//
//  ZSHLiveGiftView.m
//  ZSHApp
//
//  Created by mac on 2018/1/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHLiveGiftView.h"
#import "ZSHLiveGiftPopCell.h"
@interface ZSHLiveGiftView ()<UIScrollViewDelegate>

//大背景view
@property (nonatomic, strong) UIView            *giftBgView;
@property (nonatomic, strong) UIView            *headView;
@property (nonatomic, strong) UIScrollView      *midScrollView;

@property (nonatomic, strong) NSArray           *btnTitleArr;
@property (nonatomic, strong) NSMutableArray    *btnArr;
@property (nonatomic, strong) NSArray           *scrollContentArr;
@property (nonatomic, assign) NSInteger         midScrollIndex;
@property (nonatomic, assign) NSInteger         subScrollIndex;

//底部
@property (nonatomic, strong) UIView            *footView;
@property (nonatomic, strong) UIButton          *rechargeBtn;
@property (nonatomic, strong) UIImageView       *giftBtnView;
@property (nonatomic, strong) UIButton          *giftLeftBtn;
@property (nonatomic, strong) UIButton          *giftRightBtn;

@property (nonatomic, strong) UIPageControl     *pageControl;

//弹出礼物小框
@property (nonatomic, strong) UITableView               *subTab;
@property (nonatomic, strong) ZSHBaseTableViewModel     *tableViewModel;
@end

static NSString *ZSHLiveGiftPopCellID = @"ZSHLiveGiftPopCell";
static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHLiveGiftView

- (void)setup{
    
    [self loadLocalData];
    [self createUI];
    
}

- (void)createUI{
    _giftBgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, KScreenWidth, kRealValue(290))];
    _giftBgView.tag = 25;
    _giftBgView.backgroundColor = [UIColor blackColor];
    [self addSubview:_giftBgView];
    
    [self createHeadView];
    [self createMidView];
    [self createFootView];
}

- (void)showGiftPopView{
    [self addSubview:_giftBgView];
    [ZSHBaseFunction showPopView:_giftBgView frameY:0];
    
}

- (void)loadLocalData{
    _btnArr = [[NSMutableArray alloc]init];
    _btnTitleArr = @[@"常规",@"轻奢",@"豪华"];
    _scrollContentArr = @[@(2),@(1),@(1)];
    _midScrollView = 0;
    _subScrollIndex = 0;
}

- (void)createHeadView{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(50))];
    [_giftBgView addSubview:_headView];
    
    for (int i = 0; i<_btnTitleArr.count; i++) {
        NSDictionary *liveTypeBtnDic = @{@"title":_btnTitleArr[i],@"font":kPingFangMedium(15)};
        UIButton *liveTypeBtn = [ZSHBaseUIControl createBtnWithParamDic:liveTypeBtnDic];
        liveTypeBtn.frame = CGRectMake(i*kRealValue(65), 0, kRealValue(65), kRealValue(50));
        [liveTypeBtn addTarget:self action:@selector(liveTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        liveTypeBtn.tag = i+1;
        [_headView addSubview:liveTypeBtn];
        [_btnArr addObject:liveTypeBtn];
    }
    [self selectedByIndex:1];
}

//礼物UI
- (void)createMidView{
    [_giftBgView addSubview:self.midScrollView];
    for (int i = 0; i<_btnTitleArr.count; i++) {
        UIScrollView *giftSV = [self createScrollViewWithIndex:i Count:[_scrollContentArr[i] integerValue] ];
        [self.midScrollView addSubview:giftSV];
    }
}

//底部送礼物UI
- (void)createFootView{
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.midScrollView.frame), KScreenWidth, kRealValue(50))];
    [_giftBgView addSubview:_footView];
    
    NSDictionary *rechargeBtnDic = @{@"title":@"充值",@"font":kPingFangRegular(15)};
    _rechargeBtn = [ZSHBaseUIControl createBtnWithParamDic:rechargeBtnDic];
    
    [_footView addSubview:_rechargeBtn];
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_footView);
        make.left.mas_equalTo(_footView).offset(KLeftMargin);
        make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(15)));
    }];
    
    [_footView addSubview:self.pageControl];
    self.pageControl.numberOfPages = [_scrollContentArr[0]integerValue];
    
    [self createGiftBtnView];
    
}

