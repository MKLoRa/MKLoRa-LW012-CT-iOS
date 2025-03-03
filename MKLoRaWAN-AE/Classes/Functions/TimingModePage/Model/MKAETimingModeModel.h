//
//  MKAETimingModeModel.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKAESDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAETimingModeTimePointModel : NSObject<mk_ae_timingModeReportingTimePointProtocol>

/// 0~23
@property (nonatomic, assign)NSInteger hour;

/// 0-59
@property (nonatomic, assign)NSInteger minuteGear;

@end

@interface MKAETimingModeModel : NSObject

/*
 0:BLE
 1:GPS
 2:BLE+GPS
 3:BLE*GPS
 */
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, strong)NSArray <MKAETimingModeTimePointModel *>*pointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configData:(NSArray <MKAETimingModeTimePointModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
