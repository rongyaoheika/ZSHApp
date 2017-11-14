//
//  ZSHPersonalCenterViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPersonalCenterViewController.h"

@interface ZSHPersonalCenterViewController ()

@property (nonatomic, strong) NSArray                        *titleArr;
@property (nonatomic, assign) CGFloat                        titleWidth;
@property (nonatomic, strong) NSArray                        *contentVCS;

@end

@implementation ZSHPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    self.title = @"个人中心";
    self.titleArr = @[@"商品",@"详情",@"评价"];
    self.titleWidth = kScreenWidth/[self.titleArr count];
    self.contentVCS = @[@"ZSHGoodsSubViewController",@"ZSHGoodsDetailSubViewController",@"ZSHGoodsCommentSubViewController"];
}

- (void)createUI{

}



@end
