//
//  MKAEFilterRelationshipCell.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAEFilterRelationshipCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger dataListIndex;

@property (nonatomic, strong)NSArray *dataList;

@end

@protocol MKAEFilterRelationshipCellDelegate <NSObject>

- (void)ae_filterRelationshipChanged:(NSInteger)index dataListIndex:(NSInteger)dataListIndex;

@end

@interface MKAEFilterRelationshipCell : MKBaseCell

@property (nonatomic, strong)MKAEFilterRelationshipCellModel *dataModel;

@property (nonatomic, weak)id <MKAEFilterRelationshipCellDelegate>delegate;

+ (MKAEFilterRelationshipCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
