//
//  FormNode.m
//  CitSciMobile
//
//  Created by lee casuto on 12/9/12.
//  Copyright (c) 2012 lee casuto. All rights reserved.
//

#import "FormNode.h"

@implementation FormNode

@synthesize FormID;
@synthesize FormName;

-(void)setNextForm:(FormNode *)TheForm :(FormNode *)ToForm
{
    TheForm->NextForm=ToForm;
}

-(FormNode *)getNextForm:(FormNode *)TheForm
{
    return TheForm->NextForm;
}

-(void)AddFormToFormList:(FormNode *)FormHead :(FormNode *)TheForm
{
    FormNode *temp = FormHead;
    FormNode *temp2 = temp->NextForm;
    while(temp2 != nil)
    {
        temp = temp2;
        temp2 = temp2->NextForm;
    }
    
    temp->NextForm = TheForm;
    TheForm->NextForm = nil;
}

-(void)NukeFormsFromStructure:(FormNode *)TheHead
{
    FormNode *tempform  = TheHead;
    FormNode *t2;//        = tempform;
    
    while(tempform != nil)
    {
        t2 = tempform;
        tempform=tempform->NextForm;
    }
}

-(void)DumpFormList:(FormNode *)TheHead
{
    int j = 0;
    FormNode *tempform = TheHead;
    
    while(tempform != nil)
    {
        NSLog(@"     FormName[%d]=%@",j,[tempform getFormName:tempform]);
        NSLog(@"     FormID  [%d]=%@",j++,[tempform getFormID:tempform]);
        tempform=tempform->NextForm;
    }
}

-(NSString *)getFormName:(FormNode *)TheNode
{
    return TheNode->FormName;
}

-(NSString *)getFormID:(FormNode *)TheNode
{
    return TheNode->FormID;
}

-(void)SetFormName:(FormNode *)TheNode :(NSString *)TheName
{
    NSString *temp = [[NSString alloc]initWithFormat:@"%@",TheName];
    TheNode->FormName = temp;
}

-(void)SetFormID:(FormNode *)TheNode :(NSString *)TheID
{
    NSString *temp = [[NSString alloc]initWithFormat:@"%@",TheID];
    TheNode->FormID = temp;
}

@end
