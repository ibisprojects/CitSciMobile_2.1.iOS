/*
     File: GetLocationViewController.h
 Abstract: Attempts to acquire a location measurement with a specific level of accuracy. A timeout is used to avoid wasting power in the case where a sufficiently accurate measurement cannot be acquired. Presents a SetupViewController instance so the user can configure the desired accuracy and timeout. Uses a LocationDetailViewController instance to drill down into details for a given location measurement.
 
  Version: 2.2
 
 Apple disclaimer stuff ...
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface GetLocationViewController : UIViewController <CLLocationManagerDelegate> 
{
    CLLocationManager *locationManager;
    CLLocation *bestEffortAtLocation;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;

+(GetLocationViewController *)SharedLocation;

-(void)stopUpdatingLocation:(NSString *)state;

-(void)SetupLocationManager;

@end