//具体礼物ScrollView index：礼物类型（常规，轻奢，豪华） count：scrollview.contentSize
- (UIScrollView *)createScrollViewWithIndex:(NSInteger)index Count:(NSInteger)count{
    UIScrollView *giftSV = [[UIScrollView alloc]initWithFrame:CGRectMake(index*KScreenWidth, 0, KScreenWidth, kRealValue(190))];
    giftSV.tag = index+20;
    giftSV.contentSize = CGSizeMake(count*KScreenWidth, 0);
    giftSV.showsVerticalScrollIndicator = NO;
    giftSV.showsHorizontalScrollIndicator = NO;
    giftSV.pagingEnabled = YES;
    giftSV.delegate = self;
    
    NSArray *btnDicArr = @[
                           @[//常规
                               @[//常规第一栏
                                   @[
                                       @{@"btnNormalImage":@"gift_image_0",@"btnTitle":@"心",@"coinTile":@"1黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_1",@"btnTitle":@"星星",@"coinTile":@"1黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_2",@"btnTitle":@"棒棒糖",@"coinTile":@"1黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_3",@"btnTitle":@"棒棒糖",@"coinTile":@"1黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_4",@"btnTitle":@"红包",@"coinTile":@"6黑咖币"},
                                       ],
                                   
                                   @[
                                       @{@"btnNormalImage":@"gift_image_5",@"btnTitle":@"奖杯",@"coinTile":@"10黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_6",@"btnTitle":@"冰淇淋",@"coinTile":@"18黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_7",@"btnTitle":@"奶酪",@"coinTile":@"28黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_8",@"btnTitle":@"小蛋糕",@"coinTile":@"68黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_9",@"btnTitle":@"皇冠",@"coinTile":@"188黑咖币"},
                                       ],
                                   ],
                               @[//常规第二栏
                                   @[
                                       @{@"btnNormalImage":@"gift_image_10",@"btnTitle":@"蓝色妖姬",@"coinTile":@"1黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_11",@"btnTitle":@"小熊",@"coinTile":@"1黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_12",@"btnTitle":@"炸弹",@"coinTile":@"1黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_13",@"btnTitle":@"口红",@"coinTile":@"1黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_14",@"btnTitle":@"么么哒",@"coinTile":@"1黑咖币"},
                                       ],
                                   
                                   @[
                                       @{@"btnNormalImage":@"gift_image_15",@"btnTitle":@"炮竹",@"coinTile":@"18黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_16",@"btnTitle":@"巧克力",@"coinTile":@"68黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_17",@"btnTitle":@"包包",@"coinTile":@"188黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_18",@"btnTitle":@"蓝钻石",@"coinTile":@"288黑咖币"},
                                       @{@"btnNormalImage":@"gift_image_19",@"btnTitle":@"皮卡丘",@"coinTile":@"288黑咖币"},
                                       ],
                                   ]
                               
                               ],
                           
                           @[//轻奢
                               @[
                                   @{@"btnNormalImage":@"gift_image_30",@"btnTitle":@"包-1",@"coinTile":@"100黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_31",@"btnTitle":@"包-2",@"coinTile":@"200黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_32",@"btnTitle":@"包-3",@"coinTile":@"300黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_33",@"btnTitle":@"包-4",@"coinTile":@"400黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_34",@"btnTitle":@"包-5",@"coinTile":@"500黑咖币"},
                                   ],
                               
                               @[
                                   @{@"btnNormalImage":@"gift_image_35",@"btnTitle":@"包-6",@"coinTile":@"600黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_36",@"btnTitle":@"包-7",@"coinTile":@"700黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_37",@"btnTitle":@"包-8",@"coinTile":@"800黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_38",@"btnTitle":@"包-9",@"coinTile":@"900黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_39",@"btnTitle":@"包-10",@"coinTile":@"1000黑咖币"},
                                   ],
                               
                               ],
                           @[//豪华
                               @[
                                   @{@"btnNormalImage":@"gift_image_20",@"btnTitle":@"方向盘",@"coinTile":@"100黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_21",@"btnTitle":@"车灯",@"coinTile":@"200黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_22",@"btnTitle":@"座椅",@"coinTile":@"300黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_23",@"btnTitle":@"档位",@"coinTile":@"400黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_24",@"btnTitle":@"刹车片",@"coinTile":@"500黑咖币"},
                                   ],
                               
                               @[
                                   @{@"btnNormalImage":@"gift_image_25",@"btnTitle":@"轮胎",@"coinTile":@"600黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_26",@"btnTitle":@"车门",@"coinTile":@"700黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_27",@"btnTitle":@"发动机",@"coinTile":@"800黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_28",@"btnTitle":@"电源",@"coinTile":@"900黑咖币"},
                                   @{@"btnNormalImage":@"gift_image_29",@"btnTitle":@"螺丝",@"coinTile":@"1000黑咖币"},
                                   ],
                               
                               ],
                           ];
    
    
    
    CGFloat viewW = KScreenWidth/5;
    CGFloat viewH = kRealValue(190)/2;
    
    for (int contentCount = 0; contentCount<count; contentCount++) {//contentSize
        
        for (int i = 0; i<2; i++) {//2行
            for (int j = 0; j <5; j++) {//5列
                UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth*contentCount + j*viewW, i*viewH, viewW, viewH)];
                [giftSV addSubview:btnView];
                
                NSDictionary *giftDic = nil;
                if (count>1) {
                    giftDic = btnDicArr[index][contentCount][i][j];
                }else {
                    giftDic = btnDicArr[index][i][j];
                }
                
                //图片
                UIImageView *giftIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:giftDic[@"btnNormalImage"]]];
                [btnView addSubview:giftIV];
                [giftIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(kRealValue(45), kRealValue(45)));
                    make.centerX.mas_equalTo(btnView);
                    make.top.mas_equalTo(btnView).offset(kRealValue(10));
                }];
                
                
                //文字
                NSDictionary *giftLBDic = @{@"text":giftDic[@"btnTitle"],@"font":kPingFangRegular(12),@"textAlignment":@(NSTextAlignmentCenter)};
                UILabel *giftLB = [ZSHBaseUIControl createLabelWithParamDic:giftLBDic];
                [btnView addSubview:giftLB];
                [giftLB mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(btnView);
                    make.centerX.mas_equalTo(btnView);
                    make.top.mas_equalTo(giftIV.mas_bottom);
                    make.height.mas_equalTo(kRealValue(22));
                }];
                
                //消费
                NSDictionary *coinLBDic = @{@"text":giftDic[@"coinTile"],@"font":kPingFangRegular(10),@"textAlignment":@(NSTextAlignmentCenter)};
                UILabel *coinLB = [ZSHBaseUIControl createLabelWithParamDic:coinLBDic];
                [btnView addSubview:coinLB];
                [coinLB mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(btnView);
                    make.centerX.mas_equalTo(btnView);
                    make.top.mas_equalTo(giftLB.mas_bottom);
                    make.height.mas_equalTo(kRealValue(10));
                }];
            }
        }
        
    }
    
    
    return giftSV;
    
}

