//
//  MKAEInterface.m
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKAEInterface.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKAECentralManager.h"
#import "MKAEOperationID.h"
#import "MKAEOperation.h"
#import "CBPeripheral+MKAEAdd.h"
#import "MKAESDKDataAdopter.h"

#define centralManager [MKAECentralManager shared]
#define peripheral ([MKAECentralManager shared].peripheral)

@implementation MKAEInterface

#pragma mark ****************************************Device Service Information************************************************

+ (void)ae_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_ae_taskReadDeviceModelOperation
                           characteristic:peripheral.ae_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)ae_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_ae_taskReadFirmwareOperation
                           characteristic:peripheral.ae_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)ae_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_ae_taskReadHardwareOperation
                           characteristic:peripheral.ae_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)ae_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_ae_taskReadSoftwareOperation
                           characteristic:peripheral.ae_software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)ae_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_ae_taskReadManufacturerOperation
                           characteristic:peripheral.ae_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark ****************************************System************************************************

+ (void)ae_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMacAddressOperation
                     cmdFlag:@"0015"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readTimeZoneWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadTimeZoneOperation
                     cmdFlag:@"0021"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readHeartbeatIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadHeartbeatIntervalOperation
                     cmdFlag:@"0022"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readIndicatorSettingsWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadIndicatorSettingsOperation
                     cmdFlag:@"0023"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readHallPowerOffStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadHallPowerOffStatusOperation
                     cmdFlag:@"0025"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readShutdownPayloadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadShutdownPayloadStatusOperation
                     cmdFlag:@"0026"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readThreeAxisWakeupConditionsWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadThreeAxisWakeupConditionsOperation
                     cmdFlag:@"0028"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readThreeAxisMotionParametersWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadThreeAxisMotionParametersOperation
                     cmdFlag:@"0029"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBatteryVoltageOperation
                     cmdFlag:@"0040"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readPCBAStatusWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadPCBAStatusOperation
                     cmdFlag:@"0041"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readSelftestStatusWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadSelftestStatusOperation
                     cmdFlag:@"0042"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark **************************************** Battery ************************************************

+ (void)ae_readBatteryInformationWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBatteryInformationOperation
                     cmdFlag:@"0101"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLastCycleBatteryInformationWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLastCycleBatteryInformationOperation
                     cmdFlag:@"0102"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readAllCycleBatteryInformationWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadAllCycleBatteryInformationOperation
                     cmdFlag:@"0103"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLowPowerPromptWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLowPowerPromptOperation
                     cmdFlag:@"0104"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLowPowerPayloadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLowPowerPayloadStatusOperation
                     cmdFlag:@"0106"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLowPowerPayloadIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLowPowerPayloadIntervalOperation
                     cmdFlag:@"0107"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙相关参数************************************************

+ (void)ae_readConnectationNeedPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadConnectationNeedPasswordOperation
                     cmdFlag:@"0200"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadPasswordOperation
                     cmdFlag:@"0201"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readBroadcastTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBroadcastTimeoutOperation
                     cmdFlag:@"0202"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBeaconStatusOperation
                     cmdFlag:@"0203"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readAdvIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadAdvIntervalOperation
                     cmdFlag:@"0204"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadTxPowerOperation
                     cmdFlag:@"0205"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadDeviceNameOperation
                     cmdFlag:@"0206"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************模式相关参数************************************************
