//
//  ValidateUserService.m
//  HM
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import "ValidateUserService.h"

@interface ValidateUserService()

@property NSString          *account;
@property NSString          *password;
@property NSString          *elementName;
@property NSMutableString   *messageBuffer;
@property id                target;
@property SEL               action;
@property SEL               errorAction;

@end

@implementation ValidateUserService

- (id) init
{
    self = [super init];
    return self;
}

- (id) initWithAccount:(NSString*)account Password:(NSString*)password ElementName:(NSString*)elementName Target:(id)target Action:(SEL)action ErrorAction:(SEL)errorAction
{
    self = [self init];
    if (self)
    {
        self.account        = account;
        self.password       = password;
        self.elementName    = elementName;
        self.target         = target;
        self.action         = action;
        self.errorAction    = errorAction;
    }
    
    return self;
}

- (void) start
{
    NSString *xmlData = [super createXMLWithNameSpace:WEB_SERVICE_NAMESPACE RootElement:@"ValidateUser" Data:[NSDictionary dictionaryWithObjectsAndKeys:self.account, @"ID", self.password, @"Pwd", nil]];
    [self requestWebServiceWithURI:@"/MessageHubWS/Member.asmx" Host:WEB_SERVICE_HOST SoapAction:[NSString stringWithFormat:@"%@%@", WEB_SERVICE_NAMESPACE, @"ValidateUser"] XMLData:xmlData ConnectionCallback:nil];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:[self.messageBuffer dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    NSString* value;
    value = [json valueForKey:@"Message"];
    
    if ([RESPONSE_SUCCESS_CODE isEqualToString:value]) {
        self.error = false;
        self.type = [json valueForKey:@"Type"];
        self.unitName = [json valueForKey:@"UnitName"];
    } else {
        self.error = true;
    }
    self.message = [PMOConstants getErrorMessageWithErrorCode:value];
    
    [super responseToControllerWithTarget:self.target Action:self.action Object:self];
}

@end
