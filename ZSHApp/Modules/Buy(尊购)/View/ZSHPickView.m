//
//  ZSHPickView.m
//  RLJKApp
//
//  Created by zhaoweiwei on 2017/9/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHPickView.h"
#import "ZSHTopLineView.h"

NSUInteger yearSatrt = 1900;

@interface ZSHPickView() <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign) ShowPickViewWindowType        showType;
@property (nonatomic, strong) ZSHTopLineView                *topLineView;
@property (nonatomic, strong) UIView                        *mainView;
@property (nonatomic, strong) NSArray                       *titleArr;
@property (nonatomic, strong) UIPickerView                  *pickerView;
@property (nonatomic, strong) UILabel                       *customLabel;

@property (nonatomic, copy)   NSMutableArray       *birthdayValues;
@property (nonatomic, copy)   NSMutableArray       *timeValues;

@property (nonatomic, strong) NSArray              *birthdayWidthArr;
@property (nonatomic, strong) NSArray              *regionWidthArr;
@property (nonatomic, strong) NSArray              *regionArr;
@property (nonatomic, strong) NSArray              *couponArr;
@property (nonatomic, strong) NSArray              *KTVHourArr;
@property (nonatomic, strong) NSArray              *seatArr;
@property (nonatomic, strong) NSArray              *togetherArr;

@property (nonatomic, assign) long long            birthday;
@property (nonatomic, assign) NSInteger            currentYear;
@property (nonatomic, assign) NSInteger            currentMonth;
@property (nonatomic, assign) NSInteger            currentDay;
@property (nonatomic, assign) NSInteger            selectedRow;

@end

@implementation ZSHPickView

- (id)initWithFrame:(CGRect)frame type:(ShowPickViewWindowType)type{
    self = [super initWithFrame:frame];
    if (self) {
        _showType = type;
        
        [self createData];
        [self createUI];
    }
    return self;
}

- (void)createData{
    self.selectedRow = -1;
    self.titleArr = @[@"生日",@"性别",@"城市区域选择",@"年份",@"优惠券选择",@"时间选择",@"方式选择"];
    self.regionWidthArr = @[@(KScreenWidth * 0.25),@(KScreenWidth * 0.5),@(KScreenWidth * 0.25)];
    self.regionArr = @[@[@"北京",@"天津市",@"河北省",@"山东省"],
                       @[@"北京市",@"天津市",@"石家庄",@"聊城市"],
                       @[@"朝阳区",@"天津市",@"北辰区",@"聊城市"]
                       ];
    self.couponArr = @[@"使用优惠券",@"20元代金券",@"50元代金券"];
    self.seatArr = @[@"不限",@"经济仓",@"头等／商务舱"];
    self.togetherArr = @[@"不限",@"给力邀约",@"AA互动趴"];
   
    // 年月日
    self.birthdayWidthArr = @[@(75),@(45),@(60)];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [NSDate date];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:unitFlags fromDate:date];
    _currentYear = [comps year];
    _currentMonth = [comps month];
    _currentDay = [comps day];
    
    NSMutableArray *arrayYear = [NSMutableArray array];
    for (NSUInteger i = yearSatrt; i <= _currentYear; i++) {
        [arrayYear addObject:[NSString stringWithFormat:@"%ld年",(long)i]];
    }
    NSMutableArray *arrayMonth = [NSMutableArray array];
    
    for (NSUInteger i = 1; i <= 12; i++) {
        [arrayMonth addObject:[NSString stringWithFormat:@"%ld月",(long)i]];
    }
    if (_showType == WindowTime) {
        [arrayMonth insertObject:@"全年" atIndex:0];
    }
    NSMutableArray *arrayDay = [NSMutableArray array];
    _birthdayValues = [NSMutableArray arrayWithArray:@[arrayYear,arrayMonth,arrayDay]];
    _timeValues =  [NSMutableArray arrayWithArray:@[arrayYear,arrayMonth]];
}

