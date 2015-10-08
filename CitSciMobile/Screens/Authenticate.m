//
//  Authenticate.m
//  CitSciMobile
//
//  Created by lee casuto on 11/18/14.
//  Copyright (c) 2014 lee casuto. All rights reserved.
//

#import "Authenticate.h"
#import "../Model/Model.h"
#import "../AppDelegate.h"

@interface Authenticate ()

@end

@implementation Authenticate
@synthesize webView;
@synthesize Code;
@synthesize ParameterDictionary;
@synthesize UrlComponents;
@synthesize FirstTime;
@synthesize PreviousUser;
@synthesize Yikes;


//
// get a pointer to all options
//
Model *TheOptions;

//
// activity indicator
//
UIActivityIndicatorView *activityView;

#pragma mark -
#pragma mark utilities
-(void)DoAccessToken
{
    [TheOptions GenAccessToken];
    
    // wait here for genaccesstoken
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUserProfile) name:@"genaccesstoken" object:nil];
}

-(void)GetUserProfile
{
    [TheOptions GetUserProfile];
    
    // wait here for getuserprofile
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetServerData) name:@"getuserprofile" object:nil];
}

-(void)GetServerData
{
    // start the activity monitor again for server access
    activityView            = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect screenRect       = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth     = screenRect.size.width;
    CGFloat screenHeight    = screenRect.size.height;
    activityView.color      = [UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:1.0];
    activityView.color      = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    activityView.center     = CGPointMake((screenWidth / 2.0), (screenHeight / 2.0));
    [self.view addSubview:activityView];
    [activityView startAnimating];
    
    // set up the new/different user
    // copy in the options file and read current options
    [TheOptions ChangeUser];
    [TheOptions ReadOptionsFromFile];
    
    // replace the old token values with the current values
    [TheOptions SetAccessToken:[TheOptions GetSavedAccessToken]];
    [TheOptions SetRefreshToken:[TheOptions GetSavedRefreshToken]];
    [TheOptions SetExpires:[TheOptions GetSavedExpires]];
    
    // save the options
    [TheOptions WriteOptionsToFile];
    
    // get projects and forms from the server
    NSString *foo = [TheOptions GetFirstInvocationRev21];
    if([foo isEqualToString:NOTYETSET])
    {
        [TheOptions DoGetProjectsAndForms];
        // wait for it to get done
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FinishAuthenticate) name:@"getprojectsandforms" object:nil];
    }
    else
    {
        [self FinishAuthenticate];
    }
}

-(void)FinishAuthenticate
{
    //
    // 1. stop the activity monitor
    // 2. if the project or form is not set
    //    a. display the projects page
    //    b. otherwise display the add observation page
    //
    
    //
    // turn off monitor
    //
    [activityView stopAnimating];
    activityView.hidden       = true;
    
    ////[TheOptions ChangeUser];
    
    [TheOptions SetFirstInvocationRev21:NOWSET];
    [TheOptions WriteOptionsToFile];
    
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if(([[TheOptions GetCurrentProjectName]isEqualToString:NOTYETSET]) ||
       ([[TheOptions GetCurrentFormName]isEqualToString:NOTYETSET]))
    {
        [appDelegate displayView:PROJECTSTABLE];
    }
    else
    {
        [appDelegate displayView:OBSERVATIONSVIEW];
    }
}

#pragma mark -
#pragma mark buttons
-(IBAction)CancelButton:(int)intNewView
{
    if(!([self.PreviousUser isEqualToString:NOTYETSET]))
    {
        [TheOptions SetUserName:self.PreviousUser];
        [TheOptions ChangeUser];
    }
    
    AppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate displayView:USERDATA];
}

#pragma mark -
#pragma mark Open Authentication methods
//
// Displays the login page (duh) and allows the
// user to select allow or deny access to the
// citsci website API's.
//
// Encode the URL using the defines above and
// execute a UIWebView to show the page.  When the
// webview finishes loading, it automatically calls
// the webViewDidFinishLoading method.
//
-(void)DisplayLoginPage
{
    //
    // construct the URL
    //
    NSString *UnencodedURL      = OAUTH_URL;
    UnencodedURL                = [UnencodedURL stringByAppendingString:@"?redirect_uri="];
    UnencodedURL                = [UnencodedURL stringByAppendingString:REDIRECT_URI];
    UnencodedURL                = [UnencodedURL stringByAppendingString:@"&response_type=code&client_id="];
    UnencodedURL                = [UnencodedURL stringByAppendingString:CLIENT_ID];
    UnencodedURL                = [UnencodedURL stringByAppendingString:@"&scope="];
    UnencodedURL                = [UnencodedURL stringByAppendingString:OAUTH_SCOPE];
    
    //
    // encode it - this does not always work for URL encoding, but it works fine for this URL
    // so no need to complicate matters.  If you need to encode the URL, check the web.  It's
    // not complicated, but it is tedious.  NB.  There is not URLEncode method in iOS.
    //
    NSString *FinalURL          = [UnencodedURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    //
    // create the object and request for the web view
    //
    NSURL *url                  = [NSURL URLWithString:FinalURL];
    NSURLRequest *requestObj    = [NSURLRequest requestWithURL:url];
    
    //
    // start the acitvity monitor
    //
    activityView            = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect screenRect       = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth     = screenRect.size.width;
    CGFloat screenHeight    = screenRect.size.height;
    activityView.color      = [UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:1.0];
    activityView.color      = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    activityView.center     = CGPointMake((screenWidth / 2.0), (screenHeight / 2.0));
    [self.view addSubview:activityView];

    
    //
    // load the request
    //
    [self.webView loadRequest:requestObj];
    
    // wait here for webDidFinishLoad
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoAccessToken) name:@"webfinishedload" object:nil];
}

