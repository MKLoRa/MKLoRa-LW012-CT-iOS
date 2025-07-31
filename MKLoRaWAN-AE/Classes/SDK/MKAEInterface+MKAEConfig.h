//
//  MKAEInterface+MKAEConfig.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKAEInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAEInterface (MKAEConfig)

#pragma mark ****************************************System************************************************

/// Device shutdown.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_powerOffWithSucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Restart the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_restartDeviceWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_factoryResetWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Sync device time.
/// @param timestamp UTC
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configDeviceTime:(unsigned long)timestamp
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the time zone of the device.
/// @param timeZone -24~28  //(The time zone is in units of 30 minutes, UTC-12:00~UTC+14:00.eg:timeZone = -23 ,--> UTC-11:30)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configTimeZone:(NSInteger)timeZone
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Heartbeat Interval.
/// @param interval 300S~86400S
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configHeartbeatInterval:(NSInteger)interval
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Indicator Settings.
/// @param protocol protocol.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configIndicatorSettings:(id <mk_ae_indicatorSettingsProtocol>)protocol
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

///  Hall Power Off Status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configHallPowerOffStatus:(BOOL)isOn
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Shutdown Payload Status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configShutdownPayloadStatus:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure three-axis sensor wake-up conditions.
/// @param threshold 1 x 16ms ~20 x 16ms
/// @param duration 1 x 10ms ~ 10 x 10ms
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configThreeAxisWakeupConditions:(NSInteger)threshold
                                  duration:(NSInteger)duration
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure three-axis data motion detection judgment parameters.
/// @param threshold 10 x 2mg ~ 250 x 2mg
/// @param duration 1 x 5ms ~ 50 x 5ms
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configThreeAxisMotionParameters:(NSInteger)threshold
                                  duration:(NSInteger)duration
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark **************************************** Battery ************************************************


/// Battery Reset.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_batteryResetWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

///  Whether to trigger a heartbeat when the device is low on battery.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configLowPowerPayloadStatus:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Low power information packet reporting interval in low power state.
/// @param interval 1×30mins ~ 255×30mins.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configLowPowerPayloadInterval:(NSInteger)interval
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Low Power Condition1 Voltage Threshold.
/// @param threshold 44~64,unit:0.05v. 44=2.2v, 64=3.2v.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configLowPowerCondition1VoltageThreshold:(NSInteger)threshold
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Low Power Condition1 Min. Sample Interval.
/// @param interval 1Min~1440Mins.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configLowPowerCondition1MinSampleInterval:(NSInteger)interval
                                            sucBlock:(void (^)(void))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Low Power Condition1 Sample Times.
/// @param times 1~100.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configLowPowerCondition1SampleTimes:(NSInteger)times
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Low Power Condition2 Voltage Threshold.
/// @param threshold 44~64,unit:0.05v. 44=2.2v, 64=3.2v.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configLowPowerCondition2VoltageThreshold:(NSInteger)threshold
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Low Power Condition2 Min. Sample Interval.
/// @param interval 1Min~1440Mins.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configLowPowerCondition2MinSampleInterval:(NSInteger)interval
                                            sucBlock:(void (^)(void))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Low Power Condition2 Sample Times.
/// @param times 1~100.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configLowPowerCondition2SampleTimes:(NSInteger)times
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************蓝牙相关参数************************************************

