//
//  UserData.m
//  CitSciMobile
//
//  Created by lee casuto on 12/5/12.
//  Copyright (c) 2012 lee casuto. All rights reserved.
//

#import "UserData.h"
#import "Authenticate.h"
#import "../AppDelegate.h"
#import "../Model/Model.h"
#import "../Utilities/ToastAlert.h"

@interface UserData ()

@end


@implementation UserData

@synthesize theName;
@synthesize thePass;
@synthesize SelectedServer;
@synthesize SelectedServerLandscape;
@synthesize SelectedUserName;
@synthesize SelectedUserNameLandscape;
@synthesize PassInput;
@synthesize NameInput;
@synthesize PassInputLandscape;
@synthesize NameInputLandscape;
@synthesize VisitToDelete;
@synthesize GoneVisits;
@synthesize UploadAllErrors;
@synthesize Yikes;
@synthesize BottomYikes;

static Boolean ServerSet=false;
static Boolean OptionsUserSet=false;
static Boolean OptionsPasswordSet=false;

Boolean UserDataDebug = false;
int theServer;

//
// get a pointer to all options
//
Model *TheOptions;

UIViewController *ModalView;

//
// declaration for spinner
//
UIActivityIndicatorView *TheActivity;

//
// declaration for server name
//
static NSString *SelectedServerName;
static Boolean UDKeepGoing = false;
static Boolean UDUploadAll = false;
static Boolean ShowSaved   = false;



#pragma mark -
#pragma - utility methods
-(void)Dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //NSLog(@"access token : %@",[TheOptions GetAccessToken]);
    //NSLog(@"expires      : %@",[TheOptions GetExpires]);
    //NSLog(@"refresh token: %@",[TheOptions GetRefreshToken]);
}

- (void)CancelBusyWait:(NSTimer*) timer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"parsecomplete" object:self];
}

-(void)FinishUpload
{
    if(!UDKeepGoing)
    {
        // verify the number of uploads matches the number of results
        if([self.UploadAllErrors count] != [self.GoneVisits count])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile Observations"
                                                            message:@"Internal error: contact lkc@leewaysd.com (100)"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            for(int i=0; i < [self.GoneVisits count]; i++)
            {
                NSString *foo = [[NSString alloc]initWithFormat:@"%@", [self.UploadAllErrors objectAtIndex:i]];
                if([foo isEqualToString:@"success"])
                {
                    // upload was successful delete the visit
                    VisitToDelete = [[NSString alloc]initWithFormat:@"%@",[self.GoneVisits objectAtIndex:i]];
                    [TheOptions RemVisitFile:VisitToDelete];
                }
            }
        }
        
        AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate displayView:USERDATA];
    }
}

-(void)DoTheSlow
{
    //
    // is the server accessible
    //
    Reachability *reachability      = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus    = [reachability currentReachabilityStatus];
    
    if (internetStatus != NotReachable)
    {
        [TheOptions GetProjectsAndForms];
        
        // wait here for getprojectsandforms
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CheckGetServerData) name:@"getprojectsandforms" object:nil];
    }
    else
    {
        //there-is-a-no-connection warning
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"The server is not reachable"
                                                       delegate:nil cancelButtonTitle:@"OK"
       
                                              otherButtonTitles: nil];
        [alert show];

    }
}

-(void)CheckGetServerData
{
    Boolean ServerResults = [TheOptions GetBadNetworkConection];
    
    if(ServerResults)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"Unable to access project data from the server"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [TheOptions SetProjectDataAvailable:NO];
    }
    else
    {
        // examine the contrived project and form data
        [TheOptions SetProjectDataAvailable:YES];
        
        //
        // copy the user's option's file to the Documents
        // directory
        //
        [TheOptions ChangeUser];
    }
}

