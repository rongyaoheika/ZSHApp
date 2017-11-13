//
//  ZSHLiveContentFirstViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveContentFirstViewController.h"
#import "ZSHCustomWaterFlowLayout.h"
#import "ZSHLiveCellView.h"
#import "ZSHWeiboViewController.h"
#import "ZSHLiveListModel.h"
#import "ZSHLiveRoomViewController.h"
static NSString * const cellIdentifier = @"cellID";

@interface ZSHLiveContentFirstViewController ()< UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZSHCustomWaterFlowLayoutDelegate>

@property (nonatomic, strong)ZSHCustomWaterFlowLayout *waterLayout;
@property (nonatomic, strong)ZSHLiveListModel         *listModel;
@property (nonatomic, strong)NSMutableArray           *dataArr;

@end

@implementation ZSHLiveContentFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    NSArray *baseDataArr = @[
  @{@"liveName":@"夏天在我手中",@"imageName":@"live_image_1", @"loveCount":@"33"},
  @{@"liveName":@"忘记时间的钟",@"imageName":@"live_image_2", @"loveCount":@"43"},
  @{@"liveName":@"流沙",@"imageName":@"live_image_3", @"loveCount":@"33"},
  @{@"liveName":@"夏天",@"imageName":@"live_image_4", @"loveCount":@"44"},
  @{@"liveName":@"绅士",@"imageName":@"live_image_5", @"loveCount":@"63"},
  @{@"liveName":@"拉流",@"imageName":@"live_image_6", @"loveCount":@"40"}
                              ];
    self.dataArr = [ZSHLiveListModel mj_objectArrayWithKeyValuesArray:baseDataArr];
    
    self.waterLayout = [[ZSHCustomWaterFlowLayout alloc]init];
    self.waterLayout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.waterLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[ZSHLiveCellView class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZSHLiveCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    ZSHLiveListModel *model = self.dataArr[indexPath.item];
    [cell updateCellWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    ZSHWeiboViewController *weiboVC = [[ZSHWeiboViewController alloc]init];
//    [self.navigationController pushViewController:weiboVC animated:YES];
    
    ZSHLiveRoomViewController *liveRoomVC = [[ZSHLiveRoomViewController alloc]init];
    [self presentViewController:liveRoomVC animated:YES completion:nil];
}

#pragma WaterFlowLayoutDelegate
- (CGFloat)heightForItem:(ZSHCustomWaterFlowLayout *)layout heightForItemAtIndex:(NSInteger)index itemWith:(CGFloat)itemWith{
    ZSHLiveListModel *model = self.dataArr[index];
    UIImage *image = [UIImage imageNamed:model.imageName];
    return (image.size.height + kRealValue(22));
}

- (NSInteger)numberOfColums:(ZSHCustomWaterFlowLayout *)layout{
    return 2;
}

- (CGFloat)lineSpacingOfItems:(ZSHCustomWaterFlowLayout *)layout{
    return 10;
}

- (UIEdgeInsets)edgeinsetOfItems:(ZSHCustomWaterFlowLayout *)layout{
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