/// Do you need a password when configuring the device connection.
/// @param need need
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configNeedPassword:(BOOL)need
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the connection password of device.
/// @param password 8-character ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configPassword:(NSString *)password
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the broadcast timeout time in Bluetooth configuration mode.
/// @param timeout 1Min~60Mins
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configBroadcastTimeout:(NSInteger)timeout
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Beacon status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configBeaconStatus:(BOOL)isOn
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Adv interval of the device.
/// @param interval 1~100(Unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configAdvInterval:(NSInteger)interval
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the txPower of device.
/// @param txPower txPower
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configTxPower:(mk_ae_txPower)txPower
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the broadcast name of the device.
/// @param deviceName 0~16 ascii characters
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configDeviceName:(NSString *)deviceName
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************模式相关参数************************************************
/// Configure the working mode of the device.
/// @param deviceMode device mode
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configWorkMode:(mk_ae_deviceMode)deviceMode
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Standby Mode positioning strategy.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configStandbyModePositioningStrategy:(mk_ae_positioningStrategy)strategy
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Periodic Mode positioning strategy.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configPeriodicModePositioningStrategy:(mk_ae_positioningStrategy)strategy
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Periodic Mode reporting interval.
/// @param interval 30s~86400s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configPeriodicModeReportInterval:(long long)interval
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Timing Mode positioning strategy.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configTimingModePositioningStrategy:(mk_ae_positioningStrategy)strategy
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Timing Mode Reporting Time Point.
/// @param dataList up to 10 groups of filters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configTimingModeReportingTimePoint:(NSArray <mk_ae_timingModeReportingTimePointProtocol>*)dataList
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Notify Event On Start.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModeEventsNotifyEventOnStart:(BOOL)isOn
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Fix On Start.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModeEventsFixOnStart:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Pos-Strategy On Start.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModePosStrategyOnStart:(mk_ae_positioningStrategy)strategy
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Number Of Fix On Start.
/// @param number 1~10
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModeNumberOfFixOnStart:(NSInteger)number
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Notify Event In Trip.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModeEventsNotifyEventInTrip:(BOOL)isOn
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Fix In Trip.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModeEventsFixInTrip:(BOOL)isOn
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Pos-Strategy In Trip.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModePosStrategyInTrip:(mk_ae_positioningStrategy)strategy
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Report Interval In Trip.
/// @param interval 10s~86400s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModeReportIntervalInTrip:(long long)interval
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Notify Event On End.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModeEventsNotifyEventOnEnd:(BOOL)isOn
                                         sucBlock:(void (^)(void))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Fix On End.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModeEventsFixOnEnd:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Pos-Strategy On End.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModePosStrategyOnEnd:(mk_ae_positioningStrategy)strategy
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Report Interval On End.
/// @param interval 10s~300s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModeReportIntervalOnEnd:(NSInteger)interval
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Number Of Fix On End.
/// @param number 1~10
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModeNumberOfFixOnEnd:(NSInteger)number
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Motion Mode Trip End Timeout.
/// @param time 1~180(Unit:10s)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModeTripEndTimeout:(NSInteger)time
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Fix On Stationary State.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configMotionModeEventsFixOnStationaryState:(BOOL)isOn
                                             sucBlock:(void (^)(void))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Pos-Strategy On Stationary.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configPosStrategyOnStationary:(mk_ae_positioningStrategy)strategy
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Report Interval On Stationary.
/// @param interval 1Min~14400Mins.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configReportIntervalOnStationary:(NSInteger)interval
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Time-Segmented Mode Positioning Strategy.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configTimeSegmentedModeStrategy:(mk_ae_positioningStrategy)strategy
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Time-Segmented Mode Time Period Setting.
/// @param dataList up to 10 groups of filters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configTimeSegmentedModeTimePeriodSetting:(NSArray <mk_ae_timeSegmentedModeTimePeriodSettingProtocol>*)dataList
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************蓝牙扫描过滤参数************************************************

