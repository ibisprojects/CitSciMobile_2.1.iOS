//
//  Model.h
//  Surveyor
//
//  Created by lee casuto on 2/19/11.
//  Copyright 2011 leeway software design. All rights reserved.
//
// This is a singleton class for managing the application
// global variables (and permits initialization)

#import <Foundation/Foundation.h>
#import "ProjectNode.h"
#import "FormNode.h"

// defines for file names and types
#define OPTIONSFILE             @"LeewayCitSciMobileOptions.txt"
#define XMLPROJECTSFILE         @"LeewayXMLProjects.txt"
#define XMLSEPARATOR            @"====="
#define XMLFORMSPATH            @"AllForms"
#define VISITSPATH              @"MyVisits"
#define FORMSPATH               @"AllForms"
#define SERVERDATAPATH          @"AllData"
#define XMLEXTENSION            @".xml"
#define JPGEXTENSION            @".jpg"
#define JPGSDIRNAME             @""
#define VISITTYPE               0
#define FORMTYPE                1
#define NOTYETSET               @"not yet set"
#define NOWSET                  @"now set"
#define NOTYETSETNUM            @"0.0"
#define BIOBLITZORGANISM        @"-99"

// defines for debugging
#define CONTRIVEDDATA           0

// defines for reachability
#define REACHVIAWIFI            0
#define REACHVIAWWAN            1
#define NOTREACHABLE            2

// default values for screen sizes, delays and accuracy
#define kScreenWidth            320.0f
#define kScreenHeight           400.0f
#define kDELAY                  20.0f
#define ACCURACY                10.0f

// control values
#define LOGINNOTSET             1
#define LOGINSET                2
#define COLLECTORGANISM         0
#define COLLECTSITE             1
#define COLLECTTREATMENT        2
#define UPLOADMODE              0
#define DOWNLOADMODE            1

// parsing switches
#define PROJECTMODE             0
#define FORMMODE                1
#define AMPERSANDCHAR           @"&"
#define AMPERSANDSTRING         @"&amp;"
#define LESSTHANCHAR            @"<"
#define LESSTHANSTRING          @"&lt;"
#define GREATERTHANCHAR         @">"
#define GREATERTHANSTRING       @"&gt;"
#define TICKCHAR                @"'"
#define TICKSTRING              @"&apos;"
#define QUOTECHAR               @"\""
#define QUOTESTRING             @"&quot;"
#define PERCENTCHAR             @"%"
#define PERCENTSTRING           @"&#37;"
#define PLUSCHAR                @"+"
#define PLUSSTRING              @"&#43;"
#define COLONCHAR               @":"
#define COLONSTRING             @"&#58;"
#define QUESTIONCHAR            @"?"
#define QUESTIONSTRING          @"&#63;"
#define RPARENCHAR              @")"
#define RPARENSTRING            @"&#41;"
#define LPARENCHAR              @"("
#define LPARENSTRING            @"&#40;"
#define SLASHCHAR               @"/"
#define SLASHSTRING             @"&#47;"
#define EQUALCHAR               @"="
#define EQUALSTRING             @"&#61;"
#define COMMACHAR               @","
#define COMMASTRING             @"&#44;"
#define SPACESTRING             @" "
#define EMPTYSTRING             @""

// Attribute indexes
#define MYDATE                  0
#define OBSDATE                 1
#define OBSNAME                 2
#define OBSCOMMENT              3
#define LATVALUE                4
#define LONVALUE                5
#define ALTVALUE                6
#define ACCVALUE                7
#define AUTHORITYSTART          8
#define ATTRIBUTEINDEXOFFSET    11

// observation edit states
#define CONSISTENT              0
#define OBSERVATIONOLD          1
#define DATASHEETMISSING        2
#define DATASHEETEXTRAFIELDS    3
#define OBSERVATIONEXTRAFIELDS  4

// camera modes
#define CAMERAOBSERVATION       0
#define CAMERAORGANISM          1
#define CAMERAFROMSELECT        0
#define CAMERAFROMENTER         1

// open authentication values
#define CLIENT_ID               @"SE8vUpYjPZ0TFi4q7aeP"
#define CLIENT_SECRET           @"d0HaKsG7ubvtce0Z4jhQ"
#define REDIRECT_URI            @"https://ibis-test1.nrel.colostate.edu/app.php/oAuth/testRedirectURL"
#define GRANT_TYPE              @"authorization_code"
#define REFRESH_TYPE            @"refresh_token"
#define TOKEN_URL               @"https://ibis-test1.nrel.colostate.edu/app.php/oAuth/getAccessToken"
#define REFRESH_TOKEN_URL       @"https://ibis-test1.nrel.colostate.edu/app.php/oAuth/refreshAccessToken"
#define OAUTH_URL               @"https://ibis-test1.nrel.colostate.edu/app.php/oAuth/Auth"
#define PROFILE_URL             @"https://ibis-test1.nrel.colostate.edu/app.php/API/GetProfile"
#define PROJECTLIST_URL         @"https://ibis-test1.nrel.colostate.edu/app.php/API/GetProjectList?Token="
#define DATASHEETS_URL          @"https://ibis-test1.nrel.colostate.edu/app.php/API/GetDatasheets?Token="
#define PROJECTSANDDATASHEETS   @"https://ibis-test1.nrel.colostate.edu/app.php/API/GetProjectsAndDatasheets?Token="
#define UPLOAD_URL              @"https://ibis-test1.nrel.colostate.edu/app.php/API/UploadData"
#define OAUTH_SCOPE             @"user"
#define GETACCESSTOKEN          0
#define GETPROJECTS             1
#define GETFORMS                2
#define GETUSERPROFILE          3
#define GETPROJECTSANDFORMS     4
#define OLDLOGIN                5
#define GENREFRESHTOKEN         6
#define UPLOADOBSERVATION       7

