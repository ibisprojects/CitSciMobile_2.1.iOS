//
//  ProjectNode.h
//  CitSciMobile
//
//  Created by lee casuto on 12/9/12.
//  Copyright (c) 2012 lee casuto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormNode.h"

@interface ProjectNode : NSObject
{
    @public
    NSString                *ProjectName;
    NSString                *ProjectID;
    ProjectNode             *NextProject;
    FormNode                *FormHead;
}

@property (nonatomic, copy) NSString    *ProjectName;
@property (nonatomic, copy) NSString    *ProjectID;

-(void)AddProjectNode:(ProjectNode *)TheHead :(ProjectNode *)TheNode;
-(void)SetProjectName:(ProjectNode *)TheNode :(NSString *)TheName;
-(void)SetProjectID:(ProjectNode *)TheNode :(NSString *)TheID;
-(void)DumpProjectList:(ProjectNode *)TheHead;
-(void)AddFormToProject:(ProjectNode *)TheProject :(FormNode *)TheForm;
-(NSString *)GetProjectName:(ProjectNode *)TheNode;
-(NSString *)GetProjectID:(ProjectNode *)TheNode;
-(void)NukeProjectsFromStructure:(ProjectNode *)TheHead;



@end
