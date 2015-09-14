//
//  AddObservation.m
//  CitSciMobile
//
//  Created by lee casuto on 1/15/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import "AddObservation.h"
#import "AddObservationSelect.h"
#import "Camera.h"
#import "../Model/Model.h"
#import "../AppDelegate.h"

@interface AddObservation ()

@end

@implementation AddObservation
@synthesize ObservationNameInput;
@synthesize CommentInput;
@synthesize theName;
@synthesize theComment;
@synthesize theLat;
@synthesize theLon;
@synthesize theAcc;
@synthesize theAlt;
@synthesize LatValue;
@synthesize LonValue;
@synthesize AccValue;
@synthesize AltValue;
@synthesize Yikes;


//
// get a pointer to all options
//
Model *TheOptions;

//
// declaration for spinner
//
UIActivityIndicatorView *TheActivity;

//
// Set up the indexes to start an observation
//
static int OrganismIndex    = 0;
static int AttributeIndex   = 0;

NSString *AttributeType;
NSString *lat;
NSString *lon;
NSString *acc;
NSString *alt;

Boolean ObservationStart    = false;
Boolean DoTheSlowPointFlag  = true;
static Boolean DoCamera     = false;
Boolean AddObsDebug         = false;

#pragma -
#pragma - mark utility functions
//
// Local routine to allow the spinner to function
// properly
//
-(void)DoTheSlow
{
    if(!DoTheSlowPointFlag) return;
    
    if(![TheOptions GetAcquired])
    {
        // no location acquired
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"The location was not acquired.  Please try again."
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        ////NSLog(@"dotheslow: thelat = %@",[TheOptions GetVisitLat]);
        self.LatValue.text   = [TheOptions GetVisitLat];
        self.LonValue.text   = [TheOptions GetVisitLon];
        self.AltValue.text   = [TheOptions GetVisitAlt];
        self.AccValue.text   = [TheOptions GetVisitAcc];
    }
}

