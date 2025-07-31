//
//  MKAECentralManager.m
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKAECentralManager.h"

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseLogManager.h"

#import "MKAEPeripheral.h"
#import "MKAEOperation.h"
#import "CBPeripheral+MKAEAdd.h"

static NSString *const mk_ae_logName = @"mk_ae_bleLog";

NSString *const mk_ae_peripheralConnectStateChangedNotification = @"mk_ae_peripheralConnectStateChangedNotification";
NSString *const mk_ae_centralManagerStateChangedNotification = @"mk_ae_centralManagerStateChangedNotification";

NSString *const mk_ae_deviceDisconnectTypeNotification = @"mk_ae_deviceDisconnectTypeNotification";

static MKAECentralManager *manager = nil;
static dispatch_once_t onceToken;

//@interface NSObject (MKAECentralManager)
//
//@end
//
//@implementation NSObject (MKAECentralManager)
//
//+ (void)load{
//    [MKAECentralManager shared];
//}
//
//@end

@interface MKAECentralManager ()

@property (nonatomic, copy)NSString *password;

@property (nonatomic, copy)void (^sucBlock)(CBPeripheral *peripheral);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@property (nonatomic, assign)mk_ae_centralConnectStatus connectStatus;

@end

@implementation MKAECentralManager

- (void)dealloc {
    [self logToLocal:@"MKAECentralManager销毁"];
    NSLog(@"MKAECentralManager销毁");
}

- (instancetype)init {
    if (self = [super init]) {
        [self logToLocal:@"MKAECentralManager初始化"];
        [[MKBLEBaseCentralManager shared] loadDataManager:self];
    }
    return self;
}

+ (MKAECentralManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKAECentralManager new];
        }
    });
    return manager;
}

+ (void)sharedDealloc {
    [MKBLEBaseCentralManager singleDealloc];
    manager = nil;
    onceToken = 0;
}

+ (void)removeFromCentralList {
    [[MKBLEBaseCentralManager shared] removeDataManager:manager];
    manager = nil;
    onceToken = 0;
}

#pragma mark - MKBLEBaseScanProtocol
- (void)MKBLEBaseCentralManagerDiscoverPeripheral:(CBPeripheral *)peripheral
                                advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                                             RSSI:(NSNumber *)RSSI {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@",advertisementData);
        NSDictionary *dataModel = [self parseModelWithRssi:RSSI advDic:advertisementData peripheral:peripheral];
        if (!MKValidDict(dataModel)) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(mk_ae_receiveDevice:)]) {
                [self.delegate mk_ae_receiveDevice:dataModel];
            }
        });
    });
}

- (void)MKBLEBaseCentralManagerStartScan {
    [self logToLocal:@"开始扫描"];
    if ([self.delegate respondsToSelector:@selector(mk_ae_startScan)]) {
        [self.delegate mk_ae_startScan];
    }
}

- (void)MKBLEBaseCentralManagerStopScan {
    [self logToLocal:@"停止扫描"];
    if ([self.delegate respondsToSelector:@selector(mk_ae_stopScan)]) {
        [self.delegate mk_ae_stopScan];
    }
}

#pragma mark - MKBLEBaseCentralManagerStateProtocol
- (void)MKBLEBaseCentralManagerStateChanged:(MKCentralManagerState)centralManagerState {
    NSLog(@"蓝牙中心改变");
    NSString *string = [NSString stringWithFormat:@"蓝牙中心改变:%@",@(centralManagerState)];
    [self logToLocal:string];
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_ae_centralManagerStateChangedNotification object:nil];
}

- (void)MKBLEBasePeripheralConnectStateChanged:(MKPeripheralConnectState)connectState {
    //连接成功的判断必须是发送密码成功之后
    if (connectState == MKPeripheralConnectStateUnknow) {
        self.connectStatus = mk_ae_centralConnectStatusUnknow;
    }else if (connectState == MKPeripheralConnectStateConnecting) {
        self.connectStatus = mk_ae_centralConnectStatusConnecting;
    }else if (connectState == MKPeripheralConnectStateConnectedFailed) {
        self.connectStatus = mk_ae_centralConnectStatusConnectedFailed;
    }else if (connectState == MKPeripheralConnectStateDisconnect) {
        self.connectStatus = mk_ae_centralConnectStatusDisconnect;
    }
    NSLog(@"当前连接状态发生改变了:%@",@(connectState));
    NSString *string = [NSString stringWithFormat:@"连接状态发生改变:%@",@(connectState)];
    [self logToLocal:string];
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_ae_peripheralConnectStateChangedNotification object:nil];
}

