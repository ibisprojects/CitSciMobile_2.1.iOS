//
//  FormNode.h
//  CitSciMobile
//
//  Created by lee casuto on 12/9/12.
//  Copyright (c) 2012 lee casuto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormNode : NSObject
{
    @public
    NSString                *FormName;
    NSString                *FormID;
    FormNode                *NextForm;
}

@property (nonatomic, copy) NSString    *FormName;
@property (nonatomic, copy) NSString    *FormID;

-(void)setNextForm :(FormNode *)TheForm :(FormNode *)ToForm;
-(FormNode *)getNextForm :(FormNode *)TheForm;
-(void)AddFormToFormList :(FormNode *)FormHead :(FormNode *)TheForm;
-(void)DumpFormList :(FormNode *)TheHead;
-(void)NukeFormsFromStructure :(FormNode *)TheHead;

-(void)SetFormName :(FormNode *)TheNode :(NSString *)TheName;
-(void)SetFormID :(FormNode *)TheNode :(NSString *)TheID;

-(NSString *)getFormName:(FormNode *)TheNode;
-(NSString *)getFormID:(FormNode *)TheNode;

@end
