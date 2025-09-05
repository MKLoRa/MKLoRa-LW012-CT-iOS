//
//  CBPeripheral+MKAEAdd.m
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKAEAdd.h"

#import <objc/runtime.h>

static const char *ae_manufacturerKey = "ae_manufacturerKey";
static const char *ae_seriesNumberKey = "ae_seriesNumberKey";
static const char *ae_deviceModelKey = "ae_deviceModelKey";
static const char *ae_hardwareKey = "ae_hardwareKey";
static const char *ae_softwareKey = "ae_softwareKey";
static const char *ae_firmwareKey = "ae_firmwareKey";

static const char *ae_passwordKey = "ae_passwordKey";
static const char *ae_disconnectTypeKey = "ae_disconnectTypeKey";
static const char *ae_customKey = "ae_customKey";
static const char *ae_storageDataKey = "ae_storageDataKey";
static const char *ae_logKey = "ae_logKey";

static const char *ae_passwordNotifySuccessKey = "ae_passwordNotifySuccessKey";
static const char *ae_disconnectTypeNotifySuccessKey = "ae_disconnectTypeNotifySuccessKey";
static const char *ae_customNotifySuccessKey = "ae_customNotifySuccessKey";

@implementation CBPeripheral (MKAEAdd)

- (void)ae_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &ae_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]]) {
                objc_setAssociatedObject(self, &ae_seriesNumberKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &ae_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &ae_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &ae_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &ae_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &ae_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &ae_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
                objc_setAssociatedObject(self, &ae_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
                objc_setAssociatedObject(self, &ae_logKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA05"]]) {
                objc_setAssociatedObject(self, &ae_storageDataKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
}

- (void)ae_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &ae_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &ae_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        objc_setAssociatedObject(self, &ae_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)ae_connectSuccess {
    if (![objc_getAssociatedObject(self, &ae_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &ae_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &ae_disconnectTypeNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.ae_manufacturer || !self.ae_deviceModel || !self.ae_hardware || !self.ae_software || !self.ae_firmware) {
        return NO;
    }
    if (!self.ae_password || !self.ae_disconnectType || !self.ae_custom || !self.ae_storageData || !self.ae_log) {
        return NO;
    }
    return YES;
}

- (void)ae_setNil {
    objc_setAssociatedObject(self, &ae_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ae_seriesNumberKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ae_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ae_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ae_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ae_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &ae_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ae_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ae_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ae_storageDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ae_logKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &ae_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ae_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ae_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)ae_manufacturer {
    return objc_getAssociatedObject(self, &ae_manufacturerKey);
}

- (CBCharacteristic *)ae_seriesNumber {
    return objc_getAssociatedObject(self, &ae_seriesNumberKey);
}

- (CBCharacteristic *)ae_deviceModel {
    return objc_getAssociatedObject(self, &ae_deviceModelKey);
}

- (CBCharacteristic *)ae_hardware {
    return objc_getAssociatedObject(self, &ae_hardwareKey);
}

- (CBCharacteristic *)ae_software {
    return objc_getAssociatedObject(self, &ae_softwareKey);
}

- (CBCharacteristic *)ae_firmware {
    return objc_getAssociatedObject(self, &ae_firmwareKey);
}

- (CBCharacteristic *)ae_password {
    return objc_getAssociatedObject(self, &ae_passwordKey);
}

- (CBCharacteristic *)ae_disconnectType {
    return objc_getAssociatedObject(self, &ae_disconnectTypeKey);
}

- (CBCharacteristic *)ae_custom {
    return objc_getAssociatedObject(self, &ae_customKey);
}

- (CBCharacteristic *)ae_storageData {
    return objc_getAssociatedObject(self, &ae_storageDataKey);
}

- (CBCharacteristic *)ae_log {
    return objc_getAssociatedObject(self, &ae_logKey);
}

@end
