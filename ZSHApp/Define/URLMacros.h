//
//  URLMacros.h
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#ifndef URLMacros_h
#define URLMacros_h


//内部版本号 每次发版递增
#define KVersionCode 1
/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever    0
#define TestSever       1
#define ProductSever    0


#if DevelopSever

/**开发服务器*/

#define kUrlRoot                    @"http://192.168.1.134:8081/ZSHINTER/"
//#define kUrlRoot                  @"http://192.168.1.108:8080/ZSHINTER/"


#elif TestSever

/**测试服务器*/
//#define kUrlRoot                   @"http://192.168.1.108:8080/ZSHINTER/"
#define kUrlRoot                    @"http://192.168.1.134:8081/ZSHINTER/" //振华

#elif ProductSever

/**生产服务器（阿里云）*/
#define kUrlRoot                   @"http://47.104.16.215:8080/ZSHINTER/"


#endif


#pragma mark - ——————— 详细接口地址 ————————

//测试接口
#define kUrlTest                    @"/api/cast/home/start"

#pragma mark - ——————— 用户相关 ————————
//自动登录
#define kUrlUserAutoLogin           @"/api/autoLogin"
//登录
#define kUrlUserLogin               @"/appuserin/userloginphone?LOGIN"

// 1首页推荐（完成）
#define kUrlUserHome [NSString stringWithFormat:@"/apphomein/getrecommendlist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"COMMEND"]]
// 2用户注册 (完成)
#define kUrlUserRegister [NSString stringWithFormat:@"/appuserin/userregister?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"REGISTER"]]
// 3用户登录
//  手机号登录
//  参数：PHONE 手机号
#define kUrlUserLoginPhone [NSString stringWithFormat:@"/appuserin/userloginphone?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"LOGIN"]]
//  卡密登录
//  参数：CARDNO 登录会员卡号/PASSWORD 登录密码
#define kUrlUserLoginCard [NSString stringWithFormat:@"/appuserin/userlogincard?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"LOGIN"]]
// 4获取用户收货地址列表 （完成）
#define kUrlUserShipAdr [NSString stringWithFormat:@"/appuserin/usershipadr?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPADR"]]
// 5添加用户收货地址 （完成）
//  参数：CONSIGNEE 收货人姓名/ADRPHONE 收货人电话/PROVINCE  收货人所在地区/ADDRESS  收货人详细地址
#define kUrlUserAddShipAdr [NSString stringWithFormat:@"/appuserin/useraddshipadr?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPADR"]]
// 6修改用户收货地址 （完成）
// 参数：ADDRESS_ID 收货地址ID/CONSIGNEE 收货人姓名/ADRPHONE 收货人电话/PROVINCE 收货人所在地区/ADDRESS 收货人详细地址
#define kUrlUserEdiShipAdr [NSString stringWithFormat:@"/appuserin/useredishipadr?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPADR"]]
//7.删除用户收货地址（完成）
//参数：ADDRESS_ID 当前收货地址id
#define kUrlUserDelShipAdr [NSString stringWithFormat:@"/appuserin/userdelshipadr?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPADR"]]
//8.获取商品具体详情 （完成）
//参数：PRODUCT_ID 商品具体id
//请求地址：/appshipin/shipdetails?SHIPDT(混淆码)
#define kUrlShipDetails [NSString stringWithFormat:@"/appshipin/shipdetails?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPDT"]]
//9.获取所有商品列表（暂无用）
//参数：无参数
//请求地址：/appshipin/shiplistall?SHIPAll(混淆码)
#define kUrlShipListAll [NSString stringWithFormat:@"/appshipin/shiplistall?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPAll"]]
//10.获得类别下商品品牌列表
//参数：BRAND_ID 类型参数id
//请求地址：/appshipin/shipbrandiconlist?SHIPBRIC(混淆码)
#define kUrlShipBrandIconList [NSString stringWithFormat:@"/appshipin/shipbrandiconlist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPBRIC"]]
//11.获得商品类别列表
//参数：无参数
//请求地址：/appshipin/shipbrandlist?SHIPBR(混淆码)
#define kUrlShipBrandList [NSString stringWithFormat:@"/appshipin/shipbrandlist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPBR"]]
//12.尊购首页专区点击之后的列表（完成）
//参数：BRAND_ID 类型参数id
//(手表id:1b4ed4c57ef04933b97e8def48fc423a)
//(包袋id:a34d1f14a4b7481e8284ad4ba97a496b)
//(首饰id:2df2c7e628b14341be1e2932cb377c82)
//(豪车id:c387f598e5c64a1ea275a7ca3e77518c)
//(飞机游艇id:668b21fc68a44080899cfd840107af22)
//(家电数码id:a1d59672053f45e1a5499fb1d5850144)
//(高尔夫汇id：暂无)
//请求地址：/appshipin/shipprefecture?SHIPPRE(混淆码)
#define kUrlShipPrefecture [NSString stringWithFormat:@"/appshipin/shipprefecture?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPPRE"]]
//13.获得用户名下所有订单列表 （完成）
//参数：HONOURUSER_ID 用户id
//请求地址：/apporderin/orderalllist?ALLORDER(混淆码)
#define kUrlOrderAllList [NSString stringWithFormat:@"/apporderin/orderalllist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ALLORDER"]]
//14.获取用户名带条件查询的订单列表（待付款，待收货，待评价，已完成）（完成）
//参数：HONOURUSER_ID 用户id/CONORDER 查询状态
//（0040001）为待付款状态
//(0040002) 为待收货状态
//(0040003) 为待评价状态
//(0040004) 为已完成订单状态
//请求地址：/apporderin/orderconlist?CONORDER(混淆码)
#define kUrlOrderConList [NSString stringWithFormat:@"/apporderin/orderconlist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CONORDER"]]
//15.购物车列表 （完成）
//参数：HONOURUSER_ID 用户id
//请求地址：/apporderin/shoppingcart?SHOPPINGCART(混淆码)
#define kUrlShoppingCart [NSString stringWithFormat:@"/apporderin/shoppingcart?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHOPPINGCART"]]
//16.添加商品到购物车 （完成）
//参数: PRODUCT_ID 添加商品id/HONOURUSER_ID 当前用户id
//请求地址：/apporderin/shoppingcartadd?SHIPCARTADD(混淆码)
#define kUrlShoppingCartAdd [NSString stringWithFormat:@"/apporderin/shoppingcartadd?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPCARTADD"]]
//17.从购物车删除商品 （完成）
//参数：PRODUCT_ID 删除商品id/HONOURUSER_ID 当前用户id
//请求地址：/apporderin/shoppingcartdel?SHIPCARTDEL(混淆码)
#define kUrlShoppingCartDel [NSString stringWithFormat:@"/apporderin/shoppingcartdel?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPCARTDEL"]]
//18.生成订单接口（未产生交易）状态为待付款（购物车结算） （完成）
//参数：ORDERADDRESS 订单地址/ORDERMONEY 订单总金额/ORDERDELIVERY 配送方式（顺丰...）/HONOURUSER_ID         用户id/PRODUCT_ID 生成订单的商品id/PRODUCTCOUNT 商品数量
//请求地址：/apporderin/shiporder?SHIPORDER(混淆码)
#define kUrlShipOrder [NSString stringWithFormat:@"/apporderin/shiporder?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPORDER"]]
//19.订单状态修改（修改为待收货，待评价，已完成）
//参数：ORDERNUMBER 订单编号/HONOURUSER_ID 用户id/ORDERSTATUS 订单状态编码
//（0040001）为待付款状态
//(0040002) 为待收货状态
//(0040003) 为待评价状态
//(0040004) 为已完成订单状态
//请求地址：/apporderin/shiporderstaupd?SHIPORDERUPD(混淆码)
#define kUrlShipOrderStauPb [NSString stringWithFormat:@"/apporderin/shiporderstaupd?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPORDERUPD"]]
//20.尊购里模糊查询 （完成）
//参数：KEYWORDS 关键字
//请求地址：/appshipin/shipdimquery?SHIPDIMQ(混淆码)
#define kUrlShipDimQuery [NSString stringWithFormat:@"/appshipin/shipdimquery?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPDIMQ"]]
//21.炫购收藏列表 （完成）
//参数：HONOURUSER_ID 用户id
//请求地址：/appshipin/shipcollect?SHIPCOL(混淆码)
#define kUrlShipCollect [NSString stringWithFormat:@"/appshipin/shipcollect?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPCOL"]]
//22.添加商品到炫购收藏 （完成）
//参数：HONOURUSER_ID 用户id/PRODUCT_ID 商品id
//请求地址：/appshipin/shipcollectadd?SHIPCOLADD(混淆码)
#define kUrlShipCollectAdd [NSString stringWithFormat:@"/appshipin/shipcollectadd?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPCOLADD"]]
//23.从炫购收藏删除商品 （完成）
//参数：COLLECT_ID 炫购收藏id
//请求地址：/appshipin/shipcollectdel?SHIPCOLDEL(混淆码)
#define kUrlShipCollectDel [NSString stringWithFormat:@"/appshipin/shipcollectdel?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPCOLDEL"]]
//24.获得首页中美食分类列表（完成）
//参数：无参数
//请求地址：/appsfoodin/sfood?SORTFOOD(混淆码)
#define kUrlSFood [NSString stringWithFormat:@"/appsfoodin/sfood?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTFOOD"]]
//25.美食店铺添加评价
//参数：SORTFOOD_ID 店铺id/HONOURUSER_ID 评价用户id/EVALUATECONTENT 评价内容/EVALUATECOINT 评价分数
//请求地址：/appsfoodin/sfoodaddeva?SFOODADDEVA（混淆码）
#define kUrlSFoodAddEva [NSString stringWithFormat:@"/appsfoodin/sfoodaddeva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SFOODADDEVA"]]
//26.美食店铺综合评价分数（暂无用）
//参数：SORTFOOD_ID 需要查询的店铺id
//请求地址：/appsfoodin/sfoodmeaneva?SFOODMEANEVA(混淆码)
#define kUrlSFoodMeanEva [NSString stringWithFormat:@"/appsfoodin/sfoodmeaneva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SFOODMEANEVA"]]
//27.获得某家店铺评价数量（暂无用）
//参数：SORTFOOD_ID 需要查询的店铺id
//请求地址：/appsfoodin/sfoodcounteva?SFOODCOUNTEVA(混淆码)
#define kUrlSFoodCountEva [NSString stringWithFormat:@"/appsfoodin/sfoodcounteva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SFOODCOUNTEVA"]]
//28.获得某家店铺具体服务接口（暂无用）
//参数：SORTFOOD_ID 需要查询的店铺id
//请求地址：/appsfoodin/sfoodserv?SFOODSERV(混淆码)
#define kUrlSFoodServ [NSString stringWithFormat:@"/appsfoodin/sfoodserv?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SFOODSERV"]]
//29.获得所有私人定制列表接口 （完成）
//参数：无参数
//请求地址：/apppersonalin/personallist?PERSONAL(混淆码)
#define kUrlPersonalList [NSString stringWithFormat:@"/apppersonalin/personallist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PERSONAL"]]
//30.获取私人订制详情接口 （完成）
//参数：PERSONAL_ID 私人定制id
//请求地址：/apppersonalin/personaldet?PERSONALDET(混淆码)
#define kUrlPersonalDet [NSString stringWithFormat:@"/apppersonalin/personaldet?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PERSONALDET"]]
//31.根据条件获取火车票列表接口
//参数：from 始发站/to 终点站/date 出发日期/tt 是否为高铁动车（不打勾不需要传递，打勾需要传递’D’）
//请求地址：/apppersonalin/trainselect?TRAINSELECT(混淆码)
#define kUrlTrainSelect [NSString stringWithFormat:@"/apppersonalin/trainselect?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"TRAINSELECT"]]
//32.首页中获取所有特权接口（完成）
//参数：无参数
//请求地址：/apphomein/privilegelist?PRIVILIST(混淆码)
#define kUrlPrivilegelist [NSString stringWithFormat:@"/apphomein/privilegelist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PRIVILIST"]]
//33.首页中对应特权详情（仅马术，游艇，飞机，高尔夫，豪车）（暂无用）
//参数：PRIVILEGE_ID 特权id
//请求地址：/apphomein/privilegedet?PRIVIDET(混淆码)
#define kUrlPrivilegeDet [NSString stringWithFormat:@"/apphomein/privilegedet?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PRIVIDET"]]
//34.首页中新闻标题列表（完成）
//参数：暂无
//请求地址：/apphomein/getnewslist?NEWSLIST(混淆码)
#define kUrlGetNewsList [NSString stringWithFormat:@"/apphomein/getnewslist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"NEWSLIST"]]
//35.获取新闻详情(完成)
//参数：NEWS_ID 新闻id
//请求地址：/apphomein/getnewsdet?NEWSDET(混淆码)
#define kUrlGetNewsDet [NSString stringWithFormat:@"/apphomein/getnewsdet?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"NEWSDET"]]
//36.获取新闻所有评论（暂无用）
//参数：NEWS_ID 新闻id
//请求地址：/apphomein/getnewseva?NEWSEVA(混淆码)
#define kUrlGetNewsEva [NSString stringWithFormat:@"/apphomein/getnewseva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"NEWSEVA"]]
//37.添加新闻评论（暂无用）
//参数：NEWS_ID 评价新闻id/HONOURUSER_ID 评价用户id /NEWSEVACONTENT 评论内容
//请求地址：/apphomein/getnewsevaadd?NEWSEVAADD(混淆码)
#define kUrlGetNewsEvaAdd [NSString stringWithFormat:@"/apphomein/getnewsevaadd?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"NEWSEVAADD"]]
//38.获取汇聚列表接口 （完成）
//参数：无参数
//请求地址：/appconvergein/convergelist?CONVERGELIST(混淆码)
#define kUrlConvergeList [NSString stringWithFormat:@"/appconvergein/convergelist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CONVERGELIST"]]
//39.获得指定汇聚下所有聚会列表 （完成）
//参数：CONVERGE_ID 汇聚列表下汇聚id
//请求地址：/appconvergein/getpartylist?PARTYLIST(混淆码)
#define kUrlGetPartyList [NSString stringWithFormat:@"/appconvergein/getpartylist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PARTYLIST"]]
//40.查看指定聚会详情 （完成）
//参数：CONVERGEDETAIL_ID 指定聚会id
//请求地址：/appconvergein/getdetailbyid?DETAILID(混淆码)
#define kUrlGetDetaiByID [NSString stringWithFormat:@"/appconvergein/getdetailbyid?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"DETAILID"]]
//41.发布聚会 （完成）
//参数：STARTTIME 聚会开始时间/ENDTIME 聚会结束时间/PRICEMIN 期望价格最低值/PRICEMAX 期望价格最高值/
//CONVERGEPER 人数要求/CONVERGESEX 性别要求（0为女1为男2为不限）/AGEMIN 年龄要求下限/
//AGEMAX 年龄要求上限/CONVERGETYPE 聚会方式/CONVERGEDET 聚会详细要求/
//CONVERGETITLE 聚会标题/HONOURUSER_ID 发起人id
//请求地址：/appconvergein/adddetailparty?DETAILADD(混淆码)
#define kUrlAddDetailParty [NSString stringWithFormat:@"/appconvergein/adddetailparty?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"DETAILADD"]]
//42. 获得首页特权酒店分类列表 (完成)
//参数：SORTHOTEL_ID 酒店id
//请求地址：/appshotelin/shotel.do?SORTHOTEL（混淆码）
#define kUrlSHotelDo [NSString stringWithFormat:@"/appshotelin/shotel.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTHOTEL"]]
//43. 获得某家酒店的综合评价（暂时无用）
//参数：SORTHOTEL_ID 酒店id
//请求地址：/appshotelin/shotelmeaneva?SHOTELMEANEVA（混淆码）
#define kUrlSHotelMeanEva [NSString stringWithFormat:@"/appshotelin/shotelmeaneva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHOTELMEANEVA"]]
//44. 获得某家店铺的评价数量（暂时无用）
//参数：SORTHOTEL_ID酒店id
//请求地址：/appshotelin/shotelcounteva?SHOTELCOUNTEVA(混淆码)
#define kUrlSHotelCountEva [NSString stringWithFormat:@"/appshotelin/shotelcounteva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHOTELCOUNTEVA"]]
//45. 获得某家酒店的具体服务接口（暂时无用）
//参数：SHOP_ID 对应店铺id
//请求地址：/appshotelin/shotelserv?SHOTELSERV(混淆码)
#define kUrlSHotelServ [NSString stringWithFormat:@"/appshotelin/shotelserv?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHOTELSERV"]]
//46. 酒店店铺添加用户评价接口
//参数：SORTHOTEL_ID 所属店铺id/HONOURUSER_ID 评价用户id/EVALUATECONTENT 评价内容/EVALUATECOINT 评价分数
//请求地址：/appshotelin/shoteladdeva?SHOTELADDEVA(混淆码)
#define kUrlSHotelAddEva [NSString stringWithFormat:@"/appshotelin/shoteladdeva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHOTELADDEVA"]]
//47. 生成酒店订单接口（未产生交易）
//参数：ORDERUNAME 入住人姓名/ORDERPHONE 入住人手机号码/ORDERREMARK 订单备注/ORDERMONEY 订单价格/ORDERROOMNUM 预定酒店房间数量/ORDERCHECKDATE 入住日期/ORDERLEAVEDATE 离开日期
///ORDERDAYS 入住天数 /HOTELDETAIL_ID 预定房间类型id/HONOURUSER_ID 提交订单用户id
//请求地址：/appshotelin/shiphotelorder?SHIPHOTELORDER(混淆码)
#define kUrlShipHotlOrder [NSString stringWithFormat:@"/appshotelin/shiphotelorder?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPHOTELORDER"]]
//48. 修改酒店订单状态(改为支付成功,用户已支付)
//参数：ORDERSTATUS 订单状态编码/HONOURUSER_ID 提交订单的用户id /ORDERNUMBER 订单编号
//请求地址：/appshotelin/shiporderstaupd?SHIPHORELORDERUPD(混淆码)
#define kUrlShipOrderStauPd [NSString stringWithFormat:@"/appshotelin/shiporderstaupd?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPHORELORDERUPD"]]
//49.获得用户名下所有酒店订单列表 （完成）
//参数：HONOURUSER_ID 需要查询的用户id    /ORDERSTATUS
//（0040001）为待付款状态
//(0040002) 为待使用状态
//(0040003) 为待评价状态
//(0040004) 为已完成订单状态
//请求地址：/apphotelin/hotelorderalllist.do?ALLHOTELORDER(混淆码)
#define kUrlHotelOrderAllList [NSString stringWithFormat:@"/appshotelin/hotelorderalllist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ALLHOTELORDER"]]
//50. 获取某酒店详情列表（完成）
//参数：SORTHOTEL_ID 某酒店id
//请求地址：/appshotelin/hoteldetaillist?HOTELDETAIL(混淆码)
#define kUrlHotelDetailList [NSString stringWithFormat:@"/appshotelin/hoteldetaillist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"HOTELDETAIL"]]
//51. 获得某家KTV的综合评价（暂时无用）
//参数：SORTKTV_ID   KTV的id
//请求地址：/appsktvin/sktvmeaneva?SKTVMEANEVA（混淆码）
#define kUrlSKtvMeanEva [NSString stringWithFormat:@"/appsktvin/sktvmeaneva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SKTVMEANEVA"]]
//52. 获得某家KTV的评价数量（暂时无用）
//参数：SORTKTV_ID   KTV的id
//请求地址：/appsktvin/sktvcounteva?SKTVCOUNTEVA(混淆码)
#define kUrlSKtvMeanEva [NSString stringWithFormat:@"/appsktvin/sktvmeaneva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SKTVMEANEVA"]]
//53. 获得某家KTV的具体服务接口（暂时无用）
//参数：SHOP_ID 对应KTV的id
//请求地址：/appsktvin/sktvserv?SKTVSERV(混淆码)
#define kUrlSKtvServ [NSString stringWithFormat:@"/appsktvin/sktvserv?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SKTVSERV"]]
//54. KTV店铺添加用户评价接口
//参数：SORTKTV_ID 所属KTV的id/HONOURUSER_ID 评价用户id/EVALUATECONTENT 评价内容/EVALUATECOINT 评价分数
//请求地址：/appsktvin/sktvaddeva?SKTVADDEVA(混淆码)
#define kUrlSKtvAddEva [NSString stringWithFormat:@"/appsktvin/sktvaddeva?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SKTVADDEVA"]]
//55. 生成KTV订单接口（未产生交易）
//参数：ORDERUNAME 入住人姓名/ORDERPHONE 入住人手机号码/ORDERREMARK 订单备注/ORDERMONEY 订单价格/ORDERROOMNUM 预定KTV房间数量/ORDERROOMBEGIN 包厢开始时间/ORDERROOMEND 包厢结束时间
///KTVDETAIL_ID 所关联的KTV包厢id/HONOURUSER_ID 提交订单用户id
//请求地址：/appsktvin/shipktvorder?SHIPKTVORDER(混淆码)
#define kUrlShipKtvOrder [NSString stringWithFormat:@"/appsktvin/shipktvorder?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPKTVORDER"]]
//56. 修改KTV订单状态(改为支付成功,用户已支付)
//参数：ORDERSTATUS 订单状态编码/HONOURUSER_ID 提交订单的用户id /ORDERNUMBER 订单编号
//请求地址：/appsktvin/shipktvstaupd?SHIPKTVORDERUPD(混淆码)
#define kUrlShipKtvStauPd [NSString stringWithFormat:@"/appsktvin/shipktvstaupd?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPKTVORDERUPD"]]
//57 获得用户名下所有KTV订单列表 （完成）
//参数：HONOURUSER_ID 需要查询的用户id
//请求地址：/appsktvin/ktvorderalllist?ALLKTVORDER(混淆码)
#define kUrlKtvOrderAllList [NSString stringWithFormat:@"/appsktvin/ktvorderalllist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ALLKTVORDER"]]
//58. 获取某KTV详情列表(完成)
//参数：SORTKTV_ID 某KTVid
//请求地址：/appsktvin/ktvdetaillist?KTVDETAIL(混淆码)
#define kUrlKtvDetailList [NSString stringWithFormat:@"/appsktvin/ktvdetaillist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"KTVDETAIL"]]
//59. 根据状态获取轮播图 （完成）
//参数：无
//请求地址：/appshipin/scarouselfigure?SCAROUSELFIGURE(混淆码)
#define kUrlScarouselfigure [NSString stringWithFormat:@"/appshipin/scarouselfigure?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SCAROUSELFIGURE"]]
//60.根据酒店id获取酒店综合详细（完成）
//参数：SORTHOTEL_ID 某酒店id
//请求地址：/appshotelin/hotelsyn?HOTELSYN（混淆码）
#define kUrlHotelSyn [NSString stringWithFormat:@"/appshotelin/hotelsyn?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"HOTELSYN"]]
//61.根据美食店铺id获取美食店铺综合详细（完成）
//参数：SORTFOOD_ID 某美食店铺id
//请求地址：/appsfoodin/foodsyn?SFOODSYN（混淆码）
#define kUrlFoodSyn [NSString stringWithFormat:@"/appsfoodin/foodsyn?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SFOODSYN"]]
//62.根据KTVid获取KTV店铺综合详细（完成）
//参数：SORTKTV_ID 某KTVid
//请求地址：/appsktvin/ktvsyn?KTVSYN（混淆码）
#define kUrlKtvSyn [NSString stringWithFormat:@"/appsktvin/ktvsyn?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"KTVSYN"]]
//63. 获得引导页列表（完成）
//参数：无
//请求地址：/appbootpagein/bootpagelist?BOOTPAGELIST(混淆码)
#define kUrlBootPageList [NSString stringWithFormat:@"/appbootpagein/bootpagelist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"BOOTPAGELIST"]]
//64. 获得首页荣耀服务列表（完成）
//参数：无
//请求地址：/appserverin/server.do?SERVER(混淆码)
#define kUrlServerDo [NSString stringWithFormat:@"/appserverin/server.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SERVER"]]
//65. 获取荣耀服务详情列表（完成）
//参数：SERVER_ID 某荣耀服务id
//请求地址：/appserverin/serverdetaillist.do?SERVERDETAIL(混淆码)
#define kUrlServerDetailList [NSString stringWithFormat:@"/appserverin/serverdetaillist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SERVERDETAIL"]]
//66.获得某酒店评论列表 （完成）
//参数：SORTHOTEL_ID 某酒店id
//请求地址：/appshotelin/hotelevalist?HOTELEVA
//返回参数：EVALUATEDATE 	评价日期/EVALUATECONTENT 评价内容/PORTRAIT 用户头像/NICKNAME 用户昵称
#define kUrlHotelEvaList [NSString stringWithFormat:@"/appshotelin/hotelevalist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"HOTELEVA"]]
//67.获得某美食店铺评论列表(完成)
//参数：SORTFOOD_ID 某美食店铺id
//请求地址：/appsfoodin/foodevalist?FOODEVA
//返回参数：EVALUATEDATE 	评价日期/EVALUATECONTENT 评价内容/PORTRAIT 用户头像/NICKNAME 用户昵称
#define kUrlFoodEvaList [NSString stringWithFormat:@"/appsfoodin/foodevalist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"FOODEVA"]]

