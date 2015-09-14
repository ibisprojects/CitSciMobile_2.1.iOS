//
//  FormsTableViewController.m
//  CitSciMobile
//
//  Created by lee casuto on 12/26/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import "FormsTableViewController.h"
#import "../AppDelegate.h"
#import "../Model/Model.h"
#import "../Utilities/ToastAlert.h"

@interface FormsTableViewController ()

@end

@implementation FormsTableViewController
@synthesize FormNames;
@synthesize FormIDs;
@synthesize Yikes;
@synthesize BottomYikes;


//
// get a pointer to all options
//
Model *TheOptions;

#pragma mark - buttons
//--------------------------//
// BackButton               //
//--------------------------//
// Back Button code to set the project name
-(IBAction)BackButton:(int)intNewView
{
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:PROJECTSTABLE];
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
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
    
    for(int i=0; i<[TheOptions GetNumberOfVisitFiles]; i++)
    {
        NSString *filename  = [TheOptions GetVisitFileNameAtIndex:i];
        
        [TheOptions UploadVisit:filename];
        filename            = [filename lastPathComponent];
        
        if(![TheOptions GetUploadError])
        {
            [TheOptions RemVisitFile:filename];
        }
        
        /*****
        if([TheOptions GetGoToAuthenticate])
        {
            [appDelegate displayView:AUTHENTICATEVIEW];
        }
        ******/
    }
    
	[appDelegate displayView:PROJECTSTABLE];
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.FormNames count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    // declarations for the method
    //
    int SelectedForm            = (int)indexPath.row;
    
    /*******
    for(int i = 0; i < [FormNames count]; i++)
    {
        NSLog(@"form name[%d]=%@",i,[FormNames objectAtIndex:i]);
    }
    **********/
    
    switch(SelectedForm)
    {
        default:
            [TheOptions ReadOptionsFromFile];
            [TheOptions SetCurrentFormName:[self.FormNames objectAtIndex:SelectedForm]];
            [TheOptions SetCurrentFormID:[self.FormIDs objectAtIndex:SelectedForm]];
             
            [TheOptions WriteOptionsToFile];
            [TheOptions ReadOptionsFromFile];
            
            [self.view addSubview: [[ToastAlert alloc] initWithText: @"Saved"]];
            
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (cell == nil)
	{
        cell                    = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType      = UITableViewCellAccessoryNone;
		cell.selectionStyle     = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.text         = [self.FormNames objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Select The Data Sheet";
}

#pragma - mark lifecycle
-(void)handleNotification:(NSNotification *)pNotification
{
    ////NSLog(@"done parsing!");
    ////[TheActivity stopAnimating];
}

-(id)init
{
    self = [super init];
    
    //
    // set up the xib for iphone 4 or 5 correctly
    //
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //this is iphone 5 xib
        self = [self initWithNibName:@"FormsTableViewController_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"FormsTableViewController" bundle:nil];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Set Project", @"Set Project");
        self.tabBarItem.image = [UIImage imageNamed:@"projects"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.Yikes.translucent          = NO;
    self.Yikes.barTintColor         = [UIColor blackColor];
    self.BottomYikes.translucent    = NO;
    self.BottomYikes.barTintColor   = [UIColor blackColor];
    
    [TheOptions ReadOptionsFromFile];
        
    [TheOptions SetFormNames];
    
    self.FormNames                  = [TheOptions GetFormNames];
    self.FormIDs                    = [TheOptions GetFormIDs];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view from its nib.
    //
    // application specific stuff
    //
    TheOptions = [Model SharedModel];
    
    [TheOptions ReadOptionsFromFile];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
