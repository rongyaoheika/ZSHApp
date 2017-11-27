//
//  ZSHGoodsTitleContentViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsTitleContentViewController.h"
#import "LXScrollContentView.h"
#import "ZSHGoodsSegmentView.h"
#import "ZSHGoodsTypeViewController.h"


@interface ZSHGoodsTitleContentViewController ()

@property (nonatomic, strong) ZSHGoodsSegmentView  *segmentView;
@property (nonatomic, assign) ZSHCellType          cellType;
@property (nonatomic, strong) LXScrollContentView  *contentView;
@property (nonatomic, strong) NSMutableArray       *vcs;
@property (nonatomic, strong) NSArray              *contentVCS;

@end

@implementation ZSHGoodsTitleContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.cellType = ZSHCollectionViewCellType;

}

- (void)createUI{
    self.title = @"商品";
    
    [self.view addSubview:self.segmentView];
    [self.segmentView selectedByIndex:3];
    [self.view addSubview:self.contentView];
    
    __weak typeof(self) weakSelf = self;
    self.segmentView.btnClickBlock = ^(UIButton *btn) {
         __weak typeof(self) strongSelf = weakSelf;
         strongSelf.contentView.currentIndex = btn.tag-1;
        if (btn.tag == 4) {
            ZSHGoodsTypeViewController *vc = weakSelf.vcs[btn.tag-1];
            weakSelf.cellType = (vc.cellType == ZSHCollectionViewCellType?ZSHTableViewCellType:ZSHCollectionViewCellType);
            [vc reloadUIWithCellType:weakSelf.cellType];
        }
    };
    
    [self reloadListData];
}

#pragma getter

- (ZSHGoodsSegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[ZSHGoodsSegmentView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, kRealValue(50)) paramDic:nil];
        
    }
    return _segmentView;
}

- (LXScrollContentView *)contentView{
    if (!_contentView) {
        _contentView = [[LXScrollContentView alloc] initWithFrame:CGRectMake(0,kRealValue(50) + KNavigationBarHeight, KScreenWidth,KScreenHeight - kRealValue(50) - KNavigationBarHeight)];
        _contentView.backgroundColor = KClearColor;
        kWeakSelf(self);
        _contentView.scrollBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakself;
            [strongSelf.segmentView selectedByIndex:index];
        };
    }
    return _contentView;
}

- (void)reloadListData{
    self.vcs = [[NSMutableArray alloc]init];
    for (int i = 0; i<4; i++) {
        ZSHGoodsTypeViewController *vc =  [[ZSHGoodsTypeViewController alloc]initWithParamDic:@{@"cellType":@(self.cellType),@"PreBrandID":self.paramDic[@"PreBrandID"],KFromClassType:self.paramDic[KFromClassType]}];
        [self.vcs addObject:vc];
    }
    
    [self.contentView reloadViewWithChildVcs:self.vcs parentVC:self];
}



@end
