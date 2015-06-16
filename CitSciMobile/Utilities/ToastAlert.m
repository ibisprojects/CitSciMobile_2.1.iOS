//
//  ToastAlert.m
//  TheBottomLine
//
//  Created by lee casuto on 12/23/13.
//  Copyright (c) 2013 lee casuto. All rights reserved.
//

#import "ToastAlert.h"
#import <QuartzCore/QuartzCore.h>

#define POPUP_DELAY  1.5

@implementation ToastAlert

- (id)initWithText: (NSString *) msg
{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.textColor = [UIColor colorWithWhite:1 alpha: 0.95];
        self.font = [UIFont fontWithName: @"Helvetica-Bold" size: 13];
        self.text = msg;
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (void)didMoveToSuperview {
    
    UIView* parent = self.superview;
    
    if(parent) {
        
        CGSize maximumLabelSize = CGSizeMake(300, 200);
        CGSize expectedLabelSize = [self.text sizeWithFont: self.font  constrainedToSize:maximumLabelSize lineBreakMode: NSLineBreakByTruncatingTail];
        
        expectedLabelSize = CGSizeMake(expectedLabelSize.width + 120, expectedLabelSize.height + 110);
        
        self.frame = CGRectMake(parent.center.x - expectedLabelSize.width/2,
                                parent.bounds.size.height-expectedLabelSize.height - 10,
                                expectedLabelSize.width,
                                expectedLabelSize.height);
        
        CALayer *layer = self.layer;
        layer.cornerRadius = 4.0f;
        
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:POPUP_DELAY];
    }
}

- (void)dismiss:(id)sender {
    // Fade out the message and destroy self
    [UIView animateWithDuration:0.6  delay:0 options: UIViewAnimationOptionAllowUserInteraction
                     animations:^  { self.alpha = 0; }
                     completion:^ (BOOL finished) { [self removeFromSuperview]; }];
}



@end