+ (void)ae_readWorkModeWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadWorkModeOperation
                     cmdFlag:@"0300"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readStandbyModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadStandbyModePositioningStrategyOperation
                     cmdFlag:@"0310"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readPeriodicModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadPeriodicModePositioningStrategyOperation
                     cmdFlag:@"0320"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readPeriodicModeReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadPeriodicModeReportIntervalOperation
                     cmdFlag:@"0321"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readTimingModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadTimingModePositioningStrategyOperation
                     cmdFlag:@"0330"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readTimingModeReportingTimePointWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadTimingModeReportingTimePointOperation
                     cmdFlag:@"0331"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModeEventsNotifyEventOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                                  failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModeEventsNotifyEventOnStartOperation
                     cmdFlag:@"0340"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModeEventsFixOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModeEventsFixOnStartOperation
                     cmdFlag:@"0341"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModePosStrategyOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModePosStrategyOnStartOperation
                     cmdFlag:@"0342"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModeNumberOfFixOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModeNumberOfFixOnStartOperation
                     cmdFlag:@"0343"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModeEventsNotifyEventInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                                 failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModeEventsNotifyEventInTripOperation
                     cmdFlag:@"0350"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModeEventsFixInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModeEventsFixInTripOperation
                     cmdFlag:@"0351"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModePosStrategyInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModePosStrategyInTripOperation
                     cmdFlag:@"0352"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModeReportIntervalInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModeReportIntervalInTripOperation
                     cmdFlag:@"0353"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModeEventsNotifyEventOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                                failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModeEventsNotifyEventOnEndOperation
                     cmdFlag:@"0360"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModeEventsFixOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModeEventsFixOnEndOperation
                     cmdFlag:@"0361"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModePosStrategyOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModePosStrategyOnEndOperation
                     cmdFlag:@"0362"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModeReportIntervalOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModeReportIntervalOnEndOperation
                     cmdFlag:@"0363"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModeNumberOfFixOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModeNumberOfFixOnEndOperation
                     cmdFlag:@"0364"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModeTripEndTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModeTripEndTimeoutOperation
                     cmdFlag:@"0365"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readMotionModeEventsFixOnStationaryStateWithSucBlock:(void (^)(id returnData))sucBlock
                                                    failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadMotionModeEventsFixOnStationaryStateOperation
                     cmdFlag:@"0370"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readPosStrategyOnStationaryWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadPosStrategyOnStationaryOperation
                     cmdFlag:@"0371"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readReportIntervalOnStationaryWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadReportIntervalOnStationaryOperation
                     cmdFlag:@"0372"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readTimeSegmentedModeStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadTimeSegmentedModeStrategyOperation
                     cmdFlag:@"0380"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readTimeSegmentedModeTimePeriodSettingWithSucBlock:(void (^)(id returnData))sucBlock
                                                  failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadTimeSegmentedModeTimePeriodSettingOperation
                     cmdFlag:@"0381"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙扫描过滤参数************************************************

+ (void)ae_readRssiFilterValueWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadRssiFilterValueOperation
                     cmdFlag:@"0401"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterRelationshipOperation
                     cmdFlag:@"0402"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterTypeStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterTypeStatusOperation
                     cmdFlag:@"0403"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByMacPreciseMatchWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByMacPreciseMatchOperation
                     cmdFlag:@"0410"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByMacReverseFilterWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByMacReverseFilterOperation
                     cmdFlag:@"0411"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterMACAddressListWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterMACAddressListOperation
                     cmdFlag:@"0412"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByAdvNamePreciseMatchWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByAdvNamePreciseMatchOperation
                     cmdFlag:@"0418"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByAdvNameReverseFilterWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByAdvNameReverseFilterOperation
                     cmdFlag:@"0419"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterAdvNameListWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ee00041a00";
    [centralManager addTaskWithTaskID:mk_ae_taskReadFilterAdvNameListOperation
                       characteristic:peripheral.ae_custom
                          commandData:commandString
                         successBlock:^(id  _Nonnull returnData) {
        NSArray *advList = [MKAESDKDataAdopter parseFilterAdvNameList:returnData[@"result"]];
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":@{
                                        @"nameList":advList,
                                    },
                                    };
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock(resultDic);
            }
        });
        
    } failureBlock:failedBlock];
}



