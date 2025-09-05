//
//  MKAETaskAdopter.m
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKAETaskAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKAEOperationID.h"
#import "MKAESDKDataAdopter.h"

NSString *const mk_ae_totalNumKey = @"mk_ae_totalNumKey";
NSString *const mk_ae_totalIndexKey = @"mk_ae_totalIndexKey";
NSString *const mk_ae_contentKey = @"mk_ae_contentKey";

@implementation MKAETaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
        //产品型号
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"modeID":tempString} operationID:mk_ae_taskReadDeviceModelOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
        //firmware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"firmware":tempString} operationID:mk_ae_taskReadFirmwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
        //hardware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"hardware":tempString} operationID:mk_ae_taskReadHardwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
        //soft ware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"software":tempString} operationID:mk_ae_taskReadSoftwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
        //manufacturerKey
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"manufacturer":tempString} operationID:mk_ae_taskReadManufacturerOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //密码相关
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *state = @"";
        if (content.length == 12) {
            state = [content substringWithRange:NSMakeRange(10, 2)];
        }
        return [self dataParserGetDataSuccess:@{@"state":state} operationID:mk_ae_connectPasswordOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        return [self parseCustomData:readData];
    }
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    return @{};
}

#pragma mark - 数据解析
+ (NSDictionary *)parseCustomData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *headerString = [readString substringWithRange:NSMakeRange(0, 2)];
    if ([headerString isEqualToString:@"ee"]) {
        //分包协议
        return [self parsePacketData:readData];
    }
    if (![headerString isEqualToString:@"ed"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(8, 2)];
    if (readData.length != dataLen + 5) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 4)];
    NSString *content = [readString substringWithRange:NSMakeRange(10, dataLen * 2)];
    //不分包协议
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parseCustomReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parseCustomConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parsePacketData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 4)];
    if ([flag isEqualToString:@"00"]) {
        //读取
        NSString *totalNum = [MKBLEBaseSDKAdopter getDecimalStringWithHex:readString range:NSMakeRange(8, 2)];
        NSString *index = [MKBLEBaseSDKAdopter getDecimalStringWithHex:readString range:NSMakeRange(10, 2)];
        NSInteger len = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(12, 2)];
        if ([index integerValue] >= [totalNum integerValue]) {
            return @{};
        }
        mk_ae_taskOperationID operationID = mk_ae_defaultTaskOperationID;
        
        NSData *subData = [readData subdataWithRange:NSMakeRange(7, len)];
        NSDictionary *resultDic= @{
            mk_ae_totalNumKey:totalNum,
            mk_ae_totalIndexKey:index,
            mk_ae_contentKey:(subData ? subData : [NSData data]),
        };
        if ([cmd isEqualToString:@"041a"]) {
            //读取Adv Name过滤规则
            operationID = mk_ae_taskReadFilterAdvNameListOperation;
        }
        return [self dataParserGetDataSuccess:resultDic operationID:operationID];
    }
    if ([flag isEqualToString:@"01"]) {
        //配置
        mk_ae_taskOperationID operationID = mk_ae_defaultTaskOperationID;
        NSString *content = [readString substringWithRange:NSMakeRange(10, 2)];
        BOOL success = [content isEqualToString:@"01"];
        
        if ([cmd isEqualToString:@"041a"]) {
            //配置Adv Name过滤规则
            operationID = mk_ae_taskConfigFilterAdvNameListOperation;
        }
        return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
    }
    return @{};
}

