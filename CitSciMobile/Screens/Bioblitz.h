//
//  Bioblitz.h
//  CitSciMobile
//
//  Created by lee casuto on 8/17/15.
//  Copyright (c) 2015 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bioblitz : UIViewController
{
    IBOutlet UITextField            *SelectionEnterInput;
    IBOutlet UITextField            *textField;
    
    NSString                        *theName;
    
    // recover from xcode 5.1
    IBOutlet UIToolbar              *Yikes;
}

@property (nonatomic, retain) IBOutlet UITextField          *SelectionEnterInput;
@property (nonatomic, retain) IBOutlet UITextField          *textField;
@property (nonatomic, retain) NSString                      *theName;
@property (nonatomic, retain) UIToolbar                     *Yikes;

- (IBAction)ContinueButton:(int)intNewView;
- (IBAction)PreviousButton:(id)sender;
- (IBAction)CancelButton:(id)sender;
- (IBAction)SkipButton:(int)intNewView;

@end
