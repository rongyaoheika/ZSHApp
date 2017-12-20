//
//  ZSHTailorDetailViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTailorDetailViewController.h"
#import "ZSHTailorDetailView.h"
#import "ZSHBuyLogic.h"

static NSString *cellIdentifier = @"TailorDetailCell";

@interface ZSHTailorDetailViewController ()

@property (nonatomic, strong) UIImageView  *headImage;
@property (nonatomic, strong) ZSHBuyLogic  *buyLogic;
@end

@implementation ZSHTailorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _buyLogic = [[ZSHBuyLogic alloc] init];
    [self initViewModel];
    [self requestData];
}

- (void)createUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KBottomNavH, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHTailorDetailView class] forCellReuseIdentifier:cellIdentifier];

//    [self.tableView setTableHeaderView:[self createTableviewHeaderView]];
    [self.view addSubview:[ZSHBaseUIControl createBottomButton:^(NSInteger index) {
        
    }]];
}

- (UIView *)createTableviewHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(289))];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tailor_detail_1"]];
    image.frame = CGRectMake(0, 0, kRealValue(375), kRealValue(225));
    [view addSubview:image];
    self.headImage = image;
    
    NSDictionary *contentLabelDic = @{@"text":@"荣耀黑卡私人订制让男人轻松享用好品味，专业理型师1对1终身服务，精品推荐，按季为您推荐精品服饰，每年4次，每次6件，让您轻松享用好品味。",@"font":kPingFangRegular(12),@"textColor":KGrayColor,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *contentLabel = [ZSHBaseUIControl createLabelWithParamDic:contentLabelDic];
    contentLabel.numberOfLines = 0;
    [view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(kRealValue(235));
        make.left.mas_equalTo(view).offset(kRealValue(15));
        make.right.mas_equalTo(view).offset(kRealValue(-15));
        make.bottom.mas_equalTo(view);
    }];
    return view;
}


- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
//    [self.headImage sd_setImageWithURL:[NSURL URLWithString:_buyLogic.personalDetailModel.PERSONALDETIMGS[0]]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    for (int i = 0; i<_buyLogic.personalDetailModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        ZSHPersonalDetailModel *model = _buyLogic.personalDetailModelArr[i];
        cellModel.height = [ZSHTailorDetailView updateCellHeightWithModel:model];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //需要注册，无需判空
            ZSHTailorDetailView *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell updateCellWithModel:_buyLogic.personalDetailModelArr[indexPath.row]];
            [cell updateConstraintsIfNeeded];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    return sectionModel;
}


- (void)requestData {
    kWeakSelf(self);
    [_buyLogic requestPersonDetailWithPersonalID:self.paramDic[@"PersonalID"] success:^(id response) {
        [weakself initViewModel];
    }];
}

@end
