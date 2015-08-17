//
//  Model.m
//  Surveyor
//
//  Created by lee casuto on 2/19/11.
//  Copyright 2011 leeway software design. All rights reserved.
//
// This is a singleton class for managing the application
// global variables (and permits initialization)
//

/////////////////////////////////////////////////////////////
// THINGS  WE  MAY NOT  NEED                               //
// 1. multiple lats, lons,... for multiple points          //
// 2. visit types                                          //
// 3. point counts                                         //
//                                                         //
// THINGS  THAT WILL  CHANGE                               //
// 1. reading a visit file                                 //
/////////////////////////////////////////////////////////////


#import "Model.h"
#import "ProjectNode.h"
#import "FormNode.h"
#import "../Utilities/GetLocationViewController.h"
#import "../Screens/AddObservation.h"
#import "../Screens/AddObservationSelect.h"
#import "../Screens/AddObservationSelectDone.h"
#import "../Screens/AddObservationEnter.h"
#import "../Screens/AddObservationEnterDone.h"
#import "../Screens/ObservationsViewController.h"
#import "../Screens/AddAuthority.h"
#import "../Screens/Information.h"
#import "../Screens/UploadViewController.h"
#import "../Screens/UserData.h"
#import "../Screens/Camera.h"
#import "../AppDelegate.h"
#import "../Utilities/SMXMLDocument.h"

@implementation Model
@synthesize TheVisitLat;
@synthesize TheVisitLon;
@synthesize TheVisitAlt;
@synthesize TheVisitAcc;
@synthesize VisitNames;
@synthesize VisitDescriptions;
@synthesize VisitFiles;
@synthesize VisitDates;
@synthesize VisitLats;
@synthesize VisitLons;
@synthesize VisitAccs;
@synthesize VisitAlts;
@synthesize VisitPointCount;
@synthesize PictureList;
@synthesize VisitUpload;
@synthesize AllSystemNames;
@synthesize UserName;
@synthesize VisitComment;
@synthesize ServerName;
@synthesize Password;
@synthesize CurrentFormName;
@synthesize CurrentFormID;
@synthesize CurrentProjectName;
@synthesize CurrentProjectID;
@synthesize FormNames;
@synthesize FormIDs;
@synthesize ProjectNames;
@synthesize ProjectIDs;
@synthesize WebData;
@synthesize theConnection;
@synthesize theTimer;
@synthesize XMLServerString;
@synthesize AttributeDataName;
@synthesize AttributeDataTypeIDs;
@synthesize AttributeDataValue;
@synthesize AttributeDataChoiceCount;
@synthesize AttributeDataType;
@synthesize AttributeDataTypeModifier;
@synthesize AttributeDataChoices;
@synthesize AttributeDataChoicesIDs;
@synthesize CurrentAttributeChoices;
@synthesize CurrentAttributeName;
@synthesize CurrentAttributeValue;
@synthesize CurrentAttributeType;
@synthesize CurrentAttributeTypeModifier;
@synthesize CurrentOrganismName;
@synthesize OrganismDataName;
@synthesize OrganismDataIDs;
@synthesize OrganismPicklist;
@synthesize OrganismDataComment;
@synthesize OrganismNumberOfAttributes;
@synthesize LatValue;
@synthesize LonValue;
@synthesize DateValue;
@synthesize CurrentOrganismID;
@synthesize AuthorityFirstName;
@synthesize AuthorityID;
@synthesize AuthorityLastName;
@synthesize FullPathName;
@synthesize AttributeDataSelectRow;
@synthesize loginStatus;
@synthesize CurrentVisitName;
@synthesize UploadAllErrors;
@synthesize OrganismCameraComment;
@synthesize OrganismCameraSelectValue;
@synthesize OrganismCameraEnterValue;
@synthesize UrlComponents;
@synthesize Code;
@synthesize ParameterDictionary;
@synthesize JSONDictionary;
@synthesize AccessToken;
@synthesize SavedAccessToken;
@synthesize RefreshToken;
@synthesize SavedRefreshToken;
@synthesize Expires;
@synthesize SavedExpires;
@synthesize FirstInvocationRev21;
@synthesize ParsedAttributeValue;
@synthesize PredefinedLocationIDs;
@synthesize PredefinedLocationNames;
@synthesize SelectedPredefinedID;
@synthesize SelectedPredefinedName;
@synthesize UnitIDs;
@synthesize UnitAbbreviation;
@synthesize JSONObject;
@synthesize TranslatingDatasheetName;


#pragma mark - singleton definition
static Model* _SharedModel=nil;

GetLocationViewController *TheLocation;

static ProjectNode  *ProjectHead;
static FormNode     *LocalFormHead;
static int          ServerMode;

static NSString            *TheVisitName;


//
// singleton declarartion functions
//
+(Model*)SharedModel
{
    
    if (nil != _SharedModel)
    {
        return _SharedModel;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        _SharedModel = [[Model alloc] init];
    });
    
    return _SharedModel;
    
    /****
    // OLD CODE
	@synchronized([Model class])
	{
		if (!_SharedModel)
		{
			[[self alloc] init];
		}
		return _SharedModel;
	}
	
	return nil;
    ******/
}

+(id)alloc
{
	@synchronized([Model class])
	{
		NSAssert(_SharedModel==nil, @"attempted second allocation.");
		_SharedModel = [super alloc];
		return _SharedModel;
	}
	
	return nil;
}

-(id)init
{
	self = [super init];
	if (self != nil)
	{
        //NSLog(@"*********ALLOC CALLED***********");
        AllSystemNames                       = [[NSMutableArray alloc] init];
        self.VisitNames                      = [[NSMutableArray alloc] init];
        self.VisitDescriptions               = [[NSMutableArray alloc] init];
        VisitLats                            = [[NSMutableArray alloc] init];
        VisitLons                            = [[NSMutableArray alloc] init];
        VisitAccs                            = [[NSMutableArray alloc] init];
        VisitAlts                            = [[NSMutableArray alloc] init];
        self.VisitDates                      = [[NSMutableArray alloc] init];
        VisitUploads                         = [[NSMutableArray alloc] init];
        VisitPointCount                      = [[NSMutableArray alloc] init];
        self.PictureList                     = [[NSMutableArray alloc] init];
        self.VisitFiles                      = [[NSMutableArray alloc] init];
        SelectedVisitMaps                    = [[NSMutableArray alloc] init];
        self.ProjectNames                    = [[NSMutableArray alloc] init];
        self.FormNames                       = [[NSMutableArray alloc] init];
        self.ProjectIDs                      = [[NSMutableArray alloc] init];
        self.FormIDs                         = [[NSMutableArray alloc] init];
        self.OrganismDataName                = [[NSMutableArray alloc] init];
        self.OrganismDataIDs	             = [[NSMutableArray alloc] init];
        self.OrganismDataComment	         = [[NSMutableArray alloc] init];
        self.OrganismPicklist                = [[NSMutableArray alloc] init];
        self.OrganismNumberOfAttributes      = [[NSMutableArray alloc] init];
        self.AttributeDataName               = [[NSMutableArray alloc] init];
        self.AttributeDataTypeIDs            = [[NSMutableArray alloc] init];
        self.AttributeDataValue              = [[NSMutableArray alloc] init];
        self.AttributeDataType               = [[NSMutableArray alloc] init];
        self.AttributeDataTypeModifier       = [[NSMutableArray alloc] init];
        self.AttributeDataChoiceCount        = [[NSMutableArray alloc] init];
        self.AttributeDataChoices            = [[NSMutableArray alloc] init];
        self.UnitIDs                         = [[NSMutableArray alloc] init];
        self.UnitAbbreviation                = [[NSMutableArray alloc] init];
        self.AttributeDataChoicesIDs         = [[NSMutableArray alloc] init];
        self.AuthorityFirstName              = [[NSMutableArray alloc] init];
        self.AuthorityLastName               = [[NSMutableArray alloc] init];
        self.AuthorityID                     = [[NSMutableArray alloc] init];
        self.CurrentAttributeChoices         = [[NSMutableArray alloc] init];
        self.AttributeDataSelectRow          = [[NSMutableArray alloc] init];
        self.UploadAllErrors                 = [[NSMutableArray alloc] init];
        self.PredefinedLocationNames         = [[NSMutableArray alloc] init];
        self.PredefinedLocationIDs           = [[NSMutableArray alloc] init];
        self.SelectedPredefinedName          = [[NSString alloc] init];
        self.SelectedPredefinedID            = [[NSString alloc] init];
        self.CurrentOrganismName             = [[NSString alloc] initWithFormat:@"empty"];
        self.CurrentOrganismID	             = [[NSString alloc] initWithFormat:@"empty"];
        self.CurrentAttributeName            = [[NSString alloc] initWithFormat:@"empty"];
        self.CurrentAttributeValue           = [[NSString alloc] initWithFormat:@"empty"];
        self.CurrentAttributeType            = [[NSString alloc] initWithFormat:@"empty"];
        self.CurrentAttributeTypeModifier    = [[NSString alloc] initWithFormat:@""];
        self.loginStatus                     = [[NSString alloc] initWithFormat:@""];
        self.CurrentVisitName                = [[NSString alloc] initWithFormat:@""];
        self.Code                            = [[NSString alloc] init];
        self.UrlComponents                   = [[NSArray  alloc] init];
        self.ParameterDictionary             = [[NSMutableDictionary alloc] init];
        self.JSONDictionary                  = [[NSMutableDictionary alloc] init];
        self.AccessToken                     = [[NSString alloc] init];
        self.RefreshToken                    = [[NSString alloc] init];
        self.Expires                         = [[NSString alloc] init];
        self.SavedAccessToken                = [[NSString alloc] init];
        self.SavedRefreshToken               = [[NSString alloc] init];
        self.SavedExpires                    = [[NSString alloc] init];
        self.TranslatingDatasheetName        = [[NSString alloc] init];
        self.FirstInvocationRev21            = NOTYETSET;
        self.ParsedAttributeValue            = [[NSString alloc] init];
        OrganismCameraCalled                 = false;
        self.OrganismCameraComment           = [[NSString alloc]init];
        self.JSONObject                      = nil;
        OrganismCameraParent                 = CAMERAFROMSELECT;
        OrganismCameraSelectRow              = 0;
        self.OrganismCameraSelectValue       = [[NSString alloc]init];
        self.OrganismCameraEnterValue        = [[NSString alloc]init];
        self.OrganismCameraComment           = [[NSString alloc]init];
        CurrentAttributeChoiceCount          = 0;
        NSString *ServerTitile               = [[NSString alloc] initWithFormat:@""];
        NSString *TestName                   = [[NSString alloc] initWithFormat:@"ibis-test.nrel.colostate.edu"];
        NSString *LiveName                   = [[NSString alloc] initWithFormat:@"ibis-live.nrel.colostate.edu"];
        self.CurrentFormName                 = [[NSString alloc] initWithFormat:NOTYETSET];
        self.CurrentProjectName              = [[NSString alloc] initWithFormat:NOTYETSET];
        self.CurrentFormID                   = [[NSString alloc] initWithFormat:NOTYETSET];
        self.CurrentProjectID                = [[NSString alloc] initWithFormat:NOTYETSET];
        self.LatValue                        = [[NSString alloc]initWithFormat:@"%lf",0.0];
        self.LonValue                        = [[NSString alloc]initWithFormat:@"%lf",0.0];
        [AllSystemNames addObject:ServerTitile];
        [AllSystemNames addObject:TestName];
        [AllSystemNames addObject:LiveName];
        self.TheVisitLat                     = [[NSString alloc]init];
        self.TheVisitLon                     = [[NSString alloc]init];
        self.TheVisitAcc                     = [[NSString alloc]init];
        self.TheVisitAlt                     = [[NSString alloc]init];
        [self SetAccuracy:10.0f];
        [self SetDelay:kDELAY];
        LoginState                           = LOGINNOTSET;
        [self SetCollectionType:COLLECTORGANISM];
        self.UserName                        = @"";
        self.Password                        = @"";
        self.FullPathName                    = @"";
        self.VisitComment                    = @"";
        self.ServerName                      = [[NSString alloc]initWithString:LiveName];
        [self SetBadNetworkConnection:false];
        ////[self SetServerNameString:LiveName];
        
        TheLocation = [GetLocationViewController SharedLocation];
        
        [self SetDidGoBackground:TRUE];
        
        CurrentViewValue                     = OBSERVATIONSVIEW;
        NextViewValue                        = OBSERVATIONSVIEW;
        
        [self ResetSystemNames];                // initializes SystemIndex
        
        //
        // initialize the project list
        //
        ProjectHead          = [[ProjectNode alloc]init];
        [self SetProjectDataAvailable:NO];
        
        //
        // XML inigtializations
        //
        self.XMLServerString = [[NSString alloc]init];
        [self SetServerError:false];
        [self SetDataFromServerStatus:true];
        [self SetBioblitzDispaly:true];
        
        //
        // observation views values
        //
        [self SetCurrentOrganismIndex:0];
        [self SetCurrentAttributeChoiceIndex:0];
        [self SetCurrentAttributeDataChoicesIndex:0];
        [self SetCurrentAttributeChoiceCountIndex:0];
        [self SetIsLast:false];
        [self SetAttributesSet:false];
        [self SetSiteCharacteristicsCount:0];
        if(!([self GetKeepAuthoritySet]))
        {
            [self SetAuthoritySet:false];
        }
        [self SetKeepAuthoritySet:false];
        [self SetAuthorityRowNumber:0];
        [self SetUploadError:false];
        [self SetPreviousMode:false];
        [self SetGoingForward:false];
        [self SetFirstSelect:true];
        [self SetAllDataFileStarted:false];
        [self SetSelectIndex:-1];
        [self SetCurrentAttributeNumber:1];
        
        [self SetWriteOptionsFile:false];
        
        // predefined location mode
        [self SetPredefinedLocationMode:false];
	}
	
	return self;
}


//===========================================================//

#pragma mark - private model methods called only by the model
-(int)CalculateSelectChoiceIndex:(int)TheLoopLimit
{
    int LocalAttributeDataChoicesIndex  = 0;
    
    //
    // calculate the current index for AttributeDataChoices array
    // which is the sum of numbers in AttributeDataChoice count from
    // zero to LocalAttributeChoiceCountIndex
    //
    int i               = 0;
    int x               = 0;
    Boolean talktome    = false;
    
    if(talktome) NSLog(@"LoopLimit=%d",TheLoopLimit);
    
    NSString *y;
    for(i=0; i<=TheLoopLimit; i++)
    {
        @try
        {
            y = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataChoiceCount objectAtIndex:i]];
        }
        @catch (NSException *e)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"error case 1 call lee"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        
        if(talktome) NSLog(@"AttributeDataChoiceCount[%d]=%@",i,[self.AttributeDataChoiceCount objectAtIndex:i]);
        x = (int)[y integerValue];
        LocalAttributeDataChoicesIndex=LocalAttributeDataChoicesIndex+x;
        
        if(talktome) NSLog(@"=== loop of attributechoicecount");
        if(talktome) NSLog(@"    i                              = %d",i);
        if(talktome) NSLog(@"    y                              = %d",x);
        if(talktome) NSLog(@"    LocalAttributeDataChoicesIndex = %d",LocalAttributeDataChoicesIndex);

        x = [self GetCurrentAttributeChoiceCountIndex];
        x++;
        
        if(talktome) NSLog(@"    x                              = %d",x);
        
    }
    
    return LocalAttributeDataChoicesIndex;
}

-(int)CalculatePreviousSelectChoiceIndex:(int)TheLoopLimit
{
    int result = 0;
    int i      = 0;
    int x      = 0;
    
    //if([self GetCurrentAttributeChoiceCountIndex] == 0)
    //{
    //    result = 0;
    //}
    //else
    {
        NSString *y;
        for(i=0; i<=TheLoopLimit; i++)
        {
            y = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataChoiceCount objectAtIndex:i]];
            
            @try
            {
                y = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataChoiceCount objectAtIndex:i]];
            }
            @catch (NSException *e)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:@"error case 2 call lee"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
            
            x = (int)[y integerValue];
            
            result=result+x;
        }
    }
    
    return result;
}

-(void)SetCurrentValues
{
    if([self GetCollectionType]==COLLECTORGANISM)
    {
        [self SetCurrentOrganismName];
        [self SetCurrentOrganismID];
    }
    [self SetCurrentAttributeName];
    [self SetCurrentAttributeType];
    [self SetCurrentAttributeTypeModifier];
}

#pragma mark - reachability
//===========================================================//
// The rest of this file is the model for CitSciMobile       //
//===========================================================//

//
// Reachability functions
//
-(void)SetNetworkStatus:(int)TheValue
{
    TheNetwork=TheValue;
}
-(int)GetNetworkStatus
{
    return TheNetwork;
}

//
// view state used by CoverPage
//
-(void)SetCurrentViewValue:(int)TheView
{
    CurrentViewValue = TheView;
}
-(int)GetCurrentViewValue
{
    return CurrentViewValue;
}

#pragma -
#pragma - mark Location methods
-(NSDate *)GetDateValue
{
    NSDate *result = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    return result;
}


-(void)SetLatValue:(NSString *)TheValue
{
    self.LatValue = TheValue;
}

-(void)SetLonValue:(NSString *)TheValue
{
    self.LonValue = TheValue;
}

-(void)SetDateValue:(NSDate *)TheValue
{
    self.DateValue = TheValue;
}


-(void)SetErrorMessage:(BOOL)YesNo
{
    ShowErrorMessage=YesNo;
}

-(BOOL)GetErrorMessage
{
    return ShowErrorMessage;
}

-(void)SetupLocationManager
{
    [self SetLocationSearch:NO];
    [TheLocation SetupLocationManager];
}

-(void)SetDelay:(double)TheValue
{
    TheDelay = TheValue;
}
-(double)GetDelay
{
    return TheDelay;
}

-(void)SetAccuracy:(double)TheValue
{
    TheAccuracy = TheValue;
}
-(double)GetAccuracy
{
    return TheAccuracy;
}

-(Boolean)GetBestEffort
{
    return BestEffort;
}

// setters and getters for acquired
-(void)SetAcquired:(Boolean)TheValue
{
    Acquired = TheValue;
}
-(Boolean)GetAcquired
{
    return Acquired;
}

-(void)SetBestEffort:(Boolean)TheValue
{
    BestEffort = TheValue;
}

// setters and getters for location search
-(void)SetLocationSearch:(Boolean)TheValue
{
    LocationSearchDone=TheValue;
}
-(Boolean)GetLocationSearch
{
    return LocationSearchDone;
}
//
//  end of LocateME interface finftions
//

#pragma mark - visit functions
//
// visits functions
// visits are stored just like AOI's
// in IBISAOI.  We have an index and
// reset it to clean it out
//
-(Boolean)DoesThisNameExist:(NSString *)TheName
{
    Boolean     Result      = false;       // assume success
    NSString    *str        = [[NSString alloc]init];
    int         TheCount    = (int)[self.VisitNames count];
    int         i           = 0;
    
    while(i < TheCount)
    {
        @try
        {
            str = [NSString stringWithFormat:@"%@",[self.VisitNames objectAtIndex:i]];
        }
        @catch (NSException *e)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"error case 3 call lee"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        
        if([TheName isEqualToString:str])
        {
            Result = true;
            break;
        }
        i++;
    }
    
    return Result;
}

-(void)SetVisitComment:(NSString *)TheComment
{
	self.VisitComment=[NSString stringWithFormat:@"%@",TheComment];
}
-(NSString *)GetVisitComment
{
	return self.VisitComment;
}
-(void)ResetVisitsList
{
    VisitIndex=0;
}


//
// full path name
//
-(void)SetCurrentVisitName:(NSString *)TheName
{
    self.CurrentVisitName = [NSString stringWithFormat:@"%@",TheName];
}
-(NSString *)GetCurrentVisitName
{
    return self.CurrentVisitName;
}

-(void)SetUploadError:(Boolean)TheError
{
    UploadError=TheError;
}
-(Boolean)GetUploadError
{
    return UploadError;
}

-(NSString *)GetVisitMapName
{
    return [SelectedVisitMaps objectAtIndex:VisitMapIndex];
}

-(Boolean)GetNextVisitMap
{
    Boolean result=NO;
    
    if (([SelectedVisitMaps count]-1) > VisitMapIndex)
    {
        VisitMapIndex++;
        result = YES;
    }
    return result;
}

// lats
-(void)SetVisitLat:(NSString *)TheLat
{
    self.TheVisitLat = [NSString stringWithFormat:@"%@",TheLat];
}
-(NSString *)GetVisitLat
{
    return self.TheVisitLat;
}
-(NSString *)GetVisitLatAtIndex:(int)TheIndex
{
    return [VisitLats objectAtIndex:TheIndex];
}

// lons
-(void)SetVisitLon:(NSString *)TheLon
{
    self.TheVisitLon = [NSString stringWithFormat:@"%@",TheLon];
}
-(NSString *)GetVisitLon
{
    return self.TheVisitLon;
}

-(NSString *)GetVisitLonAtIndex:(int)TheIndex
{
    return [VisitLons objectAtIndex:TheIndex];
}

// altitudes
-(void)SetVisitAlt:(NSString *)TheAlt
{
    self.TheVisitAlt = [NSString stringWithFormat:@"%@",TheAlt];
}
-(NSString *)GetVisitAlt
{
    return self.TheVisitAlt;
}

// accuracy
-(void)SetVisitAcc:(NSString *)TheAcc
{
    self.TheVisitAcc = [NSString stringWithFormat:@"%@",TheAcc];
}
-(NSString *)GetVisitAcc
{
    return self.TheVisitAcc;
}


-(NSString *)GetVisitDescription
{
    return [self.VisitDescriptions objectAtIndex:VisitIndex];
}

// setters and getters for the active node's name value
-(void)SetVisitName:(NSString *)TheName
{
    [self.VisitNames addObject:TheName];
}
-(NSString *)GetVisitName
{
    return [self.VisitNames objectAtIndex:VisitIndex];
}
-(NSString *)GetVisitNameAtIndex:(int)TheIndex
{
    return [self.VisitNames objectAtIndex:TheIndex];
}

// sets the active node's description
-(void)SetVisitDescription:(NSString *)TheDescription
{
    [self.VisitDescriptions addObject:TheDescription];
}

// sets the current node's date
-(void)SetVisitDate:(NSDate *)TheDate
{
    [self.VisitDates addObject:TheDate];
}

// setters and getters for the current node's point count
-(void)SetVisitPointCount:(int)TheCount
{
    NSString *x = [[NSString alloc] initWithFormat:@"%d",TheCount];
    if([VisitPointCount count] == 0)
    {
        [VisitPointCount addObject:x];
    }
    else
    {
        [VisitPointCount replaceObjectAtIndex:0 withObject:x];
    }
}
-(int)GetVisitPointCount
{
    NSString *x = [VisitPointCount objectAtIndex:VisitIndex];
    int y       = [x intValue];
    return y;
}

// sets the current node's upload status
-(void)SetVisitUpload:(BOOL)TheUploadValue
{
    NSString *x = [[NSString alloc] initWithFormat:@"%d",TheUploadValue];
    [VisitUploads addObject:x];
}
-(Boolean)GetVisitUpload
{
    Boolean retval=NO;         // assume not uploaded
    NSString *x = [VisitUploads objectAtIndex:VisitIndex];
    int y = [x intValue];
    
    if(y!=0)
    {
        retval=YES;
    }
    return retval;
}

-(Boolean)GetNextVisitNode
{
    Boolean result=NO;
    
    if (([self.VisitNames count]-1) > VisitIndex)
    {
        VisitIndex++;
        result = YES;
    }
    
    return result;
}

-(int)GetNumberOfVisits
{
    return (int)[self.VisitNames count];
}

-(int)GetNumberOfVisitFiles
{
    return (int)[self.VisitFiles count];
}

-(void)SetVisitFileName:(NSString *)TheName
{
    [self.VisitFiles addObject:TheName];
}
-(NSString *)GetVisitFileNameAtIndex:(int)TheIndex
{
    NSString *foo = [[NSString alloc]initWithFormat:@"%@",[self.VisitFiles objectAtIndex:TheIndex]];
    return foo;
}

// adds the given lat to the lat list
-(void)AddVisitLat:(NSString *)TheLat
{
    [VisitLats addObject:TheLat];
}

// adds the given lon to the lon list
-(void)AddVisitLon:(NSString *)TheLon
{
    [VisitLons addObject:TheLon];
}

// adds the current accuracy to the accuracy list
-(void)AddVisitAcc:(NSString *)TheAcc
{
    [VisitAccs addObject:TheAcc];
}

// adds the current altitude to the altitude list
-(void)AddVisitAlt:(NSString *)TheAlt
{
    [VisitAlts addObject:TheAlt];
}

// cleans the visit structures and arrays
-(void)CleanVisits
{
    [self.VisitNames removeAllObjects];
    [self.VisitFiles removeAllObjects];
}

//
// ReadAllVisit files reads each of the Visit
// files in the Documents directory (all files with the
// .xml extension) and saves the names and types for
// access by other classes.  More may be added later,
// but for now that's all that's required.
//
-(void)ReadAllVisitFiles
{
	NSFileManager       *filemgr;
	NSString            *CurrentVisitFile;
	NSString            *ApplicationsPath;
    NSString            *VisitsDirectory;
	NSArray             *DirectoryPaths;
    NSArray             *DirFiles;
    NSArray             *Visits;
    Boolean             Done = NO;
    
    // 0. make sure we have a user name
    [self ReadOptionsFromFile];
	
    // 1. get a file manager for directory access
	filemgr = [NSFileManager defaultManager];
	
	// 2. if the directory does not exist, we're done
    VisitsDirectory     = [[NSString alloc]initWithFormat:VISITSPATH];
	DirectoryPaths      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath    = [DirectoryPaths objectAtIndex:0];
    ApplicationsPath    = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
    ApplicationsPath    = [ApplicationsPath stringByAppendingPathComponent:VisitsDirectory];
    
	if (![filemgr fileExistsAtPath:ApplicationsPath])
	{
        Done = YES;
	}
    else
    {
        // create a list of files to read.  (all that
        // have the .aoi extension.  If there are no
        // files, set Done to yes and return
        DirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:ApplicationsPath error:nil];
        NSString *foo = [[NSString alloc]initWithFormat:@"self ENDSWITH '%@'",XMLEXTENSION];
        Visits   = [DirFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:foo]];
        if([Visits count] == 0)
        {
            Done = YES;
        }
    }
    
	// 4. open, read, and close each file and set the
    //    name and type entries for each file
    if(!Done)
    {
        for(int k=0; k<[Visits count]; k++)
        {
            CurrentVisitFile = [ApplicationsPath stringByAppendingPathComponent:[Visits objectAtIndex:k]];
            NSString* fname = [[CurrentVisitFile lastPathComponent] stringByDeletingPathExtension];
            [self SetVisitFileName:CurrentVisitFile];
            [self SetVisitName:fname];
        }
    }
}


#pragma mark - utility functions
//
// utility functions
//
// test method
-(void) SayHello
{
	NSLog(@"hello Sally!");
}

//
// check for networking errors fronteh server
//
-(void)SetBadNetworkConnection:(Boolean)TheValue
{
    BadNetworkConnection = TheValue;
}
-(Boolean)GetBadNetworkConection
{
    return BadNetworkConnection;
}

//
// upload blockers
//
-(void)SetUploadRunning:(Boolean)TheStatus
{
    UploadRunning = TheStatus;
}
-(Boolean)GetUploadRunning
{
    return UploadRunning;
}

//
// will either create a new file or append to the
// existing file
//
-(void)WriteInstrument:(NSString *)TheString : (Boolean)RemoveIt
{
    NSString	  *InstrumentFile;
	NSString	  *ApplicationsPath;
	NSString	  *tempstring;
	NSArray		  *DirectoryPaths;
	NSData		  *tempdata;
    NSFileHandle  *file;
    NSString      *cr;
    
    if(1) return;
    
    // get the path for this application in the Docs directory
	DirectoryPaths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath = [DirectoryPaths objectAtIndex:0];
	InstrumentFile   = [ApplicationsPath stringByAppendingPathComponent:@"InstrumentFile"];
    
    if(RemoveIt)
    {
        [[NSFileManager defaultManager] removeItemAtPath:InstrumentFile error:nil];
    }
    
    //
    // create file if it doesn't exist
    //
    if(!([[NSFileManager defaultManager] fileExistsAtPath:InstrumentFile]))
    {
        [[NSFileManager defaultManager]createFileAtPath:InstrumentFile contents:nil attributes:nil];
    }
    
    //
    // open it append
    //
    file = [NSFileHandle fileHandleForWritingAtPath:InstrumentFile];
    [file seekToEndOfFile];
    
    //
    // write to it
    //
    cr          = [[NSString alloc]initWithFormat:@"\n"];
    tempstring=[NSString stringWithFormat:@"%@%@",TheString,cr];
    tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
    [file writeData:tempdata];
    
    //
    // close it
    //
    [file closeFile];

}

