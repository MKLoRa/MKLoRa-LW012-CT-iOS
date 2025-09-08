//
//  MKAEInterface+MKAEConfig.m
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKAEInterface+MKAEConfig.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseCentralManager.h"

#import "MKAECentralManager.h"
#import "MKAEOperationID.h"
#import "MKAEOperation.h"
#import "CBPeripheral+MKAEAdd.h"
#import "MKAESDKDataAdopter.h"

#define centralManager [MKAECentralManager shared]

static NSInteger const maxDataLen = 100;

@implementation MKAEInterface (MKAEConfig)

+ (void)ae_powerOffWithSucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01000000";
    [self configDataWithTaskID:mk_ae_taskPowerOffOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_restartDeviceWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01000100";
    [self configDataWithTaskID:mk_ae_taskRestartDeviceOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_factoryResetWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01000200";
    [self configDataWithTaskID:mk_ae_taskFactoryResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configDeviceTime:(unsigned long)timestamp
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [NSString stringWithFormat:@"%1lx",timestamp];
    NSString *commandString = [@"ed01002004" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigDeviceTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configTimeZone:(NSInteger)timeZone
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeZone < -24 || timeZone > 28) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *zoneString = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:timeZone];
    NSString *commandString = [@"ed01002101" stringByAppendingString:zoneString];
    [self configDataWithTaskID:mk_ae_taskConfigTimeZoneOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configHeartbeatInterval:(NSInteger)interval
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 300 || interval > 86400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:4];
    NSString *commandString = [@"ed01002204" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigHeartbeatIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configIndicatorSettings:(id <mk_ae_indicatorSettingsProtocol>)protocol
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [MKAESDKDataAdopter parseIndicatorSettingsCommand:protocol];
    if (!MKValidStr(value)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01002301" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigIndicatorSettingsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configHallPowerOffStatus:(BOOL)isOn
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0100250101" : @"ed0100250100");
    [self configDataWithTaskID:mk_ae_taskConfigHallPowerOffStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configShutdownPayloadStatus:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0100260101" : @"ed0100260100");
    [self configDataWithTaskID:mk_ae_taskConfigShutdownPayloadStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configThreeAxisWakeupConditions:(NSInteger)threshold
                                  duration:(NSInteger)duration
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    if (threshold < 1 || threshold > 20 || duration < 1 || duration > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *thresholdString = [MKBLEBaseSDKAdopter fetchHexValue:threshold byteLen:1];
    NSString *durationString = [MKBLEBaseSDKAdopter fetchHexValue:duration byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01002802",thresholdString,durationString];
    [self configDataWithTaskID:mk_ae_taskConfigThreeAxisWakeupConditionsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configThreeAxisMotionParameters:(NSInteger)threshold
                                  duration:(NSInteger)duration
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    if (threshold < 10 || threshold > 250 || duration < 1 || duration > 50) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *thresholdString = [MKBLEBaseSDKAdopter fetchHexValue:threshold byteLen:1];
    NSString *durationString = [MKBLEBaseSDKAdopter fetchHexValue:duration byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01002902",thresholdString,durationString];
    [self configDataWithTaskID:mk_ae_taskConfigThreeAxisMotionParametersOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark **************************************** Battery ************************************************

+ (void)ae_batteryResetWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01010000";
    [self configDataWithTaskID:mk_ae_taskBatteryResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configLowPowerPayloadStatus:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0101060101" : @"ed0101060100");
    [self configDataWithTaskID:mk_ae_taskConfigLowPowerPayloadStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configLowPowerPayloadInterval:(NSInteger)interval
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed01010701" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigLowPowerPayloadIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configLowPowerCondition1VoltageThreshold:(NSInteger)threshold
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (threshold < 44 || threshold > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:threshold byteLen:1];
    NSString *commandString = [@"ed01010a01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigLowPowerCondition1VoltageThresholdOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configLowPowerCondition1MinSampleInterval:(NSInteger)interval
                                            sucBlock:(void (^)(void))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 1440) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed01010b02" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigLowPowerCondition1MinSampleIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configLowPowerCondition1SampleTimes:(NSInteger)times
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [@"ed01010c01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigLowPowerCondition1SampleTimesOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configLowPowerCondition2VoltageThreshold:(NSInteger)threshold
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (threshold < 44 || threshold > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:threshold byteLen:1];
    NSString *commandString = [@"ed01010d01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigLowPowerCondition2VoltageThresholdOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configLowPowerCondition2MinSampleInterval:(NSInteger)interval
                                            sucBlock:(void (^)(void))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 1440) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed01010e02" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigLowPowerCondition2MinSampleIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configLowPowerCondition2SampleTimes:(NSInteger)times
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [@"ed01010f01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigLowPowerCondition2SampleTimesOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙相关参数************************************************

+ (void)ae_configNeedPassword:(BOOL)need
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (need ? @"ed0102000101" : @"ed0102000100");
    [self configDataWithTaskID:mk_ae_taskConfigNeedPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configPassword:(NSString *)password
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(password) || password.length != 8) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandData = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *commandString = [@"ed01020108" stringByAppendingString:commandData];
    [self configDataWithTaskID:mk_ae_taskConfigPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configBroadcastTimeout:(NSInteger)timeout
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeout < 1 || timeout > 60) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:timeout byteLen:1];
    NSString *commandString = [@"ed01020201" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigBroadcastTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configBeaconStatus:(BOOL)isOn
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0102030101" : @"ed0102030100");
    [self configDataWithTaskID:mk_ae_taskConfigBeaconStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configAdvInterval:(NSInteger)interval
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed01020401" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigAdvIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configTxPower:(mk_ae_txPower)txPower
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [@"ed01020501" stringByAppendingString:[MKAESDKDataAdopter fetchTxPower:txPower]];
    [self configDataWithTaskID:mk_ae_taskConfigTxPowerOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configDeviceName:(NSString *)deviceName
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (![deviceName isKindOfClass:NSString.class] || deviceName.length > 16) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)deviceName.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"ed010206%@%@",lenString,tempString];
    [self configDataWithTaskID:mk_ae_taskConfigDeviceNameOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************模式相关参数************************************************
+ (void)ae_configWorkMode:(mk_ae_deviceMode)deviceMode
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [MKAESDKDataAdopter fetchDeviceModeValue:deviceMode];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01030001",value];
    [self configDataWithTaskID:mk_ae_taskConfigWorkModeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configStandbyModePositioningStrategy:(mk_ae_positioningStrategy)strategy
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKAESDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01031001" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_ae_taskConfigStandbyModePositioningStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configPeriodicModePositioningStrategy:(mk_ae_positioningStrategy)strategy
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKAESDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01032001" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_ae_taskConfigPeriodicModePositioningStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configPeriodicModeReportInterval:(long long)interval
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 30 || interval > 86400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:4];
    NSString *commandString = [@"ed01032104" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigPeriodicModeReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configTimingModePositioningStrategy:(mk_ae_positioningStrategy)strategy
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKAESDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01033001" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_ae_taskConfigTimingModePositioningStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configTimingModeReportingTimePoint:(NSArray <mk_ae_timingModeReportingTimePointProtocol>*)dataList
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *dataString = [MKAESDKDataAdopter fetchTimingModeReportingTimePoint:dataList];
    if (!MKValidStr(dataString)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed010331" stringByAppendingString:dataString];
    [self configDataWithTaskID:mk_ae_taskConfigTimingModeReportingTimePointOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModeEventsNotifyEventOnStart:(BOOL)isOn
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103400101" : @"ed0103400100");
    [self configDataWithTaskID:mk_ae_taskConfigMotionModeEventsNotifyEventOnStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModeEventsFixOnStart:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103410101" : @"ed0103410100");
    [self configDataWithTaskID:mk_ae_taskConfigMotionModeEventsFixOnStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModePosStrategyOnStart:(mk_ae_positioningStrategy)strategy
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKAESDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01034201" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_ae_taskConfigMotionModePosStrategyOnStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModeNumberOfFixOnStart:(NSInteger)number
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (number < 1 || number > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:number byteLen:1];
    NSString *commandString = [@"ed01034301" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigMotionModeNumberOfFixOnStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModeEventsNotifyEventInTrip:(BOOL)isOn
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103500101" : @"ed0103500100");
    [self configDataWithTaskID:mk_ae_taskConfigMotionModeEventsNotifyEventInTripOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModeEventsFixInTrip:(BOOL)isOn
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103510101" : @"ed0103510100");
    [self configDataWithTaskID:mk_ae_taskConfigMotionModeEventsFixInTripOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModePosStrategyInTrip:(mk_ae_positioningStrategy)strategy
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKAESDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01035201" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_ae_taskConfigMotionModePosStrategyInTripOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModeReportIntervalInTrip:(long long)interval
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 10 || interval > 86400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:4];
    NSString *commandString = [@"ed01035304" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigMotionModeReportIntervalInTripOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModeEventsNotifyEventOnEnd:(BOOL)isOn
                                         sucBlock:(void (^)(void))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103600101" : @"ed0103600100");
    [self configDataWithTaskID:mk_ae_taskConfigMotionModeEventsNotifyEventOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModeEventsFixOnEnd:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103610101" : @"ed0103610100");
    [self configDataWithTaskID:mk_ae_taskConfigMotionModeEventsFixOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModePosStrategyOnEnd:(mk_ae_positioningStrategy)strategy
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKAESDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01036201" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_ae_taskConfigMotionModePosStrategyOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModeReportIntervalOnEnd:(NSInteger)interval
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 10 || interval > 300) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed01036302" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigMotionModeReportIntervalOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModeNumberOfFixOnEnd:(NSInteger)number
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (number < 1 || number > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:number byteLen:1];
    NSString *commandString = [@"ed01036401" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigMotionModeNumberOfFixOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModeTripEndTimeout:(NSInteger)time
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 1 || time > 180) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:time byteLen:1];
    NSString *commandString = [@"ed01036501" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigMotionModeTripEndTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configMotionModeEventsFixOnStationaryState:(BOOL)isOn
                                             sucBlock:(void (^)(void))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103700101" : @"ed0103700100");
    [self configDataWithTaskID:mk_ae_taskConfigMotionModeEventsFixOnStationaryStateOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configPosStrategyOnStationary:(mk_ae_positioningStrategy)strategy
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKAESDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01037101" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_ae_taskConfigPosStrategyOnStationaryOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configReportIntervalOnStationary:(NSInteger)interval
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 14400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed01037202" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigReportIntervalOnStationaryOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configTimeSegmentedModeStrategy:(mk_ae_positioningStrategy)strategy
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKAESDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01038001" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_ae_taskConfigTimeSegmentedModeStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configTimeSegmentedModeTimePeriodSetting:(NSArray <mk_ae_timeSegmentedModeTimePeriodSettingProtocol>*)dataList
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *dataString = [MKAESDKDataAdopter fetchimeSegmentedModeTimePeriodSetting:dataList];
    if (!MKValidStr(dataString)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed010381" stringByAppendingString:dataString];
    [self configDataWithTaskID:mk_ae_taskConfigTimeSegmentedModeTimePeriodSettingOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙扫描过滤参数************************************************

+ (void)ae_configRssiFilterValue:(NSInteger)rssi
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (rssi < -127 || rssi > 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:rssi];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01040101",rssiValue];
    [self configDataWithTaskID:mk_ae_taskConfigRssiFilterValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterRelationship:(mk_ae_filterRelationship)relationship
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:relationship byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01040201",value];
    [self configDataWithTaskID:mk_ae_taskConfigFilterRelationshipOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByMacPreciseMatch:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104100101" : @"ed0104100100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByMacPreciseMatchOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByMacReverseFilter:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104110101" : @"ed0104110100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByMacReverseFilterOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterMACAddressList:(NSArray <NSString *>*)macList
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (macList.count > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *macString = @"";
    if (MKValidArray(macList)) {
        for (NSString *mac in macList) {
            if ((mac.length % 2 != 0) || !MKValidStr(mac) || mac.length > 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:mac]) {
                [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
                return;
            }
            NSString *tempLen = [MKBLEBaseSDKAdopter fetchHexValue:(mac.length / 2) byteLen:1];
            NSString *string = [tempLen stringByAppendingString:mac];
            macString = [macString stringByAppendingString:string];
        }
    }
    NSString *dataLen = [MKBLEBaseSDKAdopter fetchHexValue:(macString.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"ed010412%@%@",dataLen,macString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterMACAddressListOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByAdvNamePreciseMatch:(BOOL)isOn
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104180101" : @"ed0104180100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByAdvNamePreciseMatchOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByAdvNameReverseFilter:(BOOL)isOn
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104190101" : @"ed0104190100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByAdvNameReverseFilterOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterAdvNameList:(NSArray <NSString *>*)nameList
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (nameList.count > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!MKValidArray(nameList)) {
        //无列表
        NSString *commandString = @"ee01041a010000";
        [self configDataWithTaskID:mk_ae_taskConfigFilterAdvNameListOperation
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    NSString *nameString = @"";
    if (MKValidArray(nameList)) {
        for (NSString *name in nameList) {
            if (!MKValidStr(name) || name.length > 20 || ![MKBLEBaseSDKAdopter asciiString:name]) {
                [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
                return;
            }
            NSString *nameAscii = @"";
            for (NSInteger i = 0; i < name.length; i ++) {
                int asciiCode = [name characterAtIndex:i];
                nameAscii = [nameAscii stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
            }
            NSString *tempLen = [MKBLEBaseSDKAdopter fetchHexValue:(nameAscii.length / 2) byteLen:1];
            NSString *string = [tempLen stringByAppendingString:nameAscii];
            nameString = [nameString stringByAppendingString:string];
        }
    }
    NSInteger totalLen = nameString.length / 2;
    NSInteger totalNum = (totalLen / maxDataLen);
    if (totalLen % maxDataLen != 0) {
        totalNum ++;
    }
    NSMutableArray *commandList = [NSMutableArray array];
    for (NSInteger i = 0; i < totalNum; i ++) {
        NSString *tempString = @"";
        if (i == totalNum - 1) {
            //最后一帧
            tempString = [nameString substringFromIndex:(i * 2 * maxDataLen)];
        }else {
            tempString = [nameString substringWithRange:NSMakeRange(i * 2 * maxDataLen, 2 * maxDataLen)];
        }
        [commandList addObject:tempString];
    }
    NSString *totalNumberHex = [MKBLEBaseSDKAdopter fetchHexValue:totalNum byteLen:1];
    
    __block NSInteger commandIndex = 0;
    dispatch_queue_t dataQueue = dispatch_queue_create("filterNameListQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dataQueue);
    //当2s内没有接收到新的数据的时候，也认为是接受超时
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 0.05 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (commandIndex >= commandList.count) {
            //停止
            dispatch_cancel(timer);
            MKAEOperation *operation = [[MKAEOperation alloc] initOperationWithID:mk_ae_taskConfigFilterAdvNameListOperation commandBlock:^{
                
            } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
                BOOL success = [returnData[@"success"] boolValue];
                if (!success) {
                    [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
                    return ;
                }
                if (sucBlock) {
                    sucBlock();
                }
            }];
            [[MKAECentralManager shared] addOperation:operation];
            return;
        }
        NSString *tempCommandString = commandList[commandIndex];
        NSString *indexHex = [MKBLEBaseSDKAdopter fetchHexValue:commandIndex byteLen:1];
        NSString *totalLenHex = [MKBLEBaseSDKAdopter fetchHexValue:(tempCommandString.length / 2) byteLen:1];
        NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ee01041a",totalNumberHex,indexHex,totalLenHex,tempCommandString];
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandString characteristic:[MKBLEBaseCentralManager shared].peripheral.ae_custom type:CBCharacteristicWriteWithResponse];
        commandIndex ++;
    });
    dispatch_resume(timer);
}

+ (void)ae_configFilterByBeaconStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104200101" : @"ed0104200100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByBeaconStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByBeaconMajorWithMinValue:(NSInteger)minValue
                                        maxValue:(NSInteger)maxValue
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01042104",minString,maxString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByBeaconMajorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByBeaconMinorWithMinValue:(NSInteger)minValue
                                        maxValue:(NSInteger)maxValue
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01042204",minString,maxString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByBeaconMinorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByBeaconUUID:(NSString *)uuid
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (uuid.length > 32) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!uuid) {
        uuid = @"";
    }
    if (MKValidStr(uuid)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:uuid] || uuid.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(uuid.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed010423",lenString,uuid];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByBeaconUUIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByUIDStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104280101" : @"ed0104280100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByUIDStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByUIDNamespaceID:(NSString *)namespaceID
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    if (namespaceID.length > 20) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!namespaceID) {
        namespaceID = @"";
    }
    if (MKValidStr(namespaceID)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:namespaceID] || namespaceID.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(namespaceID.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed010429",lenString,namespaceID];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByUIDNamespaceIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByUIDInstanceID:(NSString *)instanceID
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (instanceID.length > 12) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!instanceID) {
        instanceID = @"";
    }
    if (MKValidStr(instanceID)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:instanceID] || instanceID.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(instanceID.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01042a",lenString,instanceID];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByUIDInstanceIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByURLStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104300101" : @"ed0104300100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByURLStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByURLContent:(NSString *)content
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (content.length > 100 || ![MKBLEBaseSDKAdopter asciiString:content]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (content.length == 0) {
        NSString *commandString = @"ed01043100";
        [self configDataWithTaskID:mk_ae_taskConfigFilterByURLContentOperation
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < content.length; i ++) {
        int asciiCode = [content characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:content.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed010431",lenString,tempString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByURLContentOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByTLMStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104380101" : @"ed0104380100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByTLMStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByTLMVersion:(mk_ae_filterByTLMVersion)version
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *versionString = @"00";
    if (version == mk_ae_filterByTLMVersion_0) {
        versionString = @"01";
    }else if (version == mk_ae_filterByTLMVersion_1) {
        versionString = @"02";
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01043901",versionString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByTLMVersionOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByBXPBeaconStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104400101" : @"ed0104400100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByBXPBeaconStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByBXPBeaconMajorWithMinValue:(NSInteger)minValue
                                           maxValue:(NSInteger)maxValue
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01044104",minString,maxString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByBXPBeaconMajorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByBXPBeaconMinorWithMinValue:(NSInteger)minValue
                                           maxValue:(NSInteger)maxValue
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01044204",minString,maxString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByBXPBeaconMinorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByBXPBeaconUUID:(NSString *)uuid
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (uuid.length > 32) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!uuid) {
        uuid = @"";
    }
    if (MKValidStr(uuid)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:uuid] || uuid.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(uuid.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed010443",lenString,uuid];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByBXPBeaconUUIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configBXPAccFilterStatus:(BOOL)isOn
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104500101" : @"ed0104500100");
    [self configDataWithTaskID:mk_ae_taskConfigBXPAccFilterStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configBXPTHFilterStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104580101" : @"ed0104580100");
    [self configDataWithTaskID:mk_ae_taskConfigBXPTHFilterStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByBXPDeviceInfoStatus:(BOOL)isOn
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104600101" : @"ed0104600100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByBXPDeviceInfoStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByBXPButtonStatus:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104680101" : @"ed0104680100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByBXPButtonStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByBXPButtonAlarmStatus:(BOOL)singlePress
                                  doublePress:(BOOL)doublePress
                                    longPress:(BOOL)longPress
                           abnormalInactivity:(BOOL)abnormalInactivity
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed01046904",(singlePress ? @"01" : @"00"),(doublePress ? @"01" : @"00"),(longPress ? @"01" : @"00"),(abnormalInactivity ? @"01" : @"00")];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByBXPButtonAlarmStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByBXPTagIDStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104700101" : @"ed0104700100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByBXPTagIDStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configPreciseMatchTagIDStatus:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104710101" : @"ed0104710100");
    [self configDataWithTaskID:mk_ae_taskConfigPreciseMatchTagIDStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configReverseFilterTagIDStatus:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104720101" : @"ed0104720100");
    [self configDataWithTaskID:mk_ae_taskConfigReverseFilterTagIDStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterBXPTagIDList:(NSArray <NSString *>*)tagIDList
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (tagIDList.count > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tagIDString = @"";
    if (MKValidArray(tagIDList)) {
        for (NSString *tagID in tagIDList) {
            if ((tagID.length % 2 != 0) || !MKValidStr(tagID) || tagID.length > 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:tagID]) {
                [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
                return;
            }
            NSString *tempLen = [MKBLEBaseSDKAdopter fetchHexValue:(tagID.length / 2) byteLen:1];
            NSString *string = [tempLen stringByAppendingString:tagID];
            tagIDString = [tagIDString stringByAppendingString:string];
        }
    }
    NSString *dataLen = [MKBLEBaseSDKAdopter fetchHexValue:(tagIDString.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"ed010473%@%@",dataLen,tagIDString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterBXPTagIDListOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByTofStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104780101" : @"ed0104780100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByTofStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterBXPTofList:(NSArray <NSString *>*)codeList
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (codeList.count > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *codeString = @"";
    if (MKValidArray(codeList)) {
        for (NSString *code in codeList) {
            if ((code.length % 2 != 0) || !MKValidStr(code) || code.length > 4 || ![MKBLEBaseSDKAdopter checkHexCharacter:code]) {
                [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
                return;
            }
            NSString *tempLen = [MKBLEBaseSDKAdopter fetchHexValue:(code.length / 2) byteLen:1];
            NSString *string = [tempLen stringByAppendingString:code];
            codeString = [codeString stringByAppendingString:string];
        }
    }
    NSString *dataLen = [MKBLEBaseSDKAdopter fetchHexValue:(codeString.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"ed010479%@%@",dataLen,codeString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterBXPTofListOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByPirStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104800101" : @"ed0104800100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByPirStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByPirDetectionStatus:(mk_ae_detectionStatus)status
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:status byteLen:1];
    NSString *commandString = [@"ed01048101" stringByAppendingString:valueString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByPirDetectionStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByPirSensorSensitivity:(mk_ae_sensorSensitivity)sensitivity
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:sensitivity byteLen:1];
    NSString *commandString = [@"ed01048201" stringByAppendingString:valueString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByPirSensorSensitivityOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByPirDoorStatus:(mk_ae_doorStatus)status
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:status byteLen:1];
    NSString *commandString = [@"ed01048301" stringByAppendingString:valueString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByPirDoorStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByPirDelayResponseStatus:(mk_ae_delayResponseStatus)status
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:status byteLen:1];
    NSString *commandString = [@"ed01048401" stringByAppendingString:valueString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByPirDelayResponseStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByPirMajorMinValue:(NSInteger)minValue
                                 maxValue:(NSInteger)maxValue
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01048504",minString,maxString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByPirMajorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByPirMinorMinValue:(NSInteger)minValue
                                 maxValue:(NSInteger)maxValue
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01048604",minString,maxString];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByPirMinorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByOtherStatus:(BOOL)isOn
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104f80101" : @"ed0104f80100");
    [self configDataWithTaskID:mk_ae_taskConfigFilterByOtherStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByOtherRelationship:(mk_ae_filterByOther)relationship
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKAESDKDataAdopter parseOtherRelationshipToCmd:relationship];
    NSString *commandString = [@"ed0104f901" stringByAppendingString:type];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByOtherRelationshipOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configFilterByOtherConditions:(NSArray <mk_ae_BLEFilterRawDataProtocol>*)conditions
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!conditions || ![conditions isKindOfClass:NSArray.class] || conditions.count > 3) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *dataContent = @"";
    for (id <mk_ae_BLEFilterRawDataProtocol>protocol in conditions) {
        if (![MKAESDKDataAdopter isConfirmRawFilterProtocol:protocol]) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
        NSString *start = [MKBLEBaseSDKAdopter fetchHexValue:protocol.minIndex byteLen:1];
        NSString *end = [MKBLEBaseSDKAdopter fetchHexValue:protocol.maxIndex byteLen:1];
        NSString *content = [NSString stringWithFormat:@"%@%@%@%@",protocol.dataType,start,end,protocol.rawData];
        NSString *tempLenString = [MKBLEBaseSDKAdopter fetchHexValue:(content.length / 2) byteLen:1];
        dataContent = [dataContent stringByAppendingString:[tempLenString stringByAppendingString:content]];
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(dataContent.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0104fa",lenString,dataContent];
    [self configDataWithTaskID:mk_ae_taskConfigFilterByOtherConditionsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************设备lorawan信息设置************************************************

+ (void)ae_configRegion:(mk_ae_loraWanRegion)region
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01050101",[MKAESDKDataAdopter lorawanRegionString:region]];
    [self configDataWithTaskID:mk_ae_taskConfigRegionOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configModem:(mk_ae_loraWanModem)modem
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (modem == mk_ae_loraWanModemABP) ? @"ed0105020101" : @"ed0105020102";
    [self configDataWithTaskID:mk_ae_taskConfigModemOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configDEVEUI:(NSString *)devEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(devEUI) || devEUI.length != 16 || ![MKBLEBaseSDKAdopter checkHexCharacter:devEUI]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01050308" stringByAppendingString:devEUI];
    [self configDataWithTaskID:mk_ae_taskConfigDEVEUIOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configAPPEUI:(NSString *)appEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appEUI) || appEUI.length != 16 || ![MKBLEBaseSDKAdopter checkHexCharacter:appEUI]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01050408" stringByAppendingString:appEUI];
    [self configDataWithTaskID:mk_ae_taskConfigAPPEUIOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configAPPKEY:(NSString *)appKey
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appKey) || appKey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:appKey]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01050510" stringByAppendingString:appKey];
    [self configDataWithTaskID:mk_ae_taskConfigAPPKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configDEVADDR:(NSString *)devAddr
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(devAddr) || devAddr.length != 8 || ![MKBLEBaseSDKAdopter checkHexCharacter:devAddr]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01050604" stringByAppendingString:devAddr];
    [self configDataWithTaskID:mk_ae_taskConfigDEVADDROperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configAPPSKEY:(NSString *)appSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appSkey) || appSkey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:appSkey]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01050710" stringByAppendingString:appSkey];
    [self configDataWithTaskID:mk_ae_taskConfigAPPSKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configNWKSKEY:(NSString *)nwkSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(nwkSkey) || nwkSkey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:nwkSkey]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01050810" stringByAppendingString:nwkSkey];
    [self configDataWithTaskID:mk_ae_taskConfigNWKSKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configLorawanADRACKLimit:(NSInteger)value
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (value < 1 || value > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:value byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01050a01",valueString];
    [self configDataWithTaskID:mk_ae_taskConfigLorawanADRACKLimitOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configLorawanADRACKDelay:(NSInteger)value
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (value < 1 || value > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:value byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01050b01",valueString];
    [self configDataWithTaskID:mk_ae_taskConfigLorawanADRACKDelayOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configCHL:(NSInteger)chlValue
                 CHH:(NSInteger)chhValue
            sucBlock:(void (^)(void))sucBlock
         failedBlock:(void (^)(NSError *error))failedBlock {
    if (chlValue < 0 || chlValue > 95 || chhValue < chlValue || chhValue > 95) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *lowValue = [MKBLEBaseSDKAdopter fetchHexValue:chlValue byteLen:1];
    NSString *highValue = [MKBLEBaseSDKAdopter fetchHexValue:chhValue byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01052002",lowValue,highValue];
    [self configDataWithTaskID:mk_ae_taskConfigCHValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configDR:(NSInteger)drValue
           sucBlock:(void (^)(void))sucBlock
        failedBlock:(void (^)(NSError *error))failedBlock {
    if (drValue < 0 || drValue > 5) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:drValue byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01052101",value];
    [self configDataWithTaskID:mk_ae_taskConfigDRValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configUplinkStrategy:(BOOL)isOn
                  transmissions:(NSInteger)transmissions
                            DRL:(NSInteger)DRL
                            DRH:(NSInteger)DRH
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (!isOn && (DRL < 0 || DRL > 6 || DRH < DRL || DRH > 6 || transmissions < 1 || transmissions > 2)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    
    NSString *lowValue = [MKBLEBaseSDKAdopter fetchHexValue:DRL byteLen:1];
    NSString *highValue = [MKBLEBaseSDKAdopter fetchHexValue:DRH byteLen:1];
    NSString *transmissionsValue = [MKBLEBaseSDKAdopter fetchHexValue:transmissions byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed01052204",(isOn ? @"01" : @"00"),transmissionsValue,lowValue,highValue];
    [self configDataWithTaskID:mk_ae_taskConfigUplinkStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configDutyCycleStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0105230101" : @"ed0105230100");
    [self configDataWithTaskID:mk_ae_taskConfigDutyCycleStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configTimeSyncInterval:(NSInteger)interval
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed01054001" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigTimeSyncIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configLorawanNetworkCheckInterval:(NSInteger)interval
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed01054101" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskConfigNetworkCheckIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configHeartbeatPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                             retransmissionTimes:(NSInteger)times
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055102",typeValue,timeValue];
    [self configDataWithTaskID:mk_ae_taskConfigHeartbeatPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configLowPowerPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                            retransmissionTimes:(NSInteger)times
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055202",typeValue,timeValue];
    [self configDataWithTaskID:mk_ae_taskConfigLowPowerPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configEventPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                         retransmissionTimes:(NSInteger)times
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055402",typeValue,timeValue];
    [self configDataWithTaskID:mk_ae_taskConfigEventPayloadWithMessageTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configPositioningPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                               retransmissionTimes:(NSInteger)times
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055502",typeValue,timeValue];
    [self configDataWithTaskID:mk_ae_taskConfigPositioningPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configShockPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                         retransmissionTimes:(NSInteger)times
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055702",typeValue,timeValue];
    [self configDataWithTaskID:mk_ae_taskConfigShockPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configManDownDetectionPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                                    retransmissionTimes:(NSInteger)times
                                               sucBlock:(void (^)(void))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055802",typeValue,timeValue];
    [self configDataWithTaskID:mk_ae_taskConfigManDownDetectionPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configTamperAlarmPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                               retransmissionTimes:(NSInteger)times
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055902",typeValue,timeValue];
    [self configDataWithTaskID:mk_ae_taskConfigTamperAlarmPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configGPSLimitPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                            retransmissionTimes:(NSInteger)times
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055b02",typeValue,timeValue];
    [self configDataWithTaskID:mk_ae_taskConfigGPSLimitPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************辅助功能************************************************

+ (void)ae_configDownlinkPositioningStrategy:(mk_ae_positioningStrategy)strategy
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKAESDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01060001" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_ae_taskConfigDownlinkPositioningStrategyyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configShockDetectionStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0106100101" : @"ed0106100100");
    [self configDataWithTaskID:mk_ae_taskConfigShockDetectionStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configShockThresholds:(NSInteger)threshold
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (threshold < 10 || threshold > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *thresholdString = [MKBLEBaseSDKAdopter fetchHexValue:threshold byteLen:1];
    NSString *commandString = [@"ed01061101" stringByAppendingString:thresholdString];
    [self configDataWithTaskID:mk_ae_taskConfigShockThresholdsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configShockDetectionReportInterval:(NSInteger)interval
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 3 || interval > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *intervalString = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed01061201" stringByAppendingString:intervalString];
    [self configDataWithTaskID:mk_ae_taskConfigShockDetectionReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configShockTimeout:(NSInteger)interval
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 20) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *intervalString = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed01061301" stringByAppendingString:intervalString];
    [self configDataWithTaskID:mk_ae_taskConfigShockTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configManDownDetectionStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0106200101" : @"ed0106200100");
    [self configDataWithTaskID:mk_ae_taskConfigManDownDetectionStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configIdleDetectionTimeout:(NSInteger)interval
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 8760) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *intervalString = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed01062102" stringByAppendingString:intervalString];
    [self configDataWithTaskID:mk_ae_taskConfigIdleDetectionTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configIdleStutasResetWithSucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01062200";
    [self configDataWithTaskID:mk_ae_taskConfigIdleStutasResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configTamperAlarmStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0106300101" : @"ed0106300100");
    [self configDataWithTaskID:mk_ae_taskConfigTamperAlarmStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configTamperAlarmThresholds:(NSInteger)threshold
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (threshold < 10 || threshold > 200) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *thresholdString = [MKBLEBaseSDKAdopter fetchHexValue:threshold byteLen:1];
    NSString *commandString = [@"ed01063101" stringByAppendingString:thresholdString];
    [self configDataWithTaskID:mk_ae_taskConfigTamperAlarmThresholdsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configTamperAlarmReportInterval:(NSInteger)interval
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 14400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *intervalString = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed01063202" stringByAppendingString:intervalString];
    [self configDataWithTaskID:mk_ae_taskConfigTamperAlarmReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙定位参数************************************************
+ (void)ae_configOfflineFix:(BOOL)isOn
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0108000101" : @"ed0108000100");
    [self configDataWithTaskID:mk_ae_taskConfigOfflineFixOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configGpsLimitUploadStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0108010101" : @"ed0108010100");
    [self configDataWithTaskID:mk_ae_taskConfigGpsLimitUploadStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configOutdoorBLEReportInterval:(NSInteger)interval
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01080801",value];
    [self configDataWithTaskID:mk_ae_taskConfigOutdoorBLEReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configOutdoorGPSReportInterval:(NSInteger)interval
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 14400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01080902",value];
    [self configDataWithTaskID:mk_ae_taskConfigOutdoorGPSReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configBluetoothFixMechanism:(mk_ae_bluetoothFixMechanism)priority
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKAESDKDataAdopter fetchBluetoothFixMechanismString:priority];
    NSString *commandString = [@"ed01082001" stringByAppendingString:type];
    [self configDataWithTaskID:mk_ae_taskConfigBluetoothFixMechanismOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configBlePositioningTimeout:(NSInteger)timeout
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeout < 1 || timeout > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:timeout byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01082101",value];
    [self configDataWithTaskID:mk_ae_taskConfigBlePositioningTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configBlePositioningNumberOfMac:(NSInteger)number
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    if (number < 1 || number > 15) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:number byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01082201",value];
    [self configDataWithTaskID:mk_ae_taskConfigBlePositioningNumberOfMacOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configBeaconVoltageReportInBleFixStatus:(BOOL)isOn
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0108230101" : @"ed0108230100");
    [self configDataWithTaskID:mk_ae_taskConfigBeaconVoltageReportInBleFixStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configGPSFixPositioningTimeout:(NSInteger)timeout
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeout < 30 || timeout > 600) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:timeout byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01083002",value];
    [self configDataWithTaskID:mk_ae_taskConfigGPSFixPositioningTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_configGPSFixPDOP:(NSInteger)pdop
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (pdop < 25 || pdop > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:pdop byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01083101",value];
    [self configDataWithTaskID:mk_ae_taskConfigGPSFixPDOPOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************存储数据协议************************************************

+ (void)ae_readNumberOfDaysStoredData:(NSInteger)days
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (days < 1 || days > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:days byteLen:2];
    NSString *commandString = [@"ed01090002" stringByAppendingString:value];
    [self configDataWithTaskID:mk_ae_taskReadNumberOfDaysStoredDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_clearAllDatasWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01090100";
    [self configDataWithTaskID:mk_ae_taskClearAllDatasOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)ae_pauseSendLocalData:(BOOL)pause
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (pause ? @"ed0109020100" : @"ed0109020101");
    [self configDataWithTaskID:mk_ae_taskPauseSendLocalDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark - private method
+ (void)configDataWithTaskID:(mk_ae_taskOperationID)taskID
                        data:(NSString *)data
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:centralManager.peripheral.ae_custom commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

@end
