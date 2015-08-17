//
//  AddObservationEnterDone.h
//  CitSciMobile
//
//  Created by lee casuto on 2/23/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddObservationEnterDone : UIViewController<UITextFieldDelegate>
{
    int                                                     CurrentOrganismIndex;
    int                                                     CurrentAttributeIndex;
    int                                                     CurrentAttributeChoiceCount;
    NSMutableArray                                          *CurrentAttributes;
    
    UILabel                                                 *SelectionName;
    UILabel                                                 *TheAttributeNumber;
    UILabel                                                 *TitleName;
    UILabel                                                 *TheUnits;
    IBOutlet UITextField                                    *SelectionEnterDoneInput;
    IBOutlet UITextField                                    *textField;
    
    NSString                                                *theName;
    NSString                                                *theComment;
    
    // recover from xcode 5.1
    IBOutlet UIToolbar                                      *Yikes;
}

@property (nonatomic, retain) IBOutlet UITextField          *SelectionEnterDoneInput;
@property (nonatomic, retain) IBOutlet UITextField          *textField;
@property (nonatomic, retain) NSString                      *theName;
@property (nonatomic, retain) NSString                      *theComment;
@property (nonatomic, retain) NSMutableArray                *CurrentAttributes;
@property (nonatomic, retain) IBOutlet UILabel              *SelectionName;
@property (nonatomic, retain) IBOutlet UILabel              *TheAttributeNumber;
@property (nonatomic, retain) IBOutlet UILabel              *TitleName;
@property (nonatomic, retain) IBOutlet UILabel              *TheUnits;
@property (nonatomic, retain) UIToolbar                     *Yikes;

-(IBAction) DoneButton:(int)intNewView;
-(IBAction) CancelButton:(int)intNewView;
-(IBAction)PreviousButton:(int)intNewView;
-(IBAction) SkipButton:(int)intNewView;
-(IBAction) CameraButton:(int)intNewView;

@end