-(NSString *)FixXML:(NSString *)TheStringToFix
{
    NSString *foo = [[NSString alloc]initWithFormat:@"%@",TheStringToFix];
    foo           = [foo stringByReplacingOccurrencesOfString:AMPERSANDCHAR withString:AMPERSANDSTRING];
    foo           = [foo stringByReplacingOccurrencesOfString:LESSTHANCHAR withString:LESSTHANSTRING];
    foo           = [foo stringByReplacingOccurrencesOfString:GREATERTHANCHAR withString:GREATERTHANSTRING];
    foo           = [foo stringByReplacingOccurrencesOfString:TICKCHAR withString:TICKSTRING];
    foo           = [foo stringByReplacingOccurrencesOfString:QUOTECHAR withString:QUOTESTRING];
    //foo           = [foo stringByReplacingOccurrencesOfString:PERCENTCHAR withString:PERCENTSTRING];
    //foo           = [foo stringByReplacingOccurrencesOfString:PLUSCHAR withString:PLUSSTRING];
    //foo           = [foo stringByReplacingOccurrencesOfString:QUESTIONCHAR withString:QUESTIONSTRING];
    //foo           = [foo stringByReplacingOccurrencesOfString:RPARENCHAR withString:RPARENSTRING];
    //foo           = [foo stringByReplacingOccurrencesOfString:LPARENCHAR withString:LPARENSTRING];
    //foo           = [foo stringByReplacingOccurrencesOfString:SLASHCHAR withString:SLASHSTRING];
    //foo           = [foo stringByReplacingOccurrencesOfString:EQUALCHAR withString:EQUALSTRING];
    //foo           = [foo stringByReplacingOccurrencesOfString:COMMACHAR withString:COMMASTRING];
    ////NSLog(@"fixing: %@",foo);
    return foo;
}

-(NSString *)TranslateDefinition:(NSString *)TheStringToFix : (NSString *)ValueType
{
    NSString *foo = [[NSString alloc]initWithFormat:@"%@",TheStringToFix];
    NSString *bar = [[NSString alloc]initWithFormat:@"%@",ValueType];
    
    if(foo == NULL) return @"";
    if([foo isEqualToString:@"Specified"])
    {
        foo = @"Defined";
    }
    
    if([foo isEqualToString:@"List"])
    {
        foo = @"Select";
    }
    
    if([foo isEqualToString:@"Entered"])
    {
        foo = @"Entered";
    }
    
    if(([foo isEqualToString:@"Entered"]) && ([bar isEqualToString:@"6"]))
    {
        foo = @"Date";
    }
    
    if(([foo isEqualToString:@"Entered"]) && ([bar isEqualToString:@"5"]))
    {
        foo = @"String";
    }
    
    return foo;
}


//
// the name handed to this method is a local file name
// this method, based on the type, builds the full path
// to the file.
//
-(NSString *)BuildFullPathFromName:(NSString *)TheName :(int)TheType
{
	NSFileManager       *filemgr;
	NSString            *ApplicationsPath;
	NSArray             *DirectoryPaths;
    
    // 0. ensure we have a user name
    [self ReadOptionsFromFile];
	
    // 1. get a file manager for directory access
	filemgr = [NSFileManager defaultManager];
	
	// 2. get the directory for this application in the Docs directory
	DirectoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath = [DirectoryPaths objectAtIndex:0];
    ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
    
    switch (TheType)
    {
        case VISITTYPE:
            ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:VISITSPATH];
            break;
            
        case FORMTYPE:
            ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:FORMSPATH];
            break;
            
        default:
            break;
    }
    
    self.FullPathName     = [ApplicationsPath stringByAppendingPathComponent:TheName];
    
    return self.FullPathName;
}

-(void)SetCollectionType:(int)TheValue
{
    CollectionType=TheValue;
}
-(int)GetCollectionType
{
    return CollectionType;
}

// Getters and setters for username, password and servername
-(void)SetUserName:(NSString *)TheName
{
	self.UserName=[NSString stringWithFormat:@"%@",TheName];
}
-(NSString *)GetUserName
{
	return self.UserName;
}

// setters and getters for server name
-(void)SetServerNameString:(NSString *)TheName
{
	self.ServerName=[NSString stringWithFormat:@"%@",TheName];
}
-(void)SetServerName:(int)TheNameNumber
{
    self.ServerName=[NSString stringWithFormat:@"%@",[AllSystemNames objectAtIndex:TheNameNumber]];
}
-(NSString *)GetServerName
{
	return self.ServerName;
}

// setters and getters for password
-(void)SetUserPassword:(NSString *)TheName
{
	self.Password=[NSString stringWithFormat:@"%@",TheName];
}
-(NSString *)GetUserPassword
{
	return self.Password;
}

// background setters and getters
-(void)SetDidGoBackground:(Boolean)Value
{
    DidGoBackground=Value;
}
-(Boolean)GetDidGoBackground
{
    return DidGoBackground;
}

// ReadOptionsFromFile open the file to set:
// 1. user name
// 2. password
// 3. default server
-(void)ReadOptionsFromFile
{
	// the above sets the values via static strings.  The code below
	// is the beginning of reading the file for the information....
    
	// 1. get a file manager for directory access
	NSFileManager       *filemgr;
	NSString            *ApplicationsFile;
	NSString            *ApplicationsPath;
    NSError             *error;
	NSArray             *DirectoryPaths;
	
	filemgr = [NSFileManager defaultManager];
	
	// 2. create the directory for this application in the Docs directory
	DirectoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath = [DirectoryPaths objectAtIndex:0];
	ApplicationsFile = [ApplicationsPath stringByAppendingPathComponent:OPTIONSFILE];
    
	if (![filemgr fileExistsAtPath:ApplicationsPath])
	{
		[filemgr createDirectoryAtPath:ApplicationsPath
           withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	// 3. create the options file if it doesn't exist
	NSFileHandle *file;
	
	if (![filemgr fileExistsAtPath:ApplicationsFile])
	{
		[filemgr createFileAtPath:ApplicationsFile contents:nil attributes:nil];
		file = [NSFileHandle fileHandleForWritingAtPath:ApplicationsFile];
		if (file == nil)
		{
			
		}
		else
		{
            [file closeFile];
		}
	}
	
	// 4. open the file for reading and parsing
    NSString *OneLine = [NSString stringWithContentsOfFile:ApplicationsFile encoding:NSUTF8StringEncoding error:&error];
	NSArray *EachLine = [OneLine componentsSeparatedByString:@"\n"];
    
    int linecount=0;
    linecount=(int)[EachLine count]-1;
    int i;
    for(i=0;i<linecount;i++)
    {
        NSString *ThisLine=[[NSString alloc] initWithFormat:@"%@",[EachLine objectAtIndex:i]];
        NSArray *LineComponents=[ThisLine componentsSeparatedByString:@":"];
        int componentcount=(int)[LineComponents count];
        if(componentcount!=2)continue;
        NSString *VariableName=[[NSString alloc] initWithFormat:@"%@",[LineComponents objectAtIndex:0]];
        NSString *VariableValue=[[NSString alloc] initWithFormat:@"%@",[LineComponents objectAtIndex:1]];
        
        if ([VariableName isEqualToString:@"user"])
        {
            [self SetUserName:VariableValue];
        }
        else if([VariableName isEqualToString:@"password"])
        {
            [self SetUserPassword:VariableValue];
        }
        else if([VariableName isEqualToString:@"form"])
        {
            [self SetCurrentFormName:VariableValue];
        }
        else if([VariableName isEqualToString:@"formid"])
        {
            [self SetCurrentFormID:VariableValue];
        }
        else if([VariableName isEqualToString:@"project"])
        {
            [self SetCurrentProjectName:VariableValue];
        }
        else if([VariableName isEqualToString:@"projectid"])
        {
            [self SetCurrentProjectID:VariableValue];
        }
        else if([VariableName isEqualToString:@"firstinvocationrev21"])
        {
            [self SetFirstInvocationRev21:VariableValue];
        }
        else if([VariableName isEqualToString:@"accesstoken"])
        {
            [self SetAccessToken:VariableValue];
        }
        else if([VariableName isEqualToString:@"refreshtoken"])
        {
            [self SetRefreshToken:VariableValue];
        }
        else if([VariableName isEqualToString:@"expirestoken"])
        {
            [self SetExpires:VariableValue];
        }
        else if([VariableName isEqualToString:@"servererror"])
        {
            Boolean LocalServerError = true;
            if([VariableValue isEqualToString:@"NO"])
            {
                LocalServerError = false;
            }
            [self SetServerError:LocalServerError];
        }
        else if([VariableName isEqualToString:@"server"])
        {
            if([VariableValue isEqualToString:nil])
            {
                [self SetServerName:1];
            }
            else
            {
                [self SetServerNameString:VariableValue];
            }
        }
    }
}

// ChangeUser
// copies the user's option's file to the
// Documents directory
-(void)ChangeUser
{
    NSFileManager *filemgr;
	NSString	  *ApplicationsFile;
	NSString	  *ApplicationsPath;
    NSString      *DestinationPath;
    NSString      *DestinationFile;
    NSArray		  *DirectoryPaths;
    NSString	  *tempstring;
    NSData		  *tempdata;
    NSError       *error;
    NSFileHandle  *file;
    
    filemgr = [NSFileManager defaultManager];
	
	// 2. create the directory for this application in the Docs directory
	DirectoryPaths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath = [DirectoryPaths objectAtIndex:0];
    ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
    ApplicationsFile = [ApplicationsPath stringByAppendingPathComponent:OPTIONSFILE];
    
    DestinationPath  = [DirectoryPaths objectAtIndex:0];
    DestinationFile  = [DestinationPath stringByAppendingPathComponent:OPTIONSFILE];
    
    tempstring  = [[NSString alloc] initWithContentsOfFile:ApplicationsFile encoding:NSUTF8StringEncoding error:&error];
    
    if (tempstring == Nil)
    {
        ////NSLog(@"nil string so populate it for user: %@",[self GetUserName]);
        [self SetCurrentProjectName:NOTYETSET];
        [self SetCurrentProjectID:NOTYETSET];
        [self SetCurrentFormName:NOTYETSET];
        [self SetCurrentFormID:NOTYETSET];
        [self SetFirstInvocationRev21:NOTYETSET];
        [self WriteOptionsToFile];
        tempstring  = [[NSString alloc] initWithContentsOfFile:ApplicationsFile encoding:NSUTF8StringEncoding error:&error];
        // access, refresh and expires handled later
    }
    tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
    
    // ensure paths exist
    [filemgr createDirectoryAtPath:DestinationPath withIntermediateDirectories:YES attributes:nil error:nil];
    [filemgr createDirectoryAtPath:ApplicationsPath withIntermediateDirectories:YES attributes:nil error:nil];
    if ([filemgr fileExistsAtPath:DestinationPath] == YES)
    {
        [filemgr removeItemAtPath:DestinationFile error:nil];
        [filemgr createFileAtPath:DestinationFile contents:nil attributes:nil];
    }
    
    file        = [NSFileHandle fileHandleForWritingAtPath:DestinationFile];
    [file writeData:tempdata];
    [file closeFile];
    
}

// WriteOptionsToFile
// 1. remove the existing file
// 2. write a new file from the AllEvents and
// 3. copy the current options file to the User area
//    AllDates arrays
-(void)WriteOptionsToFile
{
	NSFileManager *filemgr;
	NSString	  *ApplicationsFile;
	NSString	  *ApplicationsPath;
    NSString      *DestinationPath;
    NSString      *DestinationFile;
	NSString	  *tempstring;
	NSString	  *cr;
    NSString      *colon;
	NSArray		  *DirectoryPaths;
	NSData		  *tempdata;
    NSError       *error;
	
	// 1. remove the old file
	[self RemFile:OPTIONSFILE];
	
	filemgr = [NSFileManager defaultManager];
	
	// 2. create the directory for this application in the Docs directory
	DirectoryPaths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath = [DirectoryPaths objectAtIndex:0];
    DestinationPath  = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
	ApplicationsFile = [ApplicationsPath stringByAppendingPathComponent:OPTIONSFILE];
    DestinationFile  = [DestinationPath stringByAppendingPathComponent:OPTIONSFILE];
	
	if (![filemgr fileExistsAtPath:ApplicationsPath])
	{
		[filemgr createDirectoryAtPath:ApplicationsPath
		   withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	// 3. create the surveyor file if it doesn't exist
	NSFileHandle *file;
	
	if (![filemgr fileExistsAtPath:ApplicationsFile])
	{		
		[filemgr createFileAtPath:ApplicationsFile contents:nil attributes:nil];
		file = [NSFileHandle fileHandleForWritingAtPath:ApplicationsFile];
		if (file == nil)
		{
			////NSLog(@"failed to open file");
		}
		else
		{
			cr=[[NSString alloc]initWithFormat:@"\n"];
            colon=[[NSString alloc]initWithFormat:@":"];
            
            // write out user, cr, password, cr, project, cr, form name, cr, server name, cr
            tempstring=[NSString stringWithFormat:@"user%@%@%@",colon,[self GetUserName],cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // password
            tempstring=[NSString stringWithFormat:@"password%@%@%@",colon,[self GetUserPassword],cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // project name
            tempstring=[NSString stringWithFormat:@"project%@%@%@",colon,[self GetCurrentProjectName],cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // project id
            tempstring=[NSString stringWithFormat:@"projectid%@%@%@",colon,[self GetCurrentProjectID],cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // form name
            tempstring=[NSString stringWithFormat:@"form%@%@%@",colon,[self GetCurrentFormName],cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // form id
            tempstring=[NSString stringWithFormat:@"formid%@%@%@",colon,[self GetCurrentFormID],cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // first invocation of rev 2.1
            tempstring=[NSString stringWithFormat:@"firstinvocationrev21%@%@%@",colon,[self GetFirstInvocationRev21],cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // access token
            tempstring=[NSString stringWithFormat:@"accesstoken%@%@%@",colon,[self GetAccessToken],cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // refresh token
            tempstring=[NSString stringWithFormat:@"refreshtoken%@%@%@",colon,[self GetRefreshToken],cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // expires timeout
            tempstring=[NSString stringWithFormat:@"expirestoken%@%@%@",colon,[self GetExpires],cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // server error
            Boolean LocalServerError = [self GetServerError];
            NSString *LocalServerErrorString = @"NO";
            if(LocalServerError)
            {
                ///[LocalServerErrorString initWithString:@"YES"];
            }
            tempstring=[NSString stringWithFormat:@"servererror%@%@%@",colon,LocalServerErrorString,cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // server name
            tempstring=[NSString stringWithFormat:@"server%@%@%@",colon,[self GetServerName],cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
			
			[file closeFile];
            
            //
            // copy the file so it is in the user area
            //
            ////NSLog(@"username = %@",[self GetUserName]);
            if([[self GetUserName] length] != 0)
            {
                tempstring  = [[NSString alloc] initWithContentsOfFile:ApplicationsFile encoding:NSUTF8StringEncoding error:&error];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                
                [filemgr createDirectoryAtPath:DestinationPath withIntermediateDirectories:YES attributes:nil error:nil];
                if ([filemgr fileExistsAtPath:DestinationPath] == YES)
                {
                    [filemgr removeItemAtPath:DestinationFile error:nil];
                    [filemgr createFileAtPath:DestinationFile contents:nil attributes:nil];
                }
                
                file        = [NSFileHandle fileHandleForWritingAtPath:DestinationFile];
                [file writeData:tempdata];
                [file closeFile];
            }
		}
	}
}

-(void)RemFile:(NSString *)TheName
{
	NSFileManager *filemgr;
	NSString	  *ApplicationsFile;
	NSString	  *ApplicationsPath;
	NSArray		  *DirectoryPaths;
	
    // get a file manager for directory access
	filemgr = [NSFileManager defaultManager];
	
	// create the directory for this application in the Docs directory
	DirectoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath = [DirectoryPaths objectAtIndex:0];
    if(![TheName isEqualToString:OPTIONSFILE])
    {
        ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
    }
	ApplicationsFile = [ApplicationsPath stringByAppendingPathComponent:TheName];
	
	
	//if(LocalDebug) NSLog(@"RemFile here");
	if([filemgr removeItemAtPath:ApplicationsFile error:nil])
	{
		//if(LocalDebug) NSLog(@"file removed");
	}
	else
	{
		//if(LocalDebug) NSLog(@"remove failed");
	}
}

-(void)RemVisitFile:(NSString *)TheName
{
	// get a file manager for directory access
	NSFileManager *filemgr;
	NSString	  *ApplicationsFile;
	NSString	  *ApplicationsPath;
    NSString      *ApplicationsPicPath;
    NSString      *VisitDirName;
	NSArray		  *DirectoryPaths;
	
	filemgr = [NSFileManager defaultManager];
    
    [self ReadOptionsFromFile];
    
    VisitDirName            = [TheName stringByDeletingPathExtension];
	
	// create the directory for this application in the Docs directory
	DirectoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath        = [DirectoryPaths objectAtIndex:0];
    ApplicationsPath        = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
    ApplicationsPath        = [ApplicationsPath stringByAppendingPathComponent:VISITSPATH];
	ApplicationsFile        = [ApplicationsPath stringByAppendingPathComponent:TheName];
    ApplicationsPicPath     = [ApplicationsPath stringByAppendingFormat:@"/%@%@",VisitDirName,JPGSDIRNAME];
	
	// nuke the xml file
	if([filemgr removeItemAtPath:ApplicationsFile error:nil])
	{
		//NSLog(@"file removed");
	}
	else
	{
		//NSLog(@"remove failed");
	}
    
    // nuke the pictures directory
    if([filemgr removeItemAtPath:ApplicationsPicPath error:nil])
	{
		//NSLog(@"file removed");
	}
	else
	{
		//NSLog(@"remove failed");
	}
}

-(void)AddPicturesToRequest:(NSString *)TheVisit
{
    NSFileManager   *filemgr;
    NSArray         *PicPaths;
    int             NumberOfFiles=0;
    int             i;
    
    filemgr = [NSFileManager defaultManager];
    
    PicPaths            = [filemgr contentsOfDirectoryAtPath:TheVisit error:nil];
    NumberOfFiles       = (int)[PicPaths count];
    
    // clean out PictureList
    [self.PictureList removeAllObjects];
    
    // build up PictureList
    for(i=0; i<NumberOfFiles; i++)
    {
        // build the path to the file
        [self.PictureList addObject:[TheVisit stringByAppendingPathComponent:[PicPaths objectAtIndex:i]]];
        //NSLog(@"%@",[PictureList objectAtIndex:i]);
    }
    
    return;
}

//
// UploadObservation contains the previous code for
// UploadVisit.  This is for reference only and not
// called
//
-(void)UploadObservation:(NSString *)TheVisit
{
    NSError         *Error;
    NSString        *operation = @"xmlpluspics";
    NSString        *XMLData   = [NSString stringWithContentsOfFile:TheVisit
                                                           encoding:NSUTF8StringEncoding error:&Error];
    NSString        *NumFiles  = [[NSString alloc]init];
    
    NSString        *FileName  = [[NSString alloc]initWithFormat:@"%@",[TheVisit lastPathComponent]];
    
    TheVisitName               = [[NSString alloc]initWithFormat:@"%@",[TheVisit lastPathComponent]];
    
    [self ReadOptionsFromFile];
    
    ServerMode     = UPLOADMODE;
    
    NSString *uname=[[NSString alloc] initWithFormat:@"%@",[self  GetUserName]];
	NSString *sname=[[NSString alloc] initWithFormat:@"%@",[self  GetServerName]];
	NSString *pword=[[NSString alloc] initWithFormat:@"%@",[self  GetUserPassword]];
    NSString *nl   =@"\r\n";
    NSString *pics =[TheVisit stringByDeletingPathExtension];
    
    [self AddPicturesToRequest:pics];
    NumFiles       =[NSString stringWithFormat:@"%lu",(unsigned long)[self.PictureList count]];
    
    
    //
    // build the HTTP request complete with pictures
    //
    // create the necessary variables for this technique
    NSString        *boundary    = @"---------------------------7d7119bb0c50";
    NSMutableData   *body        = [NSMutableData data];
    NSString        *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    NSString *url = [NSString stringWithFormat:@"http:%@/cwis438/WebServices/ReceiveXML_iOS.php",sname];
    //NSString *url = [NSString stringWithFormat:@"http:%@/data_user/lkc/ReceiveXML.php",sname];
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] init];
    [theRequest setURL:[NSURL URLWithString:url]];
    [theRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // login parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[uname dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    // password parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[pword dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    // operation parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Operation\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[operation dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    // numfiles parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"NumFiles\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NumFiles dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // XMLName parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"XMLName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[FileName dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    // XMLData parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"XMLData\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[XMLData dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // if there are any pictures, send 'em here
    for(int i=0; i < [self.PictureList count]; i++)
    {
        NSString *filename = [[NSString alloc]initWithString:[self.PictureList objectAtIndex:i]];
        NSData *Data = [NSData dataWithContentsOfFile:filename];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile[]\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:Data]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set up the request
    [theRequest setHTTPBody:body];
    
    [theRequest setHTTPMethod:@"POST"];
    
    // this starts the networking activities.
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    // timeout
    theTimer = [NSTimer scheduledTimerWithTimeInterval:75.0 target:self selector:@selector(cancelURLConnection:) userInfo:nil repeats:NO];
	
	if( theConnection )
	{
		self.WebData = [NSMutableData data];
	}
	else
	{
		NSLog(@"the connection failed here");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"Network timeout!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
	}
}

//
// this method has been modified to upload a visit
// using open authentication.  The original version
// of this method is in UploadObservation and it not
// called.  Ever.
//
-(void)UploadVisit:(NSString *)TheVisit
{
    ConnectionType              = UPLOADOBSERVATION;
    NSString        *NumFiles   = [[NSString alloc]init];
    NSString        *TheToken   = [self GetAccessToken];
    //TheToken                    = [self GetRefreshToken];  // force error
    
    TheVisitName                = [[NSString alloc]initWithFormat:@"%@",[TheVisit lastPathComponent]];
    
    ServerMode                  = UPLOADMODE;
    
    NSString *nl                = @"\r\n";
    NSString *pics              = [TheVisit stringByDeletingPathExtension];
    
    [self AddPicturesToRequest:pics];
    NumFiles                    = [NSString stringWithFormat:@"%lu",(unsigned long)[self.PictureList count]];
    
    //
    // build the HTTP request complete with pictures
    //
    // create the necessary variables for this technique
    NSString        *boundary    = @"---------------------------7d7119bb0c50";
    NSMutableData   *body        = [NSMutableData data];
    NSString        *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    NSString *url = [NSString stringWithFormat:@"%@",UPLOAD_URL];
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] init];
    [theRequest setURL:[NSURL URLWithString:url]];
    [theRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // token parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Token\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[TheToken dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    // numfiles parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"NumFiles\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NumFiles dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // XMLData parameter (as a file)
    NSData *FileAsData = [NSData dataWithContentsOfFile:TheVisit];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"XMLData\"; filename=\"%@\"\r\n", TheVisitName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:FileAsData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    
    // if there are any pictures, send 'em here
    for(int i=0; i < [self.PictureList count]; i++)
    {
        NSString *filename = [[NSString alloc]initWithString:[self.PictureList objectAtIndex:i]];
        NSData *Data = [NSData dataWithContentsOfFile:filename];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile[]\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:Data]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set up the request
    [theRequest setHTTPBody:body];
    
    [theRequest setHTTPMethod:@"POST"];
    
    // this starts the networking activities.
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    // timeout
    theTimer = [NSTimer scheduledTimerWithTimeInterval:75.0 target:self selector:@selector(cancelURLConnection:) userInfo:nil repeats:NO];
	
	if( theConnection )
	{
		self.WebData = [NSMutableData data];
	}
	else
	{
		NSLog(@"the connection failed here");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"Network timeout!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
	}
}



-(NSString *)GetSystemName
{
    NSString *name = [[NSString alloc] init];
    int TheCount = (int)[AllSystemNames count];
    name = nil;
    
    if(SystemIndex<TheCount)
    {
        name=[AllSystemNames objectAtIndex:SystemIndex];
        SystemIndex++;
    }
    else
    {
        ////name=nil;
    }
    
    return name;
    
    ////[name release];
}

-(void)ResetSystemNames
{
    SystemIndex=0;
}

-(NSString *)GetPicturePath
{
    // get a file manager for directory access
	NSFileManager *filemgr;
	NSString	  *ApplicationsPath;
	NSArray		  *DirectoryPaths;
	
	filemgr = [NSFileManager defaultManager];
    
    [self ReadOptionsFromFile];
	
	// create the directory for this application in the Docs directory
	DirectoryPaths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath = [DirectoryPaths objectAtIndex:0];
    ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
    ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:VISITSPATH];
    
    // create the path if it doesn't exist
    [filemgr createDirectoryAtPath:ApplicationsPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return ApplicationsPath;
}

-(void)SetNextView:(int)TheViewNumber
{
    NextViewValue = TheViewNumber;
}
-(int)GetNextView
{
    return NextViewValue;
}

-(void)SetPreviousMode:(Boolean)TheValue
{
    PreviousMode=TheValue;
}
-(Boolean)GetPreviousMode
{
    return PreviousMode;
}

-(void)SetGoingForward:(Boolean)TheValue
{
    GoingForward = TheValue;
}
-(Boolean)GetGoingForward
{
    return GoingForward;
}

-(void)SetFirstSelect:(Boolean)TheValue
{
    FirstSelectSet=TheValue;
}
-(Boolean)GetFirstSelect
{
    return FirstSelectSet;
}
-(void)CheckFirstSelect
{
    // see if this attribute index is the first select
    // if so, set first select to true
    int i   = [self GetCurrentAttributeChoiceIndex];
    
    [self SetFirstSelect:true];
    for(int c=0; c < i; c++)
    {
        NSString *foo = [self GetAttributeDataTypeAtIndex:c];
        foo = [foo lowercaseString];
        if ([foo isEqualToString:@"select"])
        {
            [self SetFirstSelect:false];
            break;
        }
    }
}

-(void)SetSelectIndex:(int)TheIndex
{
    FirstSelectAttributeChoiceIndex=TheIndex;
}
-(int)GetSelectIndex
{
    return FirstSelectAttributeChoiceIndex;
}

-(void)SetOrganismCameraCalled:(Boolean)TheValue
{
    OrganismCameraCalled = TheValue;
}
-(Boolean)GetOrganismCameraCalled
{
    return OrganismCameraCalled;
}

-(void)SetOrganismCameraComment:(NSString *)AComment
{
    OrganismCameraComment = [[NSString alloc]initWithString:AComment];
}
-(NSString *)GetOrganismCameraComment
{
    return OrganismCameraComment;
}

-(void)SetOrganismCameraParent:(int)TheValue
{
    OrganismCameraParent = TheValue;
}
-(int)GetOrganismCameraParent
{
    return OrganismCameraParent;
}

-(void)SetOrganismCameraSelectRow:(int)TheValue
{
    OrganismCameraSelectRow = TheValue;
}
-(int)GetOrganismCameraSelectRow
{
    return OrganismCameraSelectRow;
}

-(void)SetOrganismCameraSelectValue:(NSString *)TheValue
{
    OrganismCameraSelectValue = [[NSString alloc]initWithString:TheValue];
}
-(NSString *)GetOrganismCameraSelectValue
{
    return OrganismCameraSelectValue;
}

-(void)SetOrganismCameraEnterValue:(NSString *)AValue
{
    OrganismCameraEnterValue = [[NSString alloc]initWithString:AValue];
}
-(NSString *)GetOrganismCameraEnterValue
{
    return OrganismCameraEnterValue;
}

-(void)SetIsNewOrganism:(Boolean)TheValue
{
    NewOrganism = TheValue;
    if(TheValue)
    {
        [self SetCurrentAttributeNumber:1];
    }
}
-(Boolean)GetIsNewOrganism
{
    //[self showorgpicklist];
    return NewOrganism;
}

-(void)showorgpicklist
{
    NSMutableArray *foo;
    int thecount = (int)[self.OrganismPicklist count];

    for(int i=0; i<thecount; i++)
    {
        foo = [self.OrganismPicklist objectAtIndex:i];
        if([foo count] == 0)
        {
            NSLog(@"empty picklist entry so specified organism");
        }
        else
        {
            NSLog(@"this is a pickklist so select the organism: orgpicklist[%d]=%@",i,foo);
        }
    }
}

-(void)SkipOrganism
{
    if([self GetIsNewOrganism])
    {
        int Index           = [self GetCurrentOrganismIndex];
        NSString *temp      = [[NSString alloc]initWithFormat:@"%@",[self GetOrganismCommentAtIndex:Index]];
        [self ReplaceOrganismCommentAtIndex:temp:Index];
        [self PopulateEmptyAttribute];
        
        [self SetNextAttribute];
        
        while(!([self GetIsNewOrganism]))
        {
            [self PopulateEmptyAttribute];
            [self SetNextAttribute];
            if(([self GetIsLast]) || ([self GetCollectionType]==COLLECTSITE))
            {
                break;
            }
        }
    }
}

-(void)PopulateEmptyAttribute
{
    NSString *SelectType    = [[NSString alloc] initWithFormat:@"%@", [self GetCurrentAttributeType]];
    SelectType              = [SelectType lowercaseString];
    Boolean Prev            = [self GetPreviousMode];
    NSString *temp          = [[NSString alloc]initWithFormat:@""];
    
    if([SelectType isEqualToString:@"entered"])
    {
        if(!Prev)
        {
            [self SetCurrentAttributeDataValue:temp];
        }
    }
    else if([SelectType isEqualToString:@"select"])
    {
        if(Prev)
        {
            int TheIndex    = [self GetCurrentAttributeChoiceIndex]+ATTRIBUTEINDEXOFFSET;
            temp            = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:TheIndex]];
            [self ReplaceAttributeDataValueAtIndex:TheIndex:temp];
        }
        else
        {
            temp = [[NSString alloc]initWithFormat:@"-- Select --"];
            [self SetCurrentAttributeDataValue:temp];
        }
    }
}

-(void)SetCameraMode:(int)TheMode
{
    CameraMode = TheMode;
}
-(int)GetCameraMode
{
    return CameraMode;
}

-(void)SetViewType:(int)TheType
{
    TheViewType = TheType;
}

-(int)GetViewType
{
    return TheViewType;
}

-(void)SetViewAfterPicklist:(int)TheViewNumber
{
    TheViewAfterPicklist = TheViewNumber;
}
-(int)GetViewAfterPicklist
{
    return TheViewAfterPicklist;
}

-(void)SetCallNextAttribute:(Boolean)TheValue
{
    CallSetNextAttribute    = TheValue;
}
-(Boolean)GetCallNextAttribute
{
    return CallSetNextAttribute;
}

-(Boolean)ValidFloat:(NSString *)TheValue
{
    Boolean ReturnValue             = true;
    NSNumberFormatter *formatter    = [NSNumberFormatter new];
    NSNumber *num                   = [formatter numberFromString:TheValue];
    ReturnValue                     = (num != nil);
    return ReturnValue;
}

-(Boolean)ValidLat:(NSString *)TheValue
{
    Boolean ReturnValue             = true;
    double  num                     = [TheValue doubleValue];
    double  lower                   = -90.0;
    double  upper                   = 90.0;
    if(num > upper)
    {
        ReturnValue                 = false;
    }
    if(num < lower)
    {
        ReturnValue                 = false;
    }
    return ReturnValue;
}

-(Boolean)ValidLon:(NSString *)TheValue
{
    Boolean ReturnValue             = true;
    double  num                     = [TheValue doubleValue];
    double  lower                   = -180.0;
    double  upper                   = 180.0;
    if(num > upper)
    {
        ReturnValue                 = false;
    }
    if(num < lower)
    {
        ReturnValue                 = false;
    }
    return ReturnValue;
}

-(void)SetBioblitzDispaly:(Boolean)TheValue
{
    BioblitzDisplay = TheValue;
}
-(Boolean)GetBioblitzDisplay
{
    return BioblitzDisplay;
}

//
// this method checks for inconsistent edit states
// between the observation and the data sheet.  If
// all is OK, this method returns consistent
// The items being checked:
// 1. date of observation should be older than the data sheet
// 2. missing data sheet
// 3. data sheet has fields not in observation
// 4. observation has fields not in data sheet
//
-(int)InconsistentEdit:(NSString *)ObservationName
{
    return CONSISTENT;
}

#pragma mark - forms
-(void)SetCurrentFormName:(NSString *)TheName
{
    self.CurrentFormName=[NSString stringWithFormat:@"%@",TheName];
}
-(NSString *)GetCurrentFormName
{
    return self.CurrentFormName;
}

-(void)SetCurrentFormID:(NSString *)TheID
{
    self.CurrentFormID=[NSString stringWithFormat:@"%@",TheID];
}
-(NSString *)GetCurrentFormID
{
    return self.CurrentFormID;
}

-(void)SetFormNames
{
    ////[FormNames release];
    ////FormNames = [[NSMutableArray alloc]init];
    [self.FormNames removeAllObjects];
    [self.FormIDs removeAllObjects];
    
    NSString *CurrentProject  = [[NSString alloc] initWithFormat:@"%@",[self GetCurrentProjectName]];
    
    ProjectNode *TempProject = ProjectHead;
    Boolean     ProjectFound  = false;
    
    while(TempProject != nil)
    {
        if([CurrentProject isEqualToString:TempProject->ProjectName])
        {
            ProjectFound = true;
            break;
        }
        else
        {
            TempProject = TempProject->NextProject;
        }
    }
    
    if(!ProjectFound)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"Internal error: 103. Contact leeway software design lkc@leewaysd.com"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
		[alert show];
        ////exit(103);
    }
    
    
    FormNode *temp = TempProject->FormHead;
    while(temp != nil)
    {
        NSString *foo = [[NSString alloc]initWithFormat:@"%@",temp->FormName];
        if([foo isEqualToString:@""])
        {
            foo = [[NSString alloc]initWithFormat:@"No Name Specified"];
            ////NSLog(@"found an un name form");
        }
        [self.FormNames addObject:foo];
        
        foo = [temp getFormID:temp];
        if(foo == nil)
        {
            [self.FormIDs addObject:@"no form id"];
        }
        else
        {
            [self.FormIDs addObject:foo];
        }
        
        temp = temp->NextForm;
    }

}
-(NSMutableArray *)GetFormNames
{
    [self SetFormNames];
    return self.FormNames;
}
-(NSMutableArray *)GetFormIDs
{
    //NSMutableArray *dummy = nil;
    //[self SetFormNames:dummy];
    return self.FormIDs;
    //[dummy release];
}

#pragma mark - projects
-(void)SetCurrentProjectName:(NSString *)TheName
{
	self.CurrentProjectName=[NSString stringWithFormat:@"%@",TheName];
}
-(NSString *)GetCurrentProjectName
{
    return self.CurrentProjectName;
}

-(void)SetCurrentProjectID:(NSString *)TheID
{
	self.CurrentProjectID=[NSString stringWithFormat:@"%@",TheID];
}
-(NSString *)GetCurrentProjectID
{
    return self.CurrentProjectID;
}

-(void)SetProjectNames
{
    ////[ProjectNames release];
    ////[ProjectIDs release];
    ////ProjectNames              = [[NSMutableArray alloc] init];
    ////ProjectIDs                = [[NSMutableArray alloc] init];
    [self.ProjectNames removeAllObjects];
    [self.ProjectIDs removeAllObjects];
    
    ProjectNode *temp = ProjectHead;
    
    while(temp != nil)
    {
        NSString *foo = [[NSString alloc]initWithFormat:@"%@",[temp GetProjectName:temp]];
        
        if(foo == nil)
        {
            ////NSLog(@"we did not get a project name.  wonder why");
        }
        else
        {
            [self.ProjectNames addObject:foo];
            
            foo = [temp GetProjectID:temp];
            if(foo == nil)
            {
                ////NSLog(@"did not get a project id.  wonder why");
                [self.ProjectIDs addObject:@"no project id"];
            }
            else
            {
                [self.ProjectIDs addObject:foo];
            }
        }
        
        ////[foo release];
        temp = temp->NextProject;
    }
    ////[temp release];
}
-(NSMutableArray *)GetProjectNames
{
    return self.ProjectNames;
}
-(NSMutableArray *)GetProjectIDs
{
    return self.ProjectIDs;
}

-(void)SetProjectDataAvailable:(Boolean)TheValue
{
    ProjectDataAvailable = TheValue;
}
-(Boolean)GetProjectDataAvailable
{
    return ProjectDataAvailable;
}


-(Boolean)GetProjectDataFromServer
{
    [self GetXMLFromServer:XMLPROJECTSFILE];

    return true;
}

#pragma mark -
#pragma mark attribute functions
-(void)SetSiteCharacteristicsCount:(int)TheNumber
{
    SiteCharacteristicCount=TheNumber;
}
-(int)GetSiteCharacteristicsCount
{
    return SiteCharacteristicCount;
}

-(void)SetAuthorityRowNumber:(int)TheRow
{
    AuthoritySelection=TheRow;
}
-(int)GetAuthorityRowNumber
{
    return AuthoritySelection;
}

-(void)SetCurrentOrganismName
{
    int localindex = [self GetCurrentOrganismIndex];
    
    if(localindex < [self.OrganismDataName count])
    {
        @try 
        {
            self.CurrentOrganismName=[NSString stringWithFormat:@"%@",[self.OrganismDataName objectAtIndex:localindex]];
        }
        @catch (NSException *e)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"error case 4 call lee"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        self.CurrentOrganismName=[[NSString alloc]initWithFormat:@"%@",@""];
    }
}
-(NSString *)GetCurrentOrganismName
{
    [self SetCurrentOrganismName];
    return self.CurrentOrganismName;
}
-(NSString *)GetOrganismNameAtIndex:(int)TheIndex
{
    NSString *foo;
    @try
    {
        foo = [[NSString alloc]initWithFormat:@"%@",[self.OrganismDataName objectAtIndex:TheIndex]];
    }
    @catch (NSException *e)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"error case 5 call lee"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        foo = [[NSString alloc]initWithFormat:@"%@",@""];

    }
    return foo;
}

-(void)ReplaceOrganismCommentAtIndex:(NSString *)TheComment : (int)TheIndex
{
    if([self.OrganismDataComment count] <= TheIndex)
    {
        [self.OrganismDataComment addObject:TheComment];
    }
    else
    {
        [self.OrganismDataComment replaceObjectAtIndex:TheIndex withObject:TheComment];
    }
}

-(void)ReplaceOrganismDataNameAtIndex:(NSString *)TheName :(int)TheIndex
{
    if([self.OrganismDataName count] <= TheIndex)
    {
        [self.OrganismDataName addObject:TheName];
    }
    else
    {
        [self.OrganismDataName replaceObjectAtIndex:TheIndex withObject:TheName];
    }
}

-(void)ReplaceOrganismDataIDsAtIndex:(NSString *)TheID :(int)TheIndex
{
    if([self.OrganismDataIDs count] <= TheIndex)
    {
        [self.OrganismDataIDs addObject:TheID];
    }
    else
    {
        [self.OrganismDataIDs replaceObjectAtIndex:TheIndex withObject:TheID];
    }
}

-(NSString *)GetOrganismCommentAtIndex:(int)TheIndex
{
    NSString *foo;
    @try
    {
        foo = [[NSString alloc]initWithFormat:@"%@",[self.OrganismDataComment objectAtIndex:TheIndex]];
    }
    @catch (NSException *e)
    {
        //
        // no comment here so populate it with emptiness
        //
        foo = [[NSString alloc]initWithFormat:@"%@",@""];
        
    }
    return foo;
}

-(void)SetCurrentOrganismAttributeIndex:(int)TheIndex
{
    CurrentOrganismAttributeIndex=TheIndex;
}
-(int)GetCurrentOrganismAttributeIndex
{
    return CurrentOrganismAttributeIndex;
}

-(void)SetCurrentOrganismID
{
    int localindex = [self GetCurrentOrganismIndex];
    
    if(localindex < [self.OrganismDataIDs count])
    {
        @try
        {
            self.CurrentOrganismID=[NSString stringWithFormat:@"%@",[self.OrganismDataIDs objectAtIndex:localindex]];
        }
        @catch (NSException *e)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"error case 6 call lee"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        self.CurrentOrganismID=[[NSString alloc]initWithFormat:@"%@",@""];
    }
}
-(NSString *)GetCurrentOrganismID
{
    return self.CurrentOrganismID;
}
-(NSString *)GetOrganismIDAtIndex:(int)TheIndex
{
    NSString *foo;
    @try
    {
        foo = [[NSString alloc]initWithFormat:@"%@",[self.OrganismDataIDs objectAtIndex:TheIndex]];
    }
    @catch (NSException *e)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"error case 7 call lee"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        foo = [[NSString alloc]initWithFormat:@"%@",@""];

    }
    return foo;
}

-(int)GetOrganismCount
{
    //NSLog(@"organism count = %d",[OrganismDataName count]);
    return (int)[self.OrganismDataName count];
}

-(void)SetCurrentOrganismIndex:(int)TheIndex
{
    CurrentOrganismIndex=TheIndex;
}
-(int)GetCurrentOrganismIndex
{
    return CurrentOrganismIndex;
}

-(void)SetCurrentAttributeName
{
    int localindex = [self GetCurrentAttributeChoiceIndex];
    
    if(localindex < [self.AttributeDataName count])
    {
        @try
        {
            self.CurrentAttributeName=[NSString stringWithFormat:@"%@",[self.AttributeDataName objectAtIndex:localindex]];
        }
        @catch (NSException *e)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"error case 8 call lee"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        self.CurrentAttributeName=[[NSString alloc]initWithFormat:@"%@",@""];
    }
}
-(NSString *)GetCurrentAttributeName
{
    return self.CurrentAttributeName;
}

-(void)SetCurrentAttributeNumber:(int)TheNumber
{
    CurrentAttributeNumber = TheNumber;
}
-(int)GetCurrentAttributeNumber
{
    return CurrentAttributeNumber;
}

//
// returns 0 for for the first attribute
// returns 1 for the second...
//
-(int)GetAttributeNumberForCurrentOrganism
{
    int         TheAttributeNumber      = [self GetCurrentAttributeChoiceIndex];
    int         TheOrganismCount        = [self GetOrganismCount];
    int         LocalCount;
    int         NumAttrForThisOrg;
    
    //
    // map TheAttributeNumber to the attribute number
    // associated with the current organism.  For example,
    // if TheAttributeNumber is 1, and there are 3 attributes
    // in the first organism, we are working on attribute 2 of 3
    //
    // to do this, march down OrganismNumberOfAttributes counting
    // attributes until we get to TheAttributeNumber.
    
    LocalCount  = 0;
    for(int i=0; i < TheOrganismCount; i++)
    {
        int NumAttributes = [self GetOrganismNumberOfAttributes:i];
        for(int j=0; j < NumAttributes; j++)
        {
            NumAttrForThisOrg   = [self GetCurrentOrganismAttributeCount];
            if(LocalCount == TheAttributeNumber)
            {
                return j;
            }
            LocalCount++;
        }
    }
    return 0;
}

-(NSString *)GetActiveAttributeString
{
    NSString    *TheString              = @"";
    int         TheAttributeNumber      = [self GetCurrentAttributeChoiceIndex];
    int         TheOrganismCount        = [self GetOrganismCount];
    int         LocalCount;
    int         NumAttrForThisOrg;
    
    //
    // map TheAttributeNumber to the attribute number
    // associated with the current organism.  For example,
    // if TheAttributeNumber is 1, and there are 3 attributes
    // in the first organism, we are working on attribute 2 of 3
    //
    // to do this, march down OrganismNumberOfAttributes counting
    // attributes until we get to TheAttributeNumber.
    
    LocalCount  = 0;
    for(int i=0; i < TheOrganismCount; i++)
    {
        int NumAttributes = [self GetOrganismNumberOfAttributes:i];
        for(int j=0; j < NumAttributes; j++)
        {
            NumAttrForThisOrg   = [self GetCurrentOrganismAttributeCount];
            if(LocalCount == TheAttributeNumber)
            {
                TheString = [[NSString alloc]initWithFormat:@"Attribute %d of %d",j+1,NumAttributes];
                return TheString;
            }
            LocalCount++;
        }
    }
    
    return TheString;
}

-(NSString *)GetAttributeNameAtIndex:(int)TheIndex
{
    NSString *foo;
    @try
    {
        foo = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataName objectAtIndex:TheIndex]];
    }
    @catch (NSException *e)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"error case 9 call lee"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        foo = [[NSString alloc]initWithFormat:@"%@",@""];
    }
    return foo;
}
-(NSString *)GetAttributeDataTypeAtIndex:(int)TheIndex
{
    NSString *foo;
    @try
    {
        foo = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataType objectAtIndex:TheIndex]];
    }
    @catch (NSException *e)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"error case 10 call lee"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        foo = [[NSString alloc]initWithFormat:@"%@",@""];
    }
    return foo;
}

-(NSString *)GetAttributeDataTypeModifierAtIndex:(int)TheIndex
{
    NSString *foo;
    @try
    {
        foo = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataTypeModifier objectAtIndex:TheIndex]];
    }
    @catch (NSException *e)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"error case 10.1 call lee"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        foo = [[NSString alloc]initWithFormat:@"%@",@""];
    }
    return foo;
}

