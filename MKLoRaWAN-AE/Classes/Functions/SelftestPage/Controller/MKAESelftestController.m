//
//  MKAESelftestController.m
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKAESelftestController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"
#import "MKTextFieldCell.h"

#import "MKAESelftestModel.h"

#import "MKAESelftestCell.h"
#import "MKAEPCBAStatusCell.h"
#import "MKAESelftestVoltageThresholdCell.h"

@interface MKAESelftestController ()<UITableViewDelegate,
UITableViewDataSource,
MKAESelftestVoltageThresholdCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKAESelftestModel *dataModel;

@end

@implementation MKAESelftestController

- (void)dealloc {
    NSLog(@"MKAESelftestController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60.f;
    }
    
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.section3List.count;
    }
    if (section == 4) {
        return self.section4List.count;
    }
    if (section == 5) {
        return self.section5List.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKAESelftestCell *cell = [MKAESelftestCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKAEPCBAStatusCell *cell = [MKAEPCBAStatusCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 2) {
        MKAESelftestVoltageThresholdCell *cell = [MKAESelftestVoltageThresholdCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        MKAESelftestVoltageThresholdCell *cell = [MKAESelftestVoltageThresholdCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section5List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Condition1 Min. Sample Interval
        self.dataModel.sampleInterval1 = value;
        MKTextFieldCellModel *cellModel = self.section3List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //Condition1 Sample Times
        self.dataModel.sampleTimes1 = value;
        MKTextFieldCellModel *cellModel = self.section3List[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        //Condition2 Min. Sample Interval
        self.dataModel.sampleInterval2 = value;
        MKTextFieldCellModel *cellModel = self.section5List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 3) {
        //Condition2 Sample Times
        self.dataModel.sampleTimes2 = value;
        MKTextFieldCellModel *cellModel = self.section5List[1];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKADSelftestVoltageThresholdCellDelegate
- (void)ae_selftestVoltageThresholdCell_thresholdChanged:(NSInteger)index threshold:(NSInteger)threshold {
    if (index == 0) {
        //Condition1 Voltage Threshold
        self.dataModel.voltageThreshold1 = threshold;
        MKAESelftestVoltageThresholdCellModel *cellModel = self.section2List[0];
        cellModel.threshold = threshold;
        return;
    }
    if (index == 1) {
        //Condition2 Voltage Threshold
        self.dataModel.voltageThreshold2 = threshold;
        MKAESelftestVoltageThresholdCellModel *cellModel = self.section4List[0];
        cellModel.threshold = threshold;
        return;
    }
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSections
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    
    for (NSInteger i = 0; i < 6; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKAESelftestCellModel *cellModel = [[MKAESelftestCellModel alloc] init];
    if ([self.dataModel.gps integerValue] == 0 && [self.dataModel.acceData integerValue] == 0 && [self.dataModel.flash integerValue] == 0) {
        cellModel.value0 = @"0";
    }
    cellModel.value1 = ([self.dataModel.gps integerValue] == 1 ? @"1" : @"");
    cellModel.value2 = ([self.dataModel.acceData integerValue] == 1 ? @"2" : @"");
    cellModel.value3 = ([self.dataModel.flash integerValue] == 1 ? @"3" : @"");
    
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKAEPCBAStatusCellModel *cellModel = [[MKAEPCBAStatusCellModel alloc] init];
    cellModel.value0 = (([self.dataModel.pcbaStatus integerValue] == 0) ? @"0" : @"");
    cellModel.value1 = (([self.dataModel.pcbaStatus integerValue] == 1) ? @"1" : @"");
    cellModel.value2 = (([self.dataModel.pcbaStatus integerValue] == 2) ? @"2" : @"");
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKAESelftestVoltageThresholdCellModel *cellModel = [[MKAESelftestVoltageThresholdCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Condition 1 Voltage Threshold";
    cellModel.threshold = self.dataModel.voltageThreshold1;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Min. Sample Interval";
    cellModel1.textPlaceholder = @"1~1440";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.maxLength = 4;
    cellModel1.unit = @"Mins";
    cellModel1.textFieldValue = self.dataModel.sampleInterval1;
    [self.section3List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Sample Times";
    cellModel2.textPlaceholder = @"1~100";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.maxLength = 3;
    cellModel2.unit = @"Times";
    cellModel2.textFieldValue = self.dataModel.sampleTimes1;
    [self.section3List addObject:cellModel2];
}

- (void)loadSection4Datas {
    MKAESelftestVoltageThresholdCellModel *cellModel = [[MKAESelftestVoltageThresholdCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Condition 2 Voltage Threshold";
    cellModel.threshold = self.dataModel.voltageThreshold2;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 2;
    cellModel1.msg = @"Min. Sample Interval";
    cellModel1.textPlaceholder = @"1~1440";
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.maxLength = 4;
    cellModel1.unit = @"Mins";
    cellModel1.textFieldValue = self.dataModel.sampleInterval2;
    [self.section5List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 3;
    cellModel2.msg = @"Sample Times";
    cellModel2.textPlaceholder = @"1~100";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.maxLength = 3;
    cellModel2.unit = @"Times";
    cellModel2.textFieldValue = self.dataModel.sampleTimes2;
    [self.section5List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Selftest Interface";
    [self.rightButton setImage:LOADICON(@"MKLoRaWAN-AE", @"MKAESelftestController", @"ae_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKAESelftestModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKAESelftestModel alloc] init];
    }
    return _dataModel;
}

@end