- (void)createUI{
    kWeakSelf(self);
    self.windowLevel = UIWindowLevelAlert;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.mainView];
    [self.mainView addSubview:self.topLineView];
     self.topLineView.btnActionBlock = ^(NSInteger tag) {
         tag == 0 ? [weakself dismiss]:[weakself saveChange];
    };
    
     //底部添加pickview
     [self.mainView addSubview:self.pickerView];
     [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(_mainView).offset(kRealValue(50));
         make.left.and.right.mas_equalTo(_mainView);
         make.bottom.mas_equalTo(self);
     }];
}

#pragma mark --- 与DataSource有关的代理方法
//返回列数（必须实现）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (_showType) {
        case WindowBirthDay:
            return _birthdayValues.count;
        case WindowRegion:
            return _regionArr.count;
        case WindowTime:
            return _timeValues.count;
        default:
            return 1;
    }
}

//返回每列里边的行数（必须实现）
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (_showType) {
        case WindowBirthDay:{
            return [_birthdayValues[component]count];
        }
        case WindowRegion:{
            return [_regionArr[component]count];
        }
        case WindowTime:{
            return [_timeValues[component]count];
        }
        case WindowCoupon:{
            return [_couponArr count];
        }
        case WindowTogether:{
            return [_togetherArr count];
        }
        default:
            return 0;
    }
}

#pragma mark --- 与处理有关的代理方法
//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kRealValue(42);
}

//设置组件中每行的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (_showType) {
        case WindowBirthDay:{
            return  kRealValue([self.birthdayWidthArr[component]floatValue]);
        }
        case WindowRegion:{
            return ([self.regionWidthArr[component]floatValue]);
        }
        case WindowTime:{
            return kRealValue(100);
        }
            default:
            return KScreenWidth;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    CGFloat labelWith = [self pickerView:pickerView widthForComponent:component];
    CGFloat labelHeight = [self pickerView:pickerView rowHeightForComponent:component];
    NSDictionary *textLabelDic = @{@"text":@"",@"font":kPingFangRegular(14),@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *pickViewLabel = (UILabel *)view;
    if (!pickViewLabel){
        pickViewLabel = [ZSHBaseUIControl createLabelWithParamDic:textLabelDic];
        pickViewLabel.frame = CGRectMake(0, 0, labelWith, labelHeight);
    }
    if (row == self.selectedRow) {
        pickViewLabel.font = kPingFangMedium(14);
    } else {
        pickViewLabel.font = kPingFangRegular(14);
    }

    switch (_showType) {
        case WindowBirthDay:{
            pickViewLabel.text = _birthdayValues[component][row];
            break;
        }
        case WindowRegion:{
            pickViewLabel.text = _regionArr[component][row];
             break;
        }
        case WindowTime:{
            pickViewLabel.text = _timeValues[component][row];
             break;
        }
        case WindowCoupon:{
            pickViewLabel.text = _couponArr[row];
             break;
        }
        case WindowTogether:{
            pickViewLabel.text = _togetherArr[row];
             break;
        }
        default:
            pickViewLabel.text = @"";
             break;
    }
    return pickViewLabel;

}

//选择器选择的方法  row：被选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedRow = row;
    [self.pickerView selectRow:self.selectedRow inComponent:component animated:YES];
    [self.pickerView reloadComponent:component];
    switch (_showType) {
        case WindowBirthDay:{
            if (component == 0 || component == 1) { // 年和月变化的时候都应该去刷新日期
                [self refreshDayDay];
            }
            break;
        }
        case WindowRegion:{
            RLog(@"选择位置%d",row);
            break;
        }
        case WindowTime:{
            RLog(@"选择年份%ld",row);
            [self refreshMonth];
            break;
        }
        case WindowCoupon:
        case WindowTogether:{
            RLog(@"选择券%ld",row);
            break;
        }
            
        default:
            break;
    }
}

