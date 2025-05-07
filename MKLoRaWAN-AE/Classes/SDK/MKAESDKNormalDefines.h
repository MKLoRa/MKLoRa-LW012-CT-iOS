#pragma mark ****************************************Enumerate************************************************

#pragma mark - MKAECentralManager

typedef NS_ENUM(NSInteger, mk_ae_centralConnectStatus) {
    mk_ae_centralConnectStatusUnknow,                                           //未知状态
    mk_ae_centralConnectStatusConnecting,                                       //正在连接
    mk_ae_centralConnectStatusConnected,                                        //连接成功
    mk_ae_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_ae_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_ae_centralManagerStatus) {
    mk_ae_centralManagerStatusUnable,                           //不可用
    mk_ae_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_ae_deviceMode) {
    mk_ae_deviceMode_standbyMode,         //Standby mode
    mk_ae_deviceMode_periodicMode,        //Periodic mode
    mk_ae_deviceMode_timingMode,          //Timing mode
    mk_ae_deviceMode_motionMode,          //Motion Mode
    mk_ae_deviceMode_timeSegmentedMode,   //Time-Segmented Mode
};

typedef NS_ENUM(NSInteger, mk_ae_positioningStrategy) {
    mk_ae_positioningStrategy_ble,      //BLE
    mk_ae_positioningStrategy_gps,      //GPS
    mk_ae_positioningStrategy_bleAndGps_1,  //BLE + GPS
    mk_ae_positioningStrategy_bleAndGps_2,  //BLE * GPS
    mk_ae_positioningStrategy_bleAndGps_3,  //BLE & GPS
};

typedef NS_ENUM(NSInteger, mk_ae_filterRelationship) {
    mk_ae_filterRelationship_null,
    mk_ae_filterRelationship_mac,
    mk_ae_filterRelationship_advName,
    mk_ae_filterRelationship_rawData,
    mk_ae_filterRelationship_advNameAndRawData,
    mk_ae_filterRelationship_macAndadvNameAndRawData,
    mk_ae_filterRelationship_advNameOrRawData,
};

typedef NS_ENUM(NSInteger, mk_ae_filterByTLMVersion) {
    mk_ae_filterByTLMVersion_null,             //Do not filter data.
    mk_ae_filterByTLMVersion_0,                //Unencrypted TLM data.
    mk_ae_filterByTLMVersion_1,                //Encrypted TLM data.
};

typedef NS_ENUM(NSInteger, mk_ae_filterByOther) {
    mk_ae_filterByOther_A,                 //Filter by A condition.
    mk_ae_filterByOther_AB,                //Filter by A & B condition.
    mk_ae_filterByOther_AOrB,              //Filter by A | B condition.
    mk_ae_filterByOther_ABC,               //Filter by A & B & C condition.
    mk_ae_filterByOther_ABOrC,             //Filter by (A & B) | C condition.
    mk_ae_filterByOther_AOrBOrC,           //Filter by A | B | C condition.
};

typedef NS_ENUM(NSInteger, mk_ae_dataFormat) {
    mk_ae_dataFormat_DAS,
    mk_ae_dataFormat_Customer,
};

typedef NS_ENUM(NSInteger, mk_ae_positioningSystem) {
    mk_ae_positioningSystem_GPS,
    mk_ae_positioningSystem_Beidou,
    mk_ae_positioningSystem_GPSAndBeidou
};

typedef NS_ENUM(NSInteger, mk_ae_loraWanRegion) {
    mk_ae_loraWanRegionAS923,
    mk_ae_loraWanRegionAU915,
    mk_ae_loraWanRegionEU868,
    mk_ae_loraWanRegionKR920,
    mk_ae_loraWanRegionIN865,
    mk_ae_loraWanRegionUS915,
    mk_ae_loraWanRegionRU864,
    mk_ae_loraWanRegionAS923_1,
    mk_ae_loraWanRegionAS923_2,
    mk_ae_loraWanRegionAS923_3,
    mk_ae_loraWanRegionAS923_4,
};

typedef NS_ENUM(NSInteger, mk_ae_loraWanModem) {
    mk_ae_loraWanModemABP,
    mk_ae_loraWanModemOTAA,
};

typedef NS_ENUM(NSInteger, mk_ae_loraWanMessageType) {
    mk_ae_loraWanUnconfirmMessage,          //Non-acknowledgement frame.
    mk_ae_loraWanConfirmMessage,            //Confirm the frame.
};

typedef NS_ENUM(NSInteger, mk_ae_txPower) {
    mk_ae_txPowerNeg40dBm,   //RadioTxPower:-40dBm
    mk_ae_txPowerNeg20dBm,   //-20dBm
    mk_ae_txPowerNeg16dBm,   //-16dBm
    mk_ae_txPowerNeg12dBm,   //-12dBm
    mk_ae_txPowerNeg8dBm,    //-8dBm
    mk_ae_txPowerNeg4dBm,    //-4dBm
    mk_ae_txPower0dBm,       //0dBm
    mk_ae_txPower3dBm,       //3dBm
    mk_ae_txPower4dBm,       //4dBm
};