#pragma -
#pragma - mark buttons
//--------------------------//
// ContinueButton           //
//--------------------------//
// goes back to ObservationViewController loop
//
-(IBAction)ContinueButton:(int)intNewView
{
    //
    // test observation name and lat/lon before continuing
    //
    Boolean Success         = true;
    Boolean DuplicateName   = true;
    Boolean LegalName       = true;
    Boolean ValidNumber     = true;
    Boolean ValidValue      = true;
    Boolean PreviousMode    = [TheOptions GetPreviousMode];
    self.theName            = self.ObservationNameInput.text;
    self.theComment         = self.CommentInput.text;
    self.theLat             = self.LatValue.text;
    self.theLon             = self.LonValue.text;
    self.theAlt             = self.AltValue.text;
    self.theAcc             = self.AccValue.text;
    
    [TheOptions SetVisitLat:self.LatValue.text];
    [TheOptions SetVisitLon:self.LonValue.text];
    [TheOptions SetVisitAlt:self.AltValue.text];
    [TheOptions SetVisitAcc:self.AccValue.text];
    
    // check the name and post an alert if necessary
    DuplicateName = [TheOptions DoesThisNameExist:self.theName];
    LegalName     = [TheOptions IsThisNameLegal:self.theName];
    
    if(DuplicateName)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                message:@"An observation with this name already exists.  The options available are:\n1. choose a different name\n2. cancel this observation and delete the observation with this name and start over"
                                delegate:nil cancelButtonTitle:@"OK"
                                otherButtonTitles: nil];
        [alert show];
        Success = false;
    }
    
    if(!LegalName)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"The extension \".xml\" is a reserved word in CitSciMobile and specifies an illegal name.  You must choose a different name"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        Success = false;
    }
    
    if([self.theName length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"You must enter an observation name!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
		[alert show];
        Success = false;
    }
    
    if([self.theLat length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"You must specify a latitude value"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
		[alert show];
        Success = false;
    }
    
    if([self.theLon length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"You must specify a longitude value"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
		[alert show];
        Success = false;
    }

    
    ValidNumber = true;
    ValidValue  = true;
    if([self.theLat length] != 0)
    {
        ValidNumber = [TheOptions ValidFloat:self.theLat];
        if(!ValidNumber)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"Latitude value is not a number"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            Success = false;
        }
        if(ValidNumber)
        {
            ValidValue = [TheOptions ValidLat:self.theLat];
            if(!ValidValue)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:@"Latitude value must be between -90 and 90"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                Success = false;
            }
        }
    }
    
    ValidNumber = true;
    ValidValue  = true;
    if([self.theLon length] != 0)
    {
        ValidNumber = [TheOptions ValidFloat:self.theLon];
        if(!ValidNumber)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"Longitude value is not a number"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            Success = false;
        }
        if(ValidNumber)
        {
            ValidValue = [TheOptions ValidLon:self.theLon];
            if(!ValidValue)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:@"Longitude value must be between -180 and 180"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                Success = false;
            }
        }
    }
    
    ValidNumber = true;
    ValidValue  = true;
    if([self.theAlt length] != 0)
    {
        ValidNumber = [TheOptions ValidFloat:self.theAlt];
        if(!ValidNumber)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"Altitude value is not a number"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            Success = false;
        }
    }
    
    ValidNumber = true;
    ValidValue  = true;
    if([self.theAcc length] != 0)
    {
        ValidNumber = [TheOptions ValidFloat:self.theAcc];
        if(!ValidNumber)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"Accuracy value is not a number"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            Success = false;
        }
    }
    
    if(Success)
    {
        AddObsDebug = false;
        if(AddObsDebug) NSLog(@"==== addobservation continue");
        if(AddObsDebug) [TheOptions DumpAttributeDataValues];
        AddObsDebug = false;
        //
        // save date, name and lat/lon
        //
        if(!([TheOptions GetPreviousMode]))
        {
            [TheOptions InitializeAttributes];
        }
        
    
        [TheOptions SetSiteCharacteristicsCount:0];

        [TheOptions SetCollectionType:COLLECTORGANISM];
        
        //
        // date variables
        //
        NSDate *TheDate                 = [NSDate date];
        NSDateFormatter *DateFormatter  = [[NSDateFormatter alloc]init];
        [DateFormatter setDateFormat:@"yyyyMMdd"];
        [DateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString *MyDate                = [DateFormatter stringFromDate:TheDate];
        [DateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
        NSString *ObservationDate       = [DateFormatter stringFromDate:TheDate];
        [TheOptions SetDateValue:TheDate];
        
        //
        // reset or set the attribute values
        //
        if(PreviousMode)
        {
            [TheOptions ReplaceAttributeDataValueAtIndex:MYDATE :MyDate];
            [TheOptions ReplaceAttributeDataValueAtIndex:OBSDATE :ObservationDate];
            [TheOptions ReplaceAttributeDataValueAtIndex:OBSNAME :self.theName];
            [TheOptions ReplaceAttributeDataValueAtIndex:OBSCOMMENT :self.theComment];
            [TheOptions ReplaceAttributeDataValueAtIndex:LATVALUE :self.LatValue.text];
            [TheOptions ReplaceAttributeDataValueAtIndex:LONVALUE :self.LonValue.text];
            [TheOptions ReplaceAttributeDataValueAtIndex:ALTVALUE :self.AltValue.text];
            [TheOptions ReplaceAttributeDataValueAtIndex:ACCVALUE :self.AccValue.text];
        }
        else
        {
            [TheOptions ClearCurrentAttributeDataValues];
            [TheOptions SetCurrentAttributeDataValue:MyDate];
            [TheOptions SetCurrentAttributeDataValue:ObservationDate];
            [TheOptions SetCurrentAttributeDataValue:self.theName];
            [TheOptions SetCurrentAttributeDataValue:self.theComment];
            [TheOptions SetCurrentAttributeDataValue:self.LatValue.text];
            [TheOptions SetCurrentAttributeDataValue:self.LonValue.text];
            [TheOptions SetCurrentAttributeDataValue:self.AltValue.text];
            [TheOptions SetCurrentAttributeDataValue:self.AccValue.text];
        }
        
        ////[TheOptions DumpAttributeDataValues];
        
        //
        // set up for next view
        //
        [TheOptions SetNextAttribute];
        double delayInSeconds = 0.2;
        if([TheOptions GetAuthorityCount]>0)
        {
            // we have an authority specified so set up to collect it
            // next.  SetNextView is picked up by Camera to to the
            // correct view
            [TheOptions SetNextView:ADDAUTHORITY];
            if(DoCamera)
            {
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                {
                    DoCamera = false;
                    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                    [appDelegate displayView:CAMERAVIEW];
                });
            }
            else
            {
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                {
                    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                    [appDelegate displayView:ADDAUTHORITY];
                });
            }
        }
        else
        {
            // there is no authority specified so just start collecting
            // the attributes
            /*************************************/
            ObservationStart=false;
            if(ObservationStart)
            {
                NSLog(@"Addobservation just called SetNextAttribute");
                [TheOptions ShowIndexes];
            }
            ObservationStart=false;
            
            Boolean Done            = [TheOptions GetIsLast];
            NSString *SelectType    = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeType]];
            NSString *Modifier      = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeTypeModifier]];
            SelectType              = [SelectType lowercaseString];
            Modifier                = [Modifier lowercaseString];
            Boolean Error           = false;
            int TheNextView         = 0;
            
            if([SelectType isEqualToString:@"entered"])
            {
                if(Done)
                {
                    if([Modifier isEqualToString:@"date"])
                    {
                        TheNextView = ADDOBSERVATIONDATEDONE;
                    }
                    else if([Modifier isEqualToString:@"string"])
                    {
                        TheNextView = ADDOBSERVATIONSTRINGDONE;
                    }
                    else
                    {
                        TheNextView = ADDOBSERVATIONENTERDONE;
                    }
                }
                else
                {
                    if([Modifier isEqualToString:@"date"])
                    {
                        TheNextView = ADDOBSERVATIONDATE;
                    }
                    else if([Modifier isEqualToString:@"string"])
                    {
                        TheNextView = ADDOBSERVATIONSTRING;
                    }
                    else
                    {
                        TheNextView = ADDOBSERVATIONENTER;
                    }
                }
            }
            else if([SelectType isEqualToString:@"select"])
            {
                if(Done)
                {
                    TheNextView = ADDOBSERVATIONSELECTDONE;
                }
                else
                {
                    TheNextView = ADDOBSERVATIONSELECT;
                }
            }
            else
            {
                Error = true;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:@"Illegal data sheet; no observation is possible"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                
                AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
                [appDelegate displayView:OBSERVATIONSVIEW];
            }
            
            if(!Error)
            {
                // SetNextView is picked up by the Camera to go to the
                // correct next view.
                [TheOptions SetNextView:TheNextView];
                if(DoCamera)
                {
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                    {
                        DoCamera = false;
                        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                        [appDelegate displayView:CAMERAVIEW];
                    });
                }
                else
                {
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                    {
                        AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
                        [appDelegate displayView:TheNextView];
                    });
                }
            }
            /********************************/
        }
    }
}

