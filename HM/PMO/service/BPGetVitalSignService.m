//
//  BPGetVitalSignService.m
//  HM
//
//  Created by Andrerw HUANG on 13/8/25.
//
//

#import "BPGetVitalSignService.h"

@interface BPGetVitalSignService()

@property NSString          *account;
@property NSString          *password;
@property NSString          *elementName;
@property NSString          *startDate;
@property NSString          *endDate;
@property NSMutableString   *messageBuffer;
@property id                target;
@property SEL               action;
@property SEL               errorAction;

@end

@implementation BPGetVitalSignService

- (id) init
{
    self = [super init];
    return self;
}

- (id) initWithAccount:(NSString*)account Password:(NSString*)password StartDate:(NSString*)startDate EndDate:(NSString*)endDate ElementName:(NSString*)elementName Target:(id)target Action:(SEL)action ErrorAction:(SEL)errorAction
{
    self = [self init];
    if (self)
    {
        self.account        = account;
        self.password       = password;
        self.startDate      = startDate;
        self.endDate        = endDate;
        self.elementName    = elementName;
        self.target         = target;
        self.action         = action;
        self.errorAction    = errorAction;
    }
    
    return self;
}

- (id) initWithDataJson:(NSJSONSerialization*)dataJson StartDate:(NSString*)startDate EndDate:(NSString*)endDate Target:(id)target Action:(SEL)action
{
    self = [self init];
    if (self)
    {
        self.dataJson   = dataJson;
        self.startDate  = startDate;
        self.endDate    = endDate;
        self.target     = target;
        self.action     = action;
    }
    
    return self;
}

- (void) start
{
    NSString *xmlData = [super createXMLWithNameSpace:WEB_SERVICE_NAMESPACE RootElement:@"GetVitalSign" Data:[NSDictionary dictionaryWithObjectsAndKeys:self.account, @"ID", self.password, @"Pwd", self.startDate, @"StartDate", self.endDate, @"EndDate", @"BP", @"Type", nil]];
    [self requestWebServiceWithURI:@"/MessageHubWS/VitalSign.asmx" Host:WEB_SERVICE_HOST SoapAction:[NSString stringWithFormat:@"%@%@", WEB_SERVICE_NAMESPACE, @"GetVitalSign"] XMLData:xmlData ConnectionCallback:nil];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:[self.messageBuffer dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    self.dataJson = json;
    
    NSString *value;
    value = [json valueForKey:@"Message"];
    
    if ([RESPONSE_SUCCESS_CODE isEqualToString:value]) {
        self.error = false;
        
        NSArray* arr = [json valueForKey:@"VitalSign"];
        self.sourceData = [super classifyDatas:arr Type:@"BP" Mark:nil];
    } else {
        self.error = true;
    }
    self.message = [PMOConstants getErrorMessageWithErrorCode:value];
    
    [super responseToControllerWithTarget:self.target Action:self.action Object:self];
}

- (void) generateTrendGrapURL
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSArray* arr = [self.dataJson valueForKey:@"VitalSign"];
    
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
    [s appendString:@"&chxr=0,0,120|1,0,250|4,0,250"];
    [s appendString:@"&chds=0,100,0,250,0,100,0,250,0,100,0,250"];
    [s appendString:@"&chm=o,3072F3,0,-1,3|o,FF0000,1,-1,3|o,000000,2,-1,3"];
    [s appendString:@"&chxp=2,100|3,100|5,100,90"];
    
    NSDate *sd = [PMOConstants getDateWithString:self.startDate];
    NSDate *ed = [PMOConstants getDateWithString:self.endDate];
    
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
                [s appendFormat:@"|%i/%i", sdc.month, sdc.day];
            } else {
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
            [oneYearComponents setDay:(i+1)];
            tmpd = [[NSCalendar currentCalendar] dateByAddingComponents:oneYearComponents toDate:sd options:0];
            
            sdc = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:tmpd];
        }
        [s appendString:@"|2:|Date"];
    }
    
    [s appendString:@"|3:|mmHg|5:|mmHg| |3:mmHg|5:|脈搏|次數/分鐘&chdl=收縮壓|舒張壓|脈搏"];
    [s appendString:@"&chd=t:"];
    
    NSArray* sourceData = [super classifyDatas:arr Type:@"BP" Mark:nil];
    NSArray* ret;
    ret = [self chartDataStringWithList:sourceData TotalSpan:cutDate StartDate:sd];
    
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

    self.trendGraphURL = [s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [super responseToControllerWithTarget:self.target Action:self.action Object:self];
}

- (NSArray*) chartDataStringWithList:(NSArray*)list TotalSpan:(int)totalSpan StartDate:(NSDate*)startDate
{
    NSMutableString* bhp = [[NSMutableString alloc] init];
    NSMutableString* blp  = [[NSMutableString alloc] init];
    NSMutableString* pulse  = [[NSMutableString alloc] init];
    NSMutableString* scale  = [[NSMutableString alloc] init];
    
    int count = list.count;
    if (count!=0) {
        id recordData;
        NSDate* d;
        NSCalendar* cal;
        NSDateComponents* startDateComp = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:startDate];
        NSDateComponents* comp;
        for (int i=0; i<count; i++) {
            recordData = [list objectAtIndex:i];
            
            d = [PMOConstants getFullDateWithString:[recordData valueForKey:@"MTime"]];
            cal = [NSCalendar currentCalendar];
            comp = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:d];
            
            int cutDays = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:d] - [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:startDate];

            if (cutDays<0) {
                cutDays = -cutDays;
            }
            int cutHours = comp.hour - startDateComp.hour;
            int cutMinutes = comp.minute - startDateComp.minute;
            double temp = (((cutDays*24+cutHours)*60+cutMinutes) / (((double)totalSpan+1)*24*60))*100;

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

@end