#pragma mark - buttons
//--------------------------//
// AuthenticateButton       //
//--------------------------//
// Cancel any changes without saving
-(IBAction)AuthenticateButton:(int)intNewView
{
    [TheOptions SetMinCheckCalled:false];
    [TheOptions SetCheckAppRevisionRunning:true];
    Boolean LegalRevision = [TheOptions AppRevisionGood];
    
    while([TheOptions GetCheckAppRevisionRunning])
    {
        // wait for AppRevisionGood to complete
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, .05, false);
    }
    
    if([TheOptions GetBadNetworkConection])
    {
        // message already displayed nad we can't do anything so return
        return;
    }
    
    // we came back without a timeout so check the status
    if (!LegalRevision)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"The version of CitSciMobile and the server are incompatible.  You must update your app to interact with the CitSci server."
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        ShowSaved                 = true;
        AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate displayView:AUTHENTICATEVIEW];
    }
}

//--------------------------//
// CancelButton             //
//--------------------------//
// Cancel any changes without saving
-(IBAction)CancelButton:(int)intNewView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                    message:@"Your changes will not be saved"
                                                   delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    
    ServerSet=false;
    OptionsUserSet=false;
    OptionsPasswordSet=false;
}

//--------------------------//
// GetProjects              //
//--------------------------//
// Get the project data from the server
-(void)GetProjects
{
    [TheOptions SetMinCheckCalled:false];
    [TheOptions SetCheckAppRevisionRunning:true];
    Boolean LegalRevision = [TheOptions AppRevisionGood];
    
    while([TheOptions GetCheckAppRevisionRunning])
    {
        // wait for AppRevisionGood to complete
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, .05, false);
    }
    
    if([TheOptions GetBadNetworkConection])
    {
        // message already displayed nad we can't do anything so return
        return;
    }
    
    // we came back without a timeout so check the status
    if (!LegalRevision)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"The version of CitSciMobile and the server are incompatible.  You must update your app to interact with the CitSci server."
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        // start activity monitor
        TheActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [TheActivity setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)]; // in landscape mode
        [self.view addSubview:TheActivity]; // spinner is not visible until started
        [TheActivity startAnimating];
        
        [self performSelector:@selector(DoTheSlow) withObject:@"Timed Out" afterDelay:0.0];
    }
}

//--------------------------//
// SaveButton               //
//--------------------------//
// Save the options (user, password and server)
-(IBAction)SaveButton:(int)intNewView
{
    [TheOptions SetMinCheckCalled:false];
    [TheOptions SetCheckAppRevisionRunning:true];
    Boolean LegalRevision = [TheOptions AppRevisionGood];
    
    while([TheOptions GetCheckAppRevisionRunning])
    {
        // wait for AppRevisionGood to complete
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, .05, false);
    }
    
    if([TheOptions GetBadNetworkConection])
    {
        // message already displayed nad we can't do anything so return
        return;
    }
    
    // we came back without a timeout so check the status
    if (!LegalRevision)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"The version of CitSciMobile and the server are incompatible.  You must update your app to interact with the CitSci server."
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [TheOptions SetWriteOptionsFile:true];
        // replace the old save button
        NSTimer *theTimer = [[NSTimer alloc]init];
        [TheOptions ReadOptionsFromFile];
        ShowSaved         = false;
        
        //
        // Get the projects and forms from the server
        //
        [self GetProjects];
        
        // timeout of busy circle
        theTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(CancelBusyWait:) userInfo:nil repeats:NO];
    }
}

//--------------------------//
// SelectServerButton       //
//--------------------------//
// selects the AOI in an action sheet
- (IBAction)SelectServerButton:(int)intNewView
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Select Server Name" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"ibis-test.nrel.colostate.edu", @"ibis-live.nrel.colostate.edu", nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [popupQuery showInView:self.view];
    
}


