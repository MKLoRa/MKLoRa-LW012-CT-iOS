//
//  MKAEReportTimePointCell.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAEReportTimePointCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger timeSpace;

@end

@protocol MKAEReportTimePointCellDelegate <NSObject>

/**
 删除
 
 @param index 所在index
 */
- (void)ae_cellDeleteButtonPressed:(NSInteger)index;

/// 用户选择了hour事件
- (void)ae_hourButtonPressed:(NSInteger)index hour:(NSInteger)hour;

/// 用户选择了时间间隔事件
- (void)ae_timeSpaceButtonPressed:(NSInteger)index timeSpace:(NSInteger)timeSpace;

/**
 重新设置cell的子控件位置，主要是删除按钮方面的处理
 */
- (void)ae_cellResetFrame;

/// cell的点击事件，用来重置cell的布局
- (void)ae_cellTapAction;

@end

@interface MKAEReportTimePointCell : MKBaseCell

@property (nonatomic, weak)id <MKAEReportTimePointCellDelegate>delegate;

@property (nonatomic, strong)MKAEReportTimePointCellModel *dataModel;

+ (MKAEReportTimePointCell *)initCellWithTableView:(UITableView *)tableView;

- (BOOL)canReset;
- (void)resetCellFrame;
- (void)resetFlagForFrame;

@end

NS_ASSUME_NONNULL_END