//68.获得KTV店铺评论列表（完成）
//参数：SORTKTV_ID 某KTVid
//请求地址：/appsktvin/ktvevalist?KTVEVA
//返回参数：EVALUATEDATE 	评价日期/EVALUATECONTENT 评价内容/PORTRAIT 用户头像/NICKNAME 用户昵称
#define kUrlKtvEvaList [NSString stringWithFormat:@"/appsktvin/ktvevalist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"KTVEVA"]]

//69.获得酒吧店铺评论列表(完成)
//参数：SORTBAR_ID 某酒吧id
//请求地址：/appsbarin/barevalist?BAREVA
//返回参数：EVALUATEDATE     评价日期/EVALUATECONTENT 评价内容/PORTRAIT 用户头像/NICKNAME 用户昵称
#define kUrlBarevaList [NSString stringWithFormat:@"/appsbarin/barevalist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"BAREVA"]]

//70.用户上传头像的方法 （完成）
//参数：HONOURUSER_ID 上传头像人员id
//请求地址：/appuserin/up?UPPORT
#define kUrlUp [NSString stringWithFormat:@"/appuserin/up?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"UPPORT"]]





//71. 获得某家酒吧的综合评价（暂时无用）
//参数：SORTBAR_ID   酒吧的id
//请求地址：/appsbarin/getbarmeaneva.do?GETBARMEANEVA（混淆码）
#define kUrlGetBarmeanEva [NSString stringWithFormat:@"/appsbarin/getbarmeaneva.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"GETBARMEANEVA"]]
//72. 获得某家酒吧的评价数量 （暂时无用）
//参数：SORTBAR_ID   BAR的id
//请求地址：/appsbarin/getbarcounteva.do?GETBARCOUNTEVA(混淆码)
#define kUrlGetBarcountEva [NSString stringWithFormat:@"/appsbarin/getbarcounteva.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"GETBARCOUNTEVA"]]
//73. 获得某家酒吧的具体服务接口（暂时无用）
//参数：SHOP_ID 对应酒吧的id
//请求地址：/appsbarin/sbarserv.do?SBARSERV(混淆码)
#define kUrlSBarServ [NSString stringWithFormat:@"/appsbarin/sbarserv.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SBARSERV"]]
//74. 酒吧店铺添加用户评价接口
//参数：SORTBAR_ID 所属酒吧的id/HONOURUSER_ID 评价用户id/EVALUATECONTENT 评价内容/EVALUATECOINT 评价分数/ISSHOW  是否匿名显示昵称0为显示1为匿名
//请求地址：/appsbarin/addbareva.do?ADDBAREVA(混淆码)
#define kUrlAddBarEva [NSString stringWithFormat:@"/appsbarin/addbareva.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ADDBAREVA"]]
//75. 生成酒吧订单接口（未产生交易）
//参数：ORDERUNAME 入住人姓名/ORDERPHONE 入住人手机号码/ORDERREMARK 订单备注/ORDERMONEY 订单价格/ORDERROOMNUM 预定BAR套餐数量/ORDERROOMBEGIN 开始时间/ORDERROOMEND 结束时间
///BARDETAIL_ID 所关联的BAR套餐id/HONOURUSER_ID 提交订单用户id
//请求地址：/appsbarin/addbarorder.do?ADDBARORDER(混淆码)
#define kUrlAddBarOrder [NSString stringWithFormat:@"/appsbarin/addbarorder.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ADDBARORDER"]]
//76. 修改酒吧订单状态(改为支付成功,用户已支付)
//参数：ORDERSTATUS 订单状态编码/HONOURUSER_ID 提交订单的用户id /ORDERNUMBER 订单编号
//请求地址：/appsbarin/updbarstaupd.do?&UPDBARORDERUPD(混淆码)
#define kUrlUpdBarStauPd [NSString stringWithFormat:@"/appsbarin/updbarstaupd.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"UPDBARORDERUPD"]]
//77.获得用户名下所有酒吧订单列表 （完成）
//参数：HONOURUSER_ID 需要查询的用户id  /ORDERSTATUS
//（0040001）为待付款状态
//(0040002) 为待使用状态
//(0040003) 为待评价状态
//(0040004) 为已完成订单状态
//请求地址：/appsbarin/barorderalllist.do?ALLBARORDER(混淆码)
#define kUrlBarorderAllList [NSString stringWithFormat:@"/appsbarin/barorderalllist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ALLBARORDER"]]
//78. 获取某酒吧详情列表
//参数：SORTBAR_ID 某BAR id
//请求地址：/appsbarin/bardetaillist.do?BARDETAIL(混淆码)
#define kUrlBarDetailList [NSString stringWithFormat:@"/appsbarin/bardetaillist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"BARDETAIL"]]
//79. 获得首页特权酒吧店铺列表（完成）
//请求地址：/appsbarin/sbar.do?SORTBAR(混淆码)
#define kUrlSBar [NSString stringWithFormat:@"/appsbarin/sbar.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTBAR"]]