+ (NSDictionary *)parseCustomReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_ae_taskOperationID operationID = mk_ae_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    
    if ([cmd isEqualToString:@"0015"]) {
        //读取MAC地址
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[content substringWithRange:NSMakeRange(0, 2)],[content substringWithRange:NSMakeRange(2, 2)],[content substringWithRange:NSMakeRange(4, 2)],[content substringWithRange:NSMakeRange(6, 2)],[content substringWithRange:NSMakeRange(8, 2)],[content substringWithRange:NSMakeRange(10, 2)]];
        resultDic = @{@"macAddress":[macAddress uppercaseString]};
        operationID = mk_ae_taskReadMacAddressOperation;
    }else if ([cmd isEqualToString:@"0021"]) {
        //读取时区
        resultDic = @{
            @"timeZone":[MKBLEBaseSDKAdopter signedHexTurnString:content],
        };
        operationID = mk_ae_taskReadTimeZoneOperation;
    }else if ([cmd isEqualToString:@"0022"]) {
        //读取设备心跳间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadHeartbeatIntervalOperation;
    }else if ([cmd isEqualToString:@"0023"]) {
        //读取指示灯功能
        NSDictionary *indicatorSettings = [MKAESDKDataAdopter fetchIndicatorSettings:content];
        resultDic = @{
            @"indicatorSettings":indicatorSettings,
        };
        operationID = mk_ae_taskReadIndicatorSettingsOperation;
    }else if ([cmd isEqualToString:@"0025"]) {
        //读取霍尔关机功能
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_ae_taskReadHallPowerOffStatusOperation;
    }else if ([cmd isEqualToString:@"0026"]) {
        //读取关机信息上报
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_ae_taskReadShutdownPayloadStatusOperation;
    }else if ([cmd isEqualToString:@"0028"]) {
        //读取三轴唤醒条件
        NSString *threshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *duration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        resultDic = @{
            @"threshold":threshold,
            @"duration":duration,
        };
        operationID = mk_ae_taskReadThreeAxisWakeupConditionsOperation;
    }else if ([cmd isEqualToString:@"0029"]) {
        //读取运动检测判断
        NSString *threshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *duration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        resultDic = @{
            @"threshold":threshold,
            @"duration":duration,
        };
        operationID = mk_ae_taskReadThreeAxisMotionParametersOperation;
    }else if ([cmd isEqualToString:@"0040"]) {
        //读取电池电压
        resultDic = @{
            @"voltage":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadBatteryVoltageOperation;
    }else if ([cmd isEqualToString:@"0041"]) {
        //读取产测状态
        NSString *status = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"status":status,
        };
        operationID = mk_ae_taskReadPCBAStatusOperation;
    }else if ([cmd isEqualToString:@"0042"]) {
        //读取自检故障原因
//        NSString *status = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"status":content,
        };
        operationID = mk_ae_taskReadSelftestStatusOperation;
    }else if ([cmd isEqualToString:@"0101"]) {
        //读取电池信息
        NSString *workTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 8)];
        NSString *advCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 8)];
        NSString *axisWakeupTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(16, 8)];
        NSString *blePostionTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(24, 8)];
        NSString *gpsPostionTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(32, 8)];
        NSString *loraSendCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(40, 8)];
        NSString *loraPowerConsumption = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(48, 8)];
        NSString *batteryPower = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(56, 8)];
        NSString *motionStaticUploadReportTime = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(64, 8)];
        NSString *motionMoveUploadReportTime = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(72, 8)];
        
        resultDic = @{
            @"workTimes":workTimes,
            @"advCount":advCount,
            @"axisWakeupTimes":axisWakeupTimes,
            @"blePostionTimes":blePostionTimes,
            @"gpsPostionTimes":gpsPostionTimes,
            @"loraSendCount":loraSendCount,
            @"loraPowerConsumption":loraPowerConsumption,
            @"batteryPower":batteryPower,
            @"motionStaticUploadReportTime":motionStaticUploadReportTime,
            @"motionMoveUploadReportTime":motionMoveUploadReportTime
        };
        operationID = mk_ae_taskReadBatteryInformationOperation;
    }else if ([cmd isEqualToString:@"0102"]) {
        //读取上一周期电池电量消耗
        NSString *workTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 8)];
        NSString *advCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 8)];
        NSString *axisWakeupTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(16, 8)];
        NSString *blePostionTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(24, 8)];
        NSString *gpsPostionTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(32, 8)];
        NSString *loraSendCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(40, 8)];
        NSString *loraPowerConsumption = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(48, 8)];
        NSString *batteryPower = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(56, 8)];
        NSString *motionStaticUploadReportTime = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(64, 8)];
        NSString *motionMoveUploadReportTime = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(72, 8)];
        
        resultDic = @{
            @"workTimes":workTimes,
            @"advCount":advCount,
            @"axisWakeupTimes":axisWakeupTimes,
            @"blePostionTimes":blePostionTimes,
            @"gpsPostionTimes":gpsPostionTimes,
            @"loraSendCount":loraSendCount,
            @"loraPowerConsumption":loraPowerConsumption,
            @"batteryPower":batteryPower,
            @"motionStaticUploadReportTime":motionStaticUploadReportTime,
            @"motionMoveUploadReportTime":motionMoveUploadReportTime
        };
        operationID = mk_ae_taskReadLastCycleBatteryInformationOperation;
    }else if ([cmd isEqualToString:@"0103"]) {
        //读取所有周期电池电量消耗
        NSString *workTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 8)];
        NSString *advCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 8)];
        NSString *axisWakeupTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(16, 8)];
        NSString *blePostionTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(24, 8)];
        NSString *gpsPostionTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(32, 8)];
        NSString *loraSendCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(40, 8)];
        NSString *loraPowerConsumption = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(48, 8)];
        NSString *batteryPower = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(56, 8)];
        NSString *motionStaticUploadReportTime = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(64, 8)];
        NSString *motionMoveUploadReportTime = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(72, 8)];
        
        resultDic = @{
            @"workTimes":workTimes,
            @"advCount":advCount,
            @"axisWakeupTimes":axisWakeupTimes,
            @"blePostionTimes":blePostionTimes,
            @"gpsPostionTimes":gpsPostionTimes,
            @"loraSendCount":loraSendCount,
            @"loraPowerConsumption":loraPowerConsumption,
            @"batteryPower":batteryPower,
            @"motionStaticUploadReportTime":motionStaticUploadReportTime,
            @"motionMoveUploadReportTime":motionMoveUploadReportTime
        };
        operationID = mk_ae_taskReadAllCycleBatteryInformationOperation;
    }else if ([cmd isEqualToString:@"0106"]) {
        //读取低电触发心跳开关状态
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_ae_taskReadLowPowerPayloadStatusOperation;
    }else if ([cmd isEqualToString:@"0107"]) {
        //读取低电状态下低电信息包上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLowPowerPayloadIntervalOperation;
    }else if ([cmd isEqualToString:@"010a"]) {
        //读取低电判定条件1对应低电电压值
        resultDic = @{
            @"threshold":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLowPowerCondition1VoltageThresholdOperation;
    }else if ([cmd isEqualToString:@"010b"]) {
        //读取低电判定条件1对应最小采样间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLowPowerCondition1MinSampleIntervalOperation;
    }else if ([cmd isEqualToString:@"010c"]) {
        //读取低电判定条件1对应连续采样次数
        resultDic = @{
            @"times":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLowPowerCondition1SampleTimesOperation;
    }else if ([cmd isEqualToString:@"010d"]) {
        //读取低电判定条件2对应低电电压值
        resultDic = @{
            @"threshold":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLowPowerCondition2VoltageThresholdOperation;
    }else if ([cmd isEqualToString:@"010e"]) {
        //读取低电判定条件2对应最小采样间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLowPowerCondition2MinSampleIntervalOperation;
    }else if ([cmd isEqualToString:@"010f"]) {
        //读取低电判定条件2对应连续采样次数
        resultDic = @{
            @"times":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLowPowerCondition2SampleTimesOperation;
    }else if ([cmd isEqualToString:@"0200"]) {
        //读取密码开关
        BOOL need = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"need":@(need)
        };
        operationID = mk_ae_taskReadConnectationNeedPasswordOperation;
    }else if ([cmd isEqualToString:@"0201"]) {
        //读取密码
        NSData *passwordData = [data subdataWithRange:NSMakeRange(5, data.length - 5)];
        NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        resultDic = @{
            @"password":(MKValidStr(password) ? password : @""),
        };
        operationID = mk_ae_taskReadPasswordOperation;
    }else if ([cmd isEqualToString:@"0202"]) {
        //读取广播超时时长
        resultDic = @{
            @"timeout":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadBroadcastTimeoutOperation;
    }else if ([cmd isEqualToString:@"0203"]) {
        //读取Beacon模式开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"0204"]) {
        //读取广播间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadAdvIntervalOperation;
    }else if ([cmd isEqualToString:@"0205"]) {
        //读取设备Tx Power
        NSString *txPower = [MKAESDKDataAdopter fetchTxPowerValueString:content];
        resultDic = @{@"txPower":txPower};
        operationID = mk_ae_taskReadTxPowerOperation;
    }else if ([cmd isEqualToString:@"0206"]) {
        //读取设备广播名称
        NSData *nameData = [data subdataWithRange:NSMakeRange(5, data.length - 5)];
        NSString *deviceName = [[NSString alloc] initWithData:nameData encoding:NSUTF8StringEncoding];
        resultDic = @{
            @"deviceName":(MKValidStr(deviceName) ? deviceName : @""),
        };
        operationID = mk_ae_taskReadDeviceNameOperation;
    }else if ([cmd isEqualToString:@"0300"]) {
        //读取工作模式
        NSString *mode = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"mode":mode,
        };
        operationID = mk_ae_taskReadWorkModeOperation;
    }else if ([cmd isEqualToString:@"0310"]) {
        //读取待机模式定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_ae_taskReadStandbyModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"0320"]) {
        //读取定期模式定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_ae_taskReadPeriodicModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"0321"]) {
        //读取定期模式上报间隔
        NSString *interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"interval":interval,
        };
        operationID = mk_ae_taskReadPeriodicModeReportIntervalOperation;
    }else if ([cmd isEqualToString:@"0330"]) {
        //读取定时模式定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_ae_taskReadTimingModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"0331"]) {
        //读取定时模式时间点
        NSArray *list = [MKAESDKDataAdopter parseTimingModeReportingTimePoint:content];
        
        resultDic = @{
            @"pointList":list,
        };
        operationID = mk_ae_taskReadTimingModeReportingTimePointOperation;
    }else if ([cmd isEqualToString:@"0340"]) {
        //读取运动模式-运动开始事件信息开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadMotionModeEventsNotifyEventOnStartOperation;
    }else if ([cmd isEqualToString:@"0341"]) {
        //读取运动模式-运动开始定位开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadMotionModeEventsFixOnStartOperation;
    }else if ([cmd isEqualToString:@"0342"]) {
        //读取运动开始定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_ae_taskReadMotionModePosStrategyOnStartOperation;
    }else if ([cmd isEqualToString:@"0343"]) {
        //读取运动开始定位上报次数
        NSString *number = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"number":number,
        };
        operationID = mk_ae_taskReadMotionModeNumberOfFixOnStartOperation;
    }else if ([cmd isEqualToString:@"0350"]) {
        //读取运动模式-运动中事件信息开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadMotionModeEventsNotifyEventInTripOperation;
    }else if ([cmd isEqualToString:@"0351"]) {
        //读取运动模式-运动中定位开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadMotionModeEventsFixInTripOperation;
    }else if ([cmd isEqualToString:@"0352"]) {
        //读取运动中定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_ae_taskReadMotionModePosStrategyInTripOperation;
    }else if ([cmd isEqualToString:@"0353"]) {
        //读取运动中定位间隔
        NSString *interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"interval":interval,
        };
        operationID = mk_ae_taskReadMotionModeReportIntervalInTripOperation;
    }else if ([cmd isEqualToString:@"0360"]) {
        //读取运动模式-运动结束事件信息开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadMotionModeEventsNotifyEventOnEndOperation;
    }else if ([cmd isEqualToString:@"0361"]) {
        //读取运动模式-运动结束定位开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadMotionModeEventsFixOnEndOperation;
    }else if ([cmd isEqualToString:@"0362"]) {
        //读取运动结束定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_ae_taskReadMotionModePosStrategyOnEndOperation;
    }else if ([cmd isEqualToString:@"0363"]) {
        //读取运动结束定位间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadMotionModeReportIntervalOnEndOperation;
    }else if ([cmd isEqualToString:@"0364"]) {
        //读取运动结束定位次数
        NSString *number = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"number":number,
        };
        operationID = mk_ae_taskReadMotionModeNumberOfFixOnEndOperation;
    }else if ([cmd isEqualToString:@"0365"]) {
        //读取运动结束判断时间
        NSString *time = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"time":time,
        };
        operationID = mk_ae_taskReadMotionModeTripEndTimeoutOperation;
    }else if ([cmd isEqualToString:@"0370"]) {
        //读取运动模式-静止定位开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadMotionModeEventsFixOnStationaryStateOperation;
    }else if ([cmd isEqualToString:@"0371"]) {
        //读取运动静止状态定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_ae_taskReadPosStrategyOnStationaryOperation;
    }else if ([cmd isEqualToString:@"0372"]) {
        //读取运动禁止状态上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadReportIntervalOnStationaryOperation;
    }else if ([cmd isEqualToString:@"0380"]) {
        //读取定时+定期模式-定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_ae_taskReadTimeSegmentedModeStrategyOperation;
    }else if ([cmd isEqualToString:@"0381"]) {
        //读取定时+定期模式-定时时间段
        NSArray *list = [MKAESDKDataAdopter parseTimeSegmentedModeTimePeriodSetting:content];
        
        resultDic = @{
            @"timeList":list,
        };
        operationID = mk_ae_taskReadTimeSegmentedModeTimePeriodSettingOperation;
    }else if ([cmd isEqualToString:@"0401"]) {
        //读取RSSI过滤规则
        resultDic = @{
            @"rssi":[NSString stringWithFormat:@"%ld",(long)[[MKBLEBaseSDKAdopter signedHexTurnString:content] integerValue]],
        };
        operationID = mk_ae_taskReadRssiFilterValueOperation;
    }else if ([cmd isEqualToString:@"0402"]) {
        //读取广播内容过滤逻辑
        resultDic = @{
            @"relationship":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadFilterRelationshipOperation;
    }else if ([cmd isEqualToString:@"0403"]) {
        //读取过滤设备类型开关
        BOOL other = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        BOOL iBeacon = ([[content substringWithRange:NSMakeRange(2, 2)] isEqualToString:@"01"]);
        BOOL uid = ([[content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"01"]);
        BOOL url = ([[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"]);
        BOOL tlm = ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"]);
        BOOL bxp_acc = ([[content substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"01"]);
        BOOL bxp_th = ([[content substringWithRange:NSMakeRange(12, 2)] isEqualToString:@"01"]);
        BOOL bxp_ts = ([[content substringWithRange:NSMakeRange(14, 2)] isEqualToString:@"01"]);
        BOOL bxp_deviceInfo = ([[content substringWithRange:NSMakeRange(16, 2)] isEqualToString:@"01"]);
        BOOL bxp_button = ([[content substringWithRange:NSMakeRange(18, 2)] isEqualToString:@"01"]);
        BOOL bxp_pir = ([[content substringWithRange:NSMakeRange(20, 2)] isEqualToString:@"01"]);
        BOOL bxp_tof = ([[content substringWithRange:NSMakeRange(22, 2)] isEqualToString:@"01"]);
        BOOL bxp_beacon = ([[content substringWithRange:NSMakeRange(24, 2)] isEqualToString:@"01"]);
        
        resultDic = @{
            @"other":@(other),
            @"iBeacon":@(iBeacon),
            @"uid":@(uid),
            @"url":@(url),
            @"tlm":@(tlm),
            @"bxp_acc":@(bxp_acc),
            @"bxp_th":@(bxp_th),
            @"bxp_ts":@(bxp_ts),
            @"bxp_deviceInfo":@(bxp_deviceInfo),
            @"bxp_button":@(bxp_button),
            @"bxp_pir":@(bxp_pir),
            @"bxp_tof":@(bxp_tof),
            @"bxp_beacon":@(bxp_beacon),
        };
        operationID = mk_ae_taskReadFilterTypeStatusOperation;
    }else if ([cmd isEqualToString:@"0410"]) {
        //读取精准过滤MAC开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterByMacPreciseMatchOperation;
    }else if ([cmd isEqualToString:@"0411"]) {
        //读取反向过滤MAC开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterByMacReverseFilterOperation;
    }else if ([cmd isEqualToString:@"0412"]) {
        //读取MAC过滤列表
        NSArray *macList = [MKAESDKDataAdopter parseFilterMacList:content];
        resultDic = @{
            @"macList":(MKValidArray(macList) ? macList : @[]),
        };
        operationID = mk_ae_taskReadFilterMACAddressListOperation;
    }else if ([cmd isEqualToString:@"0418"]) {
        //读取精准过滤Adv Name开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterByAdvNamePreciseMatchOperation;
    }else if ([cmd isEqualToString:@"0419"]) {
        //读取反向过滤Adv Name开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterByAdvNameReverseFilterOperation;
    }else if ([cmd isEqualToString:@"0420"]) {
        //读取iBeacon类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterByBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"0421"]) {
        //读取iBeacon类型过滤的Major范围
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        resultDic = @{
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_ae_taskReadFilterByBeaconMajorRangeOperation;
    }else if ([cmd isEqualToString:@"0422"]) {
        //读取iBeacon类型过滤的Minor范围
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        resultDic = @{
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_ae_taskReadFilterByBeaconMinorRangeOperation;
    }else if ([cmd isEqualToString:@"0423"]) {
        //读取iBeacon类型过滤的UUID
        resultDic = @{
            @"uuid":content,
        };
        operationID = mk_ae_taskReadFilterByBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"0428"]) {
        //读取UID类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterByUIDStatusOperation;
    }else if ([cmd isEqualToString:@"0429"]) {
        //读取UID类型过滤的Namespace ID
        resultDic = @{
            @"namespaceID":content,
        };
        operationID = mk_ae_taskReadFilterByUIDNamespaceIDOperation;
    }else if ([cmd isEqualToString:@"042a"]) {
        //读取UID类型过滤的Instance ID
        resultDic = @{
            @"instanceID":content,
        };
        operationID = mk_ae_taskReadFilterByUIDInstanceIDOperation;
    }else if ([cmd isEqualToString:@"0430"]) {
        //读取URL类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterByURLStatusOperation;
    }else if ([cmd isEqualToString:@"0431"]) {
        //读取URL类型过滤内容
        NSString *url = @"";
        if (content.length > 0) {
            NSData *urlData = [data subdataWithRange:NSMakeRange(5, data.length - 5)];
            url = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        }
        resultDic = @{
            @"url":(MKValidStr(url) ? url : @""),
        };
        operationID = mk_ae_taskReadFilterByURLContentOperation;
    }else if ([cmd isEqualToString:@"0438"]) {
        //读取TLM类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterByTLMStatusOperation;
    }else if ([cmd isEqualToString:@"0439"]) {
        //读取TLM过滤数据类型
        NSString *version = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"version":version
        };
        operationID = mk_ae_taskReadFilterByTLMVersionOperation;
    }else if ([cmd isEqualToString:@"0440"]) {
        //读取BXP-iBeacon类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterByBXPBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"0441"]) {
        //读取BXP-iBeacon类型过滤的Major范围
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        resultDic = @{
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_ae_taskReadFilterByBXPBeaconMajorRangeOperation;
    }else if ([cmd isEqualToString:@"0442"]) {
        //读取BXP-iBeacon类型过滤的Minor范围
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        resultDic = @{
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_ae_taskReadFilterByBXPBeaconMinorRangeOperation;
    }else if ([cmd isEqualToString:@"0443"]) {
        //读取BXP-iBeacon类型过滤的UUID
        resultDic = @{
            @"uuid":content,
        };
        operationID = mk_ae_taskReadFilterByBXPBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"0450"]) {
        //读取BeaconX Pro-ACC设备过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadBXPAccFilterStatusOperation;
    }else if ([cmd isEqualToString:@"0458"]) {
        //读取BeaconX Pro-T&H设备过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadBXPTHFilterStatusOperation;
    }else if ([cmd isEqualToString:@"0460"]) {
        //读取BXP-DeviceInfo类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadBXPDeviceInfoFilterStatusOperation;
    }else if ([cmd isEqualToString:@"0468"]) {
        //读取BXP-Button过滤条件开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadBXPButtonFilterStatusOperation;
    }else if ([cmd isEqualToString:@"0469"]) {
        //读取BXP-Button报警过滤开关
        BOOL singlePresse = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        BOOL doublePresse = ([[content substringWithRange:NSMakeRange(2, 2)] isEqualToString:@"01"]);
        BOOL longPresse = ([[content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"01"]);
        BOOL abnormal = ([[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"]);
        resultDic = @{
            @"singlePresse":@(singlePresse),
            @"doublePresse":@(doublePresse),
            @"longPresse":@(longPresse),
            @"abnormal":@(abnormal),
        };
        operationID = mk_ae_taskReadBXPButtonAlarmFilterStatusOperation;
    }else if ([cmd isEqualToString:@"0470"]) {
        //读取BXP-T&S TagID类型开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterByBXPTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"0471"]) {
        //读取BXP-T&S TagID类型精准过滤tagID开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadPreciseMatchTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"0472"]) {
        //读取读取BXP-T&S TagID类型反向过滤tagID开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadReverseFilterTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"0473"]) {
        //读取BXP-T&S TagID过滤规则
        NSArray *tagIDList = [MKAESDKDataAdopter parseFilterMacList:content];
        resultDic = @{
            @"tagIDList":(MKValidArray(tagIDList) ? tagIDList : @[]),
        };
        operationID = mk_ae_taskReadFilterBXPTagIDListOperation;
    }else if ([cmd isEqualToString:@"0478"]) {
        //读取BXP-TOF设备过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterBXPTofStatusOperation;
    }else if ([cmd isEqualToString:@"0479"]) {
        //读取BXP-TOF设备过滤MFG code
        NSArray *codeList = [MKAESDKDataAdopter parseFilterMacList:content];
        resultDic = @{
            @"codeList":(MKValidArray(codeList) ? codeList : @[]),
        };
        operationID = mk_ae_taskReadFilterBXPTofMfgCodeListOperation;
    }else if ([cmd isEqualToString:@"0480"]) {
        //读取PIR过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterByPirStatusOperation;
    }else if ([cmd isEqualToString:@"0481"]) {
        //读取PIR设备过滤sensor_detection_status
        NSString *status = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"status":status,
        };
        operationID = mk_ae_taskReadFilterByPirDetectionStatusOperation;
    }else if ([cmd isEqualToString:@"0482"]) {
        //读取PIR设备过滤sensor_sensitivity
        NSString *sensitivity = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"sensitivity":sensitivity,
        };
        operationID = mk_ae_taskReadFilterByPirSensorSensitivityOperation;
    }else if ([cmd isEqualToString:@"0483"]) {
        //读取PIR设备过滤door_status
        NSString *status = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"status":status,
        };
        operationID = mk_ae_taskReadFilterByPirDoorStatusOperation;
    }else if ([cmd isEqualToString:@"0484"]) {
        //读取PIR设备过滤delay_response_status
        NSString *status = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"status":status,
        };
        operationID = mk_ae_taskReadFilterByPirDelayResponseStatusOperation;
    }else if ([cmd isEqualToString:@"0485"]) {
        //读取PIR设备Major过滤范围
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        resultDic = @{
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_ae_taskReadFilterByPirMajorRangeOperation;
    }else if ([cmd isEqualToString:@"0486"]) {
        //读取PIR设备Minor过滤范围
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        resultDic = @{
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_ae_taskReadFilterByPirMinorRangeOperation;
    }else if ([cmd isEqualToString:@"04f8"]) {
        //读取Other过滤条件开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadFilterByOtherStatusOperation;
    }else if ([cmd isEqualToString:@"04f9"]) {
        //读取Other过滤条件的逻辑关系
        NSString *relationship = [MKAESDKDataAdopter parseOtherRelationship:content];
        resultDic = @{
            @"relationship":relationship,
        };
        operationID = mk_ae_taskReadFilterByOtherRelationshipOperation;
    }else if ([cmd isEqualToString:@"04fa"]) {
        //读取Other的过滤条件列表
        NSArray *conditionList = [MKAESDKDataAdopter parseOtherFilterConditionList:content];
        resultDic = @{
            @"conditionList":conditionList,
        };
        operationID = mk_ae_taskReadFilterByOtherConditionsOperation;
    }else if ([cmd isEqualToString:@"0500"]) {
        //读取LoRaWAN网络状态
        resultDic = @{
            @"status":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLorawanNetworkStatusOperation;
    }else if ([cmd isEqualToString:@"0501"]) {
        //读取LoRaWAN频段
        resultDic = @{
            @"region":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLorawanRegionOperation;
    }else if ([cmd isEqualToString:@"0502"]) {
        //读取LoRaWAN入网类型
        resultDic = @{
            @"modem":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLorawanModemOperation;
    }else if ([cmd isEqualToString:@"0503"]) {
        //读取LoRaWAN DEVEUI
        resultDic = @{
            @"devEUI":content,
        };
        operationID = mk_ae_taskReadLorawanDEVEUIOperation;
    }else if ([cmd isEqualToString:@"0504"]) {
        //读取LoRaWAN APPEUI
        resultDic = @{
            @"appEUI":content
        };
        operationID = mk_ae_taskReadLorawanAPPEUIOperation;
    }else if ([cmd isEqualToString:@"0505"]) {
        //读取LoRaWAN APPKEY
        resultDic = @{
            @"appKey":content
        };
        operationID = mk_ae_taskReadLorawanAPPKEYOperation;
    }else if ([cmd isEqualToString:@"0506"]) {
        //读取LoRaWAN DEVADDR
        resultDic = @{
            @"devAddr":content
        };
        operationID = mk_ae_taskReadLorawanDEVADDROperation;
    }else if ([cmd isEqualToString:@"0507"]) {
        //读取LoRaWAN APPSKEY
        resultDic = @{
            @"appSkey":content
        };
        operationID = mk_ae_taskReadLorawanAPPSKEYOperation;
    }else if ([cmd isEqualToString:@"0508"]) {
        //读取LoRaWAN nwkSkey
        resultDic = @{
            @"nwkSkey":content
        };
        operationID = mk_ae_taskReadLorawanNWKSKEYOperation;
    }else if ([cmd isEqualToString:@"050a"]) {
        //读取ADR_ACK_LIMIT
        resultDic = @{
            @"value":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLorawanADRACKLimitOperation;
    }else if ([cmd isEqualToString:@"050b"]) {
        //读取ADR_ACK_DELAY
        resultDic = @{
            @"value":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLorawanADRACKDelayOperation;
    }else if ([cmd isEqualToString:@"0520"]) {
        //读取LoRaWAN CH
        resultDic = @{
            @"CHL":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"CHH":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)]
        };
        operationID = mk_ae_taskReadLorawanCHOperation;
    }else if ([cmd isEqualToString:@"0521"]) {
        //读取LoRaWAN DR
        resultDic = @{
            @"DR":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLorawanDROperation;
    }else if ([cmd isEqualToString:@"0522"]) {
        //读取LoRaWAN 数据发送策略
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *transmissions = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        NSString *DRL = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)];
        NSString *DRH = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 2)];
        resultDic = @{
            @"isOn":@(isOn),
            @"transmissions":transmissions,
            @"DRL":DRL,
            @"DRH":DRH,
        };
        operationID = mk_ae_taskReadLorawanUplinkStrategyOperation;
    }else if ([cmd isEqualToString:@"0523"]) {
        //读取LoRaWAN duty cycle
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadLorawanDutyCycleStatusOperation;
    }else if ([cmd isEqualToString:@"0540"]) {
        //读取LoRaWAN devtime指令同步间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLorawanDevTimeSyncIntervalOperation;
    }else if ([cmd isEqualToString:@"0541"]) {
        //读取LoRaWAN LinkCheckReq指令间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadLorawanNetworkCheckIntervalOperation;
    }else if ([cmd isEqualToString:@"0551"]) {
        //读取心跳数据包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_ae_taskReadHeartbeatPayloadDataOperation;
    }else if ([cmd isEqualToString:@"0552"]) {
        //读取低电信息包上行配置
        NSString *payloadType = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *number = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        resultDic = @{
            @"type":payloadType,
            @"retransmissionTimes":number,
        };
        operationID = mk_ae_taskReadLowPowerPayloadDataOperation;
    }else if ([cmd isEqualToString:@"0554"]) {
        //读取事件信息包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_ae_taskReadEventPayloadDataOperation;
    }else if ([cmd isEqualToString:@"0555"]) {
        //读取定位包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_ae_taskReadPositioningPayloadDataOperation;
    }else if ([cmd isEqualToString:@"0557"]) {
        //读取震动检测包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_ae_taskReadShockPayloadDataOperation;
    }else if ([cmd isEqualToString:@"0558"]) {
        //读取闲置检测包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_ae_taskReadManDownDetectionPayloadDataOperation;
    }else if ([cmd isEqualToString:@"0559"]) {
        //读取防拆报警检测包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_ae_taskReadTamperAlarmPayloadDataOperation;
    }else if ([cmd isEqualToString:@"055b"]) {
        //读取GPS极限定位包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_ae_taskReadGPSLimitPayloadDataOperation;
    }else if ([cmd isEqualToString:@"0600"]) {
        //读取下行请求定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_ae_taskReadDownlinkPositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"0610"]) {
        //读取震动检测开关状态
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadShockDetectionStatusOperation;
    }else if ([cmd isEqualToString:@"0611"]) {
        //读取震动检测阈值
        NSString *threshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"threshold":threshold,
        };
        operationID = mk_ae_taskReadShockThresholdsOperation;
    }else if ([cmd isEqualToString:@"0612"]) {
        //读取震动上发间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadShockDetectionReportIntervalOperation;
    }else if ([cmd isEqualToString:@"0613"]) {
        //读取震动次数判断间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadShockTimeoutOperation;
    }else if ([cmd isEqualToString:@"0620"]) {
        //读取闲置功能使能
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadManDownDetectionOperation;
    }else if ([cmd isEqualToString:@"0621"]) {
        //读取闲置超时时间
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadIdleDetectionTimeoutOperation;
    }else if ([cmd isEqualToString:@"0630"]) {
        //读取防拆报警开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadTamperAlarmStatusOperation;
    }else if ([cmd isEqualToString:@"0631"]) {
        //读取防拆报警阈值
        NSString *threshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"threshold":threshold,
        };
        operationID = mk_ae_taskReadTamperAlarmThresholdsOperation;
    }else if ([cmd isEqualToString:@"0632"]) {
        //读取防拆报警上传间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadTamperAlarmReportIntervalOperation;
    }else if ([cmd isEqualToString:@"0800"]) {
        //读取离线定位功能开关状态
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_ae_taskReadOfflineFixStatusOperation;
    }else if ([cmd isEqualToString:@"0801"]) {
        //读取GPS极限上传开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadGpsLimitUploadStatusOperation;
    }else if ([cmd isEqualToString:@"0808"]) {
        //读取室外蓝牙定位上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadOutdoorBLEReportIntervalOperation;
    }else if ([cmd isEqualToString:@"0809"]) {
        //读取室外GPS定位上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadOutdoorGPSReportIntervalOperation;
    }else if ([cmd isEqualToString:@"0820"]) {
        //读取蓝牙定位机制
        resultDic = @{
            @"priority":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadBluetoothFixMechanismOperation;
    }else if ([cmd isEqualToString:@"0821"]) {
        //读取蓝牙定位超时时间
        resultDic = @{
            @"timeout":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadBlePositioningTimeoutOperation;
    }else if ([cmd isEqualToString:@"0822"]) {
        //读取蓝牙定位MAC数量
        resultDic = @{
            @"number":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadBlePositioningNumberOfMacOperation;
    }else if ([cmd isEqualToString:@"0823"]) {
        //读取蓝牙beacon电压上报开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_ae_taskReadBeaconVoltageReportInBleFixOperation;
    }else if ([cmd isEqualToString:@"0830"]) {
        //读取GPS定位超时时间
        resultDic = @{
            @"timeout":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadGPSFixPositioningTimeoutOperation;
    }else if ([cmd isEqualToString:@"0831"]) {
        //读取GPS定位PDOP
        resultDic = @{
            @"pdop":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_ae_taskReadGPSFixPDOPOperation;
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseCustomConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_ae_taskOperationID operationID = mk_ae_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"01"];
    
    if ([cmd isEqualToString:@"01"]) {
        //
    }else if ([cmd isEqualToString:@"0000"]) {
        //关机
        operationID = mk_ae_taskPowerOffOperation;
    }else if ([cmd isEqualToString:@"0001"]) {
        //配置LoRaWAN 入网
        operationID = mk_ae_taskRestartDeviceOperation;
    }else if ([cmd isEqualToString:@"0002"]) {
        //恢复出厂设置
        operationID = mk_ae_taskFactoryResetOperation;
    }else if ([cmd isEqualToString:@"0020"]) {
        //配置时间戳
        operationID = mk_ae_taskConfigDeviceTimeOperation;
    }else if ([cmd isEqualToString:@"0021"]) {
        //配置时区
        operationID = mk_ae_taskConfigTimeZoneOperation;
    }else if ([cmd isEqualToString:@"0022"]) {
        //配置设备心跳间隔
        operationID = mk_ae_taskConfigHeartbeatIntervalOperation;
    }else if ([cmd isEqualToString:@"0023"]) {
        //配置指示灯开关状态
        operationID = mk_ae_taskConfigIndicatorSettingsOperation;
    }else if ([cmd isEqualToString:@"0025"]) {
        //配置霍尔关机功能
        operationID = mk_ae_taskConfigHallPowerOffStatusOperation;
    }else if ([cmd isEqualToString:@"0026"]) {
        //配置关机信息上报状态
        operationID = mk_ae_taskConfigShutdownPayloadStatusOperation;
    }else if ([cmd isEqualToString:@"0028"]) {
        //配置三轴唤醒条件
        operationID = mk_ae_taskConfigThreeAxisWakeupConditionsOperation;
    }else if ([cmd isEqualToString:@"0029"]) {
        //配置运动检测判断
        operationID = mk_ae_taskConfigThreeAxisMotionParametersOperation;
    }else if ([cmd isEqualToString:@"0100"]) {
        //清除电池电量数据
        operationID = mk_ae_taskBatteryResetOperation;
    }else if ([cmd isEqualToString:@"0106"]) {
        //配置低电触发心跳开关状态
        operationID = mk_ae_taskConfigLowPowerPayloadStatusOperation;
    }else if ([cmd isEqualToString:@"0107"]) {
        //配置低电状态下低电信息包上报间隔
        operationID = mk_ae_taskConfigLowPowerPayloadIntervalOperation;
    }else if ([cmd isEqualToString:@"010a"]) {
        //配置低电判定条件1对应低电电压值
        operationID = mk_ae_taskConfigLowPowerCondition1VoltageThresholdOperation;
    }else if ([cmd isEqualToString:@"010b"]) {
        //配置低电判定条件1对应最小采样间隔
        operationID = mk_ae_taskConfigLowPowerCondition1MinSampleIntervalOperation;
    }else if ([cmd isEqualToString:@"010c"]) {
        //配置低电判定条件1对应连续采样次数
        operationID = mk_ae_taskConfigLowPowerCondition1SampleTimesOperation;
    }else if ([cmd isEqualToString:@"010d"]) {
        //配置低电判定条件2对应低电电压值
        operationID = mk_ae_taskConfigLowPowerCondition2VoltageThresholdOperation;
    }else if ([cmd isEqualToString:@"010e"]) {
        //配置低电判定条件2对应最小采样间隔
        operationID = mk_ae_taskConfigLowPowerCondition2MinSampleIntervalOperation;
    }else if ([cmd isEqualToString:@"010f"]) {
        //配置低电判定条件2对应连续采样次数
        operationID = mk_ae_taskConfigLowPowerCondition2SampleTimesOperation;
    }else if ([cmd isEqualToString:@"0200"]) {
        //配置是否需要连接密码
        operationID = mk_ae_taskConfigNeedPasswordOperation;
    }else if ([cmd isEqualToString:@"0201"]) {
        //配置连接密码
        operationID = mk_ae_taskConfigPasswordOperation;
    }else if ([cmd isEqualToString:@"0202"]) {
        //配置蓝牙广播超时时间
        operationID = mk_ae_taskConfigBroadcastTimeoutOperation;
    }else if ([cmd isEqualToString:@"0203"]) {
        //配置Beacon模式开关
        operationID = mk_ae_taskConfigBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"0204"]) {
        //配置广播间隔
        operationID = mk_ae_taskConfigAdvIntervalOperation;
    }else if ([cmd isEqualToString:@"0205"]) {
        //配置蓝牙TX Power
        operationID = mk_ae_taskConfigTxPowerOperation;
    }else if ([cmd isEqualToString:@"0206"]) {
        //配置蓝牙广播名称
        operationID = mk_ae_taskConfigDeviceNameOperation;
    }else if ([cmd isEqualToString:@"0300"]) {
        //配置工作模式
        operationID = mk_ae_taskConfigWorkModeOperation;
    }else if ([cmd isEqualToString:@"0310"]) {
        //配置待机模式定位策略
        operationID = mk_ae_taskConfigStandbyModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"0320"]) {
        //设置定期模式定位策略
        operationID = mk_ae_taskConfigPeriodicModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"0321"]) {
        //设置定期模式上报间隔
        operationID = mk_ae_taskConfigPeriodicModeReportIntervalOperation;
    }else if ([cmd isEqualToString:@"0330"]) {
        //设置定时模式定位策略
        operationID = mk_ae_taskConfigTimingModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"0331"]) {
        //设置定时模式时间点
        operationID = mk_ae_taskConfigTimingModeReportingTimePointOperation;
    }else if ([cmd isEqualToString:@"0340"]) {
        //配置运动模式-运动开始事件信息开关
        operationID = mk_ae_taskConfigMotionModeEventsNotifyEventOnStartOperation;
    }else if ([cmd isEqualToString:@"0341"]) {
        //配置运动模式-运动开始定位开关
        operationID = mk_ae_taskConfigMotionModeEventsFixOnStartOperation;
    }else if ([cmd isEqualToString:@"0342"]) {
        //设置运动开始定位策略
        operationID = mk_ae_taskConfigMotionModePosStrategyOnStartOperation;
    }else if ([cmd isEqualToString:@"0343"]) {
        //设置运动开始定位上报次数
        operationID = mk_ae_taskConfigMotionModeNumberOfFixOnStartOperation;
    }else if ([cmd isEqualToString:@"0350"]) {
        //配置运动模式-运动中事件信息开关
        operationID = mk_ae_taskConfigMotionModeEventsNotifyEventInTripOperation;
    }else if ([cmd isEqualToString:@"0351"]) {
        //配置运动模式-运动中定位开关
        operationID = mk_ae_taskConfigMotionModeEventsFixInTripOperation;
    }else if ([cmd isEqualToString:@"0352"]) {
        //设置运动中定位策略
        operationID = mk_ae_taskConfigMotionModePosStrategyInTripOperation;
    }else if ([cmd isEqualToString:@"0353"]) {
        //设置运动中定位间隔
        operationID = mk_ae_taskConfigMotionModeReportIntervalInTripOperation;
    }else if ([cmd isEqualToString:@"0360"]) {
        //配置运动模式-运动结束事件信息开关
        operationID = mk_ae_taskConfigMotionModeEventsNotifyEventOnEndOperation;
    }else if ([cmd isEqualToString:@"0361"]) {
        //配置运动模式-运动结束定位开关
        operationID = mk_ae_taskConfigMotionModeEventsFixOnEndOperation;
    }else if ([cmd isEqualToString:@"0362"]) {
        //设置运动结束定位策略
        operationID = mk_ae_taskConfigMotionModePosStrategyOnEndOperation;
    }else if ([cmd isEqualToString:@"0363"]) {
        //设置运动结束定位间隔
        operationID = mk_ae_taskConfigMotionModeReportIntervalOnEndOperation;
    }else if ([cmd isEqualToString:@"0364"]) {
        //设置运动结束定位次数
        operationID = mk_ae_taskConfigMotionModeNumberOfFixOnEndOperation;
    }else if ([cmd isEqualToString:@"0365"]) {
        //设置运动结束判断时间
        operationID = mk_ae_taskConfigMotionModeTripEndTimeoutOperation;
    }else if ([cmd isEqualToString:@"0370"]) {
        //配置运动模式-静止定位开关
        operationID = mk_ae_taskConfigMotionModeEventsFixOnStationaryStateOperation;
    }else if ([cmd isEqualToString:@"0371"]) {
        //配置运动静止状态定位策略
        operationID = mk_ae_taskConfigPosStrategyOnStationaryOperation;
    }else if ([cmd isEqualToString:@"0372"]) {
        //配置运动禁止状态上报间隔
        operationID = mk_ae_taskConfigReportIntervalOnStationaryOperation;
    }else if ([cmd isEqualToString:@"0380"]) {
        //配置定时+定期模式-定位策略
        operationID = mk_ae_taskConfigTimeSegmentedModeStrategyOperation;
    }else if ([cmd isEqualToString:@"0381"]) {
        //定时+定期模式-定时时间段
        operationID = mk_ae_taskConfigTimeSegmentedModeTimePeriodSettingOperation;
    }else if ([cmd isEqualToString:@"0401"]) {
        //配置rssi过滤规则
        operationID = mk_ae_taskConfigRssiFilterValueOperation;
    }else if ([cmd isEqualToString:@"0402"]) {
        //配置广播内容过滤逻辑
        operationID = mk_ae_taskConfigFilterRelationshipOperation;
    }else if ([cmd isEqualToString:@"0410"]) {
        //配置精准过滤MAC开关
        operationID = mk_ae_taskConfigFilterByMacPreciseMatchOperation;
    }else if ([cmd isEqualToString:@"0411"]) {
        //配置反向过滤MAC开关
        operationID = mk_ae_taskConfigFilterByMacReverseFilterOperation;
    }else if ([cmd isEqualToString:@"0412"]) {
        //配置MAC过滤规则
        operationID = mk_ae_taskConfigFilterMACAddressListOperation;
    }else if ([cmd isEqualToString:@"0418"]) {
        //配置精准过滤Adv Name开关
        operationID = mk_ae_taskConfigFilterByAdvNamePreciseMatchOperation;
    }else if ([cmd isEqualToString:@"0419"]) {
        //配置反向过滤Adv Name开关
        operationID = mk_ae_taskConfigFilterByAdvNameReverseFilterOperation;
    }else if ([cmd isEqualToString:@"0420"]) {
        //配置iBeacon类型过滤开关
        operationID = mk_ae_taskConfigFilterByBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"0421"]) {
        //配置iBeacon类型过滤Major范围
        operationID = mk_ae_taskConfigFilterByBeaconMajorOperation;
    }else if ([cmd isEqualToString:@"0422"]) {
        //配置iBeacon类型过滤Minor范围
        operationID = mk_ae_taskConfigFilterByBeaconMinorOperation;
    }else if ([cmd isEqualToString:@"0423"]) {
        //配置iBeacon类型过滤UUID
        operationID = mk_ae_taskConfigFilterByBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"0428"]) {
        //配置UID类型过滤开关
        operationID = mk_ae_taskConfigFilterByUIDStatusOperation;
    }else if ([cmd isEqualToString:@"0429"]) {
        //配置UID类型过滤Namespace ID.
        operationID = mk_ae_taskConfigFilterByUIDNamespaceIDOperation;
    }else if ([cmd isEqualToString:@"042a"]) {
        //配置UID类型过滤Instace ID.
        operationID = mk_ae_taskConfigFilterByUIDInstanceIDOperation;
    }else if ([cmd isEqualToString:@"0430"]) {
        //配置URL类型过滤开关
        operationID = mk_ae_taskConfigFilterByURLStatusOperation;
    }else if ([cmd isEqualToString:@"0431"]) {
        //配置URL类型过滤的内容
        operationID = mk_ae_taskConfigFilterByURLContentOperation;
    }else if ([cmd isEqualToString:@"0438"]) {
        //配置TLM类型开关
        operationID = mk_ae_taskConfigFilterByTLMStatusOperation;
    }else if ([cmd isEqualToString:@"0439"]) {
        //配置TLM过滤数据类型
        operationID = mk_ae_taskConfigFilterByTLMVersionOperation;
    }else if ([cmd isEqualToString:@"0440"]) {
        //配置BXP-iBeacon类型过滤开关
        operationID = mk_ae_taskConfigFilterByBXPBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"0441"]) {
        //配置BXP-iBeacon类型过滤Major范围
        operationID = mk_ae_taskConfigFilterByBXPBeaconMajorOperation;
    }else if ([cmd isEqualToString:@"0442"]) {
        //配置BXP-iBeacon类型过滤Minor范围
        operationID = mk_ae_taskConfigFilterByBXPBeaconMinorOperation;
    }else if ([cmd isEqualToString:@"0443"]) {
        //配置BXP-iBeacon类型过滤UUID
        operationID = mk_ae_taskConfigFilterByBXPBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"0450"]) {
        //配置BeaconX Pro-ACC设备过滤开关
        operationID = mk_ae_taskConfigBXPAccFilterStatusOperation;
    }else if ([cmd isEqualToString:@"0458"]) {
        //配置BeaconX Pro-TH设备过滤开关
        operationID = mk_ae_taskConfigBXPTHFilterStatusOperation;
    }else if ([cmd isEqualToString:@"0460"]) {
        //配置BXP-DeviceInfo过滤开关
        operationID = mk_ae_taskConfigFilterByBXPDeviceInfoStatusOperation;
    }else if ([cmd isEqualToString:@"0468"]) {
        //配置BXP-Button过滤开关
        operationID = mk_ae_taskConfigFilterByBXPButtonStatusOperation;
    }else if ([cmd isEqualToString:@"0469"]) {
        //配置BXP-Button类型过滤内容
        operationID = mk_ae_taskConfigFilterByBXPButtonAlarmStatusOperation;
    }else if ([cmd isEqualToString:@"0470"]) {
        //配置BXP-T&S TagID类型过滤开关
        operationID = mk_ae_taskConfigFilterByBXPTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"0471"]) {
        //配置BXP-T&S TagID类型精准过滤Tag-ID开关
        operationID = mk_ae_taskConfigPreciseMatchTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"0472"]) {
        //配置BXP-T&S TagID类型反向过滤Tag-ID开关
        operationID = mk_ae_taskConfigReverseFilterTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"0473"]) {
        //配置BXP-T&S TagID过滤规则
        operationID = mk_ae_taskConfigFilterBXPTagIDListOperation;
    }else if ([cmd isEqualToString:@"0478"]) {
        //配置BXP-TOF设备过滤开关
        operationID = mk_ae_taskConfigFilterByTofStatusOperation;
    }else if ([cmd isEqualToString:@"0479"]) {
        //配置BXP-TOF设备过滤开关
        operationID = mk_ae_taskConfigFilterBXPTofListOperation;
    }else if ([cmd isEqualToString:@"0480"]) {
        //配置PIR设备过滤开关
        operationID = mk_ae_taskConfigFilterByPirStatusOperation;
    }else if ([cmd isEqualToString:@"0481"]) {
        //配置PIR设备过滤sensor_detection_status
        operationID = mk_ae_taskConfigFilterByPirDetectionStatusOperation;
    }else if ([cmd isEqualToString:@"0482"]) {
        //配置PIR设备过滤sensor_sensitivity
        operationID = mk_ae_taskConfigFilterByPirSensorSensitivityOperation;
    }else if ([cmd isEqualToString:@"0483"]) {
        //配置PIR设备过滤door_status
        operationID = mk_ae_taskConfigFilterByPirDoorStatusOperation;
    }else if ([cmd isEqualToString:@"0484"]) {
        //配置PIR设备过滤delay_response_status
        operationID = mk_ae_taskConfigFilterByPirDelayResponseStatusOperation;
    }else if ([cmd isEqualToString:@"0485"]) {
        //配置PIR设备Major过滤范围
        operationID = mk_ae_taskConfigFilterByPirMajorOperation;
    }else if ([cmd isEqualToString:@"0486"]) {
        //配置PIR设备Minor过滤范围
        operationID = mk_ae_taskConfigFilterByPirMinorOperation;
    }else if ([cmd isEqualToString:@"04f8"]) {
        //配置Other过滤关系开关
        operationID = mk_ae_taskConfigFilterByOtherStatusOperation;
    }else if ([cmd isEqualToString:@"04f9"]) {
        //配置Other过滤条件逻辑关系
        operationID = mk_ae_taskConfigFilterByOtherRelationshipOperation;
    }else if ([cmd isEqualToString:@"04fa"]) {
        //配置Other过滤条件列表
        operationID = mk_ae_taskConfigFilterByOtherConditionsOperation;
    }else if ([cmd isEqualToString:@"0501"]) {
        //配置LoRaWAN频段
        operationID = mk_ae_taskConfigRegionOperation;
    }else if ([cmd isEqualToString:@"0502"]) {
        //配置LoRaWAN入网类型
        operationID = mk_ae_taskConfigModemOperation;
    }else if ([cmd isEqualToString:@"0503"]) {
        //配置LoRaWAN DEVEUI
        operationID = mk_ae_taskConfigDEVEUIOperation;
    }else if ([cmd isEqualToString:@"0504"]) {
        //配置LoRaWAN APPEUI
        operationID = mk_ae_taskConfigAPPEUIOperation;
    }else if ([cmd isEqualToString:@"0505"]) {
        //配置LoRaWAN APPKEY
        operationID = mk_ae_taskConfigAPPKEYOperation;
    }else if ([cmd isEqualToString:@"0506"]) {
        //配置LoRaWAN DEVADDR
        operationID = mk_ae_taskConfigDEVADDROperation;
    }else if ([cmd isEqualToString:@"0507"]) {
        //配置LoRaWAN APPSKEY
        operationID = mk_ae_taskConfigAPPSKEYOperation;
    }else if ([cmd isEqualToString:@"0508"]) {
        //配置LoRaWAN nwkSkey
        operationID = mk_ae_taskConfigNWKSKEYOperation;
    }else if ([cmd isEqualToString:@"050a"]) {
        //配置ADR_ACK_LIMIT
        operationID = mk_ae_taskConfigLorawanADRACKLimitOperation;
    }else if ([cmd isEqualToString:@"050b"]) {
        //配置ADR_ACK_DELAY
        operationID = mk_ae_taskConfigLorawanADRACKDelayOperation;
    }else if ([cmd isEqualToString:@"0520"]) {
        //配置LoRaWAN CH
        operationID = mk_ae_taskConfigCHValueOperation;
    }else if ([cmd isEqualToString:@"0521"]) {
        //配置LoRaWAN DR
        operationID = mk_ae_taskConfigDRValueOperation;
    }else if ([cmd isEqualToString:@"0522"]) {
        //配置LoRaWAN 数据发送策略
        operationID = mk_ae_taskConfigUplinkStrategyOperation;
    }else if ([cmd isEqualToString:@"0523"]) {
        //配置LoRaWAN duty cycle
        operationID = mk_ae_taskConfigDutyCycleStatusOperation;
    }else if ([cmd isEqualToString:@"0540"]) {
        //配置LoRaWAN devtime指令同步间隔
        operationID = mk_ae_taskConfigTimeSyncIntervalOperation;
    }else if ([cmd isEqualToString:@"0541"]) {
        //配置LoRaWAN LinkCheckReq指令间隔
        operationID = mk_ae_taskConfigNetworkCheckIntervalOperation;
    }else if ([cmd isEqualToString:@"0551"]) {
        //配置心跳包上行配置
        operationID = mk_ae_taskConfigHeartbeatPayloadOperation;
    }else if ([cmd isEqualToString:@"0552"]) {
        //配置低电信息包上行配置
        operationID = mk_ae_taskConfigLowPowerPayloadOperation;
    }else if ([cmd isEqualToString:@"0554"]) {
        //配置事件信息包上行配置
        operationID = mk_ae_taskConfigEventPayloadWithMessageTypeOperation;
    }else if ([cmd isEqualToString:@"0555"]) {
        //配置定位包上行配置
        operationID = mk_ae_taskConfigPositioningPayloadOperation;
    }else if ([cmd isEqualToString:@"0557"]) {
        //配置震动检测包上行配置
        operationID = mk_ae_taskConfigShockPayloadOperation;
    }else if ([cmd isEqualToString:@"0558"]) {
        //配置闲置检测包上行配置
        operationID = mk_ae_taskConfigManDownDetectionPayloadOperation;
    }else if ([cmd isEqualToString:@"0559"]) {
        //配置防拆报警检测包上行配置
        operationID = mk_ae_taskConfigTamperAlarmPayloadOperation;
    }else if ([cmd isEqualToString:@"055b"]) {
        //配置GPS极限定位包上行配置
        operationID = mk_ae_taskConfigGPSLimitPayloadOperation;
    }else if ([cmd isEqualToString:@"0600"]) {
        //配置下行请求定位策略
        operationID = mk_ae_taskConfigDownlinkPositioningStrategyyOperation;
    }else if ([cmd isEqualToString:@"0610"]) {
        //配置震动检测使能
        operationID = mk_ae_taskConfigShockDetectionStatusOperation;
    }else if ([cmd isEqualToString:@"0611"]) {
        //配置震动检测阈值
        operationID = mk_ae_taskConfigShockThresholdsOperation;
    }else if ([cmd isEqualToString:@"0612"]) {
        //配置震动上发间隔
        operationID = mk_ae_taskConfigShockDetectionReportIntervalOperation;
    }else if ([cmd isEqualToString:@"0613"]) {
        //配置震动次数判断间隔
        operationID = mk_ae_taskConfigShockTimeoutOperation;
    }else if ([cmd isEqualToString:@"0620"]) {
        //配置闲置功能使能
        operationID = mk_ae_taskConfigManDownDetectionStatusOperation;
    }else if ([cmd isEqualToString:@"0621"]) {
        //配置闲置超时时间
        operationID = mk_ae_taskConfigIdleDetectionTimeoutOperation;
    }else if ([cmd isEqualToString:@"0622"]) {
        //闲置状态清除
        operationID = mk_ae_taskConfigIdleStutasResetOperation;
    }else if ([cmd isEqualToString:@"0630"]) {
        //配置防拆报警开关
        operationID = mk_ae_taskConfigTamperAlarmStatusOperation;
    }else if ([cmd isEqualToString:@"0631"]) {
        //配置防拆报警阈值
        operationID = mk_ae_taskConfigTamperAlarmThresholdsOperation;
    }else if ([cmd isEqualToString:@"0632"]) {
        //配置防拆报警上报间隔
        operationID = mk_ae_taskConfigTamperAlarmReportIntervalOperation;
    }else if ([cmd isEqualToString:@"0800"]) {
        //配置离线定位功能开关
        operationID = mk_ae_taskConfigOfflineFixOperation;
    }else if ([cmd isEqualToString:@"0801"]) {
        //配置GPS极限上传开关
        operationID = mk_ae_taskConfigGpsLimitUploadStatusOperation;
    }else if ([cmd isEqualToString:@"0808"]) {
        //配置室外蓝牙定位上报间隔
        operationID = mk_ae_taskConfigOutdoorBLEReportIntervalOperation;
    }else if ([cmd isEqualToString:@"0809"]) {
        //配置室外GPS定位上报间隔
        operationID = mk_ae_taskConfigOutdoorGPSReportIntervalOperation;
    }else if ([cmd isEqualToString:@"0820"]) {
        //配置蓝牙定位机制
        operationID = mk_ae_taskConfigBluetoothFixMechanismOperation;
    }else if ([cmd isEqualToString:@"0821"]) {
        //配置蓝牙定位超时时间
        operationID = mk_ae_taskConfigBlePositioningTimeoutOperation;
    }else if ([cmd isEqualToString:@"0822"]) {
        //配置蓝牙定位mac数量
        operationID = mk_ae_taskConfigBlePositioningNumberOfMacOperation;
    }else if ([cmd isEqualToString:@"0823"]) {
        //配置蓝牙beacon电压上报开关
        operationID = mk_ae_taskConfigBeaconVoltageReportInBleFixStatusOperation;
    }else if ([cmd isEqualToString:@"0830"]) {
        //配置GPS定位超时时间
        operationID = mk_ae_taskConfigGPSFixPositioningTimeoutOperation;
    }else if ([cmd isEqualToString:@"0831"]) {
        //配置GPS定位PDOP
        operationID = mk_ae_taskConfigGPSFixPDOPOperation;
    }else if ([cmd isEqualToString:@"0900"]) {
        //读取多少天本地存储的数据
        operationID = mk_ae_taskReadNumberOfDaysStoredDataOperation;
    }else if ([cmd isEqualToString:@"0901"]) {
        //清除存储的所有数据
        operationID = mk_ae_taskClearAllDatasOperation;
    }else if ([cmd isEqualToString:@"0902"]) {
        //暂停/恢复数据传输
        operationID = mk_ae_taskPauseSendLocalDataOperation;
    }
    
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}



#pragma mark -

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_ae_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