// defines for file sizes
#define LOGINSTRINGLIMIT        100000

@interface Model : NSObject <NSXMLParserDelegate>
{
	// reachability variables
    int                 TheNetwork;                     // network state
    
    // view state variables
    int                 CurrentViewValue;               // for coverpage
    int                 NextViewValue;                  // for camera
    int                 TheViewAfterPicklist;           // view for picklist to display
    Boolean             FirstSelectSet;                 // for select state
    int                 FirstSelectAttributeChoiceIndex;// index of first select
    Boolean             CallSetNextAttribute;           // for the first announce page
    int                 TheViewType;                    // for the announce page
    Boolean             NewOrganism;                    // for the announce
    Boolean             OrganismCameraCalled;           // back from camera
    NSString            *OrganismCameraComment;         // save the comment
    int                 OrganismCameraParent;           // type of information savec
    int                 OrganismCameraSelectRow;        // the selected row
    NSString            *OrganismCameraSelectValue;     // the selected choice
    NSString            *OrganismCameraEnterValue;      // the typed value
    Boolean             GoToAuthenticate;               // controls the flow
    int                 InvalidTokenMessageCount;       // used to display messages
    
    // core location variables
    double              TheDelay;                       // how long to wait for GPS
    double              TheAccuracy;                    // in meters
    Boolean             Acquired;                       // found it flag
    Boolean             BestEffort;                     // how to acquire
    Boolean             LocationSearchDone;             // stop the deamon
    NSString            *LatValue;                      // thses are obtained here
    NSString            *LonValue;                      // and accessed from AddObservation.m
    NSDate              *DateValue;
    BOOL                ShowErrorMessage;
    double              TheAltitude;
    
    // visits variables
    int                 VisitIndex;                     // index into the list
    int                 VisitMapIndex;                  // index into the map list
    NSMutableArray      *SelectedVisitMaps;             // list of maps
    NSString            *TheVisitLat;                   // values returned
    NSString            *TheVisitLon;                   // from the GPS
    NSString            *TheVisitAcc;
    NSString            *TheVisitAlt;
    NSString            *VisitComment;                  // comment for this visit
    NSString            *CurrentVisitName;              // so it can be removed
    NSMutableArray      *VisitNames;                    // these are used
    NSMutableArray      *VisitFiles;                    // to keep track
    NSMutableArray      *VisitDescriptions;             // and all associated
    NSMutableArray      *VisitDates;                    // values and
    NSMutableArray      *VisitLats;                     // variables
    NSMutableArray      *VisitLons;
    NSMutableArray      *VisitAccs;
    NSMutableArray      *VisitAlts;
    NSMutableArray      *VisitPointCount;
    NSMutableArray      *VisitUploads;                  // has visit been uploaded?
    NSMutableArray      *UploadAllErrors;               // track upload errors
    NSMutableArray      *PictureList;                   // list of pictures to send
    Boolean             UploadError;                    // set if files are not uploaded
    Boolean             UploadRunning;                  // used to block and wait
    
    // utility variables
    NSMutableArray      *AllSystemNames;                // places to upload visits
    NSString            *UserName;                      // the next three are used
	NSString            *ServerName;                    // to access the system where
	NSString            *Password;                      // visits are uploaded
    NSString            *FullPathName;                  // holds various file names
    int                 CollectionType;                 // organism, site characteristic or treatment
    int                 LoginState;                     // are we logged in?
    Boolean             DidGoBackground;                // cover page or not?
    int                 SystemIndex;                    // index into the system name array
    Boolean             PreviousMode;                   // previous buton tapped
    Boolean             GoingForward;                   // continue from previous
    int                 CameraMode;                     // either observation or organism
    NSString            *loginStatus;                   // don't lose this value
    Boolean             BadNetworkConnection;           // error from service
    Boolean             BioblitzDisplay;                // display bioblitz attribute
    
    // forms variables
    NSString            *CurrentFormName;               // name of active form
    NSString            *CurrentFormID;                 // ID of active form
    NSMutableArray      *FormNames;                     // names of all forms for this project
    NSMutableArray      *FormIDs;                       // ID for the corresponding form
    FormNode            *CurrentFormNode;               // which form are we on?
    FormNode            *FormHead;                      // head of current form list
    
    // project variables
    NSString            *CurrentProjectName;            // name of active project
    NSString            *CurrentProjectID;              // ID of active project
    NSMutableArray      *ProjectNames;                  // names of each project for the user
    NSMutableArray      *ProjectIDs;                    // associated ID for the project name
    ProjectNode         *CurrentProjectNode;            // current location in project data
    //ProjectNode         *ProjectHead;                   // head of the project list
    Boolean             ProjectDataAvailable;           // is it there
    
