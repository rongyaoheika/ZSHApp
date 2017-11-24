//
//  ZSHBaseUIControl.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSHBaseTableViewModel;

typedef NS_ENUM(NSInteger,ZSHCellType){
    ZSHTableViewCellType,
    ZSHCollectionViewCellType
};

typedef NS_ENUM(NSInteger,ZSHToChangePWDView){
    FromHomeNoticeVCToNoticeView,     //首页 - 公告
    FromHomeServiceVCToNoticeView,    //首页 - 玩趴
    FromHomeMagazineVCToNoticeView,   //首页 - 荣耀杂志
    FromKTVCalendarVCToNoticeView,      //KTV详情 - 预定日历
    FromKTVRoomTypeVCToNoticeView,      //KTV详情 - 包间类型
    FromMemberCenterVCToNoticeView,     //会员中心 - 类型
    FromEnergyValueVCToNoticeView,      //能量值 - 类型
    FromNoneVCToChangePWDView
};

typedef NS_ENUM(NSUInteger,ZSHFromVCToHotelDetailVC){//** -> 详情页面
    ZSHFromHotelVCToHotelDetailVC,     //酒店-酒店详情
    ZSHFromHotelPayVCToHotelDetailVC,  //酒店确认订单-底部弹窗
    ZSHFromFoodVCToHotelDetailVC,      //美食-美食详情
    ZSHFromHomeKTVVCToHotelDetailVC,   //KTV-KTV详情
    ZSHFromNoneVCToHotelDetailVC
};

typedef NS_ENUM(NSUInteger,ZSHFromVCToHotelPayVC){//** -> 订单支付页面
    ZSHFromHotelDetailVCToHotelPayVC,               //酒店详情-酒店支付
    ZSHFromHotelDetailBottomVCToHotelPayVC,         //酒店详情(底部弹窗)-酒店支付
    ZSHFromKTVDetailVCToHotelPayVC,                 //KTV详情-KTV支付
    ZSHFromNoneVCToHotelPayVC
};

// 显示选择
typedef NS_ENUM(NSInteger, ShowPickViewWindowType) {
    WindowBirthDay,                // 出生日期
    WindowGender,                  // 性别
    WindowRegion,                  // 区域
    WindowInterval,                // 区间
    WindowTime,                    // 年份
    WindowCoupon,                  // 优惠券
    WindowKTVHour,                 // KTV时间选择
    WindowTogether,                // 汇聚
    WindowLogistics,               // 物流公司
    WindowSeat,                    // 座位选择
    WindowPapers,                  // 证件选择
    WindowPrice,                   // 价格
    WindowKTVNone
};

typedef NS_ENUM(NSInteger,ZSHToSimpleCellView){
    FromSetEditInfoVCToSimpleCellView,     //设置-个人资料
    FromSetNoticeInfoVCToSimpleCellView,   //设置-新消息通知
    FromNoneToSimpleCellView
};

typedef NS_ENUM (NSInteger,ZSHToTextFieldCellView) {
    FromMultiInfoNickNameVCToTextFieldCellView,    //修改昵称 - 自定义view
    FromMultiInfoAccountVCToTextFieldCellView,     //找回登录密码 - 自定义View
    FromAirTicketDetailVCToTextFieldCellView,      //机票弹窗-个人信息
    FromMultiInfoQQVCToTextFieldCellView,          //绑定QQ帐号
    FromMultiPhoneVCToTextFieldCellView,           //更改手机号
    FromLoginVCToTextFieldCellView,                //登录-自定义View
    FromCardVCToTextFieldCellView,                 //黑卡定制-自定义View
    FromNoneToTextFieldCellView
};

typedef NS_ENUM(NSInteger,ZSHToMultiInfoVC){
    FromLoginVCToMultiInfoVC,                       //登录 - 立即注册
    FromUserInfoNickNameVCToMultiInfoVC,            //个人资料 - 修改昵称
    FromAccountVCToMultiInfoVC,                     //密码 - 找回登录密码
    FromChangePwdVCToMultiInfoVC,                   //添加银行卡1 - 添加银行卡2
    FromUserInfoPhoneVCToMultiInfoVC,               //个人资料 - 手机号
    FromUserInfoQQVCToMultiInfoVC,                  //个人资料 - 绑定QQ帐号
    FromNoneToMultiInfoVC
};

typedef NS_ENUM (NSInteger,ZSHToNotificationVC) {
    FromSettingVCToNotificationVC,         //设置 - 新消息通知
    FromLiveMineVCToNotificationVC,        //尚播 - 设置
    FromActivityCenterVCToNotificationVC
};

typedef NS_ENUM (NSInteger,ZSHToGuideView) {
    FromGuideVCToGuideView,           //引导页 - 轮播view
    FromCardVCToGuideView,            //黑卡设置页 - 轮播view
    FromHotelDetailVCToGuideView,     //酒店（美食，ktv详情页） - 轮播view
    FromNoneVCToGuideView
};

@interface ZSHBaseUIControl : NSObject

+ (UILabel *)createLabelWithParamDic:(NSDictionary *)paramDic;
+ (UIButton *)createBtnWithParamDic:(NSDictionary *)paramDic;
+ (UITableView *)createTableView;
+ (UIButton *)createLabelBtnWithTopDic:(NSDictionary *)topDic bottomDic:(NSDictionary *)bottomDic;
+ (UIView *)createTabHeadLabelViewWithParamDic:(NSDictionary *)paramDic;
+ (void) setAnimationWithHidden:(BOOL)hidden view:(UIView *)view completedBlock:(RemoveCompletedBlock)completedBlock;
+ (UIView *)createBottomButton;


@end
