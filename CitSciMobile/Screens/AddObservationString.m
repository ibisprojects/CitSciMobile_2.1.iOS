//
//  AddObservationString.m
//  CitSciMobile
//
//  Created by lee casuto on 4/24/15.
//  Copyright (c) 2015 lee casuto. All rights reserved.
//

#import "AddObservationString.h"
#import "../Model/Model.h"
#import "../AppDelegate.h"

@interface AddObservationString ()

@end

@implementation AddObservationString
@synthesize CurrentAttributes;
@synthesize TitleName;
@synthesize SelectionName;
@synthesize SelectionEnterInput;
@synthesize theName;
@synthesize theComment;
@synthesize textField;
@synthesize TheAttributeNumber;
@synthesize Yikes;

//
// get a pointer to all options
//
Model *TheOptions;


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
    //NSLog(@"===== addobservationstring: enter continue");
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
        // prepare for the next view
        //
        NSString *temp = [[NSString alloc]initWithFormat:@"%@",self.SelectionEnterInput.text];
        
        if(PreviousMode)
        {
            int TheIndex = [TheOptions GetCurrentAttributeChoiceIndex]+ATTRIBUTEINDEXOFFSET;
            [TheOptions ReplaceAttributeDataValueAtIndex:TheIndex:temp];
        }
        else
        {
            [TheOptions SetCurrentAttributeDataValue:temp];
        }
        
        //NSLog(@"===== addobservationstring: before setnextattribute continue");
        //[TheOptions ShowIndexes];
        [TheOptions SetNextAttribute];
        //NSLog(@"===== addobservationstring: after setnextattribute continue");
        //[TheOptions ShowIndexes];
        
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
    
    Boolean Error           = false;
    NSString *SelectType    = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeType]];
    NSString *Modifier      = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeTypeModifier]];
    SelectType              = [SelectType lowercaseString];
    Modifier                = [Modifier lowercaseString];
    int TheNextView         = 0;
    
    if([TheOptions GetAuthoritySet])
    {
        SelectType  = [[NSString alloc] initWithFormat:@"%@", [TheOptions GetCurrentAttributeType]];
        SelectType  = [SelectType lowercaseString];
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

#pragma -
#pragma - mark lifecycle
-(id)init
{
    self = [super init];
    
    TheOptions = [Model SharedModel];
    
    Boolean NewOrganism = [TheOptions GetIsNewOrganism];
    Boolean SiteType    = [TheOptions GetCollectionType];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //this is iphone 5 xib
        if(NewOrganism && (SiteType == COLLECTORGANISM))
        {
            self = [self initWithNibName:@"AddObservationStringSkipAndCamera_iphone5" bundle:nil];
        }
        else
        {
            self = [self initWithNibName:@"AddObservationString_iphone5" bundle:nil];
        }
    }
    else
    {
        // this is iphone 4 xib
        if(NewOrganism && (SiteType == COLLECTORGANISM))
        {
            self = [self initWithNibName:@"AddObservationStringSkipAndCamera" bundle:nil];
        }
        else
        {
            self = [self initWithNibName:@"AddObservationString" bundle:nil];
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
    
    [TheOptions SetCurrentViewValue:ADDOBSERVATIONSTRING];
    
    self.Yikes.translucent  = NO;
    self.Yikes.barTintColor = [UIColor blackColor];
    
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
    
    Boolean ShowBox = false;
    if ([TheOptions GetAttributeNumberForCurrentOrganism] == 0 &&
        ([TheOptions GetCollectionType] == COLLECTORGANISM))
    {
        ShowBox = true;
    }
    
    if([TheOptions GetIsNewOrganism] || ShowBox)
    {
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
            NSString *foo       = [TheOptions GetOrganismCommentAtIndex:OrganismIndex];
            self.textField.text = [[NSString alloc]initWithFormat:@"%@",foo];
        }
    }
    
    self.SelectionEnterInput.delegate   = self;
    
    //
    // we need to set up values if we come in backwards or
    // from a previous view
    //
    if([TheOptions GetPreviousMode])
    {
        // set the values and stay in previous mode until we
        // tap continue
        
        int TheIndex        = [TheOptions GetCurrentAttributeChoiceIndex]+ATTRIBUTEINDEXOFFSET;
        
        NSString *foo       = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetCurrentAttributeDataValueAtIndex:TheIndex]];
        
        self.SelectionEnterInput.text = foo;

        if( (AttributeNumber > 1) && !([TheOptions GetGoingForward]) )
        {
            AttributeNumber--;
            [TheOptions SetCurrentAttributeNumber:AttributeNumber];
        }
    }
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -
#pragma - mark keyboard
//
// deal with the keyboard hiding text fields
// I picked this solution up off the web.  To use it:
// 1. set the kOFFSET... define to the desired height
// 2. follow the instructions here:
//// http://www.iphonedevsdk.com/forum/iphone-sdk-tutorials/32204-moving-uitextfield-when-keyboard-pops-up.html
//
#define kOFFSET_FOR_KEYBOARD 0.0    // not needed, but ready if it becomes required
-(void)animateTextView: (UITextView *) textView up: (BOOL) up
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

-(void)textViewDidBeginEditing:(UITextView *)sender
{
    if ([sender isEqual:self.SelectionEnterInput])
    {
        [self animateTextView: sender up:YES];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.SelectionEnterInput])
    {
        [self animateTextField: sender up:YES];
    }
}

- (void)textViewDidEndEditing:(UITextView *)sender
{
    if ([sender isEqual:self.SelectionEnterInput])
    {
        [self animateTextView: sender up:NO];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)sender
{
    if ([sender isEqual:self.SelectionEnterInput])
    {
        [self animateTextField: sender up:NO];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [textView setBackgroundColor:[UIColor yellowColor]];
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // puts the screen back if it's touched anywhere
	[self.SelectionEnterInput resignFirstResponder];
    [self.textField resignFirstResponder];
}

@end
