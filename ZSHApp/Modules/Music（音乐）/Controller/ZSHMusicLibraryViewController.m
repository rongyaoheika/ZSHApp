//
//  ZSHMusicLibraryViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicLibraryViewController.h"
#import "ZSHMusicLogic.h"
#import "LXScollTitleView.h"
#import "ZSHMusicLibraryCell.h"
#import "ZSHPlayListViewController.h"

@interface ZSHMusicLibraryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) LXScollTitleView      *titleView;
@property (nonatomic, strong) NSArray               *titleArr;
@property (nonatomic, strong) ZSHMusicLogic         *musicLogic;
@property (nonatomic, strong) NSArray               *modelArr;

@end

static NSString *ZSHMusicLibraryCellID = @"ZSHMusicLibraryCell";

@implementation ZSHMusicLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}

- (void)createUI{
    self.title = @"曲库";
    [self.view addSubview:self.titleView];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(5, 7.5, 0, 7.5);
    layout.itemSize = CGSizeMake((KScreenWidth - 15)/3, kRealValue(155));
    layout.minimumLineSpacing = KLeftMargin;
    layout.minimumInteritemSpacing = 0;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.and.right.and.bottom.mas_equalTo(self.view);
    }];
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[ZSHMusicLibraryCell class] forCellWithReuseIdentifier:ZSHMusicLibraryCellID];
    [self.view addSubview:self.collectionView];
    
}

- (void)loadData{
    self.titleArr = @[@"推荐",@"精选",@"最热",@"最新"];
    [self reloadListData];
    [self requestData];
}

- (void)requestData{
    _musicLogic = [[ZSHMusicLogic alloc]init];
//    [_musicLogic loadRadioListSuccess:^(id responseObject) {
//        RLog(@"电台列表数据成功== %@",responseObject);
//    } fail:nil];
    
//    
//    [_musicLogic loadLryWithParamDic:@{@"songid":@"877578"} Success:^(id responseObject) {
//        RLog(@"歌词数据成功== %@",responseObject);
//    } fail:nil];
//
}

#pragma collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZSHMusicLibraryCell *cell = (ZSHMusicLibraryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ZSHMusicLibraryCellID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSHPlayListViewController *playListVC = [[ZSHPlayListViewController alloc]init];
    [self.navigationController pushViewController:playListVC animated:YES];
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
