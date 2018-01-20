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

#ifdef DEBUG

#define DevelopSever    1
#define TestSever       0
#define ProductSever    0

#else

#define ProductSever    1

#endif


#if DevelopSever

/**开发服务器*/

#define kUrlRoot                    @"http://192.168.1.135:8081/ZSHINTER/"   // 洪磊


#elif TestSever

/**测试服务器*/
#define kUrlRoot                    @"http://192.168.1.125:8081/ZSHINTER/"   // 振华

#elif ProductSever

/**生产服务器（阿里云）*/
#define kUrlRoot                    @"http://inter.rongyaohk.com/"


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
// 3用户登录 (完成)
//  手机号登录
//  参数：PHONE 手机号 (暂无用)
#define kUrlUserLoginPhone [NSString stringWithFormat:@"/appuserin/userloginphone?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"LOGIN"]]
//  卡密登录 （完成）
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
//10.获得类别下商品品牌列表 （完成）
//参数：BRAND_ID 类型参数id
//请求地址：/appshipin/shipbrandiconlist?SHIPBRIC(混淆码)
#define kUrlShipBrandIconList [NSString stringWithFormat:@"/appshipin/shipbrandiconlist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPBRIC"]]
//11.获得商品类别列表（完成）
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
//78. 获取某酒吧详情列表(完成)
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
//93. 随机产生酒店列表（完成）
//参数：HONOURUSER_ID 用户id
//请求地址：/appshotelin/shotellistrand.do?SORTHOTELRAND(混淆码)
#define kUrlSHotelListRand [NSString stringWithFormat:@"/appshotelin/shotellistrand.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTHOTELRAND"]]
//94. 随机产生KTV列表(完成)
//参数：HONOURUSER_ID 用户id
//请求地址：/appsktvin/sktvlistrand.do?SORTKTVRAND(混淆码)
#define kUrlSKtvListRand [NSString stringWithFormat:@"/appsktvin/sktvlistrand.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTKTVRAND"]]
//95. 随机产生酒吧列表（完成）
//参数：HONOURUSER_ID 用户id
//请求地址：/appsbarin/sbarlistrand.do?SORTBARRAND(混淆码)
#define kUrlSBarListRand [NSString stringWithFormat:@"/appsbarin/sbarlistrand.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTBARRAND"]]
//96. 随机产生美食店铺列表(完成)
//参数：HONOURUSER_ID 用户id
//请求地址：/appsfoodin/sfoodlistrand.do?SORTFOODRAND(混淆码)
#define kUrlSfoodlistRand [NSString stringWithFormat:@"/appsfoodin/sfoodlistrand.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTFOODRAND"]]
//97. 根据美食评价分数，价格，距离,品牌,类型升序或者降序排序(完成)
//参数：HONOURUSER_ID 用户id   /COLUMN 排序字段（SHOPPRICE,SHOPEVALUATE）  /SEQUENCE  升序ASC降序DESC
//BRAND  品牌   /STYLE  类型
//请求地址：//appsfoodin/sfoodlistsequence.do?SORTFOODSEQUENCE
#define kUrlSFoodListSequence [NSString stringWithFormat:@"/appsfoodin/sfoodlistsequence.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTFOODSEQUENCE"]]
//97. 获取首页推荐荣耀音乐列表（完成）
//参数：无参数
//请求地址：/appmusicin/musicreclist.do?MUSICLIST(混淆码)
#define kUrlMusicreclist [NSString stringWithFormat:@"/appmusicin/musicreclist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"MUSICLIST"]]
//98. 根据酒店评价分数，价格，距离,品牌,类型升序或者降序排序（完成）
//参数：HONOURUSER_ID 用户id   /COLUMN 排序字段（HOTELPRICE,HOTELEVALUATE）  /SEQUENCE  升序ASC降序DESC
//BRAND  品牌   /STYLE  类型
//请求地址：/appshotelin/shotellistsequence.do?SORTHOTELSEQUENCE(混淆码)
#define kUrlSHotelListSequence [NSString stringWithFormat:@"/appshotelin/shotellistsequence.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTHOTELSEQUENCE"]]
//99. 根据KTV评价分数，价格，距离,品牌,类型升序或者降序排序(完成)
//参数：HONOURUSER_ID 用户id   /COLUMN 排序字段（KTVPRICE,KTVEVALUATE）  /SEQUENCE  升序ASC降序DESC
//BRAND  品牌   /STYLE  类型
//请求地址：/appsktvin/sktvlistsequence.do?SORTKTVSEQUENCE(混淆码)
#define kUrlSKtvListSequence [NSString stringWithFormat:@"/appsktvin/sktvlistsequence.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTKTVSEQUENCE"]]
//100. 根据酒吧评价分数，价格，距离,品牌,类型升序或者降序排序(完成)
//参数：HONOURUSER_ID 用户id   /COLUMN 排序字段（BARPRICE,BAREVALUATE）  /SEQUENCE  升序ASC降序DESC
//BRAND  品牌   /STYLE  类型
//请求地址：/appsbarin/sbarlistsequence.do?SORTBARSEQUENCE(混淆码)
#define kUrlSbarListSequence [NSString stringWithFormat:@"/appsbarin/sbarlistsequence.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SORTBARSEQUENCE"]]
//101. 首页杂志（完成）(删除 108新增)
//参数：无
//请求地址：/apphomein/magazinelist?MAGAZINE(混淆码)
//#define kUrlMagazineList [NSString stringWithFormat:@"/apphomein/magazinelist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"MAGAZINE"]]
//102. 获得美食套餐页列表（完成）
//参数：SORTFOOD_ID  所属美食店铺ID
//请求地址：/appsfoodin/fooddetaillist.do?FOODDETAIL(混淆码)
#define kUrlFoodDetailList [NSString stringWithFormat:@"/appsfoodin/fooddetaillist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"FOODDETAIL"]]
//103. 生成美食订单接口（未产生交易）
//参数：ORDERUNAME 入住人姓名/ORDERPHONE 入住人手机号码/ORDERREMARK 订单备注/ORDERMONEY 订单价格/ORDERROOMNUM 套餐数量/ORDERROOMBEGIN 开始时间/ORDERROOMEND 结束时间
///BARDETAIL_ID 所关联的套餐id/HONOURUSER_ID 提交订单用户id
//请求地址：/appsfoodin/shipfoodorder.do?SHIPFOODORDER(混淆码)
#define kUrlShipFoodOrder [NSString stringWithFormat:@"/appsfoodin/shipfoodorder.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPFOODORDER"]]
//104. 修改美食订单状态(改为支付成功,用户带使用0040002)
//参数：ORDERSTATUS 订单状态编码/HONOURUSER_ID 提交订单的用户id /ORDERNUMBER 订单编号
//请求地址：/appsfoodin/shiporderstaupd.do?SHIPFOODORDERUPD(混淆码)
#define kUrlShipOrderStaupd [NSString stringWithFormat:@"/appsfoodin/shiporderstaupd.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPFOODORDERUPD"]]
//105.获得用户名下所有美食订单列表 （完成）
//参数：HONOURUSER_ID 需要查询的用户id  /ORDERSTATUS
//（0040001）为待付款状态
//(0040002) 为待使用状态
//(0040003) 为待评价状态
//(0040004) 为已完成订单状态
//请求地址：/appsfoodin/foodorderalllist.do?ALLFOODORDER(混淆码)
#define kUrlFoodOrderAllList [NSString stringWithFormat:@"/appsfoodin/foodorderalllist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ALLFOODORDER"]]
//106. 用户参加别人发起的聚会(添加聚会)（完成）
//参数：CONVERGEDETAIL_ID    聚会详情ID/          HONOURUSER_ID 用户id
//请求地址：/appconvergein/addotherparty.do?OTHRERPARTYADD(混淆码)
#define kUrlAddOtherParty [NSString stringWithFormat:@"/appconvergein/addotherparty.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"OTHRERPARTYADD"]]

