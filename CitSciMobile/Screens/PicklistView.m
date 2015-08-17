//
//  PicklistView.m
//  CitSciMobile
//
//  Created by lee casuto on 5/8/15.
//  Copyright (c) 2015 lee casuto. All rights reserved.
//

#import "PicklistView.h"
#import "../AppDelegate.h"
#import "../Model/Model.h"
#import "../Utilities/ToastAlert.h"

@interface PicklistView ()

@end

@implementation PicklistView
@synthesize PicklistNames;
@synthesize PicklistIDs;
@synthesize Yikes;
@synthesize PreviousValue;
@synthesize PreviousTitle;

//
// get a pointer to all options
//
Model *TheOptions;

//
// picklist variables
//
static int SelectedOrganismRow = -1;
static int CurrentOrganism;

#pragma mark - buttons
//--------------------------//
// ContinueButton           //
//--------------------------//
// the selected organism is saved in
// the table functions
- (IBAction)ContinueButton:(id)sender
{
    AppDelegate  *appDelegate   = [[UIApplication sharedApplication] delegate];
    int NextView                = [TheOptions GetViewAfterPicklist];
    
    if(SelectedOrganismRow == -1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"You must select an organism"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
        return;
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
            [TheOptions SetCurrentViewValue:PICKLISTVIEW];
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
        NSMutableArray *pl          = [TheOptions GetOrganismPicklistAtIndex:OrganismIndex];
        if(([TheOptions GetIsNewOrganism]) && ([pl count] > 0))
        {
            
            [TheOptions SetViewAfterPicklist:TheNextView];
            [TheOptions SetViewType:TheNextView];
            [appDelegate displayView:PICKLISTVIEW];
            
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.PicklistNames count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    // declarations for the method
    //
    int SelectedOrganism        = (int)indexPath.row;
    SelectedOrganismRow         = SelectedOrganism;     // flag to mark selection
    
    switch(SelectedOrganism)
    {
        default:
            // replace OrganismDataNames objectAtIndex ThisOrganism
            // replace OrganismDataIDs objectAtndex ThisOrganism
            [TheOptions ReplaceOrganismDataNameAtIndex:[self.PicklistNames objectAtIndex:SelectedOrganism] :CurrentOrganism];
            [TheOptions ReplaceOrganismDataIDsAtIndex:[self.PicklistIDs objectAtIndex:SelectedOrganism] :CurrentOrganism];
            //[self.view addSubview: [[ToastAlert alloc] initWithText: @"Selected!"]];
            
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
		cell.accessoryType      = UITableViewCellAccessoryNone;
		cell.selectionStyle     = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.text         = [self.PicklistNames objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"           Select The Organism";
}


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
        self = [self initWithNibName:@"PicklistView_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"PicklistView" bundle:nil];
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
    [super viewWillAppear:animated];
    
    [TheOptions SetCurrentViewValue:PICKLISTVIEW];
    
    self.Yikes.translucent          = NO;
    self.Yikes.barTintColor         = [UIColor blackColor];
    
    self.PicklistNames              = [[NSMutableArray alloc]init];
    self.PicklistIDs                = [[NSMutableArray alloc]init];
    CurrentOrganism                 = [TheOptions GetCurrentOrganismIndex];
    NSMutableArray *CurrentPicklist = [TheOptions GetOrganismPicklistAtIndex:CurrentOrganism];
    long NumChoices = [CurrentPicklist count];
    int i = 0;
    while(i < NumChoices)
    {
        NSString *foo = [[NSString alloc] initWithFormat:@"%@",[CurrentPicklist objectAtIndex:i]];
        [self.PicklistNames addObject:foo];
        foo = [[NSString alloc]initWithFormat:@"%@",[CurrentPicklist objectAtIndex:i+1]];
        [self.PicklistIDs addObject:foo];
        i+=2;
    }
    
    NSString *bar = [TheOptions GetCurrentOrganismName];
    if([bar isEqualToString:NOTYETSET])
    {
        self.PreviousTitle.text     = @"";
        self.PreviousValue.text     = @"";
    }
    else
    {
        self.PreviousTitle.text     = @"Prior choice:";
        self.PreviousValue.text     = [TheOptions GetCurrentOrganismName];
    }
    /*****
    if([TheOptions GetPreviousMode])
    {
        self.PreviousTitle.text     = @"Prior choice:";
        self.PreviousValue.text     = [TheOptions GetCurrentOrganismName];
    }
    else
    {
        self.PreviousTitle.text     = @"";
        self.PreviousValue.text     = @"";
    }
    *****/
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

@end
