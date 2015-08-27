//
//  UploadVitalSignBloodSugarService.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UploadVitalSignBloodSugarService.h"

@interface UploadVitalSignBloodSugarService()

@property NSString          *elementName;
@property NSString          *userId;
@property NSString          *userPassword;
@property NSString          *timeType;
@property NSString          *bloodSugarValue;
@property HMUser            *hmUser;
@property NSString          *fillTime;
@property NSMutableString   *messageBuffer;
@property id                target;
@property SEL               action;

@end

@implementation UploadVitalSignBloodSugarService

- (id) init
{
    self = [super init];
    if (self) {
        self.messageBuffer = [[NSMutableString alloc]init];
    }
    return self;
}

- (id) initWithUserId:(NSString*)userId
         UserPassword:(NSString*)userPassword
             TimeType:(NSString*)timeType
      BloodSugarValue:(NSString*)bloodSugarValue
               Target:(id)target
               Action:(SEL)action
{
    self = [self init];
    
    if(self) {
        self.userId          = userId;
        self.userPassword    = userPassword;
        self.timeType        = timeType;
        self.bloodSugarValue = bloodSugarValue;
        self.target          = target;
        self.action          = action;
        self.elementName     = @"UploadVitalSignResult";
    }
    
    return self;
}

- (id) initWithHMUser:(HMUser*)user
                 HMBG:(HMBG*)hmbg
               Target:(id)target
               Action:(SEL)action
{
    self = [self initWithUserId:user.uid UserPassword:user.pwd TimeType:hmbg.type BloodSugarValue:[hmbg.val description] Target:target Action:action];
    
    if(self) {
        self.hmUser = user;
        self.hmbg   = hmbg;
        
        self.fillTime = [PMOConstants getFormatFullDateWithDate:[NSDate dateWithTimeIntervalSinceReferenceDate:[hmbg.fillTime longValue]]];
    }
    
    return self;
}

- (NSString*) getCurrentDateTimeString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    return [PMOConstants getFormatFullDateWithDate:[NSDate date]];
}

- (void) start
{
    NSString* vsData = [[NSString alloc] initWithFormat:@"{\"DeviceID\":\"\", \"GatewayID\":\"\", \"MemberID\":\"%@\", \"VitalSign\":[{\"Type\":\"BG\", \"MTime\":\"%@\", \"Mark\":\"%@\", \"InputType\":\"Manual\", \"Values\":[%@]}]}", self.userId, (self.fillTime?self.fillTime:[self getCurrentDateTimeString]), self.timeType, self.bloodSugarValue];
    
    NSString* xmlData = [super createXMLWithNameSpace:WEB_SERVICE_NAMESPACE RootElement:@"UploadVitalSign" Data:[NSDictionary dictionaryWithObjectsAndKeys:self.userId, @"ID", self.userPassword, @"Pwd", vsData, @"VSData", nil]];
    
    Reachability* reachability = [Reachability reachabilityWithHostname:WEB_SERVICE_HOST];
    if ([reachability isReachable]) {
        [self requestWebServiceWithURI:@"/MessageHubWS/VitalSign.asmx" Host:WEB_SERVICE_HOST SoapAction:[NSString stringWithFormat:@"%@%@", WEB_SERVICE_NAMESPACE, @"UploadVitalSign"] XMLData:xmlData ConnectionCallback:nil];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:[self.messageBuffer dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSString* value;
    value = [json valueForKey:@"Message"];
    if ([RESPONSE_SUCCESS_CODE isEqualToString:value] || [@"A11" isEqualToString:value])
    {
        self.error = false;
    } else
    {
        self.error = true;
    }
    self.message = [PMOConstants getErrorMessageWithErrorCode:value];
    
    [super responseToControllerWithTarget:self.target Action:self.action Object:self];
}

@end