/// The device will uplink valid ADV data with RSSI no less than rssi dBm.
/// @param rssi -127 dBm ~ 0 dBm.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configRssiFilterValue:(NSInteger)rssi
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Broadcast content filtering logic.
/// @param relationship relationship
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterRelationship:(mk_ae_filterRelationship)relationship
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// A switch to accurately filter Mac addresses.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByMacPreciseMatch:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch for reverse filtering of MAC addresses.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByMacReverseFilter:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Filtered list of mac addresses.
/// @param macList You can set up to 10 filters.1-6 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterMACAddressList:(NSArray <NSString *>*)macList
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// A switch to accurately filter Adv Name.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByAdvNamePreciseMatch:(BOOL)isOn
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch for reverse filtering of Adv Name.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByAdvNameReverseFilter:(BOOL)isOn
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Filtered list of Adv Name.
/// @param nameList You can set up to 10 filters.1-20 Characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterAdvNameList:(NSArray <NSString *>*)nameList
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by iBeacon.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByBeaconStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Major filter range of iBeacon.
/// @param minValue 0~65535
/// @param maxValue minValue~65535
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByBeaconMajorWithMinValue:(NSInteger)minValue
                                        maxValue:(NSInteger)maxValue
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Minor filter range of iBeacon.
/// @param minValue 0~65535(isOn=YES)
/// @param maxValue minValue~65535(isOn=YES)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByBeaconMinorWithMinValue:(NSInteger)minValue
                                        maxValue:(NSInteger)maxValue
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// UUID status of filter by iBeacon.
/// @param uuid 0~16 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByBeaconUUID:(NSString *)uuid
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by UID.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByUIDStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Namespace ID of filter by UID.
/// @param namespaceID 0~10 Bytes
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByUIDNamespaceID:(NSString *)namespaceID
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Instance ID of filter by UID.
/// @param instanceID 0~6 Bytes
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByUIDInstanceID:(NSString *)instanceID
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by URL.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByURLStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Content of filter by URL.
/// @param content 0~100 Characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByURLContent:(NSString *)content
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by TLM.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByTLMStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// TLM Version of filter by TLM.
/// @param version version
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByTLMVersion:(mk_ae_filterByTLMVersion)version
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by BXP-iBeacon.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByBXPBeaconStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Major filter range of BXP-iBeacon.
/// @param minValue 0~65535(isOn=YES)
/// @param maxValue minValue~65535(isOn=YES)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByBXPBeaconMajorWithMinValue:(NSInteger)minValue
                                           maxValue:(NSInteger)maxValue
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Minor filter range of BXP-iBeacon.
/// @param minValue 0~65535(isOn=YES)
/// @param maxValue minValue~65535(isOn=YES)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByBXPBeaconMinorWithMinValue:(NSInteger)minValue
                                           maxValue:(NSInteger)maxValue
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// UUID status of filter by BXP-iBeacon.
/// @param uuid 0~16 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByBXPBeaconUUID:(NSString *)uuid
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// The filter status of the BeaconX Pro-ACC device.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configBXPAccFilterStatus:(BOOL)isOn
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// The filter status of the BeaconX Pro-T&H device.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configBXPTHFilterStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by BXP Device Info.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByBXPDeviceInfoStatus:(BOOL)isOn
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by BXP Button.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByBXPButtonStatus:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// BXP-Button type filter content.
/// @param singlePress Filter Single Press alarm message switch.
/// @param doublePress Filter Double Press alarm message switch
/// @param longPress Filter Long Press alarm message switch
/// @param abnormalInactivity Abnormal Inactivity
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByBXPButtonAlarmStatus:(BOOL)singlePress
                                  doublePress:(BOOL)doublePress
                                    longPress:(BOOL)longPress
                           abnormalInactivity:(BOOL)abnormalInactivity
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by BXP-T&S TagID.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByBXPTagIDStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Precise Match Tag ID.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configPreciseMatchTagIDStatus:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Reverse Filter Tag ID.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configReverseFilterTagIDStatus:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Filtered list of BXP-T&S TagID.
/// @param macList You can set up to 10 filters.1-6 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterBXPTagIDList:(NSArray <NSString *>*)tagIDList
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by MK-Tof.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByTofStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Filtered list of BXP-Tof.
/// @param codeList You can set up to 10 filters.1-2 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterBXPTofList:(NSArray <NSString *>*)codeList
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by MK-PIR.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByPirStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Detection Status of filter by MK-PIR.
/// @param status status
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByPirDetectionStatus:(mk_ae_detectionStatus)status
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Sensor Sensitivity of filter by MK-PIR.
/// @param status status
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByPirSensorSensitivity:(mk_ae_sensorSensitivity)sensitivity
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Door status of filter by MK-PIR.
/// @param status status
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByPirDoorStatus:(mk_ae_doorStatus)status
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Delay response status of filter by MK-PIR.
/// @param status status
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByPirDelayResponseStatus:(mk_ae_delayResponseStatus)status
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Major filter range of MK-PIR.
/// @param minValue 0~65535
/// @param maxValue minValue~65535
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByPirMajorMinValue:(NSInteger)minValue
                                 maxValue:(NSInteger)maxValue
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Minor filter range of MK-PIR.
/// @param minValue 0~65535
/// @param maxValue minValue~65535
/// @param failedBlock Failure callback
+ (void)ae_configFilterByPirMinorMinValue:(NSInteger)minValue
                                 maxValue:(NSInteger)maxValue
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Switch status of filter by Other.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByOtherStatus:(BOOL)isOn
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Add logical relationships for up to three sets of filter conditions.
/// @param relationship relationship
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByOtherRelationship:(mk_ae_filterByOther)relationship
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Current filter conditions.
/// @param conditions conditions
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configFilterByOtherConditions:(NSArray <mk_ae_BLEFilterRawDataProtocol>*)conditions
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************设备lorawan信息设置************************************************

