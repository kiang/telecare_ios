//
//  PMOConstants.m
//
//  Created by Andrerw HUANG on 13/8/24.
//
//

#import "PMOConstants.h"

@implementation PMOConstants

static NSDictionary         *errorMessageDictionary = nil;
static NSDateFormatter      *dateFormat = nil;
static NSDateFormatter      *dateTimeFormat = nil;
static NSDateFormatter      *fullDateFormat = nil;

+ (NSString*) getErrorMessageWithErrorCode:(NSString*)errorCode
{
    if (errorMessageDictionary == nil)
    {
        errorMessageDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"帳號不存在", @"E01",
                                  @"密碼錯誤，身份驗證失敗", @"E02",
                                  @"帳號格式錯誤", @"E03",
                                  @"密碼格式錯誤", @"E04",
                                  @"帳號已存在無法註冊", @"E05",
                                  @"帳號存在，但尚未認證通過", @"E06",
                                  @"帳號身份尚未經過認證", @"E07",
                                  @"帳號尚未收案", @"E08",
                                  @"缺少必要資料", @"E11",
                                  @"資料格式錯誤", @"E12",
                                  @"生理資料格式錯誤", @"E21",
                                  @"其他錯誤", @"E99",
                                  nil];
    }
    
    return [errorMessageDictionary objectForKey:errorCode];
}

+ (NSString*) getFormatDateTimeWithDate:(NSDate*)date
{
    [self initDateTimeFormat];
    NSString* dateTimeStr = [dateTimeFormat stringFromDate:date];
    return dateTimeStr;
}

+ (NSString*) getFormatDateWithDate:(NSDate*)date
{
    [self initDateFormat];
    NSString* dateStr = [dateFormat stringFromDate:date];
    return dateStr;
}

+ (NSString*) getFormatFullDateWithDate:(NSDate*)date
{
    [self initFullDateFormat];
    NSString* dateStr = [fullDateFormat stringFromDate:date];
    return dateStr;
}

+ (NSDate*) getDateTimeWithString:(NSString*)dateString
{
    //debug
    //NSLog(@"dateString:%@",dateString);
    
    [self initDateTimeFormat];
    NSDate *dte = [dateTimeFormat dateFromString:dateString]; //expect "yyyy/MM/dd hh:mm" format
    
    //debug
    //NSLog(@"dte:%@",dte.description);
    
    return dte;
}

+ (NSDate*)   getDateWithString:(NSString*)dateString
{
    [self initDateFormat];
    NSDate *dte = [dateFormat dateFromString:dateString];
    return dte;
}

+ (NSDate*) getFullDateWithString:(NSString*)dateString
{
    [self initFullDateFormat];
    NSDate *dte = [fullDateFormat dateFromString:dateString];
    return dte;
}

+ (void) initDateFormat
{
    if (dateFormat == nil)
    {
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:DATE_FORMAT];
    }
}

+ (void) initDateTimeFormat
{
    if (dateTimeFormat == nil)
    {
        dateTimeFormat = [[NSDateFormatter alloc] init];
        [dateTimeFormat setDateFormat:DATE_TIME_FORMAT];
    }
}

+ (void) initFullDateFormat
{
    if (fullDateFormat == nil)
    {
        fullDateFormat = [[NSDateFormatter alloc] init];
        [fullDateFormat setDateFormat:FULL_DATE_FORMAT];
    }
}

+ (NSDate*) getDateFromDate:(NSDate*)date OffsetDay:(NSInteger)offset
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* c = [[NSDateComponents alloc]init];
    c.day = offset;
    
    return [cal dateByAddingComponents:c toDate:date options:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit];
}

+ (void) showAlertWithTitle:(NSString*) title Message:(NSString*) message Delegate:(id) delegate
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:title message:message  delegate:delegate cancelButtonTitle:@"確定" otherButtonTitles: nil];
    [alertView show];
}

+ (NSString*) getConnectionErrorMessageWithError:(NSError *)error
{
    if (error.code == NSURLErrorNotConnectedToInternet)
    {
        return [NSString stringWithFormat:@"無法連上網路\n%@", @"請確認您的網路是否有開啓"];
    } else
    {
        return [NSString stringWithFormat:@"伺服器或網路忙碌，\n%@", @"請稍候再嘗試，\n建議您檢查網路連線。"];
    }
}

@end