#pragma 懒加载
//外层礼物ScrollView
- (UIScrollView *)midScrollView{
    if (!_midScrollView) {
        _midScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kRealValue(50), KScreenWidth, kRealValue(190))];
        _midScrollView.tag = 10;
        _midScrollView.contentSize = CGSizeMake(_btnTitleArr.count*KScreenWidth, 0);
        _midScrollView.showsVerticalScrollIndicator = NO;
        _midScrollView.showsHorizontalScrollIndicator = NO;
        _midScrollView.pagingEnabled = YES;
        _midScrollView.delegate = self;
    }
    return _midScrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((KScreenWidth-kRealValue(100))/2, 0, kRealValue(100), kRealValue(50))];
        _pageControl.currentPageIndicatorTintColor = KZSHColor929292;
        _pageControl.pageIndicatorTintColor = KZSHColor2A2A2A;
    }
    return _pageControl;
}

- (UIView *)createGiftBtnView{
    
    _giftBtnView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"give_gift"]];
    _giftBtnView.userInteractionEnabled = YES;
    _giftBtnView.clipsToBounds = YES;
    [self.footView addSubview:_giftBtnView];
    [_giftBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_footView).offset(-KLeftMargin);
        make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(30)));
        make.centerY.mas_equalTo(_footView);
    }];
    
    _giftLeftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kRealValue(50), kRealValue(30))];
    [_giftLeftBtn addTarget:self action:@selector(giftLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_giftLeftBtn setTitle:@"1" forState:UIControlStateNormal];
    [_giftLeftBtn setImage:[UIImage imageNamed:@"gift_more"] forState:UIControlStateNormal];
    [_giftLeftBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(15)];
    [_giftBtnView addSubview:_giftLeftBtn];
    
    _giftRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(kRealValue(55), 0, kRealValue(50), kRealValue(30))];
    [_giftRightBtn addTarget:self action:@selector(giftRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_giftRightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_giftRightBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(15)];
    [_giftBtnView addSubview:_giftRightBtn];
    
    
    
    return _giftBtnView;
}

#pragma action
- (void)liveTypeBtnAction:(UIButton *)btn{
    [self selectedByIndex:btn.tag];
    
}

- (void)giftLeftBtnAction:(UIButton *)btn{
    RLog(@"点击左侧按钮");
    btn.selected = !btn.selected;
    if (btn.selected) {
        if (![self viewWithTag:150]) {
            [self addSubview:self.subTab];
            [ZSHBaseFunction showPopView:self.subTab frameY:kScreenHeight - kRealValue(50) - kRealValue(250)];
            [self initViewModel];
        }
        
    } else {
        [ZSHBaseFunction dismissPopView:self.subTab block:nil];
    }
}

