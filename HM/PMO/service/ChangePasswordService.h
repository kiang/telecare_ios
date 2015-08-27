//
//  ChangePasswordService.h
//  HM
//
//  Created by Andrerw HUANG on 13/8/26.
//
//

#import <Foundation/Foundation.h>
#import "PMOWebService.h"

@interface ChangePasswordService : PMOWebService

@property (nonatomic)         BOOL             error;
@property (strong, nonatomic) NSString         *message;

- (id) initWithAccount:(NSString*)account
           OldPassword:(NSString*)oldPassowrd
           NewPassword:(NSString*)newPassword
           ElementName:(NSString*)elementName
                Target:(id)target
                Action:(SEL)action
           ErrorAction:(SEL)errorAction;

- (void)start;

@end
