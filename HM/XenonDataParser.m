//
//  XenonDataParser.m
//  HM
//
//  Created by WT Lin @ KYLab on 2014/9/9.
//
//

#import "XenonDataParser.h"

@implementation XenonDataParser

-(id)init
{
    if(self = [super init])
    {
        [self reset];
    }
    return self;
}

-(void)reset
{
    pID = 0;
    pIDHiByte = 0;
    dID = 0;
    iXenon = -1;
    xenonIDStr = nil;
    deviceData = nil;
}

-(void) handleData:(NSData *)data
{
    [self reset];
    if (data.length >= 5)
    {
        Byte *xenonDataBytes = (Byte *) [[data subdataWithRange:NSMakeRange(0,data.length-1)] bytes];
      //  [data getBytes:xenonDataBytes length:data.length];
        
        pIDHiByte = xenonDataBytes[1];
        
        //Product ID
        pID =  xenonDataBytes[0] + (xenonDataBytes[1] << 8);
    
        //Device ID
        dID = 0;
        int iDeviceIDLen = (xenonDataBytes[3] & 0xE0) >> 5;
        if(iDeviceIDLen > 0)
        {
            for (int i =1; i<=iDeviceIDLen;i++)
            {   dID = dID + (xenonDataBytes[i+3] << (i-1)*8);    }
        }
        
        //ID String
        xenonIDStr = [NSString stringWithFormat:@"%08x",(pID+ (dID << 16))];
    
        //Device Data
        int iDid = 4+iDeviceIDLen;
        deviceData = [data subdataWithRange:NSMakeRange( iDid,data.length - iDid)];
    
        //NSLog(@"pid:%d, did:%d, xenonID:%@, deviceData:%@",pID,dID,xenonIDStr,deviceData.description);
    }
}

-(int) getPID
{
    return pID;
}

-(int) getPIDHiByte
{
    return pIDHiByte;
}

-(int) getDID
{
    return dID;
}

-(int) getIXenon
{
    return iXenon;
}

-(int) getXenonIDStr
{
    return xenonIDStr;
}

-(NSData *) getDeviceData
{
    return deviceData;
}
@end
