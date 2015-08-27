//
//  bleService.h
//  bleTest
//
//  Created by WT Lin @ KYLab on 14/2/14.
//  Copyright (c) 2014年 ymu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "XenonPeripheralService.h"

@protocol bleServiceDelegate <NSObject>
-(void) statusChanged:(int) status;
-(void) bluetoothTurnOff;
@end


@interface bleService : NSObject 

@property (nonatomic,strong) id<bleServiceDelegate>bleServiceDelegate;
@property (nonatomic,strong) id<XenonPeripheralServiceDelegate>	xenonPeripheralDelegate;

//@property (strong,nonatomic) CBPeripheral *discoveredPeripheral;
//@property (strong,nonatomic) XenonPeripheralService *xenonPeripheral;

+(id) sharedInstance;
-(id) init;
-(void) setXenonTag:(NSString *) tagName;
-(NSString *) getXenonTag;

-(void) startService;
-(void) scan;
-(void) stopBLEScan;
-(void) connect:(CBPeripheral*) peripheral;
-(void) disconnect:(CBPeripheral*) peripheral;
-(BOOL) isScanning;
-(void) discoverService;
-(void) cleanup;
-(void) cleanDevices;
-(CBCentralManagerState) getBluetoothState;


@property (strong,nonatomic) NSMutableArray *foundPeripherals;
@property (strong,nonatomic) NSMutableArray *connectedServices;

@end
