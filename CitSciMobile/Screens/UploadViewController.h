//
//  UploadViewController.h
//  CitSciMobile
//
//  Created by lee casuto on 1/10/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController <UITextFieldDelegate>
{
    
}

@property (nonatomic, retain) IBOutlet UITextField *badgeField;

-(IBAction) ObservationsButton:(int)intNewView;
-(IBAction) SetProjectButton:(int)intNewView;
-(IBAction) UploadButton:(int)intNewView;
-(IBAction) SettingsButton:(int)intNewView;

@end
