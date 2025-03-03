//
//  MKAELCGpsFixModel.m
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKAELCGpsFixModel.h"

#import "MKMacroDefines.h"

#import "MKAEInterface.h"
#import "MKAEInterface+MKAEConfig.h"

@interface MKAELCGpsFixModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKAELCGpsFixModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readPositioningTimeout]) {
            [self operationFailedBlockWithMsg:@"Read Positioning Timeout Error" block:failedBlock];
            return;
        }
        if (![self readPDOP]) {
            [self operationFailedBlockWithMsg:@"Read PDOP Error" block:failedBlock];
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
        if (![self configPositioningTimeout]) {
            [self operationFailedBlockWithMsg:@"Config Positioning Timeout Error" block:failedBlock];
            return;
        }
        if (![self configPDOP]) {
            [self operationFailedBlockWithMsg:@"Config PDOP Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interfae
- (BOOL)readPositioningTimeout {
    __block BOOL success = NO;
    [MKAEInterface ae_readGPSFixPositioningTimeoutWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.timeout = returnData[@"result"][@"timeout"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPositioningTimeout {
    __block BOOL success = NO;
    [MKAEInterface ae_configGPSFixPositioningTimeout:[self.timeout integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPDOP {
    __block BOOL success = NO;
    [MKAEInterface ae_readGPSFixPDOPWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.pdop = returnData[@"result"][@"pdop"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPDOP {
    __block BOOL success = NO;
    [MKAEInterface ae_configGPSFixPDOP:[self.pdop integerValue] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"LCGpsFixParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
//    if (self.advName.length > 16) {
//        return NO;
//    }
    if (!ValidStr(self.timeout) || [self.timeout integerValue] < 30 || [self.timeout integerValue] > 600) {
        return NO;
    }
    if (!ValidStr(self.pdop) || [self.pdop integerValue] < 25 || [self.pdop integerValue] > 100) {
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
        _readQueue = dispatch_queue_create("LCGpsFixQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