#pragma mark - MKBLEBaseCentralManagerProtocol
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        [self logToLocal:@"+++++++++++++++++接收数据出错"];
        NSLog(@"+++++++++++++++++接收数据出错");
        return;
    }
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA05"]]) {
        //非日志
        NSString *string = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        [self saveToLogData:string appToDevice:NO];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        //引起设备断开连接的类型
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_ae_deviceDisconnectTypeNotification
                                                            object:nil
                                                          userInfo:@{@"type":[content substringWithRange:NSMakeRange(10, 2)]}];
        return;
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA05"]]) {
        //设备存储的数据
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        if (!MKValidStr(content)) {
            return;
        }
        if ([self.dataDelegate respondsToSelector:@selector(mk_ae_receiveStorageData:)]) {
            [self.dataDelegate mk_ae_receiveStorageData:content];
        }
        return;
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
        //日志
        NSString *content = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        if (!MKValidStr(content)) {
            return;
        }
        [self saveToLogData:content appToDevice:NO];
        if ([self.logDelegate respondsToSelector:@selector(mk_ae_receiveLog:)]) {
            [self.logDelegate mk_ae_receiveLog:content];
        }
        return;
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++发送数据出错");
        [self logToLocal:@"发送数据出错"];
        return;
    }
    
}

#pragma mark - public method
- (CBCentralManager *)centralManager {
    return [MKBLEBaseCentralManager shared].centralManager;
}

- (CBPeripheral *)peripheral {
    return [MKBLEBaseCentralManager shared].peripheral;
}

- (mk_ae_centralManagerStatus )centralStatus {
    return ([MKBLEBaseCentralManager shared].centralStatus == MKCentralManagerStateEnable)
    ? mk_ae_centralManagerStatusEnable
    : mk_ae_centralManagerStatusUnable;
}

- (void)startScan {
    [[MKBLEBaseCentralManager shared] scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"AA17"]] options:nil];
}

