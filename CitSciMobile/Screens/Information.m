//
//  Information.m
//  IBISAreaOfInterest
//
//  Created by lee casuto on 9/1/12.
//  Copyright (c) 2012 leeway software design. All rights reserved.
//

#import "Information.h"
#import "../AppDelegate.h"
#import "../Model/Model.h"


@interface Information ()

@end

@implementation Information
@synthesize Yikes;



//
// get a pointer to all options
//
Model *TheOptions;

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
// HelpButton               //
//--------------------------//
// displays how to use the app
-(IBAction)HelpButton:(int)intNewView
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate displayView:HELPVIEW];
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
        self = [self initWithNibName:@"Information_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"Information" bundle:nil];
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
    
    //
    // application specific stuff
    //
    TheOptions = [Model SharedModel];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        BOOL x = interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
        return (x);
        //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        return YES;
    }
}

@end