-(void)SetCurrentAttributeValue:(NSString *)TheValue
{
    self.CurrentAttributeValue=[NSString stringWithFormat:@"%@",TheValue];
}
-(NSString *)GetCurrentAttributeValue
{
    return self.CurrentAttributeValue;
}

-(void)SetCurrentAttributeType
{
    int localindex = [self GetCurrentAttributeChoiceIndex];
    
    if(localindex < [self.AttributeDataType count])
    {
        @try
        {
            self.CurrentAttributeType = [NSString stringWithFormat:@"%@",[self.AttributeDataType objectAtIndex:localindex]];
        }
        @catch (NSException *e)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"error case 11 call lee"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        self.CurrentAttributeType = [[NSString alloc]initWithFormat:@"%@",@""];
    }
}

-(void)SetCurrentAttributeTypeModifier
{
    int localindex = [self GetCurrentAttributeChoiceIndex];
    
    if(localindex < [self.AttributeDataType count])
    {
        @try
        {
            self.CurrentAttributeTypeModifier = [NSString stringWithFormat:@"%@",[self.AttributeDataTypeModifier objectAtIndex:localindex]];
        }
        @catch (NSException *e)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"error case 11.1 call lee"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        self.CurrentAttributeTypeModifier = [[NSString alloc]initWithFormat:@"%@",@""];
    }
}

-(NSString *)GetCurrentAttributeType
{
    return self.CurrentAttributeType;
}
-(NSString *)GetCurrentAttributeTypeModifier
{
    return self.CurrentAttributeTypeModifier;
}

-(void)SetCurrentAttributeChoiceCount
{
    int localindex  = [self GetCurrentAttributeChoiceCountIndex];
    int returnindex = 0;
    NSString *foo;
    
    if(localindex < 0)
    {
        returnindex = 0;
    }
    else
    {
        if([self.AttributeDataChoiceCount count] == 0)
        {
            returnindex=0;
        }
        else
        {
            @try
            {
                foo = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataChoiceCount objectAtIndex:localindex]];
                returnindex = (int)[foo integerValue];
            }
            @catch (NSException *e)
            {
                NSLog(@"case 12");
                //[self DumpAttributeData];
                [self ShowIndexes];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:@"error case 12 call lee"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }
    }
    CurrentAttributeChoiceCount=returnindex;
    ////[foo release];
}
-(int)GetCurrentAttributeChoiceCount
{
    return CurrentAttributeChoiceCount;
}

-(void)SetCurrentAttributeChoiceIndex:(int)TheIndex
{
    CurrentAttributeChoiceIndex=TheIndex;
}
-(int)GetCurrentAttributeChoiceIndex
{
    return CurrentAttributeChoiceIndex;
}

-(void)SetCurrentAttributeChoices
{
    [CurrentAttributeChoices removeAllObjects];
    // Select spinner code -- lkc
    ////[CurrentAttributeChoices addObject:@"== Select =="];
    int start   = [self GetCurrentAttributeDataChoicesIndex];
    int x       = [self GetCurrentAttributeChoiceCountIndex];
    NSString *foo;
    
    if(x >= 0)
    {
        @try
        {
            foo = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataChoiceCount objectAtIndex:x]];
        }
        @catch (NSException *e)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"error case 13 call lee"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            foo = @"0";
        }
        int limit     = (int)[foo integerValue];
        int i;
        NSString *x;
        for(i=start;i<limit+start;i++)
        {
            @try
            {
                x = [self.AttributeDataChoices objectAtIndex:i];
            }
            @catch (NSException *e)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:@"error case 14 call lee"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                x = @"0";
            }
            [self.CurrentAttributeChoices addObject:x];
        }
    }
}
-(NSMutableArray *)GetCurrentAttributeChoices
{
    return self.CurrentAttributeChoices;
}

-(void)SetCurrentAttributeDataChoicesIndex:(int)TheIndex
{
    CurrentAttributeDataChoicesIndex=TheIndex;
}
-(int)GetCurrentAttributeDataChoicesIndex
{
    return CurrentAttributeDataChoicesIndex;
}

-(void)SetUnitIDs:(NSMutableArray *)TheIDs
{
    self.UnitIDs = TheIDs;
}
-(NSMutableArray *)GetUnitIDs
{
    return self.UnitIDs;
}

-(void)SetUnitAbbreviation:(NSMutableArray *)TheUnits
{
    self.UnitAbbreviation = TheUnits;
}
-(NSMutableArray *)GetUnitAbbreviation
{
    return self.UnitAbbreviation;
}

-(void)SetCurrentAttributeChoiceCountIndex:(int)TheIndex
{
    CurrentAttributeChoiceCountIndex=TheIndex;
}
-(int)GetCurrentAttributeChoiceCountIndex
{
    return CurrentAttributeChoiceCountIndex;
}

-(void)SetCurrentAttributeDataValue:(NSString *)TheValue
{
    if (TheValue == 0)
    {
        [self.AttributeDataValue addObject:@""];
    }
    else
    {
        [self.AttributeDataValue addObject:TheValue];
    }
}
-(NSString *)GetCurrentAttributeDataValue
{
    int localindex = [self GetCurrentAttributeChoiceIndex];
    NSString *returnvalue;
    
    @try
    {
        returnvalue = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataValue objectAtIndex:localindex]];
    }
    @catch (NSException *e)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"error case 15 call lee"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        returnvalue = [[NSString alloc]initWithFormat:@"%@",@""];
    }
    return returnvalue;
}
-(int)GetCurrentAttributeDataValueCount
{
    return (int)[self.AttributeDataValue count];
}
-(NSString *)GetCurrentAttributeDataValueAtIndex:(int)TheIndex
{
    NSString *temp;
    
    @try
    {
        temp = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataValue objectAtIndex:TheIndex]];
    }
    @catch (NSException *e)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"error case 16 call lee"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        temp = [[NSString alloc]initWithFormat:@"%@",@""];
    }
    return temp;
}
-(void)ClearCurrentAttributeDataValues
{
    [self.AttributeDataValue removeAllObjects];
}
-(void)ReplaceAttributeDataValueAtIndex:(int)TheIndex :(NSString *)NewValue
{
    [self.AttributeDataValue replaceObjectAtIndex:TheIndex withObject:NewValue];
}
-(void)ReplaceAttributeDataSelectRowAtIndex:(int)TheIndex :(NSString *)NewRow
{
    [self.AttributeDataSelectRow replaceObjectAtIndex:TheIndex withObject:NewRow];
}

-(void)SetAttributeDataSelectRow:(NSString *)TheRow
{
    [self.AttributeDataSelectRow addObject:TheRow];
}
-(int)GetAttributeDataSelectRowAtIndex:(int)TheIndex
{
    NSString *foo;
    @try
    {
        foo   = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataSelectRow objectAtIndex:TheIndex]];
    }
    @catch (NSException *e)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"error case 17 call lee"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        foo = [[NSString alloc]initWithFormat:@"%@",@"0"];
    }
    int i           = (int)[foo integerValue];
    
    return i;
}


//
// dumps all the data structures for the organisms, sites,
// and attributes
//
-(void)DumpAttributeData
{
    int odncount = (int)[self.OrganismDataName count];
    int onacount = (int)[self.OrganismNumberOfAttributes count];
    int odicount = (int)[self.OrganismDataIDs count];
    
    int adncount = (int)[self.AttributeDataName count];
    int adtcount = (int)[self.AttributeDataType count];
    int adicount = (int)[self.AttributeDataTypeIDs count];
    int adccount = (int)[self.AttributeDataChoiceCount count];
    int adchcount= (int)[self.AttributeDataChoices count];
    //int caccount = (int)[self.UnitAbbreviation count];
    int cacindex = (int)[self GetCurrentAttributeChoiceIndex];
    
    NSLog(@"=== indexes ===");
    NSLog(@"OrganismIndex:  %d",[self GetCurrentOrganismIndex]);
    NSLog(@"AttributeIndex: %d",cacindex);
    //NSLog(@"=== Units ==");
    //for(int i=0; i<caccount;i++)
    //{
    //    NSLog(@"\tunit[%d]=%@",i,[self.UnitAbbreviation objectAtIndex:i]);
    //}
    NSLog(@"=== organism names ===");
    for(int i=0; i<odncount;i++)
    {
        NSLog(@"\torganismdataname[%d]=%@",i,[self.OrganismDataName objectAtIndex:i]);
    }
    NSLog(@"\n");
    
    NSLog(@"=== organism count ===");
    NSLog(@"\tOrganismCount: %d",[self GetOrganismCount]);
    NSLog(@"\n");
    
    NSLog(@"=== organism number of attributes for each organism ===");
    for(int i=0; i<onacount;i++)
    {
        NSLog(@"\torganismnumberofattributes[%d]=%@",i,[self.OrganismNumberOfAttributes objectAtIndex:i]);
    }
    NSLog(@"\n");
    
    NSLog(@"=== organism data ids ===");
    for(int i=0; i<odicount;i++)
    {
        NSLog(@"\torganismdataids[%d]=%@",i,[self.OrganismDataIDs objectAtIndex:i]);
    }
    NSLog(@"\n");
    
    NSLog(@"=== attribute data names ===");
    for(int i=0; i<adncount;i++)
    {
        NSLog(@"\tattributedataname[%d]=%@",i,[self.AttributeDataName objectAtIndex:i]);
    }
    NSLog(@"\n");
    
    NSLog(@"=== attribute data types ===");
    for(int i=0; i<adtcount;i++)
    {
        NSLog(@"\tattributedatatype[%d]=%@",i,[self.AttributeDataType objectAtIndex:i]);
    }
    NSLog(@"\n");
    
    NSLog(@"=== attribute data type modifier ===");
    for(int i=0; i<adtcount;i++)
    {
        NSLog(@"\tattributedatatypemodifier[%d]=%@",i,[self.AttributeDataTypeModifier objectAtIndex:i]);
    }
    NSLog(@"\n");
    
    //[self DumpAttributeDataValues];
    //NSLog(@"\n");
    
    NSLog(@"=== attribute datatype id ===");
    for(int i=0; i<adicount;i++)
    {
        NSLog(@"\tattributedatatypeid[%d]=%@",i,[self.AttributeDataTypeIDs objectAtIndex:i]);
    }
    NSLog(@"\n");
    
    NSLog(@"SELECT VALUES");
    NSLog(@"=== attribute data choice count ===");
    for(int i=0; i<adccount;i++)
    {
        NSLog(@"\tattributedatachoicecount[%d]=%@",i,[self.AttributeDataChoiceCount objectAtIndex:i]);
    }
    NSLog(@"\n");
    
    NSLog(@"=== attribute data choices ===");
    for(int i=0; i<adchcount;i++)
    {
        NSLog(@"\tattributedatachoices[%d]=%@",i,[self.AttributeDataChoices objectAtIndex:i]);
    }
    
    NSLog(@"\n");
    [self ShowIndexes];
}

-(void)DumpIndexes
{
    NSLog(@"=== all indexes ===");
    NSLog(@"\tCurrentOrganismIndex:              %d",[self GetCurrentOrganismIndex]);
    NSLog(@"\tCurrentAttributeChoiceIndex:       %d",[self GetCurrentAttributeChoiceIndex]);
    NSLog(@"\tCurrentAttributeChoiceCountIndex:  %d",[self GetCurrentAttributeChoiceCountIndex]);
    NSLog(@"\n");
}

-(void)DumpArraySizes
{
    int odncount = (int)[self.OrganismDataName count];
    int onacount = (int)[self.OrganismNumberOfAttributes count];
    int odicount = (int)[self.OrganismDataIDs count];
    
    int adncount = (int)[self.AttributeDataName count];
    int adtcount = (int)[self.AttributeDataType count];
    int adicount = (int)[self.AttributeDataTypeIDs count];
    int adccount = (int)[self.AttributeDataChoiceCount count];
    int adchcount= (int)[self.AttributeDataChoices count];
    int advcount = (int)[self.AttributeDataValue count];
    
    NSLog(@"OrganismDataName[count]              = %d",odncount);
    NSLog(@"OrganismNumberOfAttributes[count]    = %d",onacount);
    NSLog(@"OrganismDataIDs[count]               = %d",odicount);
    
    NSLog(@"AttributeDataName[count]             = %d",adncount);
    NSLog(@"AttributeDataType[count]             = %d",adtcount);
    NSLog(@"AttributeDataTypeIDs[count]          = %d",adicount);
    NSLog(@"AttributeDataChoiceCount[count]      = %d",adccount);
    NSLog(@"AttributeDataChoices[count]          = %d",adchcount);
    NSLog(@"AttributeDataValue[count]            = %d",advcount);
    
}

-(void)DumpAttributeDataValues
{
    NSLog(@"=== attribute data values ===");
    for(int i = 0; i < [self.AttributeDataValue count]; i++)
    {
        NSLog(@"\tattributedatavalue[%d]=%@",i,[self.AttributeDataValue objectAtIndex:i]);
    }
}

-(void)DumpAttributeDataChoiceCount
{
    for(int i = 0; i < [self.AttributeDataChoiceCount count]; i++)
    {
        NSLog(@"attributedatachoicecount[%d]=%@",i,[self.AttributeDataChoiceCount objectAtIndex:i]);
    }
}

