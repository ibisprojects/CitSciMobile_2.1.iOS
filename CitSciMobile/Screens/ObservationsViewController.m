//
//  ObservationsViewController.m
//  CitSciMobile
//
//  Created by lee casuto on 1/9/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import "ObservationsViewController.h"
#import "AddObservation.h"
#import "AddObservationSelect.h"
#import "Information.h"
#import "../Model/Model.h"
#import "../AppDelegate.h"
#import "../Utilities/MyTableCell.h"

#define LABEL_TAG 1
#define VALUE_TAG 2

@interface ObservationsViewController ()

@end

@implementation ObservationsViewController

@synthesize VisitsTable;
@synthesize ProjectNamePortrait;
@synthesize FormNamePortrait;
@synthesize UserNamePortrait;
@synthesize ServerNamePortrait;
@synthesize VisitToDelete;
@synthesize GoneVisits;
@synthesize UploadAllErrors;
@synthesize Yikes;
@synthesize BottomYikes;

Boolean CollectedVisitsDebug=false;
static int MyNumberOfVisits;

//
// get a pointer to all options
//
Model *TheOptions;

//
// declaration for spinner
//
UIActivityIndicatorView *TheActivity;

Boolean IsAcquired;
int SelectedRow=-1;
static Boolean OBSUploadALL = false;
static int CurrentVisitIndex;

#pragma -
#pragma mark - utility methods
//
// utility routines
//
-(void)UploadThisVisit:(int)TheIndex
{
    NSTimer *theTimer   = [[NSTimer alloc]init];
    NSString *filename  = [[NSString alloc]initWithFormat:@"%@",[self.GoneVisits objectAtIndex:TheIndex]];
    
    TheActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [TheActivity setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)]; // in landscape mode
    [self.view addSubview:TheActivity]; // spinner is not visible until started
    [TheActivity startAnimating];
    
    ////NSLog(@"Entered upload visit uploading=%@",filename);
    [TheOptions UploadVisit:filename];
    
    // wait for UploadCleanup to get called
    theTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(FinishUpload) userInfo:nil repeats:NO];
}

-(void)UploadCleanup
{
    ////NSLog(@"Uplaodcleanup called");
    NSString *filename  = [[NSString alloc]initWithFormat:@"%@",[self.GoneVisits objectAtIndex:CurrentVisitIndex]];
    
    if([TheOptions GetUploadError] == true)
    {
        //NSLog(@"do not delete %@",filename);
    }
    else
    {
        // do the next file
        CurrentVisitIndex++;
        
        if(CurrentVisitIndex < MyNumberOfVisits)
        {
            [self UploadThisVisit:CurrentVisitIndex];
        }
        
        //NSLog(@"remove the file: %@",[filename lastPathComponent]);
        [TheOptions RemVisitFile:[filename lastPathComponent]];
    }
    
    ////[TheActivity stopAnimating];
    if(CurrentVisitIndex >= MyNumberOfVisits)
    {
        AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate displayView:OBSERVATIONSVIEW];
    }
}

-(void)FinishUpload
{
    //
    // this is a place to sleep while waiting for
    // the first upload in uploadall to complete
    // it does nothing
    //
    ////NSLog(@"finishupload");
    ////[TheActivity stopAnimating];
    /*******/
    if([TheOptions GetGoToAuthenticate])
    {
        AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate displayView:AUTHENTICATEVIEW];
    }
    /**********/
}

-(void)DoTheSlow
{
    int  TheView    = -1;
    IsAcquired      = false;
    
    IsAcquired = [TheOptions GetAcquired];
    if(IsAcquired)
    {
        TheView = ADDOBSERVATION;
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile Observations"
                                                        message:@"The location was not acquired.  Please try again with a longer timeout"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        TheView = OBSERVATIONSVIEW;
        //TheView = ADDOBSERVATION;
    }
    
    [TheActivity startAnimating];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate displayView:TheView];
}

#pragma mark - buttons
//
// methods created for this particular implementation
//
//--------------------------//
// AddButton                //
//--------------------------//
// Add Button code to allow the user to add a new
// observation of species
//
-(IBAction)AddButton:(int)intNewView
{
    Boolean SetUpComplete   = true;
    
    if(([self.ProjectNamePortrait.text isEqualToString:NOTYETSET]) ||
       ([self.FormNamePortrait.text isEqualToString:NOTYETSET]))
    {
        SetUpComplete = false;
    }
    
    if(!SetUpComplete)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"You must set both the project and data sheet to record observations"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        Boolean  PredefinedLocations = [TheOptions ParsePredefinedLocations];
        [TheOptions SetPredefinedLocationMode:PredefinedLocations];
        
        [TheOptions InitializeAttributes];
        [TheOptions RemoveOrganismComments];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        if(PredefinedLocations)
        {
            ////NSLog(@"predefined locations: %@",[TheOptions GetPredefinedLocationNames]);
            [appDelegate displayView:ADDPREDEFINEDOBSERVATION];
        }
        else
        {
            [appDelegate displayView:ADDOBSERVATION];
        }
    }
}

