//
//  ChannelCell.m
//  ChannelTag
//
//  Created by Shin on 2017/11/26.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import "ChannelCell.h"

@interface ChannelCell ()
@end

@implementation ChannelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = KZSHColor929292.CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = kRealValue(3.0);
   
        NSDictionary *titleLBDic = @{@"text":@"",@"font":kPingFangRegular(15),@"textAlignment":@(NSTextAlignmentCenter)};
        _title = [ZSHBaseUIControl createLabelWithParamDic:titleLBDic];
        [self.contentView addSubview:_title];
        _title.frame = CGRectMake(5, 5, frame.size.width-10, frame.size.height-10);
        _title.numberOfLines = 0;
       
        
        _delBtn = [[UIButton alloc]init];
        [_delBtn setImage:[UIImage imageNamed:@"topline_close"] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        _delBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_delBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -(frame.size.width-kRealValue(20)), 0, 0)];
        [self.contentView addSubview:_delBtn];
        [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(frame.size.width, frame.size.height));
            make.left.mas_equalTo(self);
        }];
        
    }
    return self;
}

-(void)setModel:(Channel *)model{
    _model = model;
    
    if (model.tagType == MyChannel) {
//        if ([model.title containsString:@"＋"]) {
//            model.title = [model.title substringFromIndex:1];
//        }
        if (model.editable) {
        }else{
            model.editable = YES;
        }
        
        if (model.resident) {
            _delBtn.hidden = YES;
        }else{
            _delBtn.hidden = NO;
        }
        
        //选择出来的tag高亮显示
//        if (model.selected) {
//            _title.textColor = [UIColor colorWithRed:0.5 green:0.26 blue:0.27 alpha:1.0];
//        }else{
//            _title.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.0];
//        }
        
    } else if (model.tagType == RecommandChannel){
//        if (![model.title containsString:@"＋"]) {
//            model.title = [@"＋" stringByAppendingString:model.title];
//        }
        if (model.editable) {
            model.editable = NO;
        }else{
        }
//        if (model.resident) {
//            _delBtn.hidden = YES;
//        }else{
//            _delBtn.hidden = NO;
//        }
        _delBtn.hidden = YES;
    }
    _title.text = model.title;
    
}



- (void)delete:(UIButton *)sender{
    
    [_delegate deleteCell:sender];
}

@end