-(void)SetPreviousAttribute
{
    Boolean LocalAttribSet      = [self GetAttributesSet];
    Boolean LocalAuthSet        = [self GetAuthorityHasBeenSet];
    Boolean talktome            = false;
    int     LocalAttribIndex    = [self GetCurrentAttributeChoiceIndex];
    int     CurView             = [self GetCurrentViewValue];
    
    //
    // check to see if we're backing up to a pick list.
    // if so, leave everything as is.
    //
    int orgindex                = [self GetCurrentOrganismIndex];
    int attrnum                 = [self GetAttributeNumberForCurrentOrganism];
    NSMutableArray *pl          = [self GetOrganismPicklistAtIndex:orgindex];
    
    if(CurView != PICKLISTVIEW)
    {
        if( (attrnum == 0) && ([pl count] > 0))
        {
            // we are done, go back for a picklist
            return;
        }
    }
    
    [self SetIsNewOrganism:false];
    
    // check to see if this is the start of a new observation by
    // examining AttributesSet.
    // we need to know how to backup an attribute
    // if we are backing up to the name and comment screen do this
    // to get the attributes initialized
    if((LocalAttribSet==false) && (LocalAuthSet==false))
    {
        [self SetAuthorityHasBeenSet:true];     // and set the state
        [self SetCurrentValues];
        
        if(talktome)
        {
            NSLog(@"===authority and attribute not set");
            [self ShowIndexes];
            [self DumpAttributeDataValues];
        }
        
        return;
    }
    
    //
    // if we are backing up to the authority screen
    // do this to get the attributes count to the
    // start of the collection
    //
    if(LocalAttribIndex == 0)
    {
        ////talktome = true;
        [self SetAttributesSet:false];
        if(!([self GetKeepAuthoritySet]))
        {
            [self SetAuthoritySet:false];
        }
        [self SetAuthorityHasBeenSet:false];
        [self SetCurrentOrganismIndex:0];
        [self SetCurrentAttributeChoiceIndex:0];
        [self SetCurrentAttributeDataChoicesIndex:0];
        [self SetCurrentAttributeChoiceCountIndex:0];
        [self SetCurrentOrganismAttributeIndex:0];
        [self SetIsNewOrganism:true];
        
        //
        // set up the structures
        //
        [self SetCurrentValues];
        
        if(talktome)
        {
            NSLog(@"===only attribute not set");
            [self ShowIndexes];
            [self DumpAttributeData];
        }
        
        talktome=false;
        return;
    }
    
    //
    // if we are here, just decrement the counters and
    // ensure all the data structures are set correctly
    //
    if(LocalAttribIndex > 0)
    {
        talktome=false;
        if(talktome) NSLog(@"=== rest of the times through setpreviousattribute");
        //
        // calculate the indexes for the previous attribute
        //
        int LocalOrganismIndex              = [self GetCurrentOrganismIndex];
        int LocalAttributeChoiceIndex       = [self GetCurrentAttributeChoiceIndex]-1;
        int LocalAttributeDataChoicesIndex  = [self GetCurrentAttributeDataChoicesIndex];
        int LocalOrganismAttributeIndex     = [self GetCurrentOrganismAttributeIndex]-1;
        [self SetCurrentOrganismAttributeIndex:LocalOrganismAttributeIndex];
        
        NSString *foo                       = [[NSString alloc]init];
        
        if(talktome)
        {
            [self ShowIndexes];
            //[self DumpAttributeDataValues];
            //[self DumpArraySizes];
            //[self DumpAttributeData];
            talktome=false;
        }
        
        //
        // here's the setting the previous index layout
        // 1. decrement CurrentAttributeChoiceIndex for the arrays AttributeDataName and AttributeDataType
        [self SetCurrentAttributeChoiceIndex:LocalAttributeChoiceIndex];
        
        // 2. check if we're going back from site characteristics to organisms
        if([self GetCollectionType] == COLLECTSITE)
        {
            if(LocalAttributeChoiceIndex < [self GetOrganismAttributeCount])
            {
                [self SetCollectionType:COLLECTORGANISM];
                ////[self SetIsNewOrganism:true];
            }
        }
        
        // 3. check to see if we have a previous organism, site characteristic, or treatment
        //    a. if currentorganismattributeindex < 0, then decrement the organism
        if([self GetCollectionType]==COLLECTORGANISM)
        {
            if(LocalOrganismAttributeIndex < 0)
            {
                //
                // decrement the organism index
                //
                if( (LocalOrganismIndex-1) < 0)
                {
                    [self SetCurrentOrganismIndex:0];
                }
                else
                {
                    [self SetCurrentOrganismIndex:LocalOrganismIndex-1];
                }
                
                int xx = [self GetCurrentOrganismIndex];
                @try
                {
                    foo = [[NSString alloc]initWithFormat:@"%@",[self.OrganismNumberOfAttributes objectAtIndex:xx]];
                }
                @catch (NSException *e)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                    message:@"error case 18 call lee"
                                                                   delegate:nil cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                    [alert show];
                    foo = [[NSString alloc]initWithFormat:@"%@",@"0"];
                }
                xx = (int)[foo integerValue]-1;
                [self SetCurrentOrganismAttributeIndex:xx];
            }
        }
        
        // 4. set up for the previous attribute (this is only complicated for "Select"
        //    a. if AttributeDataType[currentattributeindex] == select
        //       i.   x = attributedatachoicecount[currentattributechoicecountindex]
        //       ii.  currentattributedatachoicesIndex+=x
        //       iii. bump currentattributedatachoicecountindex
        //
        @try
        {
            foo = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataType objectAtIndex:LocalAttributeChoiceIndex+1]];
        }
        @catch (NSException *e)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"error case 19 call lee"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            foo = [[NSString alloc]initWithFormat:@"%@",@""];
        }
        foo = [foo lowercaseString];
        if([foo isEqualToString:@"select"])
        {
            LocalAttributeDataChoicesIndex=0;
            //
            // calculate the current index for AttributeDataChoices array
            // which is the sum of numbers in AttributeDataChoice count from
            // zero to LocalAttributeChoiceCountIndex
            //
            int l = [self GetCurrentAttributeChoiceCountIndex]-1;
            
            [self SetCurrentAttributeChoiceCountIndex:l];
            
            LocalAttributeDataChoicesIndex=[self CalculatePreviousSelectChoiceIndex:l-1];
            [self SetCurrentAttributeChoiceCount];
            [self SetCurrentAttributeDataChoicesIndex:LocalAttributeDataChoicesIndex];
            [self SetCurrentAttributeChoices];
        }
        
        talktome=false;
        if(talktome)
        {
            NSLog(@"=======  setpreviousattribute =========");
            //[self ShowIndexes];
            //[self DumpAttributeDataValues];
            [self ShowIndexes];
            [self DumpArraySizes];
            [self DumpAttributeData];
        }
        
        //
        // set up the structures
        //
        [self SetCurrentValues];
        
        //
        // determine if we've backed up to the first attribute
        // of the current organism
        //
        LocalAttributeDataChoicesIndex = [self GetCurrentAttributeChoiceIndex];
        ////NSLog(@"Localattriburewchoceindex = %d",LocalAttributeDataChoicesIndex);
        ////NSLog(@"Currentattributechoiceindex = %d",CurrentAttributeChoiceIndex);
        int total = 0;
        for(int i=0; i < [self.OrganismNumberOfAttributes count]; i++)
        {
            NSString *s = [self.OrganismNumberOfAttributes objectAtIndex:i];
            int       x = (int)[s integerValue];
            
            if(LocalAttributeDataChoicesIndex == 0)
            {
                NSMutableArray *pl = [self GetOrganismPicklistAtIndex:LocalOrganismIndex];
                if ([pl count] == 0)
                {
                    [self SetIsNewOrganism:true];
                }
                break;
            }
            
            if(i > 0)
            {
                if(LocalAttributeDataChoicesIndex == total)
                {
                    [self SetIsNewOrganism:true];
                    break;
                }
            }
            
            total       = (total + x);
            ////NSLog(@"total = %d",total);
        }
        
        return;
    }
}

-(void)SetAttributesSet:(Boolean)TheValue
{
    AttributesSet=TheValue;
}
-(Boolean)GetAttributesSet
{
    return AttributesSet;
}

-(void)InitializeAttributes
{
    int y;
    NSString *foo = nil;
    
    if([self.OrganismNumberOfAttributes count]!=0)
    {
        foo = [[NSString alloc]initWithFormat:@"%@",[self.OrganismNumberOfAttributes objectAtIndex:0]];
    }
    y         = (int)[foo integerValue];
    if( ([self.OrganismDataName count]==1) && y==1)
    {
        [self SetIsLast:true];
    }
    else
    {
        [self SetIsLast:false];
    }
    [self SetCurrentOrganismIndex:0];
    [self SetCurrentAttributeChoiceIndex:0];
    [self SetCurrentAttributeDataChoicesIndex:0];
    [self SetCurrentAttributeChoiceCountIndex:0];
    [self SetAttributesSet:false];
    if(!([self GetKeepAuthoritySet]))
    {
        [self SetAuthoritySet:false];
    }
    [self SetAuthorityHasBeenSet:false];
    [self SetFirstSelect:true];
    [self SetPreviousMode:false];
    [self SetGoingForward:false];
    [self SetAuthorityRowNumber:0];
}

//
// setnextattribute needs to work with previous button
// this is a new implementation.  There are two type
// of attribute to consider:
// 1. a selection of choices (spinner)
// 2. a text box
//
// AttributesSet implies that the attributes structures have
// been initialized.  If they have not been initialized, then
// they must be prepared.  This will occur at the start of a
// new observation.  Authority was a late add on - just like
// previous - so we need to make sure we set the authority set
// state.  There are obscure occurrences since the previous
// button allows the user to back up.
//
// States:
// 1. new observation
//    a. authority will have been set by this time
//    b. the attribute data structures need to be initialized
//
// Additional notes for the future but I hope to never have to touch this code
// again!  These notes apply to the general case
// 1. we have to get the next attribute for either a site or an organism
//    - if it's an organism, both the organism and attribute pointers
//      need to be updated
//    - if it's a site, just update the attribute
// 2. CurrentOrganismAttributeIndex defines the attribute number within
//    the current organism
-(void)SetNextAttribute
{
    Boolean talktome            = false;
    [self ReadOptionsFromFile];
    
    ////NSLog(@"previous mode: %@",LocalPreviousMode ? @"TRUE" : @"FALSE");
    
    
    // parse the XML for this form
    NSString *foo               = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentFormName]];
    NSString *localname         = [self BuildFullPathFromName:foo :FORMTYPE];
    
    [self SetIsNewOrganism:false];
    ////////////   TOOK IT OUT  LKC  [self ParseXMLForm:localname];
    
    Boolean LocalAttribSet      = [self GetAttributesSet];
    Boolean LocalAuthSet        = [self GetAuthorityHasBeenSet];
    
    // check to see if this is the start of a new observation by
    // examining AttributesSet.
    // this is the first call to SetNextAttribute.  Set the
    // authority state and initialize the structures
    if((LocalAttribSet==false) && (LocalAuthSet==false))
    {
        [self ParseXMLForm:localname];
        [self SetAuthorityHasBeenSet:true];     // and set the state
        [self SetAuthoritySet:true];
        [self SetCurrentValues];
        [self SetIsLast:false];
        
        if(talktome)
        {
            NSLog(@"===authority and attribute not set");
            [self ShowIndexes];
            [self DumpAttributeDataValues];
        }
        
        return;
    }
    
    //
    // second time through.  the structures have been initialized and
    // authority is set, now position for the first attribute
    //
    if(LocalAttribSet==false)
    {
        [self SetAttributesSet:true];
        [self SetCurrentOrganismIndex:0];
        [self SetCurrentAttributeChoiceIndex:0];
        [self SetCurrentAttributeDataChoicesIndex:0];
        [self SetCurrentAttributeChoiceCountIndex:0];
        [self SetCurrentOrganismAttributeIndex:0];
        [self SetIsNewOrganism:true];
        
        
        int y;
        NSString *foo = nil;
        
        if([self.OrganismNumberOfAttributes count]!=0)
        {
            foo = [[NSString alloc]initWithFormat:@"%@",[self.OrganismNumberOfAttributes objectAtIndex:0]];
        }
        y         = (int)[foo integerValue];
        if( ([self.OrganismDataName count]==1) && y==1)
        {
            [self SetIsLast:true];
        }
        
        if(OrganismAttributeCount < [self.AttributeDataName count])
        {
            [self SetIsLast:false];
        }
        
        if( (OrganismAttributeCount == 0) && ([self.AttributeDataName count] > 0) )
        {
            [self SetCollectionType:COLLECTSITE];
        }
        
        //
        // set up the structures
        //
        [self SetCurrentValues];
        
        if(talktome)
        {
            NSLog(@"===only attribute not set");
            [self ShowIndexes];
            [self DumpAttributeDataValues];
        }
        
        return;
    }
    
    //
    // this is the rest of the times through and
    // we need to position to the next attribute
    //
    if(LocalAttribSet==true)
    {
        if(talktome) NSLog(@"=== rest of the times through setnextattribute");
        //
        // calculate the indexes for the next attribute
        //
        int LocalOrganismIndex              = [self GetCurrentOrganismIndex];
        int LocalAttributeChoiceIndex       = [self GetCurrentAttributeChoiceIndex]+1;
        int LocalAttributeDataChoicesIndex  = [self GetCurrentAttributeDataChoicesIndex];
        int LocalOrganismAttributeIndex     = [self GetCurrentOrganismAttributeIndex]+1;
        [self SetCurrentOrganismAttributeIndex:LocalOrganismAttributeIndex];
        
        if(talktome)
        {
            //[self ShowIndexes];
            //[self DumpAttributeDataValues];
            [self DumpArraySizes];
            [self DumpAttributeData];
        }
        
        //
        // here's the setting the next index layout
        // 1. bump CurrentAttributeChoiceIndex for the arrays AttributeDataName and AttributeDataType
        [self SetCurrentAttributeChoiceIndex:LocalAttributeChoiceIndex];
        
        // 2. check to see if this is the last attribute
        if(LocalAttributeChoiceIndex == ([self.AttributeDataName count]-1))
        {
            [self SetIsLast:true];
        }
        
        // 2.5 check to see if we're now adding again
        if((LocalAttributeChoiceIndex+ATTRIBUTEINDEXOFFSET) >= ([self.AttributeDataValue count]))
        {
            [self SetPreviousMode:false];
        }
        
        NSString *foo = [[NSString alloc]init];
        int x;
        // 3. check to see if we have a new organism, site characteristic, or treatment
        //    a. if currentattributechoiceindex == organismnumberofattributes[currentorganismindex]
        //       i. bump organismindex
        if([self GetCollectionType]==COLLECTORGANISM)
        {
            if([self.OrganismNumberOfAttributes count] == 0)
            {
                x = 0;
            }
            else
            {
                @try
                {
                    foo = [[NSString alloc]initWithFormat:@"%@",[self.OrganismNumberOfAttributes objectAtIndex:LocalOrganismIndex]];
                }
                @catch (NSException *e)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                    message:@"error case 20 call lee"
                                                                   delegate:nil cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                    [alert show];
                    foo = [[NSString alloc]initWithFormat:@"%@",@"0"];
                }
                x   = (int)[foo integerValue];
            
                if(LocalOrganismAttributeIndex == x)
                {
                    //
                    // bump the organism index
                    //
                    [self SetCurrentOrganismIndex:LocalOrganismIndex+1];
                    [self SetCurrentOrganismAttributeIndex:0];
                    ////[self SetFirstSelect:true];
                    if((LocalOrganismIndex+1)==[self GetOrganismCount])
                    {
                        [self SetCollectionType:COLLECTSITE];
                        [self SetIsNewOrganism:true];
                    }
                    else
                    {
                        [self SetIsNewOrganism:true];
                    }
                }
            }
        }
        
        // 4. set up for the next attribute (this is only complicated for "Select"
        //    a. if AttributeDataType[currentattributeindex] == select
        //       i.   x = attributedatachoicecount[currentattributechoicecountindex]
        //       ii.  currentattributedatachoicesIndex+=x
        //       iii. bump currentattributedatachoicecountindex
        //
        @try
        {
            foo = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataType objectAtIndex:LocalAttributeChoiceIndex]];
        }
        @catch (NSException *e)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"error case 21 call lee"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            foo = [[NSString alloc]initWithFormat:@"%@",@""];
        }
        foo = [foo lowercaseString];
        if([foo isEqualToString:@"select"])
        {
            LocalAttributeDataChoicesIndex=0;
            // check for first select
            [self CheckFirstSelect];
            if([self GetFirstSelect])
            {
                [self SetFirstSelect:false];
                [self SetSelectIndex:[self GetCurrentAttributeChoiceIndex]];
                [self SetCurrentAttributeChoiceCount];
                [self SetCurrentAttributeDataChoicesIndex:0];
                [self SetCurrentAttributeChoiceCountIndex:0];
                [self SetCurrentAttributeChoices];
            }
            else
            {
                //
                // calculate the current index for AttributeDataChoices array
                // which is teh sum of numbers in AttributeDataChoice count from
                // zero to LocalAttributeChoiceCountIndex
                //
                int l = [self GetCurrentAttributeChoiceCountIndex];
                LocalAttributeDataChoicesIndex=[self CalculateSelectChoiceIndex:l];
                
                [self SetCurrentAttributeDataChoicesIndex:LocalAttributeDataChoicesIndex];
                x = [self GetCurrentAttributeChoiceCountIndex];
                x++;
                [self SetCurrentAttributeChoiceCountIndex:x];
                [self SetCurrentAttributeChoiceCount];
                
                [self SetCurrentAttributeChoices];
            }
        }
        
        //
        // set up the structures
        //
        [self SetCurrentValues];
        return;
    }
}

//
// this should really be a call to SetPreviousAttribute,
// but it can't because it's only called by Picklist.m
// in the previous mode.  The scenario is we need to backup
// from the organism pick list to whatever came before it.
// Not only that, all the data structures must be consistent
// so that following calls to SetNextAttribute and
// SetPreviousAttribute function as expected.  Kind of a
// headache, but it has to be done.  And it's in the model
// because it needs to muck with the attribute and organism
// data structures.
//
// Known quantities:
// 1. this is only called when backing up from an organism
//    picklist screen
// 2. the data structures and pointers must be set up to identify
//    the item exactly before the organism picklist.
//
// The cases are:
// 1. backup to authority
// 2. backup to the last attribute of the previous organism
//
-(void)SetFirstAttribute
{
    NSString *foo               = nil;
    [self SetIsNewOrganism:true];
    [self SetAuthorityHasBeenSet:true];     // and set the state
    [self SetAuthoritySet:true];
    
    //
    // second time through.  the structures have been initialized and
    // authority is set, now position for the first attribute
    //
    [self SetAttributesSet:true];
    [self SetCurrentOrganismIndex:0];
    [self SetCurrentAttributeChoiceIndex:0];
    [self SetCurrentAttributeDataChoicesIndex:0];
    
    // this is -1 because it's being set in previous mode
    // check out SetPreviousAttribute to see how it's done
    [self SetCurrentAttributeChoiceCountIndex:-1];
    [self SetCurrentOrganismAttributeIndex:0];
    [self SetIsNewOrganism:true];
    
    
    int y;
    
    if([self.OrganismNumberOfAttributes count]!=0)
    {
        foo = [[NSString alloc]initWithFormat:@"%@",[self.OrganismNumberOfAttributes objectAtIndex:0]];
    }
    y         = (int)[foo integerValue];
    if( ([self.OrganismDataName count]==1) && y==1)
    {
        [self SetIsLast:true];
    }
    
    if(OrganismAttributeCount < [self.AttributeDataName count])
    {
        [self SetIsLast:false];
    }
    
    if( (OrganismAttributeCount == 0) && ([self.AttributeDataName count] > 0) )
    {
        [self SetCollectionType:COLLECTSITE];
    }
}

-(void)ShowIndexes
{
    int LocalOrganismIndex              = [self GetCurrentOrganismIndex];
    int LocalAttributeChoiceIndex       = [self GetCurrentAttributeChoiceIndex];
    int LocalAttributeChoiceCountIndex  = [self GetCurrentAttributeChoiceCountIndex];
    int LocalAttributeDataChoicesIndex  = [self GetCurrentAttributeDataChoicesIndex];
    
    //
    // get the number of choices for this attribute
    //
    int LocalAttributeChoiceCount       = [self GetCurrentAttributeChoiceCount];
    
    NSLog(@"==== Indexes ====");
    NSLog(@"OrganismIndex:  %d",[self GetCurrentOrganismIndex]);
    NSLog(@"AttributeIndex: %d",[self GetCurrentAttributeChoiceIndex]);
    NSLog(@"CurrentOrganismIndex=%d",LocalOrganismIndex);
    NSLog(@"CurrentAttributeChoiceIndex=%d",LocalAttributeChoiceIndex);
    NSLog(@"CurrentAttributeChoiceCountIndex=%d",LocalAttributeChoiceCountIndex);
    NSLog(@"CurrentAttributeDataChoicesIndex=%d\n",LocalAttributeDataChoicesIndex);
    NSLog(@"CurrentAttributeChoiceCount=%d",LocalAttributeChoiceCount);
}

-(void)SetIsLast:(Boolean)TheValue
{
    LastAttribute=TheValue;
}
-(Boolean)GetIsLast
{
    return LastAttribute;
}

-(void)SetOrganismNumberOfAttributes:(NSString *)TheValue
{
    [self.OrganismNumberOfAttributes addObject:TheValue];
}
-(int)GetOrganismNumberOfAttributes:(int)TheIndex
{
    NSString *foo;
    @try
    {
        foo = [[NSString alloc]initWithFormat:@"%@",[self.OrganismNumberOfAttributes objectAtIndex:TheIndex]];
    }
    @catch (NSException *e)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"error case 22 call lee"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        foo = [[NSString alloc]initWithFormat:@"%@",@"0"];
    }
    return (int)[foo integerValue];
}

-(void)SetOrganismAttributeCount
{
    OrganismAttributeCount = 0;
    NSString *foo;
    for(int i=0; i<[self.OrganismNumberOfAttributes count]; i++)
    {
        @try
        {
            foo = [[NSString alloc]initWithFormat:@"%@",[self.OrganismNumberOfAttributes objectAtIndex:i]];
        }
        @catch (NSException *e)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"error case 23 call lee"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            foo = [[NSString alloc]initWithFormat:@"%@",@"0"];
        }
        OrganismAttributeCount += [foo integerValue];
    }
}
-(int)GetOrganismAttributeCount
{
    [self SetOrganismAttributeCount];
    return OrganismAttributeCount;
}
-(int)GetTotalAttributeCount
{
    return (int)[AttributeDataName count];
}
-(int)GetCurrentOrganismAttributeCount
{
    int i = [self GetCurrentOrganismIndex];
    
    //
    // this will be true when site attributes
    // are started and the value will not be
    // used
    //
    if(i == [self.OrganismNumberOfAttributes count])
    {
        i--;
    }
    
    NSString *foo = [[NSString alloc]initWithFormat:@"%@",[self.OrganismNumberOfAttributes objectAtIndex:i]];
    i = (int)[foo integerValue];

    return i;
}

-(void)SetAuthoritySet:(Boolean)TheValue
{
    AuthoritySet = TheValue;
}
-(Boolean)GetAuthoritySet
{
    return AuthoritySet;
}
-(int)GetAuthorityCount
{
    return (int)[self.AuthorityFirstName count];
}

-(void)SetKeepAuthoritySet:(Boolean)TheValue
{
    KeepAuthoritySet = TheValue;
}
-(Boolean)GetKeepAuthoritySet
{
    return KeepAuthoritySet;
}

-(void)SetAuthorityHasBeenSet:(Boolean)TheValue
{
    AuthorityHasBeenSet = TheValue;
}
-(Boolean)GetAuthorityHasBeenSet
{
    return AuthorityHasBeenSet;
}

-(NSMutableArray *)GetAuthorityFirstName
{
    return self.AuthorityFirstName;
}
-(NSMutableArray *)GetAuthorityLastName
{
    return self.AuthorityLastName;
}
-(NSMutableArray *)GetAuthorityID
{
    return self.AuthorityID;
}

-(void)SetPredefinedLocationNames:(NSMutableArray *)TheChoices
{
    self.PredefinedLocationNames = TheChoices;
}
-(void)SetPredefinedLocationIDs:(NSMutableArray *)TheChoices
{
    self.PredefinedLocationIDs = TheChoices;
}
-(NSMutableArray *)GetPredefinedLocationNames
{
    return self.PredefinedLocationNames;
}
-(NSMutableArray *)GetPredefinedLocationIDs
{
    return self.PredefinedLocationIDs;
}

-(void)SetSelectedPredefinedName:(NSString *)TheSelection
{
    self.SelectedPredefinedName = TheSelection;
}
-(void)SetSelectedPredefinedID:(NSString *)TheSelection
{
    self.SelectedPredefinedID = TheSelection;
}
-(NSString *)GetSelectedPredefinedName
{
    return self.SelectedPredefinedName;
}
-(NSString *)GetSelectedPredefinedID
{
    return self.SelectedPredefinedID;
}

-(void)SetPredefinedLocationMode:(Boolean)TheMode
{
    PredefinedLocationMode = TheMode;
}
-(Boolean)GetPredefinedLocationMode
{
    return PredefinedLocationMode;
}

-(NSMutableArray *)GetOrganismPicklistAtIndex:(int)TheIndex
{
    // if the picklist count is 0 we have no organisms
    NSMutableArray *foo;
    
    if([self.OrganismPicklist count] <= TheIndex)
    {
        foo = [[NSMutableArray alloc]init];
    }
    else
    {
        foo = [self.OrganismPicklist objectAtIndex:TheIndex];
    }
    
    int plcount = (int)[foo count];
    
    if((plcount % 2) != 0)
    {
        foo = [[NSMutableArray alloc]init];
    }

    
    return foo;
}

-(Boolean)ParsePredefinedLocations
{
    // parse the XML for this form for predefined locations
    NSString    *foo                = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentFormName]];
    NSString    *localname          = [self BuildFullPathFromName:foo :FORMTYPE];
    NSError     *error;
    Boolean     retval              = false;        // assume failure
    
    // clear out data structures
    [self.PredefinedLocationNames removeAllObjects];
    [self.PredefinedLocationIDs removeAllObjects];
    
    //
    // use the SMXMLParser for the forms
    //
    NSString *sampleContents = [NSString stringWithContentsOfFile:localname encoding:NSUTF8StringEncoding error:&error];
    
    NSString *TheActualString = [[NSString alloc]initWithFormat:@"%@",sampleContents];
    NSData *data = [TheActualString dataUsingEncoding:NSUTF8StringEncoding];
	
	// create a new SMXMLDocument with the contents of sample.xml
	SMXMLDocument *document = [SMXMLDocument documentWithData:data error:&error];
    
    // check for errors
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"XML parsing error in predefined locations.  Contact Leeway Software Design (lkc@leewaysd.com)!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        retval=false;
    }
    else
    {
        SMXMLElement *TheArea = [document.root childNamed:@"Area"];
        for (SMXMLElement *Location in [TheArea childrenNamed:@"Location"])
        {
            //NSString     *LocationSpecified = [Location attributeNamed:@"HowSpecified"];
            //NSLog(@"how location specified: %@",LocationSpecified);
            
            for(SMXMLElement  *LocationOption in [Location childrenNamed:@"LocationOption"])
            {
                NSString      *Name     = [LocationOption attributeNamed:@"Name"];
                NSString      *AreaID   = [LocationOption attributeNamed:@"AreaID"];
                [self.PredefinedLocationNames addObject:Name];
                [self.PredefinedLocationIDs addObject:AreaID];
                //NSLog(@"%@ %@",Name,AreaID);
                retval = true;      // at least 1 so set the return to true
            }
        }
    }
    return retval;
}


#pragma mark -
#pragma mark XML methods
-(NSString *)ReadXMLFile:(NSString *)TheFileName
{
	NSFileManager       *filemgr;
	NSString            *ApplicationsFile;
	NSString            *ApplicationsPath;
    NSError             *error=nil;
	NSArray             *DirectoryPaths;
    NSString            *string=nil;
	
    // 1. get a file manager for directory access
	filemgr = [NSFileManager defaultManager];
	
	// 2. create the directory for this application in the Docs directory
	DirectoryPaths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath = [DirectoryPaths objectAtIndex:0];
    ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
	ApplicationsFile = [ApplicationsPath stringByAppendingPathComponent:TheFileName];
    
	if (![filemgr fileExistsAtPath:ApplicationsPath])
	{
        // alert get project data using settings
        NSLog(@"Get project data from server using settings");
	}
    else
    {
        // read the XML file and return it
        string = [[NSString alloc] initWithContentsOfFile:ApplicationsFile encoding:NSUTF8StringEncoding error:&error];
    }
    
    return string;
}

#pragma -
#pragma - mark JSON methods
//
// save the JSON projects and data sheets
// from the server
//
-(void)SetTranslatingDataSheetName:(NSString *)TheName
{
    self.TranslatingDatasheetName = TheName;
}
-(NSString *)GetTranslatingDataSheetName
{
    return self.TranslatingDatasheetName;
}