/// Configure the region information of LoRaWAN.
/// @param region region
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configRegion:(mk_ae_loraWanRegion)region
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure LoRaWAN network access type.
/// @param modem modem
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configModem:(mk_ae_loraWanModem)modem
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the DEVEUI of LoRaWAN.
/// @param devEUI Hexadecimal characters, length must be 16.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configDEVEUI:(NSString *)devEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the APPEUI of LoRaWAN.
/// @param appEUI Hexadecimal characters, length must be 16.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configAPPEUI:(NSString *)appEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the APPKEY of LoRaWAN.
/// @param appKey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configAPPKEY:(NSString *)appKey
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the DEVADDR of LoRaWAN.
/// @param devAddr Hexadecimal characters, length must be 8.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configDEVADDR:(NSString *)devAddr
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the APPSKEY of LoRaWAN.
/// @param appSkey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configAPPSKEY:(NSString *)appSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the NWKSKEY of LoRaWAN.
/// @param nwkSkey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configNWKSKEY:(NSString *)nwkSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// The ADR ACK LIMIT Of Lorawan.
/// @param value 1~255
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configLorawanADRACKLimit:(NSInteger)value
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// The ADR ACK DELAY Of Lorawan.
/// @param value 1~255
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configLorawanADRACKDelay:(NSInteger)value
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the CH of LoRaWAN.It is only used for US915,AU915,CN470.
/// @param chlValue Minimum value of CH.0 ~ 95
/// @param chhValue Maximum value of CH. chlValue ~ 95
/// @param sucBlock Success callback
/// @param failedBlock  Failure callback
+ (void)ae_configCHL:(NSInteger)chlValue
                 CHH:(NSInteger)chhValue
            sucBlock:(void (^)(void))sucBlock
         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the DR of LoRaWAN.It is only used for CN470, CN779, EU433, EU868,KR920, IN865, RU864.
/// @param drValue 0~5
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configDR:(NSInteger)drValue
           sucBlock:(void (^)(void))sucBlock
        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure LoRaWAN uplink data sending strategy.
/// @param isOn ADR is on.
/// @param transmissions 1/2
/// @param DRL When the ADR switch is off, the range is 0~6.
/// @param DRH When the ADR switch is off, the range is DRL~6
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configUplinkStrategy:(BOOL)isOn
                  transmissions:(NSInteger)transmissions
                            DRL:(NSInteger)DRL
                            DRH:(NSInteger)DRH
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// It is only used for EU868,CN779, EU433 and RU864. Off: The uplink report interval will not be limit by region freqency. On:The uplink report interval will be limit by region freqency.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configDutyCycleStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Time Sync Interval.
/// @param interval 0h~255h.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configTimeSyncInterval:(NSInteger)interval
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Network Check Interval Of Lorawan.
/// @param interval 0h~255h.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configLorawanNetworkCheckInterval:(NSInteger)interval
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Heartbeat Payload Type.
/// @param type type
/// @param times Max Retransmission Times.(1~4)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configHeartbeatPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                             retransmissionTimes:(NSInteger)times
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Low-Power Payload Type.
/// @param type type
/// @param times Max Retransmission Times.(1~4)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configLowPowerPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                            retransmissionTimes:(NSInteger)times
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Event Payload Type.
/// @param type type
/// @param times Max Retransmission Times.(1~4)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configEventPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                         retransmissionTimes:(NSInteger)times
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Positioning Payload Type.
/// @param type type
/// @param times Max Retransmission Times.(1~4)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configPositioningPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                               retransmissionTimes:(NSInteger)times
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Shock Payload Type.
/// @param type type
/// @param times Max Retransmission Times.(1~4)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configShockPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                         retransmissionTimes:(NSInteger)times
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Man Down Detection Payload Type.
/// @param type type
/// @param times Max Retransmission Times.(1~4)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configManDownDetectionPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                                    retransmissionTimes:(NSInteger)times
                                               sucBlock:(void (^)(void))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Tamper Alarm Payload Type.
