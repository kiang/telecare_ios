//
//  XenonDataParser.h
//  HM
//
//  Created by WT Lin @ KYLab on 2014/9/9.
//
//

#import <Foundation/Foundation.h>

@interface XenonDataParser : NSObject
{
    int pID;
    int pIDHiByte;
    int dID;
    int iXenon;
    NSString *xenonIDStr;
    NSData *deviceData;
}

-(id) init;
-(void) reset;
-(void) handleData:(NSData *)data;
-(int) getPID;
-(int) getPIDHiByte;
-(int) getDID;
-(int) getIXenon;
-(int) getXenonIDStr;
-(NSData *) getDeviceData;
@end
