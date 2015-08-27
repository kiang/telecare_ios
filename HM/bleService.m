//
//  bleService.m
//  bleTest
//
//  Created by WT Lin @ KYLab on 14/2/14.
//  Copyright (c) 2014年 ymu. All rights reserved.
//

#import "bleService.h"
#import "PMOConstants.h"

#define DEBUGLOG YES
#define XENON_SERVICE_UUID [CBUUID UUIDWithString:@"FFF0"]
#define XENON_TRANSFER_CHARACTERISTIC_UUID [CBUUID UUIDWithString:@"FFF5"]


NSString *XenonServiceUUIDString = @"FFF0";

@interface bleService () <CBCentralManagerDelegate, CBPeripheralDelegate> {
	__strong CBCentralManager    *centralManager;
    __strong CBPeripheral *discoveredPeripheral;
    __strong XenonPeripheralService *xenonPeripheral;
    __strong NSString *xenonTagName;    //name to Connect
    __strong NSString *advertiselName;
	BOOL pendingInit;
    BOOL scanning;
    CBCentralManagerState bluetoothState;
}
@end


@implementation bleService
@synthesize bleServiceDelegate;
@synthesize xenonPeripheralDelegate;
@synthesize foundPeripherals;
@synthesize connectedServices;
/*************************************************************************
                                Initial
*************************************************************************/

/*  singleton, make sure this class only 1 instance exit */
+(id)sharedInstance
{
    static bleService *this = nil;
    
    if (!this)
       this = [[bleService alloc]init];
    
    return this;
}

-(id)init
{
    if(DEBUGLOG) NSLog(@"%@",NSStringFromSelector(_cmd));
    if(self = [super init])
    {
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil
            options:@{CBCentralManagerOptionRestoreIdentifierKey:@"xenonCentralManagerId"}];
        bluetoothState = centralManager.state;
        foundPeripherals = [[NSMutableArray alloc] init];
        connectedServices = [[NSMutableArray alloc] init];
        [self setXenonTag:DEFAULT_XENONBLE_NAME];
    }
    return self;
}
    
-(void) setXenonTag:(NSString *) tagName
{
    if ([tagName length] == 0) {
        xenonTagName = DEFAULT_XENONBLE_NAME;
    }else
        xenonTagName = tagName;
}

-(NSString *) getXenonTag
{
    return xenonTagName;
}
    
/*************************************************************************
                                Actions
 *************************************************************************/
-(void)startService
{
    if (self)
        [self scan];
    else
        NSLog(@"bleService not initialized!");
}



-(void)scan
{
    if(DEBUGLOG) NSLog(@"%@",NSStringFromSelector(_cmd));

    //(1)   //scan for all devices, not surpport in background
    //[centralManager scanForPeripheralsWithServices:nil options:nil];
    
    //*
    //(2)scan for specific UUID, supproted background
    
    NSArray	*uuidArray = [NSArray arrayWithObjects:XENON_SERVICE_UUID, nil];
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
    [centralManager scanForPeripheralsWithServices:uuidArray options:options];
    
    scanning = YES;
    //*/
    [bleServiceDelegate statusChanged:BLEStatus_SCANNING];
}

-(void) stopBLEScan
{
    [centralManager stopScan];
    scanning = NO;
    [bleServiceDelegate statusChanged:BLEStatus_IDLE];
}
    

-(void)connect:(CBPeripheral*) peripheral
{
    if(DEBUGLOG) NSLog(@"Scanning stopped");
    [self stopBLEScan];
        
    if(DEBUGLOG) NSLog(@"Connecting to peripheral %@",discoveredPeripheral);
    [centralManager connectPeripheral:peripheral options:nil];
    [bleServiceDelegate statusChanged:BLEStatus_SCANNING];
}

-(void) disconnect:(CBPeripheral*) peripheral;
{
    if(DEBUGLOG) NSLog(@"Disconnecting peripheral %@",peripheral);
    [centralManager cancelPeripheralConnection:peripheral];
    [bleServiceDelegate statusChanged:BLEStatus_DISCONNECTING];
}
    
-(void)discoverService
{
    [discoveredPeripheral discoverServices:@[XENON_SERVICE_UUID]];
    [bleServiceDelegate statusChanged:BLEStatus_DISCOVERING];
}

-(BOOL) isScanning;
{   return scanning;    }
    
