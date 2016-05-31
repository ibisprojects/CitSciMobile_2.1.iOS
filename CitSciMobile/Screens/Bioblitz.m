//
//  Bioblitz.m
//  CitSciMobile
//
//  Created by lee casuto on 8/17/15.
//  Copyright (c) 2015 lee casuto. All rights reserved.
//

#import "Bioblitz.h"
#import "../Model/Model.h"
#import "../AppDelegate.h"

@interface Bioblitz ()

@end

@implementation Bioblitz
@synthesize SelectionEnterInput;
@synthesize theName;
@synthesize textField;
@synthesize Yikes;

//
// get a pointer to all options
//
Model *TheOptions;

//
// Set up the indexes to start an observation
//
static int OrganismIndex    = 0;
static int CurrentOrganism;

#pragma -
#pragma - mark buttons
//--------------------------//
// ContinueButton           //
//--------------------------//
// goes back to ObservationViewController loop
//
-(IBAction)ContinueButton:(int)intNewView
{
    AppDelegate  *appDelegate   = [[UIApplication sharedApplication] delegate];
    int NextView                = [TheOptions GetViewAfterPicklist];
    OrganismIndex               = [TheOptions GetCurrentOrganismIndex];
    int LocalAttributeIndex     = [TheOptions GetCurrentAttributeChoiceIndex];
    
    self.theName                = [[NSString alloc]init];
    
    //
    // save the information
    //
    self.theName                = self.SelectionEnterInput.text;
    
    if([self.theName length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"You must enter an organism name!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [TheOptions ReplaceOrganismDataNameAtIndex:self.theName :OrganismIndex];
    [TheOptions ReplaceOrganismDataIDsAtIndex:EMPTYSTRING :OrganismIndex];
    
    // check to see if we're now adding again
    if((LocalAttributeIndex+ATTRIBUTEINDEXOFFSET) >= ([TheOptions GetCurrentAttributeDataValueCount]))
    {
        [TheOptions SetPreviousMode:false];
    }
    
    if([TheOptions GetPreviousMode])
    {
        [TheOptions SetAuthorityHasBeenSet:true];
        ////[TheOptions SetPreviousAttribute];
        
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
            
            [appDelegate displayView:OBSERVATIONSVIEW];
        }
        
        if(!Error)
        {
            [TheOptions SetCurrentViewValue:BIOBLITZVIEW];
            [TheOptions SetGoingForward:true];
            [TheOptions SetViewType:TheNextView];
            [appDelegate displayView:TheNextView];
        }
    }
    else
    {
        [appDelegate displayView:NextView];
    }
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
        NSString *orgtype           = [TheOptions GetOrganismDataTypeAtIndex:OrganismIndex];
        NSMutableArray *pl          = [TheOptions GetOrganismPicklistAtIndex:OrganismIndex];
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
// PreviousButton           //
//--------------------------//
// the selected organism is saved in
// the table functions
- (IBAction)PreviousButton:(id)sender
{
    Boolean CollectingSite  = false;
    Boolean CollectingOrg   = false;
    int     PrevView        = [TheOptions GetCurrentViewValue];
    
    ////NSLog(@"ENTER: bioblitz previous");
    ////[TheOptions DumpAttributeDataValues];
    if([TheOptions GetCollectionType]==COLLECTSITE)
    {
        CollectingSite      = true;
    }
    
    int orgindex=[TheOptions GetCurrentOrganismIndex];
    int curattrnum=[TheOptions GetAttributeNumberForCurrentOrganism];
    
    [TheOptions SetPreviousMode:true];
    
    if ( (orgindex==0) && (curattrnum==0))
    {
        // we are going to back up to the authority page
        [TheOptions SetAttributesSet:false];
        [TheOptions SetAuthoritySet:false];
        [TheOptions SetAuthorityHasBeenSet:false];
        [TheOptions SetCurrentOrganismIndex:0];
        [TheOptions SetCurrentAttributeChoiceIndex:0];
        [TheOptions SetCurrentAttributeDataChoicesIndex:0];
        [TheOptions SetCurrentAttributeChoiceCountIndex:0];
        [TheOptions SetCurrentOrganismAttributeIndex:0];
        [TheOptions SetIsNewOrganism:true];
        
        //
        // set up the structures
        //
        ////[TheOptions SetCurrentValues];
    }
    else
    {
        if(PrevView != ADDAUTHORITY)
        {
            [TheOptions SetPreviousAttribute];
        }
    }
    
    
    if([TheOptions GetCollectionType]==COLLECTORGANISM)
    {
        CollectingOrg       = true;
    }
    
    Boolean     Error               = false;
    NSString    *SelectType         = [[NSString alloc] init];
    NSString    *Modifier           = [[NSString alloc] init];
    int         TheNextView         = 0;
    
    if([TheOptions GetAuthoritySet] && (PrevView != ADDAUTHORITY))
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
    
    ////NSLog(@"EXIT:  bioblitz previous");
    ////[TheOptions DumpAttributeDataValues];
    
    if(!Error)
    {
        AppDelegate  *appDelegate   = [[UIApplication sharedApplication] delegate];
        
        [TheOptions SetViewType:TheNextView];
        [appDelegate displayView:TheNextView];
    }
}

//--------------------------//
// CancelButton             //
//--------------------------//
// captures the lat/lon and sets it for the current
// observation
//
-(IBAction)CancelButton:(id)sender
{
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:OBSERVATIONSVIEW];
}
//--------------------------//
// end of buttons           //
//--------------------------//

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
        self = [self initWithNibName:@"Bioblitz_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"Bioblitz" bundle:nil];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [TheOptions SetCurrentViewValue:BIOBLITZVIEW];
    [TheOptions SetNextView:BIOBLITZVIEW];          // for camera
    
    self.Yikes.translucent  = NO;
    self.Yikes.barTintColor = [UIColor blackColor];
    
    CurrentOrganism         = [TheOptions GetCurrentOrganismIndex];
    
    //
    // we need to set up values if we come in backwards or
    // from a previous view
    //
    if([TheOptions GetPreviousMode])
    {
        // set the values and stay in previous mode until we
        // tap continue
        NSString *foo       = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetCurrentOrganismName]];
        
        self.SelectionEnterInput.text = foo;
    }
    
    ////NSLog(@"EXIT:  bioblitz viewWillAppear");
    ////[TheOptions DumpAttributeDataValues];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    TheOptions = [Model SharedModel];
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
