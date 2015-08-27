//
//  XenonPeripheralService.h
//  bleTest
//
//  Created by WT Lin @ KYLab on 14/3/3.
//  Copyright (c) 2014年 ymu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Reachability.h"

@protocol XenonPeripheralServiceDelegate <NSObject>
- (void) peripheralStatusChanged:(int) status;
@end

@interface XenonPeripheralService : NSObject

- (id) initWithPeripheral:(CBPeripheral *)peripheral
               controller:(id<XenonPeripheralServiceDelegate>) controller;
- (void)reset;
- (void)start:(BOOL) setTime;
- (NSData *) getData;
- (void) writeXenonCmd:(CBCharacteristic *) charateristicToWrite;
@property (weak, readonly) CBPeripheral *peripheral;
//@property (strong,nonatomic) CBPeripheral *servicePeripheral;
@end
