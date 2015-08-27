//
//  HMUser.h
//
//  Created by HUANG Andrerw on 12/10/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMUser : NSObject

@property (strong, nonatomic) NSString* uid;
@property (strong, nonatomic) NSString* pwd;
@property (strong, nonatomic) NSString* rememberAccount;
@property (strong, nonatomic) NSString* userType;
@property (strong, nonatomic) NSString* userUnitName;

@end
