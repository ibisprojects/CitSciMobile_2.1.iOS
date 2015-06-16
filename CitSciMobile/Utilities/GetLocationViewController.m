/*
     File: GetLocationViewController.m
 Abstract: Attempts to acquire a location measurement with a specific level of accuracy. A timeout is used to avoid wasting power in the case where a sufficiently accurate measurement cannot be acquired. Presents a SetupViewController instance so the user can configure the desired accuracy and timeout. Uses a LocationDetailViewController instance to drill down into details for a given location measurement.
 
  Version: 2.2
 
 Apple disclaimer stuff...
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

//
// lkc - make this a singleton so the variables are the same
//

#import "GetLocationViewController.h"
#import "../Model/Model.h"
#import "../AppDelegate.h"


@implementation GetLocationViewController

@synthesize locationManager;
@synthesize bestEffortAtLocation;

BOOL Acquired   = NO;
BOOL BestEffort = NO;

//
// get a pointer to all options
//
Model *TheOptions;

//
// declaration for spinner
//
UIActivityIndicatorView *TheActivity;

static GetLocationViewController* _SharedLocation=nil;

CLLocation *SavedLocation;

// singleton declarartion
+(GetLocationViewController*)SharedLocation
{
	@synchronized([GetLocationViewController class])
	{
		if (!_SharedLocation)
		{
			_SharedLocation = [[self alloc] init];
		}
		return _SharedLocation;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([GetLocationViewController class])
	{
		NSAssert(_SharedLocation==nil, @"attempted second allocation.");
		_SharedLocation = [super alloc];
		return _SharedLocation;
	}
	
	return nil;
}

-(id)init
{
	self = [super init];
	if (self != nil)
	{
        //NSLog(@"*********ALLOC CALLED***********");
		// initialization here
        locationManager         = nil;
        bestEffortAtLocation    = nil;
        BestEffort              = YES;
        TheOptions = [Model SharedModel];
	}
	
	return self;
}

//
// this method is called when the "Start" button is pressed from 
// add{point,polyline,polygon}view is called.  LocateMe only 
// calls this once and sets it up once per location access.  LocateMe
// cleans up after itself so this must as well.
// 
-(void)SetupLocationManager
{
    double Delay    = [TheOptions GetDelay];
    double Accuracy = [TheOptions GetAccuracy];
    
    TheActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [TheActivity setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)]; // in landscape mode
    [self.view addSubview:TheActivity]; // spinner is not visible until started
    [TheActivity startAnimating];
    /////[TheActivity release];
    
    // Create the manager object 
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    // This is the most important property to set for the manager. It ultimately determines 
    // how the manager will  attempt to acquire location and thus, the amount of power that 
    // will be consumed.
    // dsired accuracy is in meters.  a -1.0 value means get the best
    // possible value.
    locationManager.desiredAccuracy = Accuracy;
    Acquired = [TheOptions GetAcquired];
    //NSLog(@"SetupLocationManager: Acquired = %d",Acquired);
    
    // Once configured, the location manager must be "started".
    dispatch_async(dispatch_get_main_queue(), ^{
        [locationManager startUpdatingLocation];
    });
    
    //[locationManager startUpdatingLocation];
    
    if(!Acquired)
    {
        //NSLog(@"SetupLocationManager: Timed out in setuplocationmanager");
        [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:Delay];
    }
    else
    {
        //NSLog(@"SetupLocationManager: Acquired");
        [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Acquired" afterDelay:Delay];
    }
}

- (void)dealloc {
    
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


#pragma mark Location Manager Interactions 

/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    CLLocation *oldLocation;
    if (locations.count > 1) {
        oldLocation = [locations objectAtIndex:locations.count-2];
    } else {
        oldLocation = nil;
    }
    
    BOOL SkipAccuracy   = NO;
    Acquired            = NO;
    BestEffort          = [TheOptions GetBestEffort];
    double Accuracy     = [TheOptions GetAccuracy];
    //NSLog(@"inside didupdatelocation& betseffort = %d",BestEffort);
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    ////NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    ////if (locationAge > 5.0) return;
    //NSLog(@"made it past age");
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    //NSLog(@"made it past accuracy");
    // test the measurement to see if it is more accurate than the previous measurement
    //if(1)               // always true
    BestEffort = [TheOptions GetBestEffort];
    if (!BestEffort)
    {
        if (newLocation.horizontalAccuracy > Accuracy)
        {
            SkipAccuracy = NO;
        }
        else
        {
            SkipAccuracy = YES;
        }
    }
    else
    {
        SkipAccuracy = (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy);
    }
    if (SkipAccuracy)
    {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        //NSLog(@"Skip accuracy or reached accuracy");
        // we have a measurement that meets our requirements, so we can stop updating the location
        //
        // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
        //
        [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
        Acquired = YES;
        SavedLocation = newLocation;
        //NSLog(@"lat = %lf",SavedLocation.coordinate.latitude);
        
        NSString *lat = [[NSString alloc] initWithFormat:@"%lf",SavedLocation.coordinate.latitude];
        NSString *lon = [[NSString alloc] initWithFormat:@"%lf",SavedLocation.coordinate.longitude];
        NSString *acc = [[NSString alloc] initWithFormat:@"%lf",SavedLocation.horizontalAccuracy];
        NSString *alt = [[NSString alloc] initWithFormat:@"%lf",SavedLocation.altitude];
        
        
        [TheOptions SetVisitLat:lat];
        [TheOptions SetVisitLon:lon];
        [TheOptions SetVisitAcc:acc];
        [TheOptions SetVisitAlt:alt];
        [TheOptions SetAcquired:YES];
        
        [TheOptions SetBestEffort:NO];
        
        // post notification that we're done
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pointfound" object:nil];
        // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
    }
}

/***********
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    BOOL SkipAccuracy   = NO;
    Acquired            = NO;
    BestEffort          = [TheOptions GetBestEffort];
    double Accuracy     = [TheOptions GetAccuracy];
    //NSLog(@"inside didupdatelocation& betseffort = %d",BestEffort);
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    ////NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    ////if (locationAge > 5.0) return;
    //NSLog(@"made it past age");
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    //NSLog(@"made it past accuracy");
    // test the measurement to see if it is more accurate than the previous measurement
    //if(1)               // always true
    BestEffort = [TheOptions GetBestEffort];
    if (!BestEffort)
    {
        if (newLocation.horizontalAccuracy > Accuracy)
        {
            SkipAccuracy = NO;
        }
        else
        {
            SkipAccuracy = YES;
        }
    }
    else
    {
        SkipAccuracy = (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy);
    }
    if (SkipAccuracy) 
    {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        //NSLog(@"Skip accuracy or reached accuracy");
        // we have a measurement that meets our requirements, so we can stop updating the location
        // 
        // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
        //
        [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
        Acquired = YES;
        SavedLocation = newLocation;
        //NSLog(@"lat = %lf",SavedLocation.coordinate.latitude);

        NSString *lat = [[NSString alloc] initWithFormat:@"%lf",SavedLocation.coordinate.latitude];
        NSString *lon = [[NSString alloc] initWithFormat:@"%lf",SavedLocation.coordinate.longitude];
        NSString *acc = [[NSString alloc] initWithFormat:@"%lf",SavedLocation.horizontalAccuracy];
        NSString *alt = [[NSString alloc] initWithFormat:@"%lf",SavedLocation.altitude];

        
        [TheOptions SetVisitLat:lat];
        [TheOptions SetVisitLon:lon];
        [TheOptions SetVisitAcc:acc];
        [TheOptions SetVisitAlt:alt];
        [TheOptions SetAcquired:YES];
        
        [TheOptions SetBestEffort:NO];
        
        // post notification that we're done
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pointfound" object:nil];
        // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
    }
}
***************/

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    //NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
}

- (void)stopUpdatingLocation:(NSString *)state 
{
    Boolean ShowMessage=true;
    //NSLog(@"stop updating:%@",state);
    [locationManager stopUpdatingLocation]; 
    [TheOptions SetLocationSearch:YES];
    locationManager.delegate = nil;
    [TheActivity stopAnimating];
    
    ShowMessage = [TheOptions GetErrorMessage];
    
    if([state isEqualToString:@"Timed Out"])
    {
        ShowMessage=true;
    }
    if(ShowMessage)
    {
        if(![TheOptions GetAcquired])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile Getlocation"
                                                    message:@"The location was not acquired.  Please try again"
                                                   delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
            [alert show];
        }
    }
}

@end
