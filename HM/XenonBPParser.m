//
//  XenonBPParser.m
//  HM
//
//  Created by WT Lin @ KYLab on 2014/9/9.
//
//

#import "XenonBPParser.h"
#import "PMOConstants.h"
#import "UploadVitalSignBloodPressureService.h"
#import "PMODBService.h"

#define BPDATALENGTH 17
#define BPHEADER {75,15}

@implementation XenonBPParser

static PMODBService *dbService;

-(id) init
{
    if([super init])
    {
        Byte headerBytes [] = BPHEADER;
        BPHeader = [NSData dataWithBytes:headerBytes length:sizeof(headerBytes)];
        dataBuffer = [[NSMutableData alloc] init];
        
        if (dbService == nil) {
            dbService = [[PMODBService alloc]init];
        }
    }
    return self;
}

-(int) appendData2Buffer:(NSData *)data
{
    [dataBuffer appendData:data];
    return dataBuffer.length;
}

-(void) parseBP
{
    if(dataBuffer.length >= BPDATALENGTH)
    {
     //   NSLog(@"dataBuffer:%@",dataBuffer.description);
        NSRange iRange = [dataBuffer rangeOfData:BPHeader options:0 range:NSMakeRange(0,[dataBuffer length])];
        if (iRange.length > 0)
        {
            //check BP data length
            int iEnd = iRange.location + BPDATALENGTH -1;
            if(dataBuffer.length > iEnd)
            {
                NSData *bpData = [dataBuffer subdataWithRange:NSMakeRange(iRange.location,iEnd)];
                Byte *bpDataBytes = (Byte *)[bpData bytes];
                
                if ((int)bpDataBytes[16]==0)
                {
                    //get bp
                    int sys = bpDataBytes[5];
                    int dia = bpDataBytes[6];
                    int hr = bpDataBytes[7];
                    NSString *bpStr =
                    [NSString stringWithFormat:@"收縮壓:%d,舒張壓:%d,心率:%d",sys,dia,hr];
                    NSLog(@"%@",bpStr);
                    
                    //decode time data
                    unsigned int year = bpDataBytes[9] >> 1;
                    if(year > 0) { year = year + 1980;}
                    unsigned int month = ((bpDataBytes[9] % 2)*8) + (bpDataBytes[10] >> 5);
                    unsigned int day = bpDataBytes[10] % 32;
                    unsigned int hour = bpDataBytes[11] >>3;
                    unsigned int min = ((bpDataBytes[11] % 8)*8) + (bpDataBytes[12] >> 5);
                    NSString *dateTimeStr =
                    [NSString stringWithFormat:@"%d/%02d/%02d %02d:%02d",year,month,day,hour,min];
                    NSLog(@"%@",dateTimeStr);
                    
                    if (sys==0 || dia == 0 || hr==0 || year == 0)
                    {
                        [OMGToast showWithText:@"量測資料錯誤" duration:2];
                    }else
                    {
                        //notice message box
                        NSString *bpMessage = [NSString stringWithFormat:@"收到並儲存血壓資料:%@,%@",dateTimeStr,bpStr];
                        [OMGToast showWithText:bpMessage duration:3];
                    
                        //save bp to DB
                        [self saveBP2DB:dateTimeStr Bph:sys Bpl:dia Pulse:hr];
                    }
                    
                    //clear buffer
                    [self deleteDataInBuf:iEnd + 1];
                }else
                {
                    NSLog(@"bpdataByte[16]:%d",(int)bpDataBytes[16]);
                    
                }
                
            }
        }else   //no BP Header in buffer, then reset buffer
        {
            [self deleteDataInBuf:dataBuffer.length -1];
        }
        
    }
    
}

- (void) deleteDataInBuf:(int) length
{
    [dataBuffer replaceBytesInRange:NSMakeRange(0, length) withBytes:NULL length:0];
}

-(NSData *) dosDateDecoder:(NSData *) timeData
{
    Byte *datetimeBytes = (Byte *)[timeData bytes];
    
    if (datetimeBytes[0]==0 && datetimeBytes[1]==0 &&
        datetimeBytes[2]==0 && datetimeBytes[3]==0)
    {
        return nil;
    }else
    {
        unsigned int year = datetimeBytes[0] >> 1;
        if(year > 0) { year = year + 1980;}
        
        unsigned int month = ((datetimeBytes[0] % 2)*8) + (datetimeBytes[1] >> 5);
        unsigned int day = datetimeBytes[1] % 32;
        unsigned int hour = datetimeBytes[2] >>3;
        unsigned int min = ((datetimeBytes[2] % 8)*8) + (datetimeBytes[3] >> 5);
        unsigned int sec = (datetimeBytes[3] % 32)*2;

        NSLog(@"%d-%02d-%02d %02d:%02d:%02d",year,month,day,hour,min,sec);
    }
    return nil;
}

-(void) saveBP2DB:(NSString *)dateTime Bph:(int)bph Bpl:(int)bpl Pulse:(int)pulse
{
    HMUser*  user;
    user = [dbService getLastHMUser];
    
    NSString *sys = [NSString stringWithFormat:@"%d",bph];
    NSString *dia = [NSString stringWithFormat:@"%d",bpl];
    NSString *hr = [NSString stringWithFormat:@"%d",pulse];
    
    // Save to HMBP
    [dbService saveHMBPWithAccount:user.uid DateTime:dateTime Bpl:dia Bph:sys Pluse:hr InputType:@"D"];
    
    //[OMGToast showWithText:@"血壓資料已儲存" duration:2];
}

-(void) uploadBPData:(NSString *)dateTime Bph:(int)bph Bpl:(int)bpl Pulse:(int)pulse
{
    HMBP *hmbp      = [[HMBP alloc] init];
    hmbp.bph        = [NSNumber numberWithInt:bph];
    hmbp.bpl        = [NSNumber numberWithInt:bpl];
    hmbp.pluse      = [NSNumber numberWithInt:pulse];
    NSDate *dte     = [PMOConstants getDateTimeWithString:dateTime];
    hmbp.fillTime   = [NSNumber numberWithLong:[dte timeIntervalSinceReferenceDate]];
    hmbp.sendFlag = @"D";
  
    HMUser*  user;
    user = [dbService getLastHMUser];
    
    //upload directly
    [[[UploadVitalSignBloodPressureService alloc]initWithHMUser:user HMBP:hmbp Target:self Action:@selector(uploadBPResponse:)]start:0];
}

- (void)uploadBPResponse:(UploadVitalSignBloodPressureService*)service
{
    if(!service.error) {
        [OMGToast showWithText:@"上傳血壓資料成功" duration:2];
    } else {
        [OMGToast showWithText:@"上傳血壓資料失敗" duration:2];
    }
}

@end
