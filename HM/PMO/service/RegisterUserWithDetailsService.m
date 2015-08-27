//
//  RegisterUserWithDetailsService.m
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import "RegisterUserWithDetailsService.h"

@interface RegisterUserWithDetailsService ()

@property NSString          *account;
@property NSString          *password;
@property NSString          *jsonData;
@property id                target;
@property SEL               action;
@property SEL               errorAction;
@property NSString          *elementName;

@end

@implementation RegisterUserWithDetailsService

- (id) init
{
    self = [super init];
    return self;
}

- (id) initWithAccount:(NSString*)account Password:(NSString*)password Sex:(NSString*)sex Tel:(NSString*)tel AreaCode:(NSString*)areaCode Birth:(NSString*)birth ElementName:(NSString*)elementName Target:(id)target Action:(SEL)action ErrorAction:(SEL)errorAction
{
    self = [self init];
    
    if(self)
    {
        self.account        = account;
        self.password       = password;
        self.jsonData       = [super createJsonStringWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:sex, @"Sex", tel, @"Tel", areaCode, @"AreaCode", birth, @"Birth", nil]];
        self.elementName    = elementName;
        self.target         = target;
        self.action         = action;
        self.errorAction    = errorAction;
    }
    
    return self;
}

- (void) start
{
    NSString *xmlData = [super createXMLWithNameSpace:WEB_SERVICE_NAMESPACE RootElement:@"RegisterUserWithDetails" Data:[NSDictionary dictionaryWithObjectsAndKeys:self.account, @"ID", self.password, @"Pwd", self.jsonData, @"RegisterData", nil]];
    [self requestWebServiceWithURI:@"/MessageHubWS/Member.asmx" Host:WEB_SERVICE_HOST SoapAction:[NSString stringWithFormat:@"%@%@", WEB_SERVICE_NAMESPACE, @"RegisterUserWithDetails"] XMLData:xmlData ConnectionCallback:nil];
}

@end