#pragma action
- (void)setUserBirthDay:(long long)birthday{
    _birthday = birthday;
}

- (void)show:(ShowPickViewWindowType)type{
    _showType = type;
    [_pickerView reloadAllComponents];
    switch (_showType) {
        case WindowBirthDay:{
            _birthday = [@(19920322) longLongValue];
            if (_birthday > 0) {
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                long long birthCache = _birthday / 1000;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:birthCache];
                NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
                NSDateComponents *comps = [[NSDateComponents alloc] init];
                comps = [calendar components:unitFlags fromDate:date];
                NSInteger year = [comps year];
                NSInteger month = [comps month];
                NSInteger day = [comps day];
                
                [_pickerView selectRow:year - yearSatrt inComponent:0 animated:NO];
                [_pickerView selectRow:month - 1 inComponent:1 animated:NO];
                [_pickerView selectRow:day - 1 inComponent:2 animated:NO];
                
                [self refreshDayDay];
            } else {  // default 1990/8/8
                NSMutableArray *arrayDay = _birthdayValues[2];
                [arrayDay removeAllObjects];
                for (NSUInteger i = 1; i <= 31; i++) {
                    [arrayDay addObject:[NSString stringWithFormat:@"%ld日",(long)i]];
                }
                [_pickerView selectRow:90 inComponent:0 animated:NO];
                [_pickerView selectRow:7 inComponent:1 animated:NO];
                [_pickerView selectRow:7 inComponent:2 animated:NO];
            }
            break;
        }
            
        case WindowRegion:{
             [_pickerView selectRow:1 inComponent:0 animated:NO];
             [_pickerView selectRow:1 inComponent:1 animated:NO];
             [_pickerView selectRow:1 inComponent:2 animated:NO];
            break;
        }
        case WindowTime:{
             [_pickerView selectRow:2017-yearSatrt inComponent:0 animated:NO];
             [_pickerView selectRow:8 inComponent:1 animated:NO];
             [self refreshMonth];
            break;
        }
            
        default:{
             [_pickerView selectRow:1 inComponent:0 animated:NO];
            break;
        }
    }
    
//    self.selectedRow = [_pickerView selectedRowInComponent:0];
    
    
    
    
    [self makeKeyAndVisible];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect mainFrame = _mainView.frame;
        mainFrame.origin.y = self.frame.size.height - mainFrame.size.height;
        _mainView.frame = mainFrame;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect mainFrame = _mainView.frame;
        mainFrame.origin.y = self.frame.size.height;
        _mainView.frame = mainFrame;
    } completion:^(BOOL finished) {
        [self resignKeyWindow];
        [self setHidden:YES];
    }];
}

- (void)saveChange {
    switch (_showType) {
        case WindowBirthDay:{
            RLog(@"保存生日数据");
            break;
        }
        case WindowGender:{
            RLog(@"保存性别数据");
            break;
        }
        case WindowRegion:{
            NSInteger region = [_pickerView selectedRowInComponent:0];
            RLog(@"保存区域数据%ld",region);
            break;
        }
            
        case WindowTime:{
            NSInteger year = [_pickerView selectedRowInComponent:0];
            NSInteger month = [_pickerView selectedRowInComponent:1];
            NSString *dateStr = [NSString stringWithFormat:@"%02ld/%ld",month,yearSatrt + year];
            RLog(@"保存区域数据%ld%ld",year,month);
            if (self.saveChangeBlock) {
                self.saveChangeBlock(dateStr);
            }
            break;
        }
        default:
            break;
    }
    [self dismiss];
}

