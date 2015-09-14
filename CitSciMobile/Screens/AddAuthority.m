//
//  AddAuthority.m
//  CitSciMobile
//
//  Created by lee casuto on 4/18/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import "AddAuthority.h"
#import "AddObservationSelect.h"
#import "../Model/Model.h"
#import "../AppDelegate.h"
#import "PicklistView.h"

@interface AddAuthority ()

@end

@implementation AddAuthority
@synthesize CurrentAuthorities;
@synthesize AuthorityFirstNames;
@synthesize AuthorityLastNames;
@synthesize AuthorityIDs;
@synthesize PreviousTitle;
@synthesize PreviousValue;
@synthesize Yikes;

//
// get a pointer to all options
//
Model *TheOptions;

//
// declaration for spinner
//
UIActivityIndicatorView *TheActivity;


Boolean IsAcquired;

//
// Set up the indexes to start an observation
//

int TheAuthorityRow;
Boolean AuthoritySelectSet=false;
Boolean AuthorityDebug = false;

NSString *ShutUp;


#pragma -
#pragma mark - utility methods
//
// utility routines
//
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
    }
    
    [TheActivity startAnimating];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate displayView:TheView];
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
    Boolean PreviousMode    = [TheOptions GetPreviousMode];
    NSString *temp          = [[NSString alloc]init];
    NSString *t2            = [[NSString alloc]init];
    NSString *t3            = [[NSString alloc]init];
    
    //
    // save the information
    //
    if(!AuthoritySelectSet)
    {
        TheAuthorityRow = 0;
    }
    
    if(TheAuthorityRow > [self.AuthorityFirstNames count])
    {
        TheAuthorityRow = 0;
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
        //                                                message:@"FOUND  THE  ERROR!!!"
        //                                               delegate:nil cancelButtonTitle:@"OK"
        //                                      otherButtonTitles: nil];
        //[alert show];
        //[alert release];

    }
    
    temp = [[NSString alloc]initWithFormat:@"%@",[self.AuthorityFirstNames objectAtIndex:TheAuthorityRow]];
    t2   = [[NSString alloc]initWithFormat:@"%@",[self.AuthorityLastNames objectAtIndex:TheAuthorityRow]];
    t3   = [[NSString alloc]initWithFormat:@"%@",[self.AuthorityIDs objectAtIndex:TheAuthorityRow]];
    
    AuthorityDebug=false;
    if(AuthorityDebug) NSLog(@"==== addauthority continue");
    if(AuthorityDebug)[TheOptions DumpAttributeDataValues];
    AuthorityDebug=false;
    
    int CurrentCount = [TheOptions GetCurrentAttributeDataValueCount];
    if(CurrentCount <= AUTHORITYSTART)
    {
        [TheOptions SetPreviousMode:false];
        PreviousMode = false;
    }
    
    if(PreviousMode)
    {
        //NSLog(@"===== addauthority: continue/previous mode");
        //[TheOptions DumpAttributeData];
        int TheIndex = AUTHORITYSTART;
        if(!AuthoritySelectSet)
        {
            temp     = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetCurrentAttributeDataValueAtIndex:TheIndex]];
            t2       = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetCurrentAttributeDataValueAtIndex:TheIndex+1]];
            t3       = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetCurrentAttributeDataValueAtIndex:TheIndex+2]];
        }
        
        // replace the authority
        [TheOptions ReplaceAttributeDataValueAtIndex:TheIndex:temp];
        [TheOptions ReplaceAttributeDataValueAtIndex:TheIndex+1:t2];
        [TheOptions ReplaceAttributeDataValueAtIndex:TheIndex+2:t3];
        [TheOptions SetAuthorityRowNumber:TheAuthorityRow];
    }
    else
    {
        // add authority information to attribute array
        [TheOptions SetCurrentAttributeDataValue:[self.AuthorityFirstNames objectAtIndex:TheAuthorityRow]];
        [TheOptions SetCurrentAttributeDataValue:[self.AuthorityLastNames objectAtIndex:TheAuthorityRow]];
        [TheOptions SetCurrentAttributeDataValue:[self.AuthorityIDs objectAtIndex:TheAuthorityRow]];
        [TheOptions SetAuthorityRowNumber:TheAuthorityRow];
    }
    
    [TheOptions SetAuthorityHasBeenSet:true];
    [TheOptions SetAuthoritySet:true];
    
    //
    // set up for next view
    //
    [TheOptions SetAttributesSet:false];
    [TheOptions SetNextAttribute];
    
    //
    // foo causes the model to wake up properly.  No idea why...
    //
    NSString *foo   = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetCurrentOrganismName]];
    ShutUp          = [[NSString alloc]initWithFormat:@"%@",foo];
    
    ////NSLog(@"AddAuthority continue: current organism name = %@",foo);
    
    
    
    Boolean Done            = [TheOptions GetIsLast];
    NSString *SelectType    = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeType]];
    NSString *Modifier      = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeTypeModifier]];
    SelectType              = [SelectType lowercaseString];
    Modifier                = [Modifier lowercaseString];
    Boolean Error           = false;
    int TheNextView         = 0;
    
    //
    // check to see if any attributes have been added.  If not
    // ensure that previous mode is disabled.
    //
    if([TheOptions GetCurrentAttributeDataValueCount] <= ATTRIBUTEINDEXOFFSET)
    {
        [TheOptions SetPreviousMode:false];
    }
    
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
        if([TheOptions GetFirstSelect])
        {
            [TheOptions SetCurrentAttributeChoiceCount];
            [TheOptions SetCurrentAttributeChoices];
            [TheOptions SetFirstSelect:false];
        }
        if(Done)
        {
            TheNextView = ADDOBSERVATIONSELECTDONE;
        }
        else
        {
            TheNextView = ADDOBSERVATIONSELECT;
        }
        
        ////NSLog(@"TheNextView=%d",TheNextView);
    }
    else
    {
        Error = true;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"Illegal data sheet; no observation is possible"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
        AppDelegate  *appDelegate   = [[UIApplication sharedApplication] delegate];
        [appDelegate displayView:OBSERVATIONSVIEW];
    }
    
    if(!Error)
    {
        [TheOptions SetCurrentViewValue:ADDAUTHORITY];
        AppDelegate  *appDelegate   = [[UIApplication sharedApplication] delegate];
        int OrganismIndex           = [TheOptions GetCurrentOrganismIndex];
        NSMutableArray *pl          = [TheOptions GetOrganismPicklistAtIndex:OrganismIndex];
        NSString *orgtype           = [TheOptions GetOrganismDataTypeAtIndex:OrganismIndex];
        //NSLog(@"Authority(continue): orgtype: %@",orgtype);
        if(([TheOptions GetIsNewOrganism]) && ([pl count] > 0))
        {
            [TheOptions SetKeepAuthoritySet:true];
            [TheOptions SetViewAfterPicklist:TheNextView];
            [TheOptions SetViewType:TheNextView];
            [appDelegate displayView:PICKLISTVIEW];
            
        }
        else if(([TheOptions GetIsNewOrganism]) && ([orgtype isEqualToString:@"bioblitz"]))
        {
            [TheOptions SetKeepAuthoritySet:true];
            [TheOptions SetViewAfterPicklist:TheNextView];
            [TheOptions SetViewType:TheNextView];
            [appDelegate displayView:BIOBLITZVIEW];
        }
        else
        {
            [TheOptions SetKeepAuthoritySet:false];
            [appDelegate displayView:TheNextView];
            [TheOptions SetViewType:TheNextView];
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
// PreviousButton           //
//--------------------------//
// backs up to the previous screen AddObservation
//
-(IBAction)PreviousButton:(int)intNewView
{
    //
    // this can only go to AddObservation so we just know
    //
    [TheOptions SetPreviousMode:true];
    [TheOptions SetAuthorityHasBeenSet:false];
    [TheOptions SetPreviousAttribute];
    
    AuthorityDebug=false;
    if(AuthorityDebug)
    {
        NSLog(@"=====  AddAuthority Previous =====");
        [TheOptions DumpAttributeDataValues];
    }
    AuthorityDebug=false;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if([TheOptions GetPredefinedLocationMode])
    {
        [appDelegate displayView:ADDPREDEFINEDOBSERVATION];
    }
    else
    {
        [appDelegate displayView:ADDOBSERVATION];
    }

    /***************************
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
    TheActivity.color=[UIColor blackColor];
    [TheActivity setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)]; // in landscape mode
    [self.view addSubview:TheActivity]; // spinner is not visible until started
    [TheActivity startAnimating];
    ****************************/
    
}
///////////////////////////
// end of buttons        //
///////////////////////////

#pragma mark - picker finctions
//--------------------------//
// picker functions         //
//--------------------------//
- (UIView *)pickerView:(UIPickerView *)thePickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, thePickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = [NSString stringWithFormat:@" %@", [self.CurrentAuthorities objectAtIndex:row]];
    label.textAlignment = NSTextAlignmentCenter;
    return label;    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
	return 1;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    TheAuthorityRow     = (int)row;
    AuthoritySelectSet  = true;
    [thePickerView reloadAllComponents];
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.CurrentAuthorities count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.CurrentAuthorities objectAtIndex:row];
}
//
// end of picker functions
//

