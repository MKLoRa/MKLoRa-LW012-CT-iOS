
typedef NS_ENUM(NSInteger, mk_ae_taskOperationID) {
    mk_ae_defaultTaskOperationID,
    
#pragma mark - Read
    mk_ae_taskReadDeviceModelOperation,        //读取产品型号
    mk_ae_taskReadFirmwareOperation,           //读取固件版本
    mk_ae_taskReadHardwareOperation,           //读取硬件类型
    mk_ae_taskReadSoftwareOperation,           //读取软件版本
    mk_ae_taskReadManufacturerOperation,       //读取厂商信息
    mk_ae_taskReadDeviceTypeOperation,         //读取产品类型
    
#pragma mark - 系统参数读取
    mk_ae_taskReadMacAddressOperation,              //读取mac地址
    mk_ae_taskReadTimeZoneOperation,            //读取时区
    mk_ae_taskReadHeartbeatIntervalOperation,   //读取设备心跳间隔
    mk_ae_taskReadIndicatorSettingsOperation,   //读取指示灯开关状态
    mk_ae_taskReadHallPowerOffStatusOperation,      //读取霍尔关机功能
    mk_ae_taskReadShutdownPayloadStatusOperation,   //读取关机信息上报状态
    mk_ae_taskReadThreeAxisWakeupConditionsOperation,       //读取三轴唤醒条件
    mk_ae_taskReadThreeAxisMotionParametersOperation,       //读取运动检测判断条件
    mk_ae_taskReadBatteryVoltageOperation,          //读取电池电量
    mk_ae_taskReadPCBAStatusOperation,              //读取产测状态
    mk_ae_taskReadSelftestStatusOperation,          //读取自检故障原因
    
    
#pragma mark - 电池管理参数
    mk_ae_taskReadBatteryInformationOperation,      //读取电池电量消耗
    mk_ae_taskReadLastCycleBatteryInformationOperation, //读取上一周期电池电量消耗
    mk_ae_taskReadAllCycleBatteryInformationOperation,  //读取所有周期电池电量消耗
    mk_ae_taskReadLowPowerPayloadStatusOperation,   //读取低电触发心跳开关状态
    mk_ae_taskReadLowPowerPayloadIntervalOperation,     //读取低电状态下低电信息包上报间隔
    
#pragma mark - 蓝牙参数读取
    mk_ae_taskReadConnectationNeedPasswordOperation,    //读取连接是否需要密码
    mk_ae_taskReadPasswordOperation,                    //读取连接密码
    mk_ae_taskReadBroadcastTimeoutOperation,            //读取蓝牙广播超时时间
    mk_ae_taskReadBeaconStatusOperation,                //读取Beacon模式开关
    mk_ae_taskReadAdvIntervalOperation,                 //读取广播间隔
    mk_ae_taskReadTxPowerOperation,                     //读取蓝牙TX Power
    mk_ae_taskReadDeviceNameOperation,                  //读取广播名称
    
    
    
#pragma mark - 模式相关参数读取
    mk_ae_taskReadWorkModeOperation,            //读取工作模式
    mk_ae_taskReadStandbyModePositioningStrategyOperation,          //读取待机模式定位策略
    mk_ae_taskReadPeriodicModePositioningStrategyOperation,         //读取定期模式定位策略
    mk_ae_taskReadPeriodicModeReportIntervalOperation,              //读取定期模式上报间隔
    mk_ae_taskReadTimingModePositioningStrategyOperation,           //读取定时模式定位策略
    mk_ae_taskReadTimingModeReportingTimePointOperation,            //读取定时模式时间点
    mk_ae_taskReadMotionModeEventsNotifyEventOnStartOperation,      //读取运动模式-运动开始事件信息开关
    mk_ae_taskReadMotionModeEventsFixOnStartOperation,              //读取运动模式-运动开始定位开关
    mk_ae_taskReadMotionModePosStrategyOnStartOperation,            //读取运动开始定位策略
    mk_ae_taskReadMotionModeNumberOfFixOnStartOperation,            //读取运动开始定位上报次数
    mk_ae_taskReadMotionModeEventsNotifyEventInTripOperation,       //读取运动模式-运动中事件信息开关
    mk_ae_taskReadMotionModeEventsFixInTripOperation,               //读取运动模式-运动中定位开关
    mk_ae_taskReadMotionModePosStrategyInTripOperation,             //读取运动中定位策略
    mk_ae_taskReadMotionModeReportIntervalInTripOperation,          //读取运动中定位间隔
    mk_ae_taskReadMotionModeEventsNotifyEventOnEndOperation,      //读取运动模式-运动结束事件信息开关
    mk_ae_taskReadMotionModeEventsFixOnEndOperation,              //读取运动模式-运动结束定位开关
    mk_ae_taskReadMotionModePosStrategyOnEndOperation,              //读取运动结束定位策略
    mk_ae_taskReadMotionModeReportIntervalOnEndOperation,           //读取运动结束定位间隔
    mk_ae_taskReadMotionModeNumberOfFixOnEndOperation,              //读取运动结束定位次数
    mk_ae_taskReadMotionModeTripEndTimeoutOperation,                //读取运动结束判断时间
    mk_ae_taskReadMotionModeEventsFixOnStationaryStateOperation,    //读取运动模式-静止定位开关
    mk_ae_taskReadPosStrategyOnStationaryOperation,                 //读取运动静止状态定位策略
    mk_ae_taskReadReportIntervalOnStationaryOperation,              //读取运动禁止状态上报间隔
    mk_ae_taskReadTimeSegmentedModeStrategyOperation,               //读取定时+定期模式-定位策略
    mk_ae_taskReadTimeSegmentedModeTimePeriodSettingOperation,      //读取定时+定期模式-定时时间段
    
    
#pragma mark - 蓝牙扫描过滤参数读取
    mk_ae_taskReadRssiFilterValueOperation,             //读取RSSI过滤规则
    mk_ae_taskReadFilterRelationshipOperation,          //读取广播内容过滤逻辑
    mk_ae_taskReadFilterTypeStatusOperation,            //读取过滤设备类型开关
    mk_ae_taskReadFilterByMacPreciseMatchOperation, //读取精准过滤MAC开关
    mk_ae_taskReadFilterByMacReverseFilterOperation,    //读取反向过滤MAC开关
    mk_ae_taskReadFilterMACAddressListOperation,        //读取MAC过滤列表
    mk_ae_taskReadFilterByAdvNamePreciseMatchOperation, //读取精准过滤ADV Name开关
    mk_ae_taskReadFilterByAdvNameReverseFilterOperation,    //读取反向过滤ADV Name开关
    mk_ae_taskReadFilterAdvNameListOperation,           //读取ADV Name过滤列表
    mk_ae_taskReadFilterByBeaconStatusOperation,        //读取iBeacon类型过滤开关
    mk_ae_taskReadFilterByBeaconMajorRangeOperation,    //读取iBeacon类型Major范围
    mk_ae_taskReadFilterByBeaconMinorRangeOperation,    //读取iBeacon类型Minor范围
    mk_ae_taskReadFilterByBeaconUUIDOperation,          //读取iBeacon类型UUID
    mk_ae_taskReadFilterByUIDStatusOperation,                //读取UID类型过滤开关
    mk_ae_taskReadFilterByUIDNamespaceIDOperation,           //读取UID类型过滤的Namespace ID
    mk_ae_taskReadFilterByUIDInstanceIDOperation,            //读取UID类型过滤的Instance ID
    mk_ae_taskReadFilterByURLStatusOperation,               //读取URL类型过滤开关
    mk_ae_taskReadFilterByURLContentOperation,              //读取URL过滤的内容
    mk_ae_taskReadFilterByTLMStatusOperation,               //读取TLM过滤开关
    mk_ae_taskReadFilterByTLMVersionOperation,              //读取TLM过滤类型
    mk_ae_taskReadFilterByBXPBeaconStatusOperation,      //读取BXP-iBeacon类型过滤开关
    mk_ae_taskReadFilterByBXPBeaconMajorRangeOperation,    //读取BXP-iBeacon类型Major范围
    mk_ae_taskReadFilterByBXPBeaconMinorRangeOperation,    //读取BXP-iBeacon类型Minor范围
    mk_ae_taskReadFilterByBXPBeaconUUIDOperation,          //读取BXP-iBeacon类型UUID
    mk_ae_taskReadBXPAccFilterStatusOperation,          //读取BeaconX Pro-ACC设备过滤开关
    mk_ae_taskReadBXPTHFilterStatusOperation,           //读取BeaconX Pro-T&H设备过滤开关
    mk_ae_taskReadBXPDeviceInfoFilterStatusOperation,       //读取BXP-DeviceInfo过滤条件开关
    mk_ae_taskReadBXPButtonFilterStatusOperation,           //读取BXP-Button过滤条件开关
    mk_ae_taskReadBXPButtonAlarmFilterStatusOperation,      //读取BXP-Button报警过滤开关
    mk_ae_taskReadFilterByBXPTagIDStatusOperation,         //读取BXP-T&S TagID类型开关
    mk_ae_taskReadPreciseMatchTagIDStatusOperation,        //读取BXP-T&S TagID类型精准过滤tagID开关
    mk_ae_taskReadReverseFilterTagIDStatusOperation,    //读取读取BXP-T&S TagID类型反向过滤tagID开关
    mk_ae_taskReadFilterBXPTagIDListOperation,             //读取BXP-T&S TagID过滤规则
    mk_ae_taskReadFilterBXPTofStatusOperation,              //读取BXP-TOF设备过滤开关
    mk_ae_taskReadFilterBXPTofMfgCodeListOperation,         //读取BXP-TOF设备过滤MFG code
    mk_ae_taskReadFilterByPirStatusOperation,           //读取PIR过滤开关
    mk_ae_taskReadFilterByPirDetectionStatusOperation,  //读取PIR设备过滤sensor_detection_status
    mk_ae_taskReadFilterByPirSensorSensitivityOperation,    //读取PIR设备过滤sensor_sensitivity
    mk_ae_taskReadFilterByPirDoorStatusOperation,           //读取PIR设备过滤door_status
    mk_ae_taskReadFilterByPirDelayResponseStatusOperation,  //读取PIR设备过滤delay_response_status
    mk_ae_taskReadFilterByPirMajorRangeOperation,           //读取PIR设备Major过滤范围
    mk_ae_taskReadFilterByPirMinorRangeOperation,           //读取PIR设备Minor过滤范围
    mk_ae_taskReadFilterByOtherStatusOperation,         //读取Other过滤条件开关
    mk_ae_taskReadFilterByOtherRelationshipOperation,   //读取Other过滤条件的逻辑关系
    mk_ae_taskReadFilterByOtherConditionsOperation,     //读取Other的过滤条件列表
    
#pragma mark - 定位参数读取
    mk_ae_taskReadOfflineFixStatusOperation,    //读取离线定位功能开关状态
    mk_ae_taskReadGpsLimitUploadStatusOperation,        //读取GPS极限上传开关
    mk_ae_taskReadOutdoorBLEReportIntervalOperation,    //读取室外蓝牙定位上报间隔
    mk_ae_taskReadOutdoorGPSReportIntervalOperation,    //读取室外GPS定位上报间隔
    mk_ae_taskReadBluetoothFixMechanismOperation,   //读取蓝牙定位机制
    mk_ae_taskReadBlePositioningTimeoutOperation,   //读取蓝牙定位超时时间
    mk_ae_taskReadBlePositioningNumberOfMacOperation,   //读取蓝牙定位成功MAC数量
    mk_ae_taskReadBeaconVoltageReportInBleFixOperation, //读取蓝牙beacon电压上报开关
    mk_ae_taskReadGPSFixPositioningTimeoutOperation,    //读取GPS定位超时时间
    mk_ae_taskReadGPSFixPDOPOperation,                  //读取GPS定位PDOP
    
    
#pragma mark - 设备控制参数配置
    mk_ae_taskPowerOffOperation,                        //关机
    mk_ae_taskRestartDeviceOperation,                   //配置设备重新入网
    mk_ae_taskFactoryResetOperation,                    //设备恢复出厂设置
    mk_ae_taskConfigDeviceTimeOperation,                //配置时间戳
    mk_ae_taskConfigTimeZoneOperation,                  //配置时区
    mk_ae_taskConfigHeartbeatIntervalOperation,         //配置设备心跳间隔
    mk_ae_taskConfigIndicatorSettingsOperation,         //配置指示灯开关状态
    mk_ae_taskConfigHallPowerOffStatusOperation,        //配置霍尔关机功能
    mk_ae_taskConfigShutdownPayloadStatusOperation,     //配置关机信息上报状态
    mk_ae_taskConfigThreeAxisWakeupConditionsOperation,         //配置三轴唤醒条件
    mk_ae_taskConfigThreeAxisMotionParametersOperation,         //配置运动检测判断
    
#pragma mark - 电池管理
    mk_ae_taskBatteryResetOperation,                    //清除电池电量数据
    mk_ae_taskConfigLowPowerPayloadStatusOperation,     //配置低电触发心跳开关状态
    mk_ae_taskConfigLowPowerPayloadIntervalOperation,   //配置低电状态下低电信息包上报间隔
    
    
#pragma mark - 蓝牙参数配置
    mk_ae_taskConfigNeedPasswordOperation,              //配置是否需要连接密码
    mk_ae_taskConfigPasswordOperation,                  //配置连接密码
    mk_ae_taskConfigBroadcastTimeoutOperation,          //配置蓝牙广播超时时间
    mk_ae_taskConfigBeaconStatusOperation,              //配置Beacon模式开关
    mk_ae_taskConfigAdvIntervalOperation,               //配置广播间隔
    mk_ae_taskConfigTxPowerOperation,                   //配置蓝牙TX Power
    mk_ae_taskConfigDeviceNameOperation,                //配置蓝牙广播名称
    
#pragma mark - 配置模式相关参数
    mk_ae_taskConfigWorkModeOperation,                  //配置工作模式
    mk_ae_taskConfigStandbyModePositioningStrategyOperation,        //配置待机模式定位策略
    mk_ae_taskConfigPeriodicModePositioningStrategyOperation,       //配置定期模式定位策略
    mk_ae_taskConfigPeriodicModeReportIntervalOperation,            //配置定期模式上报间隔
    mk_ae_taskConfigTimingModePositioningStrategyOperation,         //配置定时模式定位策略
    mk_ae_taskConfigTimingModeReportingTimePointOperation,          //配置定时模式时间点
    mk_ae_taskConfigMotionModeEventsNotifyEventOnStartOperation,    //配置运动模式-运动开始事件信息开关
    mk_ae_taskConfigMotionModeEventsFixOnStartOperation,            //配置运动模式-运动开始定位开关
    mk_ae_taskConfigMotionModePosStrategyOnStartOperation,          //配置运动开始定位策略
    mk_ae_taskConfigMotionModeNumberOfFixOnStartOperation,          //配置运动开始定位上报次数
    mk_ae_taskConfigMotionModeEventsNotifyEventInTripOperation,     //配置运动模式-运动中事件信息开关
    mk_ae_taskConfigMotionModeEventsFixInTripOperation,             //配置运动模式-运动中定位开关
    mk_ae_taskConfigMotionModePosStrategyInTripOperation,           //配置运动中定位策略
    mk_ae_taskConfigMotionModeReportIntervalInTripOperation,        //配置运动中定位间隔
    mk_ae_taskConfigMotionModeEventsNotifyEventOnEndOperation,      //配置运动模式-运动结束事件信息开关
    mk_ae_taskConfigMotionModeEventsFixOnEndOperation,              //配置运动模式-运动结束定位开关
    mk_ae_taskConfigMotionModePosStrategyOnEndOperation,            //配置运动结束定位策略
    mk_ae_taskConfigMotionModeReportIntervalOnEndOperation,         //配置运动结束定位间隔
    mk_ae_taskConfigMotionModeNumberOfFixOnEndOperation,            //配置运动结束定位次数
    mk_ae_taskConfigMotionModeTripEndTimeoutOperation,              //配置运动结束判断时间
    mk_ae_taskConfigMotionModeEventsFixOnStationaryStateOperation,  //配置运动模式-静止定位开关
    mk_ae_taskConfigPosStrategyOnStationaryOperation,               //配置运动静止状态定位策略
    mk_ae_taskConfigReportIntervalOnStationaryOperation,            //配置运动禁止状态上报间隔
    mk_ae_taskConfigTimeSegmentedModeStrategyOperation,             //配置定时+定期模式-定位策略
    mk_ae_taskConfigTimeSegmentedModeTimePeriodSettingOperation,    //配置定时+定期模式-定时时间段

#pragma mark - 蓝牙扫描过滤参数配置
    mk_ae_taskConfigRssiFilterValueOperation,           //配置rssi过滤规则
    mk_ae_taskConfigFilterRelationshipOperation,        //配置广播内容过滤逻辑
    mk_ae_taskConfigFilterByMacPreciseMatchOperation,   //配置精准过滤MAC开关
    mk_ae_taskConfigFilterByMacReverseFilterOperation,  //配置反向过滤MAC开关
    mk_ae_taskConfigFilterMACAddressListOperation,      //配置MAC过滤规则
    mk_ae_taskConfigFilterByAdvNamePreciseMatchOperation,   //配置精准过滤Adv Name开关
    mk_ae_taskConfigFilterByAdvNameReverseFilterOperation,  //配置反向过滤Adv Name开关
    mk_ae_taskConfigFilterAdvNameListOperation,             //配置Adv Name过滤规则
    mk_ae_taskConfigFilterByBeaconStatusOperation,          //配置iBeacon类型过滤开关
    mk_ae_taskConfigFilterByBeaconMajorOperation,           //配置iBeacon类型过滤的Major范围
    mk_ae_taskConfigFilterByBeaconMinorOperation,           //配置iBeacon类型过滤的Minor范围
    mk_ae_taskConfigFilterByBeaconUUIDOperation,            //配置iBeacon类型过滤的UUID
    mk_ae_taskConfigFilterByUIDStatusOperation,                 //配置UID类型过滤的开关状态
    mk_ae_taskConfigFilterByUIDNamespaceIDOperation,            //配置UID类型过滤的Namespace ID
    mk_ae_taskConfigFilterByUIDInstanceIDOperation,             //配置UID类型过滤的Instance ID
    mk_ae_taskConfigFilterByURLStatusOperation,                 //配置URL类型过滤的开关状态
    mk_ae_taskConfigFilterByURLContentOperation,                //配置URL类型过滤的内容
    mk_ae_taskConfigFilterByTLMStatusOperation,                 //配置TLM过滤开关
    mk_ae_taskConfigFilterByTLMVersionOperation,                //配置TLM过滤数据类型
    mk_ae_taskConfigFilterByBXPBeaconStatusOperation,          //配置BXP-iBeacon类型过滤开关
    mk_ae_taskConfigFilterByBXPBeaconMajorOperation,           //配置BXP-iBeacon类型过滤的Major范围
    mk_ae_taskConfigFilterByBXPBeaconMinorOperation,           //配置BXP-iBeacon类型过滤的Minor范围
    mk_ae_taskConfigFilterByBXPBeaconUUIDOperation,            //配置BXP-iBeacon类型过滤的UUID
    mk_ae_taskConfigBXPAccFilterStatusOperation,            //配置BeaconX Pro-ACC设备过滤开关
    mk_ae_taskConfigBXPTHFilterStatusOperation,             //配置BeaconX Pro-TH设备过滤开关
    mk_ae_taskConfigFilterByBXPDeviceInfoStatusOperation,       //配置BXP-DeviceInfo过滤开关
    mk_ae_taskConfigFilterByBXPButtonStatusOperation,           //配置BXP-Button过滤开关
    mk_ae_taskConfigFilterByBXPButtonAlarmStatusOperation,      //配置BXP-Button类型过滤内容
    mk_ae_taskConfigFilterByBXPTagIDStatusOperation,            //配置BXP-T&S TagID类型过滤开关
    mk_ae_taskConfigPreciseMatchTagIDStatusOperation,           //配置BXP-T&S TagID类型精准过滤Tag-ID开关
    mk_ae_taskConfigReverseFilterTagIDStatusOperation,          //配置BXP-T&S TagID类型反向过滤Tag-ID开关
    mk_ae_taskConfigFilterBXPTagIDListOperation,                //配置BXP-T&S TagID过滤规则
    mk_ae_taskConfigFilterByTofStatusOperation,                 //配置BXP-TOF设备过滤开关
    mk_ae_taskConfigFilterBXPTofListOperation,                  //配置BXP-TOF设备过滤开关
    mk_ae_taskConfigFilterByPirStatusOperation,             //配置PIR设备过滤开关
    mk_ae_taskConfigFilterByPirDetectionStatusOperation,    //配置PIR设备过滤sensor_detection_status
    mk_ae_taskConfigFilterByPirSensorSensitivityOperation,  //配置PIR设备过滤sensor_sensitivity
    mk_ae_taskConfigFilterByPirDoorStatusOperation,         //配置PIR设备过滤door_status
    mk_ae_taskConfigFilterByPirDelayResponseStatusOperation,    //配置PIR设备过滤delay_response_status
    mk_ae_taskConfigFilterByPirMajorOperation,                  //配置PIR设备Major过滤范围
    mk_ae_taskConfigFilterByPirMinorOperation,                  //配置PIR设备Minor过滤范围
    mk_ae_taskConfigFilterByOtherStatusOperation,           //配置Other过滤关系开关
    mk_ae_taskConfigFilterByOtherRelationshipOperation,     //配置Other过滤条件逻辑关系
    mk_ae_taskConfigFilterByOtherConditionsOperation,       //配置Other过滤条件列表
    
#pragma mark - 密码特征
    mk_ae_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 设备LoRa参数读取
    mk_ae_taskReadLorawanNetworkStatusOperation,    //读取LoRaWAN网络状态
    mk_ae_taskReadLorawanRegionOperation,           //读取LoRaWAN频段
    mk_ae_taskReadLorawanModemOperation,            //读取LoRaWAN入网类型
    mk_ae_taskReadLorawanDEVEUIOperation,           //读取LoRaWAN DEVEUI
    mk_ae_taskReadLorawanAPPEUIOperation,           //读取LoRaWAN APPEUI
    mk_ae_taskReadLorawanAPPKEYOperation,           //读取LoRaWAN APPKEY
    mk_ae_taskReadLorawanDEVADDROperation,          //读取LoRaWAN DEVADDR
    mk_ae_taskReadLorawanAPPSKEYOperation,          //读取LoRaWAN APPSKEY
    mk_ae_taskReadLorawanNWKSKEYOperation,          //读取LoRaWAN NWKSKEY
    mk_ae_taskReadLorawanADRACKLimitOperation,              //读取ADR_ACK_LIMIT
    mk_ae_taskReadLorawanADRACKDelayOperation,              //读取ADR_ACK_DELAY
    mk_ae_taskReadLorawanCHOperation,               //读取LoRaWAN CH
    mk_ae_taskReadLorawanDROperation,               //读取LoRaWAN DR
    mk_ae_taskReadLorawanUplinkStrategyOperation,   //读取LoRaWAN数据发送策略
    mk_ae_taskReadLorawanDutyCycleStatusOperation,  //读取dutycyle
    mk_ae_taskReadLorawanDevTimeSyncIntervalOperation,  //读取同步时间同步间隔
    mk_ae_taskReadLorawanNetworkCheckIntervalOperation, //读取网络确认间隔
    mk_ae_taskReadHeartbeatPayloadDataOperation,            //读取心跳包上行配置
    mk_ae_taskReadEventPayloadDataOperation,                //读取事件信息包上行配置
    mk_ae_taskReadPositioningPayloadDataOperation,          //读取定位包上行配置
    mk_ae_taskReadShockPayloadDataOperation,                //读取震动检测包上行配置
    mk_ae_taskReadManDownDetectionPayloadDataOperation,     //读取闲置检测包上行配置
    mk_ae_taskReadTamperAlarmPayloadDataOperation,          //读取防拆报警检测包上行配置
    mk_ae_taskReadGPSLimitPayloadDataOperation,             //读取GPS极限定位包上行配置
    
#pragma mark - 辅助功能读取
    mk_ae_taskReadDownlinkPositioningStrategyOperation,     //读取下行请求定位策略
    mk_ae_taskReadShockDetectionStatusOperation,            //读取震动检测状态
    mk_ae_taskReadShockThresholdsOperation,                 //读取震动检测阈值
    mk_ae_taskReadShockDetectionReportIntervalOperation,    //读取震动上法间隔
    mk_ae_taskReadShockTimeoutOperation,                    //读取震动次数判断间隔
    mk_ae_taskReadManDownDetectionOperation,                //读取闲置功能使能
    mk_ae_taskReadIdleDetectionTimeoutOperation,            //读取闲置超时时间
    mk_ae_taskReadTamperAlarmStatusOperation,               //读取防拆报警开关
    mk_ae_taskReadTamperAlarmThresholdsOperation,           //读取防拆报警阈值
    mk_ae_taskReadTamperAlarmReportIntervalOperation,       //读取防拆报警上传间隔
    
#pragma mark - 设备LoRa参数配置
    mk_ae_taskConfigRegionOperation,                    //配置LoRaWAN的region
    mk_ae_taskConfigModemOperation,                     //配置LoRaWAN的入网类型
    mk_ae_taskConfigDEVEUIOperation,                    //配置LoRaWAN的devEUI
    mk_ae_taskConfigAPPEUIOperation,                    //配置LoRaWAN的appEUI
    mk_ae_taskConfigAPPKEYOperation,                    //配置LoRaWAN的appKey
    mk_ae_taskConfigDEVADDROperation,                   //配置LoRaWAN的DevAddr
    mk_ae_taskConfigAPPSKEYOperation,                   //配置LoRaWAN的APPSKEY
    mk_ae_taskConfigNWKSKEYOperation,                   //配置LoRaWAN的NwkSKey
    mk_ae_taskConfigLorawanADRACKLimitOperation,        //配置ADR_ACK_LIMIT
    mk_ae_taskConfigLorawanADRACKDelayOperation,        //配置ADR_ACK_DELAY
    mk_ae_taskConfigCHValueOperation,                   //配置LoRaWAN的CH值
    mk_ae_taskConfigDRValueOperation,                   //配置LoRaWAN的DR值
    mk_ae_taskConfigUplinkStrategyOperation,            //配置LoRaWAN数据发送策略
    mk_ae_taskConfigDutyCycleStatusOperation,           //配置LoRaWAN的duty cycle
    mk_ae_taskConfigTimeSyncIntervalOperation,          //配置LoRaWAN的同步指令间隔
    mk_ae_taskConfigNetworkCheckIntervalOperation,      //配置LoRaWAN的LinkCheckReq间隔
    mk_ae_taskConfigHeartbeatPayloadOperation,          //配置心跳包上行配置
    mk_ae_taskConfigEventPayloadWithMessageTypeOperation,   //配置事件信息包上行配置
    mk_ae_taskConfigPositioningPayloadOperation,        //配置定位包上行配置
    mk_ae_taskConfigShockPayloadOperation,              //配置震动检测包上行配置
    mk_ae_taskConfigManDownDetectionPayloadOperation,   //配置闲置检测包上行配置
    mk_ae_taskConfigTamperAlarmPayloadOperation,        //配置防拆报警检测包上行配置
    mk_ae_taskConfigGPSLimitPayloadOperation,           //配置GPS极限定位包上行配置
    
    
#pragma mark - 辅助功能配置
    mk_ae_taskConfigDownlinkPositioningStrategyyOperation,  //配置下行请求定位策略
    mk_ae_taskConfigShockDetectionStatusOperation,          //配置震动检测使能
    mk_ae_taskConfigShockThresholdsOperation,               //配置震动检测阈值
    mk_ae_taskConfigShockDetectionReportIntervalOperation,  //配置震动上发间隔
    mk_ae_taskConfigShockTimeoutOperation,                  //配置震动次数判断间隔
    mk_ae_taskConfigManDownDetectionStatusOperation,            //配置闲置功能使能
    mk_ae_taskConfigIdleDetectionTimeoutOperation,              //配置闲置超时时间
    mk_ae_taskConfigIdleStutasResetOperation,                   //闲置状态清除
    mk_ae_taskConfigTamperAlarmStatusOperation,             //配置防拆报警开关
    mk_ae_taskConfigTamperAlarmThresholdsOperation,         //配置防拆报警阈值
    mk_ae_taskConfigTamperAlarmReportIntervalOperation,     //配置防拆报警上报间隔
    
#pragma mark - 定位参数配置
    mk_ae_taskConfigOfflineFixOperation,                //配置离线定位功能开关状态
    mk_ae_taskConfigGpsLimitUploadStatusOperation,      //配置GPS极限上传开关
    mk_ae_taskConfigOutdoorBLEReportIntervalOperation,      //配置室外蓝牙定位上报间隔
    mk_ae_taskConfigOutdoorGPSReportIntervalOperation,      //配置室外GPS定位上报间隔
    mk_ae_taskConfigBluetoothFixMechanismOperation,     //配置蓝牙定位机制
    mk_ae_taskConfigBlePositioningTimeoutOperation,     //配置蓝牙定位超时时间
    mk_ae_taskConfigBlePositioningNumberOfMacOperation,     //配置蓝牙定位mac数量
    mk_ae_taskConfigBeaconVoltageReportInBleFixStatusOperation, //配置蓝牙beacon电压上报开关
    mk_ae_taskConfigGPSFixPositioningTimeoutOperation,      //配置GPS定位超时时间
    mk_ae_taskConfigGPSFixPDOPOperation,                    //配置GPS定位PDOP
    
    
#pragma mark - 存储数据协议
    mk_ae_taskReadNumberOfDaysStoredDataOperation,      //读取多少天本地存储的数据
    mk_ae_taskClearAllDatasOperation,                   //清除存储的所有数据
    mk_ae_taskPauseSendLocalDataOperation,              //暂停/恢复数据传输
};
