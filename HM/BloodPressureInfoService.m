//
//  BloodPressureInfoService.m
//  HM
//
//  Created by HUANG Andrerw on 12/10/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BloodPressureInfoService.h"

@implementation BloodPressureInfoService
{
    BOOL receiveElement;
}

@synthesize userId        = _userId;
@synthesize userPassword  = _userPassword;
@synthesize startDate     = _startDate;
@synthesize endDate       = _endDate;
@synthesize sourceData    = _sourceData;
@synthesize imageData     = _imageData;
@synthesize error         = _error;
@synthesize message       = _message;
@synthesize messageBuffer = _messageBuffer;
@synthesize target        = _target;
@synthesize action        = _action;
@synthesize dataJson = _dataJson;

- (id) init
{
    self = [super init];
    if (self) {
        self.messageBuffer = [[NSMutableString alloc]init];
    }
    return self;
}

- (id) initWithUserId:(NSString*)userId
         UserPassword:(NSString*)userPassword
            StartDate:(NSString*)startDate
              EndDate:(NSString*)endDate
               Target:(id)target
               Action:(SEL)action
{
    self = [self init];
    
    if(self) {
        self.userId       = userId;
        self.userPassword = userPassword;
        self.startDate    = startDate;
        self.endDate      = endDate;
        self.target       = target;
        self.action       = action;
    }
    
    return self;
}

- (void) start
{
    NSString* xmlData = [super createXMLWithNameSpace:DEFAULT_NAME_SPACE RootElement:@"GetVitalSign" Data:[NSDictionary dictionaryWithObjectsAndKeys:self.userId, @"ID", self.userPassword, @"Pwd", @"BP", @"Type", [NSString stringWithFormat:@"%@", self.startDate], @"StartDate", [NSString stringWithFormat:@"%@", self.endDate], @"EndDate", nil]];
    
    [self requestWebServiceWithURI:@"/MessageHubWS/VitalSign.asmx" Host:WEB_SERVICE_HOST SoapAction:@"http://tempuri.org/GetVitalSign" XMLData:xmlData ConnectionCallback:nil];
}

- (void) requestWebServiceFinish:(NSMutableData*)data
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"HTTP Response Data:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSXMLParser* parser = [[NSXMLParser alloc]initWithData:data];
    parser.delegate = self;
    [parser parse];
}

- (NSArray*) chartDataStringWithList:(NSArray*)list TotalSpan:(int)totalSpan StartDate:(NSDate*)startDate Type:(NSString*)type
{
    NSMutableString* bhp = [[NSMutableString alloc] init];
    NSMutableString* blp  = [[NSMutableString alloc] init];
    NSMutableString* pulse  = [[NSMutableString alloc] init];
    NSMutableString* scale  = [[NSMutableString alloc] init];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    int count = list.count;
    if (count!=0) {
        id recordData;
        NSDate* d;
        NSCalendar* cal;
        NSDateComponents* startDateComp = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:startDate];
        NSDateComponents* comp;
        for (int i=0; i<count; i++) {
            ////
            recordData = [list objectAtIndex:i];
            if (![@"BP" isEqualToString:[recordData valueForKey:@"Type"]]) {
                continue;
            }
//            if (![type isEqualToString:[recordData valueForKey:@"Mark"]]) {
//                continue;
//            }
            
            d = [df dateFromString:[recordData valueForKey:@"MTime"]];
            cal = [NSCalendar currentCalendar];
            comp = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:d];
            
            int cutDays = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:d] - [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:startDate];
//            NSLog(@"cutDays d %@", startDate);
//            NSLog(@"cutDays x %i", [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:d]);
//            NSLog(@"cutDays y %i", [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:startDate]);
//            NSLog(@"cutDays res %i", cutDays);
            if (cutDays<0) {
                cutDays = -cutDays;
            }
            int cutHours = comp.hour - startDateComp.hour;
            int cutMinutes = comp.minute - startDateComp.minute;
            double temp = (((cutDays*24+cutHours)*60+cutMinutes) / (((double)totalSpan+1)*24*60))*100;
            //NSLog(@"temp %f", temp);
            //NSLog(@"temp2 %.3f", temp);
            //NSLog(@"startDate.hour %i", startDate.hour);
            //NSLog(@"comp.hour %i", comp.hour);
            [scale appendFormat:@"%.3f", temp];
            recordData = [recordData valueForKey:@"Values"];
            [bhp appendFormat:@"%i",[[recordData objectAtIndex:0] intValue]];
            [blp appendFormat:@"%i",[[recordData objectAtIndex:1] intValue]];
            [pulse appendFormat:@"%i",[[recordData objectAtIndex:2] intValue]];
            if (i!=(count-1)) {
                [scale appendString:@","];
                [bhp appendString:@","];
                [blp appendString:@","];
                [pulse appendString:@","];
            }
            ////
        }
    } else {
        [bhp appendString:@"_"];
        [blp appendString:@"_"];
        [pulse appendString:@"_"];
        [scale appendString:@"_"];
    }
    
    if (count==1) {
        NSString* tmp;
        tmp = [scale copy];
        [scale appendString:@","];
        [scale appendString:tmp];
        
        tmp = [bhp copy];
        [bhp appendString:@","];
        [bhp appendString:tmp];
        
        tmp = [blp copy];
        [blp appendString:@","];
        [blp appendString:tmp];
        
        tmp = [pulse copy];
        [pulse appendString:@","];
        [pulse appendString:tmp];
    }
    
    return [NSArray arrayWithObjects:[scale description], [bhp description], [blp description], [pulse description], nil];
}