//80. 获得首页汇聚玩趴图片 （完成）
//参数：无参数
//请求地址：/apphomein/partyimg.do?PARTY(混淆码)
#define kUrlPartyimg [NSString stringWithFormat:@"/apphomein/partyimg.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PARTY"]]


//81. 根据酒吧店铺id获取美食店铺综合详细(完成)
//参数：SORTBAR_ID 酒吧id
//请求地址：/appsbarin/barsyn.do?BARSYN(混淆码)
#define kUrlBarSyn [NSString stringWithFormat:@"/appsbarin/barsyn.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"BARSYN"]]


//82. 获得荣耀服务高尔夫列表（完成）
//参数：HONOURUSER_ID 用户id
//请求地址：/appserverin/sgolflist.do?SORTHIGHGOLF(混淆码)
#define kUrlSGolflist [NSString stringWithFormat:@"/appserverin/sgolflist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTHIGHGOLF"]]
//83. 获得荣耀服务马术列表（完成）
//参数：HONOURUSER_ID 用户id
//请求地址：/appserverin/shorselist.do?SORTHIGHHORSE(混淆码)
#define kUrlSHorseList [NSString stringWithFormat:@"/appserverin/shorselist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTHIGHHORSE"]]

//84. 获得荣耀服务豪车列表（完成）
//参数：HONOURUSER_ID 用户id
//请求地址：/appserverin/sluxcarlist.do?SORTHIGHLUXCAR(混淆码)
#define kUrlSLuxcarlist [NSString stringWithFormat:@"/appserverin/sluxcarlist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTHIGHLUXCAR"]]

