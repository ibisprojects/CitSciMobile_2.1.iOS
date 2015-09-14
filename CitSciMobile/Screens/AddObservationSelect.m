//
//  AddObservationSelect.m
//  CitSciMobile
//
//  Created by lee casuto on 2/20/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import "AddObservationSelect.h"
#import "../Model/Model.h"
#import "../AppDelegate.h"
#import "PicklistView.h"

@interface AddObservationSelect ()

@end

@implementation AddObservationSelect
@synthesize CurrentAttributes;
@synthesize TitleName;
@synthesize SelectionName;
@synthesize PreviousValue;
@synthesize PreviousTitle;
@synthesize textField;
@synthesize theComment;
@synthesize TheAttributeNumber;
@synthesize Yikes;


//
// get a pointer to all options
//
Model *TheOptions;

//
// debugging
//
Boolean SelectContiniue = false;

int TheSelectionRow;
Boolean OptionsSelectSet=false;
Boolean AddSelectDebug=false;

//
// Set up the indexes to start an observation
//
static int OrganismIndex    = 0;
static int AttributeIndex   = 0;
static int AttributeNumber  = 0;

#pragma -
#pragma - mark utility methods


#pragma -
#pragma - mark buttons
//--------------------------//
// ContinueButton           //
//--------------------------//
// goes back to ObservationViewController loop
//
-(IBAction)ContinueButton:(int)intNewView
{
    //NSLog(@"===== addobservationselect: enter continue");
    //[TheOptions DumpAttributeData];
    Boolean PreviousMode    = [TheOptions GetPreviousMode];
    NSString *temp          = [[NSString alloc]init];
    self.theComment         = [[NSString alloc]init];
    
    //
    // save the comment
    //
    self.theComment = self.textField.text;
    
    if(self.theComment == NULL)
    {
        self.theComment = @"";
    }

    //
    // save the information
    //
    if(!OptionsSelectSet)
    {
        TheSelectionRow = 0;
    }
    
    
    //
    // save the comment
    //
    if([TheOptions GetIsNewOrganism])
    {
        OrganismIndex           = [TheOptions GetCurrentOrganismIndex];
        [TheOptions ReplaceOrganismCommentAtIndex:self.theComment:OrganismIndex];
    }
    
    temp = [[NSString alloc]initWithFormat:@"%@",[self.CurrentAttributes objectAtIndex:TheSelectionRow]];
    
    if(PreviousMode)
    {
        int TheIndex = [TheOptions GetCurrentAttributeChoiceIndex]+ATTRIBUTEINDEXOFFSET;
        if(!OptionsSelectSet)
        {
            temp     = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetCurrentAttributeDataValueAtIndex:TheIndex]];
        }
        
        [TheOptions ReplaceAttributeDataValueAtIndex:TheIndex:temp];
    }
    else
    {
        [TheOptions SetCurrentAttributeDataValue:temp];
    }
    
    //
    // prepare for the next view
    //
    AddSelectDebug=false;
    if(AddSelectDebug) [TheOptions DumpAttributeDataValues];
    AddSelectDebug=false;
    
    SelectContiniue=false;
    if(SelectContiniue)
    {
        NSLog(@"AddobservationSelect just before SetNextAttribute");
        [TheOptions ShowIndexes];
    }
    
    [TheOptions SetNextAttribute];
    
    if(SelectContiniue)
    {
        NSLog(@"AddobservationSelect just after SetNextAttribute");
        [TheOptions ShowIndexes];
    }
    SelectContiniue=false;
    
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
            [appDelegate displayView:PICKLISTVIEW];
        }
        else if(([TheOptions GetIsNewOrganism]) && ([orgtype isEqualToString:@"bioblitz"]))
        {
            [TheOptions SetViewAfterPicklist:TheNextView];
            [appDelegate displayView:BIOBLITZVIEW];
        }
        else
        {
            [appDelegate displayView:TheNextView];
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
            [appDelegate displayView:PICKLISTVIEW];
        }
        else if(([TheOptions GetIsNewOrganism]) && ([orgtype isEqualToString:@"bioblitz"]))
        {
            [TheOptions SetViewAfterPicklist:TheNextView];
            [appDelegate displayView:BIOBLITZVIEW];
        }
        else
        {
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
    // set up to go back to select after
    // the camera is finished
    //
    [TheOptions SetOrganismCameraCalled:true];
    [TheOptions SetOrganismCameraParent:CAMERAFROMSELECT];
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
    // save the row and selection
    //
    if(!OptionsSelectSet)
    {
        TheSelectionRow = 0;
    }
    [TheOptions SetOrganismCameraSelectRow:TheSelectionRow];
    NSString *foo = [[NSString alloc]initWithFormat:@"%@",[CurrentAttributes objectAtIndex:TheSelectionRow]];
    [TheOptions SetOrganismCameraSelectValue:foo];
    
    
    [TheOptions SetCameraMode:CAMERAORGANISM];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate displayView:CAMERAVIEW];
}

