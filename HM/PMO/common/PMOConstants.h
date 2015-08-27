//
//  PMOConstants.h
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import <Foundation/Foundation.h>

@interface PMOConstants : NSObject

#define WEB_SERVICE_HOST        @"doh.telecare.com.tw"  //doh.telecare.com.tw
#define WEB_SERVICE_NAMESPACE   @"http://tempuri.org/"
#define WEB_DOMAIN              @"http://mohw.telecare.com.tw/PMOMobileApp/"

#define RESPONSE_SUCCESS_CODE   @"A01"

#define NO_NAVIGATION_BAR       0
#define HAS_NAVIGATION_BAR      1

#define BG                      0
#define BP                      1

#define DATE_FORMAT             @"yyyy/MM/dd"
#define DATE_TIME_FORMAT        @"yyyy/MM/dd HH:mm"
#define FULL_DATE_FORMAT        @"yyyy/MM/dd HH:mm:ss"

#define ERROR_ALERT_TITLE       @"警告"
#define SUCCESS_ALERT_TITLE     @"成功"

/* XenonBLE Service Constants */
#define DEFAULT_XENONBLE_NAME @"xb40"
typedef NS_ENUM(NSInteger, BLEStatus) {
	BLEStatus_IDLE = 0,
	BLEStatus_SCANNING,
    BLEStatus_CONNECTING,
    BLEStatus_CONNECTED,
    BLEStatus_DISCOVERING,
    BLEStatus_DATARECEIVING,
    BLEStatus_DISCONNECTING,
    BLEStatus_DISCONNECTED
};

+ (NSString*) getErrorMessageWithErrorCode:(NSString*)errorCode;

+ (NSString*) getFormatDateWithDate:(NSDate*)date;

+ (NSString*) getFormatDateTimeWithDate:(NSDate*)date;

+ (NSString*) getFormatFullDateWithDate:(NSDate*)date;

+ (NSDate*)   getDateTimeWithString:(NSString*)dateString;

+ (NSDate*)   getDateWithString:(NSString*)dateString;

+ (NSDate*)   getFullDateWithString:(NSString*)dateString;

+ (NSDate*)   getDateFromDate:(NSDate*)date
                    OffsetDay:(NSInteger)offset;

+ (NSString*) getConnectionErrorMessageWithError:(NSError *)error;

+ (void) showAlertWithTitle:(NSString*) title
                    Message:(NSString*) message
                   Delegate:(id) delegate;

@end