//86. 获得荣耀服务游艇列表（完成）
//参数：HONOURUSER_ID 用户id
//请求地址：/appserverin/syachtlist.do?SORTHIGHYACHT(混淆码)
#define kUrlSYachtlist [NSString stringWithFormat:@"/appserverin/syachtlist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTHIGHYACHT"]]


//87. 获取高尔夫详情接口（完成）
//参数：GOLFSHOP_ID 高尔夫店id
//请求地址：/appserverin/golfdetail.do?GOLFDETAIL(混淆码)
#define kUrlGolfDetail [NSString stringWithFormat:@"/appserverin/golfdetail.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"GOLFDETAIL"]]

//88. 获取马术详情接口（完成）
//参数：HORSESHOP_ID   马术店id
//请求地址：/appserverin/horsedetail.do?HORSEDETAIL(混淆码)
#define kUrlHorseDetail [NSString stringWithFormat:@"/appserverin/horsedetail.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"HORSEDETAIL"]]

//89. 获取豪车详情接口（完成）
//参数：LUXCARSHOP_ID   豪车店id
//请求地址：/appserverin/luxcardetail.do?LUXCARDETAIL(混淆码)
#define kUrlLuxcarDetail [NSString stringWithFormat:@"/appserverin/luxcardetail.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"LUXCARDETAIL"]]

