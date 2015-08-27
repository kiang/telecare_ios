//
//  ValidateUserService.h
//  HM
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import <Foundation/Foundation.h>
#import "PMOWebService.h"

@interface ValidateUserService : PMOWebService

@property (nonatomic)         BOOL             error;
@property (strong, nonatomic) NSString         *message;
@property (strong, nonatomic) NSString         *type;
@property (strong, nonatomic) NSString         *unitName;

- (id) initWithAccount:(NSString*)account
              Password:(NSString*)password
           ElementName:(NSString*)elementName
                Target:(id)target
                Action:(SEL)action
           ErrorAction:(SEL)errorAction;

- (void) start;

@end