//107.添加关注（加好友功能）(完成)
//参数：HONOURUSER_ID 关注人ID/        REHONOURUSER_ID 被关注人ID
//请求地址：/appfriendin/addfriend?FRIENDADD(混淆码)
#define kUrlAddFriend [NSString stringWithFormat:@"/appfriendin/addfriend?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"FRIENDADD"]]
//108.获得首页荣耀杂志推荐接口
//参数：无
//请求地址：/apphomein/magazinelist?MAGAZINE(混淆码)
#define kUrlMagazineList [NSString stringWithFormat:@"/apphomein/magazinelist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"MAGAZINE"]]
//109.获取我关注的好友的列表接口（完成）
//参数：HONOURUSER_ID  查询的用户Id
//请求地址：/appfriendin/friendlist?FLIST (混淆码)
#define kUrlFriendList [NSString stringWithFormat:@"/appfriendin/friendlist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"FLIST"]]
//110.获取关注我的好友的列表接口（完成）
//参数：HONOURUSER_ID  查询的用户Id
//请求地址：/appfriendin/refriendlist?REFLIST(混淆码)
#define kUrlRefriendList [NSString stringWithFormat:@"/appfriendin/refriendlist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"REFLIST"]]
//111.删除我关注的好友接口（取消关注）（完成）
//参数：HONOURUSER_ID 当前登录用户Id/    REHONOURUSER_ID  被取消用户Id
//请求地址：/appfriendin/delfriend?FRIENDDEL(混淆码)
#define kUrlDelFriend [NSString stringWithFormat:@"/appfriendin/delfriend?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"FRIENDDEL"]]
//112.获取发现中所有的菜单项(完成)
//参数：无
//请求地址：/appdiscoverin/caidan.do?CAIDAN(混淆码)
#define kUrlCaidan [NSString stringWithFormat:@"/appdiscoverin/caidan.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CAIDAN"]]
//113.根据发现菜单ID获取视频和图片（完成）
//参数：CAIDAN_ID 所属的菜单Id
//请求地址：/appdiscoverin/discoverlist.do?DISCOVERLIST(混淆码)
#define kUrlDiscoverList [NSString stringWithFormat:@"/appdiscoverin/discoverlist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"DISCOVERLIST"]]
//114.查询所有美食,酒店,KTV,酒吧品牌或者类型
//参数：TYPE  (0代表品牌，1代表筛选)          SORTNAME  (0代表美食，1酒店，2KTV，3酒吧)
//请求地址：/appsfoodin/brandstylelist.do?BRANDLIST(混淆码)
#define kUrlBrandstyleList [NSString stringWithFormat:@"/appsfoodin/brandstylelist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"BRANDLIST"]]
//115.发布内容到我的圈子 （完成）
//参数：HONOURUSER_ID 用户的Id/    CONTENT   发布的内容/    SHOWIMAGES  上传的图片（参数可选）
//请求地址：/appcirclein/addcircle.do?CIRCLEADD(混淆码)
#define kUrlAddCircle [NSString stringWithFormat:@"/appcirclein/addcircle.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CIRCLEADD"]]
//116.获取我和我关注的好友的所有圈子并根据时间排序 (完成)
//参数：HONOURUSER_ID 用户的Id
//请求地址：/appcirclein/circlelist.do?CIRCLELIST(混淆码)
#define kUrlCircleList [NSString stringWithFormat:@"/appcirclein/circlelist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CIRCLELIST"]]

