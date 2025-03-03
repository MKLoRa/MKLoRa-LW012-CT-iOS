//
//  MKAETimeSegmentedAddCell.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/11/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAETimeSegmentedAddCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@end

@protocol MKAETimeSegmentedAddCellDelegate <NSObject>

- (void)ae_timeSegmentedAddCell_addPressed;

@end

@interface MKAETimeSegmentedAddCell : MKBaseCell

@property (nonatomic, strong)MKAETimeSegmentedAddCellModel *dataModel;

@property (nonatomic, weak)id <MKAETimeSegmentedAddCellDelegate>delegate;

+ (MKAETimeSegmentedAddCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
