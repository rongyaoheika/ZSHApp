//
//  ZSHPlayListViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPlayListViewController.h"
#import "ZSHMusicLogic.h"
#import "ZSHPlayListHeadView.h"

@interface ZSHPlayListViewController ()

@property (nonatomic, strong) ZSHPlayListHeadView  *headView;
@property (nonatomic, strong) UIView               *tabHeadView;
@property (nonatomic, strong) UIView               *tabFootView;

@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHPlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    
//    [self requestData];
    [self initViewModel];
}

- (void)createUI{
    self.title = @"曲库";
    
    _headView = [[ZSHPlayListHeadView alloc]init];
    _headView.frame = CGRectMake(0, 0, kScreenWidth, kRealValue(225));
    [self.view addSubview:_headView];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(kRealValue(225), 0, 0, 0));
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerView = self.tabHeadView;
    sectionModel.headerHeight = kRealValue(40);
    
    sectionModel.footerView = self.tabFootView;
    sectionModel.footerHeight = KBottomNavH;
    
    for (int i = 0; i < 10; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(60);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell == nil) {
                cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            UIImage *icon = [UIImage imageNamed:@"music_image_1"];
            CGSize imageSize = CGSizeMake(40, 40);
            UIGraphicsBeginImageContextWithOptions(imageSize, NO,0.0);
            CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
            [icon drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            cell.textLabel.text = @"说谎";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",@"林宥嘉",@"感官世界"];
            cell.detailTextLabelEdgeInsets = UIEdgeInsetsMake(kRealValue(14), 0, 0, 0);
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    
    return sectionModel;
}

- (UIView *)tabHeadView{
    if (!_tabHeadView) {
        _tabHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(40))];
        
        NSDictionary *btnDic = @{@"title":@"随机播放",@"withImage":@(YES),@"normalImage":@"music_play"};
        UIButton *playBtn = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
        playBtn.frame = CGRectMake(KLeftMargin, 0, kRealValue(100), kRealValue(40));
        [playBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(7.5)];
        [_tabHeadView addSubview:playBtn];
        
        NSDictionary *titleLabelDic = @{@"text":@"共123首",@"font":kPingFangRegular(12)};
        UILabel *songCountLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
        [_tabHeadView addSubview:songCountLabel];
        [songCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(playBtn.mas_right);
            make.top.and.height.and.right.mas_equalTo(_tabHeadView);
        }];
        
        
    }
    return _tabHeadView;
}

- (UIView *)tabFootView{
    if (!_tabFootView) {
        _tabFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KBottomNavH)];
        
        UIImageView *authorIV = [[UIImageView alloc]init];
        authorIV.image = [UIImage imageNamed:@"music_image_1"];
        [_tabFootView addSubview:authorIV];
        [authorIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_tabFootView).offset(KLeftMargin);
            make.centerY.mas_equalTo(_tabFootView);
            make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(40)));
        }];
        
        NSDictionary *songLabelDic = @{@"text":@"后来",@"font":kPingFangRegular(12)};
        UILabel *songLabel = [ZSHBaseUIControl createLabelWithParamDic:songLabelDic];
        [_tabFootView addSubview:songLabel];
        [songLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(authorIV.mas_right).offset(kRealValue(10));
            make.height.mas_equalTo(_tabFootView);
            make.centerY.mas_equalTo(_tabFootView);
            make.width.mas_equalTo(kRealValue(100));
        }];
        
        
        UIButton *stopBtn = [[UIButton alloc]init];
        [stopBtn setBackgroundImage:[UIImage imageNamed:@"music_stop"] forState:UIControlStateNormal];
        [_tabFootView addSubview:stopBtn];
        [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_tabFootView).offset(-KLeftMargin);
            make.size.mas_equalTo(CGSizeMake(kRealValue(25), kRealValue(25)));
            make.centerY.mas_equalTo(_tabFootView);
        }];
        
        UIButton *startBtn = [[UIButton alloc]init];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"music_start"] forState:UIControlStateNormal];
        [_tabFootView addSubview:startBtn];
         [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(stopBtn.mas_left).offset(-KLeftMargin);
            make.centerY.mas_equalTo(_tabFootView);
            make.size.mas_equalTo(CGSizeMake(kRealValue(25), kRealValue(25)));
        }];
        
    }
    return _tabFootView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
