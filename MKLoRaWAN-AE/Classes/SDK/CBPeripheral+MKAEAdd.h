//
//  CBPeripheral+MKAEAdd.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKAEAdd)

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *ae_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *ae_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *ae_seriesNumber;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *ae_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *ae_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *ae_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *ae_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *ae_disconnectType;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *ae_custom;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *ae_log;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *ae_storageData;

- (void)ae_updateCharacterWithService:(CBService *)service;

- (void)ae_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)ae_connectSuccess;

- (void)ae_setNil;

@end

NS_ASSUME_NONNULL_END
