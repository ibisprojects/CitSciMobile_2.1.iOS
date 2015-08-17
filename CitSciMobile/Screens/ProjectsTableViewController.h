//
//  ProjectsTableViewController.h
//  CitSciMobile
//
//  Created by lee casuto on 12/25/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectsTableViewController : UIViewController
{
    NSMutableArray          *ProjectNames;
    NSMutableArray          *ProjectIDs;
    NSString                *VisitToDelete;
    NSMutableArray          *GoneVisits;
    NSMutableArray          *UploadAllErrors;
    
    // recover from xcode 5.1
    IBOutlet UIToolbar      *Yikes;
}

@property (nonatomic, retain) NSMutableArray                *ProjectNames;
@property (nonatomic, retain) NSMutableArray                *ProjectIDs;
@property (nonatomic, retain) NSMutableArray                *GoneVisits;
@property (nonatomic, retain) NSMutableArray                *UploadAllErrors;
@property (nonatomic, retain) NSString                      *VisitToDelete;
@property (nonatomic, retain) UIToolbar                     *Yikes;

-(IBAction) ObservationsButton:(int)intNewView;
-(IBAction) SetProjectButton:(int)intNewView;
-(IBAction) UploadButton:(int)intNewView;
-(IBAction) SettingsButton:(int)intNewView;
-(void) FinishUpload;

@end
