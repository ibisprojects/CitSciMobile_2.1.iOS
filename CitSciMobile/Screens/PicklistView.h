//
//  PicklistView.h
//  CitSciMobile
//
//  Created by lee casuto on 5/8/15.
//  Copyright (c) 2015 lee casuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicklistView : UIViewController
{
    NSMutableArray          *PicklistNames;
    NSMutableArray          *PicklistIDs;
}

@property (nonatomic, retain) NSMutableArray            *PicklistNames;
@property (nonatomic, retain) NSMutableArray            *PicklistIDs;

- (IBAction)ContinueButton:(id)sender;

@end