    // arrays to hold attribute data variables
    NSMutableArray      *OrganismDataName;              // list of organism names
    NSMutableArray      *OrganismDataIDs;               // list of organism IDs
    NSMutableArray      *OrganismDataType;              // how organism is specified
    NSMutableArray      *OrganismDataComment;           // list of organism comments
    NSMutableArray      *OrganismPicklist;              // list of organism choices
    NSMutableArray      *OrganismNumberOfAttributes;    // number of attributes for each organism
    NSMutableArray      *AttributeDataName;             // list of attributes for the organisms
    NSMutableArray      *AttributeDataTypeIDs;          // list of attributes for the organisms
    NSMutableArray      *AttributeDataValue;            // list of attributes values for the organisms
    NSMutableArray      *AttributeDataSelectRow;        // the row for the select screen (previous value)
    NSMutableArray      *AttributeDataType;             // either defined, entered or select
    NSMutableArray      *AttributeDataTypeModifier;     // for Date and String types
    NSMutableArray      *AttributeDataChoiceCount;      // how mant attributes in this choice
    NSMutableArray      *AttributeDataChoices;          // the attributes
    NSMutableArray      *AttributeDataChoicesIDs;       // the attributes ID
    NSMutableArray      *UnitIDs;                       // Unit ID of the requested attribute
    NSMutableArray      *UnitsAbbreviation;             // shown on each screen
    NSMutableArray      *AuthorityFirstName;            // first name of authority
    NSMutableArray      *AuthorityLastName;             // last name
    NSMutableArray      *AuthorityID;                   // id in the data base
    NSMutableArray      *PredefinedLocationNames;       // from the XML
    NSMutableArray      *PredefineLocationIDs;          // from the XML
    NSString            *SelectedPredefinedName;        // the user sets this
    NSString            *SelectedPredefinedID;          // ditto
    Boolean             PredefinedLocationMode;         // for previous button
    int                 CurrentAttributeChoiceIndex;    // used to access the current attribute
    int                 CurrentOrganismIndex;           // which organism are we on
    int                 OrganismCount;                  // number of organisms
    int                 CurrentAttributeChoiceCountIndex;
    int                 CurrentAttributeChoiceCount;    // used as an index into the Choices array
    int                 CurrentAttributeDataChoicesIndex;
    int                 CurrentOrganismAttributeIndex;  // the current attribute number for this organism
    int                 OrganismAttributeCount;         // number of attributes before site attributes
    int                 CurrentAttributeNumber;         // track the attribute being collected
    NSString            *CurrentOrganismName;           // active organism name
    NSString            *CurrentOrganismComment;        // active organism comment
    NSString            *CurrentOrganismID;             // active organism ID
    NSString            *CurrentAttributeName;          // active attribute
    NSString            *CurrentAttributeValue;         // active attribute value
    NSString            *CurrentAttributeType;          // type of the current attribute
    NSString            *CurrentAttributeTypeModifier;  // for Date and String
    NSMutableArray      *CurrentAttributeChoices;       // list of attributes for this attribute name
    Boolean             LastAttribute;                  // key for "Done" views
    Boolean             AttributesSet;                  // first call to SetNextAttribute
    Boolean             AuthoritySet;                   // defines getting authority
    Boolean             KeepAuthoritySet;               // for picklist
    Boolean             AuthorityHasBeenSet;            // defines getting authority
    int                 SiteCharacteristicCount;        // number of site characteristics
    int                 AuthoritySelection;             // the row number selected
    NSString            *TranslatingDataSheetName;      // current data sheet being translated from JSON to XML
        
    // xml variables
    NSXMLParser         *xmlParser;                     // the parser
    NSInteger           depth;                          // current xml depth
    NSMutableString     *currentName;                   // current name
    NSString            *currentElement;                // and element
    NSMutableData       *WebData;                       // used to get projects from server
    NSURLConnection     *theConnection;                 // webservice communicator
    NSTimer             *theTimer;                      // how long to wait for the web
    NSString            *XMLServerString;               // what the server returned
    Boolean             ServerError;                    // there is or there is not
    NSMutableString     *xmlString;                     // from parsing example
    NSString            *ParsedAttributeValue;          // from JSON
    id                  JSONObject;                     // JSON returned by the server
    
    // UIViewControllers so they only get allocated once
    UIViewController   *TheObservationView;             // allocated in the model
    UIViewController   *TheAddObservationView;          // allocated in the model
    UIViewController   *TheAddAuthorityView;            // allocated in the model
    UIViewController   *TheAddObservationSelectView;    // allocated in the model
    UIViewController   *TheAddObservationSelectDoneView;// allocated in the model
    UIViewController   *TheAddObservationEnterView;     // allocated in the model
    UIViewController   *TheAddObservationEnterDoneView; // allocated in the model
    UIViewController   *TheCameraView;                  // allocated in the model
    UIViewController   *TheProjectsView;                // allocated in the model
    UIViewController   *TheUploadView;                  // allocated in the model
    UIViewController   *TheUserDataView;                // allocated in the model
    
