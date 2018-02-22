//
//  ZSHLiveGiftView.m
//  ZSHApp
//
//  Created by mac on 2018/1/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHLiveGiftView.h"
#import "ZSHLiveGiftPopCell.h"
#import "ZSHLiveLogic.h"

@interface ZSHLiveGiftView ()<UIScrollViewDelegate,UIAlertViewDelegate>

//大背景view
@property (nonatomic, strong) UIView            *giftBgView;
@property (nonatomic, strong) UIView            *headView;

//中间
@property (nonatomic, strong) UIScrollView      *midScrollView;
@property (nonatomic, strong) NSMutableArray    *giftBtnArr;

@property (nonatomic, strong) NSArray           *btnTitleArr;
@property (nonatomic, strong) NSMutableArray    *typeBtnArr;
@property (nonatomic, strong) NSArray           *scrollContentArr;

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
@property (nonatomic, strong) ZSHLiveLogic              *liveLogic;
@property (nonatomic, strong) NSString                  *giftNum;

@end
static NSInteger giftBtnTag = 0;
static NSString *ZSHLiveGiftPopCellID = @"ZSHLiveGiftPopCell";
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
    _liveLogic = [[ZSHLiveLogic alloc]init];
    _typeBtnArr = [[NSMutableArray alloc]init];
    _giftBtnArr = [[NSMutableArray alloc]init];
    _btnTitleArr = @[@"常规",@"轻奢",@"豪华"];
    _scrollContentArr = @[@(2),@(1),@(1)];
    
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
        [_typeBtnArr addObject:liveTypeBtn];
    }
    [self selectedGiftTypeByIndex:1 isClick:YES];
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

//具体礼物ScrollView index：礼物类型（常规0，轻奢1，豪华2） count：scrollview.contentSize
- (UIScrollView *)createScrollViewWithIndex:(NSInteger)index Count:(NSInteger)count{
    UIScrollView *giftSV = [[UIScrollView alloc]initWithFrame:CGRectMake(index*KScreenWidth, 0, KScreenWidth, kRealValue(190))];
    giftSV.tag = index+600;
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
            for (int j = 0; j<5; j++) {//5列
                UIButton *btnView = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth*contentCount + j*viewW, i*viewH, viewW, viewH)];
                [btnView addTarget:self action:@selector(gitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                btnView.tag = giftBtnTag++;
                [giftSV addSubview:btnView];
                [_giftBtnArr addObject:btnView];
                
                NSDictionary *giftDic = nil;
                if (count>1) {
                    giftDic = btnDicArr[index][contentCount][i][j];
                }else {
                    giftDic = btnDicArr[index][i][j];
                }
                
                //图片
                UIImageView *giftIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:giftDic[@"btnNormalImage"]]];
                giftIV.tag = 120;
                [btnView addSubview:giftIV];
                [giftIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(kRealValue(45), kRealValue(45)));
                    make.centerX.mas_equalTo(btnView);
                    make.top.mas_equalTo(btnView).offset(kRealValue(10));
                }];
                
                
                //文字
                NSDictionary *giftLBDic = @{@"text":giftDic[@"btnTitle"],@"font":kPingFangRegular(12),@"textAlignment":@(NSTextAlignmentCenter)};
                UILabel *giftLB = [ZSHBaseUIControl createLabelWithParamDic:giftLBDic];
                giftLB.tag = 121;
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
                coinLB.tag = 123;
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
        _midScrollView.tag = 500;
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
    UIImageView *rightIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gift_more"]];
    rightIV.contentMode = UIViewContentModeScaleAspectFit;
    rightIV.frame = CGRectMake(kRealValue(40), 0, kRealValue(5), kRealValue(30));
    [_giftLeftBtn addSubview:rightIV];
    
    NSDictionary *titleLabelDic = @{@"text":@"1",@"font":kPingFangRegular(14),@"textColor":KWhiteColor};
    UILabel *btnLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    btnLabel.frame = CGRectMake(5, 0, kRealValue(35), kRealValue(30));
    btnLabel.tag = 301;
    [_giftLeftBtn addSubview:btnLabel];
    

    [_giftBtnView addSubview:_giftLeftBtn];
    
    _giftRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(kRealValue(55), 0, kRealValue(50), kRealValue(30))];
    [_giftRightBtn addTarget:self action:@selector(giftRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_giftRightBtn setTitle:@"发送" forState:UIControlStateNormal];
    _giftRightBtn.titleLabel.font = kPingFangRegular(14);
    [_giftRightBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(15)];
    [_giftBtnView addSubview:_giftRightBtn];

    return _giftBtnView;
}

#pragma action

- (void)gitBtnAction:(UIButton *)btn{
    UILabel *coinLB = [btn viewWithTag:123];
    _giftNum =  [NSString stringWithFormat:@"%ld",[self getGiftNumWith:coinLB.text]];
    [self selectedGiftBtnByIndex:btn.tag];
}