//107. 电台列表(完成)
//请求地址：/ZSHINTER/appmusicin/getcategorylist?CATELIST(混淆码)
#define kUrlRadioStation [NSString stringWithFormat:@"/appmusicin/getcategorylist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CATELIST"]]
//107. 获取某个电台下的歌曲列表接口（完成）
//请求地址： /appmusicin/getchannelsong?CANNELSONG
//参数:ch_name 电台名称
#define kUrlChannelSong [NSString stringWithFormat:@"/appmusicin/getchannelsong?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CANNELSONG"]]
//108. 获取歌曲详细接口（完成）
//请求地址： /appmusicin/getsongplay?SONGPLAY
//参数:songid 歌曲id
#define kUrlSongPlay [NSString stringWithFormat:@"/appmusicin/getsongplay?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SONGPLAY"]]
//@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.song.getInfos&format=json&songid=8059247&ts=1408284347323&e=JoN56kTXnnbEpd9MVczkYJCSx%2FE1mkLx%2BPMIkTcOEu4%3D&nw=2&ucf=1&res=1"
//[NSString stringWithFormat:@"/appmusicin/getsongplay?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SONGPLAY"]]
//110:获得所有模糊查询的歌曲列表接口
//请求地址： /appmusicin/getsearchsong?SEARCHSONG
//参数:query  查询字段
#define kUrlSearchSong [NSString stringWithFormat:@"/appmusicin/getchannelsong?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SEARCHSONG"]]
//111:获得音乐排行榜列表接口（完成）
//请求地址： /appmusicin/getbilllist?BILLLIST
// 参数:type  类型(1-新歌榜,2-热歌榜,6-KTV热歌榜,8-Hito中文榜,11-摇滚榜,12-爵士,16-流行,21-欧美金 曲榜,22-经典老歌榜,23-情歌对唱榜,24-影视金曲榜,25-网络歌曲榜) offset偏移数(页码)
#define kUrlBillList [NSString stringWithFormat:@"/appmusicin/getbilllist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"BILLLIST"]]
//@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.billboard.billList&type=1&size=10&offset=0"
//[NSString stringWithFormat:@"/appmusicin/getbilllist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"BILLLIST"]]