- (UITableView *)subTab{
    if (!_subTab) {
        _tableViewModel = [[ZSHBaseTableViewModel alloc] init];
        _subTab = [ZSHBaseUIControl createTableView];
        _subTab.delegate = self.tableViewModel;
        _subTab.dataSource = self.tableViewModel;
        _subTab.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gift_pop"]];
        _subTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_subTab setSeparatorColor:KZSHColor1D1D1D];
        [_subTab setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _subTab.tag = 150;
        _subTab.frame = CGRectMake(KScreenWidth - kRealValue(160), kScreenHeight, kRealValue(130), kRealValue(248));
        [_subTab registerClass:[ZSHLiveGiftPopCell class] forCellReuseIdentifier:ZSHLiveGiftPopCellID];
        [_subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
    }
    return _subTab;
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.subTab reloadData];
    
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    NSArray *dicArr = @[@{@"leftTitle":@"1314",@"rightTitle":@"一生一世"},@{@"leftTitle":@"520",@"rightTitle":@"我爱你"},
                        @{@"leftTitle":@"188",@"rightTitle":@"要抱抱"},@{@"leftTitle":@"66",@"rightTitle":@"一切顺利"},
                        @{@"leftTitle":@"30",@"rightTitle":@"想你"},@{@"leftTitle":@"10",@"rightTitle":@"十全十美"},
                        @{@"leftTitle":@"1",@"rightTitle":@"一心一意"},@{@"midTitle":@"其他数量"}];
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < dicArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(30);
        [sectionModel.cellModelArray addObject:cellModel];
        if (i != dicArr.count - 1) {
            cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
                ZSHLiveGiftPopCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHLiveGiftPopCellID forIndexPath:indexPath];
                [cell updateCellWithParamDic:dicArr[i]];
                return cell;
            };
        } else {
            cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
                ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
                cell.textLabel.text = dicArr[i][@"midTitle"];
                cell.textLabel.textColor = KZSHColorF29E19;
                return cell;
            };
        }
        
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    
    return sectionModel;
}

- (void)giftRightBtnAction:(UIButton *)btn{
    RLog(@"点击右侧发送按钮");
}

#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) return;
    [self dealPageEnableWithScrollView:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self dealPageEnableWithScrollView:scrollView];
}
#pragma mark 处理scrollView翻页效果
- (void)dealPageEnableWithScrollView:(UIScrollView *)scrollView{
    //     NSInteger midScrollViewIndex = (NSInteger)(fabs((scrollView.contentOffset.x/KScreenWidth)));
    //    RLog(@"scrollView 的tag == %ld  page==%ld   contentoffset==%f",scrollView.tag,midScrollViewIndex,scrollView.contentOffset.x);
    if (scrollView.tag == 10) {//外层scrollview
        NSInteger midScrollViewIndex = (NSInteger)(fabs((scrollView.contentOffset.x/KScreenWidth)));
        [self selectedByIndex:midScrollViewIndex+1];
        self.pageControl.numberOfPages = [_scrollContentArr[midScrollViewIndex]integerValue];
        
        UIScrollView *subScrollView = [self.midScrollView viewWithTag:midScrollViewIndex + 20];
        NSInteger subScrollIndex = (NSInteger)(fabs((subScrollView.contentOffset.x/KScreenWidth)));
        self.pageControl.currentPage = subScrollIndex;
        self.pageControl.hidden = self.pageControl.numberOfPages<=1?YES:NO;
        
    } else {//内层scrollview
        
        NSInteger subScrollIndex = (NSInteger)(fabs((scrollView.contentOffset.x/KScreenWidth)));
        self.pageControl.currentPage = subScrollIndex;
        [scrollView setContentOffset:CGPointMake(KScreenWidth * subScrollIndex,0)];
    }
    
    
}

- (void)selectedByIndex:(NSUInteger)index {
    [_btnArr enumerateObjectsUsingBlock:^(UIButton *btn , NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn.tag == index) {
            btn.selected = YES;
            btn.titleLabel.font = kPingFangMedium(15);
        } else {
            btn.selected = NO;
            btn.titleLabel.font = kPingFangRegular(15);
        }
    }];
    
    //外层scrollview
    self.pageControl.numberOfPages = [_scrollContentArr[index-1]integerValue];
    [_midScrollView setContentOffset:CGPointMake((index-1)*kScreenWidth, 0)];
    self.pageControl.hidden = self.pageControl.numberOfPages<=1?YES:NO;
    
    //内层scrollview
    UIScrollView *subScrollView = [self.midScrollView viewWithTag:(index-1) + 20];
    [subScrollView setContentOffset:CGPointMake(0, 0)];//默认第0组
}

//弹框消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view.tag != 25) {
        [ZSHBaseFunction dismissPopView:self.giftBgView block:^{
            [self removeFromSuperview];
        }];
    }
}

@end