/// @param type type
/// @param times Max Retransmission Times.(1~4)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configTamperAlarmPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                               retransmissionTimes:(NSInteger)times
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// GPS Limit Payload Type.
/// @param type type
/// @param times Max Retransmission Times.(1~4)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configGPSLimitPayloadWithMessageType:(mk_ae_loraWanMessageType)type
                            retransmissionTimes:(NSInteger)times
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************辅助功能************************************************

/// Configure the Positioning Strategy Downlink  For Position.
/// @param strategy strategy
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configDownlinkPositioningStrategy:(mk_ae_positioningStrategy)strategy
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;



/// Configure the state of the Shock detection switch.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configShockDetectionStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the Shock detection threshold.
/// @param threshold 10 x 10mg ~ 255 x 10mg
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configShockThresholds:(NSInteger)threshold
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the report interval of the Shock detection.
/// @param interval 3s~255s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configShockDetectionReportInterval:(NSInteger)interval
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Shock Timeout.
/// @param interval 1s~20s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configShockTimeout:(NSInteger)interval
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure  Man Down Detection.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configManDownDetectionStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Idle Detection Timeout.
/// @param interval 1h~8760h
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configIdleDetectionTimeout:(NSInteger)interval
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear the idle state of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configIdleStutasResetWithSucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure  Tamper Alarm Function Switch.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configTamperAlarmStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the Tamper Alarm threshold.
/// @param threshold 10 x lux ~ 200 x lux
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configTamperAlarmThresholds:(NSInteger)threshold
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the report interval of the Tamper Alarm.
/// @param interval 1Min~14400Mins.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configTamperAlarmReportInterval:(NSInteger)interval
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************定位参数************************************************
///  Whether to enable positioning when the device fails to connect to the Lorawan network.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configOfflineFix:(BOOL)isOn
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// GPS limit upload switch.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configGpsLimitUploadStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Outdoor BLE Report Interval.
/// - Parameters:
///   - interval: 1min~100min.
///   - sucBlock: Success callback
///   - failedBlock: Failure callback
+ (void)ae_configOutdoorBLEReportInterval:(NSInteger)interval
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Outdoor GPS Report Interval.
/// - Parameters:
///   - interval: 1min~14400min.
///   - sucBlock: Success callback
///   - failedBlock: Failure callback
+ (void)ae_configOutdoorGPSReportInterval:(NSInteger)interval
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Bluetooth Fix Mechanism.
/// @param priority priority
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configBluetoothFixMechanism:(mk_ae_bluetoothFixMechanism)priority
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Positioning Timeout Of Ble.
/// @param timeout 1s~10s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configBlePositioningTimeout:(NSInteger)timeout
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// The number of MACs for Bluetooth positioning.
/// @param number 1~15
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configBlePositioningNumberOfMac:(NSInteger)number
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Beacon Voltage Report in Bluetooth Fix.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_configBeaconVoltageReportInBleFixStatus:(BOOL)isOn
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// L76K GPS Fix Positioning Timeout.
/// - Parameters:
///   - timeout: 30s~600s.
///   - sucBlock: Success callback
///   - failedBlock: Failure callback
+ (void)ae_configGPSFixPositioningTimeout:(NSInteger)timeout
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// L76K GPS Fix PDOP.
/// - Parameters:
///   - pdop: 25~100
///   - sucBlock: Success callback
///   - failedBlock: Failure callback
+ (void)ae_configGPSFixPDOP:(NSInteger)pdop 
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;


 
#pragma mark ****************************************存储协议************************************************
/// Read the data stored by the device every day.
/// @param days 1 ~ 65535
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_readNumberOfDaysStoredData:(NSInteger)days
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear all data stored in the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_clearAllDatasWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Pause/resume data transmission of local data.
/// @param pause YES:pause,NO:resume
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)ae_pauseSendLocalData:(BOOL)pause
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;



@end

NS_ASSUME_NONNULL_END
