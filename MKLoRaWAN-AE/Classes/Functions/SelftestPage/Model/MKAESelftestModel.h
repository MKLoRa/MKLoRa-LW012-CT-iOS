//
//  MKAESelftestModel.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAESelftestModel : NSObject

@property (nonatomic, copy)NSString *gps;

@property (nonatomic, copy)NSString *acceData;

@property (nonatomic, copy)NSString *flash;

@property (nonatomic, copy)NSString *pcbaStatus;

/// 0-2.2v  20-3.2v
@property (nonatomic, assign)NSInteger voltageThreshold1;

@property (nonatomic, copy)NSString *sampleInterval1;

@property (nonatomic, copy)NSString *sampleTimes1;


/// 0-2.2v  20-3.2v
@property (nonatomic, assign)NSInteger voltageThreshold2;

@property (nonatomic, copy)NSString *sampleInterval2;

@property (nonatomic, copy)NSString *sampleTimes2;


- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
