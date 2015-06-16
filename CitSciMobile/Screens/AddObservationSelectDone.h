//
//  AddObservationSelectDone.h
//  CitSciMobile
//
//  Created by lee casuto on 2/23/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddObservationSelectDone : UIViewController<UITextFieldDelegate>
{
    int                     CurrentOrganismIndex;
    int                     CurrentAttributeIndex;
    int                     CurrentAttributeChoiceCount;
    NSMutableArray          *CurrentAttributes;
    
    IBOutlet UIPickerView   *pickerView;
    UILabel                 *SelectionName;
    UILabel                 *TitleName;
    UILabel                 *TheAttributeNumber;
    
    
    IBOutlet UITextField    *textField;
    
    NSString                *theComment;
}

@property (nonatomic, retain) NSMutableArray                *CurrentAttributes;
@property (nonatomic, retain) IBOutlet UILabel              *SelectionName;
@property (nonatomic, retain) IBOutlet UILabel              *TheAttributeNumber;
@property (nonatomic, retain) IBOutlet UILabel              *TitleName;
@property (nonatomic, retain) UILabel                       *PreviousValue;
@property (nonatomic, retain) IBOutlet UITextField          *textField;
@property (nonatomic, retain) NSString                      *theComment;

-(IBAction)DoneButton:(int)intNewView;
-(IBAction)CancelButton:(int)intNewView;
-(IBAction)PreviousButton:(int)intNewView;
-(IBAction) SkipButton:(int)intNewView;
-(IBAction) CameraButton:(int)intNewView;

@end