    // open authentication
    NSArray            *UrlComponents;                  // returned by OAuth
    NSString           *Code;                           // static for now, but could change
    NSMutableDictionary*ParameterDictionary;            // save login information
    NSMutableDictionary*JSONDictionary;                 // save login information
    int                ConnectionType;                  // for connectionDidFinishLoading
    NSString           *AccessToken;                    // the token value
    NSString           *SavedAccessToken;               // the token value
    NSString           *RefreshToken;                   // ditto
    NSString           *SavedRefreshToken;              // ditto
    NSString           *Expires;                        // ditto
    NSString           *SavedExpires;                   // ditto
    NSString           *FirstInvocationRev21;           // behavior for revision 2.1
    Boolean            DataFromServerStatus;            // result of server activity
    Boolean            WriteOptionsFile;                // flag to decide if file should be written
    Boolean            AllDataFileStarted;              // flag to write the file
    
}

//
// variable declarations for the model
//
@property (nonatomic, retain) NSString                          *TheVisitLat;
@property (nonatomic, retain) NSString                          *TheVisitLon;
@property (nonatomic, retain) NSString                          *TheVisitAcc;
@property (nonatomic, retain) NSString                          *TheVisitAlt;
@property (nonatomic, retain) NSString                          *UserName;
@property (nonatomic, retain) NSString                          *VisitComment;
@property (nonatomic, retain) NSString                          *ServerName;
@property (nonatomic, retain) NSString                          *Password;
@property (nonatomic, retain) NSString                          *FullPathName;
@property (nonatomic, retain) NSString                          *CurrentFormName;
@property (nonatomic, retain) NSString                          *CurrentFormID;
@property (nonatomic, retain) NSString                          *CurrentProjectName;
@property (nonatomic, retain) NSString                          *CurrentProjectID;
@property (nonatomic, retain) NSString                          *loginStatus;
@property (nonatomic, retain) NSString                          *CurrentVisitName;
@property (nonatomic, retain) NSString                          *ParsedAttributeValue;
@property (nonatomic, retain) NSString                          *SelectedPredefinedName;
@property (nonatomic, retain) NSString                          *SelectedPredefinedID;
@property (nonatomic, retain) NSMutableArray                    *VisitNames;
@property (nonatomic, retain) NSMutableArray                    *VisitFiles;
@property (nonatomic, retain) NSMutableArray                    *VisitDescriptions;
@property (nonatomic, retain) NSMutableArray                    *VisitDates;
@property (nonatomic, retain) NSMutableArray                    *VisitLats;
@property (nonatomic, retain) NSMutableArray                    *VisitLons;
@property (nonatomic, retain) NSMutableArray                    *VisitAccs;
@property (nonatomic, retain) NSMutableArray                    *VisitAlts;
@property (nonatomic, retain) NSMutableArray                    *VisitPointCount;
@property (nonatomic, retain) NSMutableArray                    *VisitUpload;
@property (nonatomic, retain) NSMutableArray                    *PictureList;
@property (nonatomic, retain) NSMutableArray                    *AllSystemNames;
@property (nonatomic, retain) NSMutableArray                    *FormNames;
@property (nonatomic, retain) NSMutableArray                    *ProjectNames;
@property (nonatomic, retain) NSMutableArray                    *FormIDs;
@property (nonatomic, retain) NSMutableArray                    *ProjectIDs;
@property (nonatomic, retain) NSMutableArray                    *UploadAllErrors;
@property (nonatomic, retain) NSMutableArray                    *PredefinedLocationNames;
@property (nonatomic, retain) NSMutableArray                    *PredefinedLocationIDs;
@property (nonatomic, retain) NSMutableData                     *WebData;
@property (nonatomic, strong) NSURLConnection                   *theConnection;
@property (nonatomic, retain) NSTimer                           *theTimer;
@property (nonatomic, retain) NSString                          *XMLServerString;
@property (nonatomic, retain) NSMutableArray                    *OrganismDataName;
@property (nonatomic, retain) NSMutableArray                    *OrganismDataType;
@property (nonatomic, retain) NSMutableArray                    *OrganismPicklist;
@property (nonatomic, retain) NSMutableArray                    *OrganismDataIDs;
@property (nonatomic, retain) NSMutableArray                    *OrganismDataComment;
@property (nonatomic, retain) NSMutableArray                    *OrganismNumberOfAttributes;
@property (nonatomic, retain) NSMutableArray                    *AttributeDataName;
@property (nonatomic, retain) NSMutableArray                    *AttributeDataTypeIDs;
@property (nonatomic, retain) NSMutableArray                    *AttributeDataValue;
@property (nonatomic, retain) NSMutableArray                    *AttributeDataSelectRow;
@property (nonatomic, retain) NSMutableArray                    *AttributeDataType;
@property (nonatomic, retain) NSMutableArray                    *AttributeDataTypeModifier;
@property (nonatomic, retain) NSMutableArray                    *AttributeDataChoiceCount;
@property (nonatomic, retain) NSMutableArray                    *AttributeDataChoices;
@property (nonatomic, retain) NSMutableArray                    *AttributeDataChoicesIDs;
@property (nonatomic, retain) NSMutableArray                    *UnitIDs;
@property (nonatomic, retain) NSMutableArray                    *UnitAbbreviation;
@property (nonatomic, retain) NSMutableArray                    *AuthorityFirstName;
@property (nonatomic, retain) NSMutableArray                    *AuthorityLastName;
@property (nonatomic, retain) NSMutableArray                    *AuthorityID;
@property (nonatomic, retain) NSString                          *CurrentOrganismName;
@property (nonatomic, retain) NSString                          *CurrentOrganismID;
@property (nonatomic, retain) NSString                          *CurrentAttributeName;
@property (nonatomic, retain) NSString                          *CurrentAttributeValue;
@property (nonatomic, retain) NSString                          *CurrentAttributeType;
@property (nonatomic, retain) NSString                          *CurrentAttributeTypeModifier;
@property (nonatomic, retain) NSString                          *OrganismCameraComment;
@property (nonatomic, retain) NSString                          *OrganismCameraSelectValue;
@property (nonatomic, retain) NSString                          *OrganismCameraEnterValue;
@property (nonatomic, retain) NSMutableArray                    *CurrentAttributeChoices;
@property (strong, nonatomic) NSArray                           *UrlComponents;
@property (strong, nonatomic) NSString                          *Code;
@property (strong, nonatomic) NSMutableDictionary               *ParameterDictionary;
@property (strong, nonatomic) NSMutableDictionary               *JSONDictionary;
@property (strong, nonatomic) NSString                          *AccessToken;
@property (strong, nonatomic) NSString                          *RefreshToken;
@property (strong, nonatomic) NSString                          *Expires;
@property (strong, nonatomic) NSString                          *SavedAccessToken;
@property (strong, nonatomic) NSString                          *SavedRefreshToken;
@property (strong, nonatomic) NSString                          *SavedExpires;
@property (strong, nonatomic) NSString                          *FirstInvocationRev21;
@property (strong, nonatomic) NSString                          *TranslatingDatasheetName;
@property (strong, nonatomic) id                                JSONObject;

