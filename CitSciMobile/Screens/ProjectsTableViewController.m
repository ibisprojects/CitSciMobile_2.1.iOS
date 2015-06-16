//
//  ProjectsTableViewController.m
//  CitSciMobile
//
//  Created by lee casuto on 12/25/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import "ProjectsTableViewController.h"
#import "../AppDelegate.h"
#import "../Model/Model.h"
#import "../Utilities/ToastAlert.h"

@interface ProjectsTableViewController ()

@end

@implementation ProjectsTableViewController
@synthesize ProjectIDs;
@synthesize ProjectNames;
@synthesize VisitToDelete;
@synthesize GoneVisits;
@synthesize UploadAllErrors;

//
// get a pointer to all options
//
Model *TheOptions;

//
// declaration for spinner
//
UIActivityIndicatorView *TheActivity;

static Boolean PTKeepGoing = false;
static Boolean PTUploadAll = false;

-(void)FinishUpload
{
    if(!PTKeepGoing)
    {
        // verify the number of uploads matches the number of results
        if([self.UploadAllErrors count] != [self.GoneVisits count])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile Observations"
                                                            message:@"Internal error: contact lkc@leewaysd.com (102)"
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
        [appDelegate displayView:PROJECTSTABLE];
    }
}

#pragma mark - buttons
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
    PTUploadAll             = false;
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
        PTKeepGoing         = true;
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
            PTKeepGoing     = false;
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ProjectNames count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    // declarations for the method
    //
    int SelectedProject         = (int) indexPath.row;
    AppDelegate  *appDelegate   = [[UIApplication sharedApplication] delegate];
    
    switch(SelectedProject)
    {
        default:
            [TheOptions ReadOptionsFromFile];
            
            [TheOptions SetCurrentProjectName:[self.ProjectNames objectAtIndex:SelectedProject]];
            [TheOptions SetCurrentProjectID:[self.ProjectIDs objectAtIndex:SelectedProject]];
            
            NSString *temp            = [[NSString alloc]initWithFormat:@"%@",NOTYETSET];
            NSString *t2              = [[NSString alloc]initWithFormat:@"%@",NOTYETSET];
            
            [TheOptions SetCurrentFormName:temp];
            [TheOptions SetCurrentFormID:t2];
            
            [TheOptions WriteOptionsToFile];
            [appDelegate displayView:FORMSTABLE];
            
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
		cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle     = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.text         = [self.ProjectNames objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Select The Project";
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
        self = [self initWithNibName:@"ProjectsTableViewController_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"ProjectsTableViewController" bundle:nil];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:)name:@"parsecomplete" object:nil];
    
    [TheOptions ReadOptionsFromFile];
    
    //
    // check that the xml for projects is there and accurate
    // if the XML file is not on the phone, tell the user to go get it
    //
    if(![TheOptions DoesXMLExist])
    {
        // the XML doesn't exist
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"You have not downloaded your project data from the server.\nUse the Settings button to get your project data."
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
        [self.ProjectNames removeAllObjects];
        [self.ProjectIDs removeAllObjects];
    }
    else
    {
        // the XML is on the system so parse it
        // and populate the arrays
        //
        // parse the project XML file to set the project and forms
        // data structure.  We know the XMLFile is there
        //
        
        [TheOptions ParseXMLProject:[TheOptions GetXMLPath]];
        
        [TheOptions SetProjectNames];
        self.ProjectNames   = [TheOptions GetProjectNames];
        self.ProjectIDs     = [TheOptions GetProjectIDs];
        NSString *temp      = [[NSString alloc]initWithFormat:@"%@",[self.ProjectNames objectAtIndex:0]];
        NSString *t2        = [[NSString alloc]initWithFormat:@"%@",[self.ProjectIDs objectAtIndex:0]];
        [TheOptions SetCurrentProjectName:temp];
        [TheOptions SetCurrentProjectID:t2];
        
        [TheOptions SetFormNames];
    }
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
