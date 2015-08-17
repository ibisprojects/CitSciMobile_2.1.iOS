//
//  AddPredefinedObservation.h
//  CitSciMobile
//
//  Created by lee casuto on 3/25/15.
//  Copyright (c) 2015 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPredefinedObservation : UIViewController
{
    IBOutlet UITextField        *ObservationNameInput;
    IBOutlet UITextField        *CommentInput;
    IBOutlet UITableView        *LocationsTable;
    NSString                    *theName;
    NSString                    *theComment;
    NSMutableArray              *LocationNames;
    NSMutableArray              *LocationIDs;
    
    IBOutlet UILabel            *PreviousTitle;
    IBOutlet UILabel            *PreviousValue;
    
    // recover from xcode 5.1
    IBOutlet UIToolbar          *Yikes;
}

@property (nonatomic, retain) IBOutlet UITextField          *ObservationNameInput;
@property (nonatomic, retain) IBOutlet UITextField          *CommentInput;
@property (nonatomic, retain) UITableView                   *LocationsTable;
@property (nonatomic, retain) NSMutableArray                *LocationNames;
@property (nonatomic, retain) NSMutableArray                *LocationIDs;
@property (nonatomic, copy) NSString                        *theName;
@property (nonatomic, copy) NSString                        *theComment;
@property (nonatomic, retain) UILabel                       *PreviousTitle;
@property (nonatomic, retain) UILabel                       *PreviousValue;
@property (nonatomic, retain) UIToolbar                     *Yikes;

-(IBAction) ContinueButton:(int)intNewView;
-(IBAction) CameraButton:(int)intNewView;
-(IBAction) CancelButton:(int)intNewView;

@end
