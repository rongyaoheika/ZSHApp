//
//  ZSHPayView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPayView.h"
#import "ZSHBaseTableViewSectionModel.h"

@interface ZSHPayView ()

@property (nonatomic, strong) NSArray                       *cellParamArr;

@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHPayView

- (void)setup{
    self.cellParamArr = @[
                          @{@"payImage":@"pay_wechat",@"title":@"微信支付",@"btnTag":@(1),@"btnNormalImage":@"pay_btn_normal",@"btnPressImage":@"pay_btn_press"},
                          @{@"payImage":@"pay_alipay",@"title":@"支付宝支付",@"btnTag":@(2),@"btnNormalImage":@"pay_btn_normal",@"btnPressImage":@"pay_btn_press"}];
}

- (ZSHBaseTableViewSectionModel *)storePaySection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *titleCellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:titleCellModel];
    titleCellModel.height = kRealValue(40);
    titleCellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHBaseCellID];
        cell.textLabel.text = self.paramDic[@"title"];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        return cell;
    };

    for (int i = 0; i<self.cellParamArr.count; i++) {
        ZSHBaseTableViewCellModel *titleCellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:titleCellModel];
        titleCellModel.height = kRealValue(40);
        titleCellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHBaseCellID];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            cell.textLabel.text = weakself.cellParamArr[i][@"title"];
            cell.imageView.image = [UIImage imageNamed:weakself.cellParamArr[i][@"payImage"]];
            
            UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectZero];
            rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [rightBtn setImage:[UIImage imageNamed:weakself.cellParamArr[i][@"btnNormalImage"]] forState:UIControlStateNormal];
            [rightBtn setImage:[UIImage imageNamed:weakself.cellParamArr[i][@"btnPressImage"]] forState:UIControlStateSelected];
            [cell.contentView addSubview:rightBtn];
            [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell).offset(-KLeftMargin);
                make.centerY.mas_equalTo(cell);
                make.size.mas_equalTo(CGSizeMake(kRealValue(35), kRealValue(35)));
            }];
            
            rightBtn.selected = (weakself.selectedCellRow == indexPath.row);
            return cell;
        };
    }
    return sectionModel;
}

#pragma action
- (void)rightBtnAction:(UIButton *)rightBtn{
    if (self.rightBtnBlcok) {
        self.rightBtnBlcok(rightBtn);
    }
}

@end
