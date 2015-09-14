//
//  AddObservationDate.m
//  CitSciMobile
//
//  Created by lee casuto on 4/24/15.
//  Copyright (c) 2015 lee casuto. All rights reserved.
//

#import "AddObservationDate.h"
#import "../Model/Model.h"
#import "../AppDelegate.h"
#import "PicklistView.h"

@interface AddObservationDate ()

@end

@implementation AddObservationDate
@synthesize DatePicker;
@synthesize theComment;
@synthesize theName;
@synthesize SelectionEnterInput;
@synthesize SelectionName;
@synthesize textField;
@synthesize TitleName;
@synthesize CurrentAttributes;
@synthesize TheAttributeNumber;
@synthesize Yikes;
@synthesize PreviousTitle;
@synthesize PreviousValue;
@synthesize SelectedDate;

//
// get a pointer to all options
//
Model *TheOptions;

//
// Set up the indexes to start an observation
//
static int OrganismIndex    = 0;
static int AttributeIndex   = 0;
static int AttributeNumber  = 0;

#pragma mark - buttons
//--------------------------//
// GetSelectedDate          //
//--------------------------//
// Cancel any changes without saving
-(IBAction)GetSelectedDate
{
    NSDate *pickerDate = [self.DatePicker date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    
    NSString *dateString = [dateFormatter stringFromDate: pickerDate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH";
    NSString *HourString = [timeFormatter stringFromDate: pickerDate];
    
    timeFormatter.dateFormat = @"mm";
    NSString *MinuteString = [timeFormatter stringFromDate:pickerDate];
    
    NSLog(@"NSDateFormatter:   %@",dateString);
    NSLog(@"HourString     :   %@",HourString);
    NSLog(@"MinuteString   :   %@",MinuteString);
}

//--------------------------//
// ContinueButton           //
//--------------------------//
// goes back to ObservationViewController loop
//
-(IBAction)ContinueButton:(int)intNewView
{
    //NSLog(@"===== addobservationdate: enter continue");
    //[TheOptions ShowIndexes];
    Boolean PreviousMode = [TheOptions GetPreviousMode];
    self.theComment      = [[NSString alloc]init];
    self.theName         = [[NSString alloc]init];
    
    //
    // save the information
    //
    Boolean Success = true;
    self.theName    = self.SelectionEnterInput.text;
    self.theComment = self.textField.text;
    
    if(self.theComment == NULL)
    {
        self.theComment = @"";
    }
    
    if(Success)
    {
        //
        // save the comment
        //
        if([TheOptions GetIsNewOrganism])
        {
            OrganismIndex           = [TheOptions GetCurrentOrganismIndex];
            [TheOptions ReplaceOrganismCommentAtIndex:self.theComment:OrganismIndex];
        }
        
        //
        // prepare for the next view - get the date and convert it in temp
        //
        self.SelectedDate = self.DatePicker.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yyyy";
        
        NSString *dateString = [dateFormatter stringFromDate: self.SelectedDate];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH";
        NSString *HourString = [timeFormatter stringFromDate: self.SelectedDate];
        
        timeFormatter.dateFormat = @"mm";
        NSString *MinuteString = [timeFormatter stringFromDate:self.SelectedDate];
        NSString *Meridian     = [[NSString alloc] init];
        
        long h = [HourString integerValue];
        if(h > 12)
        {
            Meridian = @"PM";
            h = h-12;
            HourString = [[NSString alloc]initWithFormat:@"%ld",h];
        }
        else
        {
            Meridian = @"AM";
        }
        
        NSString *temp = [[NSString alloc]initWithFormat:@"%@ %@:%@ %@",dateString, HourString,MinuteString,Meridian];
        
        int CurrentAttributeCount                = [TheOptions GetCurrentAttributeDataValueCount];
        int TheIndex                             = [TheOptions GetCurrentAttributeChoiceIndex]+ATTRIBUTEINDEXOFFSET;
        
        if(PreviousMode && (TheIndex < CurrentAttributeCount))
        {
            [TheOptions ReplaceAttributeDataValueAtIndex:TheIndex:temp];
        }
        else
        {
            [TheOptions SetCurrentAttributeDataValue:temp];
        }
        
        [TheOptions SetNextAttribute];
        
        Boolean Done            = [TheOptions GetIsLast];
        Boolean Error           = false;
        NSString *SelectType    = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeType]];
        NSString *Modifier      = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeTypeModifier]];
        SelectType              = [SelectType lowercaseString];
        Modifier                = [Modifier lowercaseString];
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
            [TheOptions SetGoingForward:true];
            AppDelegate  *appDelegate   = [[UIApplication sharedApplication] delegate];
            int OrganismIndex           = [TheOptions GetCurrentOrganismIndex];
            NSMutableArray *pl          = [TheOptions GetOrganismPicklistAtIndex:OrganismIndex];
            NSString *orgtype           = [TheOptions GetOrganismDataTypeAtIndex:OrganismIndex];
            if(([TheOptions GetIsNewOrganism]) && ([pl count] > 0))
            {
                [TheOptions SetViewAfterPicklist:TheNextView];
                [TheOptions SetViewType:TheNextView];
                [appDelegate displayView:PICKLISTVIEW];
            }
            else if(([TheOptions GetIsNewOrganism]) && ([orgtype isEqualToString:@"bioblitz"]))
            {
                [TheOptions SetViewAfterPicklist:TheNextView];
                [TheOptions SetViewType:TheNextView];
                [appDelegate displayView:BIOBLITZVIEW];
            }
            else
            {
                [TheOptions SetViewType:TheNextView];
                [appDelegate displayView:TheNextView];
            }
        }
    }
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
// SkipButton               //
//--------------------------//
// skips the current organism
//
-(IBAction)SkipButton:(int)intNewView
{
    [TheOptions SkipOrganism];
    
    Boolean Done            = [TheOptions GetIsLast];
    Boolean Error           = false;
    NSString *SelectType    = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeType]];
    NSString *Modifier      = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeTypeModifier]];
    SelectType              = [SelectType lowercaseString];
    Modifier                = [Modifier lowercaseString];
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
        AppDelegate  *appDelegate   = [[UIApplication sharedApplication] delegate];
        int OrganismIndex           = [TheOptions GetCurrentOrganismIndex];
        NSMutableArray *pl          = [TheOptions GetOrganismPicklistAtIndex:OrganismIndex];
        NSString *orgtype           = [TheOptions GetOrganismDataTypeAtIndex:OrganismIndex];
        if(([TheOptions GetIsNewOrganism]) && ([pl count] > 0))
        {
            [TheOptions SetViewAfterPicklist:TheNextView];
            [TheOptions SetViewType:TheNextView];
            [appDelegate displayView:PICKLISTVIEW];
        }
        else if(([TheOptions GetIsNewOrganism]) && ([orgtype isEqualToString:@"bioblitz"]))
        {
            [TheOptions SetViewAfterPicklist:TheNextView];
            [TheOptions SetViewType:TheNextView];
            [appDelegate displayView:BIOBLITZVIEW];
        }
        else
        {
            [TheOptions SetViewType:TheNextView];
            [appDelegate displayView:TheNextView];
        }
    }
}

