//
//  BloodPressureInfoService.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMWebService.h"
#import "HMConstants.h"

@interface BloodPressureInfoService : HMWebService<NSXMLParserDelegate>

@property (strong, nonatomic) NSString*        userId;
@property (strong, nonatomic) NSString*        userPassword;
@property (strong, nonatomic) NSString*        startDate;
@property (strong, nonatomic) NSString*        endDate;
@property (strong, nonatomic) NSArray*         sourceData;
@property (strong, nonatomic) NSData*          imageData;
@property (nonatomic)         BOOL             error;
@property (strong, nonatomic) NSString*        message;
@property (strong, nonatomic) NSMutableString* messageBuffer;
@property (strong, nonatomic) id               target;
@property (nonatomic)         SEL              action;
@property (strong, nonatomic) NSJSONSerialization* dataJson;

- (id) initWithUserId:(NSString*)userId
         UserPassword:(NSString*)userPassword
            StartDate:(NSString*)startDate
              EndDate:(NSString*)endDate
               Target:(id)target
               Action:(SEL)action;

- (void) start;

@end