+ (void)ae_readFilterByBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByBeaconStatusOperation
                     cmdFlag:@"0420"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByBeaconMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByBeaconMajorRangeOperation
                     cmdFlag:@"0421"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByBeaconMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByBeaconMinorRangeOperation
                     cmdFlag:@"0422"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByBeaconUUIDOperation
                     cmdFlag:@"0423"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByUIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByUIDStatusOperation
                     cmdFlag:@"0428"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByUIDNamespaceIDWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByUIDNamespaceIDOperation
                     cmdFlag:@"0429"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByUIDInstanceIDWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByUIDInstanceIDOperation
                     cmdFlag:@"042a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByURLStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByURLStatusOperation
                     cmdFlag:@"0430"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByURLContentWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByURLContentOperation
                     cmdFlag:@"0431"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByTLMStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByTLMStatusOperation
                     cmdFlag:@"0438"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByTLMVersionWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByTLMVersionOperation
                     cmdFlag:@"0439"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByBXPBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByBXPBeaconStatusOperation
                     cmdFlag:@"0440"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByBXPBeaconMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByBXPBeaconMajorRangeOperation
                     cmdFlag:@"0441"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByBXPBeaconMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByBXPBeaconMinorRangeOperation
                     cmdFlag:@"0442"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByBXPBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByBXPBeaconUUIDOperation
                     cmdFlag:@"0443"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readBXPAccFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBXPAccFilterStatusOperation
                     cmdFlag:@"0450"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readBXPTHFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBXPTHFilterStatusOperation
                     cmdFlag:@"0458"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByBXPDeviceInfoStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBXPDeviceInfoFilterStatusOperation
                     cmdFlag:@"0460"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readBXPButtonFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBXPButtonFilterStatusOperation
                     cmdFlag:@"0468"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readBXPButtonAlarmFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBXPButtonAlarmFilterStatusOperation
                     cmdFlag:@"0469"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByBXPTagIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByBXPTagIDStatusOperation
                     cmdFlag:@"0470"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readPreciseMatchTagIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadPreciseMatchTagIDStatusOperation
                     cmdFlag:@"0471"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readReverseFilterTagIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadReverseFilterTagIDStatusOperation
                     cmdFlag:@"0472"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterBXPTagIDListWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterBXPTagIDListOperation
                     cmdFlag:@"0473"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterBXPTofStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterBXPTofStatusOperation
                     cmdFlag:@"0478"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterBXPTofMfgCodeListWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterBXPTofMfgCodeListOperation
                     cmdFlag:@"0479"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByPirStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByPirStatusOperation
                     cmdFlag:@"0480"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByPirDetectionStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByPirDetectionStatusOperation
                     cmdFlag:@"0481"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByPirSensorSensitivityWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByPirSensorSensitivityOperation
                     cmdFlag:@"0482"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByPirDoorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByPirDoorStatusOperation
                     cmdFlag:@"0483"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByPirDelayResponseStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByPirDelayResponseStatusOperation
                     cmdFlag:@"0484"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByPirMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByPirMajorRangeOperation
                     cmdFlag:@"0485"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByPirMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByPirMinorRangeOperation
                     cmdFlag:@"0486"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByOtherStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByOtherStatusOperation
                     cmdFlag:@"04f8"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByOtherRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByOtherRelationshipOperation
                     cmdFlag:@"04f9"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readFilterByOtherConditionsWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadFilterByOtherConditionsOperation
                     cmdFlag:@"04fa"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark **************************************** LoRaWAN ************************************************

