//
//  Help.m
//  CitSciMobile
//
//  Created by lee casuto on 5/30/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import "Help.h"
#import "../AppDelegate.h"

@interface Help ()

@end

@implementation Help
@synthesize Yikes;

//
// The buttons
//
//--------------------------//
// DoneButton               //
//--------------------------//
// Done Button code to get to
// the main view
-(IBAction)DoneButton:(int)intNewView
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:OBSERVATIONSVIEW];
}

//--------------------------//
// AboutUsButton            //
//--------------------------//
// Code to display the about us page
-(IBAction)AboutUsButton:(int)intNewView
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:ABOUTUSVIEW];
}

//--------------------------//
// DeveloperButton          //
//--------------------------//
// Code to display pictures of us
-(IBAction)DeveloperButton:(int)intNewView
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:DEVELOPERSVIEW];
}
//
// end of buttons
//

#pragma mark - View lifecycle
-(id)init
{
    self = [super init];
    
    //
    // set up the xib for iphone 4 or 5 correctly
    //
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //this is iphone 5 xib
        self = [self initWithNibName:@"Help_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"Help" bundle:nil];
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
    
    self.Yikes.translucent              = NO;
    self.Yikes.barTintColor             = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