//--------------------------//
// InformationButton        //
//--------------------------//
// takes the user to the information screen
//
-(IBAction)InformationButton:(int)intNewView
{    
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate displayView:INFORMATION];
}

//--------------------------//
// DeleteButton             //
//--------------------------//
-(IBAction)DeleteButton:(int)intNewView
{
    if (SelectedRow == -1)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"You must select an Observation"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
		[alert show];
	}
    else
    {
        //
        // remove the Observation file
        // first get the associated directory name, then
        // remove the AOI file followed by the pictures directory
        //
        NSString *filename  = [TheOptions GetVisitFileNameAtIndex:SelectedRow];
        filename            = [filename lastPathComponent];
        [TheOptions RemVisitFile:filename];
        
        if(intNewView != -99)
        {
            AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate displayView:OBSERVATIONSVIEW];
        }
    }
}

//--------------------------//
// EditButton               //
//--------------------------//
//
// Edit is based on the previous mode.  We need to set up
// the collection to use the collected data from the
// selected file.  Go through the screens in previous mode
// and edit the data values.  The steps are defined below.
// Note that the "Done" screens need to know if we're in
// edit mode and if so, return the project and form to
// their original values.  Good luck!
//
-(IBAction)EditButton:(int)intNewView
{
    if (SelectedRow == -1)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"You must select an Observation"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
		[alert show];
	}
    else
    {
        //
        // edit the Observation file
        // need to:
        // 0. check for inconsistencies (out of date observations...)
        // 1. initialize the attribute and project data structures
        // 2. save the current project and form
        // 3. parse the collected data
        // 4. set the new project and form
        // 5. set previous mode to true
        // 6. invoke AddObservation
        // 7. in the "Done" screens, return the project and form to the previous values
        //
        NSString *message   = [[NSString alloc]initWithFormat:@"%@",@""];
        NSString *filename  = [TheOptions GetVisitFileNameAtIndex:SelectedRow];
        int TheResut        = [TheOptions InconsistentEdit:filename];
        switch (TheResut)
        {
            case CONSISTENT:
                break;
            case OBSERVATIONOLD:
                break;
            case DATASHEETMISSING:
                break;
            case DATASHEETEXTRAFIELDS:
                break;
            case OBSERVATIONEXTRAFIELDS:
                break;
        }
        
        if([message length]!=0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:message
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            filename            = [filename lastPathComponent];
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"edit stub here"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
            [alert show];
        }
        
        AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate displayView:OBSERVATIONSVIEW];
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
// uploads all visits to the server
//
-(IBAction)UploadButton:(int)intNewView
{
    [TheOptions SetMinCheckCalled:false];
    Boolean LegalRevision = [TheOptions AppRevisionGood];
    
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
        OBSUploadALL            = true;
        self.GoneVisits         = [[NSMutableArray alloc]init];
        self.UploadAllErrors    = [[NSMutableArray alloc]init];
        int NumFiles            = [TheOptions GetNumberOfVisitFiles];
        MyNumberOfVisits        = NumFiles;
        
        //
        // get all of the visit names
        //
        for(int i=0; i<NumFiles; i++)
        {
            NSString *filename  = [TheOptions GetVisitFileNameAtIndex:i];
            [self.GoneVisits addObject:filename];
        }
        
        CurrentVisitIndex = 0;
        if(NumFiles != 0)
        {
            [self UploadThisVisit:CurrentVisitIndex];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"There are no observations to upload"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }
}

//--------------------------//
// UploadOneButton          //
//--------------------------//
-(IBAction)UploadOneButton:(int)intNewView
{
    [TheOptions SetMinCheckCalled:false];
    Boolean LegalRevision = [TheOptions AppRevisionGood];
    
    if (!LegalRevision)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"The version of CitSciMobile and the server are incompatible.  You must update your app to interact with the CitSci server."
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else if (SelectedRow == -1)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"You must select an Observation"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
		[alert show];
	}
    else
    {
        //
        // upload the Observation file and pictures (if any)
        // first get the associated directory name, then
        //
        NSString *filename  = [TheOptions GetVisitFileNameAtIndex:SelectedRow];
        self.GoneVisits     = [[NSMutableArray alloc]init];
        MyNumberOfVisits    = -1;       // only upload 1
        
        [TheOptions SetUploadRunning:true];
        [TheOptions SetUploadError:false];
        [self.GoneVisits addObject:filename];
        CurrentVisitIndex   = 0;
        [TheOptions UploadVisit:filename];
        
        TheActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [TheActivity setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)]; // in landscape mode
        [self.view addSubview:TheActivity]; // spinner is not visible until started
        [TheActivity startAnimating];
        
        self.VisitToDelete  = [[NSString alloc]initWithString:[filename lastPathComponent]];
        
        ////NSTimer *theTimer   = [[NSTimer alloc]init];
        
        ////theTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(FinishUpload) userInfo:nil repeats:NO];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FinishUpload) name:@"NSURLConnectionDidFinish" object:nil];
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
///////////////////////////
// end of buttons        //
///////////////////////////

