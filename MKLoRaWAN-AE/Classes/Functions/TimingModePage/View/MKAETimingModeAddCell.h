//
//  MKAETimingModeAddCell.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2021/5/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAETimingModeAddCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@end

@protocol MKAETimingModeAddCellDelegate <NSObject>

- (void)ae_addButtonPressed;

@end

@interface MKAETimingModeAddCell : MKBaseCell

@property (nonatomic, strong)MKAETimingModeAddCellModel *dataModel;

@property (nonatomic, weak)id <MKAETimingModeAddCellDelegate>delegate;

+ (MKAETimingModeAddCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