//
// LocateMe Interface variables
//
@property (nonatomic, copy) NSString            *LatValue;
@property (nonatomic, copy) NSString            *LonValue;
@property (nonatomic, copy) NSDate              *DateValue;
//
// End of LocateMe Interface variables
//

// singleton declaration
+(Model *)SharedModel;

//
// reachability functions
//
-(void)SetNetworkStatus:(int)TheValue;
-(int)GetNetworkStatus;

//
// core location functions
//
-(double)GetDelay;
-(void)SetDelay:(double)TheDelay;
-(double)GetAccuracy;
-(void)SetAccuracy:(double)TheAccuracy;
-(Boolean)GetAcquired;
-(Boolean)GetBestEffort;
-(void)SetAcquired:(Boolean)TheValue;
-(void)SetBestEffort:(Boolean)TheValue;
-(void)SetLocationSearch:(Boolean)TheValue;
-(Boolean)GetLocationSearch;
-(NSDate *)GetDateValue;
-(void)SetDateValue:(NSDate *)TheValue;
-(void)SetErrorMessage:(BOOL)YesNo;
-(BOOL)GetErrorMessage;
-(void)SetupLocationManager;
//
// end of LocateMe interface functions
//

//
// visits functions
//
-(void)ResetVisitsList;
-(NSString *)GetVisitMapName;
-(Boolean)GetNextVisitMap;
-(void)SetVisitLat:(NSString *)TheLat;
-(void)SetVisitLon:(NSString *)TheLon;
-(void)SetVisitAcc:(NSString *)TheAcc;
-(void)SetVisitAlt:(NSString *)TheAlt;
-(void)SetVisitName:(NSString *)TheName;
-(void)SetVisitDescription:(NSString *)TheDescription;
-(void)SetVisitDate:(NSDate *)TheDate;
-(void)SetVisitUpload:(BOOL)TheUploadValue;
-(void)SetVisitPointCount:(int)TheCount;
-(void)SetVisitFileName:(NSString *)TheName;
-(void)AddVisitLat:(NSString *)TheLat;
-(void)AddVisitLon:(NSString *)TheLon;
-(void)AddVisitAcc:(NSString *)TheAcc;
-(void)AddVisitAlt:(NSString *)TheAlt;
-(void)SetUploadError:(Boolean)TheError;
-(void)SetCurrentVisitName:(NSString *)TheName;
-(NSString *)GetCurrentVisitName;
-(Boolean)GetUploadError;
-(NSString *)GetVisitLat;
-(NSString *)GetVisitLatAtIndex:(int)TheIndex;
-(NSString *)GetVisitLon;
-(NSString *)GetVisitLonAtIndex:(int)TheIndex;
-(NSString *)GetVisitAcc;
-(NSString *)GetVisitAlt;
-(NSString *)GetVisitName;
-(NSString *)GetVisitNameAtIndex:(int)TheIndex;
-(NSString *)GetVisitFileNameAtIndex:(int)TheIndex;
-(NSString *)GetVisitDescription;
-(int)GetVisitPointCount;
-(Boolean)GetVisitUpload;
-(Boolean)GetNextVisitNode;
-(int)GetNumberOfVisits;
-(int)GetNumberOfVisitFiles;
-(void)WriteOptionsToFile;
-(void)ChangeUser;
-(void)ReadAllVisitFiles;
-(void)CleanVisits;
-(void)SetVisitComment:(NSString *)TheComment;
-(NSString *)GetVisitComment;
-(Boolean)DoesThisNameExist:(NSString *)TheName;
-(Boolean)IsThisNameLegal:(NSString *)TheName;
-(void)UploadVisit:(NSString *)TheVisit;
-(void)DoUploadVisit;
-(void)UploadObservation:(NSString *)TheObservation;
-(void)AddPicturesToRequest:(NSString *)TheVisit;