-(void)SetJSONObject:(id)TheObject
{
    self.JSONObject = TheObject;
}
-(id)GetJSONObject
{
    return self.JSONObject;
}

//
// need to get the JSON from the server
// and translate it to XML for the rest
// of the app
//
-(void)GetJSONFromServer
{
    NSLog(@"getjsonfromserver called");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getjsonfromserver" object:nil];
    NSLog(@"getjsonfromserver posted");
}

-(void)BuildLoginStatus:(NSString *)TheString
{
    if(!([self GetBioblitzDisplay]))
    {
        return;
    }
    self.loginStatus = [self.loginStatus stringByAppendingString:TheString];
    
    if([self.loginStatus length] >= LOGINSTRINGLIMIT)
    {
        [self WriteLoginStatus];
        self.loginStatus = @"";
    }
}

-(Boolean)GetWriteOptionsFile
{
    return WriteOptionsFile;
}

-(void)SetWriteOptionsFile:(Boolean)TheFlag
{
    WriteOptionsFile = TheFlag;
}

Boolean JSONWrite = false;
//
// translate JSON to XML files
//
-(void)JSONToXML
{
    NSDictionary    *JsonResponseDictionary;
    NSArray         *dsProjectName;             // data sheet project name
    NSArray         *dsProjectID;               // data sheet project id
    NSArray         *dsName;                    // data sheet name
    NSArray         *dsID;                      // data sheet id
    NSArray         *CurrentName;               // current data sheet name
    NSArray         *CurrentID;                 // current data sheet id
    NSArray         *dsDataSheets;              // look for null data sheet
    NSArray         *CurrentDataSheets;         // current for the project
    NSString        *tempstring;                // used for intermediate loginStatus
    id              object;                     // get this from the model rather than a parameter
    
    object          = [self GetJSONObject];
    if([object isKindOfClass:[NSDictionary class]])
    {
        JsonResponseDictionary      = object;
        dsProjectName               = [JsonResponseDictionary valueForKeyPath:@"data.ProjectName"];
        dsProjectID                 = [JsonResponseDictionary valueForKeyPath:@"data.ProjectID"];
        dsName                      = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets.Name"];
        dsID                        = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets.DataSheetID"];
        dsDataSheets                = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets"];
        
        // clear out loginStatus
        self.loginStatus            = @"";
        
        //
        // write the header portion of AllData.xml
        //
        [self WriteXMLHeader:object];
        
        //
        // write each form to AllData.xml
        // we do not need Instructions and area so start with visit
        // cycle through the form data again (for each project (again))
        //
        int numprojects             = (int)[dsProjectName count];
        //NSLog(@"number of projects: %d",numprojects);
        //numprojects = 15;
        for(int projindex=0; projindex < numprojects; projindex++)
        {
            NSString *curprojid     = [[NSString alloc]initWithFormat:@"%@",[dsProjectID objectAtIndex:projindex]];
            curprojid               = [self FixXML:curprojid];
            
            CurrentName             = [dsName objectAtIndex:projindex];
            CurrentID               = [dsID objectAtIndex:projindex];
            CurrentDataSheets       = [dsDataSheets objectAtIndex:projindex];
            
            int numdatasheets       = (int)[CurrentDataSheets count];
            //NSLog(@"number of datasheets :%d",numdatasheets);
            for(int dsindex=0; dsindex<numdatasheets; dsindex++)
            {
                //
                // start of GODMForm
                //
                NSString *curdsid   = [[NSString alloc]initWithFormat:@"%@", [CurrentID objectAtIndex:dsindex]];
                NSString *curdsname = [CurrentName objectAtIndex:dsindex];
                curdsname           = [self FixXML:curdsname];
                curdsid             = [self FixXML:curdsid];
                tempstring          = [[NSString alloc]initWithFormat:@"<GODMForm Name='%@' ID='%@' >\n",curdsname,curdsid];
                JSONWrite=false;
                if(JSONWrite) NSLog(@"working on datasheet: %@",curdsname);
                JSONWrite=false;
                [self SetTranslatingDataSheetName:curdsname];
                [self BuildLoginStatus:tempstring];
                
                [self WriteXMLPredefinedLocations:object : projindex : dsindex];
                
                [self BuildLoginStatus:@"\t<Visit>\n"];
                
                [self WriteXMLAuthority:object :projindex];
                [self BuildLoginStatus:@"\t\t<OrganismData>\n"];
                [self WriteXMLOrganismData:object :dsindex :projindex :numdatasheets :numprojects];
                [self BuildLoginStatus:@"\t\t</OrganismData>\n"];
                [self WriteXMLSiteCharacteristics:object :dsindex : projindex : numdatasheets : numprojects];
                
                // close the XML for the visit and the form
                [self BuildLoginStatus:@"\t</Visit>\n"];
                tempstring          = [[NSString alloc]initWithFormat:@"</GODMForm>\n\n%@\n",XMLSEPARATOR];
                [self BuildLoginStatus:tempstring];
            }
        }
    }

    //NSLog(@"loginstatus: %@",self.loginStatus);
    NSString *foo = [[NSString alloc] initWithFormat:@"%@", [self GetCurrentProjectName]];
    [self SetXMLServerString:self.loginStatus];
    [self FinishLoginStatus];
    [self WriteXMLAllFiles:self.loginStatus];
    
    [self SetCurrentProjectName:foo];
}

-(void)WriteXMLHeader:(id)TheObject
{
    NSDictionary    *JsonResponseDictionary;
    NSArray         *dsProjectName;             // data sheet project name
    NSArray         *dsProjectID;               // data sheet project id
    NSArray         *dsName;                    // data sheet name
    NSArray         *dsID;                      // data sheet id
    NSArray         *CurrentName;               // current data sheet name
    NSArray         *CurrentID;                 // current data sheet id
    NSString        *tempstring;                // used for building loginstatus
    
    
    JsonResponseDictionary      = TheObject;
    dsProjectName               = [JsonResponseDictionary valueForKeyPath:@"data.ProjectName"];
    dsProjectID                 = [JsonResponseDictionary valueForKeyPath:@"data.ProjectID"];
    dsName                      = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets.Name"];
    dsID                        = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets.DataSheetID"];
    
    //
    // write the projects portion of AllData.xml
    //
    [self BuildLoginStatus:@"<?xml version='1.0' ?>\n"];
    [self BuildLoginStatus:@"<GODMProjects>\n"];
    
    for(int projindex=0; projindex< [dsProjectName count]; projindex++)
    {
        NSString *curprojname   = [[NSString alloc]initWithFormat:@"%@",[dsProjectName objectAtIndex:projindex]];
        NSString *curprojid     = [[NSString alloc]initWithFormat:@"%@",[dsProjectID objectAtIndex:projindex]];
        curprojid               = [self FixXML:curprojid];
        
        tempstring              = [[NSString alloc]initWithFormat:@"\t<GODMProject Name='%@' ID='%@'>\n",curprojname,curprojid];
        [self BuildLoginStatus:tempstring];
        
        CurrentName             = [dsName objectAtIndex:projindex];
        CurrentID               = [dsID objectAtIndex:projindex];
        
        for(int dsindex=0; dsindex<[CurrentName count]; dsindex++)
        {
            NSString *curdsname = [[NSString alloc]initWithFormat:@"%@", [CurrentName objectAtIndex:dsindex]];
            NSString *curdsid   = [[NSString alloc]initWithFormat:@"%@", [CurrentID objectAtIndex:dsindex]];
            curdsname           = [self FixXML:curdsname];
            curdsid             = [self FixXML:curdsid];
            
            tempstring          = [[NSString alloc]initWithFormat:@"\t\t<GODMForm Name='%@' ID='%@' />\n",curdsname,curdsid];
            [self BuildLoginStatus:tempstring];
        }
        [self BuildLoginStatus:@"\t</GODMProject>\n"];
    }
    tempstring                  = [[NSString alloc]initWithFormat:@"</GODMProjects>\n\n%@\n",XMLSEPARATOR];
    [self BuildLoginStatus:tempstring];
}

-(void)WriteXMLPredefinedLocations:(id)TheObject : (int)ProjectIndex : (int)datasheet
{
    NSDictionary    *JsonResponseDictionary;
    NSArray         *dsPredefinedLocations;     // data sheet predefined locations
    NSArray         *CurrentPredefinedLocation; // current predefined locations
    NSString        *tempstring;                // used for building loginstatus
    
    JsonResponseDictionary      = TheObject;
    dsPredefinedLocations       = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets.locations"];
    CurrentPredefinedLocation   = [dsPredefinedLocations objectAtIndex:ProjectIndex];
    
    id predefinedvalue          = [CurrentPredefinedLocation objectAtIndex:datasheet];
    if(![predefinedvalue isEqual:[NSNull null]])
    {
        // we have some so open area and location
        [self BuildLoginStatus:@"\t<Area>\n"];
        [self BuildLoginStatus:@"\t\t<Location HowSpecified='Select'>\n"];
        tempstring              = @"\t<Area>\n";
        
        // write out the predefined locations
        for(int i=0; i<[predefinedvalue count]; i++)
        {
            NSArray *foo = [predefinedvalue objectAtIndex:i];
            //NSLog(@"foo[1]=%@",[foo valueForKey:@"AreaName"]);
            //NSLog(@"foo[0]=%@",[foo valueForKey:@"AreaID"]);
            tempstring = [[NSString alloc]initWithFormat:@"\t\t\t<LocationOption Name='%@' AreaID='%@'/>\n",[foo valueForKey:@"AreaName"],[foo valueForKey:@"AreaID"]];
            [self BuildLoginStatus:tempstring];
        }
        
        // close the locations and area
        [self BuildLoginStatus:@"\t\t</Location>\n"];
        [self BuildLoginStatus:@"\t</Area>\n"];
    }
}

-(void)WriteXMLAuthority:(id)TheObject : (int) ProjectIndex
{
    NSDictionary    *JsonResponseDictionary;
    NSArray         *afn;                       // authority first name
    NSArray         *aln;                       // authority last name
    NSArray         *aid;                       // authority id
    NSString        *tempstring;                // build loginstatus
    
    JsonResponseDictionary  = TheObject;
    afn                     = [JsonResponseDictionary valueForKeyPath:@"data.Authority.FirstName"];
    aln                     = [JsonResponseDictionary valueForKeyPath:@"data.Authority.LastName"];
    aid                     = [JsonResponseDictionary valueForKeyPath:@"data.Authority.ID"];
    
    [self BuildLoginStatus:@"\t\t<Authority HowSpecified='Select'>\n"];
    
    //
    // authority loop
    //
    NSArray *f = [afn objectAtIndex:ProjectIndex];
    NSArray *l = [aln objectAtIndex:ProjectIndex];
    NSArray *d = [aid objectAtIndex:ProjectIndex];
    
    for(int acount=0; acount<[f count]; acount++)
    {
        NSString *sfn = [[NSString alloc]initWithFormat:@"%@",[f objectAtIndex:acount]];
        NSString *sln = [[NSString alloc]initWithFormat:@"%@",[l objectAtIndex:acount]];
        NSString *sid = [[NSString alloc]initWithFormat:@"%@",[d objectAtIndex:acount]];
        tempstring    = [[NSString alloc]initWithFormat:@"\t\t\t<AuthorityOption FirstName='%@' LastName='%@' ID='%@' />\n",sfn,sln,sid];
        [self BuildLoginStatus:tempstring];
    }
    [self BuildLoginStatus:@"\t\t</Authority>\n"];
}

-(void)WriteXMLSiteCharacteristics:(id)TheObject :(int)datasheet : (int) projnum : (int)numdatasheets : (int)numprojects
{
    NSDictionary    *JsonResponseDictionary;
    NSArray         *dsProjectName;             // data sheet project name
    NSArray         *dsProjectID;               // data sheet project id
    NSArray         *dsName;                    // data sheet name
    NSArray         *dsID;                      // data sheet id
    NSArray         *dsSiteChar;                // data sheet site characteristics
    NSArray         *CurrentSiteChar;           // current data sheet site characteristics
    NSArray         *AllSiteCharacteristics;    // all for this project
    NSArray         *DataSheetSiteChar;         // all site characteristics for this data sheet
    NSString        *tempstring;                // build loginstatus
    
    int             sitecount;
    
    JsonResponseDictionary      = TheObject;
    dsProjectName               = [JsonResponseDictionary valueForKeyPath:@"data.ProjectName"];
    dsProjectID                 = [JsonResponseDictionary valueForKeyPath:@"data.ProjectID"];
    dsName                      = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets.Name"];
    dsID                        = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets.DataSheetID"];
    dsSiteChar                  = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets.SiteChar"];
    
    // open site characteristics
    [self BuildLoginStatus:@"\t\t<SiteCharacteristicsData>\n"];
    
    // display information
    AllSiteCharacteristics  = [dsSiteChar objectAtIndex:projnum];                   // for the project
    DataSheetSiteChar       = [AllSiteCharacteristics objectAtIndex:datasheet];     // for this data sheets
    sitecount               = (int)[DataSheetSiteChar count];
    
    for(int i=0; i < sitecount; i++)
    {
        CurrentSiteChar     = [DataSheetSiteChar objectAtIndex:i];                  // this site attribute
        [self BuildLoginStatus:@"\t\t\t<SiteCharacteristicsDataEntry>\n"];
        [self BuildLoginStatus:@"\t\t\t\t<AttributeData>\n"];
        
        NSString *strname   = [CurrentSiteChar valueForKey:@"HowSpecifiedString"];
        NSString *ValueType = [CurrentSiteChar valueForKey:@"ValueType"];
        NSString *UnitType  = [CurrentSiteChar valueForKeyPath:@"UnitDetails.Abbreviation"];
        strname             = [self TranslateDefinition:strname:ValueType];
        NSString *strname2  = [CurrentSiteChar valueForKey:@"Name"];
        NSString *strvalue  = [CurrentSiteChar valueForKey:@"AttributeTypeID"];
        NSString *strvalue2 = [CurrentSiteChar valueForKey:@"UnitID"];
        if([strvalue2 isEqual:[NSNull null]])
        {
            strvalue2 = @"";
        }
        
        if([UnitType isEqual:[NSNull null]])
        {
            UnitType = @"";
        }
        if([UnitType length] == 0)
        {
            UnitType = @"";
        }
        
        tempstring          = [[NSString alloc]initWithFormat:@"\t\t\t\t\t<AttributeDataEntry HowSpecified='%@' Name='%@' UnitID='%@' AttributeTypeID='%@' Units='%@'>\n",strname,strname2,strvalue2,strvalue,UnitType];
        [self BuildLoginStatus:tempstring];
        NSArray *temp       = [CurrentSiteChar valueForKey:@"AttributeValuesPossible"];
        
        int attributetotal  = (int)[temp count];
        for(int attrcount=0; attrcount < attributetotal; attrcount++)
        {
            NSArray *attributevalues = [temp objectAtIndex:attrcount];
            //if(show) NSLog(@"attrvals: %@",attributevalues);
            strname         = [attributevalues valueForKey:@"Name"];
            strvalue        = [attributevalues valueForKey:@"ID"];
            tempstring      = [[NSString alloc]initWithFormat:@"\t\t\t\t\t\t<AttributeDataOption Name='%@' ID='%@'/>\n",strname,strvalue];
            [self BuildLoginStatus:tempstring];
        }
        [self BuildLoginStatus:@"\t\t\t\t\t</AttributeDataEntry>\n"];

        // close sttributedata and sitecharacteristicdataentry
        [self BuildLoginStatus:@"\t\t\t\t</AttributeData>\n"];
        [self BuildLoginStatus:@"\t\t\t</SiteCharacteristicsDataEntry>\n"];
    }
    
    // close site characteristics
    [self BuildLoginStatus:@"\t\t</SiteCharacteristicsData>\n"];
}

-(void)SetParsedAttributeValue:(NSString *)TheValue
{
    self.ParsedAttributeValue = [[NSString alloc]initWithString:TheValue];
}

-(NSString *)GetParsedAttributeValue
{
    return self.ParsedAttributeValue;
}

-(void)ParseTheAttributes:(id)object :(NSString *)TheKey
{
    if([object isKindOfClass:[NSDictionary class]])
    {
        NSString *key = TheKey;
        id child = [object objectForKey:key];
        [self ParseTheAttributes:child :key];
    }
    
    else if([object isKindOfClass:[NSArray class]])
    {
        for(id child in object)
        {
            [self ParseTheAttributes:child :TheKey];
        }
    }
    else
    {
        [self SetParsedAttributeValue:@""];
        //This object is not a container you might be interested in it's value
        if(!([object isEqual:[NSNull null]]) && (object != NULL))
        {
            NSString *foo = [[NSString alloc]initWithFormat:@"%@",[object description]];
            if(!([foo isEqualToString:@""]) && (foo != NULL))
            {
                //NSLog(@"Key: %@ value: %@",TheKey,[object description]);
                NSString *foo = [[NSString alloc]initWithFormat:@"%@",[object description]];
                [self SetParsedAttributeValue:foo];
            }
        }
    }
}

//
// the organisms are organized into:
// 1. an organisminfos header
// 2. any number of attributes for that organism
// and there are any number of organisms in a data sheet.
// so loop through as:
// for each organism
// 1. write first/next organisminfos section
//    for each attribute
//    1. write first/next attribute section
//
//
// TheObject is the JSON returned from the API.
// The job is to isolate the current project, denoted by
// projnum, and get each data sheet, denoted by datasheet
// for that projnum.  Therefore, this method needs to parse
// TheObject[projnum].Datasheet[datasheet].
//
-(void)WriteXMLOrganismData:(id)TheObject :(int)datasheet : (int) projnum : (int)numdatasheets : (int)numprojects
{
    NSDictionary    *JsonResponseDictionary;
    id              dsAttributes;               // data sheet attributes
    id              CurrentDataSheets;          // all datasheets for this project
    id              ThisDataSheet;              // the datasheet to be parsed
    id              AllOrganisms;               // for the current datasheet
    id              AllDataSheets;              // all data sheets from JSON
    NSArray         *temp;                      // temporary array
    NSString        *strvalue;                  // common place holder for a value
    NSString        *strname;                   // common place holder for a name
    NSString        *strname2;                  // second common place holder for additional names
    NSString        *strvalue2;                 // second common place holder for addtional values
    NSString        *tempstring;                // build loginstatus
    NSString        *AttributesString;          // holding place for attributes
    static NSString *BioBlitzName;              // do not display the smae data sheet name twice
    Boolean         OrganismStarted;            // trigger to write either XML open or close
    Boolean         FoundOrgDetails;            // does organismdetails exist
    Boolean         AttributesStarted;          // trigger to write the attributedata tag
    Boolean         IsOrganismList;             // flag for pick list
    Boolean         IsOrganismDetails;          // flag for single organism
    Boolean         IsAttribute;                // flag for an attribute
    Boolean         DoneAnOrganism;             // flag to denote we've done an organism
    Boolean         NullAttribute;              // flag for determining bio blitz
    Boolean         FirstNull;                  // do not write out the actual null attribute
    
    JsonResponseDictionary      = TheObject;
    dsAttributes                = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets.OrgAttributes"];
    AllDataSheets               = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets"];
    
    CurrentDataSheets           = [AllDataSheets objectAtIndex:projnum];
    ThisDataSheet               = [CurrentDataSheets objectAtIndex:datasheet];
    AllOrganisms                = [ThisDataSheet valueForKeyPath:@"OrgAttributes"];
    
    OrganismStarted             = false;
    AttributesStarted           = false;
    DoneAnOrganism              = false;
    NullAttribute               = false;
    AttributesString            = @"";
    BioBlitzName                = @"";
    
    // handle zero organisms by examining all the
    // children of AllOrganisms.  If there are no
    // OrganismDetails, or OrganismLists, there are
    // no Organisms.
    FoundOrgDetails             = false;
    for(id child in AllOrganisms)
    {
        // examine all children and stop when OrganismDetails is found
        id x = [child valueForKeyPath:@"OrganismDetails"];
        
        if (x != NULL)
        {
            FoundOrgDetails = true;
            break;
        }
        
        // check for an organism list and stop if it's found
        x = [child valueForKeyPath:@"OrganismList"];
        
        if (x != NULL)
        {
            FoundOrgDetails = true;
            break;
        }
    }
    
    // if there are neither organisms nor organism picklsits
    // get out of here
    if(!FoundOrgDetails)
    {
        // no organism details so skip this
        return;
    }
    
    //
    // we have at least one organism or organism picklist
    // so open the OrgasnismData tree.  For each organism
    // we know there has to be details or there has to be
    // an organism list.  If there isn't, this data sheet
    // is illegal, but that will get caught later
    //
    for(id child in AllOrganisms)
    {
        //
        // if there is a null attribute it signals bioblitz
        // we need to set the NullAttribute flag and ignore the
        // rest of the attributes until we get the next organism
        //
        
        // check to see if we have an organismdetails or pick list
        IsOrganismList      = false;
        IsOrganismDetails   = false;
        IsAttribute         = false;
        FirstNull           = false;
        [self SetBioblitzDispaly:true];
        id x = [child valueForKeyPath:@"OrganismDetails"];
        if (x == NULL)
        {
            x = [child valueForKeyPath:@"OrganismList"];
            if (x != NULL)
            {
                IsOrganismList = true;
            }
        }
        else
        {
            IsOrganismDetails = true;
        }
        
        // check for attribute mode.  if so, check for
        // a null attribute.  if it's a null attribute,
        // set the null attribute flag and ignore the
        // rest of the attributes until we get to the
        // next organism
        if ((!IsOrganismList) && (!IsOrganismDetails))
        {
            if([self IsNullAttribute:child])
            {
                NullAttribute = true;
                FirstNull     = true;
                [self SetBioblitzDispaly:false];
            }
            IsAttribute = true;
        }
        else
        {
            // we have an organism so reset the null attribute flag
            NullAttribute = false;
        }
        
        // if we are in null attribute mode (bioblitz), skip this child
        if(NullAttribute)
        {
            if(!([BioBlitzName isEqualToString:[self GetTranslatingDataSheetName]]))
            {
                //NSString *Message  = [[NSString alloc]initWithFormat:@"BioBlitz mode is not supported in this release\ndatasheet name: %@",[self GetTranslatingDataSheetName]];
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                //                                            message:Message
                //                                           delegate:nil cancelButtonTitle:@"OK"
                //                                  otherButtonTitles: nil];
                //[alert show];
                BioBlitzName        = [self GetTranslatingDataSheetName];
                //NSLog(@"null attribute so bioblitz child:%@",child);
            }
            //continue;
        }
        
        //
        // this could be an organism or an attribute
        // if it's an organism, create the organism
        // XML.  If it's an attribute, create the
        // attribute XML
        //
        // is this an organism
        if(IsOrganismDetails || IsOrganismList || NullAttribute)
        {
            DoneAnOrganism = true;
            // do we need to complete the current organism
            if(OrganismStarted)
            {
                // close AttributeData
                //
                // close off the previous Attributes, OrganismDataEntry and
                // open the new/next organism
                //
                if(AttributesStarted)
                {
                    [self BuildLoginStatus:@"\t\t\t\t</AttributeData>\n"];
                    AttributesStarted   = false;
                }
                // close off the current organism and open a new one
                
                [self BuildLoginStatus:@"\t\t\t</OrganismDataEntry>\n"];
                [self BuildLoginStatus:@"\t\t\t<OrganismDataEntry>\n"];
            }
            else
            {
                // this is the first organism so start it
                [self BuildLoginStatus:@"\t\t\t<OrganismDataEntry>\n"];
                
                // mark the organism as atarted
                OrganismStarted = true;
            }
            
            //
            // OrganismDataEntry is complete so generate the OrganismInfos
            // for this organism.  The HowSpecified String should always be
            // 'Defined' and ValueType will always be null
            //
            // organisminfos (HowSpecifiedString)
            [self ParseTheAttributes:child :@"HowSpecifiedString"];
            strname2                    = [[NSString alloc]initWithFormat:@"%@",[self GetParsedAttributeValue]];
            strname2                    = [self TranslateDefinition:strname2:@""];
            if(IsOrganismList)
            {
                strname2                = @"Select";
            }
            if(NullAttribute)
            {
                strname2                = @"Entered";
            }
            tempstring                  = [[NSString alloc]initWithFormat:@"\t\t\t\t<OrganismInfos HowSpecified='%@'>\n",strname2];
            
            [self BuildLoginStatus:tempstring];
            
            //
            // now the OrganismInfosOption
            //
            [self SetParsedAttributeValue:@""];
            if(IsOrganismList)
            {
                NSMutableArray *TheList = [child valueForKeyPath:@"OrganismList"];
                NSMutableArray *TheNames= [TheList valueForKeyPath:@"Name"];
                NSMutableArray *TheIDs  = [TheList valueForKeyPath:@"ID"];
                int TheListCount        = (int)[TheList count];
                ////NSLog(@"theList: %@",TheList);
                for(int orgcount=0; orgcount<TheListCount;orgcount++)
                {
                    NSString *OrgName   = [[NSString alloc]initWithFormat:@"%@",[TheNames objectAtIndex:orgcount]];
                    NSString *OrgID     = [[NSString alloc]initWithFormat:@"%@",[TheIDs objectAtIndex:orgcount]];
                    
                    if([OrgID isEqual:[NSNull null]])
                    {
                        OrgID           = @"";
                    }
                    tempstring          = [[NSString alloc]initWithFormat:@"\t\t\t\t\t<OrganismInfoOption Name='%@' OrganismInfoID='%@' />\n",OrgName,OrgID];
                    
                    [self BuildLoginStatus:tempstring];
                }
            }
            else
            {
                strname                 = [child valueForKeyPath:@"OrganismDetails.Name"];
                strname                 = [self FixXML:strname];
                strvalue                = [child valueForKey:@"OrganismInfoID"];
                
                if([strvalue isEqual:[NSNull null]])
                {
                    strvalue           = @"";
                }
                
                tempstring              = [[NSString alloc]initWithFormat:@"\t\t\t\t\t<OrganismInfoOption Name='%@' OrganismInfoID='%@' />\n",strname,strvalue];
                [self BuildLoginStatus:tempstring];
            }
            //
            // close the OrganismInfos
            //
            [self BuildLoginStatus:@"\t\t\t\t</OrganismInfos>\n"];
        }
        
        if(IsAttribute)
        {
            if(!DoneAnOrganism)
            {
                ///NSLog(@"we should have seen an organism, but have not");
            }
            // the organismdataentry and organisminfos are complete
            // do the attributes for this organism
            // write out the attributedata
            //
            // we have an attribute so write it out
            //
            if(OrganismStarted)
            {
                if(!AttributesStarted)
                {
                    [self BuildLoginStatus:@"\t\t\t\t<AttributeData>\n"];
                    AttributesStarted = true;
                }
            }
            
            // now write out the AttributeDataEntry
            strname             = [child valueForKey:@"HowSpecifiedString"];
            NSString *ValueType = [child valueForKey:@"ValueType"];
            NSString *UnitType  = [child valueForKeyPath:@"UnitDetails.Abbreviation"];
            strname             = [self TranslateDefinition:strname:ValueType];
            strname2            = [child valueForKey:@"Name"];
            strvalue            = [child valueForKey:@"AttributeTypeID"];
            strvalue2           = [child valueForKey:@"UnitID"];
            if([strvalue2 isEqual:[NSNull null]])
            {
                strvalue2 = @"";
            }
            
            if([strvalue isEqual:[NSNull null]])
            {
                strvalue = @"";
            }
            
            if([UnitType length] == 0)
            {
                UnitType = @"";
            }
            
            tempstring          = [[NSString alloc]initWithFormat:@"\t\t\t\t\t<AttributeDataEntry HowSpecified='%@' Name='%@' UnitID='%@' AttributeTypeID='%@' Units='%@'>\n",strname,strname2,strvalue2,strvalue,UnitType];
            [self BuildLoginStatus:tempstring];
            
            // now the attributeDataOptions
            temp                = [child valueForKey:@"AttributeValuesPossible"];
            
            int attributetotal  = (int)[temp count];
            for(int attrcount=0; attrcount < attributetotal; attrcount++)
            {
                NSArray *attributevalues = [temp objectAtIndex:attrcount];
                strname         = [attributevalues valueForKey:@"Name"];
                strvalue        = [attributevalues valueForKey:@"ID"];
                tempstring      = [[NSString alloc]initWithFormat:@"\t\t\t\t\t\t<AttributeDataOption Name='%@' ID='%@'/>\n",strname,strvalue];
                [self BuildLoginStatus:tempstring];
            }
            
            // close out AttributeDataEntry
            [self BuildLoginStatus:@"\t\t\t\t\t</AttributeDataEntry>\n"];
        }
    } // end of AllOrganisms loop
    
    if(OrganismStarted)
    {
        // close AttributeData
        //
        // close off the previous Attributes, OrganismDataEntry and
        // open the new/next organism
        //
        if(AttributesStarted)
        {
            [self BuildLoginStatus:@"\t\t\t\t</AttributeData>\n"];
            AttributesStarted   = false;
        }
        // close off the last organism
        [self BuildLoginStatus:@"\t\t\t</OrganismDataEntry>\n"];
    }
}

