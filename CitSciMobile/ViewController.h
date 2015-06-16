//
//  ViewController.h
//  CitSciMobile
//
//  Created by lee casuto on 3/10/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    UIViewController  *currentView;
}

@property (nonatomic, retain) UIViewController *currentView;

- (void) displayView:(int)intNewView;

@end