//113:每日推荐歌曲(固定10首)   appmusicin/getrecommandsonglist?SONGLIST
#define kUrlSongList [NSString stringWithFormat:@"appmusicin/getrecommandsonglist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SONGLIST"]]
//@"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=baidu.ting.song.getRecommandSongList&song_id=877578&num=10"
//114:歌手列表
//参数：参数：offset 偏移数(页码)
//地址：/appmusicin/gethotartist?HOTARTIST
#define kUrlSingerList [NSString stringWithFormat:@"/appmusicin/gethotartist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"HOTARTIST"]]
//115.通过歌手id获取其所有歌曲列表接口
//参数：tinguid 歌手id  offset 偏移数(页码)
//地址：/appmusicin/getsonglist?SONGLIST
#define kUrlSingerSongList  [NSString stringWithFormat:@"/appmusicin/getsonglist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SONGLIST"]]
//116
//参数：
//
#define kUrlBillListall [NSString stringWithFormat:@"/appmusicin/getbilllistall?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"BILLLIST"]]
//117.点赞(完成)
//参数：HONOURUSER_ID 用户的Id    /CIRCLE_ID  所评论的圈子ID
//请求地址：/appcirclein/dotAgree.do?DOTAGREE(混淆码)
#define kUrlDotAgree [NSString stringWithFormat:@"/appcirclein/dotAgree.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"DOTAGREE"]]
//118.添加评论到用户圈子（完成）
//参数：HONOURUSER_ID 用户的Id    /CIRCLE_ID  所评论的圈子ID    /COMCONTENT   评论内容 /REPLYHONOURUSER_ID 回复用户的Id
//请求地址：/appcirclein/addcomment.do?COMMENTADD(混淆码)
#define kUrlAddComment [NSString stringWithFormat:@"/appcirclein/addcomment.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"COMMENTADD"]]
//119.通过圈子ID获取所有评论（完成）
//参数：/CIRCLE_ID  所评论的圈子ID
//请求地址：/appcirclein/commentlist.do?COMMENTLIST(混淆码)
#define kUrlCommentList [NSString stringWithFormat:@"/appcirclein/commentlist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"COMMENTLIST"]]
//120.获取所有电台
//参数：无
//请求地址：/appmusicin/getcategorylist?CATELIST(混淆码)
#define kUrlGetCategoryList [NSString stringWithFormat:@"/appmusicin/getcategorylist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CATELIST"]]
//121.根据电台名称获取频道列表
//参数：ch_name   电台名称
//请求地址：/appmusicin/getchannelsong?CANNELSONG(混淆码)
#define kUrlGetChannelSong [NSString stringWithFormat:@"/appmusicin/getchannelsong?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CANNELSONG"]]
//122.获取歌曲详细接口
//参数：songid 歌曲id
//请求地址：/appmusicin/getsongplay?SONGPLAY(混淆码)
#define kUrlGetSongPlay [NSString stringWithFormat:@"/appmusicin/getsongplay?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SONGPLAY"]]
//123.获得所有模糊查询的歌曲列表接口
//参数：query  查询字段
//请求地址：/appmusicin/getsearchsong?SEARCHSONG  (混淆码)
#define kUrlGetSearchSong [NSString stringWithFormat:@"/appmusicin/getsearchsong?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SONGPLAY"]]
//124.修改用户个人资料 （完成）
//参数：HONOURUSER_ID 用户的Id  /
//以下参数可选： ADDRESS  详细地址/ NICKNAME 用户昵称/  SEX  用户性别/
//BIRTHDAY  用户生日/ PORTRAIT  用户头像/ PAYPASSWORD  支付密码 / SIGNNAME  个性签名
//请求地址：/appuserin/userpersonalinfo.do?UPDPERSONALINFO  (混淆码)
#define kUrlUserPersonalInfo [NSString stringWithFormat:@"/appuserin/userpersonalinfo.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"UPDPERSONALINFO"]]
//126.获取用户的个人信息（完成）
//参数： HONOURUSER_ID  用户ID/
//请求地址：/appuserin/getuserinfo.do?GETUSERINFO  (混淆码)
#define kUrlGetUserInfo [NSString stringWithFormat:@"/appuserin/getuserinfo.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"GETUSERINFO"]]
//127.修改用户密码（完成）
//参数： HONOURUSER_ID  用户ID/    PASSWORD  密码
//请求地址：/appuserin/userupdpassword.do?UPDUSERPASSWORD  (混淆码)
#define kUrlUserUpdPassword [NSString stringWithFormat:@"/appuserin/userupdpassword.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"UPDUSERPASSWORD"]]
//128.选择卡种类的图片（完成）
//
//参数： CARDTYPE_ID（390181853778149376 至尊会籍卡，390200265979646133 荣耀会籍卡，390201795059646464 名人联名卡，390201950420860928 经典会籍卡，390202180738482176 金，390202468161552384 木，390202526550458368 水，390202622746820608 火，390202686642847744 土，390202047296700416 白羊座，390202895984754688 金牛座，390202951949352960 双子座，390202999533731840 巨蟹座，390203316828635136 狮子座，390203446780755968 处女座，390203482788855808 天平座，390203541202927616 天蝎座，390203583108218880 射手座，390203751593410560 摩羯座，390203784837464064 水瓶座，390203822426816512双鱼座）
//请求地址： /appbootpagein/getcardimgs?CARDIMGS  (混淆码)
#define kUrlGetCardImgs [NSString stringWithFormat:@"/appbootpagein/getcardimgs?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CARDIMGS"]]
//129.分类随机显示6个卡号（完成）
//参数： CARDTYPE_ID（1 自选号码库 2 贵宾号码库 3 金钻号码库 4荣耀号码库 5 超级黑卡靓号号码库）
//请求地址：/appbootpagein/getcardnum?CARDNUM  (混淆码)
#define kUrlGetCardNum [NSString stringWithFormat:@"/appbootpagein/getcardnum?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"CARDNUM"]]
//130.获取所有能量组成 （完成）
//参数： HONOURUSER_ID  用户ID/
//请求地址：/appengrgyin/energylist.do?ENERGYLIST  (混淆码)
#define kUrlEnergyList [NSString stringWithFormat:@"/appengrgyin/energylist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ENERGYLIST"]]
//131.按月份统计用户能量值(完成)
//参数：  HONOURUSER_ID  用户ID/
//请求地址：/appengrgyin/energyvaluemonth.do?ENERGYVALUEMONTH  (混淆码)
#define kUrlEnergyValueMonth [NSString stringWithFormat:@"/appengrgyin/energyvaluemonth.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ENERGYVALUEMONTH"]]
//132.获取用户会员中心信息(完成)
//参数：  HONOURUSER_ID  用户ID/
//请求地址：/appuserin/getmemberinfo.do?MEMBERINFO  (混淆码)
#define kUrlGetMemberInfo [NSString stringWithFormat:@"/appuserin/getmemberinfo.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"MEMBERINFO"]]
//133.给商品添加用户评价（完成）
//参数：PRODUCT_ID 商品id/HONOURUSER_ID 评价用户id/EVALUATECONTENT 评价内容/EVALUATECOINT 评价分数
//ISSHOW 是否为匿名评价（0为不匿名，1为匿名）
//请求地址：/appshipin/sproductaddeva.do?SPRODUCTADDEVA（混淆码）
#define kUrlSProductAddEva [NSString stringWithFormat:@"/appshipin/sproductaddeva.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SPRODUCTADDEVA"]]
//134.获取商品的评价列表(弃用)
//参数：  PRODUCT_ID  商品ID/
//请求地址：/appshipin/productevalist.do?PRODUCTEVALIST  (混淆码)
#define kUrlProductEvaList [NSString stringWithFormat:@"/appshipin/sproductaddeva.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PRODUCTEVALIST"]]
//135.获取我的优惠券，黑卡币，能量值(完成)
//参数：  HONOURUSER_ID  用户ID/
//请求地址：/getmycoublackenergy.do?MYCOUBLACKENERGY  (混淆码)
#define kUrlGetMyCouBlackEnergy [NSString stringWithFormat:@"/appuserin/getmycoublackenergy.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"MYCOUBLACKENERGY"]]
//136.找回登录密码 (忘记密码)(完成)
//参数：  CARDNO=390913360687792128   当前账号/   PHONE=13366847890   手机号/   USERIDCARD=654321  身份证号/
//请求地址：/appuserin/getuserbyforget.do?USERBYFORGET  (混淆码)
#define kUrlGetUserByForget [NSString stringWithFormat:@"/appuserin/getuserbyforget.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"USERBYFORGET"]]

