//
//  UserData.h
//  CitSciMobile
//
//  Created by lee casuto on 12/5/12.
//  Copyright (c) 2012 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserData : UIViewController <UIActionSheetDelegate>
{
    NSMutableArray          *arraySystems;
    IBOutlet UITextField    *NameInput;
	IBOutlet UITextField    *PassInput;
    IBOutlet UITextField    *NameInputLandscape;
	IBOutlet UITextField    *PassInputLandscape;
    NSString                *theName;
    NSString                *thePass;
    UILabel                 *SelectedServer;
    UILabel                 *SelectedServerLandscape;
    UILabel                 *SelectedUserName;
    UILabel                 *SelectedUserNameLandscape;
    
    NSString                *VisitToDelete;
    NSMutableArray          *GoneVisits;
    NSMutableArray          *UploadAllErrors;
}

@property (nonatomic, copy) NSString                        *theName;
@property (nonatomic, copy) NSString                        *thePass;
@property (nonatomic, retain) IBOutlet UITextField          *NameInput;
@property (nonatomic, retain) IBOutlet UITextField          *PassInput;
@property (nonatomic, retain) IBOutlet UITextField          *NameInputLandscape;
@property (nonatomic, retain) IBOutlet UITextField          *PassInputLandscape;
@property (nonatomic, retain) IBOutlet UILabel              *SelectedServer;
@property (nonatomic, retain) IBOutlet UILabel              *SelectedServerLandscape;
@property (nonatomic, retain) IBOutlet UILabel              *SelectedUserName;
@property (nonatomic, retain) IBOutlet UILabel              *SelectedUserNameLandscape;
@property (nonatomic, retain) NSMutableArray                *GoneVisits;
@property (nonatomic, retain) NSMutableArray                *UploadAllErrors;
@property (nonatomic, retain) NSString                      *VisitToDelete;

-(IBAction)SaveButton:(int)intNewView;
-(IBAction)SelectServerButton:(int)intNewView;
-(IBAction)CancelButton:(int)intNewView;
-(IBAction)AuthenticateButton:(int)intNewView;
-(void)GetProjects;

-(IBAction) ObservationsButton:(int)intNewView;
-(IBAction) SetProjectButton:(int)intNewView;
-(IBAction) UploadButton:(int)intNewView;
-(IBAction) SettingsButton:(int)intNewView;

-(void) FinishUpload;

-(void)Dismiss;
-(void)CheckGetServerData;

@end
