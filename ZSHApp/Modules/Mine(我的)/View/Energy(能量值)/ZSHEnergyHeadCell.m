//
//  ZSHEnergyHeadCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEnergyHeadCell.h"
#import "ZSHNotCycleScrollView.h"
#import "BEMSimpleLineGraphView.h"
#import "ZSHMineLogic.h"
#import "ZSHEnergyValueModel.h"
#import "ZSHEnergyModel.h"


@interface ZSHEnergyHeadCell()<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>
{
    int previousStepperValue;
    int totalNumber;
}


@property (strong, nonatomic) BEMSimpleLineGraphView    *myGraph;
@property (strong, nonatomic) NSMutableArray            *arrayOfValues;
@property (strong, nonatomic) NSMutableArray            *arrayOfDates;

@property (nonatomic, strong) ZSHNotCycleScrollView     *itemScrollView;
//@property (nonatomic, strong) UIImageView             *bgImageView;
@property (nonatomic ,strong) NSMutableArray            *btnArr;
@property (nonatomic, strong) ZSHMineLogic              *mineLogic;



@end

@implementation ZSHEnergyHeadCell

- (void)setup{
    //
//    UIImage *bgImage = [UIImage imageNamed:@"mine_energy_bg"];
//    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//    _bgImageView.image = bgImage;
//    [self.contentView addSubview:_bgImageView];
    
    self.myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 230)];
    self.myGraph.delegate = self;
    self.myGraph.dataSource = self;
    [self addSubview:self.myGraph];
    
    // Create a gradient to apply to the bottom portion of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        0.35, 0.666, 0.745, 1.0,
        0.337, 0.698, 0.729, 0.0
    };

    // Apply the gradient to the bottom portion of the graph
    self.myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    

    // Enable and disable various graph properties and axis displays
    self.myGraph.enableTouchReport = YES;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.enableYAxisLabel = YES;
    self.myGraph.enableXAxisLabel = YES;
    self.myGraph.autoScaleYAxis = YES;
    self.myGraph.alwaysDisplayDots = NO;
    self.myGraph.enableReferenceXAxisLines = YES;
    self.myGraph.enableReferenceYAxisLines = YES;
    self.myGraph.enableReferenceAxisFrame = YES;
    self.myGraph.enableLeftReferenceAxisFrameLine = YES;
    self.myGraph.enableBezierCurve = YES;
    self.myGraph.animationGraphStyle = BEMLineAnimationFade;
    self.myGraph.colorLine = KZSHColor58AABE;
    self.myGraph.colorYaxisLabel = KWhiteColor;
    self.myGraph.colorXaxisLabel = KWhiteColor;
    self.myGraph.widthLine = 3;
    
    UIColor *color = KBlackColor;
    self.myGraph.colorTop = color;
    self.myGraph.colorBottom = color;
    self.myGraph.backgroundColor = color;
    
    // Draw an average line
//    self.myGraph.averageLine.enableAverageLine = true;
//    self.myGraph.averageLine.alpha = 0.6;
//    self.myGraph.averageLine.color = [UIColor darkGrayColor];
//    self.myGraph.averageLine.width = 2.5;
//    self.myGraph.averageLine.dashPattern = @[@(2),@(2)];
    

    
    // Dash the y reference lines
    self.myGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
//    self.myGraph.formatStringForValues = @"%.1f";
    
    
    
    kWeakSelf(self);
    [self.contentView addSubview:self.itemScrollView];
    self.itemScrollView.selectedBlock = ^(NSInteger index){
        if (weakself.itemClickBlock) {
            weakself.itemClickBlock(index);
        }
    };
    
    _btnArr = [[NSMutableArray alloc]init];
    NSArray *topTitleArr = @[@"99",@"99",@"99",@"99",@"99"];
    NSArray *bottomTitleArr = @[@"购物分",@"活动分",@"互动分",@"基础分",@"荣耀分"];
    NSArray *colorArr = @[[UIColor colorWithHexString:@"D48B32"],[UIColor colorWithHexString:@"4B70C5"],[UIColor colorWithHexString:@"E34C4C"],[UIColor colorWithHexString:@"EBE758"],[UIColor colorWithHexString:@"69E2D3"]];
    _itemScrollView.fromClassType = FromEnergyValueVCToNoticeView;
    for (int i = 0; i<topTitleArr.count; i++) {
        NSDictionary *topTitleDic = @{@"text":topTitleArr[i],@"font":kPingFangMedium(30),@"textColor":colorArr[i], @"height":@(40),@"textAlignment":@(NSTextAlignmentCenter)};
        NSDictionary *bottomTitleDic = @{@"text":bottomTitleArr[i], @"font":kPingFangRegular(14),@"textColor":colorArr[i],@"height":@(30),@"textAlignment":@(NSTextAlignmentCenter)};
        UIButton *labelBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:topTitleDic bottomDic:bottomTitleDic];
        [_btnArr addObject:labelBtn];
    }
    
    [self.itemScrollView reloadViewWithDataArr:_btnArr];
    
    _mineLogic = [[ZSHMineLogic alloc] init];
    [self requestEneryValueMonth];
}

