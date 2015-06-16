//
//  ProjectNode.m
//  CitSciMobile
//
//  Created by lee casuto on 12/9/12.
//  Copyright (c) 2012 lee casuto. All rights reserved.
//

#import "ProjectNode.h"
#import "FormNode.h"

@implementation ProjectNode

@synthesize ProjectID;
@synthesize ProjectName;

//
// Adds a project node to the project list marked by the head of
// the list  (passed in)
//
-(void)AddProjectNode:(ProjectNode *)TheHead :(ProjectNode *)TheNode
{
    ProjectNode *temp = TheHead;
    ProjectNode *temp2 = temp->NextProject;
    while(temp2 != nil)
    {
        temp = temp2;
        temp2 = temp2->NextProject;
    }
    
    temp->NextProject = TheNode;
    TheNode->NextProject = nil;
}

//
// Adds a form node to the project marked by the specified
// project at the end of the list
//
-(void)AddFormToProject:(ProjectNode *)TheProject :(FormNode *)TheForm
{
    //FormNode *temp = TheProject->FormHead;
    TheProject->FormHead=TheForm;
    //[temp AddFormToFormList:temp:TheForm];
    
}

-(void)NukeProjectsFromStructure:(ProjectNode *)TheHead
{
    ProjectNode *temp = TheHead;
    ProjectNode *t2;//   = temp;
    
    while(temp != nil)
    {
        t2      = temp;
        
        // first get rid of forms
        FormNode *tempform = t2->FormHead;
        [tempform NukeFormsFromStructure:tempform];
        
        // now nuke the project node
        if(t2 == TheHead)
        {
            
            t2->FormHead = nil;
        }
        else
        {
            
        }
        
        temp    = temp->NextProject;
    }
}

-(void)DumpProjectList:(ProjectNode *)TheHead
{
    ProjectNode *temp = TheHead;
    int i = 0;
    
    NSLog(@"==============================");
    
    while(temp != nil)
    {
        // project data
        NSLog(@"Project Name[%d]=%@",i,temp.ProjectName);
        NSLog(@"Project   ID[%d]=%@",i++,temp.ProjectID);
        
        // form data
        FormNode *tempform = temp->FormHead;
        [tempform DumpFormList:tempform];
        
        temp = temp->NextProject;
    }
}

-(NSString *)GetProjectName:(ProjectNode *)TheNode
{
    return TheNode->ProjectName;
}
-(NSString *)GetProjectID:(ProjectNode *)TheNode
{
    return TheNode->ProjectID;
}

-(void)SetProjectName:(ProjectNode *)TheNode :(NSString *)TheName
{
    NSString *temp = [[NSString alloc]initWithFormat:@"%@",TheName];
    TheNode->ProjectName = temp;
    ////[temp release];
}

-(void)SetProjectID:(ProjectNode *)TheNode :(NSString *)TheID
{
    NSString *temp = [[NSString alloc]initWithFormat:@"%@",TheID];
    TheNode->ProjectID = temp;
    ////[temp release];
}



@end
