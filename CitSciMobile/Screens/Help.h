//
//  Help.h
//  CitSciMobile
//
//  Created by lee casuto on 5/30/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Help : UIViewController
{
    // recover from xcode 5.1
    IBOutlet UIToolbar                      *Yikes;
}

@property (nonatomic, retain) UIToolbar     *Yikes;

-(IBAction)DoneButton:(int)intNewView;
-(IBAction)AboutUsButton:(int)intNewView;
-(IBAction)DeveloperButton:(int)intNewView;

@end
