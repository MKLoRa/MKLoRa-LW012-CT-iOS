//
//  MKAETamperAlarmModel.m
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2025/3/2.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKAETamperAlarmModel.h"

#import "MKMacroDefines.h"

#import "MKAEInterface.h"
#import "MKAEInterface+MKAEConfig.h"

@interface MKAETamperAlarmModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKAETamperAlarmModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readFunctionSwitch]) {
            [self operationFailedBlockWithMsg:@"Read Function Switch Error" block:failedBlock];
            return;
        }
        if (![self readLightThreshold]) {
            [self operationFailedBlockWithMsg:@"Read Light Threshold Error" block:failedBlock];
            return;
        }
        if (![self readReportInterval]) {
            [self operationFailedBlockWithMsg:@"Read Report Interval Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self checkParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configFunctionSwitch]) {
            [self operationFailedBlockWithMsg:@"Config Function Switch Error" block:failedBlock];
            return;
        }
        if (![self configLightThreshold]) {
            [self operationFailedBlockWithMsg:@"Config Light Threshold Error" block:failedBlock];
            return;
        }
        if (![self configReportInterval]) {
            [self operationFailedBlockWithMsg:@"Config Report Interval Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)resetIdleStatusWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    [MKAEInterface ae_configIdleStutasResetWithSucBlock:sucBlock failedBlock:failedBlock];
}

#pragma mark - interface
- (BOOL)readFunctionSwitch {
    __block BOOL success = NO;
    [MKAEInterface ae_readTamperAlarmStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFunctionSwitch {
    __block BOOL success = NO;
    [MKAEInterface ae_configTamperAlarmStatus:self.isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readLightThreshold {
    __block BOOL success = NO;
    [MKAEInterface ae_readTamperAlarmThresholdsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.threshold = returnData[@"result"][@"threshold"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configLightThreshold {
    __block BOOL success = NO;
    [MKAEInterface ae_configTamperAlarmThresholds:[self.threshold integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readReportInterval {
    __block BOOL success = NO;
    [MKAEInterface ae_readTamperAlarmReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.interval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configReportInterval {
    __block BOOL success = NO;
    [MKAEInterface ae_configTamperAlarmReportInterval:[self.interval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"TamperAlarmParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)checkParams {
    if (!ValidStr(self.interval) || [self.interval integerValue] < 1 || [self.interval integerValue] > 8760) {
        return NO;
    }
    return YES;
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("TamperAlarmQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
