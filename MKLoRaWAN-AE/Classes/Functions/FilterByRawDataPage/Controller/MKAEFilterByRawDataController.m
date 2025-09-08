//
//  MKAEFilterByRawDataController.m
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKAEFilterByRawDataController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKNormalTextCell.h"

#import "MKFilterByBeaconController.h"
#import "MKFilterByBXPButtonController.h"
#import "MKFilterByBXPTagController.h"
#import "MKFilterByOtherController.h"
#import "MKFilterByPirController.h"
#import "MKFilterByTLMController.h"
#import "MKFilterByTofController.h"
#import "MKFilterByUIDController.h"
#import "MKFilterByURLController.h"

#import "MKAEInterface+MKAEConfig.h"

#import "MKAEFilterByRawDataModel.h"

#import "MKAEFilterByBeaconModel.h"
#import "MKAEFilterByBXPButtonModel.h"
#import "MKAEFilterByBXPTagModel.h"
#import "MKAEFilterByOtherModel.h"
#import "MKAEFilterByPirModel.h"
#import "MKAEFilterByTLMModel.h"
#import "MKAEFilterByTofModel.h"
#import "MKAEFilterByUIDModel.h"
#import "MKAEFilterByURLModel.h"

@interface MKAEFilterByRawDataController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKAEFilterByRawDataModel *dataModel;

@end

@implementation MKAEFilterByRawDataController

- (void)dealloc {
    NSLog(@"MKAEFilterByRawDataController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDatasFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //iBeacon
        MKFilterByBeaconController *vc = [[MKFilterByBeaconController alloc] init];
        MKAEFilterByBeaconModel *model = [[MKAEFilterByBeaconModel alloc] init];
        model.pageType = mk_filterByBeaconPageType_beacon;
        model.pageTitle = @"iBeacon Filter";
        vc.protocol = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        //Eddystone-UID
        MKFilterByUIDController *vc = [[MKFilterByUIDController alloc] init];
        MKAEFilterByUIDModel *model = [[MKAEFilterByUIDModel alloc] init];
        model.pageTitle = @"Eddystone-UID Filter";
        vc.protocol = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        //Eddystone-URL
        MKFilterByURLController *vc = [[MKFilterByURLController alloc] init];
        MKAEFilterByURLModel *model = [[MKAEFilterByURLModel alloc] init];
        model.pageTitle = @"Eddystone-URL Filter";
        vc.protocol = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        //Eddystone-TLM
        MKFilterByTLMController *vc = [[MKFilterByTLMController alloc] init];
        MKAEFilterByTLMModel *model = [[MKAEFilterByTLMModel alloc] init];
        model.pageTitle = @"Eddystone-TLM Filter";
        vc.protocol = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 4) {
        //BXP-iBeacon
        MKFilterByBeaconController *vc = [[MKFilterByBeaconController alloc] init];
        MKAEFilterByBeaconModel *model = [[MKAEFilterByBeaconModel alloc] init];
        model.pageType = mk_filterByBeaconPageType_bxpBeacon;
        model.pageTitle = @"BXP-iBeacon Filter";
        vc.protocol = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        //BXP-Button
        MKFilterByBXPButtonController *vc = [[MKFilterByBXPButtonController alloc] init];
        MKAEFilterByBXPButtonModel *model = [[MKAEFilterByBXPButtonModel alloc] init];
        model.pageTitle = @"BXP-Button Filter";
        vc.protocol = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        //BXP - Tag
        MKFilterByBXPTagController *vc = [[MKFilterByBXPTagController alloc] init];
        MKAEFilterByBXPTagModel *model = [[MKAEFilterByBXPTagModel alloc] init];
        model.pageTitle = @"BXP-T&S";
        vc.protocol = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        //MK-PIR
        MKFilterByPirController *vc = [[MKFilterByPirController alloc] init];
        MKAEFilterByPirModel *model = [[MKAEFilterByPirModel alloc] init];
        model.pageTitle = @"MK-PIR Filter";
        vc.protocol = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 2 && indexPath.row == 3) {
        //MK-TOF
        MKFilterByTofController *vc = [[MKFilterByTofController alloc] init];
        MKAEFilterByTofModel *model = [[MKAEFilterByTofModel alloc] init];
        model.pageTitle = @"MK-TOF Filter";
        vc.protocol = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 2 && indexPath.row == 4) {
        //Other
        MKFilterByOtherController *vc = [[MKFilterByOtherController alloc] init];
        MKAEFilterByOtherModel *model = [[MKAEFilterByOtherModel alloc] init];
        model.pageTitle = @"Other Type Filter";
        vc.protocol = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //BXP - Device Info
        [self configDeviceInfo:isOn];
        return;
    }
    if (index == 1) {
        //BXP - ACC
        [self configBXPAcc:isOn];
        return;
    }
    if (index == 2) {
        //BeaconX Pro - T&H
        [self configBXPTH:isOn];
        return;
    }
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateCellStatus];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configDeviceInfo:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKAEInterface ae_configFilterByBXPDeviceInfoStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.bxpDeviceInfo = isOn;
        MKTextSwitchCellModel *cellModel = self.section1List[0];
        cellModel.isOn = isOn;
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)configBXPAcc:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKAEInterface ae_configBXPAccFilterStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.bxpAcc = isOn;
        MKTextSwitchCellModel *cellModel = self.section1List[1];
        cellModel.isOn = isOn;
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)configBXPTH:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKAEInterface ae_configBXPTHFilterStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.bxpTH = isOn;
        MKTextSwitchCellModel *cellModel = self.section1List[2];
        cellModel.isOn = isOn;
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadRow:2 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - loadSectionDatas
- (void)updateCellStatus {
    MKNormalTextCellModel *cellModel1 = self.section0List[0];
    cellModel1.rightMsg = (self.dataModel.iBeacon ? @"ON" : @"OFF");
    
    MKNormalTextCellModel *cellModel2 = self.section0List[1];
    cellModel2.rightMsg = (self.dataModel.uid ? @"ON" : @"OFF");
    
    MKNormalTextCellModel *cellModel3 = self.section0List[2];
    cellModel3.rightMsg = (self.dataModel.url ? @"ON" : @"OFF");
    
    MKNormalTextCellModel *cellModel4 = self.section0List[3];
    cellModel4.rightMsg = (self.dataModel.tlm ? @"ON" : @"OFF");
    
    MKNormalTextCellModel *cellModel5 = self.section0List[4];
    cellModel5.rightMsg = (self.dataModel.bxpBeacon ? @"ON" : @"OFF");
    
    MKTextSwitchCellModel *cellModel6 = self.section1List[0];
    cellModel6.isOn = self.dataModel.bxpDeviceInfo;
    
    MKTextSwitchCellModel *cellModel7 = self.section1List[1];
    cellModel7.isOn = self.dataModel.bxpAcc;
    
    MKTextSwitchCellModel *cellModel8 = self.section1List[2];
    cellModel8.isOn = self.dataModel.bxpTH;
    
    MKNormalTextCellModel *cellModel9 = self.section2List[0];
    cellModel9.rightMsg = (self.dataModel.bxpButton ? @"ON" : @"OFF");
    
    MKNormalTextCellModel *cellModel10 = self.section2List[1];
    cellModel10.rightMsg = (self.dataModel.bxpTag ? @"ON" : @"OFF");
    
    MKNormalTextCellModel *cellModel11 = self.section2List[2];
    cellModel11.rightMsg = (self.dataModel.pir ? @"ON" : @"OFF");
    
    MKNormalTextCellModel *cellModel12 = self.section2List[3];
    cellModel12.rightMsg = (self.dataModel.tof ? @"ON" : @"OFF");
    
    MKNormalTextCellModel *cellModel13 = self.section2List[4];
    cellModel13.rightMsg = (self.dataModel.other ? @"ON" : @"OFF");
    
    [self.tableView reloadData];
}

- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.showRightIcon = YES;
    cellModel1.leftMsg = @"iBeacon";
    [self.section0List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.showRightIcon = YES;
    cellModel2.leftMsg = @"Eddystone-UID";
    [self.section0List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.showRightIcon = YES;
    cellModel3.leftMsg = @"Eddystone-URL";
    [self.section0List addObject:cellModel3];
    
    MKNormalTextCellModel *cellModel4 = [[MKNormalTextCellModel alloc] init];
    cellModel4.showRightIcon = YES;
    cellModel4.leftMsg = @"Eddystone-TLM";
    [self.section0List addObject:cellModel4];
    
    MKNormalTextCellModel *cellModel5 = [[MKNormalTextCellModel alloc] init];
    cellModel5.showRightIcon = YES;
    cellModel5.leftMsg = @"BXP-iBeacon";
    [self.section0List addObject:cellModel5];
}

- (void)loadSection1Datas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"BXP - Device Info";
    [self.section1List addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"BXP - ACC";
    [self.section1List addObject:cellModel2];
    
    MKTextSwitchCellModel *cellModel3 = [[MKTextSwitchCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"BXP - T&H";
    [self.section1List addObject:cellModel3];
}

- (void)loadSection2Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.showRightIcon = YES;
    cellModel1.leftMsg = @"BXP - Button";
    [self.section2List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.showRightIcon = YES;
    cellModel2.leftMsg = @"BXP - T&S";
    [self.section2List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.showRightIcon = YES;
    cellModel3.leftMsg = @"MK - PIR";
    [self.section2List addObject:cellModel3];
    
    MKNormalTextCellModel *cellModel4 = [[MKNormalTextCellModel alloc] init];
    cellModel4.showRightIcon = YES;
    cellModel4.leftMsg = @"BXP-TOF";
    [self.section2List addObject:cellModel4];
    
    MKNormalTextCellModel *cellModel5 = [[MKNormalTextCellModel alloc] init];
    cellModel5.showRightIcon = YES;
    cellModel5.leftMsg = @"Other";
    [self.section2List addObject:cellModel5];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Filter by Raw Data";
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

- (MKAEFilterByRawDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKAEFilterByRawDataModel alloc] init];
    }
    return _dataModel;
}

@end
