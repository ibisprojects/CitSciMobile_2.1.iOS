//
//  AddAuthority.h
//  CitSciMobile
//
//  Created by lee casuto on 4/18/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAuthority : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    IBOutlet UIPickerView   *pickerView;
    NSMutableArray          *CurrentAuthorities;
    NSMutableArray          *AuthorityFirstNames;
    NSMutableArray          *AuthorityLastNames;
    NSMutableArray          *AuthorityIDs;
    IBOutlet UILabel        *PreviousTitle;
    IBOutlet UILabel        *PreviousValue;
}

@property (nonatomic, retain) NSMutableArray    *CurrentAuthorities;
@property (nonatomic, retain) NSMutableArray    *AuthorityFirstNames;
@property (nonatomic, retain) NSMutableArray    *AuthorityLastNames;
@property (nonatomic, retain) NSMutableArray    *AuthorityIDs;
@property (nonatomic, retain) UILabel           *PreviousTitle;
@property (nonatomic, retain) UILabel           *PreviousValue;

-(IBAction) ContinueButton:(int)intNewView;
-(IBAction) CancelButton:(int)intNewView;
-(IBAction) PreviousButton:(int)intNewView;

@end
