//
//  ZSHAddressListCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHAddressListCell.h"

@interface ZSHAddressListCell()

@property (nonatomic, strong) UILabel   *nameLabel;
@property (nonatomic, strong) UILabel   *addressLabel;
@property (nonatomic, strong) UILabel   *telLabel;
@property (nonatomic, strong) UIButton  *defaultBtn;
@property (nonatomic, strong) UIButton  *deleteBtn;
@property (nonatomic, strong) UIButton  *editBtn;

@end

@implementation ZSHAddressListCell

- (void)setup{
    
    NSDictionary *nameLabelDic = @{@"text":@"王晶",@"font":kPingFangMedium(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [self.contentView addSubview:_nameLabel];
    
    NSDictionary *addressLabelDic = @{@"text":@"13719143456",@"font":kPingFangLight(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _addressLabel = [ZSHBaseUIControl createLabelWithParamDic:addressLabelDic];
    _addressLabel.numberOfLines = 0;
    [self.contentView addSubview:_addressLabel];
    
    NSDictionary *telLabelDic = @{@"text":@"13719143456",@"font":kPingFangMedium(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentRight)};
    _telLabel = [ZSHBaseUIControl createLabelWithParamDic:telLabelDic];
    [self.contentView addSubview:_telLabel];
    
    NSDictionary *defaultBtnDic = @{@"title":@"设为默认",@"titleColor":KZSHColor929292,@"font":kPingFangLight(11),@"backgroundColor":KClearColor,@"withImage":@(YES),@"normalImage":@"address_normal",@"selectedImage":@"address_press",@"layoutType":@(XYButtonEdgeInsetsStyleLeft),@"space":@(4)};
    _defaultBtn = [ZSHBaseUIControl createBtnWithParamDic:defaultBtnDic];
    [_defaultBtn addTarget:self action:@selector(defaultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_defaultBtn];
    
    NSDictionary *deleteBtnDic = @{@"title":@"删除",@"titleColor":KZSHColor929292,@"font":kPingFangLight(11),@"backgroundColor":KClearColor,@"withImage":@(YES),@"normalImage":@"address_delete",@"selectedImage":@"address_delete",@"layoutType":@(XYButtonEdgeInsetsStyleLeft),@"space":@(4)};
    _deleteBtn = [ZSHBaseUIControl createBtnWithParamDic:deleteBtnDic];
    [self.contentView addSubview:_deleteBtn];
    
    NSDictionary *editBtnDic = @{@"title":@"编辑",@"titleColor":KZSHColor929292,@"font":kPingFangLight(11),@"backgroundColor":KClearColor,@"withImage":@(YES),@"normalImage":@"address_edit",@"selectedImage":@"address_edit",@"layoutType":@(XYButtonEdgeInsetsStyleLeft),@"space":@(4)};
    _editBtn = [ZSHBaseUIControl createBtnWithParamDic:editBtnDic];
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
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.bottom.mas_equalTo(_defaultBtn);
        make.width.mas_equalTo(kRealValue(40));
        make.height.mas_equalTo(_defaultBtn);
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_deleteBtn.mas_left).offset(-kRealValue(20));
        make.bottom.mas_equalTo(_defaultBtn);
        make.width.mas_equalTo(_deleteBtn);
        make.height.mas_equalTo(_deleteBtn);
    }];

}

- (void)updateCellWithModel:(ZSHAddressModel *)model{
    self.nameLabel.text = model.name;
    self.telLabel.text = model.telephone;
    self.addressLabel.text = model.address;
}

#pragma action
- (void)defaultBtnAction:(UIButton *)defaultBtn{
    defaultBtn.selected = !defaultBtn.selected;
}

@end
