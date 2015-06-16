//
//  FormsTableViewController.h
//  CitSciMobile
//
//  Created by lee casuto on 12/26/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormsTableViewController : UIViewController
{
    NSMutableArray          *FormNames;
    NSMutableArray          *FormIDs;
}

@property (nonatomic, retain) NSMutableArray                *FormNames;
@property (nonatomic, retain) NSMutableArray                *FormIDs;

-(IBAction) BackButton:(int)intNewView;
-(IBAction) ObservationsButton:(int)intNewView;
-(IBAction) SetProjectButton:(int)intNewView;
-(IBAction) UploadButton:(int)intNewView;
-(IBAction) SettingsButton:(int)intNewView;

@end
