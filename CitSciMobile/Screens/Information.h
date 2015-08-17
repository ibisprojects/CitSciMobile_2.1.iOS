//
//  Information.h
//  IBISAreaOfInterest
//
//  Created by lee casuto on 9/1/12.
//  Copyright (c) 2012 leeway software design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Information : UIViewController
{
    // recover from xcode 5.1
    IBOutlet UIToolbar                      *Yikes;
}

@property (nonatomic, retain) UIToolbar     *Yikes;

-(IBAction)DoneButton:(int)intNewView;
-(IBAction)HelpButton:(int)intNewView;
-(IBAction)AboutUsButton:(int)intNewView;
-(IBAction)DeveloperButton:(int)intNewView;

@end
