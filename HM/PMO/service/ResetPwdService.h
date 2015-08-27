//
//  ResetPwdService.h
//  HM
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import <Foundation/Foundation.h>
#import "PMOWebService.h"

@interface ResetPwdService : PMOWebService

@property (nonatomic)         BOOL             error;
@property (strong, nonatomic) NSString         *message;

- (id) initWithAccount:(NSString*)account
           ElementName:(NSString*)elementName
                Target:(id)target
               Action:(SEL)action
           ErrorAction:(SEL)errorAction;

- (void) start;

@end
