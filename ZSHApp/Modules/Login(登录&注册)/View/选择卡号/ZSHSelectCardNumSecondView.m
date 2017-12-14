//
//  ZSHSelectCardNumSecondView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSelectCardNumSecondView.h"
#import "ZSHPhoneNumListView.h"
#import "ZSHCardSubHeadView.h"
#import "ZSHBlackCardPhoneNumView.h"
@interface ZSHSelectCardNumSecondView ()<UIScrollViewDelegate>

@property (nonatomic, strong) ZSHBaseTableViewModel     *tableViewModel;
@property (nonatomic, strong) UITableView               *subTab;
@property (nonatomic, strong) ZSHPhoneNumListView       *phoneNumListView;
@property (nonatomic, strong) NSArray                   *titleArr;

@end

@implementation ZSHSelectCardNumSecondView

- (void)setup{
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.tableViewModel = [[ZSHBaseTableViewModel alloc] init];
    [self initViewModel];
}

- (void)createUI{
    self.subTab = [ZSHBaseUIControl createTableView];
    self.subTab.scrollEnabled = NO;
    [self addSubview: self.subTab];
    [self.subTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(kRealValue(20), 0, 0, 0));
    }];
    
    self.subTab.delegate = self.tableViewModel;
    self.subTab.dataSource = self.tableViewModel;
    [self.subTab reloadData];
    
}

- (void)initViewModel{
    [self.tableViewModel.sectionModelArray removeAllObjects];
    
    NSArray *sectionParmaDicArr = @[@{KFromClassType:@(FromCardNumCellToCardSubHeadView),@"title":@"自选号码 自选仅需+20元选号费",@"btnTitle":@"换一批",@"tag":@(10)},
          @{KFromClassType:@(FromCardNumCellToCardSubHeadView),@"title":@"贵宾号码",@"btnTitle":@"换一批",@"tag":@(11)},
          @{KFromClassType:@(FromCardNumCellToCardSubHeadView),@"title":@"金钻号码",@"btnTitle":@"换一批",@"tag":@(12)},
          @{KFromClassType:@(FromCardNumCellToCardSubHeadView),@"title":@"荣耀号码",@"btnTitle":@"换一批",@"tag":@(13)},
          @{KFromClassType:@(FromCardNumCellToCardSubHeadView),@"title":@"超级黑卡靓号",@"btnTitle":@"换一批",@"tag":@(14)}];
    for (NSDictionary *paramDic in sectionParmaDicArr) {
        ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
        sectionModel.headerHeight = kRealValue(65);
        sectionModel.headerView = [self createHeadViewWithParamDic:paramDic];
        [self.tableViewModel.sectionModelArray addObject:sectionModel];
        
        if ([paramDic[@"tag"]integerValue] == 14) {
            [self addBlackCardCellModelToSection:[paramDic[@"tag"]integerValue] ];
        } else {
           [self addCellModelToSection:[paramDic[@"tag"]integerValue] ];
        }
        
    }
}

//创建头视图
- (ZSHCardSubHeadView *)createHeadViewWithParamDic:(NSDictionary *)paramDic{
    ZSHCardSubHeadView *cardSubView = [[ZSHCardSubHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(65)) paramDic:paramDic];
    cardSubView.backgroundColor = KClearColor;
    return cardSubView;
}

//创建cell
- (void)addCellModelToSection:(NSInteger)section{
    NSInteger realSection = section - 10;
    ZSHBaseTableViewSectionModel *sectionModel = self.tableViewModel.sectionModelArray[realSection];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(150);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        NSArray *titleArr = @[@"1035686866",@"1035686866",@"1035686866",@"1035686866",@"11035686866",@"1035686866",@"1035686866",@"1035686866",];
        NSDictionary *nextParamDic = @{@"titleArr":titleArr,@"normalImage":@"phone_normal",@"selectedImage":@"phone_press",@"type":@(indexPath.row+1)};
        ZSHPhoneNumListView *listView = [[ZSHPhoneNumListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kRealValue(150)) paramDic:nextParamDic];
        [cell.contentView addSubview:listView];
        
        return cell;
    };
}

//超级黑卡靓号
- (void)addBlackCardCellModelToSection:(NSInteger)section{
    NSInteger realSection = section - 10;
    ZSHBaseTableViewSectionModel *sectionModel = self.tableViewModel.sectionModelArray[realSection];
    
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(280);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        ZSHBlackCardPhoneNumView *blackCardPhoneView = [[ZSHBlackCardPhoneNumView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(280)) paramDic:@{@"type":@"5"}];
        [cell.contentView addSubview:blackCardPhoneView];
        return cell;
    };
}

- (void)getSelectCardNum {
    
}


@end