typedef NS_ENUM(NSInteger, mk_ae_bluetoothFixMechanism) {
    mk_ae_bluetoothFixMechanism_timePriority,
    mk_ae_bluetoothFixMechanism_rssiPriority,
};

typedef NS_ENUM(NSInteger, mk_ae_detectionStatus) {
    mk_ae_detectionStatus_noMotionDetected,
    mk_ae_detectionStatus_motionDetected,
    mk_ae_detectionStatus_all
};

typedef NS_ENUM(NSInteger, mk_ae_sensorSensitivity) {
    mk_ae_sensorSensitivity_low,
    mk_ae_sensorSensitivity_medium,
    mk_ae_sensorSensitivity_high,
    mk_ae_sensorSensitivity_all
};

typedef NS_ENUM(NSInteger, mk_ae_doorStatus) {
    mk_ae_doorStatus_close,
    mk_ae_doorStatus_open,
    mk_ae_doorStatus_all
};

typedef NS_ENUM(NSInteger, mk_ae_delayResponseStatus) {
    mk_ae_delayResponseStatus_low,
    mk_ae_delayResponseStatus_medium,
    mk_ae_delayResponseStatus_high,
    mk_ae_delayResponseStatus_all
};

@protocol mk_ae_indicatorSettingsProtocol <NSObject>

@property (nonatomic, assign)BOOL DeviceState;
@property (nonatomic, assign)BOOL LowPower;
@property (nonatomic, assign)BOOL NetworkCheck;
@property (nonatomic, assign)BOOL Broadcast;
@property (nonatomic, assign)BOOL InFix;
@property (nonatomic, assign)BOOL FixSuccessful;
@property (nonatomic, assign)BOOL FailToFix;

@end

@protocol mk_ae_timingModeReportingTimePointProtocol <NSObject>

/// 0~23
@property (nonatomic, assign)NSInteger hour;

/// 0-59
@property (nonatomic, assign)NSInteger minuteGear;

@end

@protocol mk_ae_timeSegmentedModeTimePeriodSettingProtocol <NSObject>

/// 0~24
@property (nonatomic, assign)NSInteger startHour;

/// 0-59
@property (nonatomic, assign)NSInteger startMinuteGear;

/// 0~24
@property (nonatomic, assign)NSInteger endHour;

/// 0-59
@property (nonatomic, assign)NSInteger endMinuteGear;

/// Report Interval   30s - 86400s
@property (nonatomic, assign)NSInteger interval;

@end

@protocol mk_ae_BLEFilterRawDataProtocol <NSObject>

/// The currently filtered data type, refer to the definition of different Bluetooth data types by the International Bluetooth Organization, 1 byte of hexadecimal data
@property (nonatomic, copy)NSString *dataType;

/// Data location to start filtering.
@property (nonatomic, assign)NSInteger minIndex;

/// Data location to end filtering.
@property (nonatomic, assign)NSInteger maxIndex;

/// The currently filtered content. If minIndex==0,maxIndex must be 0.The data length should be maxIndex-minIndex, if maxIndex=0&&minIndex==0, the item length is not checked whether it meets the requirements.MAX length:29 Bytes
@property (nonatomic, copy)NSString *rawData;

@end

#pragma mark ****************************************Delegate************************************************

@protocol mk_ae_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param deviceModel device
/*
 @{
 @"rssi":@(-55),
 @"peripheral":peripheral,
 @"deviceName":@"LW008-MT",
 
 @"deviceType":@"00",           //@"00":LR1110  @"10":L76
 @"txPower":@(-55),             //dBm
 @"deviceState":@"0",           //0 (Standby Mode), 1 (Timing Mode), 2 (Periodic Mode), 3 (Motion Mode)
 @"lowPower":@(lowPower),       //Whether the device is in a low battery state.
 @"needPassword":@(YES),
 @"idle":@(NO),               //Whether the device is idle.
 @"move":@(YES),               //Whether there is any movement from the last lora payload to the current broadcast moment (for example, 0 means no movement, 1 means movement).
 @"voltage":@"3.333",           //V
 @"macAddress":@"AA:BB:CC:DD:EE:FF",
 @"connectable":advDic[CBAdvertisementDataIsConnectable],
 }
 */
- (void)mk_ae_receiveDevice:(NSDictionary *)deviceModel;

@optional

/// Starts scanning equipment.
- (void)mk_ae_startScan;

/// Stops scanning equipment.
- (void)mk_ae_stopScan;

@end

@protocol mk_ae_storageDataDelegate <NSObject>

- (void)mk_ae_receiveStorageData:(NSString *)content;

@end


@protocol mk_ae_centralManagerLogDelegate <NSObject>

- (void)mk_ae_receiveLog:(NSString *)deviceLog;

@end
