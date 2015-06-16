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
    if(SelectedOrganismRow == -1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"You must select an organism"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        ////[TheOptions DumpAttributeData];
        AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
        int NextView = [TheOptions GetViewAfterPicklist];
        [appDelegate displayView:NextView];
    }
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
