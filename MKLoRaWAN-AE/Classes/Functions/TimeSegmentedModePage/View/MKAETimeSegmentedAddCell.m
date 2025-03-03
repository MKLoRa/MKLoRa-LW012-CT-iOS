//
//  MKAETimeSegmentedAddCell.m
//  MKLoRaWAN-AE_Example
//
//  Created by aa on 2024/11/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKAETimeSegmentedAddCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKAETimeSegmentedAddCellModel
@end

@interface MKAETimeSegmentedAddCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *addButton;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKAETimeSegmentedAddCell

+ (MKAETimeSegmentedAddCell *)initCellWithTableView:(UITableView *)tableView {
    MKAETimeSegmentedAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKAETimeSegmentedAddCellIdenty"];
    if (!cell) {
        cell = [[MKAETimeSegmentedAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKAETimeSegmentedAddCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.addButton];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.addButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.addButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    CGSize noteSize = [NSString sizeWithText:self.noteLabel.text
                                     andFont:self.noteLabel.font
                                  andMaxSize:CGSizeMake(self.contentView.frame.size.width - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.addButton.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(noteSize.height);
    }];
}

#pragma mark - event method
- (void)addButtonPressed {
    if ([self.delegate respondsToSelector:@selector(ae_timeSegmentedAddCell_addPressed)]) {
        [self.delegate ae_timeSegmentedAddCell_addPressed];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKAETimeSegmentedAddCellModel *)dataModel {
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKAETimeSegmentedAddCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:LOADICON(@"MKLoRaWAN-AE", @"MKAETimeSegmentedAddCell", @"ae_addIcon.png") forState:UIControlStateNormal];
        [_addButton addTarget:self
                       action:@selector(addButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = DEFAULT_TEXT_COLOR;
        _noteLabel.font = MKFont(12.f);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = @"*Swipe your finger from right to left on the screen to delete the time period.";
        
    }
    return _noteLabel;
}

@end
