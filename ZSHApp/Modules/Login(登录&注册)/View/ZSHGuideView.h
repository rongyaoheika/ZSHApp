//
//  ZSHGuideView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"
#import "TYCyclePagerView.h"


typedef void (^DidSelected) (NSInteger index);

@interface ZSHGuideView : ZSHBaseView

@property (nonatomic, copy) DidSelected didSelected;

@end
