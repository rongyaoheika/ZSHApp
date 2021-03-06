//
//  ZSHAddressListCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHAddressListCell.h"

@interface ZSHAddressListCell()

@end

@implementation ZSHAddressListCell

- (void)setup{
    
    NSDictionary *nameLabelDic = @{@"text":@"王晶",@"font":kPingFangMedium(14)};
    _nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [self.contentView addSubview:_nameLabel];
    
    NSDictionary *addressLabelDic = @{@"text":@"13719143456",@"font":kPingFangLight(14)};
    _addressLabel = [ZSHBaseUIControl createLabelWithParamDic:addressLabelDic];
    _addressLabel.numberOfLines = 0;
    [self.contentView addSubview:_addressLabel];
    
    NSDictionary *telLabelDic = @{@"text":@"13719143456",@"font":kPingFangMedium(14),@"textAlignment":@(NSTextAlignmentRight)};
    _telLabel = [ZSHBaseUIControl createLabelWithParamDic:telLabelDic];
    [self.contentView addSubview:_telLabel];
    
    NSDictionary *defaultBtnDic = @{@"title":@"设为默认",@"font":kPingFangLight(11),@"normalImage":@"address_normal",@"selectedImage":@"address_press"};
    _defaultBtn = [ZSHBaseUIControl  createBtnWithParamDic:defaultBtnDic target:self action:@selector(btnAction:)];
    [self.contentView addSubview:_defaultBtn];
    
    NSDictionary *deleteBtnDic = @{@"title":@"删除",@"font":kPingFangLight(11),@"normalImage":@"address_delete"};
    _deleteBtn = [ZSHBaseUIControl  createBtnWithParamDic:deleteBtnDic target:self action:@selector(btnAction:)];
    [self.contentView addSubview:_deleteBtn];
    
    NSDictionary *editBtnDic = @{@"title":@"编辑",@"font":kPingFangLight(11),@"normalImage":@"address_edit"};
    _editBtn = [ZSHBaseUIControl  createBtnWithParamDic:editBtnDic target:self action:@selector(btnAction:) ];
    [self.contentView addSubview:_editBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(kRealValue(18.5));
        make.width.mas_equalTo(KScreenWidth * 0.5);
        make.height.mas_equalTo(kRealValue(14));
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(kRealValue(25));
        make.right.mas_equalTo(self).offset(-15);
        make.height.mas_equalTo(kRealValue(14));
    }];
    
    [_telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.top.mas_equalTo(_nameLabel);
        make.width.mas_equalTo(KScreenWidth*0.4);
        make.height.mas_equalTo(_nameLabel);
    }];
    
    [_defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.bottom.mas_equalTo(self).offset(-kRealValue(15));
        make.width.mas_equalTo(kRealValue(60));
        make.height.mas_equalTo(kRealValue(14));
    }];
    [_defaultBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(4)];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.bottom.mas_equalTo(_defaultBtn);
        make.width.mas_equalTo(kRealValue(40));
        make.height.mas_equalTo(_defaultBtn);
    }];
    [_deleteBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(4)];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_deleteBtn.mas_left).offset(-kRealValue(20));
        make.bottom.mas_equalTo(_defaultBtn);
        make.width.mas_equalTo(_deleteBtn);
        make.height.mas_equalTo(_deleteBtn);
    }];
    [_editBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(4)];

}

- (void)updateCellWithModel:(ZSHAddrModel *)model{
    self.nameLabel.text = model.CONSIGNEE;
    self.telLabel.text = [model.ADRPHONE stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.addressLabel.text = NSStringFormat(@"%@%@", model.PROVINCE, model.ADDRESS);
}

- (void)btnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    
}

@end
