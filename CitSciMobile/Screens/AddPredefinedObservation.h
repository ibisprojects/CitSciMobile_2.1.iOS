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
}

@property (nonatomic, retain) IBOutlet UITextField          *ObservationNameInput;
@property (nonatomic, retain) IBOutlet UITextField          *CommentInput;
@property (nonatomic, retain) UITableView                   *LocationsTable;
@property (nonatomic, retain) NSMutableArray                *LocationNames;
@property (nonatomic, retain) NSMutableArray                *LocationIDs;
@property (nonatomic, copy) NSString                        *theName;
@property (nonatomic, copy) NSString                        *theComment;

-(IBAction) ContinueButton:(int)intNewView;
-(IBAction) CameraButton:(int)intNewView;
-(IBAction) CancelButton:(int)intNewView;

@end