//90. 获取飞机详情接口(完成)
//参数：无
//请求地址：/appserverin/planedetail.do?HORSEDETAIL(混淆码)
#define kUrlPlaneDetail [NSString stringWithFormat:@"/appserverin/planedetail.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"HORSEDETAIL"]]

//91. 获得服务游艇接口（完成）
//参数：YACHTSHOP_ID  游艇id
//请求地址：/appserverin/yachtdetail.do?YACHTDETAIL(混淆码)
#define kUrlYachtDetail [NSString stringWithFormat:@"/appserverin/yachtdetail.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"YACHTDETAIL"]]

//92. 获得首页特权KTV分类列表（完成）
//参数：HONOURUSER_ID 用户id
//请求地址：/appsktvin/sktv.do?SORTKTV(混淆码)
#define kUrlSktvlist [NSString stringWithFormat:@"/appsktvin/sktv.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTKTV"]]
//93. 随机产生酒店列表
//参数：HONOURUSER_ID 用户id
//请求地址：/appshotelin/shotellistrand.do?SORTHOTELRAND(混淆码)
#define kUrlSHotelListRand [NSString stringWithFormat:@"/appshotelin/shotellistrand.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTHOTELRAND"]]
//94. 随机产生KTV列表
//参数：HONOURUSER_ID 用户id
//请求地址：/appsktvin/sktvlistrand.do?SORTKTVRAND(混淆码)
#define kUrlSKtvListRand [NSString stringWithFormat:@"/appsktvin/sktvlistrand.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTKTVRAND"]]
//95. 随机产生酒吧列表
//参数：HONOURUSER_ID 用户id
//请求地址：/appsbarin/sbarlistrand.do?SORTBARRAND(混淆码)
#define kUrlSBarListRand [NSString stringWithFormat:@"/appsbarin/sbarlistrand.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTBARRAND"]]
//96. 随机产生美食店铺列表(完成)
//参数：HONOURUSER_ID 用户id
//请求地址：/appsfoodin/sfoodlistrand.do?SORTFOODRAND(混淆码)
#define kUrlSfoodlistrand [NSString stringWithFormat:@"/appsfoodin/sfoodlistrand.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTFOODRAND"]]
//97. 根据美食评价分数，价格，距离,品牌,类型升序或者降序排序
//参数：HONOURUSER_ID 用户id   /COLUMN 排序字段（SHOPPRICE,SHOPEVALUATE）  /SEQUENCE  升序ASC降序DESC
//BRAND  品牌   /STYLE  类型
//请求地址：//appsfoodin/sfoodlistsequence.do?SORTFOODSEQUENCE
#define kUrlSFoodListSequence [NSString stringWithFormat:@"/appsfoodin/sfoodlistsequence.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTFOODSEQUENCE"]]
//97. 获取首页推荐荣耀音乐列表（完成）
//参数：无参数
//请求地址：/appmusicin/musicreclist.do?MUSICLIST(混淆码)
#define kUrlMusicreclist [NSString stringWithFormat:@"/appmusicin/musicreclist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"MUSICLIST"]]
//98. 根据酒店评价分数，价格，距离,品牌,类型升序或者降序排序
//参数：HONOURUSER_ID 用户id   /COLUMN 排序字段（HOTELPRICE,HOTELEVALUATE）  /SEQUENCE  升序ASC降序DESC
//BRAND  品牌   /STYLE  类型
//请求地址：/appshotelin/shotellistsequence.do?SORTHOTELSEQUENCE(混淆码)
#define kUrlSHotelListSequence [NSString stringWithFormat:@"/appshotelin/shotellistsequence.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTHOTELSEQUENCE"]]
//99. 根据KTV评价分数，价格，距离,品牌,类型升序或者降序排序
//参数：HONOURUSER_ID 用户id   /COLUMN 排序字段（KTVPRICE,KTVEVALUATE）  /SEQUENCE  升序ASC降序DESC
//BRAND  品牌   /STYLE  类型
//请求地址：/appsktvin/sktvlistsequence.do?SORTKTVSEQUENCE(混淆码)
#define kUrlSKtvListSequence [NSString stringWithFormat:@"/appsktvin/sktvlistsequence.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTKTVSEQUENCE"]]
//100. 根据酒吧评价分数，价格，距离,品牌,类型升序或者降序排序
//参数：HONOURUSER_ID 用户id   /COLUMN 排序字段（BARPRICE,BAREVALUATE）  /SEQUENCE  升序ASC降序DESC
//BRAND  品牌   /STYLE  类型
//请求地址：/appsbarin/sbarlistsequence.do?SORTBARSEQUENCE(混淆码)
#define kUrlSbarListSequence [NSString stringWithFormat:@"/appsbarin/sbarlistsequence.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTBARSEQUENCE"]]

