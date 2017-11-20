//
//  YHSlider.m
//  SliderDemo
//
//  Created by yunhang on 2017/1/10.
//  Copyright © 2017年 muse. All rights reserved.
//

#import "YHSlider.h"
@interface YHSlider ()

@property (nonatomic,strong) UIImageView *first;

@property (nonatomic,strong) UIImageView *second;

@end
@implementation YHSlider
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 30)])
    {
        self.backgroundColor = [UIColor clearColor];
        [self first];
        [self second];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    
    self.first.center = CGPointMake( ((self.firstValue - self.minmumValue)/(self.maxmumValue - self.minmumValue)) *self.frame.size.width, 15);
    self.second.center = CGPointMake( ((self.secondValue - self.minmumValue)/(self.maxmumValue - self.minmumValue)) *self.frame.size.width, 15);
    
    CGFloat value1 = self.firstValue > self.secondValue ? self.secondValue:self.firstValue;
    CGFloat value2 = self.firstValue > self.secondValue ? self.firstValue : self.secondValue;
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGFloat minumTrackWidth = ((value1 - self.minmumValue)/(self.maxmumValue - self.minmumValue))  * self.frame.size.width;
    CGRect minumTrackRect = CGRectMake(0, 14, minumTrackWidth, 2);
    CGContextSetFillColorWithColor(ref, self.minimumTrackTintColor.CGColor);
    CGContextFillRect(ref, minumTrackRect);
    
    
    CGFloat thumbWidth = ((value2 - value1)/(self.maxmumValue - self.minmumValue)) * self.frame.size.width;
    CGContextSetFillColorWithColor(ref, self.thumbTintColor.CGColor);
    CGRect thumbRect = CGRectMake(minumTrackWidth, 14, thumbWidth, 2);
    CGContextFillRect(ref, thumbRect);
    
    
    CGRect maxumTrackRect = CGRectMake(minumTrackWidth + thumbWidth, 14, self.frame.size.width - minumTrackWidth - thumbWidth, 2);
    CGContextSetFillColorWithColor(ref, self.maximumTrackTintColor.CGColor);
    CGContextFillRect(ref, maxumTrackRect);
    
    CGPDFContextClose(ref);
}
#pragma mark - Target
- (void)panHappen:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    
    CGPoint center = pan.view.center;
    
    center.x += point.x;
    if (center.x > 0 && center.x < self.frame.size.width)
    {
        pan.view.center = center;
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self];
    
    self.firstValue = (_first.center.x/self.frame.size.width) * (self.maxmumValue - self.minmumValue) + self.minmumValue;
    self.secondValue = (_second.center.x/ self.frame.size.width) *(self.maxmumValue - self.minmumValue) + self.minmumValue;
    [self setNeedsDisplay];
    
    if (self.valueChanged) {
        self.valueChanged(self.firstValue, self.secondValue);
    }
}
#pragma mark - getter
- (UIColor *)thumbTintColor
{
    if (!_thumbTintColor)
    {
        _thumbTintColor = KZSHColorD8D8D8;
    }
    return _thumbTintColor;
}
- (UIColor *)minimumTrackTintColor
{
    if (!_minimumTrackTintColor) {
        _minimumTrackTintColor = KZSHColorD8D8D8;
    }
    return _minimumTrackTintColor;
}
- (UIColor *)maximumTrackTintColor
{
    if (!_maximumTrackTintColor)
    {
        _maximumTrackTintColor = KZSHColorD8D8D8;
    }
    return _maximumTrackTintColor;
}

- (UIImageView *)first
{
    if (!_first)
    {
        _first = [[UIImageView alloc] init];
        _first.userInteractionEnabled = YES;
        _first.bounds = CGRectMake(0, 0, kRealValue(10), kRealValue(10));
        _first.center = CGPointMake(0, 15);
        _first.layer.cornerRadius = kRealValue(10)/2.f;
        _first.backgroundColor = KClearColor;
        [self addSubview:_first];
        [_first addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHappen:)]];
        [self setFirstSliderImg:nil];
    }
    return _first;
}

- (UIImageView *)second
{
    if (!_second)
    {
        _second = [[UIImageView alloc] init];
        _second.userInteractionEnabled = YES;
        _second.frame = CGRectMake(0, 0, kRealValue(10), kRealValue(10));
        _second.layer.cornerRadius = kRealValue(10)/2.f;
        _second.backgroundColor = KClearColor;
        _second.center = CGPointMake(self.frame.size.width, 15);
        [_second addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHappen:)]];
        [self addSubview:_second];
        
        [self setSecondSliderImg:nil];
    }
    return _second;
}
#pragma mark - setter
- (void)setFirstSliderImg:(UIImage *)firstSliderImg
{
    if (firstSliderImg != _firstSliderImg)
    {
        _firstSliderImg = firstSliderImg;
    }
    if (_firstSliderImg == nil)
    {
        self.first.backgroundColor = KZSHColorD8D8D8;
    }
    else
    {
        self.first.image = firstSliderImg;
    }
}
- (void)setSecondSliderImg:(UIImage *)secondSliderImg
{
    if (_secondSliderImg != secondSliderImg)
    {
        _secondSliderImg = secondSliderImg;
    }
    if (_secondSliderImg == nil)
    {
        self.second.backgroundColor = KZSHColorD8D8D8;
    }
    else
    {
        self.second.image = _secondSliderImg;
    }
}
- (void)setFirstValue:(float)firstValue
{
    _firstValue = firstValue;
    [self setNeedsDisplay];
}
- (void)setSecondValue:(float)secondValue
{
    _secondValue = secondValue;
    [self setNeedsDisplay];
}
- (void)setMinmumValue:(float)minmumValue
{
    _minmumValue = minmumValue;
    [self setNeedsDisplay];
}
- (void)setMaxmumValue:(float)maxmumValue
{
    _maxmumValue = maxmumValue;
    [self setNeedsDisplay];
}

@end