- (void)stopScan {
    [[MKBLEBaseCentralManager shared] stopScan];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
                 sucBlock:(void (^)(CBPeripheral * _Nonnull))sucBlock
              failedBlock:(void (^)(NSError * error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    if (password.length != 8 || ![MKBLEBaseSDKAdopter asciiString:password]) {
        [self operationFailedBlockWithMsg:@"The password should be 8 characters." failedBlock:failedBlock];
        return;
    }
    self.password = @"";
    self.password = password;
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    self.password = @"";
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)disconnect {
    [[MKBLEBaseCentralManager shared] disconnect];
}

- (void)addTaskWithTaskID:(mk_ae_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock {
    MKAEOperation <MKBLEBaseOperationProtocol>*operation = [self generateOperationWithOperationID:operationID
                                                                                   characteristic:characteristic
                                                                                      commandData:commandData
                                                                                     successBlock:successBlock
                                                                                     failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addReadTaskWithTaskID:(mk_ae_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock {
    MKAEOperation <MKBLEBaseOperationProtocol>*operation = [self generateReadOperationWithOperationID:operationID
                                                                                       characteristic:characteristic
                                                                                         successBlock:successBlock
                                                                                         failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addOperation:(MKAEOperation *)operation {
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (BOOL)notifyStorageData:(BOOL)notify {
    if (self.connectStatus != mk_ae_centralConnectStatusConnected || [MKBLEBaseCentralManager shared].peripheral == nil || [MKBLEBaseCentralManager shared].peripheral.ae_storageData == nil) {
        return NO;
    }
    [[MKBLEBaseCentralManager shared].peripheral setNotifyValue:notify
                                              forCharacteristic:[MKBLEBaseCentralManager shared].peripheral.ae_storageData];
    return YES;
}

- (BOOL)notifyLogData:(BOOL)notify {
    if (self.connectStatus != mk_ae_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.ae_log == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.ae_log];
    return YES;
}

#pragma mark - password method
- (void)connectPeripheral:(CBPeripheral *)peripheral
             successBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    MKAEPeripheral *trackerPeripheral = [[MKAEPeripheral alloc] initWithPeripheral:peripheral];
    [[MKBLEBaseCentralManager shared] connectDevice:trackerPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        if (MKValidStr(self.password) && self.password.length == 8) {
            //需要密码登录
            [self logToLocal:@"密码登录"];
            [self sendPasswordToDevice];
            return;
        }
        //免密登录
        [self logToLocal:@"免密登录"];
        MKBLEBase_main_safe(^{
            self.connectStatus = mk_ae_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_ae_peripheralConnectStateChangedNotification object:nil];
            if (self.sucBlock) {
                self.sucBlock(peripheral);
            }
        });
    } failedBlock:failedBlock];
}

- (void)sendPasswordToDevice {
    NSString *commandData = @"ed01000108";
    for (NSInteger i = 0; i < self.password.length; i ++) {
        int asciiCode = [self.password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    __weak typeof(self) weakSelf = self;
    MKAEOperation *operation = [[MKAEOperation alloc] initOperationWithID:mk_ae_connectPasswordOperation commandBlock:^{
        __strong typeof(self) sself = weakSelf;
        [sself saveToLogData:commandData appToDevice:YES];
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBLEBaseCentralManager shared].peripheral.ae_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error || !MKValidDict(returnData) || ![returnData[@"state"] isEqualToString:@"01"]) {
            //密码错误
            [sself operationFailedBlockWithMsg:@"Password Error" failedBlock:sself.failedBlock];
            return ;
        }
        //密码正确
        MKBLEBase_main_safe(^{
            sself.connectStatus = mk_ae_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_ae_peripheralConnectStateChangedNotification object:nil];
            if (sself.sucBlock) {
                sself.sucBlock([MKBLEBaseCentralManager shared].peripheral);
            }
        });
    }];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

#pragma mark - task method
- (MKAEOperation <MKBLEBaseOperationProtocol>*)generateOperationWithOperationID:(mk_ae_taskOperationID)operationID
                                                                 characteristic:(CBCharacteristic *)characteristic
                                                                    commandData:(NSString *)commandData
                                                                   successBlock:(void (^)(id returnData))successBlock
                                                                   failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!MKValidStr(commandData)) {
        [self operationFailedBlockWithMsg:@"The data sent to the device cannot be empty" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKAEOperation <MKBLEBaseOperationProtocol>*operation = [[MKAEOperation alloc] initOperationWithID:operationID commandBlock:^{
        __strong typeof(self) sself = weakSelf;
        [sself saveToLogData:commandData appToDevice:YES];
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData,
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

- (MKAEOperation <MKBLEBaseOperationProtocol>*)generateReadOperationWithOperationID:(mk_ae_taskOperationID)operationID
                                                                     characteristic:(CBCharacteristic *)characteristic
                                                                       successBlock:(void (^)(id returnData))successBlock
                                                                       failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKAEOperation <MKBLEBaseOperationProtocol>*operation = [[MKAEOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBLEBaseCentralManager shared].peripheral readValueForCharacteristic:characteristic];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData,
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

#pragma mark - private method
- (NSDictionary *)parseModelWithRssi:(NSNumber *)rssi advDic:(NSDictionary *)advDic peripheral:(CBPeripheral *)peripheral {
    if ([rssi integerValue] == 127 || !MKValidDict(advDic) || !peripheral) {
        return @{};
    }
    
    NSData *manufacturerData = advDic[@"kCBAdvDataServiceData"][[CBUUID UUIDWithString:@"AA17"]];
//    if (manufacturerData.length != 10) {
//        return @{};
//    }
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:manufacturerData];
    
    NSString *deviceType = [content substringWithRange:NSMakeRange(0, 2)];
    
    NSString *deviceState = [content substringWithRange:NSMakeRange(2, 2)];
    
    NSString *binary = [MKBLEBaseSDKAdopter binaryByhex:deviceState];
    
    NSString *workModeBinary = [binary substringWithRange:NSMakeRange(4, 2)];
    NSString *workMode = @"0";
    if ([workModeBinary isEqualToString:@"0001"]) {
        workMode = @"1";
    }else if ([workModeBinary isEqualToString:@"0010"]) {
        workMode = @"2";
    }else if ([workModeBinary isEqualToString:@"0011"]) {
        workMode = @"3";
    }else if ([workModeBinary isEqualToString:@"0100"]) {
        workMode = @"4";
    }
    
    BOOL lowPower = [[binary substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"];
    BOOL needPassword = [[binary substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"];
    BOOL idle = [[binary substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"1"];
    BOOL moved = [[binary substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"];
    
    NSString *voltage = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
    
    
    NSString *tempMac = [[content substringWithRange:NSMakeRange(8, 12)] uppercaseString];
    NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
    [tempMac substringWithRange:NSMakeRange(0, 2)],
    [tempMac substringWithRange:NSMakeRange(2, 2)],
    [tempMac substringWithRange:NSMakeRange(4, 2)],
    [tempMac substringWithRange:NSMakeRange(6, 2)],
    [tempMac substringWithRange:NSMakeRange(8, 2)],
    [tempMac substringWithRange:NSMakeRange(10, 2)]];
    
    [self logToLocal:[@"扫描到设备:" stringByAppendingString:content]];
    
    return @{
        @"rssi":rssi,
        @"peripheral":peripheral,
        @"deviceName":(advDic[CBAdvertisementDataLocalNameKey] ? advDic[CBAdvertisementDataLocalNameKey] : @""),
        @"txPower":(advDic[CBAdvertisementDataTxPowerLevelKey] ? advDic[CBAdvertisementDataTxPowerLevelKey] : @""),
        @"deviceType":deviceType,
        @"voltage":voltage,
        @"moved":@(moved),
        @"lowPower":@(lowPower),
        @"needPassword":@(needPassword),
        @"idle":@(idle),
        @"workMode":workMode,
        @"macAddress":macAddress,
        @"connectable":advDic[CBAdvertisementDataIsConnectable],
    };
}

- (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.MPCentralManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    MKBLEBase_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

- (void)saveToLogData:(NSString *)string appToDevice:(BOOL)app {
    if (!MKValidStr(string)) {
        return;
    }
    NSString *fuction = (app ? @"App To Device" : @"Device To App");
    NSString *recordString = [NSString stringWithFormat:@"%@---->%@",fuction,string];
    [self logToLocal:recordString];
}

- (void)logToLocal:(NSString *)string {
    if (!MKValidStr(string)) {
        return;
    }
    [MKBLEBaseLogManager saveDataWithFileName:mk_ae_logName dataList:@[string]];
}

@end
