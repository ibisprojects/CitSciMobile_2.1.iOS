//
//  Camera.m
//  CitSciMobile
//
//  Created by lee casuto on 5/17/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import "Camera.h"
#import "../Model/Model.h"
#import "../AppDelegate.h"
#import "../Utilities/ToastAlert.h"

#define NAMEINDEX   2

@interface Camera ()

@end

@implementation Camera

@synthesize imageView;
@synthesize LandscapeView;
@synthesize PortraitView;
@synthesize Yikes;

static int jpgcount=0;

BOOL CameraDebug=NO;

//
// get a pointer to all options
//
Model *TheOptions;

#pragma mark - utility method
-(void)InsertView
{
    int TheView = [TheOptions GetNextView];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:TheView];
}

-(UIImage *)Scrunch:(UIImage *)Original
{
    // Determine output size
    CGFloat maxSize = 1024.0f;
    CGFloat width = Original.size.width;
    CGFloat height = Original.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;
    
    // If any side exceeds the maximun size, reduce the greater side to 1200px and proportionately the other one
    if (width > maxSize || height > maxSize)
    {
        if (width > height)
        {
            newWidth = maxSize;
            newHeight = (height*maxSize)/width;
        }
        else
        {
            newHeight = maxSize;
            newWidth = (width*maxSize)/height;
        }
    }
    
    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [Original drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Set maximun compression in order to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.0f);
    UIImage *processedImage = [UIImage imageWithData:imageData];
    
    return processedImage;
}

#pragma mark - Show camera
-(IBAction)showCameraAction:(id)sender
{
    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
    //You can use isSourceTypeAvailable to check
    imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
    imagePickController.delegate=self;
    imagePickController.allowsEditing=NO;
    imagePickController.showsCameraControls=YES;
    
    // Prevent the image picker learning about orientation changes by preventing the device from reporting them.
    UIDevice *currentDevice = [UIDevice currentDevice];
    
    // The device keeps count of orientation requests.  If the count is more than one, it
    // continues detecting them and sending notifications.  So, switch them off repeatedly
    // until the count reaches zero and they are genuinely off.
    // If orientation notifications are on when the view is presented, it may slide on in
    // landscape mode even if the app is entirely portrait.
    // If other parts of the app require orientation notifications, the number "end" messages
    // sent should be counted.  An equal number of "begin" messages should be sent after the
    // image picker ends.
    while ([currentDevice isGeneratingDeviceOrientationNotifications])
    {
        [currentDevice endGeneratingDeviceOrientationNotifications];
    }
    
    //This method inherit from UIView,show imagePicker with animation
    [self presentViewController:imagePickController animated:YES completion:nil];
    
    // The UIImagePickerController switches on notifications AGAIN when it is presented,
    // so switch them off again.
    while ([currentDevice isGeneratingDeviceOrientationNotifications])
    {
        [currentDevice endGeneratingDeviceOrientationNotifications];
    }
}


#pragma mark - When Tap Done Button
-(IBAction)doneImageAction:(id)sender
{
    NSString *picpath       = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetPicturePath]];
    NSString *CurrentName   = [picpath stringByAppendingPathComponent:[TheOptions GetCurrentAttributeDataValueAtIndex:NAMEINDEX]];
    
    //NSLog(@"currentname: %@",CurrentName);
    //[TheOptions DumpAttributeDataValues];
    NSString *CurrentDir    = [[NSString alloc]initWithFormat:@"%@%@",CurrentName,JPGSDIRNAME];
    
    NSFileManager *filemgr  = [NSFileManager defaultManager];
    
    NSArray *filelist       = [filemgr contentsOfDirectoryAtPath:CurrentDir error:nil];
    
    int count = (int)[filelist count];
    
    NSString *message       = [[NSString alloc]initWithFormat:@"%d Pictures saved (so far)",count];

    [self.view addSubview: [[ToastAlert alloc] initWithText: message]];
    
    [self performSelector:@selector(InsertView)  withObject:nil afterDelay:1.1];
}

#pragma mark - Check Save Image Error
- (void)CheckedImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                           message:[error description]
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"The image has been stored in an album"
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    }
    
    [alert show];
}

#pragma mark - When Finish Shoot

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSFileManager *filemgr;
    
    UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image=originalImage;
    
    [TheOptions ReadOptionsFromFile];
    
    filemgr                 = [NSFileManager defaultManager];
    
    NSString *picpath       = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetPicturePath]];
    NSString *CurrentName   = [picpath stringByAppendingPathComponent:[TheOptions GetCurrentAttributeDataValueAtIndex:NAMEINDEX]];
    NSString *CurrentDir    = [[NSString alloc]initWithFormat:@"%@%@",CurrentName,JPGSDIRNAME];
    NSString *NameOnly      = [CurrentName lastPathComponent];
    int Mode                = [TheOptions GetCameraMode];
    
    if(Mode == CAMERAORGANISM)
    {
        NSString *organismid= [[NSString alloc]initWithFormat:@"_organism_%@_",[TheOptions GetCurrentOrganismID]];
        NameOnly            = [NameOnly stringByAppendingString:organismid];
    }
    else
    {
        NSString *foo       = @"_visit_";
        NameOnly            = [NameOnly stringByAppendingString:foo];
    }
    NSString *jpgPath       = [CurrentDir stringByAppendingFormat:@"/%@%d%@",NameOnly,jpgcount++,JPGEXTENSION];
    
    //
    // make the directory
    //
    [filemgr createDirectoryAtPath:CurrentDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    originalImage = [self Scrunch:originalImage];
    // Write a UIImage to JPEG with minimum compression (best quality)
    // The value 'image' must be a UIImage object
    // The value '1.0' represents image compression quality as value from 0.0 to 1.0
    [UIImageJPEGRepresentation(originalImage, 1.0) writeToFile:jpgPath atomically:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - When Tap Cancel

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Release object


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - life cycle
-(id)init
{
    self = [super init];
    
    //
    // set up the xib for iphone 4 or 5 correctly
    //
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //this is iphone 5 xib
        self = [self initWithNibName:@"Camera_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"Camera" bundle:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    //
    // application specific stuff
    //
    TheOptions = [Model SharedModel];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.Yikes.translucent              = NO;
    self.Yikes.barTintColor             = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

@end