- (void)cleanup
{
        // See if we are subscribed to a characteristic on the peripheral
        if (discoveredPeripheral.services != nil) {
            for (CBService *service in discoveredPeripheral.services) {
                if (service.characteristics != nil) {
                    for (CBCharacteristic *characteristic in service.characteristics) {
                        if ([characteristic.UUID isEqual:XENON_TRANSFER_CHARACTERISTIC_UUID]) {
                            if (characteristic.isNotifying) {
                                [discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                                return;
                            }
                        }
                    }
                }
            }
        }
        
        [centralManager cancelPeripheralConnection:discoveredPeripheral];
}
    
-(void) cleanDevices
{
    [foundPeripherals removeAllObjects];
    
    XenonPeripheralService *service;
    for (service in connectedServices)
    {   [service reset]; }
    [connectedServices removeAllObjects];
}

-(CBCentralManagerState) getBluetoothState
{
    return bluetoothState;
}
    
#pragma mark - centralManager delegate


-(void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
{
    if(DEBUGLOG) NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    CBCentralManagerState state = central.state;
    bluetoothState = central.state;
    switch (state) {
        case CBCentralManagerStateUnknown:
            if(DEBUGLOG) NSLog(@"The current state of the central manager is unknown; an update is imminent.");
            break;
        case CBCentralManagerStateResetting:
            if(DEBUGLOG) NSLog(@"The connection with the system service was momentarily lost; an update is imminent.");
            [self cleanDevices];
            break;
        case CBCentralManagerStateUnsupported:
            if(DEBUGLOG) NSLog(@"The platform does not support Bluetooth low energy.");
            break;
        case CBCentralManagerStateUnauthorized:
            if(DEBUGLOG) NSLog(@"The app is not authorized to use Bluetooth low energy.");
            break;
        case CBCentralManagerStatePoweredOff:
            if(DEBUGLOG)  NSLog(@"Bluetooth is currently powered off.");
            [self stopBLEScan];
            [self cleanDevices];
            [bleServiceDelegate bluetoothTurnOff];
            break;
        case CBCentralManagerStatePoweredOn:
            if(DEBUGLOG)  NSLog(@"Bluetooth is currently powered on and available to use.");
            [self startService];
            break;
        default:
            // non-reach
            break;
    }
}

- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options;
{
    if(DEBUGLOG) NSLog(@"%@",NSStringFromSelector(_cmd));
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    if(DEBUGLOG) NSLog(@"Discovered %@ at RSSI: %@",peripheral.name, RSSI);
    if ([RSSI intValue] == 127 ) {
        NSLog(@"127 Error Occured");
    }
    
    if(DEBUGLOG) NSLog(@"advertisementData: %@",advertisementData);
    
    if( discoveredPeripheral != peripheral)
    {
        discoveredPeripheral = peripheral;
        if (![foundPeripherals containsObject:peripheral])
        {   [foundPeripherals addObject:peripheral];    }
        
        NSString *advName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
        
        if([advName isEqualToString:xenonTagName])
        {
            advertiselName = advName;
            [self connect:peripheral];
        }
        else
        {   if(DEBUGLOG) NSLog(@"Unknow advertise name:%@",advName);     }
    }
}


-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if(DEBUGLOG) NSLog(@"Failed to connect, Error:%@",[error description]);
    [self cleanup];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    if(DEBUGLOG) NSLog(@"Connected");
    
    //(1)
    //discoveredPeripheral = peripheral;
    //[self discoverService];
    
    //(2)
    xenonPeripheral = [[XenonPeripheralService alloc]initWithPeripheral:
               peripheral controller:xenonPeripheralDelegate];
    
    [xenonPeripheral start:NO];
  
    if (![connectedServices containsObject:xenonPeripheral])
    {   [connectedServices addObject:xenonPeripheral];  }
    if ([foundPeripherals containsObject:peripheral])
    {   [foundPeripherals removeObject:peripheral];  }
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    
    if (error) {
        if(DEBUGLOG) NSLog(@"Error when disconnected, stata:%@",[error localizedDescription]);
        [centralManager cancelPeripheralConnection:peripheral];
        //return;
    }else
    {
        if(DEBUGLOG) NSLog(@"Disconnected");
    }

    XenonPeripheralService *service = nil;
    for (service in connectedServices)
    {
        if([service peripheral] == peripheral)
        {
            [service reset];
            [connectedServices removeObject:service];
            break;
        }
    }
    //debug
    if(DEBUGLOG) NSLog(@"found P:%d, connected P:%d",[foundPeripherals count],[connectedServices count]);
    
    //update UIView
    [bleServiceDelegate statusChanged:BLEStatus_DISCONNECTED];
    
    [self cleanup];
    discoveredPeripheral = nil;
    [self scan];    //restart scanning
    
}



@end
