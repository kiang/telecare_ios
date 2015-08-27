//
//  ChangePasswordService.m
//  HM
//
//  Created by Andrerw HUANG on 13/8/26.
//
//

#import "ChangePasswordService.h"

@interface ChangePasswordService()

@property NSString          *account;
@property NSString          *theOldPassword;
@property NSString          *theNewPassword;
@property id                target;
@property SEL               action;
@property SEL               errorAction;
@property NSString          *elementName;

@end

@implementation ChangePasswordService

- (id) init
{
    self = [super init];
    return self;
}

- (id) initWithAccount:(NSString*)account OldPassword:(NSString*)oldPassowrd NewPassword:(NSString*)newPassword ElementName:(NSString*)elementName Target:(id)target Action:(SEL)action ErrorAction:(SEL)errorAction
{
    self = [self init];
    if (self)
    {
        self.account        = account;
        self.theOldPassword = oldPassowrd;
        self.theNewPassword = newPassword;
        self.target         = target;
        self.action         = action;
        self.errorAction    = errorAction;
        self.elementName    = elementName;
    }
    return self;
}

- (void)start
{
    NSString *xmlData = [super createXMLWithNameSpace:WEB_SERVICE_NAMESPACE RootElement:@"ChangePassword" Data:[NSDictionary dictionaryWithObjectsAndKeys:self.account, @"ID", self.theOldPassword, @"OldPwd", self.theNewPassword, @"NewPwd", nil]];
    [self requestWebServiceWithURI:@"/MessageHubWS/Member.asmx" Host:WEB_SERVICE_HOST SoapAction:[NSString stringWithFormat:@"%@%@", WEB_SERVICE_NAMESPACE, @"ChangePassword"] XMLData:xmlData ConnectionCallback:nil];
}

@end
