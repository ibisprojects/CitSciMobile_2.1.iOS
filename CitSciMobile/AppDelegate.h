//
//  AppDelegate.h
//  CitSciMobile
//
//  Created by lee casuto on 3/10/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities/Reachability.h"

#define OBSERVATIONSVIEW                        1
#define ADDOBSERVATION                          2
#define ADDOBSERVATIONSELECT                    3
#define ADDOBSERVATIONSELECTDONE                4
#define ADDOBSERVATIONENTER                     5
#define ADDOBSERVATIONENTERDONE                 6
#define INFORMATION                             7
#define PROJECTS                                8
#define UPLOAD                                  9
#define USERDATA                                10
#define ADDAUTHORITY                            11
#define ADDATTRIBUTELOOP                        12
#define CAMERAVIEW                              13
#define INFORMATIONSCROLL                       14
#define HELPVIEW                                15
#define ABOUTUSVIEW                             16
#define DEVELOPERSVIEW                          17
#define PROJECTSTABLE                           18
#define FORMSTABLE                              19
#define AUTHENTICATEVIEW                        20
#define ADDPREDEFINEDOBSERVATION                21
#define ADDOBSERVATIONDATE                      22
#define ADDOBSERVATIONDATEDONE                  23
#define ADDOBSERVATIONSTRING                    24
#define ADDOBSERVATIONSTRINGDONE                25
#define PICKLISTVIEW                            26


@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow                            *window;
	ViewController                      *viewController;
    Reachability                        *hostReach;
    Reachability                        *internetReach;
    Reachability                        *wifiReach;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

-(void) displayView:(int)intNewView;
-(void) reachabilityChanged:(NSNotification *)note;


@end
