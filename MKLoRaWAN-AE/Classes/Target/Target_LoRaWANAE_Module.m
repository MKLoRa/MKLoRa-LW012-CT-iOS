//
//  Target_LoRaWANAE_Module.m
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "Target_LoRaWANAE_Module.h"

#import "MKAEScanController.h"

#import "MKAEAboutController.h"

@implementation Target_LoRaWANAE_Module

/// 扫描页面
- (UIViewController *)Action_LoRaWANAE_Module_ScanController:(NSDictionary *)params {
    MKAEScanController *vc = [[MKAEScanController alloc] init];
    vc.deviceType = [params[@"deviceType"] integerValue];
    return vc;
}

/// 关于页面
- (UIViewController *)Action_LoRaWANAE_Module_AboutController:(NSDictionary *)params {
    return [[MKAEAboutController alloc] init];
}

@end
