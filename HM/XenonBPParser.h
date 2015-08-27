//
//  XenonBPParser.h
//  HM
//
//  Created by WT Lin @ KYLab on 2014/9/9.
//
//

#import <Foundation/Foundation.h>
#import "HMUser.h"
#import "HMBP.h"

@interface XenonBPParser : NSObject
{
    NSData *BPHeader;
    NSMutableData *dataBuffer;
}

-(id) init;
-(int) appendData2Buffer:(NSData *) data;   //return dataBuffer length
-(void) parseBP;
-(void) deleteDataInBuf:(int) length;
-(NSDate *) dosDateDecoder:(NSData *) timeData;
-(void) saveBP2DB:(NSString *)dateTime Bph:(int)bph Bpl:(int)bpl Pulse:(int)pulse;
-(void) uploadBPData:(NSString *)dateTime Bph:(int)bph Bpl:(int)bpl Pulse:(int)pulse;
@end
