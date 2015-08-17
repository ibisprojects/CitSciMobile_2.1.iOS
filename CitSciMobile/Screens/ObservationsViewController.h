//
//  ObservationsViewController.h
//  CitSciMobile
//
//  Created by lee casuto on 1/9/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubLevelViewController;

@interface ObservationsViewController : UIViewController
{
    IBOutlet UITableView        *VisitsTable;
    
    // form and project variables
    UILabel                     *ProjectNamePortrait;
    UILabel                     *FormNamePortrait;
    UILabel                     *UserNamePortrait;
    
    // server variables
    UILabel                     *ServerNamePortrait;
    
    NSString                    *VisitToDelete;
    NSMutableArray              *GoneVisits;
    NSMutableArray              *UploadAllErrors;
    
    // recover from xcode 5.1
    IBOutlet UIToolbar          *Yikes;
    IBOutlet UIToolbar          *BottomYikes;
}

@property (nonatomic, retain) UITableView                       *VisitsTable;
@property (nonatomic, retain) NSMutableArray                    *GoneVisits;
@property (nonatomic, retain) NSMutableArray                    *UploadAllErrors;
@property (nonatomic, retain) UIToolbar                         *Yikes;
@property (nonatomic, retain) UIToolbar                         *BottomYikes;
@property (nonatomic, retain) IBOutlet UILabel                  *ProjectNamePortrait;
@property (nonatomic, retain) IBOutlet UILabel                  *FormNamePortrait;
@property (nonatomic, retain) IBOutlet UILabel                  *UserNamePortrait;
@property (nonatomic, retain) IBOutlet UILabel                  *ServerNamePortrait;
@property (nonatomic, retain) IBOutlet NSString                 *VisitToDelete;



-(IBAction) AddButton:(int)intNewView;
-(IBAction) InformationButton:(int)intNewView;
-(IBAction) ObservationsButton:(int)intNewView;
-(IBAction) SetProjectButton:(int)intNewView;
-(IBAction) UploadButton:(int)intNewView;
-(IBAction) SettingsButton:(int)intNewView;
-(IBAction) DeleteButton:(int)intNewView;
-(IBAction) EditButton:(int)intNewView;
-(IBAction) UploadOneButton:(int)intNewView;
-(void) UploadCleanup;
-(void) FinishUpload;
-(void) UploadThisVisit:(int)TheIndex;

@end