//
// table functions
//
//--------------------------//
// cellForRowAtIndexPath    //
//--------------------------//
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString    *MyIdentifier   = [NSString stringWithFormat:@"MyIdentifier %li", (long)indexPath.row];
    UITableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    NSString    *str            = [[NSString alloc]init];
    
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MyIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        str=[TheOptions GetVisitName];
        cell.textLabel.text = str;
        [TheOptions GetNextVisitNode];        
    }
    
    return cell;
    
}

//--------------------------//
// titleForHeaderInSection  //
//--------------------------//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"         Observation Name";
}

//--------------------------//
// didSelectRowAtIndexPath  //
//--------------------------//

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // open a alert with an OK and cancel button
    ///NSString *alertString = [NSString stringWithFormat:@"Clicked on row #%d", [indexPath row]];
    SelectedRow = (int)[indexPath row];
    ////UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    ////[alert show];
}

//-------------------------------//
// numberOfSectionsInTableView   //
//-------------------------------//
// collection of functions to set up the view of the table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//--------------------------//
// numberOfRowsInSection    //
//--------------------------//
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [TheOptions GetNumberOfVisits];
}

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
        self = [self initWithNibName:@"ObservationsViewController_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"ObservationsViewController" bundle:nil];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // application specific stuff
    //
    TheOptions = [Model SharedModel];
    
    // make the table scroll
    self.VisitsTable.bounces=YES;
    
    // reset the list of visits for the traverse
    [TheOptions ResetVisitsList];
    [TheOptions CleanVisits];
    
    // set up the arrays for writing the display table
    // that means read all of the AOI files and populate
    // the Names and types tables
    [TheOptions ReadAllVisitFiles];
    
    int visitcount = [TheOptions GetNumberOfVisits];
    
    // set up the default values from the options file
    [TheOptions ReadOptionsFromFile];
    if(CollectedVisitsDebug) NSLog(@"CollectedViews: Servername = %@",[TheOptions GetServerName]);
    
    if(!([TheOptions GetPreviousMode]))
    {
        [TheOptions SetCurrentProjectName:@""];
    }
    
    self.ProjectNamePortrait.text = [TheOptions GetCurrentProjectName];
    
    self.FormNamePortrait.text    = [TheOptions GetCurrentFormName];
    
    self.UserNamePortrait.text    = [TheOptions GetUserName];
    
    self.ServerNamePortrait.text  = [TheOptions GetServerName];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = visitcount;
    
    //
    // set up to wait for url connection
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UploadCleanup)
                                                 name:@"NSURLConnectionDidFinish"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.Yikes.translucent              = NO;
    self.Yikes.barTintColor             = [UIColor blackColor];
    self.BottomYikes.translucent        = NO;
    self.BottomYikes.barTintColor       = [UIColor blackColor];
    
    // set up the default values from the options file
    [TheOptions ReadOptionsFromFile];
    if(CollectedVisitsDebug) NSLog(@"CollectedViews: Servername = %@",[TheOptions GetServerName]);
    
    self.ProjectNamePortrait.text = [TheOptions GetCurrentProjectName];
    
    self.FormNamePortrait.text    = [TheOptions GetCurrentFormName];
    
    self.ServerNamePortrait.text  = [TheOptions GetServerName];
    
    self.UserNamePortrait.text    = [TheOptions GetUserName];
    
    SelectedRow              = -1;
    
    [self.VisitsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.VisitsTable reloadData];
    });
    
    //
    // if there's no xml file for the visits table
    // and there is a pictures directory with that
    // name, then it's there by error so get rid of
    // it
    //
    int numvisits = [TheOptions GetNumberOfVisitFiles];
    
    //
    // get the name of each directory in the user's
    // MyVisits directory - these will be picture
    // directories
    //
    NSString *picpath       = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetPicturePath]];
    NSError *error;
    NSArray *dir            = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:picpath error:&error];
    
    for(int j=0; j<[dir count]; j++)
    {
        Boolean DirOK = false;
        NSString *foo = [[NSString alloc]initWithFormat:@"%@",[dir objectAtIndex:j]];
        NSString *visitpicdir   = [[NSString alloc]initWithFormat:@"%@/%@",picpath,foo];
        for(int i=0; i<numvisits; i++)
        {
            BOOL IsDir;
            if([[NSFileManager defaultManager]fileExistsAtPath:visitpicdir isDirectory:&IsDir])
            {
                NSString *lastpathcomponent = [visitpicdir lastPathComponent];
                lastpathcomponent   = [lastpathcomponent lowercaseString];
                NSString *extension = [lastpathcomponent pathExtension];
                if([extension isEqualToString:@"xml"])
                {
                    lastpathcomponent   = [lastpathcomponent stringByDeletingPathExtension];
                }
                NSString *visitname = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetVisitNameAtIndex:i]];
                
                if([lastpathcomponent isEqualToString:visitname])
                {
                    DirOK = true;
                }
            }
        }
        
        if(!DirOK)
        {
            [[NSFileManager defaultManager]removeItemAtPath:visitpicdir error:nil];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
