//
//  ZSHFootPlayMusicView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"


typedef void(^FootViewAction) ();

@interface ZSHFootPlayMusicView : ZSHBaseView

@property (nonatomic, copy) FootViewAction  footerViewAction;

@end
