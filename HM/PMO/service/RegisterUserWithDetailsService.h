//
//  RegisterUserWithDetailsService.h
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import <Foundation/Foundation.h>
#import "PMOWebService.h"

@interface RegisterUserWithDetailsService : PMOWebService

@property (nonatomic)         BOOL             error;
@property (strong, nonatomic) NSString         *message;

- (id)   initWithAccount:(NSString*)account
                Password:(NSString*)password
                     Sex:(NSString*)sex
                     Tel:(NSString*)tel
                AreaCode:(NSString*)areaCode
                   Birth:(NSString*)birth
             ElementName:(NSString*)elementName
                  Target:(id)target
                  Action:(SEL)action
             ErrorAction:(SEL)errorAction;

- (void) start;

@end