//--------------------------//
// CGPSButton               //
//--------------------------//
// captures the lat/lon and sets it for the current
// observation
//
-(IBAction)GPSButton:(int)intNewView
{
    //
    // calibrate the GPS here
    //
    // GPS calibration - always required for add point
    // fire up the notification center
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoTheSlow) name:@"pointfound" object:nil];
    [TheOptions SetAcquired:NO];
    
    // Fire up the location service
    [TheOptions SetupLocationManager];
    [TheOptions SetBestEffort:NO];
    
    // start activity monitor
    TheActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [TheActivity setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)]; // in landscape mode
    [self.view addSubview:TheActivity]; // spinner is not visible until started
    [TheActivity startAnimating];
}

//--------------------------//
// CancelButton             //
//--------------------------//
// captures the lat/lon and sets it for the current
// observation
//
-(IBAction)CancelButton:(int)intNewView
{
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:OBSERVATIONSVIEW];
}

//--------------------------//
// CameraButton             //
//--------------------------//
// Back Button code to get to
// the main view  Thecamera button is the same
// as the continue button except it sets the next
// view, calls the camera which continues to the
// proper view
-(IBAction)CameraButton:(int)intNewView
{
    [TheOptions SetCameraMode:CAMERAOBSERVATION];
    DoCamera = true;
    [self ContinueButton:1];
}
///////////////////////////
// end of buttons        //
///////////////////////////


