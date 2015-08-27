//
//  UploadVitalSignBloodPressureService.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UploadVitalSignBloodPressureService.h"

@interface UploadVitalSignBloodPressureService()

@property NSString          *elementName;
@property NSString          *userId;
@property NSString          *userPassword;
@property NSString          *bloodPressureValue1;
@property NSString          *bloodPressureValue2;
@property NSString          *bloodPressureValue3;
@property HMUser            *hmUser;
@property NSString          *fillTime;
@property NSMutableString   *messageBuffer;
@property id                target;
@property SEL               action;

@end

@implementation UploadVitalSignBloodPressureService

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
  BloodPressureValue1:(NSString*)bloodPressureValue1
  BloodPressureValue2:(NSString*)bloodPressureValue2
  BloodPressureValue3:(NSString*)bloodPressureValue3
               Target:(id)target
               Action:(SEL)action
{
    self = [self init];
    
    if(self) {
        self.userId              = userId;
        self.userPassword        = userPassword;
        self.bloodPressureValue1 = bloodPressureValue1;
        self.bloodPressureValue2 = bloodPressureValue2;
        self.bloodPressureValue3 = bloodPressureValue3;
        self.target              = target;
        self.action              = action;
        self.elementName         = @"UploadVitalSignResult";
    }
    
    return self;
}

- (id) initWithHMUser:(HMUser*)user
                 HMBP:(HMBP*)hmbp
               Target:(id)target
               Action:(SEL)action
{
    self = [self initWithUserId:user.uid UserPassword:user.pwd BloodPressureValue1:[hmbp.bph description] BloodPressureValue2:[hmbp.bpl description] BloodPressureValue3:[hmbp.pluse description] Target:target Action:action];
    
    if (self) {
        self.hmUser = user;
        self.hmbp   = hmbp;
        self.fillTime = [PMOConstants getFormatFullDateWithDate:[NSDate dateWithTimeIntervalSinceReferenceDate:[hmbp.fillTime longValue]]];
    }
    
    return self;
}

- (NSString*) getCurrentDateTimeString
{
    return [PMOConstants getFormatFullDateWithDate:[NSDate date]];
}

//inputType = 0 : Device input
//else as Device input
- (void) start:(int)inputType
{
    NSString* vsData;
    
    if(inputType == 0)
    {
        vsData = [[NSString alloc] initWithFormat:@"{\"DeviceID\":\"\", \"GatewayID\":\"\", \"MemberID\":\"%@\", \"VitalSign\":[{\"Type\":\"BP\", \"MTime\":\"%@\", \"Mark\":\"\", \"InputType\":\"Device\", \"Values\":[%@,%@,%@]}]}", self.userId, (self.fillTime?self.fillTime:[self getCurrentDateTimeString]), self.bloodPressureValue1, self.bloodPressureValue2, self.bloodPressureValue3];
    }else
    {
        vsData = [[NSString alloc] initWithFormat:@"{\"DeviceID\":\"\", \"GatewayID\":\"\", \"MemberID\":\"%@\", \"VitalSign\":[{\"Type\":\"BP\", \"MTime\":\"%@\", \"Mark\":\"\", \"InputType\":\"Manual\", \"Values\":[%@,%@,%@]}]}", self.userId, (self.fillTime?self.fillTime:[self getCurrentDateTimeString]), self.bloodPressureValue1, self.bloodPressureValue2, self.bloodPressureValue3];
    }
    
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