- (NSArray*) clssifyDatas:(NSArray*)datas Type:(NSString*)type
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    id data;
    for (int i=0; i<datas.count; i++) {
        data = [datas objectAtIndex:i];
        if (![@"BP" isEqualToString:[data valueForKey:@"Type"]]) {
            continue;
        }
//        if (![type isEqualToString:[data valueForKey:@"Mark"]]) {
//            continue;
//        }
        [ret addObject:data];
    }
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSComparator cmpr = ^(NSObject* data1, NSObject* data2) {
        NSDate* d1;
        NSDate* d2;
        d1 = [df dateFromString:[data1 valueForKey:@"MTime"]];
        d2 = [df dateFromString:[data2 valueForKey:@"MTime"]];
        if (d1.timeIntervalSince1970 > d2.timeIntervalSince1970) return NSOrderedAscending;
        if (d2.timeIntervalSince1970 > d1.timeIntervalSince1970) return NSOrderedDescending;
        return NSOrderedSame;
    };
    
    return [ret sortedArrayUsingComparator:cmpr];
}

//@protocol NSXMLParserDelegate <NSObject>
//@optional

- (void)parserDidEndDocument:(NSXMLParser *)parser
{   
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:[self.messageBuffer dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    self.dataJson = json;
    NSString* value;
    value = [json valueForKey:@"Message"];
    NSLog(@"Message:%@", value);
    NSLog(@"@\"A01\" isEqualToString Message:%i", [@"A01" isEqualToString:value]);
    if ([@"A01" isEqualToString:value]) {
        self.error = false;
        self.message = @"成功。";
    } else {
        self.error = true;
        if ([@"E01" isEqualToString:value]) {
            self.message = @"帳號不存在。";
        } else if ([@"E02" isEqualToString:value]) {
            self.message = @"密碼錯誤，身分驗證失敗。";
        } else if ([@"E11" isEqualToString:value]) {
            self.message = @"缺少必要資料。";
        } else if ([@"E12" isEqualToString:value]) {
            self.message = @"資料格式錯誤。";
        } else {
            self.message = @"未知錯誤。";
        }
    }
    
    //Build Image
    //http://chart.googleapis.com/chart?chxl=1:|md%2FdL&chxr=0,3,8|1,-5,100|2,0,31&chxt=y,y,x&chs=440x220&cht=lxy&chco=3072F3&chds=0,100,3,8&chd=t:1,2,3,4,5,6|3,4,3,6,5.2,3.4&chdlp=b&chg=-1,-1,0,0&chls=1&chma=5,5,5,25&chtt=blood+glucose
    if (!self.error) {
        NSArray* arr = [json valueForKey:@"VitalSign"];
        
        /*
        //URL
        NSMutableString* s = [[NSMutableString alloc] init];
        [s appendString:@"http://chart.apis.google.com/chart?"];
        [s appendString:@"cht=lxy"];
        [s appendString:@"&chs=400x400"];
        [s appendString:@"&chxt=x,y,x,y,r,r"];
        [s appendString:@"&chls=1|1"];
        [s appendString:@"&chdlp=t"];
        [s appendString:@"&chma=5,5,5,40|20,20"];
        [s appendString:@"&chco=3072F3,FF0000,000000"];
        [s appendString:@"&chxr=0,0,120|1,0,200|4,0,200"];
        [s appendString:@"&chds=0,100,0,200,0,100,0,200,0,100,0,200"];
        [s appendString:@"&chm=o,3072F3,0,-1,3|o,FF0000,1,-1,3|o,000000,2,-1,3"];
        [s appendString:@"&chxp=2,100|3,100|5,100,90"];
        
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate* sd = [df dateFromString:self.startDate];
        NSDate* ed = [df dateFromString:self.endDate];
        
        
        int cutDate = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:ed] - [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:sd];
        NSLog(@"cutDate:%i", cutDate);
        int days = 0;
        if (cutDate >= 9) {
            [s appendFormat:@"&chg=%f,10",(100.0/((double)cutDate+1))];
            [s appendString:@"&chxl=0:"];
            NSDateComponents* sdc = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:sd];
            NSDateComponents* oneYearComponents = [[NSDateComponents alloc] init];
            NSDate* tmpd = sd;
            for (int i = 0; i <= cutDate; i++) {
                if (i % 5 == 0) {
                    NSLog(@"i -TRUE");
                    [s appendFormat:@"|%i/%i", sdc.month, sdc.day];
                } else {
                    NSLog(@"i -false");
                    [s appendString:@"| "];
                }
                [oneYearComponents setDay:(i+1)];
                tmpd = [[NSCalendar currentCalendar] dateByAddingComponents:oneYearComponents toDate:sd options:0];
                 sdc = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:tmpd];
            }
            [s appendString:@"|2:|Date"];
        } else if (cutDate<=3) {
            [s appendString:@"&chg=8.333,10"];
            [s appendString:@"&chxl=0:"];
            for (int i=0; i<=12; i++) {
                if (i!=0) {
                    days += (cutDate+1)*2;
                }
                if (days==24) {
                    days = 0;
                }
                [s appendString:@"|"];
                if (days>9) {
                    [s appendFormat:@"%i", days];
                } else {
                    [s appendFormat:@"0%i", days];
                }
            }
            [s appendString:@"|2:|Hours"];
        } else {
            [s appendFormat:@"&chg=%.3f,10", (100.0/((double)cutDate+1))];
            [s appendString:@"&chxl=0:"];
            NSDateComponents* oneYearComponents = [[NSDateComponents alloc] init];
            NSDateComponents* sdc = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:sd];
            NSDate* tmpd = sd;
            for (int i=0; i<=cutDate; i++) {
                [s appendFormat:@"|%i/%i", sdc.month, sdc.day];
                NSLog(@"sdc.month, sdc.day:%i, %i", sdc.month, sdc.day);
                //oneYearComponents.day = oneYearComponents.day+1;
                [oneYearComponents setDay:(i+1)];

                NSLog(@"OneYearComponents: %@", oneYearComponents);
                tmpd = [[NSCalendar currentCalendar] dateByAddingComponents:oneYearComponents toDate:sd options:0];
                
                NSLog(@"add: %@", tmpd);
                
                sdc = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:tmpd];
            }
            [s appendString:@"|2:|Date"];
        }
        
        [s appendString:@"|3:|mmHg|5:|mmHg| |3:mmHg|5:|脈搏|次數/分鐘&chdl=收縮壓|舒張壓|脈搏"];
        [s appendString:@"&chd=t:"];
        */
        
        self.sourceData = [self clssifyDatas:arr Type:nil];
        /*
        NSArray* ret;
        ret = [self chartDataStringWithList:self.sourceData TotalSpan:cutDate StartDate:sd Type:nil];
        
        
        
        //scale bhp blp pulse
        [s appendString:[[ret objectAtIndex:0] description]];
        [s appendString:@"|"];
        [s appendString:[[ret objectAtIndex:1] description]];
        [s appendString:@"|"];
        [s appendString:[[ret objectAtIndex:0] description]];
        [s appendString:@"|"];
        [s appendString:[[ret objectAtIndex:2] description]];
        [s appendString:@"|"];
        [s appendString:[[ret objectAtIndex:0] description]];
        [s appendString:@"|"];
        [s appendString:[[ret objectAtIndex:3] description]];
        
        NSLog(@"URL:%@", s);
        
        
        //Request
        NSURLResponse* response;
        NSError* error;
        self.imageData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] returningResponse:&response  error:&error];
        if (error) {
            NSLog(@"error:%@", [error description]);
        } else if (response) {
            NSLog(@"status code:%i", ((NSHTTPURLResponse*)response).statusCode);
        }
        
        NSLog(@"image data size:%i", self.imageData.length);
         */
    }
    
    [self.target performSelector:self.action withObject:self];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"GetVitalSignResult"]) {
        receiveElement = true;
        [self.messageBuffer deleteCharactersInRange:NSMakeRange(0, self.message.length)];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"GetVitalSignResult"]) {
        receiveElement = false;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (receiveElement) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        NSLog(@"%@", string);
        [self.messageBuffer appendString:string];
    }
}

@end