- (void)liveTypeBtnAction:(UIButton *)btn{
    [self selectedGiftTypeByIndex:btn.tag isClick:YES];
    
}

- (void)giftLeftBtnAction:(UIButton *)btn{
    RLog(@"点击左侧按钮");
    if (![self viewWithTag:150]) {
        [self addSubview:self.subTab];
        [ZSHBaseFunction showPopView:self.subTab frameY:kScreenHeight - kRealValue(50) - kRealValue(250)];
        [self initViewModel];
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
        
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHLiveGiftPopCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHLiveGiftPopCellID forIndexPath:indexPath];
            [cell updateCellWithParamDic:dicArr[i]];
            return cell;
        };

        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            if (indexPath.row != dicArr.count-1) {
                 _giftNum = dicArr[i][@"leftTitle"];
                UILabel *giftLeftBtnLabel = [_giftLeftBtn viewWithTag:301];
                giftLeftBtnLabel.text = _giftNum;
//                [_giftLeftBtn setTitle:_giftNum forState:UIControlStateNormal];
            }
           
            [ZSHBaseFunction dismissPopView:self.subTab block:nil];
        };
    }
    
    return sectionModel;
}

- (void)giftRightBtnAction:(UIButton *)btn{
   
    RLog(@"点击右侧发送按钮");
    NSDictionary *paramDic = @{@"HONOURUSER_ID":HONOURUSER_IDValue,@"REHONOURUSER_ID":REHONOURUSER_IDValue,@"BLACKPRICE":_giftNum};
    [_liveLogic requesGiftToUserWithDic:paramDic success:^(id response) {
        RLog(@"发送礼物成功");
        if ([response[@"result"]isEqualToString:@"07"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"余额不足" message:@"当前余额不足，充值才可以继续送礼，是否去充值" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 10;
            [alertView show];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 10:{//充值
            if (buttonIndex == 1) {
                RLog(@"点击确定充值");
            }
            break;
        }
        
            
        default:
            break;
    }
    
}

- (NSInteger)getGiftNumWith:(NSString *)str{
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    return number;
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
    if (scrollView.tag == 500) {//外层scrollview
        NSInteger midScrollViewIndex = (NSInteger)(fabs((scrollView.contentOffset.x/KScreenWidth)));
        [self selectedGiftTypeByIndex:midScrollViewIndex+1 isClick:NO];
        self.pageControl.numberOfPages = [_scrollContentArr[midScrollViewIndex]integerValue];
        
        UIScrollView *subScrollView = [self.midScrollView viewWithTag:midScrollViewIndex + 600];
        NSInteger subScrollIndex = (NSInteger)(fabs((subScrollView.contentOffset.x/KScreenWidth)));
        self.pageControl.currentPage = subScrollIndex;
        self.pageControl.hidden = self.pageControl.numberOfPages<=1?YES:NO;
        
    } else {//内层scrollview
        
        NSInteger subScrollIndex = (NSInteger)(fabs((scrollView.contentOffset.x/KScreenWidth)));
        self.pageControl.currentPage = subScrollIndex;
        [scrollView setContentOffset:CGPointMake(KScreenWidth * subScrollIndex,0)];
    }
    
    
}

//点击常规，轻奢，豪华(1,2,3)
- (void)selectedGiftTypeByIndex:(NSUInteger)index isClick:(BOOL)isClick{
    [_typeBtnArr enumerateObjectsUsingBlock:^(UIButton *btn , NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn.tag == index) {
            btn.selected = YES;
            btn.titleLabel.font = kPingFangMedium(15);
        } else {
            btn.selected = NO;
            btn.titleLabel.font = kPingFangRegular(15);
        }
    }];
    
    if (!isClick) return;
    
    //外层scrollview
    self.pageControl.numberOfPages = [_scrollContentArr[index-1]integerValue];
    [_midScrollView setContentOffset:CGPointMake((index-1)*kScreenWidth, 0)];
    self.pageControl.hidden = self.pageControl.numberOfPages<=1?YES:NO;
    
    //内层scrollview
    UIScrollView *subScrollView = [self.midScrollView viewWithTag:(index-1) + 600];
    [subScrollView setContentOffset:CGPointMake(0, 0)];//默认第0组
}

- (void)setScrollViewOffset{
    
}

//点击某个礼物
- (void)selectedGiftBtnByIndex:(NSUInteger)index{
    [_giftBtnArr enumerateObjectsUsingBlock:^(UIButton *btn , NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn.tag == index) {
            btn.selected = YES;
            btn.layer.borderColor = KZSHColorF29E19.CGColor;
            btn.layer.borderWidth = 1.0;
    
        } else {
            btn.selected = NO;
            btn.layer.borderWidth = 0;
 
        }
    }];
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