//
// webViewDidFinishLoad is called whenever the load is complete (duh).
// Most of the time, what happens here is ignored.  But if the current
// URL contains the word "code" as a parameter, we take special action.
// That special action is to save the code value so we can next get the
// access and refresh tokens for the authentication by calling GenAccessToken.
//
// The only way this method gets called is when DisplayLoginPage completes
// successfully
//
- (void)webViewDidFinishLoad:(UIWebView *)TheWebView
{
    //
    // turn off monitor
    //
    [activityView stopAnimating];
    activityView.hidden                             = true;
    
    NSString                *currentURL             = self.webView.request.URL.absoluteString;
    NSURL                   *url                    = [NSURL URLWithString:currentURL];
    
    self.Code                                       = @"code";
    NSRange                 range                   = [currentURL rangeOfString:Code];
    NSString                *Query;
    ParameterDictionary                             = [[NSMutableDictionary alloc]init];
        
    if(range.location != NSNotFound)                // found "code"
    {
        Query = [url query];
        
        for (NSString *param in [Query componentsSeparatedByString:@"&"])
        {
            UrlComponents = [param componentsSeparatedByString:@"="];
            NSString *key = [UrlComponents objectAtIndex:0];
            NSString *val = [UrlComponents objectAtIndex:1];
            [ParameterDictionary setObject:val forKey:key];
        }
    
        [TheOptions SetCode:[ParameterDictionary objectForKey:Code]];
        
        //
        // post notification that web is finished
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:@"webfinishedload" object:nil];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                    message:@"webview error"
                                                   delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    
    NSLog(@"webview error: %@",error);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityView startAnimating];
}

#pragma mark - view life cycle
-(id)init
{
    self = [super init];
    
    //
    // set up the xib for iphone 4 or 5 correctly
    //
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //this is iphone 5 xib
        self = [self initWithNibName:@"Authenticate_iphone5" bundle:nil];
        
    }
    else
    {
        // this is iphone 4 xib
        self = [self initWithNibName:@"Authenticate" bundle:nil];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    TheOptions          = [Model SharedModel];
    self.FirstTime      = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetFirstInvocationRev21]];
    self.PreviousUser   = [[NSString alloc]initWithFormat:@"%@",[TheOptions GetUserName]];
    [TheOptions SetWriteOptionsFile:false];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.Yikes.translucent              = NO;
    self.Yikes.barTintColor             = [UIColor blackColor];
    
    if([self.FirstTime isEqualToString:NOTYETSET])
    {
        self.PreviousUser = NOTYETSET;
        ////[TheOptions SetCurrentProjectName:NOTYETSET];
        ////[TheOptions SetCurrentProjectID:NOTYETSET];
        ////[TheOptions SetCurrentFormName:NOTYETSET];
        ////[TheOptions SetCurrentFormID:NOTYETSET];
    }
    else
    {
        // save the current user in case
        // we need to recover from cancel button
        self.PreviousUser = [TheOptions GetUserName];
    }
    
    // nuke all the saved fields for the options file
    // and save it
    [TheOptions SetUserName:@""];
    
    ////[TheOptions WriteOptionsToFile];
    
    /********
    // save the current user if there is one
    if(!([[TheOptions GetUserName] isEqualToString:@""]))
    {
        [TheOptions ChangeUser];
        NSLog(@"current user is: %@",[TheOptions GetUserName]);
    }
    else
    {
        // nuke all the saved fields for the options file
        // and save it
        [TheOptions SetUserName:@""];
        [TheOptions SetCurrentProjectName:NOTYETSET];
        [TheOptions SetCurrentProjectID:NOTYETSET];
        [TheOptions SetCurrentFormName:NOTYETSET];
        [TheOptions SetCurrentFormID:NOTYETSET];
        [TheOptions WriteOptionsToFile];
    }
    *********/
    
    [self DisplayLoginPage];
}

@end
