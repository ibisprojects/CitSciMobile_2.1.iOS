//
//  UploadViewController.m
//  CitSciMobile
//
//  Created by lee casuto on 1/10/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import "UploadViewController.h"
#import "../Model/Model.h"
#import "../AppDelegate.h"

NSString *kBadgeValuePrefKey = @"kBadgeValue";

@interface UploadViewController ()

@end

@implementation UploadViewController

//
// get a pointer to all options
//
Model *TheOptions;

#pragma mark - buttons

//
// methods created for this particular implementation
//
//--------------------------//
// ObservationsButton       //
//--------------------------//
// takes the user to the Observations screen
//
-(IBAction)ObservationsButton:(int)intNewView
{
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:OBSERVATIONSVIEW];
}

//--------------------------//
// SetProjectButton         //
//--------------------------//
// takes the user to the SetProject screen
//
-(IBAction)SetProjectButton:(int)intNewView
{
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:PROJECTSTABLE];
}

//--------------------------//
// UploadButton             //
//--------------------------//
// takes the user to the Upload screen
//
-(IBAction)UploadButton:(int)intNewView
{
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:UPLOAD];
}

//--------------------------//
// SettingsButton           //
//--------------------------//
// takes the user to the Upload screen
//
-(IBAction)SettingsButton:(int)intNewView
{
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:USERDATA];
}

@synthesize badgeField;
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
        self = [self initWithNibName:@"UploadViewController_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"UploadViewController" bundle:nil];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Upload", @"Upload");
        self.tabBarItem.image = [UIImage imageNamed:@"arrowup"];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UITabBarItem *tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:2];
    
    // this line clears it out
    tabBarItem.badgeValue = 0;
    
    // this line sets it to a value
    //tabBarItem.badgeValue = @"10";
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
