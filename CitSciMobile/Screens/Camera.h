//
//  Camera.h
//  CitSciMobile
//
//  Created by lee casuto on 5/17/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Camera : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //
    // orientation stuff
    //
    IBOutlet UIView             *PortraitView;
    IBOutlet UIView             *LandscapeView;
    IBOutlet UIImageView        *imageView;
    
    UIDeviceOrientation         orientation;
}

@property(nonatomic,retain)IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIView            *PortraitView;
@property (nonatomic, retain) UIView            *LandscapeView;

-(IBAction)showCameraAction:(id)sender;
-(IBAction)doneImageAction:(id)sender;
-(UIImage *)Scrunch:(UIImage *)Original;

@end
