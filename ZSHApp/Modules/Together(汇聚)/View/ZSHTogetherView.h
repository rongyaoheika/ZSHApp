//
//  ZSHTogetherView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

//#import "ZSHBaseView.h"
#import "ZSHBaseCell.h"

typedef NS_ENUM(NSInteger,ZSHFromVCToTogetherView){
    ZSHFromTogetherVCToTogetherView,         //汇聚-自定义view
    ZSHFromPersonalTailorVCToTogetherView,   //私人定制-自定义cell
    ZSHFromNoneVCToToTogetherView
};

@interface ZSHTogetherView : ZSHBaseCell  //ZSHBaseView


@end