-(Boolean)IsNullAttribute:(id)TheObject
{
    Boolean     result = false;            // assume failure
    NSString    *AttributeCategoryID;
    NSString    *AttributeTypeID;
    NSString    *AttributeValueID;
    NSString    *Description;
    NSString    *HowSpecified;
    NSString    *HowSpecifiedString;
    NSString    *MaximumValue;
    NSString    *MinimumValue;
    NSString    *Name;
    NSString    *OrderNumber;
    NSString    *OrganismInfoID;
    NSString    *Picklist;
    NSString    *SubplotTypeID;
    NSString    *UnitID;
    NSString    *ValueType;
    
    AttributeCategoryID     = [TheObject valueForKeyPath:@"AttributeCategoryID"];
    AttributeTypeID         = [TheObject valueForKeyPath:@"AttributeTypeID"];
    AttributeValueID        = [TheObject valueForKeyPath:@"AttributeValueID"];
    Description             = [TheObject valueForKeyPath:@"Description"];
    HowSpecified            = [TheObject valueForKeyPath:@"HowSpecified"];
    HowSpecifiedString      = [TheObject valueForKeyPath:@"HowSpecifiedString"];
    MaximumValue            = [TheObject valueForKeyPath:@"MaximumValue"];
    MinimumValue            = [TheObject valueForKeyPath:@"MinimumValue"];
    Name                    = [TheObject valueForKeyPath:@"Name"];
    OrderNumber             = [TheObject valueForKeyPath:@"OrderNumber"];
    OrganismInfoID          = [TheObject valueForKeyPath:@"OrganismInfoID"];
    Picklist                = [TheObject valueForKeyPath:@"Picklist"];
    SubplotTypeID           = [TheObject valueForKeyPath:@"SubplotTypeID"];
    UnitID                  = [TheObject valueForKeyPath:@"UnitID"];
    ValueType               = [TheObject valueForKeyPath:@"ValueType"];

    
    if (   ([AttributeCategoryID isEqual:[NSNull null]])       &&
           ([AttributeTypeID     isEqual:[NSNull null]])       &&
           ([AttributeValueID    isEqual:[NSNull null]])       &&
           ([Description         isEqual:[NSNull null]])       &&
           ([HowSpecified        isEqual:[NSNull null]])       &&
           ([HowSpecifiedString  isEqualToString:@""])         &&
           ([MaximumValue        isEqual:[NSNull null]])       &&
           ([MinimumValue        isEqual:[NSNull null]])       &&
           ([Name                isEqualToString:@""])         &&
           ([OrderNumber         isEqual:[NSNull null]])       &&
           ([OrganismInfoID      isEqual:[NSNull null]])       &&
           ([Picklist            isEqual:[NSNull null]])       &&
           ([SubplotTypeID       isEqual:[NSNull null]])       &&
           ([UnitID              isEqual:[NSNull null]])       &&
           ([ValueType           isEqual:[NSNull null]])     )
           {
               result = true;
           }
    /*****
     AttributeCategoryID = "<null>";
     AttributeTypeID = "<null>";
     AttributeValueID = "<null>";
     Description = "<null>";
     HowSpecified = "<null>";
     HowSpecifiedString = "";
     ID = 4822;
     MaximumValue = "<null>";
     MinimumValue = "<null>";
     Name = "";
     OrderNumber = "<null>";
     OrganismInfoID = "<null>";
     ParentFormEntryID = "<null>";
     Picklist = "<null>";
     SubplotTypeID = "<null>";
     UnitID = "<null>";
     ValueType = "<null>";
    *****/
    return result;
}

//
// the organisms are organized into:
// 1. an organisminfos header
// 2. any number of attributes for that organism
// and there are any number of organisms in a data sheet.
// so loop through as:
// for each organism
// 1. write first/next organisminfos section
//    for each attribute
//    1. write first/next attribute section
//
//
// TheObject is the JSON returned from the API.
// The job is to isolate the current project, denoted by
// projnum, and get each data sheet, denoted by datasheet
// for that projnum.  Therefore, this method needs to parse
// TheObject[projnum].Datasheet[datasheet].
//
-(void)WriteXMLOrganismDataOld:(id)TheObject :(int)datasheet : (int) projnum : (int)numdatasheets : (int)numprojects
{
    NSDictionary    *JsonResponseDictionary;
    id              dsAttributes;               // data sheet attributes
    id              CurrentDataSheets;          // all datasheets for this project
    id              ThisDataSheet;              // the datasheet to be parsed
    id              AllOrganisms;               // for the current datasheet
    id              AllDataSheets;              // all data sheets from JSON
    NSArray         *temp;                      // temporary array
    NSString        *strvalue;                  // common place holder for a value
    NSString        *strname;                   // common place holder for a name
    NSString        *strname2;                  // second common place holder for additional names
    NSString        *strvalue2;                 // second common place holder for addtional values
    NSString        *tempstring;                // build loginstatus
    NSString        *AttributesString;          // holding place for attributes
    Boolean         OrganismStarted;            // trigger to write either XML open or close
    Boolean         FoundOrgDetails;            // does organismdetails exist
    Boolean         AttributesStarted;          // trigger to write the attributedata tag
    Boolean         IsOrganismList;             // flag for pick list
    Boolean         IsOrganismDetails;          // flag for single organism
    
    JsonResponseDictionary      = TheObject;
    dsAttributes                = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets.OrgAttributes"];
    AllDataSheets               = [JsonResponseDictionary valueForKeyPath:@"data.Datasheets"];
    
    CurrentDataSheets           = [AllDataSheets objectAtIndex:projnum];
    ThisDataSheet               = [CurrentDataSheets objectAtIndex:datasheet];
    AllOrganisms                = [ThisDataSheet valueForKeyPath:@"OrgAttributes"];
    
    OrganismStarted             = false;
    AttributesStarted           = false;
    AttributesString            = @"";
    
    // handle zero attributes by examining only the
    // first child of AllOrganisms.  If there are no
    // OrganismDetails, there are no Organisms.
    FoundOrgDetails             = false;
    for(id child in AllOrganisms)
    {
        // examine all children and stop when OrganismDetails is found
        id x = [child valueForKeyPath:@"OrganismDetails"];
        
        if (x != NULL)
        {
            FoundOrgDetails = true;
            break;
        }
        
        // check for an organism list and stop if it's found
        x = [child valueForKeyPath:@"OrganismList"];
        
        if (x != NULL)
        {
            FoundOrgDetails = true;
            break;
        }
    }
    
    // if there are neither organisms nor organism picklsits
    // get out of here
    if(!FoundOrgDetails)
    {
        // no organism details so skip this
        return;
    }
    
    //
    // we have at least one organism or organism picklist
    // so open the OrgasnismData tree.  For each organism
    // we know there has to be details or there has to be
    // an organism list.  If there isn't, this data sheet
    // is illegal that will get caught later
    //
    NSLog(@"AllOrganisms count: %lu",(unsigned long)[AllOrganisms count]);
    for(id child in AllOrganisms)
    {
        IsOrganismList      = false;
        IsOrganismDetails   = false;
        id x = [child valueForKeyPath:@"OrganismDetails"];
        if (x == NULL)
        {
            x = [child valueForKeyPath:@"OrganismList"];
            if (x != NULL)
            {
                IsOrganismList = true;
            }
        }
        else
        {
            IsOrganismDetails = true;
        }
        
        //if(IsOrganismList)
        //{
        //    NSLog(@"skipping organism pick list");
        //    continue;
        //}
        
        //
        // if x is null at this point, we have an out of order attribute
        // so deal with it.  That is, save it for writing after the
        // organism header and body are first written out.  This should
        // no longer happen.  But...
        //
        if (x == NULL)
        {
            // this child must be an attribute that we've already done
            // so skip it.  We'll see..
            continue;
        }
        if (x != NULL)
        {
            if(!OrganismStarted)
            {
                ////NSLog(@"organism not started and we have an attribute so it's out of order");
            }
            //NSLog(@"out of order attribute");
            //x = [child valueForKeyPath:@"OrganismList"];
            //if(x != NULL)
            //{
            //    NSLog(@"skipping picklist");
            //    continue;       // skip for now
            //}
            
            //
            // no organism details but we know it's not a list too
            // if OrganismDetails ot List is not first and we have
            // attribute data, it has to be saved and added
            // to the XML after the OrganismInfos section
            //
            //
            // we have an attribute so write it out
            //
            if(OrganismStarted)
            {
                if(!AttributesStarted)
                {
                    [self BuildLoginStatus:@"\t\t\t\t<AttributeData>\n"];
                    AttributesStarted = true;
                }
            }
            else
            {
                if(!AttributesStarted)
                {
                    AttributesString    = [AttributesString stringByAppendingString:@"\t\t\t\t<AttributeData>\n"];
                    AttributesStarted   = true;
                }
            }
            
            strname             = [child valueForKey:@"HowSpecifiedString"];
            NSString *ValueType = [child valueForKey:@"ValueType"];
            strname             = [self TranslateDefinition:strname:ValueType];
            strname2            = [child valueForKey:@"Name"];
            strvalue            = [child valueForKey:@"AttributeTypeID"];
            strvalue2           = [child valueForKey:@"UnitID"];
            if([strvalue2 isEqual:[NSNull null]])
            {
                strvalue2 = @"";
            }
            
            tempstring          = [[NSString alloc]initWithFormat:@"\t\t\t\t\t<AttributeDataEntry HowSpecified='%@' Name='%@' UnitID='%@' AttributeTypeID='%@'>\n",strname,strname2,strvalue2,strvalue];
            if(OrganismStarted)
            {
                [self BuildLoginStatus:tempstring];
            }
            else
            {
                AttributesString= [AttributesString stringByAppendingString:tempstring];
            }
            temp                = [child valueForKey:@"AttributeValuesPossible"];
            
            int attributetotal  = (int)[temp count];
            for(int attrcount=0; attrcount < attributetotal; attrcount++)
            {
                NSArray *attributevalues = [temp objectAtIndex:attrcount];
                strname         = [attributevalues valueForKey:@"Name"];
                strvalue        = [attributevalues valueForKey:@"ID"];
                tempstring      = [[NSString alloc]initWithFormat:@"\t\t\t\t\t\t<AttributeDataOption Name='%@' ID='%@'/>\n",strname,strvalue];
                if(OrganismStarted)
                {
                    [self BuildLoginStatus:tempstring];
                }
                else
                {
                    AttributesString = [AttributesString stringByAppendingString:tempstring];
                }
            }
            
            if(OrganismStarted)
            {
                [self BuildLoginStatus:@"\t\t\t\t\t</AttributeDataEntry>\n"];
                ////[self BuildLoginStatus:@"\t\t\t\t</AttributeData>\n"];
            }
            else
            {
                AttributesString = [AttributesString stringByAppendingString:@"\t\t\t\t\t</AttributeDataEntry>\n"];
                ////AttributesString = [AttributesString stringByAppendingString:@"\t\t\t\t</AttributeData>\n"];
            }
        }
        else
        {
            //
            // this is an organism so prepare for the OrganismInfos
            //
            //NSString *foo = [[NSString alloc]initWithFormat:@"%@",[child valueForKeyPath:@"OrganismDetails.Name"]];
            //NSLog(@"organism name: %@",foo);
            
            if(OrganismStarted)
            {
                //
                // close off the previous Attributes, OrganismDataEntry and
                // open the new/next organism
                //
                if(AttributesStarted)
                {
                    [self BuildLoginStatus:@"\t\t\t\t</AttributeData>\n"];
                    AttributesStarted   = false;
                }
                
                [self BuildLoginStatus:@"\t\t\t</OrganismDataEntry>\n"];
                [self BuildLoginStatus:@"\t\t\t<OrganismDataEntry>\n"];
            }
            else
            {
                //
                // mark the first OrganismDataEntry
                //
                OrganismStarted     = true;
                [self BuildLoginStatus:@"\t\t\t<OrganismDataEntry>\n"];
            }
            
            //
            // OrganismDataEntry is complete so generate the OrganismInfos
            // for this organism.  The HowSpecified String should always be
            // 'Defined' and ValueType will always be null
            //
            // organisminfos (HowSpecifiedString)
            [self ParseTheAttributes:child :@"HowSpecifiedString"];
            strname2                    = [[NSString alloc]initWithFormat:@"%@",[self GetParsedAttributeValue]];
            strname2                    = [self TranslateDefinition:strname2:@""];
            if(IsOrganismList)
            {
                strname2                = @"Select";
            }
            tempstring                  = [[NSString alloc]initWithFormat:@"\t\t\t\t<OrganismInfos HowSpecified='%@'>\n",strname2];
            [self BuildLoginStatus:tempstring];
            
            //
            // now the OrganismInfosOption
            //
            [self SetParsedAttributeValue:@""];
            if(IsOrganismList)
            {
                NSMutableArray *TheList = [child valueForKeyPath:@"OrganismList"];
                NSMutableArray *TheNames= [TheList valueForKeyPath:@"Name"];
                NSMutableArray *TheIDs  = [TheList valueForKeyPath:@"ID"];
                int TheListCount        = (int)[TheList count];
                ////NSLog(@"theList: %@",TheList);
                for(int orgcount=0; orgcount<TheListCount;orgcount++)
                {
                    NSString *OrgName   = [[NSString alloc]initWithFormat:@"%@",[TheNames objectAtIndex:orgcount]];
                    NSString *OrgID     = [[NSString alloc]initWithFormat:@"%@",[TheIDs objectAtIndex:orgcount]];
                    tempstring          = [[NSString alloc]initWithFormat:@"\t\t\t\t\t<OrganismInfoOption Name='%@' OrganismInfoID='%@' />\n",OrgName,OrgID];
                    [self BuildLoginStatus:tempstring];
                    ////NSLog(@"tempstring: %@",tempstring);
                }
            }
            else
            {
                strname                 = [child valueForKeyPath:@"OrganismDetails.Name"];
                strname                 = [self FixXML:strname];
                strvalue                = [child valueForKey:@"OrganismInfoID"];
                tempstring              = [[NSString alloc]initWithFormat:@"\t\t\t\t\t<OrganismInfoOption Name='%@' OrganismInfoID='%@' />\n",strname,strvalue];
                [self BuildLoginStatus:tempstring];
            }
            //
            // close the OrganismInfos
            //
            [self BuildLoginStatus:@"\t\t\t\t</OrganismInfos>\n"];
            
            //
            // now check to see if AttributesString is empty.
            // if it is, do nothing otherwise add it to the XML
            //
            if(!([AttributesString isEqualToString:@""]))
            {
                [self BuildLoginStatus:AttributesString];
                AttributesString = @"";
            }
        }
    }
    
    // close off the first/last organism data entry abd attribute data
    if(AttributesStarted)
    {
        [self BuildLoginStatus:@"\t\t\t\t</AttributeData>\n"];
        AttributesStarted   = false;
    }
    [self BuildLoginStatus:@"\t\t\t</OrganismDataEntry>\n"];
}

-(void)SetAllDataFileStarted:(Boolean)TheStatus
{
    AllDataFileStarted = TheStatus;
}
-(Boolean)GetAllDataFileStarted
{
    return AllDataFileStarted;
}

-(void)FinishLoginStatus
{
    NSString        *ApplicationsPath;
	NSString        *tempstring;
    NSString        *AllData;
	NSArray         *DirectoryPaths;
	NSData          *tempdata;
    NSFileHandle    *file;
    
    // read the options
    [self ReadOptionsFromFile];
    
    // get the path for this application in the Docs directory
	DirectoryPaths                  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath                = [DirectoryPaths objectAtIndex:0];
    ApplicationsPath                = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
    AllData                         = [ApplicationsPath stringByAppendingPathComponent:SERVERDATAPATH];
    AllData                         = [AllData stringByAppendingString:XMLEXTENSION];
    
    if([self GetAllDataFileStarted])
    {
        // write out the end
        // open it append
        file                        = [NSFileHandle fileHandleForWritingAtPath:AllData];
        [file seekToEndOfFile];
    }
    else
    {
        // create the file for writing out the entire string
        [[NSFileManager defaultManager] removeItemAtPath:AllData error:nil];
        [[NSFileManager defaultManager] createFileAtPath:AllData contents:nil attributes:nil];
        file                        = [NSFileHandle fileHandleForWritingAtPath:AllData];
    }
    
    // write out the section
    tempstring                  = [NSString stringWithFormat:@"%@\n",self.loginStatus];
    tempdata                    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
    [file writeData:tempdata];
    [file closeFile];
}

-(void)WriteLoginStatus
{
    static Boolean FirstTimeCalled  = true;
	NSString        *ApplicationsPath;
	NSString        *tempstring;
    NSString        *AllData;
	NSArray         *DirectoryPaths;
	NSData          *tempdata;
    NSFileHandle    *file;
    
    // read the options
    [self ReadOptionsFromFile];
    
    // get the path for this application in the Docs directory
	DirectoryPaths                  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath                = [DirectoryPaths objectAtIndex:0];
    ApplicationsPath                = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
    AllData                         = [ApplicationsPath stringByAppendingPathComponent:SERVERDATAPATH];
    AllData                         = [AllData stringByAppendingString:XMLEXTENSION];
    
    if(FirstTimeCalled)
    {
        // nuke and create the file
        FirstTimeCalled             = false;
        [self SetAllDataFileStarted:true];
        [[NSFileManager defaultManager] removeItemAtPath:AllData error:nil];
        [[NSFileManager defaultManager] createFileAtPath:AllData contents:nil attributes:nil];
        file                        = [NSFileHandle fileHandleForWritingAtPath:AllData];
    }
    else
    {
        // open it append
        file                        = [NSFileHandle fileHandleForWritingAtPath:AllData];
        [file seekToEndOfFile];
    }
    
    // write out the section
    tempstring                  = [NSString stringWithFormat:@"%@\n",self.loginStatus];
    tempdata                    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
    [file writeData:tempdata];
    [file closeFile];
}

-(void)WriteXMLAllFiles:(NSString *)TheOldData
{
	NSString	  *FormsXMLPath;
    NSString      *ProjectXMLFile;
	NSString	  *ApplicationsPath;
	NSString	  *tempstring;
    NSString      *AllData;
	NSArray		  *DirectoryPaths;
	NSData		  *tempdata;
    Boolean       WriteDebug=false;
    NSString      *TheData;
    
    // read the options
    [self ReadOptionsFromFile];
    
    // get the path for this application in the Docs directory
	DirectoryPaths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath = [DirectoryPaths objectAtIndex:0];
    ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
	FormsXMLPath     = [ApplicationsPath stringByAppendingPathComponent:XMLFORMSPATH];
    ProjectXMLFile   = [ApplicationsPath stringByAppendingPathComponent:XMLPROJECTSFILE];
    AllData          = [ApplicationsPath stringByAppendingPathComponent:SERVERDATAPATH];
    AllData          = [AllData stringByAppendingString:XMLEXTENSION];
    
    //
    // nuke all the existing XML files prior to writing the
    // new versions and create the new location
    //
    [[NSFileManager defaultManager] removeItemAtPath:FormsXMLPath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:FormsXMLPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //
    // TheData used to come in as a huge string.  Now it is written to a
    // file.  So we read it in and format it as a string into a local string
    // variable.  The old variable is now called TheOldData and the new
    // data is called TheData.  We read the "string" from the file AllData
    //
    TheData             = [NSString stringWithContentsOfFile:AllData encoding:NSUTF8StringEncoding error:nil];
    
    //
    // separate TheData into the component files.  The first is the Projects
    // XML file followed by "=====" followed by the Forms files
    //
    NSArray         *EachLine                   = [TheData componentsSeparatedByString:@"\n"];
    Boolean         FileOpen                    = false;
    Boolean         DoingProjectsXML            = true;
    Boolean         DoXMLHeader                 = false;
    NSString        *CurrentFile                = [[NSString alloc]initWithString:ProjectXMLFile];
    NSFileHandle    *file;
    int             i                           = 0;
    int             CurrentForm                 = 0;
    int             linecount                   = (int)[EachLine count]-1;
    NSMutableArray  *TheFormNames               = [[NSMutableArray alloc]init];     // this will autorelease
    NSMutableArray  *SomeFormNames              = [[NSMutableArray alloc]init];
    NSMutableArray  *TheProjectNames            = [[NSMutableArray alloc]init];
    Boolean         MoreFiles                   = true;
    
    /*****
     // get rid of writing the file here.  It's now done elsewhere
     //
    [[NSFileManager defaultManager] createFileAtPath:AllData contents:nil attributes:nil];
    file                    = [NSFileHandle fileHandleForWritingAtPath:AllData];
    tempstring=[NSString stringWithFormat:@"%@\n",TheData];
    tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
    [file writeData:tempdata];
    [file closeFile];
    ******/
    
    for(i=0;i<linecount;i++)
    {
        if(!MoreFiles) break;
        // "read" the line
        NSString *ThisLine = [[NSString alloc] initWithFormat:@"%@",[EachLine objectAtIndex:i]];
        if([ThisLine isEqualToString:@"\r"]) continue;
        
        // nuke and open the file, if necessary - write the XML line too!
        if(!FileOpen)
        {
            [[NSFileManager defaultManager] createFileAtPath:CurrentFile contents:nil attributes:nil];
            file                    = [NSFileHandle fileHandleForWritingAtPath:CurrentFile];
            FileOpen                = true;
        }
        
        
        // if the line is "=====\n" close the file
        if([ThisLine isEqualToString:XMLSEPARATOR])
        {
            int ProjectIndex = 0;
            int FormIndex    = 0;
            DoXMLHeader      = true;
            // close the file and start a new one
            [file closeFile];
            
            if(DoingProjectsXML)
            {
                [TheFormNames removeAllObjects];
                [TheProjectNames removeAllObjects];
                [SomeFormNames removeAllObjects];
                ////NSLog(@"theprojectnames count = %d", [TheProjectNames count]);
                // for each project name, get all form names
                [self ParseXMLProject:ProjectXMLFile];
                
                [self SetProjectNames];
                TheProjectNames = [self GetProjectNames];
                
                if(WriteDebug)
                {
                    NSLog(@"count of project names = %lu",(unsigned long)[TheProjectNames count]);
                    NSLog(@"projectname = %@",[TheProjectNames objectAtIndex:0]);
                }
                
                ////NSLog(@"theprojectnames count = %d", [TheProjectNames count]);
                
                int projectstart = 0;
                int projectend   = (int)[TheProjectNames count];

                for(ProjectIndex = projectstart; ProjectIndex<projectend; ProjectIndex++)
                {
                    [self SetCurrentProjectName:[TheProjectNames objectAtIndex:ProjectIndex]];
                    
                    if(WriteDebug)
                    {
                        NSLog(@"Selected project is: %@",[self GetCurrentProjectName]);
                    }
                    
                    // set form names here
                    [self SetFormNames];
                    SomeFormNames = [self GetFormNames];
                    for(FormIndex=0; FormIndex < [SomeFormNames count]; FormIndex++)
                    {
                        NSString *foo = [[NSString alloc]initWithFormat:@"%@",[SomeFormNames objectAtIndex:FormIndex]];
                        if([foo isEqualToString:@""])
                        {
                            foo=@"NoNameForForm";
                            [TheFormNames addObject:foo];
                        }
                        else
                        {
                            [TheFormNames addObject:[SomeFormNames objectAtIndex:FormIndex]];
                        }
                        
                        if(WriteDebug)
                        {
                            NSLog(@"formname=%@",[SomeFormNames objectAtIndex:FormIndex]);
                        }
                    }
                }
                
                DoingProjectsXML = false;
            }
            
            
            if(CurrentForm <= [TheFormNames count])
            {
                if(CurrentForm == [TheFormNames count])
                {
                    MoreFiles = false;
                }
                else
                {
                    NSString *foo = [[NSString alloc]initWithFormat:@"%@",[TheFormNames objectAtIndex:CurrentForm]];
                    CurrentFile = [FormsXMLPath stringByAppendingPathComponent:foo];
                    CurrentForm++;
                }
                
                FileOpen    = false;
            }
        }
        else
        {
            // write the line
            if(DoXMLHeader)
            {
                DoXMLHeader = false;
                tempstring=[NSString stringWithFormat:@"%@\n",@"<?xml version='1.0' ?>"];
                tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
            }
            tempstring=[NSString stringWithFormat:@"%@\n",ThisLine];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
        }
    }
}

-(Boolean)DoesXMLExist
{
    Boolean         ReturnValue = true;
    NSString        *ProjectXMLFile;
	NSString        *ApplicationsPath;
	NSArray         *DirectoryPaths;
    
    [self ReadOptionsFromFile];
    
    DirectoryPaths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath = [DirectoryPaths objectAtIndex:0];
    ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
    ProjectXMLFile   = [ApplicationsPath stringByAppendingPathComponent:XMLPROJECTSFILE];
    
    if (!([[NSFileManager defaultManager] fileExistsAtPath:ProjectXMLFile]))
	{
        ReturnValue = false;
    }
    
    return ReturnValue;
}


-(void)ParseXMLProject:(NSString *)TheFileName
{
    // variables for the parser
    NSData  *tempdata;
    NSError *error;
    NSString *tempstring=[[NSString alloc] initWithContentsOfFile:TheFileName encoding:NSUTF8StringEncoding error:&error];
    tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
    
    // variables for the project and form data structures
    ProjectNode *TempProject;
    FormNode    *TempForm;
    Boolean     FirstProject;
    Boolean     FirstForm;
    Boolean     ParseProjectDebug=false;
    
    //
    // nuke the forms and projects structure so we start clean
    // every time
    //
    
    ////[ProjectHead DumpProjectList:ProjectHead];
    [ProjectHead NukeProjectsFromStructure:ProjectHead];
    [self.FormNames removeAllObjects];
    [self.ProjectNames removeAllObjects];
    [self.FormIDs removeAllObjects];
    [self.ProjectIDs removeAllObjects];
    ProjectHead = [[ProjectNode alloc]init];
    
    //
    // use the SMXMLParser for the forms
    //
    NSString *sampleContents = [NSString stringWithContentsOfFile:TheFileName encoding:NSUTF8StringEncoding error:&error];
    
    // nuke the "&" character for parsing, but put it back in for display
    //          "<"
    //          ">"
    //          "'"
    //          " " "
    //          "%"
    //          "+"
    //          "?"
    //          ")"
    //          "("
    //          "/"
    //          "="
    //          ","
    /***
    NSString *TheActualString = [sampleContents stringByReplacingOccurrencesOfString:AMPERSANDCHAR withString:AMPERSANDSTRING];
    TheActualString           = [TheActualString stringByReplacingOccurrencesOfString:LESSTHANCHAR withString:LESSTHANSTRING];
    TheActualString           = [TheActualString stringByReplacingOccurrencesOfString:GREATERTHANCHAR withString:GREATERTHANSTRING];
    TheActualString           = [TheActualString stringByReplacingOccurrencesOfString:TICKCHAR withString:TICKSTRING];
    TheActualString           = [TheActualString stringByReplacingOccurrencesOfString:QUOTECHAR withString:QUOTESTRING];
    TheActualString           = [TheActualString stringByReplacingOccurrencesOfString:PERCENTCHAR withString:PERCENTSTRING];
    TheActualString           = [TheActualString stringByReplacingOccurrencesOfString:PLUSCHAR withString:PLUSSTRING];
    TheActualString           = [TheActualString stringByReplacingOccurrencesOfString:QUESTIONCHAR withString:QUESTIONSTRING];
    TheActualString           = [TheActualString stringByReplacingOccurrencesOfString:RPARENCHAR withString:RPARENSTRING];
    TheActualString           = [TheActualString stringByReplacingOccurrencesOfString:LPARENCHAR withString:LPARENSTRING];
    TheActualString           = [TheActualString stringByReplacingOccurrencesOfString:SLASHCHAR withString:SLASHSTRING];
    TheActualString           = [TheActualString stringByReplacingOccurrencesOfString:EQUALCHAR withString:EQUALSTRING];
    TheActualString           = [TheActualString stringByReplacingOccurrencesOfString:COMMACHAR withString:COMMASTRING];
    **/
    
    NSString *TheActualString = [[NSString alloc]initWithFormat:@"%@",sampleContents];
    NSData *data = [TheActualString dataUsingEncoding:NSUTF8StringEncoding];
	
	// create a new SMXMLDocument with the contents of sample.xml
	SMXMLDocument *document = [SMXMLDocument documentWithData:data error:&error];
    
    // check for errors
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"XML parsing error.  Contact Leeway Software Design (lkc@leewaysd.com)!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [self SetProjectDataAvailable:false];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"parsecomplete" object:self];
        return;
    }
    
    //
    // walk the XML file
    //
    SMXMLElement *AllProjects    = document.root;
    
    // 1. GODMProject
    FirstProject = true;
    for (SMXMLElement *GODMProject in [AllProjects childrenNamed:@"GODMProject"])
    {
        // set up the data structures for the project(s)
        TempProject                     = [[ProjectNode alloc]init];
        CurrentProjectNode              = TempProject;
        FirstForm                       = true;
        if(FirstProject)
        {
            ProjectHead                 = TempProject;
        }
        
        // get the project name and id
        NSString        *ProjectName    = [GODMProject attributeNamed:@"Name"];
        NSString        *ProjectID      = [GODMProject attributeNamed:@"ID"];
        
        // set the current name and id
        [TempProject SetProjectName:TempProject :ProjectName];
        [TempProject SetProjectID:TempProject :ProjectID];
        
        // add the project node to the list of nodes
        if(!FirstProject)
        {
            [TempProject AddProjectNode:ProjectHead:TempProject];
        }
        else
        {
            FirstProject=false;
        }
        
        if(ParseProjectDebug)
        {
            NSLog(@"Project values: %@ %@",ProjectName,ProjectID);
        }
        
        for(SMXMLElement  *GODMForm in [GODMProject childrenNamed:@"GODMForm"])
        {
            // set up the data structures for the forms
            TempForm                    = [[FormNode alloc]init];
            if(FirstForm)
            {
                CurrentProjectNode->FormHead    = TempForm;
                LocalFormHead                   = TempForm;
                FirstForm                       = false;
            }
            else
            {
                [LocalFormHead AddFormToFormList:LocalFormHead :TempForm];
            }
            
            // get the form anme and id
            NSString      *FormName             = [GODMForm attributeNamed:@"Name"];
            NSString      *FormID               = [GODMForm attributeNamed:@"ID"];
            
            // set the current name and id
            [TempForm SetFormName:TempForm :FormName];
            [TempForm SetFormID:TempForm :FormID];
            
            if(ParseProjectDebug)
            {
                NSLog(@"    form value: %@ %@",FormName,FormID);
            }
        }
    }
    
    ParseProjectDebug=false;
    if(ParseProjectDebug)
    {
        [ProjectHead DumpProjectList:ProjectHead];
    }
    ParseProjectDebug=false;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"parsecomplete" object:self];
}

