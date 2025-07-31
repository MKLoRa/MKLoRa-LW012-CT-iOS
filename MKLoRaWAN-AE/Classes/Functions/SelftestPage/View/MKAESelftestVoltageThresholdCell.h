//
//  MKADSelftestVoltageThresholdCell.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2025/4/27.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAESelftestVoltageThresholdCellModel : NSObject

/// 当前cell所在的index
@property (nonatomic, assign)NSInteger index;

/// 左侧显示的msg
@property (nonatomic, copy)NSString *msg;

/// 0~20
@property (nonatomic, assign)NSInteger threshold;

@end

@protocol MKAESelftestVoltageThresholdCellDelegate <NSObject>

- (void)ae_selftestVoltageThresholdCell_thresholdChanged:(NSInteger)index threshold:(NSInteger)threshold;

@end

@interface MKAESelftestVoltageThresholdCell : MKBaseCell

@property (nonatomic, strong)MKAESelftestVoltageThresholdCellModel *dataModel;

@property (nonatomic, weak)id <MKAESelftestVoltageThresholdCellDelegate>delegate;

+ (MKAESelftestVoltageThresholdCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
