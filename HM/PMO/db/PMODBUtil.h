//
//  PMODBUtil.h
//  HM
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface PMODBUtil : NSObject

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