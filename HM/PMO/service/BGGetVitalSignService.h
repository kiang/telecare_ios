//
//  BGGetVitalSignService.h
//  HM
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import <Foundation/Foundation.h>
#import "PMOWebService.h"

@interface BGGetVitalSignService : PMOWebService

@property (nonatomic)         BOOL                error;
@property (strong, nonatomic) NSString            *message;
@property (strong, nonatomic) NSJSONSerialization *dataJson;
@property (strong, nonatomic) NSArray             *sourceData;
@property (strong, nonatomic) NSString            *trendGraphURL;

- (id) initWithAccount:(NSString*)account
              Password:(NSString*)password
             StartDate:(NSString*)startDate
               EndDate:(NSString*)endDate
           ElementName:(NSString*)elementName
                Target:(id)target
                Action:(SEL)action
           ErrorAction:(SEL)errorAction;

- (id) initWithDataJson:(NSJSONSerialization*)dataJson
              StartDate:(NSString*)startDate
                EndDate:(NSString*)endDate
                   Target:(id)target
                   Action:(SEL)action;

- (void) start;

- (void) generateTrendGrapURL;

@end
