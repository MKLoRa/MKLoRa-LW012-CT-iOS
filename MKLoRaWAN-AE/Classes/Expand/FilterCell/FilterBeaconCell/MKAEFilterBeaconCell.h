//
//  MKAEFilterBeaconCell.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2021/11/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAEFilterBeaconCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *minValue;

@property (nonatomic, copy)NSString *maxValue;

@end

@protocol MKAEFilterBeaconCellDelegate <NSObject>

- (void)mk_ae_beaconMinValueChanged:(NSString *)value index:(NSInteger)index;

- (void)mk_ae_beaconMaxValueChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKAEFilterBeaconCell : MKBaseCell

@property (nonatomic, strong)MKAEFilterBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKAEFilterBeaconCellDelegate>delegate;

+ (MKAEFilterBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