//101. 首页杂志(完成)
//参数：无
//请求地址：/apphomein/magazinelist?MAGAZINE(混淆码)
#define kUrlMagazineList [NSString stringWithFormat:@"/apphomein/magazinelist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"MAGAZINE"]]

//102.获得美食套餐页列表 FOODDETAIL（完成）
//http://localhost:8081/ZSHINTER//appsfoodin/fooddetaillist.do?FOODDETAIL&SORTFOOD_ID=382585520535896064
#define kUrlFoodDetailList [NSString stringWithFormat:@"/appsfoodin/fooddetaillist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"FOODDETAIL"]]

//103.生成美食订单接口（未产生交易）SHIPFOODORDER
//http://localhost:8081/ZSHINTER//appsfoodin/shipfoodorder.do?SHIPFOODORDER&ORDERUNAME=yu&ORDERPHONE=17601680524&ORDERREMARK=不要辣&ORDERMONEY=136&ORDERROOMNUM=1&ORDERCHECKDATE=2017-8-14&ORDERLEAVEDATE=2017-8-14&FOODDETAIL_ID=387192633518194688&HONOURUSER_ID=d6a3779de8204dfd9359403f54f7d27c
//#define kUrlShipFoodOrdert [NSString stringWithFormat:@"/appsfoodin/shipfoodorder.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPFOODORDER"]]

//104. 修改美食订单状态(改为支付成功,用户带使用0040002)
//参数：ORDERSTATUS 订单状态编码/HONOURUSER_ID 提交订单的用户id /ORDERNUMBER 订单编号
//请求地址：/appsfoodin/shiporderstaupd.do?SHIPFOODORDERUPD(混淆码)


//105.获得用户名下所有美食订单列表     ALLFOODORDER
//http://localhost:8081/ZSHINTER//appsfoodin/foodorderalllist.do?ALLFOODORDER&HONOURUSER_ID=d6a3779de8204dfd9359403f54f7d27c&ORDERSTATUS=0040001



#endif /* URLMacros_h */