//--------------------------//
// CameraButton             //
//--------------------------//
// take pictures
//
-(IBAction)CameraButton:(int)intNewView
{
    //
    // set up to go back to enter after
    // the camera is finished
    //
    [TheOptions SetOrganismCameraCalled:true];
    [TheOptions SetOrganismCameraParent:CAMERAFROMENTER];
    //
    // save the comment
    //
    self.theComment = [[NSString alloc]init];
    self.theComment = self.textField.text;
    
    if(self.theComment == NULL)
    {
        self.theComment = @"";
    }
    [TheOptions SetOrganismCameraComment:self.theComment];
    
    //
    // save the entered value
    //
    NSString *foo = [[NSString alloc]initWithFormat:@"%@",self.SelectionEnterInput.text];
    [TheOptions SetOrganismCameraEnterValue:foo];
    
    
    [TheOptions SetCameraMode:CAMERAORGANISM];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate displayView:CAMERAVIEW];
}

//
// temporary check for picklist as the previous view
//
-(Boolean)IsPicklistNext
{
    return false;
}
//--------------------------//
// PreviousButton           //
//--------------------------//
// go to the previous screen
//
-(IBAction)PreviousButton:(int)intNewView
{
    Boolean CollectingSite          = false;
    Boolean CollectingOrg           = false;
    int     PreviousNumber          = [TheOptions GetAttributeNumberForCurrentOrganism];
    AppDelegate  *appDelegate       = [[UIApplication sharedApplication] delegate];
    
    if([self IsPicklistNext])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                    message:@"Do Not backup from here"
                                                   delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if([TheOptions GetCollectionType]==COLLECTSITE)
    {
        CollectingSite              = true;
    }
    [TheOptions SetPreviousMode:true];
    [TheOptions SetPreviousAttribute];
    if([TheOptions GetCollectionType]==COLLECTORGANISM)
    {
        CollectingOrg               = true;
    }
    
    Boolean     Error               = false;
    NSString    *SelectType         = [[NSString alloc] init];
    NSString    *Modifier           = [[NSString alloc] init];
    int         TheNextView         = 0;
    
    if([TheOptions GetAuthoritySet])
    {
        SelectType  = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeType]];
        Modifier    = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeTypeModifier]];
        SelectType  = [SelectType lowercaseString];
        Modifier    = [Modifier lowercaseString];
    }
    else
    {
        SelectType  = @"AddAuthority";
    }
    
    if([SelectType isEqualToString:@"entered"])
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
    else if([SelectType isEqualToString:@"select"])
    {
        TheNextView = ADDOBSERVATIONSELECT;
    }
    else if([SelectType isEqualToString:@"AddAuthority"])
    {
        TheNextView = ADDAUTHORITY;
    }
    else
    {
        Error = true;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"Illegal data sheet; no observation is possible"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [appDelegate displayView:OBSERVATIONSVIEW];
    }
    
    if(!Error)
    {
        int         AtNum           = [TheOptions GetCurrentAttributeNumber];
        AtNum                       = AtNum - 1;
        [TheOptions SetGoingForward:false];
        if(CollectingOrg && CollectingSite)
        {
            //
            // we were collecting site characteristics and have
            // backed up to organisms.  We need to set the
            // current attribute nunber to the last number of
            // the current organism.
            //
            AtNum                   = [TheOptions GetCurrentOrganismAttributeCount]+1;
        }
        [TheOptions SetCurrentAttributeNumber:AtNum];
        int OrganismIndex           = [TheOptions GetCurrentOrganismIndex];
        int AttrIndex               = [TheOptions GetAttributeNumberForCurrentOrganism];
        NSMutableArray *pl          = [TheOptions GetOrganismPicklistAtIndex:OrganismIndex];
        NSString *orgtype           = [TheOptions GetOrganismDataTypeAtIndex:OrganismIndex];
        Boolean ShowPicklist        = ([pl count]>0 && (AttrIndex==0) && (PreviousNumber==0));
        Boolean ShowBioblitz        = ([orgtype isEqualToString:@"bioblitz"] && (AttrIndex==0) && (PreviousNumber==0));
        if(ShowPicklist)
        {
            [TheOptions SetViewAfterPicklist:TheNextView];
            [TheOptions SetViewType:TheNextView];
            [appDelegate displayView:PICKLISTVIEW];
        }
        else if(ShowBioblitz)
        {
            [TheOptions SetViewAfterPicklist:TheNextView];
            [TheOptions SetViewType:TheNextView];
            [appDelegate displayView:BIOBLITZVIEW];
        }
        else
        {
            [TheOptions SetViewType:TheNextView];
            [appDelegate displayView:TheNextView];
        }
    }
}
//--------------------------//
// End of buttons           //
//--------------------------//