//-----------------------//
// actionSheet           //
//-----------------------//
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ServerSet=true;
    theServer = (int)buttonIndex++;
    switch(buttonIndex)
    {
        case 1:
            self.SelectedServer.text = @"ibis-test.nrel.colostate.edu";
            self.SelectedServerLandscape.text = self.SelectedServer.text;
            SelectedServerName = [[NSString alloc]initWithFormat:@"%@",@"ibis-test.nrel.colostate.edu"];
            ////NSLog(@"SelectedServer.text = %@",SelectedServerName);
            break;
        case 2:
            self.SelectedServer.text = @"ibis-live.nrel.colostate.edu";
            self.SelectedServerLandscape.text = SelectedServer.text;
            break;
        default:
            break;
    }
}

//--------------------------//
// ObservationsButton       //
//--------------------------//
// takes the user to the Observations screen
//
-(IBAction)ObservationsButton:(int)intNewView
{
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:OBSERVATIONSVIEW];
}

//--------------------------//
// SetProjectButton         //
//--------------------------//
// takes the user to the SetProject screen
//
-(IBAction)SetProjectButton:(int)intNewView
{
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:PROJECTSTABLE];
}

//--------------------------//
// UploadButton             //
//--------------------------//
// takes the user to the Upload screen
//
-(IBAction)UploadButton:(int)intNewView
{
    UDUploadAll             = false;
    int NumFiles            = [TheOptions GetNumberOfVisitFiles];
    self.GoneVisits         = [[NSMutableArray alloc]init];
    self.UploadAllErrors    = [[NSMutableArray alloc]init];
    NSString *UploadResult  = [[NSString alloc]init];
    
    TheActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [TheActivity setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)]; // in landscape mode
    [self.view addSubview:TheActivity]; // spinner is not visible until started
    [TheActivity startAnimating];
    
    for(int i=0; i<NumFiles; i++)
    {
        UDKeepGoing         = true;
        NSString *filename  = [TheOptions GetVisitFileNameAtIndex:i];
        
        [TheOptions SetUploadRunning:true];
        [TheOptions SetUploadError:false];
        [TheOptions UploadVisit:filename];
        if([TheOptions GetUploadError] == true)
        {
            UploadResult = [[NSString alloc]initWithFormat:@"%@",@"fail"];
        }
        else
        {
            UploadResult = [[NSString alloc]initWithFormat:@"%@",@"success"];
        }
        [self.UploadAllErrors addObject:UploadResult];
        
        VisitToDelete       = [[NSString alloc]initWithString:[filename lastPathComponent]];
        [self.GoneVisits addObject:VisitToDelete];
        
        if(i == (NumFiles - 1))
        {
            UDKeepGoing     = false;
        }
        
        NSTimer *theTimer   = [[NSTimer alloc]init];
        
        theTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(FinishUpload) userInfo:nil repeats:NO];
    }
}

//--------------------------//
// SettingsButton           //
//--------------------------//
// takes the user to the Upload screen
//
-(IBAction)SettingsButton:(int)intNewView
{
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:USERDATA];
}
//--------------------------//
// end of buttons           //
//--------------------------//


#pragma mark - view lifecycle
//-----------------------//
// view life cycle       //
//-----------------------//
#pragma mark - View lifecycle
-(id)init
{
    self = [super init];
    
    //
    // set up the xib for iphone 4 or 5 correctly
    //
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //this is iphone 5 xib
        self = [self initWithNibName:@"UserData_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"UserData" bundle:nil];
    }
    
    return self;
}
/********
-(id)init
{
    self = [super init];

    // let's see if we can get an iPad view
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self initWithNibName:@"UserData" bundle:nil];
    }
    else
    {
        [self initWithNibName:@"UserData" bundle:nil];
    }
    return self;
}
**********/

