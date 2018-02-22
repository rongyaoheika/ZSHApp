//
//  QQLrcCell.m
//  QQMusic
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 KeenLeung. All rights reserved.
//

#import "QQLrcCell.h"
#import "QQLrcLabel.h"

@interface QQLrcCell()

@property (weak, nonatomic) IBOutlet QQLrcLabel *lrcContentLabel;

@end

@implementation QQLrcCell

#pragma mark --------------------------
#pragma mark 重写 set

/** 给子控件赋值*/
- (void)setLrcModel:(QQLrcModel *)lrcModel{
    _lrcModel = lrcModel;
    
    self.lrcContentLabel.text = lrcModel.lrcStr;
}

/** 设置播放进度*/
- (void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    
    self.lrcContentLabel.progress = progress;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    // 处理选中后的效果
//    if (selected) {
//        self.lrcContentLabel.textColor = KZSHColorA61CE7;
//        self.lrcContentLabel.font = kPingFangRegular(20);
//    } else {
//        self.lrcContentLabel.textColor = KWhiteColor;
//        self.lrcContentLabel.font = kPingFangRegular(18);
//    }
//}

@end
