//
//  UploadVitalSignBloodSugarService.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PMOWebService.h"
#import "HMUser.h"
#import "HMBG.h"

@interface UploadVitalSignBloodSugarService : PMOWebService

@property (strong, nonatomic) HMBG*            hmbg;
@property (nonatomic)         BOOL             error;
@property (strong, nonatomic) NSString*        message;

- (id)   initWithUserId:(NSString*)userId
           UserPassword:(NSString*)userPassword
               TimeType:(NSString*)timeType
        BloodSugarValue:(NSString*)bloodSugarValue
                 Target:(id)target
                 Action:(SEL)action;

- (id) initWithHMUser:(HMUser*)user
                 HMBG:(HMBG*)hmbg
               Target:(id)target
               Action:(SEL)action;

- (void) start;

@end