//--------------------------//
// PreviousButton           //
//--------------------------//
// go to the previous screen
//
-(IBAction)PreviousButton:(int)intNewView
{
    Boolean CollectingSite  = false;
    Boolean CollectingOrg   = false;
    int     PreviousNumber  = [TheOptions GetAttributeNumberForCurrentOrganism];
    if([TheOptions GetCollectionType]==COLLECTSITE)
    {
        CollectingSite      = true;
    }
    [TheOptions SetPreviousMode:true];
    [TheOptions SetPreviousAttribute];
    if([TheOptions GetCollectionType]==COLLECTORGANISM)
    {
        CollectingOrg       = true;
    }

    Boolean         Error           = false;
    NSString        *SelectType     = [[NSString alloc]init];
    NSString        *Modifier       = [[NSString alloc] init];
    int             TheNextView     = 0;
    
    if([TheOptions GetAuthorityHasBeenSet])
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
        
        AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate displayView:OBSERVATIONSVIEW];
    }
    
    if(!Error)
    {
        [TheOptions SetGoingForward:false];
        int         AtNum           = [TheOptions GetCurrentAttributeNumber];
        AtNum                       = AtNum - 1;
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
        AppDelegate  *appDelegate   = [[UIApplication sharedApplication] delegate];
        int OrganismIndex           = [TheOptions GetCurrentOrganismIndex];
        int AttrIndex               = [TheOptions GetAttributeNumberForCurrentOrganism];
        NSMutableArray *pl          = [TheOptions GetOrganismPicklistAtIndex:OrganismIndex];
        NSString *orgtype           = [TheOptions GetOrganismDataTypeAtIndex:OrganismIndex];
        Boolean ShowPicklist        = ([pl count]>0 && (AttrIndex==0) && (PreviousNumber==0));
        Boolean ShowBioblitz        = ([orgtype isEqualToString:@"bioblitz"] && (AttrIndex==0) && (PreviousNumber==0));
        if(ShowPicklist)
        {
            [TheOptions SetViewAfterPicklist:TheNextView];
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
            [appDelegate displayView:TheNextView];
        }
    }
}
//--------------------------//
// End of buttons           //
//--------------------------//

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
    label.text = [NSString stringWithFormat:@" %@", [self.CurrentAttributes objectAtIndex:row]];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    ////NSLog(@"number of components");
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger ReturnCount = 0;
    
    ReturnCount = [self.CurrentAttributes count];
	
	return ReturnCount;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *ReturnTitle = [[NSString alloc]init];
    ////NSLog(@"title for row");
    ReturnTitle = [self.CurrentAttributes objectAtIndex:row];
	
	return ReturnTitle;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    TheSelectionRow     = (int)row;
    OptionsSelectSet    = true;
    [thePickerView reloadAllComponents];
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
    // application specific stuff
    //
    TheOptions = [Model SharedModel];
    
    Boolean NewOrganism = [TheOptions GetIsNewOrganism];
    Boolean SiteType    = [TheOptions GetCollectionType];
    
    ////NSLog(@"AddObservationSelect init: current organism name = %@",[TheOptions GetCurrentOrganismName]);
    
    ////NSLog(@"Select: CurrentOrganismName = %@",[TheOptions GetCurrentOrganismName]);
    //
    // set up the xib for iphone 4 or 5 correctly
    //
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //this is iphone 5 xib
        if(NewOrganism && (SiteType == COLLECTORGANISM))
        {
            self = [self initWithNibName:@"AddObservationSelectSkipAndCamera_iphone5" bundle:nil];
        }
        else
        {
            self = [self initWithNibName:@"AddObservationSelect_iphone5" bundle:nil];
        }
    }
    else
    {
        // this is iphone 4 xib
        if(NewOrganism && (SiteType == COLLECTORGANISM))
        {
            self = [self initWithNibName:@"AddObservationSelectSkipAndCamera" bundle:nil];
        }
        else
        {
            self = [self initWithNibName:@"AddObservationSelect" bundle:nil];
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
    
    self.CurrentAttributes   = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [TheOptions SetCurrentViewValue:ADDOBSERVATIONSELECT];
    
    self.Yikes.translucent  = NO;
    self.Yikes.barTintColor = [UIColor blackColor];
    
    [self.CurrentAttributes removeAllObjects];
    
    OrganismIndex           = [TheOptions GetCurrentOrganismIndex];
    AttributeIndex          = [TheOptions GetCurrentAttributeChoiceIndex];
    AttributeNumber         = [TheOptions GetCurrentAttributeNumber];
    
    self.CurrentAttributes  = [TheOptions GetCurrentAttributeChoices];
    NSString *foo           = [[NSString alloc]initWithFormat:@"%@",[self.CurrentAttributes objectAtIndex:0]];
    if(!([foo isEqualToString:@"-- Select --"]))
    {
        [self.CurrentAttributes insertObject:@"-- Select --" atIndex:0];
    }
    
    self.SelectionName.text      = [TheOptions GetCurrentAttributeName];
    
    if([TheOptions GetCollectionType]==COLLECTORGANISM)
    {
        self.TitleName.text      = [TheOptions GetCurrentOrganismName];
    }
    
    if([TheOptions GetCollectionType]==COLLECTSITE)
    {
        self.TitleName.text      = @"Site Attribute";
    }
    
    if([TheOptions GetCollectionType]==COLLECTTREATMENT)
    {
        self.TitleName.text      = @"Treatment Attribute";
    }
    
    OptionsSelectSet        = false;
    
    
    Boolean ShowBox = false;
    if ([TheOptions GetAttributeNumberForCurrentOrganism] == 0 &&
        ([TheOptions GetCollectionType] == COLLECTORGANISM))
    {
        ShowBox = true;
    }
    
    if([TheOptions GetIsNewOrganism] || ShowBox)
    {
        //
        // show the alert and add a text field for
        // capturing the organism comment
        //
        NSString *message;
        int site           = [TheOptions GetCollectionType];
        AttributeNumber    = 1;
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
            // show the message if not returning from camera
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:message
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
            [alert show];
        }
        
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
        
        if(site == COLLECTORGANISM)
        {
            [self.view addSubview:self.textField];
        }
        
        if([TheOptions GetOrganismCameraCalled])
        {
            // handle the camera recovery
            self.textField.text = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetOrganismCameraComment]];
            self.theComment     = self.textField.text;
            TheSelectionRow     = [TheOptions GetOrganismCameraSelectRow];
        }
        
        //
        // populate the comment if it's been filled out before
        //
        if([TheOptions GetPreviousMode])
        {
            NSString *foo       = [TheOptions GetOrganismCommentAtIndex:OrganismIndex];
            self.textField.text = [[NSString alloc]initWithFormat:@"%@",foo];
        }
    }
    
    if([TheOptions GetPreviousMode])
    {
        // backing up so get the row number the user chose
        // for this selection
        int TheIndex        = [TheOptions GetCurrentAttributeChoiceIndex]+ATTRIBUTEINDEXOFFSET;
        
        self.PreviousTitle.text  = @"Prior choice:";
        NSString *foo       = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetCurrentAttributeDataValueAtIndex:TheIndex]];
        self.PreviousValue.text  = foo;

        if( (AttributeNumber > 1) && !([TheOptions GetGoingForward]) )
        {
            AttributeNumber--;
            [TheOptions SetCurrentAttributeNumber:AttributeNumber];
        }
        
        for(int i=0; i < [self.CurrentAttributes count]; i++)
        {
            NSString *temp = [[NSString alloc]initWithFormat:@"%@",[self.CurrentAttributes objectAtIndex:i]];
            if([temp isEqualToString:foo])
            {
                TheSelectionRow = i;
                [pickerView selectRow:TheSelectionRow inComponent:0 animated:NO];
            }
        }        
    }
    else
    {
        TheSelectionRow     = 0;
    }
    
    if([TheOptions GetOrganismCameraCalled])
    {
        // disable the camera called
        [TheOptions SetOrganismCameraCalled:false];
        if(!([TheOptions GetPreviousMode]))
        {
            TheSelectionRow     = [TheOptions GetOrganismCameraSelectRow];
            OptionsSelectSet    = true;
            [pickerView selectRow:TheSelectionRow inComponent:0 animated:NO];
        }
    }
    
    [pickerView reloadAllComponents];
    
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
    ////NSLog(@"===FEED FOR LABEL:%@",CurAttribute);
    //if(!([TheOptions GetPreviousMode]))
    {
        AttributeNumber++;
        [TheOptions SetCurrentAttributeNumber:AttributeNumber];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)ParameterTextField
{
    [ParameterTextField resignFirstResponder];
    return YES;
}

@end