//
// utility functions
//
-(void)SetBadNetworkConnection:(Boolean)TheValue;
-(Boolean)GetBadNetworkConection;
-(void)SetUploadRunning:(Boolean)TheStatus;
-(Boolean)GetUploadRunning;
-(void)WriteInstrument:(NSString *)TheString : (Boolean)RemoveIt;
-(NSString *)FixXML:(NSString* )TheStringToFix;
-(NSString *)TranslateDefinition:(NSString* )TheStringToFix : (NSString *)ValueType;
-(NSString *)GetUserName;
-(NSString *)GetServerName;
-(NSString *)GetUserPassword;
-(Boolean)GetDidGoBackground;
-(void)SetUserName:(NSString *)TheName;
-(void)SetServerName:(int)TheNameNumber;
-(void)SetServerNameString:(NSString *)TheName;
-(void)SetUserPassword:(NSString *)TheName;
-(void)SetDidGoBackground:(Boolean)Value;
-(void)ReadOptionsFromFile;
-(void)RemFile:(NSString *)TheName;
-(void)RemVisitFile:(NSString *)TheName;
-(NSString *)GetSystemName;
-(void)ResetSystemNames;
-(void)SetCollectionType:(int)TheValue;
-(int)GetCollectionType;
-(NSString *)BuildFullPathFromName:(NSString *)TheName : (int)TheType;
-(NSString *)GetPicturePath;
-(void)SetNextView:(int)TheViewNumber;
-(int)GetNextView;
-(void)SetPreviousMode:(Boolean)TheValue;
-(void)SetCurrentValues;
-(void)SetFirstAttribute;
-(Boolean)GetPreviousMode;
-(void)SetGoingForward:(Boolean)TheValue;
-(Boolean)GetGoingForward;
-(void)SetFirstSelect:(Boolean)TheValue;
-(Boolean)GetFirstSelect;
-(void)CheckFirstSelect;
-(void)SetSelectIndex:(int)TheIndex;
-(int)GetSelectIndex;
-(void)SetViewType:(int)TheType;
-(int)GetViewType;
-(void)SetViewAfterPicklist:(int)TheViewNumber;
-(int)GetViewAfterPicklist;
-(void)SetCallNextAttribute:(Boolean)TheValue;
-(Boolean)GetCallNextAttribute;
-(void)SetIsNewOrganism:(Boolean)TheValue;
-(Boolean)GetIsNewOrganism;
-(void)SkipOrganism;
-(void)SetOrganismCameraCalled:(Boolean)TheValue;
-(Boolean)GetOrganismCameraCalled;
-(void)SetGoToAuthenticate:(Boolean)TheValue;
-(Boolean)GetGoToAuthenticate;
-(void)SetInvalidTokenMessageCount:(int)TheCount;
-(int)GetInvalidTokenMessageCount;
-(void)SetOrganismCameraComment:(NSString *)AComment;
-(NSString*)GetOrganismCameraComment;
-(void)SetOrganismCameraParent:(int)TheValue;
-(int)GetOrganismCameraParent;
-(void)SetOrganismCameraSelectRow:(int)TheValue;
-(int)GetOrganismCameraSelectRow;
-(void)SetOrganismCameraSelectValue:(NSString *)TheValue;
-(NSString *)GetOrganismCameraSelectValue;
-(void)SetOrganismCameraEnterValue:(NSString *)AValue;
-(NSString *)GetOrganismCameraEnterValue;
-(void)PopulateEmptyAttribute;
-(void)SetCameraMode:(int)TheMode;
-(int)GetCameraMode;
-(int)InconsistentEdit:(NSString *)ObservationName;
-(Boolean)ValidFloat:(NSString *)TheValue;
-(Boolean)ValidLat:(NSString *)TheValue;
-(Boolean)ValidLon:(NSString *)TheValue;
-(void)SetBioblitzDispaly:(Boolean)TheValue;
-(Boolean)GetBioblitzDisplay;

//
// form methods
//
-(void)SetCurrentFormName:(NSString *)TheName;
-(NSString *)GetCurrentFormName;
-(void)SetFormNames;
-(NSMutableArray *)GetFormNames;
-(NSMutableArray *)GetFormIDs;
-(void)SetCurrentFormID:(NSString *)TheID;
-(NSString *)GetCurrentFormID;

//
// project methods
//
-(void)SetCurrentProjectName:(NSString *)TheName;
-(NSString *)GetCurrentProjectName;
-(void)SetCurrentProjectID:(NSString *)TheID;
-(NSString *)GetCurrentProjectID;
-(void)SetProjectNames;
-(NSMutableArray *)GetProjectNames;
-(NSMutableArray *)GetProjectIDs;
-(Boolean)GetProjectDataFromServer;
-(void)SetProjectDataAvailable:(Boolean)TheValue;
-(Boolean)GetProjectDataAvailable;

