//
//  MKAEScanPageCell.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKAEScanPageCellDelegate <NSObject>

/// 连接按钮点击事件
/// @param index 当前cell的row
- (void)ae_scanCellConnectButtonPressed:(NSInteger)index;

@end

@class MKAEScanPageModel;
@interface MKAEScanPageCell : MKBaseCell

@property (nonatomic, strong)MKAEScanPageModel *dataModel;

@property (nonatomic, weak)id <MKAEScanPageCellDelegate>delegate;

+ (MKAEScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
