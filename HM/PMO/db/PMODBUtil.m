//
//  PMODBUtil.m
//  HM
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import "PMODBUtil.h"

@implementation PMODBUtil

static sqlite3*  db;
static NSString* dbPath;

+ (void) dbUtil
{
    if (!dbPath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        dbPath = [[NSString alloc]initWithString:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    }
    
    //    [DBUtil createDatabase];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath])
    {
        [PMODBUtil createDatabase];
    }
}

+ (void) createDatabase
{
    
    if ([PMODBUtil openDatabase])
    {
        char *error;
        //HM_USER
        NSLog(@"CREATE TABLE IF NOT EXISTS HM_USER (UID TEXT RPIMARY, PWD TEXT, USER_TYPE TEXT, USER_UNIT_NAME TEXT, REMEMBER_ACCOUNT TEXT, LAST_LOGIN INTEGER)");
        sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS HM_USER (UID TEXT RPIMARY, PWD TEXT, USER_TYPE TEXT, USER_UNIT_NAME TEXT, REMEMBER_ACCOUNT TEXT, LAST_LOGIN INTEGER)", NULL, NULL, &error);
        if (error) {
            NSLog(@"%s", error);
        }
        
        //HM_BG
        NSLog(@"CREATE TABLE IF NOT EXISTS HM_BG (FILL_TIME INTEGER RPIMARY, UID TEXT, TYPE TEXT, VAL INTEGER, SEND_FLAG TEXT)");
        sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS HM_BG (FILL_TIME INTEGER RPIMARY, UID TEXT, TYPE TEXT, VAL INTEGER, SEND_FLAG TEXT)", NULL, NULL, &error);
        if (error) {
            NSLog(@"%s", error);
        }
        
        //HM_BP
        NSLog(@"CREATE TABLE IF NOT EXISTS HM_BP (FILL_TIME INTEGER RPIMARY, UID TEXT, BPL INTEGER, BPH INTEGER, PULSE INTEGER, SEND_FLAG TEXT)");
        sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS HM_BP (FILL_TIME INTEGER RPIMARY, UID TEXT, BPL INTEGER, BPH INTEGER, PULSE INTEGER, SEND_FLAG TEXT)", NULL, NULL, &error);
        if (error) {
            NSLog(@"%s", error);
        }
        
        sqlite3_close(db);
        db = nil;
    }
}

+ (BOOL) openDatabase
{
    if (db) return true;
    if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK) return true;
    
    db = nil;
    return false;
}

+ (NSMutableArray*) executeQueryWithSQL:(NSString*)sql Parameters:(NSArray*)parameters
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSMutableArray* datas = [[NSMutableArray alloc] init];
    if ([PMODBUtil openDatabase]) {
        sqlite3_stmt* stmt;
        if (sqlite3_prepare(db, [sql UTF8String], -1, &stmt, nil) != SQLITE_OK) {
            NSLog(@"executeQueryWithSQL sqlite3_prepare fail.");
            return datas;
        }
        
        NSObject* parameter;
        NSString* value;
        for (int i=0, len=parameters.count; i<len; ++i) {
            parameter = [parameters objectAtIndex:i];
            value = [parameter description];
            sqlite3_bind_text(stmt, i+1, [value UTF8String], value.length, nil);
        }
        
        NSMutableDictionary* data;
        const int COLUMN_COUNT = sqlite3_column_count(stmt);
        NSString* colNm;
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            data = [NSMutableDictionary dictionaryWithCapacity:COLUMN_COUNT];
            
            for (int i=0; i<COLUMN_COUNT; ++i) {
                colNm = [NSString stringWithCString:sqlite3_column_name(stmt, i) encoding:NSUTF8StringEncoding];
                switch (sqlite3_column_type(stmt, i)) {
                    case SQLITE_TEXT:
                        [data setObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, i)] forKey:colNm];
                        break;
                    case SQLITE_INTEGER:
                        [data setObject:[NSNumber numberWithInt:sqlite3_column_int(stmt, i)] forKey:colNm];
                        break;
                    case SQLITE_FLOAT:
                        [data setObject:[NSNumber numberWithDouble:sqlite3_column_double(stmt, i)] forKey:colNm];
                        break;
                    case SQLITE_NULL:
                        [data setObject:[NSNull null] forKey:colNm];
                        break;
                    default:
                        break;
                }
            }
            
            [datas addObject:data];
        }
        
        sqlite3_finalize(stmt);
        
        sqlite3_close(db);
        db = nil;
    }
    
    NSLog(@"Query record count:%i", datas.count);
    NSLog(@"Query record:%@", datas);
    
    return datas;
}

+ (void) executeUpdateWithSQL:(NSString*)sql Parameters:(NSArray*)parameters
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([PMODBUtil openDatabase]) {
        if (parameters)
        {
            NSLog(@"executeUpdateWithSQL:%@ Parameters:%@, parameter length:%i", sql, parameters, parameters.count);
            
            sqlite3_stmt* stmt;
            if (sqlite3_prepare(db, [sql UTF8String], -1, &stmt, nil) != SQLITE_OK) {
                NSLog(@"executeUpdateWithSQL sqlite3_prepare fail.");
                return;
            }
            
            NSObject* parameter;
            NSString* value;
            for (int i=0, len=parameters.count; i<len; ++i) {
                parameter = [parameters objectAtIndex:i];
                value = [parameter description];
                const char* str = [value UTF8String];
                sqlite3_bind_text(stmt, i+1, str, strlen(str), nil);
            }
            
            if (sqlite3_step(stmt) != SQLITE_DONE) {
                NSLog(@"executeUpdateWithSQL sqlite3_step fail.");
            }
            
            sqlite3_finalize(stmt);
        } else {
            NSLog(@"executeUpdateWithSQL:%@ Parameters:nil", sql);
            
            char *error;
            sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error);
            if (error) {
                NSLog(@"%s", error);
            }
        }
        
        sqlite3_close(db);
        db = nil;
    }
}


@end
