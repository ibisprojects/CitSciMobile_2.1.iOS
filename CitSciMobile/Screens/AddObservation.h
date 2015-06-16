//
//  AddObservation.h
//  CitSciMobile
//
//  Created by lee casuto on 1/15/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddObservation : UIViewController
{
    IBOutlet UITextField        *ObservationNameInput;
    IBOutlet UITextField        *CommentInput;
    IBOutlet UITextField        *LatValue;
    IBOutlet UITextField        *LonValue;
    IBOutlet UITextField        *AltValue;
    IBOutlet UITextField        *AccValue;
    NSString                    *theName;
    NSString                    *theComment;
    NSString                    *theLat;
    NSString                    *theLon;
    NSString                    *theAcc;
    NSString                    *theAlt;
}

@property (nonatomic, retain) IBOutlet UITextField          *ObservationNameInput;
@property (nonatomic, retain) IBOutlet UITextField          *CommentInput;
@property (nonatomic, retain) IBOutlet UITextField          *LatValue;
@property (nonatomic, retain) IBOutlet UITextField          *LonValue;
@property (nonatomic, retain) IBOutlet UITextField          *AltValue;
@property (nonatomic, retain) IBOutlet UITextField          *AccValue;
@property (nonatomic, copy) NSString                        *theName;
@property (nonatomic, copy) NSString                        *theComment;
@property (nonatomic, copy) NSString                        *theLat;
@property (nonatomic, copy) NSString                        *theLon;
@property (nonatomic, copy) NSString                        *theAcc;
@property (nonatomic, copy) NSString                        *theAlt;

-(IBAction) ContinueButton:(int)intNewView;
-(IBAction) GPSButton:(int)intNewView;
-(IBAction) CameraButton:(int)intNewView;
-(IBAction) CancelButton:(int)intNewView;

@end
