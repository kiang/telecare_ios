//
//  ChangingPasswordService.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChangingPasswordService.h"

@implementation ChangingPasswordService
{
    BOOL receiveElement;
}

@synthesize userId         = _userId;
@synthesize theOldPassword = _theOldPassword;
@synthesize theNewPassword = _theNewPassword;
@synthesize error          = _error;
@synthesize message        = _message;
@synthesize messageBuffer  = _messageBuffer;
@synthesize target         = _target;
@synthesize action         = _action;

- (id) init
{
    self = [super init];
    if (self) {
        self.messageBuffer = [[NSMutableString alloc]init];
    }
    return self;
}

- (id) initWithUserId:(NSString*)userId
       TheOldPassword:(NSString*)theOldPassword
       TheNewPassword:(NSString*)theNewPassword
               Target:(id)target
               Action:(SEL)action;
{
    self = [self init];
    
    if(self) {
        self.userId          = userId;
        self.theOldPassword  = theOldPassword;
        self.theNewPassword  = theNewPassword;
        self.target          = target;
        self.action          = action;
    }
    
    return self;
}

- (void) start
{
    NSString* xmlData = [super createXMLWithNameSpace:DEFAULT_NAME_SPACE RootElement:@"ChangePassword" Data:[NSDictionary dictionaryWithObjectsAndKeys:self.userId, @"ID", self.theOldPassword, @"OldPwd", self.theNewPassword, @"NewPwd", nil]];
    [self requestWebServiceWithURI:@"/MessageHubWS/Member.asmx" Host:WEB_SERVICE_HOST SoapAction:@"http://tempuri.org/ChangePassword" XMLData:xmlData ConnectionCallback:nil];
}

- (void) requestWebServiceFinish:(NSMutableData*)data
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSXMLParser* parser = [[NSXMLParser alloc]initWithData:data];
    parser.delegate = self;
    [parser parse];
}

//@protocol NSXMLParserDelegate <NSObject>
//@optional

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:[self.messageBuffer dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    NSString* value;
    value = [json valueForKey:@"Message"];
    NSLog(@"Message:%@", value);
    NSLog(@"@\"A01\" isEqualToString Message:%i", [@"A01" isEqualToString:value]);
    if ([@"A01" isEqualToString:value]) {
        self.error = false;
        self.message = @"密碼修改成功，\n下次請使用新密碼登入。";
    } else {
        self.error = true;
        if ([@"E01" isEqualToString:value]) {
            self.message = @"帳號不存在。";
        } else if ([@"E02" isEqualToString:value]) {
            self.message = @"密碼錯誤，身分驗證失敗。";
        } else if ([@"E04" isEqualToString:value]) {
            self.message = @"(新)密碼格式錯誤。";
        } else {
            self.message = @"未知錯誤。";
        }
    }
    [self.target performSelector:self.action withObject:self];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"ChangePasswordResult"]) {
        receiveElement = true;
        [self.messageBuffer deleteCharactersInRange:NSMakeRange(0, self.message.length)];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"ChangePasswordResult"]) {
        receiveElement = false;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (receiveElement) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        NSLog(@"%@", string);
        [self.messageBuffer appendString:string];
    }
}

@end