//
// parses the XML for the forms leaving the project
// data structures alone.  The same parse is used.
// TheFileName is the complete path name of the
// file.  Nuke the data structures for the form
//
-(void)ParseXMLForm:(NSString *)TheFileName
{
    NSData  *tempdata;
    NSError *error;
    NSString *tempstring=[[NSString alloc] initWithContentsOfFile:TheFileName encoding:NSUTF8StringEncoding error:&error];
    tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
    
    ////NSLog(@"ParseXMLForm: %@",TheFileName);
    
    // organism data structures
    [self.OrganismDataName removeAllObjects];
    [self.OrganismDataIDs removeAllObjects];
    [self.OrganismNumberOfAttributes removeAllObjects];
    [self.OrganismPicklist removeAllObjects];
    
    // attribute data structures
    [self.AttributeDataName removeAllObjects];
    [self.AttributeDataType removeAllObjects];
    [self.AttributeDataTypeModifier removeAllObjects];
    [self.AttributeDataTypeIDs removeAllObjects];
    [self.AttributeDataChoiceCount removeAllObjects];
    [self.AttributeDataChoices removeAllObjects];
    [self.AttributeDataChoicesIDs removeAllObjects];
    [self.UnitIDs removeAllObjects];
    [self.UnitAbbreviation removeAllObjects];
    
    // authority
    [self.AuthorityFirstName removeAllObjects];
    [self.AuthorityLastName removeAllObjects];
    [self.AuthorityID removeAllObjects];
    
    //
    // use the SMXMLParser for the forms
    //
    NSString *sampleContents = [NSString stringWithContentsOfFile:TheFileName encoding:NSUTF8StringEncoding error:&error];
    
    NSString *TheActualString = [[NSString alloc]initWithFormat:@"%@",sampleContents];
    NSData *data = [TheActualString dataUsingEncoding:NSUTF8StringEncoding];
	
	// create a new SMXMLDocument with the contents of sample.xml
	SMXMLDocument *document = [SMXMLDocument documentWithData:data error:&error];
    
    // check for errors
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"XML parsing error.  Contact Leeway Software Design (lkc@leewaysd.com)!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        ////NSLog(@"Error while parsing the document: %@", error);
        return;
    }
    
    //
    // walk the XML file
    //
    
    // yank out <Instructions> there are no children so just get the value
    // this will not make the traveling squad since it's not used in the
    // observation collection
    // does not make the traveling squad
    
    // yank out <Project> for name and ID
    // this makes the traveling squad
    ////SMXMLElement *Project = [document.root childNamed:@"Project"];
    ////NSString     *ProjectName = [Project attributeNamed:@"Name"];
    ////NSString     *ProjectID   = [Project attributeNamed:@"ID"];
    ////NSLog(@"projectname = %@, projectid=%@",ProjectName,ProjectID);
    
    // area is not used
    
    // Visit - this is the biggie and what we really came for
    // it has loops and levels and will be the most interesting
    // it also makes the traveling squad
    // visit fields are:
    // 1. comment       - skip
    // 2. date          - skip
    // 3. recorder      - fills a select loop
    // 4. authority     - fills a select loop
    // 5. organism data - fills the loop
    // 6. site characteristics
    ////int recordercount   = 0;
    int authoritycount  = 0;
    int organismcount   = 0;
    int attributecount  = 0;
    int sitecount       = 0;
    int selectcount     = 0;
    
    SMXMLElement *TheVisit    = [document.root childNamed:@"Visit"];
    // 3. recorder  - not used we just use the logged in user
    /****
    for (SMXMLElement *Visit in [TheVisit childrenNamed:@"Recorder"])
    {
        NSString     *RecorderSpecified = [Visit attributeNamed:@"HowSpecified"];
        NSLog(@"recorder: %@",RecorderSpecified);
        
        for(SMXMLElement  *RecorderOption in [Visit childrenNamed:@"RecorderOption"])
        {
            NSString      *FirstName = [RecorderOption attributeNamed:@"FirstName"];
            NSString      *LastName  = [RecorderOption attributeNamed:@"LastName"];
            NSString *recid          = [RecorderOption attributeNamed:@"ID"];
            NSLog(@"    %@ %@ %@",FirstName,LastName,recid);
            recordercount++;
        }
    }
    NSLog(@"recordercount = %d",recordercount);
    ****/
    
    // 4. authority
    // Select spinner code -- lkc
    ////Boolean AuthorityFirst = true;
    for (SMXMLElement *Visit in [TheVisit childrenNamed:@"Authority"])
    {
        ////NSString     *AuthoritySpecified = [Visit attributeNamed:@"HowSpecified"];
        ////NSLog(@"authority specification: %@",AuthoritySpecified);
        ////[self SetAuthoritySet:true];
        
        for(SMXMLElement  *AuthorityOption in [Visit childrenNamed:@"AuthorityOption"])
        {
            NSString      *FirstName = [AuthorityOption attributeNamed:@"FirstName"];
            NSString      *LastName  = [AuthorityOption attributeNamed:@"LastName"];
            NSString      *recid     = [AuthorityOption attributeNamed:@"ID"];
            ////NSLog(@"    authority value: %@ %@ %@",FirstName,LastName,recid);
            
            [self.AuthorityFirstName addObject:FirstName];
            [self.AuthorityLastName addObject:LastName];
            [self.AuthorityID addObject:recid];
            authoritycount++;
            
            //[FirstName release];
            //[LastName release];
            //[recid release];
        }
    }
    ////NSLog(@"    authoritycount = %d",authoritycount);
    
    // 5.organismdata
    for (SMXMLElement *OrganismData in [TheVisit childrenNamed:@"OrganismData"])
    {
        for (SMXMLElement *OrganismDataEntry in [OrganismData childrenNamed:@"OrganismDataEntry"])
        {
            organismcount++;
            // get an array for pick list storage
            NSMutableArray *temp   = [[NSMutableArray alloc]init];
            for (SMXMLElement *OrganismInfos in [OrganismDataEntry childrenNamed:@"OrganismInfos"])
            {
                NSString *HowSpecified = [OrganismInfos attributeNamed:@"HowSpecified"];
                HowSpecified           = [HowSpecified lowercaseString];
                if([HowSpecified isEqualToString:@"select"])
                {
                    [self.OrganismDataName addObject:NOTYETSET];
                    [self.OrganismDataIDs addObject:NOTYETSET];
                    for (SMXMLElement *OrganismInfoOption in [OrganismInfos childrenNamed:@"OrganismInfoOption"])
                    {
                        // get organism name
                        NSString *OrganismName = [OrganismInfoOption attributeNamed:@"Name"];
                        NSString *OrganismID   = [OrganismInfoOption attributeNamed:@"OrganismInfoID"];
                        [temp addObject:OrganismName];
                        [temp addObject:OrganismID];
                    }
                    [self.OrganismPicklist addObject:temp];
                }
                else if ([HowSpecified isEqualToString:@"entered"])
                {
                    [self.OrganismDataName addObject:NOTYETSET];
                    [self.OrganismDataIDs addObject:@" "];
                    temp = [[NSMutableArray alloc]init];
                    [self.OrganismPicklist addObject:temp];
                }
                else
                {
                    for (SMXMLElement *OrganismInfoOption in [OrganismInfos childrenNamed:@"OrganismInfoOption"])
                    {
                        // get organism name
                        NSString *OrganismName = [OrganismInfoOption attributeNamed:@"Name"];
                        NSString *OrganismID   = [OrganismInfoOption attributeNamed:@"OrganismInfoID"];
                        [self.OrganismDataName addObject:OrganismName];
                        [self.OrganismDataIDs addObject:OrganismID];
                        temp = [[NSMutableArray alloc]init];
                        [self.OrganismPicklist addObject:temp];
                    }
                }
            }
            
            ////NSLog(@"OrganismPicklist: %@",OrganismPicklist);

            // attribute data
            for (SMXMLElement *AttributeData in [OrganismDataEntry childrenNamed:@"AttributeData"])
            {
                for (SMXMLElement *AttributeDataEntry in [AttributeData childrenNamed:@"AttributeDataEntry"])
                {
                    attributecount++;
                    NSString     *AttributeSpecified = [AttributeDataEntry attributeNamed:@"HowSpecified"];
                    NSString     *AttributeName      = [AttributeDataEntry attributeNamed:@"Name"];
                    NSString     *AttributeTypeID    = [AttributeDataEntry attributeNamed:@"AttributeTypeID"];
                    NSString     *UnitID             = [AttributeDataEntry attributeNamed:@"UnitID"];
                    NSString     *Units              = [AttributeDataEntry attributeNamed:@"Units"];
                    if([Units length] == 0) Units    = @"";
                    if([UnitID length] == 0) UnitID  = @"";
                    [self.AttributeDataName addObject:AttributeName];
                    [self.AttributeDataTypeIDs addObject:AttributeTypeID];
                    if([AttributeSpecified isEqualToString:@"Date"])
                    {
                        [self.AttributeDataType addObject:@"Entered"];
                    }
                    else if([AttributeSpecified isEqualToString:@"String"])
                    {
                        [self.AttributeDataType addObject:@"Entered"];
                    }
                    else
                    {
                        [self.AttributeDataType addObject:AttributeSpecified];
                    }
                    [self.AttributeDataTypeModifier addObject:AttributeSpecified];
                    [self.UnitIDs addObject:UnitID];
                    [self.UnitAbbreviation addObject:Units];
                    
                    //[AttributeSpecified release];
                    //[AttributeName release];
                    
                    // only get here if select is the attribute type
                    selectcount=0;
                    for (SMXMLElement *AttributeDataOption in [AttributeDataEntry childrenNamed:@"AttributeDataOption"])
                    {
                        NSString *AttributeOptionName = [AttributeDataOption attributeNamed:@"Name"];
                        NSString *AttributeOptionID   = [AttributeDataOption attributeNamed:@"ID"];
                        [self.AttributeDataChoices addObject:AttributeOptionName];
                        [self.AttributeDataChoicesIDs addObject:AttributeOptionID];
                        selectcount++;
                        ////NSLog(@"    attributeoption: name=%@, id=%@",AttributeOptionName,AttributeOptionID);
                        ////NSLog(@"(1)attributedatachoudecount=%d",[AttributeDataChoices count]);
                        
                        //[AttributeOptionName release];
                        //[AttributeOptionID release];
                    }
                    if(selectcount !=0)
                    {
                        NSString *foo = [NSString stringWithFormat:@"%d",selectcount];
                        [self.AttributeDataChoiceCount addObject:foo];
                    }
                }
                ////NSLog(@"attributecount=%d",attributecount);
                NSString *foo = [NSString stringWithFormat:@"%d",attributecount];
                [self.OrganismNumberOfAttributes addObject:foo];
                /////[foo release];
                attributecount=0;
            }
        }
        ////NSLog(@"organismcount=%d",organismcount);
        ////NSLog(@"(2)attributedatachoudecount=%d",[AttributeDataChoices count]);
    }
    
    [self SetOrganismAttributeCount];
    
    ////[self DumpAttributeData];
    ////return;
    
    // 5.site characteristics
    attributecount = 0;
    ////NSLog(@"Site characteristics======================");
    for (SMXMLElement *SiteCharacteristicsData in [TheVisit childrenNamed:@"SiteCharacteristicsData"])
    {
        for (SMXMLElement *SiteCharacteristicsDataEntry in [SiteCharacteristicsData childrenNamed:@"SiteCharacteristicsDataEntry"])
        {
            sitecount++;
            // attribute data
            for (SMXMLElement *AttributeData in [SiteCharacteristicsDataEntry childrenNamed:@"AttributeData"])
            {
                for (SMXMLElement *AttributeDataEntry in [AttributeData childrenNamed:@"AttributeDataEntry"])
                {
                    attributecount++;
                    NSString     *AttributeSpecified = [AttributeDataEntry attributeNamed:@"HowSpecified"];
                    NSString     *AttributeName      = [AttributeDataEntry attributeNamed:@"Name"];
                    NSString     *UnitID             = [AttributeDataEntry attributeNamed:@"UnitID"];
                    NSString     *Units              = [AttributeDataEntry attributeNamed:@"Units"];
                    if([Units length] == 0) Units    = @"";
                    if([UnitID length] == 0) UnitID  = @"";
                    NSString     *AttributeTypeID    = [AttributeDataEntry attributeNamed:@"AttributeTypeID"];
                    ////NSLog(@"    attribute: specified=%@,name=%@,id=%@",AttributeSpecified,AttributeName,AttributeID);
                    
                    [self.AttributeDataName addObject:AttributeName];
                    [self.AttributeDataTypeIDs addObject:AttributeTypeID];
                    if([AttributeSpecified isEqualToString:@"Date"])
                    {
                        [self.AttributeDataType addObject:@"Entered"];
                    }
                    else if([AttributeSpecified isEqualToString:@"String"])
                    {
                        [self.AttributeDataType addObject:@"Entered"];
                    }
                    else
                    {
                        [self.AttributeDataType addObject:AttributeSpecified];
                    }
                    [self.AttributeDataTypeModifier addObject:AttributeSpecified];
                    [self.UnitIDs addObject:UnitID];
                    [self.UnitAbbreviation addObject:Units];
                    
                    // only get here if select is the attribute type
                    selectcount=0;
                    for (SMXMLElement *AttributeDataOption in [AttributeDataEntry childrenNamed:@"AttributeDataOption"])
                    {
                        NSString *AttributeOptionName = [AttributeDataOption attributeNamed:@"Name"];
                        NSString *AttributeOptionID   = [AttributeDataOption attributeNamed:@"ID"];
                        
                        selectcount++;
                        [self.AttributeDataChoices addObject:AttributeOptionName];
                        [self.AttributeDataChoicesIDs addObject:AttributeOptionID];
                        ////NSLog(@"    attributeoption: name=%@, id=%@",AttributeOptionName,AttributeOptionID);
                    }
                    
                    if(selectcount !=0)
                    {
                        NSString *foo = [NSString stringWithFormat:@"%d",selectcount];
                        [self.AttributeDataChoiceCount addObject:foo];
                    }
                }
                ////NSLog(@"attributecount=%d",attributecount);
                attributecount=0;
            }
        }
        ////NSLog(@"sitecount=%d",sitecount);
    }
}



- (void)cancelURLConnection:(NSTimer*) timer
{
    /*****
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                    message:@"Network timeout!"
                                                   delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    sleep(100);
    *****/
    [self.theConnection cancel];
}

-(NSString *)GetXMLPath
{    
    NSString        *ProjectXMLFile;
	NSString        *ApplicationsPath;
	NSArray         *DirectoryPaths;
    
    [self ReadOptionsFromFile];
    DirectoryPaths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath = [DirectoryPaths objectAtIndex:0];
    ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
    ProjectXMLFile   = [ApplicationsPath stringByAppendingPathComponent:XMLPROJECTSFILE];
    
    return ProjectXMLFile;
}

#undef OLDBEHAVIOR
////#define OLDBEHAVIOR

