//
//  ZSHRadioSubView.h
//  ZSHApp
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHBaseView.h"

typedef void (^DidSelect)(NSInteger);

@interface ZSHRadioSubView : ZSHBaseView

@property (nonatomic, copy) DidSelect didSelect;

@end
