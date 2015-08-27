//
//  DBUtil.h
//  HM
//
//  Created by HUANG Andrerw on 12/10/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBUtil : NSObject

+ (void) dbUtil;
+ (NSMutableArray*) executeQueryWithSQL:(NSString*)sql Parameters:(NSArray*)parameters;
+ (void) executeUpdateWithSQL:(NSString*)sql Parameters:(NSArray*)parameters;

@end

#ifndef __DB_UTIL__
    #define __DB_UTIL__
#endif

#ifdef __DB_UTIL__
    #define DB_NAME @"HM.db"
#endif
