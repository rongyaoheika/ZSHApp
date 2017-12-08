//
//  ZSHMusicRadioViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicRadioViewController.h"
#import "LXScollTitleView.h"
#import "ZSHMusicLogic.h"

@interface ZSHMusicRadioViewController ()

@property (nonatomic, strong) LXScollTitleView      *titleView;
@property (nonatomic, strong) NSArray               *titleArr;
@property (nonatomic, strong) ZSHMusicLogic         *musicLogic;
@property (nonatomic, strong) NSArray               *audioArr;

@end

static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHMusicRadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    self.titleArr = @[@"全部",@"傍晚",@"最近",@"情感",@"主题",@"场景",@"曲库"];
    [self reloadListData];
    _musicLogic = [[ZSHMusicLogic alloc]init];
    [self requestData];
    [self initViewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_audioArr) {
        [self requestData];
    }
    
}


- (void)createUI{
    self.title = @"电台";
    [self.view addSubview:self.titleView];
   
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = KZSHColor1D1D1D;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.and.right.and.bottom.mas_equalTo(self.view);
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
//    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
    
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
            
            cell.textLabel.text = @"歌手说";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"当前热度为%.1f万",53.9];
            cell.detailTextLabel.font = kPingFangRegular(11);
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
           
        };
    }
    
    return sectionModel;
}

- (void)requestData{
    [_musicLogic loadRadioListSuccess:^(id responseObject) {
        _audioArr = responseObject;
    } fail:nil];
    
}

//getter
- (LXScollTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, kRealValue(40))];
        _titleView.normalTitleFont = kPingFangRegular(15);
        _titleView.selectedTitleFont = kPingFangMedium(15);
        _titleView.selectedColor = KZSHColor929292;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = 0;
        _titleView.selectedBlock = ^(NSInteger index){
           
        };
        
    }
    return _titleView;
}

- (void)reloadListData{
    _titleView.titleWidth = KScreenWidth /self.titleArr.count;
    [self.titleView reloadViewWithTitles:self.titleArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