+ (void)ae_readLorawanNetworkStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanNetworkStatusOperation
                     cmdFlag:@"0500"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanRegionWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanRegionOperation
                     cmdFlag:@"0501"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanModemWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanModemOperation
                     cmdFlag:@"0502"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanDEVEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanDEVEUIOperation
                     cmdFlag:@"0503"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanAPPEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanAPPEUIOperation
                     cmdFlag:@"0504"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanAPPKEYWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanAPPKEYOperation
                     cmdFlag:@"0505"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanDEVADDRWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanDEVADDROperation
                     cmdFlag:@"0506"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanAPPSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanAPPSKEYOperation
                     cmdFlag:@"0507"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanNWKSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanNWKSKEYOperation
                     cmdFlag:@"0508"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanADRACKLimitWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanADRACKLimitOperation
                     cmdFlag:@"050a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanADRACKDelayWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanADRACKDelayOperation
                     cmdFlag:@"050b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanCHWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanCHOperation
                     cmdFlag:@"0520"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanDRWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanDROperation
                     cmdFlag:@"0521"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanUplinkStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanUplinkStrategyOperation
                     cmdFlag:@"0522"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanDutyCycleStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanDutyCycleStatusOperation
                     cmdFlag:@"0523"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanTimeSyncIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanDevTimeSyncIntervalOperation
                     cmdFlag:@"0540"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readLorawanNetworkCheckIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadLorawanNetworkCheckIntervalOperation
                     cmdFlag:@"0541"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readHeartbeatPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadHeartbeatPayloadDataOperation
                     cmdFlag:@"0551"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readEventPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadEventPayloadDataOperation
                     cmdFlag:@"0554"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readPositioningPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadPositioningPayloadDataOperation
                     cmdFlag:@"0555"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readShockPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadShockPayloadDataOperation
                     cmdFlag:@"0557"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readManDownDetectionPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadManDownDetectionPayloadDataOperation
                     cmdFlag:@"0558"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readTamperAlarmPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadTamperAlarmPayloadDataOperation
                     cmdFlag:@"0559"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readGPSLimitPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadGPSLimitPayloadDataOperation
                     cmdFlag:@"055b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************辅助功能************************************************

+ (void)ae_readDownlinkPositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadDownlinkPositioningStrategyOperation
                     cmdFlag:@"0600"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readShockDetectionStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadShockDetectionStatusOperation
                     cmdFlag:@"0610"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readShockThresholdsWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadShockThresholdsOperation
                     cmdFlag:@"0611"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readShockDetectionReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadShockDetectionReportIntervalOperation
                     cmdFlag:@"0612"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readShockTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadShockTimeoutOperation
                     cmdFlag:@"0613"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readManDownDetectionWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadManDownDetectionOperation
                     cmdFlag:@"0620"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readIdleDetectionTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadIdleDetectionTimeoutOperation
                     cmdFlag:@"0621"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readTamperAlarmStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadTamperAlarmStatusOperation
                     cmdFlag:@"0630"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readTamperAlarmThresholdsWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadTamperAlarmThresholdsOperation
                     cmdFlag:@"0631"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readTamperAlarmReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadTamperAlarmReportIntervalOperation
                     cmdFlag:@"0632"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙定位参数************************************************
+ (void)ae_readOfflineFixStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadOfflineFixStatusOperation
                     cmdFlag:@"0800"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readGpsLimitUploadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadGpsLimitUploadStatusOperation
                     cmdFlag:@"0801"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readOutdoorBLEReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadOutdoorBLEReportIntervalOperation
                     cmdFlag:@"0808"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readOutdoorGPSReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadOutdoorGPSReportIntervalOperation
                     cmdFlag:@"0809"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readBluetoothFixMechanismWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBluetoothFixMechanismOperation
                     cmdFlag:@"0820"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readBlePositioningTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBlePositioningTimeoutOperation
                     cmdFlag:@"0821"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readBlePositioningNumberOfMacWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBlePositioningNumberOfMacOperation
                     cmdFlag:@"0822"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readBeaconVoltageReportInBleFixWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadBeaconVoltageReportInBleFixOperation
                     cmdFlag:@"0823"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readGPSFixPositioningTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadGPSFixPositioningTimeoutOperation
                     cmdFlag:@"0830"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)ae_readGPSFixPDOPWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_ae_taskReadGPSFixPDOPOperation
                     cmdFlag:@"0831"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}



#pragma mark - private method

+ (void)readDataWithTaskID:(mk_ae_taskOperationID)taskID
                   cmdFlag:(NSString *)flag
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.ae_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