#pragma -
#pragma - mark lifecycle
-(id)init
{
    self = [super init];
    
    TheOptions = [Model SharedModel];
    
    Boolean NewOrganism = [TheOptions GetIsNewOrganism];
    Boolean SiteType    = [TheOptions GetCollectionType];
    
    Boolean ShowBox = false;
    if ([TheOptions GetAttributeNumberForCurrentOrganism] == 0 &&
        ([TheOptions GetCollectionType] == COLLECTORGANISM))
    {
        ShowBox = true;
    }
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //this is iphone 5 xib
        if((NewOrganism && (SiteType == COLLECTORGANISM)) || (ShowBox))
        {
            self = [self initWithNibName:@"AddObservationDateSkipAndCamera_iphone5" bundle:nil];
        }
        else
        {
            self = [self initWithNibName:@"AddObservationDate_iphone5" bundle:nil];
        }
    }
    else
    {
        // this is iphone 4 xib
        if(NewOrganism && (SiteType == COLLECTORGANISM))
        {
            self = [self initWithNibName:@"AddObservationDateSkipAndCamera" bundle:nil];
        }
        else
        {
            self = [self initWithNibName:@"AddObservationDate" bundle:nil];
        }
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
    //
    // application specific stuff
    //
    self.CurrentAttributes   = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [TheOptions SetCurrentViewValue:ADDOBSERVATIONDATE];
    
    self.Yikes.translucent  = NO;
    self.Yikes.barTintColor = [UIColor blackColor];
    
    //self.DatePicker.datePickerMode = UIDatePickerModeDate;
    self.SelectedDate       = [self.DatePicker date];
    
    [self.DatePicker setBackgroundColor:[UIColor whiteColor]];
    
    [self.CurrentAttributes removeAllObjects];
    
    OrganismIndex           = [TheOptions GetCurrentOrganismIndex];
    AttributeIndex          = [TheOptions GetCurrentAttributeChoiceIndex];
    AttributeNumber         = [TheOptions GetCurrentAttributeNumber];
    
    self.CurrentAttributes  = [TheOptions GetCurrentAttributeChoices];
    self.SelectionName.text = [TheOptions GetCurrentAttributeName];
    
    if([TheOptions GetCollectionType]==COLLECTORGANISM)
    {
        self.TitleName.text = [TheOptions GetCurrentOrganismName];
    }
    
    if([TheOptions GetCollectionType]==COLLECTSITE)
    {
        self.TitleName.text = @"Site Attribute";
    }
    
    if([TheOptions GetCollectionType]==COLLECTTREATMENT)
    {
        self.TitleName.text = @"Treatment Attribute";
    }
    
    int CurrentAttributeCount                = [TheOptions GetCurrentAttributeDataValueCount];
    int TheIndex                             = [TheOptions GetCurrentAttributeChoiceIndex] + ATTRIBUTEINDEXOFFSET;
    //
    // we need to set up values if we come in backwards or
    // from a previous view
    //
    if([TheOptions GetPreviousMode])
    {
        // set the values and stay in previous mode until we
        // tap continue
        if(TheIndex < CurrentAttributeCount)
        {
            //
            // set the date to the previously selected
            // date by parsing foo and reconstructing
            // SelectedDate
            //
            // Initialize date components with date values
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            NSUInteger       x               = 0;
            NSString         *foo            = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetCurrentAttributeDataValueAtIndex:TheIndex]];
            
            NSArray *bits = [foo componentsSeparatedByString: @" "];
            NSString *bar = [[NSString alloc]initWithFormat:@"%@",[bits objectAtIndex:0]];
            NSArray *thedate = [bar componentsSeparatedByString:@"/"];
            
            // month
            bar = [[NSString alloc]initWithFormat:@"%@",[thedate objectAtIndex:0]];
            x   = [bar integerValue];
            [dateComponents setMonth:(unsigned long)x];
            
            // day
            bar = [[NSString alloc]initWithFormat:@"%@",[thedate objectAtIndex:1]];
            x   = [bar integerValue];
            [dateComponents setDay:(unsigned long)x];
            
            // year
            bar = [[NSString alloc]initWithFormat:@"%@",[thedate objectAtIndex:2]];
            x   = [bar integerValue];
            [dateComponents setYear:(unsigned long)x];
            
            // hours and minutes
            NSString *meridian = [[NSString alloc]initWithFormat:@"%@",[bits objectAtIndex:2]];
            Boolean plus12     = false;
            if([meridian isEqualToString:@"PM"])
            {
                plus12 = true;
            }
            bar = [[NSString alloc]initWithFormat:@"%@",[bits objectAtIndex:1]];
            NSArray *thetime = [bar componentsSeparatedByString:@":"];
            
            // hour
            bar = [[NSString alloc]initWithFormat:@"%@",[thetime objectAtIndex:0]];
            x   = [bar integerValue];
            if(plus12)
            {
                x+=(unsigned long)12;
            }
            [dateComponents setHour:(unsigned long)x];
            
            // minute
            bar = [[NSString alloc]initWithFormat:@"%@",[thetime objectAtIndex:1]];
            x   = [bar integerValue];
            [dateComponents setMinute:(unsigned long)x];
            
            NSCalendar *calendar  = [[NSCalendar alloc]  initWithCalendarIdentifier:NSGregorianCalendar];
            self.SelectedDate     = [calendar dateFromComponents:dateComponents];
            
            self.SelectionEnterInput.text = foo;
        }
        
        if( (AttributeNumber > 1) && !([TheOptions GetGoingForward]) )
        {
            AttributeNumber--;
            [TheOptions SetCurrentAttributeNumber:AttributeNumber];
        }
    }

    Boolean ShowBox = false;
    if ([TheOptions GetAttributeNumberForCurrentOrganism] == 0 &&
        ([TheOptions GetCollectionType] == COLLECTORGANISM))
    {
        ShowBox = true;
    }
    
    if([TheOptions GetIsNewOrganism] || ShowBox)
    {
        NSString *message;
        int site          = [TheOptions GetCollectionType];
        AttributeNumber   = 1;
        [TheOptions SetCurrentAttributeNumber:AttributeNumber];
        
        if(site == COLLECTORGANISM)
        {
            message        = [[NSString alloc]initWithFormat:@"Starting organism: %@",[TheOptions GetCurrentOrganismName]];
        }
        else
        {
            message        = [[NSString alloc]initWithFormat:@"Starting site attributes"];
        }
        
        if(!([TheOptions GetOrganismCameraCalled]))
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:message
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        
        if(site == COLLECTORGANISM)
        {
            self.textField                           = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, 280, 30)];
            self.textField.borderStyle               = UITextBorderStyleRoundedRect;
            self.textField.font                      = [UIFont systemFontOfSize:15];
            self.textField.placeholder               = @"enter organism comment";
            self.textField.autocorrectionType        = UITextAutocorrectionTypeNo;
            self.textField.keyboardType              = UIKeyboardTypeDefault;
            self.textField.returnKeyType             = UIReturnKeyDefault;
            self.textField.clearButtonMode           = UITextFieldViewModeWhileEditing;
            self.textField.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
            self.textField.autocapitalizationType    = UITextAutocapitalizationTypeNone;
            self.textField.delegate                  = self;
            self.SelectionEnterInput.delegate        = self;
            [self.view addSubview:self.textField];
        }
        
        if([TheOptions GetOrganismCameraCalled])
        {
            [TheOptions SetOrganismCameraCalled:false];
            self.theComment                 = [[NSString alloc]init];
            self.theName                    = [[NSString alloc]init];
            self.SelectionEnterInput.text   = [TheOptions GetOrganismCameraEnterValue];
            self.theName                    = self.SelectionEnterInput.text;
            self.theComment                 = [TheOptions GetOrganismCameraComment];
            self.textField.text             = self.theComment;
        }
        
        if([TheOptions GetPreviousMode])
        {
            NSString *foo                   = [TheOptions GetOrganismCommentAtIndex:OrganismIndex];
            self.textField.text             = [[NSString alloc]initWithFormat:@"%@",foo];
        }
    }
    
    self.SelectionEnterInput.delegate        = self;
    
    //
    // set up the attribute number being collected and next attribute
    //
    AttributeNumber         = [TheOptions GetCurrentAttributeNumber];
    int site                = [TheOptions GetCollectionType];
    NSString *CurAttribute;
    int RemainingAttributes;
    if(site == COLLECTORGANISM)
    {
        CurAttribute            = [TheOptions GetActiveAttributeString];
    }
    
    if(site == COLLECTSITE)
    {
        RemainingAttributes = [TheOptions GetTotalAttributeCount]-[TheOptions GetOrganismAttributeCount];
        CurAttribute            = [[NSString alloc]initWithFormat:@"Attribute %d of %d",AttributeNumber,RemainingAttributes];
    }
    
    self.TheAttributeNumber.text   = CurAttribute;
    
    AttributeNumber++;
    [TheOptions SetCurrentAttributeNumber:AttributeNumber];
    
    // set the date picker
    self.DatePicker.date = self.SelectedDate;
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
	if(theTextField == self.SelectionEnterInput)
	{
		[self.SelectionEnterInput resignFirstResponder];
	}
    
    if(theTextField == self.textField)
	{
		[self.textField resignFirstResponder];
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
#define kOFFSET_FOR_KEYBOARD 0.0    // not needed, but ready if it becomes required

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

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.SelectionEnterInput])
    {
        [self animateTextField: sender up:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)sender
{
    if ([sender isEqual:self.SelectionEnterInput])
    {
        [self animateTextField: sender up:NO];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // puts the screen back if it's touched anywhere
	[self.SelectionEnterInput resignFirstResponder];
    [self.textField resignFirstResponder];
}

@end
