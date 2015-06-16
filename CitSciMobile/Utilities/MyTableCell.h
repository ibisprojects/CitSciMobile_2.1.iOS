//
//  MyTableCell.h
//  AmortizeAtwell
//
//  Created by lee casuto on 6/20/11.
//  Copyright 2011 leeway software design. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyTableCell : UITableViewCell 
{
    NSMutableArray *columns;
}
-(void)addColumn:(CGFloat)position;

@end
