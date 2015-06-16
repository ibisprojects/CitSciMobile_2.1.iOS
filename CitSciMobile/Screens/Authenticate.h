//
//  Authenticate.h
//  CitSciMobile
//
//  Created by lee casuto on 11/18/14.
//  Copyright (c) 2014 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Authenticate : UIViewController
{
    UIWebView               *webView;                        // login page
    NSString                *Code;
    NSMutableDictionary     *ParameterDictionary;
    NSArray                 *UrlComponents;
    NSString                *FirstTime;
    NSString                *PreviousUser;
}

@property (strong, nonatomic) IBOutlet  UIWebView               *webView;
@property (strong, nonatomic) NSString                          *Code;
@property (strong, nonatomic) NSString                          *FirstTime;
@property (strong, nonatomic) NSString                          *PreviousUser;
@property (strong, nonatomic) NSMutableDictionary               *ParameterDictionary;
@property (strong, nonatomic) NSArray                           *UrlComponents;

-(void)DisplayLoginPage;
-(IBAction)CancelButton:(int)intNewView;
-(void)DoAccessToken;
-(void)FinishAuthenticate;
-(void)GetServerData;
-(void)GetUserProfile;

@end
