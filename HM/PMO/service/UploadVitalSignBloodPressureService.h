//
//  UploadVitalSignBloodPressureService.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PMOWebService.h"
#import "HMUser.h"
#import "HMBP.h"

@interface UploadVitalSignBloodPressureService : PMOWebService

@property (strong, nonatomic) HMBP*            hmbp;
@property (nonatomic)         BOOL             error;
@property (strong, nonatomic) NSString*        message;

- (id)   initWithUserId:(NSString*)userId
           UserPassword:(NSString*)userPassword
    BloodPressureValue1:(NSString*)bloodPressureValue1
    BloodPressureValue2:(NSString*)bloodPressureValue2
    BloodPressureValue3:(NSString*)bloodPressureValue3
                 Target:(id)target
                 Action:(SEL)action;

- (id) initWithHMUser:(HMUser*)user
                 HMBP:(HMBP*)hmbp
               Target:(id)target
               Action:(SEL)action;

- (void) start:(int)inputType;

@end
