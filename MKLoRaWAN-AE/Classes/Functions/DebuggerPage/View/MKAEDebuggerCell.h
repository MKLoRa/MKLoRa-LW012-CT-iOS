//
//  MKAEDebuggerCell.h
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2021/12/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAEDebuggerCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *timeMsg;

@property (nonatomic, assign)BOOL selected;

@property (nonatomic, copy)NSString *logInfo;

@end

@protocol MKAEDebuggerCellDelegate <NSObject>

- (void)ae_debuggerCellSelectedChanged:(NSInteger)index selected:(BOOL)selected;

@end

@interface MKAEDebuggerCell : MKBaseCell

@property (nonatomic, strong)MKAEDebuggerCellModel *dataModel;

@property (nonatomic, weak)id <MKAEDebuggerCellDelegate>delegate;

+ (MKAEDebuggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