#pragma -
#pragma - mark lifecycle
-(id)init
{
    self = [super init];
    
    //
    // set up the xib for iphone 4 or 5 correctly
    //
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //this is iphone 5 xib
        self = [self initWithNibName:@"AddAuthority_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"AddAuthority" bundle:nil];
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
    TheOptions = [Model SharedModel];
    
    self.CurrentAuthorities      = [[NSMutableArray alloc]init];
    self.AuthorityFirstNames     = [[NSMutableArray alloc]init];
    self.AuthorityLastNames      = [[NSMutableArray alloc]init];
    self.AuthorityIDs            = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.Yikes.translucent      = NO;
    self.Yikes.barTintColor     = [UIColor blackColor];
    
    AuthorityDebug=false;
    if(AuthorityDebug) NSLog(@"==== addauthority viewwillappear");
    if(AuthorityDebug)[TheOptions DumpAttributeDataValues];
    AuthorityDebug=false;
    
    // build up the authority list
    [self.CurrentAuthorities removeAllObjects];
    [self.AuthorityFirstNames removeAllObjects];
    [self.AuthorityLastNames removeAllObjects];
    [self.AuthorityIDs removeAllObjects];
    
    self.AuthorityLastNames  = [TheOptions GetAuthorityLastName];
    self.AuthorityFirstNames = [TheOptions GetAuthorityFirstName];
    self.AuthorityIDs        = [TheOptions GetAuthorityID];
    
    int limit = (int)[self.AuthorityFirstNames count];
    
    NSString *foo = [[NSString alloc]initWithFormat:@"%@", [self.AuthorityFirstNames objectAtIndex:0]];
    
    if(!([foo isEqualToString:@"-- Select --"]))
    {
        [self.CurrentAuthorities addObject:@"-- Select --"];
    }
    
    for(int i=0; i < limit; i++)
    {
        NSString *fn = [[NSString alloc]initWithFormat:@"%@",[self.AuthorityFirstNames objectAtIndex:i]];
        NSString *ln = [[NSString alloc]initWithFormat:@"%@",[self.AuthorityLastNames objectAtIndex:i]];
        NSString *name = [[NSString alloc]initWithFormat:@"%@ %@",fn,ln];
        [self.CurrentAuthorities addObject:name];
    }
    
    if(!([foo isEqualToString:@"-- Select --"]))
    {
        [self.AuthorityFirstNames insertObject:@"-- Select --" atIndex:0];
        [self.AuthorityLastNames insertObject:@"" atIndex:0];
        [self.self.AuthorityIDs insertObject:@"-1" atIndex:0];
    }
    
    TheAuthorityRow = [TheOptions GetAuthorityRowNumber];
    
    if([TheOptions GetPreviousMode] && ([TheOptions GetCurrentAttributeDataValueCount]>AUTHORITYSTART))
    {
        self.PreviousTitle.text = @"Prior choice:";
        self.PreviousValue.text = [self.CurrentAuthorities objectAtIndex:TheAuthorityRow];
    }
    
    [pickerView selectRow:TheAuthorityRow inComponent:0 animated:NO];
    [pickerView reloadAllComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