- (void)refreshMonth{
    NSArray *cache = _timeValues[0];
    NSString *year = cache[[_pickerView selectedRowInComponent:0]];
    NSUInteger yearInt = [year integerValue];
    
    NSMutableArray *arrayMonth = _timeValues[1];
    
    if (yearInt == _currentYear) {// 当前年，要检查月和日
        [arrayMonth removeAllObjects];
        for (NSUInteger i = 1; i <= _currentMonth; i++) {
            [arrayMonth addObject:[NSString stringWithFormat:@"%ld月",(long)i]];
        }
        if (_showType == WindowTime) {
            [arrayMonth insertObject:@"全年" atIndex:0];
        }
        //刷新第一列的信息
        [_pickerView reloadComponent:1];
    } else {
        [arrayMonth removeAllObjects];
        for (NSUInteger i = 1; i <= 12; i++) {
            [arrayMonth addObject:[NSString stringWithFormat:@"%ld月",(long)i]];
        }
        if (_showType == WindowTime) {
            [arrayMonth insertObject:@"全年" atIndex:0];
        }
        //刷新第一列的信息
        [_pickerView reloadComponent:1];
    }
}

-(void)refreshDayDay{
    NSArray *cache = _birthdayValues[0];
    NSString *year = cache[[_pickerView selectedRowInComponent:0]];
    NSUInteger yearInt = [year integerValue];
    
    NSMutableArray *arrayMonth = _birthdayValues[1];
    NSString *month = arrayMonth[[_pickerView selectedRowInComponent:1]];
    NSUInteger monthInt = [month integerValue];
    if (yearInt == _currentYear) { // 当前年，要检查月和日
        [arrayMonth removeAllObjects];
        for (NSUInteger i = 1; i <= _currentMonth; i++) {
            [arrayMonth addObject:[NSString stringWithFormat:@"%ld月",(long)i]];
        }
        //刷新第一列的信息
        [_pickerView reloadComponent:1];
        
        // 因为month刷新了，所以要重新获取当前选中的月份
        month = arrayMonth[[_pickerView selectedRowInComponent:1]];
        NSUInteger monthInt = [month integerValue];
        
        if (monthInt == _currentMonth) {
            NSMutableArray *arrayDay = _birthdayValues[2];
            [arrayDay removeAllObjects];
            for (NSUInteger i = 1; i <= _currentDay; i++) {
                [arrayDay addObject:[NSString stringWithFormat:@"%ld日",(long)i]];
            }
            //刷新第一列的信息
            [_pickerView reloadComponent:2];
            return;
        }
    } else {
        [arrayMonth removeAllObjects];
        for (NSUInteger i = 1; i <= 12; i++) {
            [arrayMonth addObject:[NSString stringWithFormat:@"%ld月",(long)i]];
        }
        //刷新第一列的信息
        [_pickerView reloadComponent:1];
    }
    
    NSUInteger maxDay = 30;
    switch (monthInt) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            maxDay = 31;
            break;
        case 2:{
            NSArray *cache = _birthdayValues[0];
            NSString *year = cache[[_pickerView selectedRowInComponent:0]];
            NSUInteger yearInt = [year integerValue];
            if((yearInt % 4 == 0 && yearInt % 100 != 0) || yearInt % 400 == 0){
                maxDay = 29;
            }else{
                maxDay = 28;
            }
        }
            break;
        default:
            maxDay = 30;
            break;
    }
    NSMutableArray *arrayDay = _birthdayValues[2];
    [arrayDay removeAllObjects];
    for (NSUInteger i = 1; i <= maxDay; i++) {
        [arrayDay addObject:[NSString stringWithFormat:@"%ld日",(long)i]];
    }
    //刷新第一列的信息
    [_pickerView reloadComponent:2];
}


#pragma getter
- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, kRealValue(200))];
        _mainView.backgroundColor = KWhiteColor;
    }
    return _mainView;
}

- (ZSHTopLineView *)topLineView{
    if (!_topLineView) {
        NSDictionary *paramDic = @{@"typeText":_titleArr[_showType]};
        _topLineView = [[ZSHTopLineView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(50)) paramDic:paramDic];
    }
    return _topLineView;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = NO;
    }
    return _pickerView;
}

@end