-(void)GetXMLFromServer:(NSString *)TheFileName
{
    [self ReadOptionsFromFile];
    
    ServerMode             = DOWNLOADMODE;
    
    NSString *TheOperation = [[NSString alloc] initWithFormat:@"GetProjectsAndForms"];
    
    NSString *uname=[[NSString alloc] initWithFormat:@"%@",[self GetUserName]];
	
	NSString *sname=[[NSString alloc] initWithFormat:@"%@",[self GetServerName]];
	
	NSString *pword=[[NSString alloc] initWithFormat:@"%@",[self GetUserPassword]];
    
#ifdef OLDBEHAVIOR
    ConnectionType         = OLDLOGIN;
    sname = @"ibis-test.nrel.colostate.edu";
    uname = @"lkc";
    pword = @"spurge";
#endif
	
	NSString *post =
	[[NSString alloc] initWithFormat:@"Login=%@&Password=%@&Operation=%@",uname,pword,TheOperation];
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *url = [NSString stringWithFormat:@"http:%@/cwis438/WebServices/AddGODMData_iOS.php",sname];
    ////NSLog(@"url:%@",url);
    //NSString *url = [NSString stringWithFormat:@"http:%@/cwis438/WebServices/AddGODMData_lkc.php",sname];
    //NSString *url = [NSString stringWithFormat:@"http:%@/cwis438/WebServices/AddGODMData.php",sname];
    //NSString *url = [NSString stringWithFormat:@"http:%@/data_user/lkc/AddGODMData.php",sname];
    
    ////NSLog(@"GOING TO %@",url);
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] init];
    
    [theRequest setURL:[NSURL URLWithString:url]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Length"];
    [theRequest setTimeoutInterval:20];
    [theRequest setHTTPBody:postData];
    
	// this starts the networking activities.
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    // timeout
    theTimer = [NSTimer scheduledTimerWithTimeInterval:75.0 target:self selector:@selector(cancelURLConnection:) userInfo:nil repeats:NO];
	
	if( theConnection )
	{
		self.WebData = [NSMutableData data];
	}
	else
	{
		////NSLog(@"the connection failed here");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"Network timeout!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[self.WebData setLength: 0];
    //NSLog(@"MODEL: didReveiveResponse");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.WebData appendData:data];
    //NSLog(@"MODEL: didReceiveData");
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	////[WebData release];
    //NSLog(@"MODEL: didFailWithError");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                    message:@"Server network error."
                                                   delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [self SetUploadError:true];
}

//
// this method does the work of
// 1. setting up the JSON dictionary
// 2. saving the access token
// 3. saving the refresh token
//
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // declarations
    id              jsonResponseData;
    NSData          *JsonResponseData;
    id              JsonResponse;
    NSDictionary    *JsonResponseDictionary;
    NSString        *SValue;
    NSString        *SMessage;
    NSRange         range;
    
    [self SetBadNetworkConnection:false];
    switch(ConnectionType)
    {
        case GENREFRESHTOKEN:
            jsonResponseData        = [NSJSONSerialization JSONObjectWithData:self.WebData options:kNilOptions error:nil];
            //NSLog(@"jsonResponseData: %@",jsonResponseData);
            
            // the response is returned as a dictionary
            self.JSONDictionary     = [[NSMutableDictionary alloc]init];
            self.JSONDictionary     = (NSMutableDictionary *)jsonResponseData;
            
            SValue                  = [jsonResponseData valueForKeyPath:@"error"];
            SMessage                = [jsonResponseData valueForKeyPath:@"error_description"];
            SValue                  = [SValue lowercaseString];
            
            range                   = [SValue  rangeOfString: @"error" options: NSCaseInsensitiveSearch];
            if (range.location >= 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:SMessage
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                [self SetBadNetworkConnection:true];
            }
            else
            {
                [self SetSavedAccessToken:[JSONDictionary objectForKey:@"access_token"]];
                [self SetAccessToken:[self GetSavedAccessToken]];
            
                [self SetSavedExpires:[JSONDictionary objectForKey:@"expires"]];
                [self SetExpires:[self GetSavedExpires]];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"genrefreshtoken" object:nil];
            break;
            
        case UPLOADOBSERVATION:
            jsonResponseData        = [NSJSONSerialization JSONObjectWithData:self.WebData options:kNilOptions error:nil];
            //NSLog(@"jsonResponseData: %@",jsonResponseData);
            
            // the response is returned as a dictionary
            self.JSONDictionary     = [[NSMutableDictionary alloc]init];
            self.JSONDictionary     = (NSMutableDictionary *)jsonResponseData;
            
            SValue                  = [jsonResponseData valueForKeyPath:@"status"];
            SMessage                = [jsonResponseData valueForKeyPath:@"message"];
            SValue                  = [SValue lowercaseString];
            
            range                   = [SValue  rangeOfString: @"failed" options: NSCaseInsensitiveSearch];
            if (range.location == NSNotFound)
            {
                // we're okay so soldier on
                //NSLog(@"connectionDidFinishloading: UPLOADOBSERVATION");
            }
            else
            {
                // problem so show the message
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:SMessage
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                [self SetBadNetworkConnection:true];
                [self SetUploadError:true];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLConnectionDidFinish" object:nil];
            break;
            
        case OLDLOGIN:
            [self connectionDidFinishLoadingOLD:connection];
            break;
            
        case GETACCESSTOKEN:
            jsonResponseData        = [NSJSONSerialization JSONObjectWithData:self.WebData options:kNilOptions error:nil];
            
            // the response is returned as a dictionary
            self.JSONDictionary     = [[NSMutableDictionary alloc]init];
            self.JSONDictionary     = (NSMutableDictionary *)jsonResponseData;
            
            SValue                  = [jsonResponseData valueForKeyPath:@"error"];
            SMessage                = [jsonResponseData valueForKeyPath:@"error_description"];
            SValue                  = [SValue lowercaseString];
            
            range                   = [SValue  rangeOfString: @"error" options: NSCaseInsensitiveSearch];
            if (range.location >= 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:SMessage
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                [self SetBadNetworkConnection:true];
            }
            else
            {
                [self SetSavedAccessToken:[JSONDictionary objectForKey:@"access_token"]];
                [self SetAccessToken:[self GetSavedAccessToken]];
                [self SetSavedRefreshToken:[JSONDictionary objectForKey:@"refresh_token"]];
                [self SetRefreshToken:[self GetSavedRefreshToken]];
                [self SetSavedExpires:[JSONDictionary objectForKey:@"expires"]];
                [self SetExpires:[self GetSavedExpires]];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"genaccesstoken" object:nil];
            break;
            
        case GETPROJECTSANDFORMS:
            JsonResponseData                = [NSData dataWithData:self.WebData];
            JsonResponse                    = [NSJSONSerialization JSONObjectWithData:JsonResponseData options:kNilOptions error:nil];
            
            //NSLog(@"response: %@",JsonResponse);
            
            SValue                  = [jsonResponseData valueForKeyPath:@"error"];
            SMessage                = [jsonResponseData valueForKeyPath:@"error_description"];
            SValue                  = [SValue lowercaseString];
            
            range                   = [SValue  rangeOfString: @"error" options: NSCaseInsensitiveSearch];
            if (range.location >= 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:SMessage
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                [self SetBadNetworkConnection:true];
            }
            else
            {
                [self SetJSONObject:JsonResponse];
                [self JSONToXML];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getprojectsandforms" object:nil];
            break;
            
        case GETUSERPROFILE:
            JsonResponseData                = [NSData dataWithData:self.WebData];
            JsonResponse                    = [NSJSONSerialization JSONObjectWithData:JsonResponseData options:kNilOptions error:nil];
            
            if([JsonResponse isKindOfClass:[NSDictionary class]])
            {
                JsonResponseDictionary      = JsonResponse;
                SValue                      = [JsonResponseDictionary valueForKeyPath:@"status"];
                SMessage                    = [JsonResponseDictionary valueForKeyPath:@"message"];
                SValue                      = [SValue lowercaseString];
                
                if(!([SValue isEqualToString:@"success"]))
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                    message:SMessage
                                                                   delegate:nil cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                    [alert show];
                }
                else
                {
                    // get the user name
                    NSString *uname         = [JsonResponseDictionary valueForKeyPath:@"data.Login"];
                    //[self ReadOptionsFromFile];
                    [self SetUserName:uname];
                    /////[self WriteOptionsToFile];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getuserprofile" object:nil];
            }
            break;
    }
}

-(void)connectionDidFinishLoadingOLD:(NSURLConnection *)connection
{
    Boolean ServerIssue   = false;        // assume no prob
	self.loginStatus = [[NSString alloc] initWithBytes: [self.WebData mutableBytes] length:[self.WebData length] encoding:NSASCIIStringEncoding];
    [self SetUploadError:false];
    
    NSLog(@"Loginstatus = %@",self.loginStatus);
    
    if(ServerMode == UPLOADMODE)
    {
        self.loginStatus = [self.loginStatus lowercaseString];
        if(!([self.loginStatus rangeOfString:@"failure"].location == NSNotFound))
        {
            ServerIssue = true;
            [self SetUploadError:true];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"Unable to upload the observation at this time.  This appears to be a networking issue.  Try again later.  The observation will remain on the device until it is uploaded successfully."
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        
        //
        // post notification that the upload is done
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLConnectionDidFinish" object:nil];
        [self SetUploadRunning:false];
        ////NSLog(@"MODEL: connectiondidfinish");
    }
    else
    {
        if(!([self.loginStatus rangeOfString:@"Sorry"].location == NSNotFound))
        {
            ServerIssue = true;
        }
        
        //
        // check for all the possible server error returns
        //
        if(ServerIssue)
        {
            [self SetServerError:true];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"parsecomplete" object:self];
            
            // bad login
            if(!([self.loginStatus rangeOfString:@"login and password are not"].location==NSNotFound))
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                            message:@"server login error"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
                [alert show];
            }
            // bad operation
            if(!([self.loginStatus rangeOfString:@"unknown operation"].location == NSNotFound))
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:@"contact leeway software design.  Unknown operation: this should not happen: error:104"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
            // data error (1)
            if(!([self.loginStatus rangeOfString:@"found instead of the"].location == NSNotFound))
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:@"contact citsci.org webmaster for data element error"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
            // data error (2)
            if(!([self.loginStatus rangeOfString:@"unknown datum"].location == NSNotFound))
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:@"contact citsci.org webmaster for 'unknown' data error"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
            // form error
            if(!([self.loginStatus rangeOfString:@"could not find the specified form"].location == NSNotFound))
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:@"data sheet not found. contact the citsci webmaster"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
            // contribution error
            if(!([self.loginStatus rangeOfString:@"this user does not"].location == NSNotFound))
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                                message:@"this user does not have permission to contribute"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }
        else
        {
            [self SetServerError:false];

            [self SetXMLServerString:self.loginStatus];
            
            [self WriteXMLAllFiles:self.loginStatus];
        
            ////[loginStatus release];
        
            ////[WebData release];
        }
    }
}

-(void)SetXMLServerString:(NSString *)TheString
{
    self.XMLServerString = [NSString stringWithFormat:@"%@",TheString];
}
-(NSString *)GetXMLServerString
{
    return self.XMLServerString;
}

-(void)SetServerError:(Boolean)TheValue
{
    ServerError=TheValue;
}
-(Boolean)GetServerError
{
    return ServerError;
}

#pragma -
#pragma - mark Upload File
-(void)GenCurrentXMLFile
{
    [self ReadOptionsFromFile];
    //
    // write the appropriate file
    //
    NSFileManager   *filemgr;
	NSString        *ApplicationsFile;
    NSString        *CurrentXMLName;
    NSString        *TheComment;
    NSString        *LocalVisitName;
    NSString        *VisitsDirectory;
    NSString        *TheDate;
    NSString        *ObservationStartDate;
    NSString        *TheLat;
    NSString        *TheLon;
    NSString        *TheAcc;
    NSString        *TheAlt;
    NSString        *LocalAuthorityFirstName;
    NSString        *LocalAuthorityLastName;
    NSString        *LocalAuthorityID;
	NSString        *ApplicationsPath;
	NSString        *tempstring;
    NSString        *LocalProjectID;
    NSString        *LocalFormID;
	NSString        *line;
    NSString        *cr;
    NSString        *tick;
    NSString        *tab;
    NSString        *opentag;
    NSString        *slash;
    NSString        *closetag;
    NSString        *thefield;
    NSString        *theValue;
    NSString        *theID;
    NSString        *theName;
    NSString        *ObservationTime;
	NSArray         *DirectoryPaths;
	NSData          *tempdata;
    Boolean         LocalDebug=false;
    Boolean         DoAuthority;
    NSDate          *TheEndDate;
    NSDate          *TheStartDate;
    int             TheIndexOffset;
    int             NumberOfAttributes;
    int             NumberOfOrganisms;
    int             LocalAttributeIndex = 0;
    int             UnitIDIndex;
    int             adci                = 0;
    int             ChoiceCount         = 0;
    int             StartPoint          = 0;
    int             EndPoint            = 0;
	
	filemgr = [NSFileManager defaultManager];
    
    //
    // the first 6 items of the attribute data value array (AttributeDataValue)
    // are populated (in this order) with:
    // 1. date
    // 2. the name of the file
    // 3. lat
    // 4. lon
    // 5. altitude
    // 6. accuracy
    //
    ////[self DumpAttributeDataValues];
    DoAuthority         = [self GetAuthorityCount]>0;
    TheDate             = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:0]];
    ObservationStartDate= [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:1]];
	CurrentXMLName      = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:2]];
    LocalVisitName      = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:2]];
    TheComment          = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:3]];
    TheLat              = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:4]];
    TheLon              = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:5]];
    TheAlt              = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:6]];
    TheAcc              = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:7]];
    if(DoAuthority)
    {
        LocalAuthorityFirstName  = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:8]];
        LocalAuthorityLastName   = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:9]];
        LocalAuthorityID         = [[NSString alloc]initWithFormat:@"%@",[self GetCurrentAttributeDataValueAtIndex:10]];
    }
    VisitsDirectory     = [[NSString alloc]initWithFormat:VISITSPATH];
    LocalProjectID      = [self GetCurrentProjectID];
    LocalFormID         = [self GetCurrentFormID];
    TheIndexOffset      = ATTRIBUTEINDEXOFFSET;
    NumberOfAttributes  = [self GetCurrentAttributeChoiceCount];
    line                = [[NSString alloc]init];
    tempstring          = [[NSString alloc]init];
    slash               = [[NSString alloc]init];
    CurrentXMLName      = [CurrentXMLName stringByAppendingString:XMLEXTENSION];
    TheEndDate          = [NSDate date];
    UnitIDIndex         = 0;
    
    // convert TheDate from NSString to NSDate in TheStartDate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    ////[dateFormatter setDateFormat:@"dd-MM-yyyy"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    // voila!
    TheStartDate = [dateFormatter dateFromString:ObservationStartDate];
    
    // calculate the observation time
    NSTimeInterval interval = [TheEndDate timeIntervalSinceDate:TheStartDate];
    ObservationTime = [[NSString alloc]initWithFormat:@"%2f",interval/60];
    
	// 1. create the directory for this application in the Docs directory
	DirectoryPaths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	ApplicationsPath = [DirectoryPaths objectAtIndex:0];
    ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:[self GetUserName]];
    ApplicationsPath = [ApplicationsPath stringByAppendingPathComponent:VisitsDirectory];
    ApplicationsFile = [ApplicationsPath stringByAppendingPathComponent:CurrentXMLName];
    
    [filemgr createDirectoryAtPath:ApplicationsPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    // 2. remove the old file if it exists
    [filemgr removeItemAtPath:ApplicationsFile error:nil];
	
	if (![filemgr fileExistsAtPath:ApplicationsPath])
	{
		[filemgr createDirectoryAtPath:ApplicationsPath
		   withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	// 3. create the XML file if it doesn't exist
	NSFileHandle *file;
	
	if (![filemgr fileExistsAtPath:ApplicationsFile])
	{
		if(LocalDebug) NSLog(@"create the file here 4");
		
		[filemgr createFileAtPath:ApplicationsFile contents:nil attributes:nil];
		file = [NSFileHandle fileHandleForWritingAtPath:ApplicationsFile];
		if (file == nil)
		{
			if(LocalDebug) NSLog(@"failed to open file GenCurrentXMLFile");
            slash       = [[NSString alloc]initWithFormat:@"/"];
		}
		else
		{
            //
            // all set, write the xml file here.  Start with the header stuff
            // followed by the attributes
            //
            
            // xml version line
            cr          = [[NSString alloc]initWithFormat:@"\n"];
            tick        = [[NSString alloc]initWithFormat:@"'"];
            tab         = [[NSString alloc]initWithFormat:@"    "];
            opentag     = [[NSString alloc]initWithFormat:@"<"];
            slash       = [[NSString alloc]initWithFormat:@"/"];
            closetag    = [[NSString alloc]initWithFormat:@">"];
			line        = [[NSString alloc]initWithFormat:@"<?xml version=\'1.0\' ?>"];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // GODMData tag
            LocalFormID = [self FixXML:LocalFormID];
            line        = [[NSString alloc]initWithFormat:@"%@GODMData FormId=%@%@%@%@",opentag,tick,LocalFormID,tick,closetag];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // Project tag (tab 1)
            LocalProjectID = [self FixXML:LocalProjectID];
            line        = [[NSString alloc]initWithFormat:@"%@<Project ID=%@%@%@%@",tab,tick,LocalProjectID,tick,@">"];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // Name and value tag (tab 2)
            LocalVisitName = [self FixXML:LocalVisitName];
            line        = [[NSString alloc]initWithFormat:@"%@%@<Name Value=%@%@%@%@",tab,tab,tick,LocalVisitName,tick,@"/>"];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            // no no longer adding the Name section
            ////[file writeData:tempdata];
            
            // Area - open it name and lat/lon (2 tabs) and predefined location
            line        = [[NSString alloc]initWithFormat:@"%@%@%@Area",tab,tab,opentag];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            NSString *areafield;
            
            if([self GetPredefinedLocationMode])
            {
                // write out the predefined location name
                areafield   = [[NSString alloc]initWithFormat:@"%@",[self GetSelectedPredefinedName]];
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@AreaName=%@%@%@",tab,tab,tab,tab,tick,areafield,tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // location ID
                areafield   = [[NSString alloc]initWithFormat:@"%@",[self GetSelectedPredefinedID]];
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@AreaID=%@%@%@",tab,tab,tab,tab,tick,areafield,tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // area lon,lat,coordinate systemid, and accuracy not used here so set to
                // ''
                // area lon
                TheLon      = @"";
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@X=%@%@%@",tab,tab,tab,tab,tick,TheLon,tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // area lat
                TheLat      = @"";
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@Y=%@%@%@",tab,tab,tab,tab,tick,TheLat,tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // coordinate system
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@CoordinateSystemID=%@%@%@",tab,tab,tab,tab,tick,@"",tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // area accuracy
                TheAcc      = @"";
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@Accuracy=%@%@%@",tab,tab,tab,tab,tick,TheAcc,tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
            }
            else
            {
                // predefined values nit set so make the ""
                // write out the predefined location name
                areafield   = LocalVisitName;
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@AreaName=%@%@%@",tab,tab,tab,tab,tick,areafield,tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // location ID
                areafield   = @"";
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@AreaID=%@%@%@",tab,tab,tab,tab,tick,areafield,tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                // area lon
                TheLon      = [self FixXML:TheLon];
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@X=%@%@%@",tab,tab,tab,tab,tick,TheLon,tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // area lat
                TheLat      = [self FixXML:TheLat];
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@Y=%@%@%@",tab,tab,tab,tab,tick,TheLat,tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // coordinate system
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@CoordinateSystemID=%@%@%@",tab,tab,tab,tab,tick,@"1",tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // area accuracy
                TheAcc      = [self FixXML:TheAcc];
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@Accuracy=%@%@%@",tab,tab,tab,tab,tick,TheAcc,tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
            }
            
            // close the area
            line        = [[NSString alloc]initWithFormat:@"%@%@%@",tab,tab,closetag];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // Visit open tag 2 tabs
            line        = [[NSString alloc]initWithFormat:@"%@%@%@Visit Date=%@%@%@%@",tab,tab,opentag,tick,TheDate,tick,closetag];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // authority (open 3 tabs) - if necessary
            if(DoAuthority)
            {
                line        = [[NSString alloc]initWithFormat:@"%@%@%@<Authority>",tab,tab,tab];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // authority option (4 tabs)
                LocalAuthorityFirstName = [self FixXML:LocalAuthorityFirstName];
                LocalAuthorityLastName  = [self FixXML:LocalAuthorityLastName];
                LocalAuthorityID        = [self FixXML:LocalAuthorityID];
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@<AuthorityOption Value=%@%@ %@%@ ID='%@%@/>",tab,tab,tab,tab,tick,LocalAuthorityFirstName,LocalAuthorityLastName,tick,LocalAuthorityID,tick];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // authority close (3 tabs)
                line        = [[NSString alloc]initWithFormat:@"%@%@%@</Authority>",tab,tab,tab];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
            }
            
            // recorder open (3 tabs)
            line        = [[NSString alloc]initWithFormat:@"%@%@%@<Recorder>",tab,tab,tab];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // recorder option (4 tabs)
            line        = [[NSString alloc]initWithFormat:@"%@%@%@%@<RecorderOption Value=%@%@%@/>",tab,tab,tab,tab,tick,[self GetUserName],tick];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // recorder close (3 tabs)
            line        = [[NSString alloc]initWithFormat:@"%@%@%@</Recorder>",tab,tab,tab];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // time of visit sibling of organism data (3 tabs)
            line        = [[NSString alloc]initWithFormat:@"%@%@%@%@Time Value=%@%@%@%@%@",tab,tab,tab,opentag,tick,ObservationTime,tick,slash,closetag];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // visit comment (3 tabs)
            TheComment  = [self FixXML:TheComment];
            line        = [[NSString alloc]initWithFormat:@"%@%@%@%@VisitComment Value=%@%@%@%@%@",tab,tab,tab,opentag,tick,TheComment,tick,slash,closetag];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            //
            // for each organism write each attribute and the attribute value
            //
            NumberOfOrganisms   = (int)[self.OrganismDataName count];
            LocalAttributeIndex = 0;
            for(int i=0; i<NumberOfOrganisms; i++)
            {
                // OrganismData open tag 3 tabs
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@OrganismData%@",tab,tab,tab,opentag,closetag];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // OrganismDataOption open tag 4 tabs
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@%@OrganismDataOption ",tab,tab,tab,tab,opentag];
                tempstring  = [NSString stringWithFormat:@"%@",line];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                tempstring          = [self.OrganismNumberOfAttributes objectAtIndex:i];
                NumberOfAttributes  = (int)[tempstring integerValue];
                
                // organsim name
                NSString            *thefield = [[NSString alloc]initWithFormat:@"%@",[self.OrganismDataName objectAtIndex:i]];
                thefield            = [self FixXML:thefield];
                line                = [[NSString alloc]initWithFormat:@"OrganismName=%@%@%@/%@",tick,thefield,tick,closetag];
                tempstring          = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata            = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // OrganismDataOption open tag 4 tabs
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@%@OrganismDataOption ",tab,tab,tab,tab,opentag];
                tempstring  = [NSString stringWithFormat:@"%@",line];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // organsim id
                thefield            = [[NSString alloc]initWithFormat:@"%@",[self.OrganismDataIDs objectAtIndex:i]];
                thefield            = [self FixXML:thefield];
                line                = [[NSString alloc]initWithFormat:@"OrganismInfoID=%@%@%@/%@",tick,thefield,tick,closetag];
                tempstring          = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata            = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // OrganismDataOption open tag 4 tabs
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@%@OrganismDataOption ",tab,tab,tab,tab,opentag];
                tempstring  = [NSString stringWithFormat:@"%@",line];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // organsim comment
                thefield            = [[NSString alloc]initWithFormat:@"%@",[self.OrganismDataComment objectAtIndex:i]];
                thefield            = [self FixXML:thefield];
                line                = [[NSString alloc]initWithFormat:@"OrganismComment=%@%@%@/%@",tick,thefield,tick,closetag];
                tempstring          = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata            = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // open attribute data 5 tabs
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@%@%@AttributeData%@",tab,tab,tab,tab,tab,opentag,closetag];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                ////NSLog(@"attributedatatype:%@",self.AttributeDataType);
                // now for the attributes
                ChoiceCount             = 0;
                StartPoint              = 0;
                EndPoint                = 0;
                adci                    = 0;
                for(int j=0; j<NumberOfAttributes; j++)
                {
                    // AttributeDataOptionID 6 tabs
                    theID       = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataTypeIDs objectAtIndex:LocalAttributeIndex]];
                    theValue    = [[NSString alloc]initWithFormat:@"%@",[self.UnitIDs objectAtIndex:j]];
                    theName     = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataName objectAtIndex:j]];
                    thefield    = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataValue objectAtIndex:LocalAttributeIndex+TheIndexOffset]];
                    
                    // if this attributedataoption is not "entered", map the
                    // selection to the associated id
                    if(![[self.AttributeDataType objectAtIndex:j] isEqualToString:@"Entered"])
                    {
                        ChoiceCount     = (int)[[self.AttributeDataChoiceCount objectAtIndex:adci] integerValue];
                        EndPoint        = StartPoint + ChoiceCount;
                        for(int xx=0; xx<ChoiceCount;xx++)
                        {
                            if([thefield isEqualToString:[self.AttributeDataChoices objectAtIndex:xx+StartPoint]])
                            {
                                thefield = [self.AttributeDataChoicesIDs objectAtIndex:xx+StartPoint];
                                break;
                            }
                        }
                        StartPoint      = EndPoint;
                        adci++;
                    }
                    
                    if([thefield isEqualToString:@"-- Select --"])
                    {
                        thefield = @"";
                    }
                    
                    if([theValue isEqualToString:@"NULL"])
                    {
                        theValue = @"";
                    }
                    thefield    = [self FixXML:thefield];
                    theID       = [self FixXML:theID];
                    theValue    = [self FixXML:theValue];
                    
                    // write out the 6 tabs
                    line        = [[NSString alloc]initWithFormat:@"%@%@%@%@%@%@",tab,tab,tab,tab,tab,tab];
                    tempdata    = [line dataUsingEncoding:NSUTF8StringEncoding];
                    [file writeData:tempdata];
                    
                    // write out the AttributeDataOption line
                    line        = [[NSString alloc]initWithFormat:@"<AttributeDataOption Name=%@%@%@ Value=%@%@%@ UnitID=%@%@%@ AttributeDataTypeID=%@%@%@%@%@",tick,theName,tick,tick,thefield,tick,tick,theValue,tick,tick,theID,tick,slash,closetag];
                    tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                    tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                    [file writeData:tempdata];
                    
                    // bump the attrbute index
                    LocalAttributeIndex++;
                }
                
                // close attribute data 5 tabs
                line        = [[NSString alloc]initWithFormat:@"%@%@%@%@%@%@/AttributeData%@",tab,tab,tab,tab,tab,opentag,closetag];
                tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // close organsimdata  3 tabsclose tag
                line                = nil;
                line                = [[NSString alloc]initWithFormat:@"%@%@%@</OrganismData>",tab,tab,tab];
                tempstring          = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata            = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
            }
            
            UnitIDIndex             = NumberOfAttributes;
            int AttributeStart      = UnitIDIndex;
            //
            // SiteCharacteristics if there are any attributes left over, they
            // are site characteristic attributes
            //
            NumberOfAttributes      = (int)([self.AttributeDataValue count] - LocalAttributeIndex) - TheIndexOffset;
            ////NumberOfAttributes--;
            if(NumberOfAttributes > 0)
            {
                // sitecharacteristics 3 tabs
                line                = nil;
                line                = [[NSString alloc]initWithFormat:@"%@%@%@<SiteCharacteristics>",tab,tab,tab];
                tempstring          = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata            = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
                
                // write out each attributes
                for(int i=0;i<NumberOfAttributes;i++)
                {
                    // AttributeDataOptionID 6 tabs
                    theID       = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataTypeIDs objectAtIndex:LocalAttributeIndex]];
                    thefield    = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataValue objectAtIndex:LocalAttributeIndex+TheIndexOffset]];
                    theValue    = [[NSString alloc]initWithFormat:@"%@",[self.UnitIDs objectAtIndex:UnitIDIndex]];
                    theName     = [[NSString alloc]initWithFormat:@"%@",[self.AttributeDataName objectAtIndex:UnitIDIndex]];
                    UnitIDIndex++;
                    // if this attributedataoption is not "entered", map the
                    // selection to the associated id
                    if(![[self.AttributeDataType objectAtIndex:AttributeStart] isEqualToString:@"Entered"])
                    {
                        ChoiceCount     = (int)[[self.AttributeDataChoiceCount objectAtIndex:adci++] integerValue];
                        EndPoint        = StartPoint + ChoiceCount;
                        for(int xx=0; xx<ChoiceCount;xx++)
                        {
                            if([thefield isEqualToString:[self.AttributeDataChoices objectAtIndex:xx+StartPoint]])
                            {
                                thefield = [self.AttributeDataChoicesIDs objectAtIndex:xx+StartPoint];
                                break;
                            }
                        }
                        StartPoint      = EndPoint;
                    }
                    AttributeStart++;
                    if([thefield isEqualToString:@"-- Select --"])
                    {
                        thefield = @"";
                    }
                    
                    if([theValue isEqualToString:@"NULL"])
                    {
                        theValue = @"";
                    }
                    
                    thefield    = [self FixXML:thefield];
                    theID       = [self FixXML:theID];
                    theName     = [self FixXML:theName];
                    theValue    = [self FixXML:theValue];
                    
                    // write out the 6 tabs
                    line        = [[NSString alloc]initWithFormat:@"%@%@%@%@%@%@",tab,tab,tab,tab,tab,tab];
                    tempdata    = [line dataUsingEncoding:NSUTF8StringEncoding];
                    [file writeData:tempdata];
                    
                    // write out the AttributeDataOption line
                    ////line        = [[NSString alloc]initWithFormat:@"<AttributeDataOption Value=%@%@%@ AttributeDataTypeID=%@%@%@%@%@",tick,thefield,tick,tick,theID,tick,slash,closetag];
                    line        = [[NSString alloc]initWithFormat:@"<AttributeDataOption Name=%@%@%@ Value=%@%@%@ UnitID=%@%@%@ AttributeDataTypeID=%@%@%@%@%@",tick,theName,tick,tick,thefield,tick,tick,theValue,tick,tick,theID,tick,slash,closetag];
                    tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
                    tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                    [file writeData:tempdata];
                    
                    // bump the attrbute index
                    LocalAttributeIndex++;
                }
                
                // close sitecharacteristics
                line                = nil;
                line                = [[NSString alloc]initWithFormat:@"%@%@%@</SiteCharacteristics>",tab,tab,tab];
                tempstring          = [NSString stringWithFormat:@"%@%@",line,cr];
                tempdata            = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
                [file writeData:tempdata];
            }
            
            // close the visit
            line        = [[NSString alloc]initWithFormat:@"%@%@%@/Visit%@",tab,tab,opentag,closetag];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // close the area
            line        = [[NSString alloc]initWithFormat:@"%@%@%@/Area%@",tab,tab,opentag,closetag];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            // close the project
            line        = [[NSString alloc]initWithFormat:@"%@%@/Project%@",tab,opentag,closetag];
            tempstring  = [NSString stringWithFormat:@"%@%@",line,cr];
            tempdata    = [tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
            
            //
            // close out the common factors of the
            // kml file (Dcument and kml)
            //
            // GODMData tag
            line=[[NSString alloc]initWithFormat:@"</GODMData>"];
            tempstring=[NSString stringWithFormat:@"%@%@",line,cr];
            tempdata=[tempstring dataUsingEncoding:NSUTF8StringEncoding];
            [file writeData:tempdata];
            
			[file closeFile];
            
            [self SetVisitName:CurrentXMLName];
		}
	}
    
    LocalDebug=false;
}
-(void)RemCurrentXMLFile:(NSString *)TheFile
{
    
}

#pragma mark -
#pragma mark Open Authentication methods


//
// GenAccessToken acquires the data in JSON
// The HTTP request in this example mirrors
// the request used in the iOS version of
// CitSciMobile.  In this example, build an HTTP
// request sending the following POST parameters:
// 1. code as the get string "code"
// 2. client id as the get string client_id
// 3. client secret as the get string client_secret
// 4. redirect url as the get string redirect_uri
// 5. grant type as the get string grant_type
//
// Finally, create the HTTP request to TOKEN_URL
// to generate the access and refresh tokens.  These
// values are set in connectionDidFinishLoading
//
-(void)GenAccessToken
{
    // set the connection type
    ConnectionType                      = GETACCESSTOKEN;
    // collect the code from the UIWebView and method webViewDidFinishLoad
    NSString        *TheCode            = [self GetCode];
    
    // required variables to build the request
    NSString            *boundary       = @"---------------------------7d7119bb0c50";
    NSString            *nl             = @"\r\n";
    NSMutableData       *body           = [NSMutableData data];
    NSString            *contentType    = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSString            *url            = TOKEN_URL;
    NSMutableURLRequest *theRequest     = [[NSMutableURLRequest alloc] init];
    [theRequest setURL:[NSURL URLWithString:url]];
    [theRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //
    // create the POST parameters
    //
    // code parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"code\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[TheCode dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    // client id parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"client_id\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[CLIENT_ID dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    // client secret parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"client_secret\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[CLIENT_SECRET dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    // redirect uri parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"redirect_uri\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[REDIRECT_URI dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    // grant type parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"grant_type\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[GRANT_TYPE dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form - ***LKC*** TRY THIS
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set up the request
    [theRequest setHTTPBody:body];
    
    [theRequest setHTTPMethod:@"POST"];
    
    // set a time out
    theTimer = [NSTimer scheduledTimerWithTimeInterval:75.0 target:self selector:@selector(cancelURLConnection:) userInfo:nil repeats:NO];
    
    // call the getaccesstoken URL
    theConnection                       = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection)
    {
        self.WebData                    = [NSMutableData data];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"Network timeout!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

-(void)GetUserProfile
{
    // set the connection type
    ConnectionType                      = GETUSERPROFILE;
    // collect the code from the UIWebView and method webViewDidFinishLoad
    NSString        *TheToken           = [self GetAccessToken];
    
    // required variables to build the request
    NSString            *boundary       = @"---------------------------7d7119bb0c50";
    NSString            *nl             = @"\r\n";
    NSMutableData       *body           = [NSMutableData data];
    NSString            *contentType    = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSString            *url            = PROFILE_URL;
    NSMutableURLRequest *theRequest     = [[NSMutableURLRequest alloc] init];
    [theRequest setURL:[NSURL URLWithString:url]];
    [theRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //
    // create the POST parameters
    //
    // token parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Token\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[TheToken dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set up the request
    [theRequest setHTTPBody:body];
    
    [theRequest setHTTPMethod:@"POST"];
    
    // set a time out
    theTimer = [NSTimer scheduledTimerWithTimeInterval:75.0 target:self selector:@selector(cancelURLConnection:) userInfo:nil repeats:NO];
    
    // call the getaccesstoken URL
    theConnection                       = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection)
    {
        self.WebData                    = [NSMutableData data];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"Network timeout!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

-(void)GenRefreshToken
{
    // set the connection type
    ConnectionType                      = GENREFRESHTOKEN;
    
    // required variables to build the request
    NSString            *boundary       = @"---------------------------7d7119bb0c50";
    NSString            *nl             = @"\r\n";
    NSMutableData       *body           = [NSMutableData data];
    NSString            *contentType    = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSString            *url            = REFRESH_TOKEN_URL;
    NSString            *refresh_token  = [[NSString alloc]initWithString:[self GetRefreshToken]];
    NSMutableURLRequest *theRequest     = [[NSMutableURLRequest alloc] init];
    [theRequest setURL:[NSURL URLWithString:url]];
    [theRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //
    // create the POST parameters
    //
    // code parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"code\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[self GetCode] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"code: %@",[self GetCode]);
    
    // client id parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"client_id\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[CLIENT_ID dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"clientid: %@",CLIENT_ID);
    
    // client secret parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"client_secret\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[CLIENT_SECRET dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"client secret: %@",CLIENT_SECRET);
    
    // redirect uri parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"redirect_uri\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[REDIRECT_URI dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"redirect uri: %@",REDIRECT_URI);
    
    // refresh token
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"refresh_token\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[refresh_token dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"refresh token: %@",refresh_token);
    
    // grant type parameter
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary,nl] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"grant_type\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[REFRESH_TYPE dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[nl dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"grant type: %@",GRANT_TYPE);
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set up the request
    [theRequest setHTTPBody:body];
    
    [theRequest setHTTPMethod:@"POST"];
    
    // set a time out
    theTimer = [NSTimer scheduledTimerWithTimeInterval:75.0 target:self selector:@selector(cancelURLConnection:) userInfo:nil repeats:NO];
    
    // call the getaccesstoken URL
    theConnection                       = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection)
    {
        self.WebData                    = [NSMutableData data];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"Network timeout!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

-(void)GetProjectsAndForms
{
    NSString        *LocalExpires   = [self GetExpires];
    NSTimeInterval  RightNow        = NSDate.date.timeIntervalSince1970;
    double          TheLimit        = [LocalExpires doubleValue];

    if(RightNow >= TheLimit)
    {
        //NSLog(@"genrefreshtoken here");
        //NSLog(@"RightNow: %f",RightNow);
        //NSLog(@"TheLimit: %f",TheLimit);
        // get a new token via refresh token
        // and wait for it to complete
        [self GenRefreshToken];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoGetProjectsAndForms) name:@"genrefreshtoken" object:nil];
    }
    else
    {
        [self DoGetProjectsAndForms];
    }
}

-(void)DoGetProjectsAndForms
{
    if([self GetBadNetworkConection]) return;
    if([self GetWriteOptionsFile])
    {
        [self WriteOptionsToFile];
        [self ReadOptionsFromFile];
    }
    ConnectionType                  = GETPROJECTSANDFORMS;
    NSString *LocalAccessToken      = [self GetAccessToken];
    NSString *url                   = PROJECTSANDDATASHEETS;
    url                             = [url stringByAppendingString:LocalAccessToken];
    url                             = [url stringByAppendingString:@"&Mode=JSON"];
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] init];
    
    [theRequest setURL:[NSURL URLWithString:url]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Length"];
    [theRequest setTimeoutInterval:20];
    
    // this starts the networking activities.
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    // timeout
    theTimer = [NSTimer scheduledTimerWithTimeInterval:75.0 target:self selector:@selector(cancelURLConnection:) userInfo:nil repeats:NO];
	
	if( theConnection )
	{
		self.WebData = [NSMutableData data];
	}
	else
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CitSciMobile"
                                                        message:@"Network timeout in get projects!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
	}
}

//
// access token setters
//
-(void)SetAccessToken:(NSString *)TheToken
{
    self.AccessToken = TheToken;
}
-(void)SetSavedAccessToken:(NSString *)TheToken
{
    self.SavedAccessToken = TheToken;
}

-(void)SetRefreshToken:(NSString *)TheToken
{
    self.RefreshToken = TheToken;
}
-(void)SetSavedRefreshToken:(NSString *)TheToken
{
    self.SavedRefreshToken = TheToken;
}

-(void)SetExpires:(NSString *)TheTime
{
    self.Expires = TheTime;
}
-(void)SetSavedExpires:(NSString *)TheTime
{
    self.SavedExpires = TheTime;
}

-(void)SetCode:(NSString *)TheCode
{
    self.Code = TheCode;
}

//
// access tooken getters
//
-(NSString *)GetAccessToken
{
    return self.AccessToken;
}
-(NSString *)GetSavedAccessToken
{
    return self.SavedAccessToken;
}

-(NSString *)GetRefreshToken
{
    return self.RefreshToken;
}
-(NSString *)GetSavedRefreshToken
{
    return self.SavedRefreshToken;
}

-(NSString *)GetExpires
{
    return self.Expires;
}
-(NSString *)GetSavedExpires
{
    return self.SavedExpires;
}

-(NSString *)GetCode
{
    return self.Code;
}

// behavior flow
-(NSString *)GetFirstInvocationRev21
{
    return self.FirstInvocationRev21;
}
-(void)SetFirstInvocationRev21:(NSString *)TheValue
{
    self.FirstInvocationRev21 = TheValue;
}

-(Boolean)GetDataFromServerStatus
{
    return DataFromServerStatus;
}
-(void)SetDataFromServerStatus:(Boolean)TheStatus
{
    DataFromServerStatus = TheStatus;
}

#pragma mark -
#pragma mark GetUIViewCOntroller methods
-(UIViewController*)GetObservationView
{
    return TheObservationView;
}
-(UIViewController*)GetAddObservationView
{
    return TheAddObservationView;
}
-(UIViewController*)GetAddAuthorityView
{
    return TheAddAuthorityView;
}
-(UIViewController*)GetAddObservationSelectView
{
    return TheAddObservationSelectView;
}
-(UIViewController*)GetAddObservationSelectDoneView
{
    return TheAddObservationSelectDoneView;
}
-(UIViewController*)GetAddObservationEnterView
{
    return TheAddObservationEnterView;
}
-(UIViewController*)GetAddObservationEnterDoneView
{
    return TheAddObservationEnterDoneView;
}
-(UIViewController*)GetCameraView
{
    return TheCameraView;
}
-(UIViewController*)GetProjectsView
{
    return TheProjectsView;
}
-(UIViewController*)GetUploadView
{
    return TheUploadView;
}
-(UIViewController*)GetUserDataView
{
    return TheUserDataView;
}


@end