//137.修改用户手机号码
//参数：  HONOURUSER_ID  用户ID/     PHONE   手机号/
//请求地址：/appuserin/upduserphone.do?UPDUSERPHONE  (混淆码)
#define kUrlUpdUserphone [NSString stringWithFormat:@"/appuserin/upduserphone.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"UPDUSERPHONE"]]
//138.根据广告栏位置查询广告
//参数：  AD_POSITION  广告栏位置
//请求地址：/appadvertismentin/advertiselist.do?ADVERTISEMENTLIST  (混淆码)
#define kUrlAdvertiseList [NSString stringWithFormat:@"/appadvertismentin/advertiselist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"ADVERTISEMENTLIST"]]
//139.修改点击广告的次数
//参数：  CLICK_COUNT  点击次数   /      ADVERTISEMENT_ID    广告栏的id
//请求地址：/appadvertismentin/editClickCount.do?EDITCLICKCOUNT  (混淆码)
#define kUrlEditClickCount [NSString stringWithFormat:@"/appadvertismentin/editClickCount.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"EDITCLICKCOUNT"]]

//140.根据汇聚ID查询分类列表
//参数：  CONVERGE_ID  所属汇聚的ID
//请求地址：/appconvergein/getconvergesort.do?GETCONVERGESORT  (混淆码)
#define kUrlGetConvergesort [NSString stringWithFormat:@"/appconvergein/getconvergesort.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"GETCONVERGESORT"]]
//141.获取话题列表(含模糊查询)（完成）
//可选参数：  TITLE  话题
//请求地址：/appcirclein/gettopiclist.do?TOPICLIST  (混淆码)
#define kUrlGetTopicList [NSString stringWithFormat:@"/appcirclein/gettopiclist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"TOPICLIST"]]
//142.根据话题查询(弃用)
//参数：  TITLE  话题
//请求地址：/appcirclein/gettopicbytitle.do?TOPICBYTITLE  (混淆码)
//143.添加话题 （话题头像名字 showfile）
//参数：  HONOURUSER_ID  添加话题的用户ID/       TITLE  话题      /
//请求地址：/appcirclein/addtopic.do?TOPICADD  (混淆码)
#define kUrlAddTopic [NSString stringWithFormat:@"/appcirclein/addtopic.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"TOPICADD"]]
//144.通过ID获取杂志详情
//参数：  MAGAZINE_ID     杂志的ID/       MAGAZINETYPE  杂志的类型      /
//请求地址：/apphomein/magazineone?MAGAZINEONE  (混淆码)
#define kUrlMagazineOne [NSString stringWithFormat:@"/apphomein/magazineone?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"MAGAZINEONE"]]
//146 尊购首页各种专区点击后返回的商家列表（筛选同接口）
//参数：  参数：BRAND_ID 类型参数id/
//BRANDICON_ID   商品品牌 ID（筛选用参数）
//请求地址：/appshipin/shipbusinesslist.do?SHIPPBUSINESS  (混淆码)
#define kUrlShipbusinessList [NSString stringWithFormat:@"/appshipin/shipbusinesslist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SHIPPBUSINESS"]]
//147.显示首页（1）/尊购（2）/汇聚（3）→搜索的字
//参数：  参数：PARENT_ID 类型参数id/
//请求地址：/apphomein/searchlist.do?SERRCHLIST  (混淆码)
#define kUrlSearchList [NSString stringWithFormat:@"/apphomein/searchlist.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SERRCHLIST"]]
//148.荣耀杂志首页接口
//参数：  无
//请求地址：/appmagazinein/getlistsubmenu.do?LISTSUBMENU  (混淆码)
#define kUrlGetListSubmenu [NSString stringWithFormat:@"/appmagazinein/getlistsubmenu.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"LISTSUBMENU"]]
//149.商家发布自媒体广告流-单独上传视频
//参数：  showfile  视频文件名
//请求地址：/appdiscoverin/upvideo.do?UPVIDEO (混淆码)
#define kUrlUpVideo [NSString stringWithFormat:@"/appdiscoverin/upvideo.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"UPVIDEO"]]
//150.商家发布自媒体广告流
//参数：  TITLE 标题 /     HONOURUSER_ID  用户id     /fileList   上传的图片名
//请求地址：/appdiscoverin/addselfmediaad.do?SELFMEDIAADD (混淆码)
#define kUrlAddSelfMediaad [NSString stringWithFormat:@"/appdiscoverin/addselfmediaad.do?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"SELFMEDIAADD"]]

//直播
//151.主播开播接口(获取一个推流地址)
//请求地址：/livein/getpushaddress?PUSHADDRESS
#define kUrlGetPushAddress [NSString stringWithFormat:@"/livein/getpushaddress?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PUSHADDRESS"]]
//152.获得所有正在推流的地址(所有正在直播的地址)
//请求地址：/livein/getpushlist?PUSHLIST
#define kUrlGetPushList [NSString stringWithFormat:@"/livein/getpushlist?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PUSHLIST"]]
//153.用户看直播接口(获取一个拉流地址)
//请求地址：/livein/getpulladdress?PULLADDRESS  参数：STREAMNAME(每个主播单独的地址)
#define kUrlGetPullAddress [NSString stringWithFormat:@"/livein/getpulladdress?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"PULLADDRESS"]]



#endif /* URLMacros_h */