#pragma -
#pragma - mark lifecycle
-(id)init
{
    self = [super init];
    
    //
    // application specific stuff
    //
    TheOptions = [Model SharedModel];
    
    //
    // set up the xib for iphone 4 or 5 correctly
    //
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //this is iphone 5 xib
        self = [self initWithNibName:@"AddObservation_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"AddObservation" bundle:nil];
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
    // Do any additional setup after loading the view from its nib.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.Yikes.translucent  = NO;
    self.Yikes.barTintColor = [UIColor blackColor];
    
    OrganismIndex   = [TheOptions GetCurrentOrganismIndex];
    AttributeIndex  = [TheOptions GetCurrentAttributeChoiceIndex];
    
    AddObsDebug = false;
    if(AddObsDebug) NSLog(@"==== addobservation viewwillappear");
    if(AddObsDebug) [TheOptions DumpAttributeDataValues];
    AddObsDebug = false;
    
    if(ObservationStart)
    {
        NSLog(@"========= ADDOBSERVATION ========");
        NSLog(@"OrganismIndex        = %d",OrganismIndex);
        NSLog(@"AttributeIndex       = %d",AttributeIndex);
    }
    
    if([TheOptions GetPreviousMode])
    {
        self.ObservationNameInput.text   = [TheOptions GetCurrentAttributeDataValueAtIndex:OBSNAME];
        self.CommentInput.text           = [TheOptions GetCurrentAttributeDataValueAtIndex:OBSCOMMENT];
        self.LatValue.text               = [TheOptions GetCurrentAttributeDataValueAtIndex:LATVALUE];
        self.LonValue.text               = [TheOptions GetCurrentAttributeDataValueAtIndex:LONVALUE];
        self.AltValue.text               = [TheOptions GetCurrentAttributeDataValueAtIndex:ALTVALUE];
        self.AccValue.text               = [TheOptions GetCurrentAttributeDataValueAtIndex:ACCVALUE];
    }
    
    ////[TheOptions SetCurrentAttributeDataValue:[TheOptions GetVisitLat]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma -
#pragma - mark keyboard
//
// Text field functions
//
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
	if(theTextField == self.ObservationNameInput)
	{
		[self.ObservationNameInput resignFirstResponder];
	}
    
    if(theTextField == self.CommentInput)
	{
		[self.CommentInput resignFirstResponder];
	}
    
    if(theTextField == self.LatValue)
	{
		[self.LatValue resignFirstResponder];
	}
    
    if(theTextField == self.LonValue)
	{
		[self.LonValue resignFirstResponder];
	}
    
    if(theTextField == self.AccValue)
	{
		[self.AccValue resignFirstResponder];
	}
    
    if(theTextField == self.AltValue)
	{
		[self.AltValue resignFirstResponder];
	}
    
	return YES;
}

//
// deal with the keyboard hiding text fields
// I picked this solution up off the web.  To use it:
// 1. set the kOFFSET... define to the desired height
// 2. follow the instructions here:
//// http://www.iphonedevsdk.com/forum/iphone-sdk-tutorials/32204-moving-uitextfield-when-keyboard-pops-up.html
//
#define kOFFSET_FOR_KEYBOARD 0.0             // not needed, but ready if it becomes required
int movementDistance = kOFFSET_FOR_KEYBOARD; // tweak as needed
-(void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    //const int movementDistance = kOFFSET_FOR_KEYBOARD; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.ObservationNameInput])
    {
        movementDistance = 0.0;
        [self animateTextField: sender up:YES];
    }
    
    if ([sender isEqual:self.CommentInput])
    {
        movementDistance = 0.0;
        [self animateTextField: sender up:YES];
    }
    
    if ([sender isEqual:self.LatValue])
    {
        movementDistance = 150.0;
        [self animateTextField: sender up:YES];
    }
    
    if ([sender isEqual:self.LonValue])
    {
        movementDistance = 150.0;
        [self animateTextField: sender up:YES];
    }
    
    if ([sender isEqual:self.AccValue])
    {
        movementDistance = 150.0;
        [self animateTextField: sender up:YES];
    }
    
    if ([sender isEqual:self.AltValue])
    {
        movementDistance = 150.0;
        [self animateTextField: sender up:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)sender
{
    if ([sender isEqual:self.CommentInput])
    {
        [self animateTextField: sender up:NO];
    }
    
    if ([sender isEqual:self.LatValue])
    {
        [self animateTextField: sender up:NO];
    }
    
    if ([sender isEqual:self.LonValue])
    {
        [self animateTextField: sender up:NO];
    }
    
    if ([sender isEqual:self.AccValue])
    {
        [self animateTextField: sender up:NO];
    }
    
    if ([sender isEqual:self.AltValue])
    {
        [self animateTextField: sender up:NO];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // puts the screen back if it's touched anywhere
	[self.ObservationNameInput resignFirstResponder];
    [self.CommentInput resignFirstResponder];
}

@end
