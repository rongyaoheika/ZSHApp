//
//  ZSHSingerViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHSingerViewController.h"
#import "LXScollTitleView.h"
#import "ZSHMusicLogic.h"

@interface ZSHSingerViewController ()

@property (nonatomic, strong) ZSHMusicLogic         *musicLogic;
@property (nonatomic, strong) NSArray               *singerArr;

@end

@implementation ZSHSingerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    
    _musicLogic = [[ZSHMusicLogic alloc]init];
    [self requestData];
    [self initViewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_singerArr) {
        [self requestData];
    }
    
}

- (void)requestData{
    [_musicLogic loadRadioListSuccess:^(id responseObject) {
        _singerArr = responseObject;
    } fail:nil];
    
}

- (void)createUI{
    self.title = @"歌手";
    [self addNavigationItemWithImageName:@"live_search" isLeft:NO target:self action:@selector(searchAction) tag:1];
    
    NSArray *titleArr = @[@[@"全部",@"内地",@"港台",@"欧美",@"日本",@"韩国",@"其它"],
  @[@"全部",@"男",@"女",@"组合"],@[@"全部",@"流行",@"嘻哈",@"嘻哈",@"摇滚",@"电子",@"民谣",@"民歌"]];
    for (int i = 0; i<titleArr.count; i++) {
        LXScollTitleView *titleView = [self createTitleView];
        titleView.frame = CGRectMake(0, KNavigationBarHeight+i*kRealValue(40), KScreenWidth, kRealValue(40));
        [self.view addSubview:titleView];
        
        titleView.titleWidth = KScreenWidth /6.5;
        [titleView reloadViewWithTitles:titleArr[i]];
    }
    
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = KZSHColor1D1D1D;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KNavigationBarHeight + 3*kRealValue(40));
        make.left.and.right.and.bottom.mas_equalTo(self.view);
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i <10; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(50);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell == nil) {
                cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImage *icon = [UIImage imageNamed:@"music_image_1"];
            CGSize imageSize = CGSizeMake(kRealValue(40), kRealValue(40));
            UIGraphicsBeginImageContextWithOptions(imageSize, NO,0.0);
            CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
            [icon drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            cell.imageView.clipsToBounds = YES;
            cell.imageView.layer.cornerRadius = kRealValue(40)/2;
            UIGraphicsEndImageContext();
            
            cell.textLabel.text = @"薛之谦";
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    
    return sectionModel;
}


//getter
- (LXScollTitleView *)createTitleView{
    LXScollTitleView *titleView = [[LXScollTitleView alloc] init];
    titleView.normalTitleFont = kPingFangRegular(15);
    titleView.selectedTitleFont = kPingFangMedium(15);
    titleView.selectedColor = KZSHColor929292;
    titleView.normalColor = KZSHColor929292;
    titleView.indicatorHeight = 0;
    titleView.selectedBlock = ^(NSInteger index){
        
    };
    return titleView;
}

- (void)searchAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