//
// attribute, organism and sitecharacteristics methods
//
-(void)SetSiteCharacteristicsCount:(int)TheNumber;
-(int)GetSiteCharacteristicsCount;
-(void)SetAuthorityRowNumber:(int)TheRow;
-(int)GetAuthorityRowNumber;
-(void)DumpArraySizes;
-(void)DumpAttributeData;
-(void)DumpAttributeDataValues;
-(void)DumpAttributeDataChoiceCount;
-(void)DumpIndexes;
-(void)SetCurrentOrganismName;
-(void)SetCurrentOrganismAttributeIndex:(int)TheIndex;
-(int)GetCurrentOrganismAttributeIndex;
-(NSString *)GetCurrentOrganismName;
-(NSString *)GetOrganismNameAtIndex:(int)TheIndex;
-(NSString *)GetOrganismCommentAtIndex:(int)TheIndex;
-(void)ReplaceOrganismCommentAtIndex:(NSString *)TheComment : (int)TheIndex;
-(void)ReplaceOrganismDataNameAtIndex:(NSString *)TheName : (int)TheIndex;
-(void)ReplaceOrganismDataIDsAtIndex:(NSString *)TheID : (int)TheIndex;
-(NSString *)GetOrganismDataTypeAtIndex:(int)TheIndex;
-(void)SetOrganismAttributeCount;
-(int)GetOrganismAttributeCount;
-(int)GetTotalAttributeCount;
-(int)GetCurrentOrganismAttributeCount;


-(void)SetCurrentOrganismID;
-(NSString *)GetCurrentOrganismID;
-(NSString *)GetOrganismIDAtIndex:(int)TheIndex;

-(void)SetOrganismNumberOfAttributes:(NSString *)TheValue;
-(int)GetOrganismNumberOfAttributes:(int)TheIndex;
-(int)GetOrganismCount;
-(void)SetCurrentOrganismIndex:(int)TheIndex;
-(int)GetCurrentOrganismIndex;
-(void)SetCurrentAttributeName;
-(NSString *)GetCurrentAttributeName;
-(void)SetCurrentAttributeValue:(NSString *)TheValue;
-(NSString *)GetCurrentAttributeValue;
-(NSString *)GetAttributeNameAtIndex:(int)TheIndex;
-(void)SetCurrentAttributeNumber:(int)TheNumber;
-(int)GetCurrentAttributeNumber;
-(NSString *)GetActiveAttributeString;
-(int)GetAttributeNumberForCurrentOrganism;
-(void)SetCurrentAttributeType;
-(void)SetCurrentAttributeTypeModifier;
-(NSString *)GetCurrentAttributeType;
-(NSString *)GetCurrentAttributeTypeModifier;
-(NSString *)GetAttributeDataTypeAtIndex:(int)TheIndex;
-(NSString *)GetAttributeDataTypeModifierAtIndex:(int)TheIndex;
-(void)SetCurrentAttributeChoiceCount;
-(int)GetCurrentAttributeChoiceCount;
-(void)SetCurrentAttributeChoices;
-(void)SetUnitIDs:(NSMutableArray *)TheIDs;
-(NSMutableArray *)GetUnitIDs;
-(void)SetUnitAbbreviation:(NSMutableArray *)TheUnits;
-(NSMutableArray *)GetUnitAbbreviation;
-(NSMutableArray *)GetCurrentAttributeChoices;
-(void)SetCurrentAttributeChoiceIndex:(int)TheIndex;
-(int)GetCurrentAttributeChoiceIndex;
-(void)SetCurrentAttributeDataChoicesIndex:(int)TheIndex;
-(int)GetCurrentAttributeDataChoicesIndex;
-(void)SetCurrentAttributeDataValue:(NSString *)TheValue;
-(void)ReplaceAttributeDataValueAtIndex:(int)TheIndex : (NSString *)NewValue;
-(void)ReplaceAttributeDataSelectRowAtIndex:(int)TheIndex : (NSString *) NewRow;
-(NSString *)GetCurrentAttributeDataValue;
-(NSString *)GetCurrentAttributeDataValueAtIndex:(int)TheIndex;
-(int)GetCurrentAttributeDataValueCount;
-(void)ClearCurrentAttributeDataValues;
-(void)SetAttributeDataSelectRow:(NSString *)TheRow;
-(int)GetAttributeDataSelectRowAtIndex:(int)TheIndex;
-(void)InitializeAttributes;
-(void)SetNextAttribute;
-(void)SetPreviousAttribute;
-(void)SetAttributesSet:(Boolean)TheValue;
-(Boolean)GetAttributesSet;
-(void)SetIsLast:(Boolean)TheValue;
-(Boolean)GetIsLast;
-(void)SetCurrentViewValue:(int)TheValue;
-(int)GetCurrentViewValue;
-(void)SetCurrentAttributeChoiceCountIndex:(int)TheIndex;
-(int)GetCurrentAttributeChoiceCountIndex;
-(void)ShowIndexes;
-(void)SetAuthoritySet:(Boolean)TheValue;
-(Boolean)GetAuthoritySet;
-(void)SetKeepAuthoritySet:(Boolean)TheValue;
-(Boolean)GetKeepAuthoritySet;
-(void)SetAuthorityHasBeenSet:(Boolean)TheValue;
-(Boolean)GetAuthorityHasBeenSet;
-(int)GetAuthorityCount;
-(NSMutableArray *)GetAuthorityFirstName;
-(NSMutableArray *)GetAuthorityLastName;
-(NSMutableArray *)GetAuthorityID;