- (void)layoutSubviews{
    [super layoutSubviews];

//     UIImage *bgImage = [UIImage imageNamed:@"mine_energy_bg"];
//    _bgImageView.frame = CGRectMake(0, 0, bgImage.size.width,bgImage.size.height);
    
    [_itemScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_bgImageView.mas_bottom).offset(kRealValue(20));
        make.top.mas_equalTo(self.contentView).offset(kRealValue(250));
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(KScreenWidth);
        make.bottom.mas_equalTo(self);
    }];
}
- (void)requestEneryValueMonth {
    kWeakSelf(self);
    [_mineLogic requestEnergyValueMonth:^(id response) {
        NSArray *arr =  [ZSHEnergyValueModel mj_objectArrayWithKeyValuesArray:response[@"pd"]];
        [weakself hydrateDatasets:arr];
    }];
}

#pragma getter
- (ZSHNotCycleScrollView *)itemScrollView{
    if (!_itemScrollView) {
        _itemScrollView = [[ZSHNotCycleScrollView alloc] init];
        _itemScrollView.selectedColor = KClearColor;
        _itemScrollView.indicatorHeight = 0.0;
        _itemScrollView.itemWidth = kRealValue(108);
    }
    return _itemScrollView;
}


- (void)updateCellWithDataArr:(NSArray *)dataArr {
    for (int i = 0; i < dataArr.count; i++) {
        UILabel *score  =  [_btnArr[i] viewWithTag:1];
        UILabel *name = [_btnArr[i] viewWithTag:2];
        ZSHEnergyModel *model = dataArr[i];
        score.text = model.SCORE;
        name.text = model.NAME;
    }
}

#pragma mark - Chart
- (void)hydrateDatasets:(NSArray *)arr {
    // Reset the arrays of values (Y-Axis points) and dates (X-Axis points / labels)
    if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];
    
//    previousStepperValue = 12;//self.graphObjectIncrement.value;
//    totalNumber = 0;
//    NSDate *baseDate = [NSDate date];
//    BOOL showNullValue = false;
//    
//    // Add objects to the array based on the stepper value
//    for (int i = 0; i < 12; i++) {
//        [self.arrayOfValues addObject:@(100)]; // Random values for the graph [self getRandomFloat]
//        if (i == 0) {
//            [self.arrayOfDates addObject:baseDate]; // Dates for the X-Axis of the graph
//        } else if (showNullValue && i == 4) {
//            [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
//            self.arrayOfValues[i] = @(BEMNullGraphValue);
//        } else {
//            [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
//        }
//        
//        totalNumber = totalNumber + [[self.arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
//    }
//    [self.arrayOfValues removeAllObjects];
//    [self.arrayOfDates removeAllObjects];
    for (int i = 0; i < arr.count; i++) {
        ZSHEnergyValueModel *model = arr[arr.count-i-1];
        [self.arrayOfValues addObject:@([model.ENERGYVALUE integerValue])];
        [self.arrayOfDates addObject:model.months];
    }

    [self.myGraph reloadGraph];
}

- (float)getRandomFloat {
    float i1 = (float)(arc4random() % 1000000) / 100 ;
    return i1;
}

- (NSDate *)dateForGraphAfterDate:(NSDate *)date {
    NSTimeInterval secondsInTwentyFourHours = 24 * 60 * 60;
    NSDate *newDate = [date dateByAddingTimeInterval:secondsInTwentyFourHours];
    return newDate;
}

- (NSString *)labelForDateAtIndex:(NSInteger)index {
    NSDate *date = self.arrayOfDates[index];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd";
    NSString *label = [df stringFromDate:date];
    return label;
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    NSString *label = self.arrayOfDates[index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {

}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {

}

/* - (void)lineGraphDidFinishDrawing:(BEMSimpleLineGraphView *)graph {
 // Use this method for tasks after the graph has finished drawing
 } */

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return @"";
}

//- (NSString *)popUpPrefixForlineGraph:(BEMSimpleLineGraphView *)graph {
//    return @"$ ";
//}



@end
