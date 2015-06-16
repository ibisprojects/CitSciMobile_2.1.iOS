//
//  AddObservationDateDone.h
//  CitSciMobile
//
//  Created by lee casuto on 4/24/15.
//  Copyright (c) 2015 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddObservationDateDone : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIDatePicker                                   *DatePicker;
    NSMutableArray                                          *CurrentAttributes;
    
    UILabel                                                 *SelectionName;
    UILabel                                                 *TheAttributeNumber;
    UILabel                                                 *TitleName;
    
    IBOutlet UITextField                                    *SelectionEnterDoneInput;
    IBOutlet UITextField                                    *textField;
    
    NSString                                                *theName;
    NSString                                                *theComment;
}

@property(nonatomic,retain) UIDatePicker                    *DatePicker;
@property (nonatomic, retain) IBOutlet UITextField          *SelectionEnterDoneInput;
@property (nonatomic, retain) IBOutlet UILabel              *TheAttributeNumber;
@property (nonatomic, retain) IBOutlet UITextField          *textField;
@property (nonatomic, retain) NSString                      *theName;
@property (nonatomic, retain) NSString                      *theComment;
@property (nonatomic, retain) NSMutableArray                *CurrentAttributes;
@property (nonatomic, retain) IBOutlet UILabel              *SelectionName;
@property (nonatomic, retain) IBOutlet UILabel              *TitleName;

-(IBAction) DoneButton:(int)intNewView;
-(IBAction) CancelButton:(int)intNewView;
-(IBAction)PreviousButton:(int)intNewView;
-(IBAction) SkipButton:(int)intNewView;
-(IBAction) CameraButton:(int)intNewView;

@end
