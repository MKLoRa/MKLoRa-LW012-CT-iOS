//
//  MKAEFilterByUIDModel.m
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2021/11/30.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKAEFilterByUIDModel.h"

#import "MKMacroDefines.h"

#import "MKAEInterface.h"
#import "MKAEInterface+MKAEConfig.h"

@interface MKAEFilterByUIDModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKAEFilterByUIDModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Read Filter Status Error" block:failedBlock];
            return;
        }
        if (![self readNamespaceID]) {
            [self operationFailedBlockWithMsg:@"Read Namespace ID Error" block:failedBlock];
            return;
        }
        if (![self readInstanceID]) {
            [self operationFailedBlockWithMsg:@"Read Instance ID Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Config Filter Status Error" block:failedBlock];
            return;
        }
        if (![self configNamespaceID]) {
            [self operationFailedBlockWithMsg:@"Config Namespace ID Error" block:failedBlock];
            return;
        }
        if (![self configInstanceID]) {
            [self operationFailedBlockWithMsg:@"Config Instance ID Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readFilterStatus {
    __block BOOL success = NO;
    [MKAEInterface ae_readFilterByUIDStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFilterStatus {
    __block BOOL success = NO;
    [MKAEInterface ae_configFilterByUIDStatus:self.isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNamespaceID {
    __block BOOL success = NO;
    [MKAEInterface ae_readFilterByUIDNamespaceIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.namespaceID = returnData[@"result"][@"namespaceID"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNamespaceID {
    __block BOOL success = NO;
    [MKAEInterface ae_configFilterByUIDNamespaceID:self.namespaceID sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}
- (BOOL)readInstanceID {
    __block BOOL success = NO;
    [MKAEInterface ae_readFilterByUIDInstanceIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.instanceID = returnData[@"result"][@"instanceID"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configInstanceID {
    __block BOOL success = NO;
    [MKAEInterface ae_configFilterByUIDInstanceID:self.instanceID sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"filterUIDParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (self.namespaceID.length > 20 || self.instanceID.length > 12 || self.namespaceID.length % 2 != 0 || self.instanceID.length % 2 != 0) {
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
        _readQueue = dispatch_queue_create("filterUIDQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
