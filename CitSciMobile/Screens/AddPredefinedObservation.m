//
//  AddPredefinedObservation.m
//  CitSciMobile
//
//  Created by lee casuto on 3/25/15.
//  Copyright (c) 2015 lee casuto. All rights reserved.
//

#import "AddPredefinedObservation.h"
#import "AddObservationSelect.h"
#import "Camera.h"
#import "../Model/Model.h"
#import "../AppDelegate.h"
#import "../Utilities/MyTableCell.h"

#define LABEL_TAG 1
#define VALUE_TAG 2

@interface AddPredefinedObservation ()

@end

@implementation AddPredefinedObservation
@synthesize ObservationNameInput;
@synthesize CommentInput;
@synthesize theComment;
@synthesize theName;
@synthesize LocationsTable;
@synthesize LocationNames;
@synthesize LocationIDs;
@synthesize Yikes;
@synthesize PreviousTitle;
@synthesize PreviousValue;

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
static int OrganismIndex        = 0;
static int AttributeIndex       = 0;
static int SelectedRow          = -1;

static Boolean ObservationStart = false;
static Boolean DoCamera         = false;

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
    // test observation name and predefined locations before continuing
    //
    Boolean Success         = true;
    Boolean DuplicateName   = true;
    Boolean LegalName       = true;
    Boolean PreviousMode    = [TheOptions GetPreviousMode];
    self.theName            = self.ObservationNameInput.text;
    self.theComment         = self.CommentInput.text;
    
    //
    // set up visit lat/lon/alt/acc for the previous button
    // this is so we don't have to redesign the data structures
    // for attributes.  See more in the "Success" section of
    // this method.
    //
    [TheOptions SetVisitLat:NOTYETSETNUM];
    [TheOptions SetVisitLon:NOTYETSETNUM];
    [TheOptions SetVisitAlt:NOTYETSETNUM];
    [TheOptions SetVisitAcc:NOTYETSETNUM];
    
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
    
    if(SelectedRow == -1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"You must select a predefined location!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
		[alert show];
        Success = false;
    }
    
    //
    // if we've been successful, we need to save a lat/lon altitude
    // and accuracy even though they are not used for predefined
    // locations.  Why? the previous button.  We could go into
    // the code that does all the attribute resetting and ignore
    // the lat/lon/acc/alt if we've come down this path.  But
    // that would be complicated and might break existing functionality.
    // It's much safer and easier to add false values of NOTYETSETNUM.
    //
    if(Success)
    {
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
        NSString *foo;
        if(PreviousMode)
        {
            [TheOptions ReplaceAttributeDataValueAtIndex:MYDATE :MyDate];
            [TheOptions ReplaceAttributeDataValueAtIndex:OBSDATE :ObservationDate];
            [TheOptions ReplaceAttributeDataValueAtIndex:OBSNAME :self.theName];
            [TheOptions ReplaceAttributeDataValueAtIndex:OBSCOMMENT :self.theComment];
            [TheOptions ReplaceAttributeDataValueAtIndex:LATVALUE :NOTYETSETNUM];
            [TheOptions ReplaceAttributeDataValueAtIndex:LONVALUE :NOTYETSETNUM];
            [TheOptions ReplaceAttributeDataValueAtIndex:ALTVALUE :NOTYETSETNUM];
            [TheOptions ReplaceAttributeDataValueAtIndex:ACCVALUE :NOTYETSETNUM];
        }
        else
        {
            [TheOptions ClearCurrentAttributeDataValues];
            [TheOptions SetCurrentAttributeDataValue:MyDate];
            [TheOptions SetCurrentAttributeDataValue:ObservationDate];
            [TheOptions SetCurrentAttributeDataValue:self.theName];
            [TheOptions SetCurrentAttributeDataValue:self.theComment];
            [TheOptions SetCurrentAttributeDataValue:NOTYETSETNUM];
            [TheOptions SetCurrentAttributeDataValue:NOTYETSETNUM];
            [TheOptions SetCurrentAttributeDataValue:NOTYETSETNUM];
            [TheOptions SetCurrentAttributeDataValue:NOTYETSETNUM];
            foo = [[NSString alloc]initWithFormat:@"%@",[LocationNames objectAtIndex:SelectedRow]];
            [TheOptions SetSelectedPredefinedName:foo];
            foo = [[NSString alloc]initWithFormat:@"%@",[LocationIDs objectAtIndex:SelectedRow]];
            [TheOptions SetSelectedPredefinedID:foo];
        }
                
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
    NSString    *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %li", (long)indexPath.row];
	MyTableCell *cell = (MyTableCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    NSString    *str  = [[NSString alloc]init];
    
    if (cell == nil)
	{
        cell = [[MyTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MyIdentifier];
        
        ////[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
		
        // first column location name
		UILabel *label = [[UILabel	alloc] initWithFrame:CGRectMake(0.0, 0, 200.0,//was 0, 0, 120
                                                                    tableView.rowHeight)];
        str=[self.LocationNames objectAtIndex:indexPath.row];
		[cell addColumn:130];       // was 130
		label.tag = LABEL_TAG;
		label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor blueColor];
        
        label.text = [NSString stringWithFormat:@"   %@", str];
        
        label.textAlignment = NSTextAlignmentLeft;
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
		UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:label];
    }
    
    return cell;
    
}

//--------------------------//
// titleForHeaderInSection  //
//--------------------------//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"         Predefined Location Names";
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
    return [self.LocationIDs count];
}


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
        self = [self initWithNibName:@"AddPredefinedObservation_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"AddPredefinedObservation" bundle:nil];
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
    
    // make the table scroll
    self.LocationsTable.bounces=YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.Yikes.translucent  = NO;
    self.Yikes.barTintColor = [UIColor blackColor];
    
    self.LocationNames  = [TheOptions GetPredefinedLocationNames];
    self.LocationIDs    = [TheOptions GetPredefinedLocationIDs];
    
    [self.LocationsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.LocationsTable reloadData];
    });
    
    OrganismIndex   = [TheOptions GetCurrentOrganismIndex];
    AttributeIndex  = [TheOptions GetCurrentAttributeChoiceIndex];
    
    if(ObservationStart)
    {
        NSLog(@"========= ADDOBSERVATION ========");
        NSLog(@"OrganismIndex        = %d",OrganismIndex);
        NSLog(@"AttributeIndex       = %d",AttributeIndex);
    }
    
    if([TheOptions GetPreviousMode])
    {
        NSString *foo;
        self.ObservationNameInput.text   = [TheOptions GetCurrentAttributeDataValueAtIndex:OBSNAME];
        self.CommentInput.text           = [TheOptions GetCurrentAttributeDataValueAtIndex:OBSCOMMENT];
        foo                              = [TheOptions GetCurrentAttributeDataValueAtIndex:LATVALUE];
        foo                              = [TheOptions GetCurrentAttributeDataValueAtIndex:LONVALUE];
        foo                              = [TheOptions GetCurrentAttributeDataValueAtIndex:ALTVALUE];
        foo                              = [TheOptions GetCurrentAttributeDataValueAtIndex:ACCVALUE];
        
        // set the previous choice
        self.PreviousTitle.text          = @"Prior choice:";
        foo                              = [TheOptions GetSelectedPredefinedName];
        self.PreviousValue.text          = foo;
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
static int movementDistance = kOFFSET_FOR_KEYBOARD; // tweak as needed
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
}

- (void)textFieldDidEndEditing:(UITextField *)sender
{
    if ([sender isEqual:self.CommentInput])
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
