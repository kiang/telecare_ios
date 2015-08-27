//
//  ResetPwdService.m
//  HM
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import "ResetPwdService.h"

@interface ResetPwdService()

@property NSString          *account;
@property id                target;
@property SEL               action;
@property SEL               errorAction;
@property NSString          *elementName;

@end

@implementation ResetPwdService

- (id) init
{
    self = [super init];
    return self;
}

- (id) initWithAccount:(NSString*)account ElementName:(NSString*)elementName Target:(id)target Action:(SEL)action ErrorAction:(SEL)errorAction
{
    self = [self init];
    if (self)
    {
        self.account     = account;
        self.target      = target;
        self.action      = action;
        self.elementName = elementName;
        self.errorAction = errorAction;
    }
    return self;
}

- (void) start
{
    NSString *xmlData = [super createXMLWithNameSpace:WEB_SERVICE_NAMESPACE RootElement:@"ResetPassword" Data:[NSDictionary dictionaryWithObjectsAndKeys:self.account, @"ID", nil]];
    [self requestWebServiceWithURI:@"/MessageHubWS/Member.asmx" Host:WEB_SERVICE_HOST SoapAction:[NSString stringWithFormat:@"%@%@", WEB_SERVICE_NAMESPACE, @"ResetPassword"] XMLData:xmlData ConnectionCallback:nil];
}

@end
