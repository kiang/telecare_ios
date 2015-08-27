//
//  ChangingPasswordService.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMWebService.h"
#import "HMConstants.h"

@interface ChangingPasswordService : HMWebService<NSXMLParserDelegate>

@property (strong, nonatomic) NSString*        userId;
@property (strong, nonatomic) NSString*        theOldPassword;
@property (strong, nonatomic) NSString*        theNewPassword;
@property (nonatomic)         BOOL             error;
@property (strong, nonatomic) NSString*        message;
@property (strong, nonatomic) NSMutableString* messageBuffer;
@property (strong, nonatomic) id               target;
@property (nonatomic)         SEL              action;

- (id) initWithUserId:(NSString*)userId
       TheOldPassword:(NSString*)theOldPassword
       TheNewPassword:(NSString*)theNewPassword
               Target:(id)target
               Action:(SEL)action;

- (void) start;

@end