-(void)SetPredefinedLocationNames:(NSMutableArray *)TheChoices;
-(void)SetPredefinedLocationIDs:(NSMutableArray *)TheChoices;
-(void)SetSelectedPredefinedID:(NSString *)TheSelection;
-(void)SetSelectedPredefinedName:(NSString *)TheSelection;
-(NSMutableArray *)GetPredefinedLocationNames;
-(NSMutableArray *)GetPredefinedLocationIDs;
-(NSString *)GetSelectedPredefinedName;
-(NSString *)GetSelectedPredefinedID;
-(Boolean)ParsePredefinedLocations;
-(void)SetPredefinedLocationMode:(Boolean)TheMode;
-(Boolean)GetPredefinedLocationMode;

-(NSMutableArray *)GetOrganismPicklistAtIndex:(int) TheIndex;

//
// XML methods
//
-(void)GetXMLFromServer:(NSString *)TheFileName;
-(void)SetXMLServerString:(NSString *)TheString;
-(NSString *)GetXMLServerString;
-(void)WriteXMLAllFiles:(NSString *)TheData;
-(NSString *)ReadXMLFile:(NSString *)TheFileName;
-(void)ParseXMLProject:(NSString *)TheFileName;
-(void)ParseXMLForm:(NSString *)TheFileName;
-(void)SetServerError:(Boolean)TheValue;
-(NSString *)GetXMLPath;
-(Boolean)GetServerError;
-(Boolean)DoesXMLExist;
-(void)GenCurrentXMLFile;
-(void)RemCurrentXMLFile:(NSString *)TheFile;
-(void)WriteXMLHeader:(id)TheObject;
-(void)WriteXMLPredefinedLocations:(id)TheObject : (int)ProjectIndex : (int)datasheet;
-(void)WriteXMLAuthority:(id)TheObject : (int)ProjectIndex;
-(void)WriteXMLOrganismData:(id)TheObject : (int)datasheet : (int) projnum : (int)numdatasheets :(int)numprojects;
-(void)WriteXMLSiteCharacteristics:(id)TheObject : (int)datasheet : (int) projnum : (int)numdatasheets : (int)numprojects;
-(void)ParseTheAttributes:(id)object :(NSString *)TheKey;
-(void)SetParsedAttributeValue:(NSString *)TheValue;
-(NSString *)GetParsedAttributeValue;

//
// ViewController methods
//
-(UIViewController*)GetObservationView;
-(UIViewController*)GetAddObservationView;
-(UIViewController*)GetAddAuthorityView;
-(UIViewController*)GetAddObservationSelectView;
-(UIViewController*)GetAddObservationSelectDoneView;
-(UIViewController*)GetAddObservationEnterView;
-(UIViewController*)GetAddObservationEnterDoneView;
-(UIViewController*)GetCameraView;
-(UIViewController*)GetProjectsView;
-(UIViewController*)GetUploadView;
-(UIViewController*)GetUserDataView;

//
// open authentication methods
//
-(void)GenAccessToken;
-(void)GenRefreshToken;
-(void)GetUserProfile;
-(void)GetProjectsAndForms;
-(void)DoGetProjectsAndForms;
-(Boolean)GetDataFromServerStatus;
-(void)SetDataFromServerStatus:(Boolean)TheStatus;

// token setters and getters
-(NSString *)GetAccessToken;
-(void)SetAccessToken:(NSString *)TheToken;
-(NSString *)GetSavedAccessToken;
-(void)SetSavedAccessToken:(NSString *)TheToken;
-(NSString *)GetRefreshToken;
-(void)SetRefreshToken:(NSString *)TheToken;
-(NSString *)GetSavedRefreshToken;
-(void)SetSavedRefreshToken:(NSString *)TheToken;
-(NSString *)GetExpires;
-(void)SetExpires:(NSString *)TheTime;
-(NSString *)GetSavedExpires;
-(void)SetSavedExpires:(NSString *)TheTime;
-(NSString *)GetCode;
-(void)SetCode:(NSString *)TheCode;

// flow behavior
-(NSString *)GetFirstInvocationRev21;
-(void)SetFirstInvocationRev21:(NSString *)TheValue;

// JSON methods
-(void)GetJSONFromServer;
-(void)JSONToXML;
-(void)BuildLoginStatus:(NSString *)TheString;
-(void)WriteLoginStatus;
-(void)FinishLoginStatus;
-(void)SetAllDataFileStarted:(Boolean)TheStatus;
-(Boolean)GetAllDataFileStarted;
-(Boolean)GetWriteOptionsFile;
-(void)SetWriteOptionsFile:(Boolean)TheFlag;
-(void)SetJSONObject:(id)TheObject;
-(id)GetJSONObject;
-(Boolean)IsNullAttribute:(id)TheObject;
-(void)SetTranslatingDataSheetName:(NSString *)TheName;
-(NSString *)GetTranslatingDataSheetName;


@end
