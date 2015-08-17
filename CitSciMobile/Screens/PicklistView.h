//
//  PicklistView.h
//  CitSciMobile
//
//  Created by lee casuto on 5/8/15.
//  Copyright (c) 2015 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicklistView : UIViewController
{
    NSMutableArray          *PicklistNames;
    NSMutableArray          *PicklistIDs;
    
    IBOutlet UILabel        *PreviousTitle;
    IBOutlet UILabel        *PreviousValue;
    
    // recover from xcode 5.1
    IBOutlet UIToolbar      *Yikes;
}

@property (nonatomic, retain) NSMutableArray            *PicklistNames;
@property (nonatomic, retain) NSMutableArray            *PicklistIDs;
@property (nonatomic, retain) UILabel                   *PreviousTitle;
@property (nonatomic, retain) UILabel                   *PreviousValue;
@property (nonatomic, retain) UIToolbar                 *Yikes;

- (IBAction)ContinueButton:(id)sender;
- (IBAction)PreviousButton:(id)sender;
- (IBAction)CancelButton:(id)sender;
- (IBAction)SkipButton:(int)intNewView;

@end
