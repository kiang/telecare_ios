//
//  XenonPeripheralService.m
//  bleTest
//
//  Created by WT Lin @ KYLab on 14/3/3.
//  Copyright (c) 2014年 ymu. All rights reserved.
//

#import "XenonPeripheralService.h"
#import "PMOConstants.h"
#import "XenonDataParser.h"
#import "XenonBPParser.h"

#define DEBUGLOG YES
#define XENON_SERVICE_UUID [CBUUID UUIDWithString:@"FFF0"]
#define XENON_TRANSFER_CHARACTERISTIC_UUID [CBUUID UUIDWithString:@"FFF5"]

@interface XenonPeripheralService() <CBPeripheralDelegate,NSStreamDelegate>
{
    @private

    CBService  *xenonTransferService;
    id<XenonPeripheralServiceDelegate> peripheralDelegate;

}
@end



@implementation XenonPeripheralService
{
    @private
    BOOL mustSetTime;
    NSMutableData *rcvData;
    XenonDataParser *xenonDataParser;
    XenonBPParser *xenonBPParser;
}
@synthesize peripheral = servicePeripheral;

#pragma mark Init
/*************************************************************************
 Initial
 *************************************************************************/
- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<XenonPeripheralServiceDelegate>)controller
{
    if(DEBUGLOG) NSLog(@"%@",NSStringFromSelector(_cmd));
    self = [super init];
    if (self)
    {
        servicePeripheral = peripheral;
        servicePeripheral.Delegate = self;
        peripheralDelegate = controller;
        
        rcvData = [[NSMutableData alloc] init];
        xenonDataParser = [[XenonDataParser alloc ]init];
        xenonBPParser = [[XenonBPParser alloc] init];
        
    }
    return self;
}


- (void)reset;
{
    servicePeripheral = nil;
    peripheralDelegate = nil;
    rcvData = nil;
}

- (void)start:(BOOL) setTime;
{
    mustSetTime = setTime;
    
    if(servicePeripheral != nil)
    {
        [servicePeripheral discoverServices:@[XENON_SERVICE_UUID]];
    }else
        if(DEBUGLOG) NSLog(@"servicePeripheral = nil");
 
    [peripheralDelegate peripheralStatusChanged:BLEStatus_DISCOVERING];
    
}

- (NSData *) getData
{
    return rcvData;
}

- (void) writeXenonCmd:(CBCharacteristic *) charateristicToWrite
{
    if(servicePeripheral)
    {
        if(charateristicToWrite.properties & CBCharacteristicPropertyWrite)
        {
            static const char xenonCmd[]={ 0x4B,0x59,0x58,0x42,0x01,0x80 };
            
            [servicePeripheral writeValue:
             [NSData dataWithBytes:xenonCmd length:6]
                        forCharacteristic:charateristicToWrite
                        type:CBCharacteristicWriteWithResponse];
        }
        else{
            NSLog(@"charateristic property:%x",charateristicToWrite.properties);
        }
    }else{  NSLog(@"servicePeripheral not initialied");}
}

#pragma mark Peripheral Delegate Method

- (void)peripheral:(CBPeripheral *)peripheral didupdateRSSI:(NSError *)error;
{
    if(DEBUGLOG) NSLog(@"%@",NSStringFromSelector(_cmd));
    if(DEBUGLOG) NSLog(@"RSSI:%@",servicePeripheral.RSSI);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if(DEBUGLOG) NSLog(@"%@",NSStringFromSelector(_cmd));
    
    if (error) {
        NSLog(@"Error didDiscoverServices stata:%@",[error localizedDescription]);
//        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"%@",service.UUID);
        [peripheral discoverCharacteristics: @[XENON_TRANSFER_CHARACTERISTIC_UUID] forService:service];
    }
    
    // Discover other characteristics
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
       // [self cleanup];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:XENON_TRANSFER_CHARACTERISTIC_UUID]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        if(DEBUGLOG) NSLog(@"Error read characteristic stata:%@",[error localizedDescription]);
        return;
    }
    
    NSData *data = characteristic.value;
    NSLog(@"Len:%d, Value: %@",data.length,data.description);
    
    //handle Xenon Data
    [xenonDataParser handleData:data];

    // if Xenon Pid is in BPList, handle BP Data
    if(
       ([xenonDataParser getPID] == 250) || ([xenonDataParser getPIDHiByte] == 0xB0)
    )
    {
        [xenonBPParser appendData2Buffer: [xenonDataParser getDeviceData]];
        [xenonBPParser parseBP];
    }
    
    // [bleServiceDelegate statusChanged:BLESTATUS_DATARECEIVING];
    [peripheralDelegate peripheralStatusChanged:BLEStatus_DATARECEIVING];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
{
    if (error) {
        if(DEBUGLOG) NSLog(@"Error enable notification stata:%@",[error localizedDescription]);
        return;
    }
    
    if(DEBUGLOG) NSLog(@"enable Notification succeed");
    [self writeXenonCmd:characteristic];
}


 - (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
{
    if (error) {
        if(DEBUGLOG) NSLog(@"Error write characteristic stata:%@",[error localizedDescription]);
        return;
    }
    
    if(DEBUGLOG) NSLog(@"Write charateristic succeed");     
   // [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    
    
}

@end
