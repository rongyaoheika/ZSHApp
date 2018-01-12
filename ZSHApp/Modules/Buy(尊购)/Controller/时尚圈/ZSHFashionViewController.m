//
//  ZSHFashionViewController.m
//  ZSHApp
//
//  Created by mac on 12/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHFashionViewController.h"
#import "ZSHFashionCell.h"

static NSString *ZSHFashionCellID = @"ZSHFashionCellID";

@interface ZSHFashionViewController ()

@end

@implementation ZSHFashionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KBottomTabH, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHFashionCell class] forCellReuseIdentifier:ZSHFashionCellID];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *dataArr = @[@{@"image":@"fashion0", @"title":@"星二代们都爱穿的NUNUNU,大胆对色彩say no", @"content":@"厌倦了一模一样和规矩刻板的孩童服装？那么你的想法正好跟这两名来自以色列的设计师不谋而合"},
                         @{@"image":@"fashion1", @"title":@"CL高跟鞋让你优雅的像一只猫，足矣为你倾慕不已", @"content":@"女人有三宝：口红、耳环和高跟鞋。其中，高跟鞋是力量的象征是魅力的源泉，是女人味最有力的表现"},
                         @{@"image":@"fashion2", @"title":@"小小的耳边风情让你秒变仙女本人", @"content":@"农历新年很快就要来了，有没有很开心呀？反正我是能放假就出去浪就很开心了，说到出去浪，最重要的当然是美啦！"}];
    for (int i = 0; i<dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(320);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //需要注册，无需判空
            ZSHFashionCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHFashionCellID forIndexPath:indexPath];
            [cell updateCellWithParamDic:dataArr[i]];
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    return sectionModel;
}
@end
