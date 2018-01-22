//
//  ZSHRadioScrollCell.m
//  ZSHApp
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHRadioScrollCell.h"
#import "ZSHRadioSubView.h"
#import "ZSHPlayListViewController.h"

@interface ZSHRadioScrollCell()<UIScrollViewDelegate>

@property (nonatomic, strong)  UIScrollView       *scrollView;
@property (nonatomic, strong)  NSMutableArray     *btnArr;
@property (nonatomic, assign)  CGFloat            startX;
@property (nonatomic, assign)  CGFloat            contentW;
@property (nonatomic, strong)  NSArray            *dataArr;

@end

@implementation ZSHRadioScrollCell

- (void)setup{
    _contentW = 0.9 * kScreenWidth;
    [self.contentView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*0.9*3, 0);
//    for (int i = 0; i<3; i++) {
//        for (int j = 0; j<3; j++) {
//            ZSHRadioSubView *radioSubView = [[ZSHRadioSubView alloc]initWithFrame:CGRectMake(kScreenWidth *0.9*i,(kRealValue(60)+ kRealValue(10)) * j, kScreenWidth *0.9, kRealValue(60))];
//            radioSubView.tag = i*3+j;
//            [self.scrollView addSubview:radioSubView];
//        }
//    }
    
}

- (void)updateCellWithParamDic:(NSDictionary *)dic {
    kWeakSelf(self);
    _dataArr = dic[@"dataArr"];
    NSInteger count = _dataArr.count/3;
    if (_dataArr.count%3 != 0)
        count++;

    for (int i = 0; i<count; i++) {
        for (int j = 0; j<3; j++) {
            int index = i*3+j;
            if (index >= _dataArr.count) continue;
            
            ZSHRadioSubView *radioSubView = [[ZSHRadioSubView alloc]initWithFrame:CGRectMake(kScreenWidth *0.9*i,(kRealValue(60)+ kRealValue(10)) * j, kScreenWidth *0.9, kRealValue(60))];
            [self.scrollView addSubview:radioSubView];
            radioSubView.tag = index;
            [radioSubView updateViewWithParamDic:_dataArr[index]];
            radioSubView.didSelect = ^(NSInteger tag) {
                NSDictionary *radioDic = weakself.dataArr[tag];
                NSDictionary *paramDic = @{@"ch_name":radioDic[@"ch_name"],KFromClassType:@(ZSHFromRadioVCToPlayListVC),@"headImage":radioDic[@"thumb"]};
                ZSHPlayListViewController *playListVC = [[ZSHPlayListViewController alloc]initWithParamDic:paramDic];
                [[kAppDelegate getCurrentUIVC].navigationController pushViewController:playListVC animated:YES];
            };
        }
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*0.9*count, 0);
}

#pragma getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
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
    NSInteger page = (NSInteger)(fabs((scrollView.contentOffset.x/_contentW))+0.5);
    [UIView animateWithDuration:0.5 animations:^{
        [scrollView setContentOffset:CGPointMake(_contentW * page,0)];
    } completion:^(BOOL finished) {
        
    }];
    
}
   

@end
