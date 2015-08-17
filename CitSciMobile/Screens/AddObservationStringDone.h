//
//  AddObservationStringDone.h
//  CitSciMobile
//
//  Created by lee casuto on 4/24/15.
//  Copyright (c) 2015 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddObservationStringDone : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    int                                                     CurrentOrganismIndex;
    int                                                     CurrentAttributeIndex;
    int                                                     CurrentAttributeChoiceCount;
    NSMutableArray                                          *CurrentAttributes;
    
    UILabel                                                 *SelectionName;
    UILabel                                                 *TheAttributeNumber;
    UILabel                                                 *TitleName;
    IBOutlet UITextView                                     *SelectionEnterDoneInput;
    IBOutlet UITextField                                    *textField;
    
    NSString                                                *theName;
    NSString                                                *theComment;
    
    // recover from xcode 5.1
    IBOutlet UIToolbar                                      *Yikes;
}

@property (nonatomic, retain) IBOutlet UITextView           *SelectionEnterDoneInput;
@property (nonatomic, retain) IBOutlet UITextField          *textField;
@property (nonatomic, retain) NSString                      *theName;
@property (nonatomic, retain) NSString                      *theComment;
@property (nonatomic, retain) NSMutableArray                *CurrentAttributes;
@property (nonatomic, retain) IBOutlet UILabel              *SelectionName;
@property (nonatomic, retain) IBOutlet UILabel              *TheAttributeNumber;
@property (nonatomic, retain) IBOutlet UILabel              *TitleName;
@property (nonatomic, retain) UIToolbar                     *Yikes;


-(IBAction)CancelButton:(int)intNewView;
-(IBAction)PreviousButton:(int)intNewView;
-(IBAction) SkipButton:(int)intNewView;
-(IBAction) CameraButton:(int)intNewView;

@end