- (void)viewDidLoad
{
    //
    // application specific stuff
    //
    arraySystems = [[NSMutableArray alloc] init];
    TheOptions = [Model SharedModel];
    [TheOptions  ResetSystemNames];
    
    NSString *temp=[[NSString alloc] init];
    while ( (temp=[TheOptions  GetSystemName]) != nil)
    {
        [arraySystems addObject:temp];
    }
    
    [TheOptions ReadOptionsFromFile];
    ServerSet=false;
    
    self.SelectedServer.text                    = [TheOptions GetServerName];
    self.SelectedServerLandscape.text           = self.SelectedServer.text;
    self.SelectedUserName.text                  = [TheOptions GetUserName];
    self.SelectedServerLandscape.text           = self.SelectedUserName.text;
    self.SelectedUserName.text                  = [TheOptions GetUserName];
    self.SelectedUserNameLandscape.text         = self.SelectedUserName.text;
    
    self.NameInput.text                         = [TheOptions GetUserName];
    self.NameInputLandscape.text                = self.NameInput.text;
    self.PassInput.text                         = [TheOptions GetUserPassword];
    self.PassInputLandscape.text                = self.PassInput.text;
    
    SelectedServerName                          = [[NSString alloc]init];
    SelectedServerName                          = self.SelectedServer.text;
    
    [super viewDidLoad];
}

-(void)handleNotification:(NSNotification *)pNotification
{
    Boolean Problem = [TheOptions GetBadNetworkConection];
    if(!ShowSaved)
    {
        if(!Problem) [self.view addSubview: [[ToastAlert alloc] initWithText: @"Saved"]];
        ShowSaved = true;
    }
    [TheActivity stopAnimating];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.Yikes.translucent              = NO;
    self.Yikes.barTintColor             = [UIColor blackColor];
    self.BottomYikes.translucent        = NO;
    self.BottomYikes.barTintColor       = [UIColor blackColor];
    
    //
    // add myself as an observer in order to stop the
    // activity monitor
    //
    ////NSLog(@"register for parse complete");
    ShowSaved = false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:)name:@"parsecomplete" object:nil];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        BOOL x = interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
        return (x);
        //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        return YES;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"parsecomplete" object:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
}

#pragma mark - text fields
//
// deal with the keyboard hiding text fields
// I picked this solution up off the web.  To use it:
// 1. set the kOFFSET... define to the desired height
// 2. follow the instructions here:
//// http://www.iphonedevsdk.com/forum/iphone-sdk-tutorials/32204-moving-uitextfield-when-keyboard-pops-up.html
//

#define kOFFSET_FOR_KEYBOARD 130.0

-(void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = kOFFSET_FOR_KEYBOARD; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
	if(theTextField == self.PassInput)
	{
		[self.PassInput resignFirstResponder];
	}
    
    if(theTextField == self.PassInputLandscape)
	{
		[self.PassInputLandscape resignFirstResponder];
	}
	
	if(theTextField == self.NameInput)
	{
		[self.NameInput resignFirstResponder];
	}
    
    if(theTextField == self.NameInputLandscape)
	{
		[self.NameInputLandscape resignFirstResponder];
	}
    
	return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if([sender isEqual:self.PassInput])
    {
        [self animateTextField: sender up:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)sender
{
    // move back down
    if([sender isEqual:self.PassInput])
    {
        [self animateTextField: sender up:NO];
    }
    
    // remember the Name values
    if([sender isEqual:self.NameInput])
    {
        self.NameInputLandscape.text = self.NameInput.text;
        OptionsUserSet=true;
    }
    if([sender isEqual:self.NameInputLandscape])
    {
        self.NameInput.text = self.NameInputLandscape.text;
        OptionsUserSet=true;
    }
    
    // remember the Description values
    if([sender isEqual:self.PassInput])
    {
        if([self.PassInput.text length] == 0)
        {
            self.PassInput.text=@"******";
        }
        self.PassInputLandscape.text = self.PassInput.text;
        OptionsPasswordSet=true;
    }
    if([sender isEqual:self.PassInputLandscape])
    {
        if([self.PassInputLandscape.text length] == 0)
        {
            self.PassInputLandscape.text=@"******";
        }
        self.PassInput.text = self.PassInputLandscape.text;
        OptionsPasswordSet=true;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // puts the screen back if it's touched anywhere
	[self.NameInput resignFirstResponder];
    [self.PassInput resignFirstResponder];
    [self.NameInputLandscape resignFirstResponder];
    [self.PassInputLandscape resignFirstResponder];
}

@end
