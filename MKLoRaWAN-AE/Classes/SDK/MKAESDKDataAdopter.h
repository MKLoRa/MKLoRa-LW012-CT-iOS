//
//  MKAESDKDataAdopter.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKAESDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAESDKDataAdopter : NSObject

+ (NSString *)lorawanRegionString:(mk_ae_loraWanRegion)region;

+ (NSString *)fetchTxPower:(mk_ae_txPower)txPower;

/// 实际值转换为0dBm、4dBm等
/// @param content content
+ (NSString *)fetchTxPowerValueString:(NSString *)content;

+ (NSString *)fetchDataFormatString:(mk_ae_dataFormat)dataType;

/// 过滤的mac列表
/// @param content content
+ (NSArray <NSString *>*)parseFilterMacList:(NSString *)content;

/// 过滤的Adv Name列表
/// @param contentList contentList
+ (NSArray <NSString *>*)parseFilterAdvNameList:(NSArray <NSData *>*)contentList;

/// 过滤的url
/// @param contentList contentList
+ (NSString *)parseFilterUrlContent:(NSArray <NSData *>*)contentList;

/// 将协议中的数值对应到原型中去
/// @param other 协议中的数值
+ (NSString *)parseOtherRelationship:(NSString *)other;

/// 解析Other当前过滤条件列表
/// @param content content
+ (NSArray *)parseOtherFilterConditionList:(NSString *)content;

+ (NSString *)parseOtherRelationshipToCmd:(mk_ae_filterByOther)relationship;

+ (BOOL)isConfirmRawFilterProtocol:(id <mk_ae_BLEFilterRawDataProtocol>)protocol;

+ (NSString *)fetchDeviceModeValue:(mk_ae_deviceMode)deviceMode;

+ (NSArray <NSDictionary *>*)parseTimingModeReportingTimePoint:(NSString *)content;

+ (NSArray <NSDictionary *>*)parseTimeSegmentedModeTimePeriodSetting:(NSString *)content;

+ (NSString *)fetchPositioningStrategyCommand:(mk_ae_positioningStrategy)strategy;

+ (NSString *)fetchTimingModeReportingTimePoint:(NSArray <mk_ae_timingModeReportingTimePointProtocol>*)dataList;

+ (NSString *)fetchimeSegmentedModeTimePeriodSetting:(NSArray <mk_ae_timeSegmentedModeTimePeriodSettingProtocol>*)dataList;

+ (NSDictionary *)fetchIndicatorSettings:(NSString *)content;

+ (NSString *)parseIndicatorSettingsCommand:(id <mk_ae_indicatorSettingsProtocol>)protocol;

+ (NSString *)fetchLRPositioningSystemString:(mk_ae_positioningSystem)system;

+ (NSString *)fetchBluetoothFixMechanismString:(mk_ae_bluetoothFixMechanism)priority;

@end

NS_ASSUME_NONNULL_END
