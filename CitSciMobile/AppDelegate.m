//
//  AppDelegate.m
//  CitSciMobile
//
//  Created by lee casuto on 3/10/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Model/Model.h"

@implementation AppDelegate
@synthesize window;
@synthesize viewController;

Boolean AppDelegateDebug=false;
Boolean ShowCoverPage=true;

//
// get a pointer to all options
//
Model *TheOptions;

#pragma -
#pragma - mark Reachability
//
// these methods are not really needed
// they're just here for testing and debugging
// but that was changed to use them to set the
// values in the model, alloptions.
//
#define HOST        0
#define INTERNET    1
#define WIFI        2


- (void) ShowTheValueForEach: (Reachability *) curReach : (int) Who
{
    NSString *TheMessage = [[NSString alloc]init];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch(Who)
    {
        case HOST:
            TheMessage = [TheMessage stringByAppendingString:@"host is "];
            break;
        case INTERNET:
            TheMessage = [TheMessage stringByAppendingString:@"interned is "];
            break;
        case WIFI:
            TheMessage = [TheMessage stringByAppendingString:@"wifi is "];
            break;
    }
    
    switch (netStatus)
    {
        case NotReachable:
        {
            TheMessage = [TheMessage stringByAppendingString:@"Unreachable"];
            [TheOptions SetNetworkStatus:NOTREACHABLE];
            break;
        }
        case ReachableViaWWAN:
        {
            TheMessage = [TheMessage stringByAppendingString:@"Reachable WWAN"];
            [TheOptions SetNetworkStatus:REACHVIAWIFI];
            break;
        }
        case ReachableViaWiFi:
        {
            TheMessage = [TheMessage stringByAppendingString:@"Reachable WiFi"];
            [TheOptions SetNetworkStatus:REACHVIAWWAN];
            break;
        }
    }
    
    if(AppDelegateDebug)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobilet"
                                                        message:TheMessage
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        ////[alert release];
    }
}
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == hostReach)
	{
        //NSLog(@"updating the host field");
		[self ShowTheValueForEach: curReach : HOST];
    }
    
    if(curReach == internetReach)
	{
        [self ShowTheValueForEach:curReach :INTERNET];
	}
	if(curReach == wifiReach)
	{
        [self ShowTheValueForEach:curReach :WIFI];
	}
}

//
// The Reachability class just called us to let us know
// access to the internet changed.  Update AllOptions here
// since the model values will be checked to ascertain
// if networking is available and how.
//
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
    //NSLog(@"Reachability changed");
    if(AppDelegateDebug)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Areas Of Interest"
                                                        message:@"reachabilitychanged called!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        ////[alert release];
    }
}

#pragma -
#pragma - mark utilities
-(void) displayView:(int)intNewView
{
	//printf("appdelegate here displayview :%d\n",intNewView);
	[viewController displayView:intNewView];
}


#undef CONSOLE_LOG
////#define CONSOLE_LOG

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

#ifdef CONSOLE_LOG
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console.log"];
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
#endif
    
    TheOptions = [Model SharedModel];
    [TheOptions ReadOptionsFromFile];
    [TheOptions WriteOptionsToFile];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
        
    //
    // set up the xib for iphone 4 or 5 correctly
    //
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //this is iphone 5 xib
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iphone5" bundle:nil];
    }
    else
    {
        // this is iphone 4 xib
        
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    }
    
    //self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
