//
//  ViewController.m
//  CitSciMobile
//
//  Created by lee casuto on 3/10/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Screens/ObservationsViewController.h"
#import "Screens/AddObservation.h"
#import "Screens/AddObservationSelect.h"
#import "Screens/AddObservationSelectDone.h"
#import "Screens/AddObservationEnter.h"
#import "Screens/AddObservationEnterDone.h"
#import "Screens/AddAuthority.h"
#import "Screens/Information.h"
#import "Screens/UploadViewController.h"
#import "Screens/UserData.h"
#import "Screens/Camera.h"
#import "Screens/Help.h"
#import "Screens/AboutUs.h"
#import "Screens/Developers.h"
#import "Screens/ProjectsTableViewController.h"
#import "Screens/FormsTableViewController.h"
#import "Screens/Authenticate.h"
#import "Screens/AddPredefinedObservation.h"
#import "Screens/AddObservationDate.h"
#import "Screens/AddObservationDateDone.h"
#import "Screens/AddObservationString.h"
#import "Screens/AddObservationStringDone.h"
#import "Screens/PicklistView.h"
#import "Screens/Bioblitz.h"
#import "Model/Model.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize currentView;

//
// get a pointer to all options
//
Model *TheOptions;


-(void)displayView:(int)intNewView
{
    [self.currentView removeFromParentViewController];
    [self.currentView dismissViewControllerAnimated:YES completion:nil];
    self.currentView = nil;
    
    //
    // we needto display a new view, but wait for everything to
    // complete before we continue
    //
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        // unhide views, animate if desired
        //NSLog(@"in the delay code");
    
    switch(intNewView)
    {
        case OBSERVATIONSVIEW:
            self.currentView = [[ObservationsViewController alloc] init];
            break;
            
        case ADDOBSERVATION:
            [TheOptions SetNextView:ADDOBSERVATION];
            self.currentView = [[AddObservation alloc] init];
            break;
            
        case ADDAUTHORITY:
            self.currentView = [[AddAuthority alloc] init];
            break;
            
        case ADDOBSERVATIONSELECT:
            [TheOptions SetNextView:ADDOBSERVATIONSELECT];
            self.currentView = [[AddObservationSelect alloc] init];
            break;
            
        case ADDOBSERVATIONSELECTDONE:
            [TheOptions SetNextView:ADDOBSERVATIONSELECTDONE];
            self.currentView = [[AddObservationSelectDone alloc] init];
            break;
            
        case ADDOBSERVATIONENTER:
            [TheOptions SetNextView:ADDOBSERVATIONENTER];
            self.currentView = [[AddObservationEnter alloc] init];
            break;
            
        case ADDOBSERVATIONENTERDONE:
            [TheOptions SetNextView:ADDOBSERVATIONENTERDONE];
            self.currentView = [[AddObservationEnterDone alloc] init];
            ////self.currentView = [[AddObservationEnterDone alloc]init];
            break;
            
        case INFORMATION:
            self.currentView = [[Information alloc]init];
            break;
            
        case UPLOAD:
            self.currentView = [[UploadViewController alloc]init];
            break;
            
        case USERDATA:
            self.currentView = [[UserData alloc]init];
            break;
            
        case CAMERAVIEW:
            self.currentView = [[Camera alloc]init];
            break;
            
        case HELPVIEW:
            self.currentView = [[Help alloc]init];
            break;
            
        case ABOUTUSVIEW:
            self.currentView = [[AboutUs alloc]init];
            break;
            
        case DEVELOPERSVIEW:
            self.currentView = [[Developers alloc]init];
            break;
            
        case PROJECTSTABLE:
            self.currentView = [[ProjectsTableViewController alloc]init];
            break;
            
        case FORMSTABLE:
            self.currentView = [[FormsTableViewController alloc]init];
            break;
            
        case AUTHENTICATEVIEW:
            self.currentView = [[Authenticate alloc]init];
            break;
            
        case ADDPREDEFINEDOBSERVATION:
            self.currentView = [[AddPredefinedObservation alloc] init];
            break;
            
        case ADDOBSERVATIONDATE:
            [TheOptions SetNextView:ADDOBSERVATIONDATE];
            self.currentView = [[AddObservationDate alloc] init];
            break;
            
        case ADDOBSERVATIONDATEDONE:
            [TheOptions SetNextView:ADDOBSERVATIONDATEDONE];
            self.currentView = [[AddObservationDateDone alloc] init];
            break;
            
        case ADDOBSERVATIONSTRING:
            [TheOptions SetNextView:ADDOBSERVATIONSTRING];
            self.currentView = [[AddObservationString alloc] init];
            break;
            
        case ADDOBSERVATIONSTRINGDONE:
            [TheOptions SetNextView:ADDOBSERVATIONSTRINGDONE];
            self.currentView = [[AddObservationStringDone alloc] init];
            break;
            
        case PICKLISTVIEW:
            self.currentView = [[PicklistView alloc] init];
            break;
            
        case BIOBLITZVIEW:
            self.currentView = [[Bioblitz alloc] init];
            break;
    }
    
    [self.view addSubview:currentView.view];
        
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    TheOptions = [Model SharedModel];
    [TheOptions ReadOptionsFromFile];
    NSString *FirstTime = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetFirstInvocationRev21]];
    
    ////NSString *UserName = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetUserName]];
    ////NSString *AccessToken = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetAccessToken]];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if([FirstTime isEqualToString:NOTYETSET])
    {
        [TheOptions SetMinCheckCalled:false];
        [TheOptions SetCheckAppRevisionRunning:true];
        Boolean LegalRevision   = [TheOptions AppRevisionGood];
        int GoToView            = AUTHENTICATEVIEW;
        
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
                                                            message:@"The initial invocation of this app normally presents the CitSci server login screen.  However, the version of CitSciMobile and the server are incompatible.  You must update your app to interact with the CitSci server."
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            GoToView            = OBSERVATIONSVIEW;
        }
        ////[TheOptions SetFirstInvocationRev21:NOTYETSET];
        [appDelegate displayView:GoToView];
        //[TheOptions SetFirstInvocation:NOWSET];
    }
    else
    {
        [appDelegate displayView:OBSERVATIONSVIEW];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
