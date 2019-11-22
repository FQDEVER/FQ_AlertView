//
//  JTFQ_NewAlertView.h
//  FQ_AlertTipView
//
//  Created by fanqi on 2018/12/19.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBA(r, g, b, a)           [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define Color(r)                    RGBA(r, r, r, 1)
#define GlobalBlueColor             RGBA(9.0, 99.0, 204.0, 1.0)
#define SJScreenH      [UIScreen mainScreen].bounds.size.height
#define SJScreenW      [UIScreen mainScreen].bounds.size.width
#define KEY_WINDOW        [[UIApplication sharedApplication] keyWindow]

//是否是 iphone X
#define FQAIS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iPHoneXr
#define FQAIS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size)  : NO)
// 判断iPhoneXs
#define FQAIS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)  : NO)
// 判断iPhoneXs Max
#define FQAIS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

//所有流海屏幕
#define KIsiPhoneX  (FQAIS_IPHONE_X || FQAIS_IPHONE_Xr || FQAIS_IPHONE_Xs || FQAIS_IPHONE_Xs_Max)

#define GetSystemVersion     [[[UIDevice currentDevice] systemVersion] floatValue]
#define PFRegularFont(Size) GetSystemVersion >= 9.0 ? [UIFont fontWithName:@"PingFangSC-Regular" size:Size]:[UIFont systemFontOfSize:Size]
#define PFMediumFont(Size) GetSystemVersion >= 9.0 ? [UIFont fontWithName:@"PingFangSC-Medium" size:Size]:[UIFont systemFontOfSize:Size]
#define PFHeavyFont(Size) GetSystemVersion >= 9.0 ? [UIFont fontWithName:@"AvenirNext-Bold" size:Size]:[UIFont systemFontOfSize:Size]
#define PFLightFont(Size) GetSystemVersion >= 9.0 ? [UIFont fontWithName:@"PingFangSC-Light" size:Size]:[UIFont systemFontOfSize:Size]
#define PFBoldFont(Size) GetSystemVersion >= 9.0 ? [UIFont fontWithName:@"PingFangSC-Semibold" size:Size]:[UIFont systemFontOfSize:Size]


#define FQKeyWindowRootView [[UIApplication sharedApplication] keyWindow].rootViewController.view
//默认值
#define TitleFontSize 18
#define ContentFontSize 14
#define AlertViewW MIN(SJScreenH,SJScreenW)

#define TitleTextColor Color(51)
#define MessageTextColor Color(102)
#define TitleTextFont PFMediumFont(18)
#define MessageTextFont PFRegularFont(14)
#define ActionBtnFont PFMediumFont(16)


//居中样式的默认样式
#define MidConfirmTextColor [[UIColor whiteColor] colorWithAlphaComponent:1.0]
#define MidDefaultTextColor [[UIColor whiteColor] colorWithAlphaComponent:1.0]
#define MidCancelTextColor  RGBA(170,170,170,1.0)
#define MidDestructiveTextColor RGBA(228,57,60,1.0)

#define MidCancelBackgroundColor     [[UIColor whiteColor] colorWithAlphaComponent:1.0]
#define MidOtherActionBackColor      [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]
#define MidBackViewBackgroundColor   [[UIColor whiteColor] colorWithAlphaComponent:1.0]
//其他样式的默认样式

#define ConfirmTextColor [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] //Color(0)
#define DefaultTextColor [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]// Color(128)
#define CancelTextColor [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]//RGBA(1.0,104.0,204.0,1.0)
#define DestructiveTextColor RGBA(228,57,60,1.0)
#define CancelBackgroundColor     [[UIColor whiteColor] colorWithAlphaComponent:1.0]
#define OtherActionBackColor      [[UIColor whiteColor] colorWithAlphaComponent:1.0]


#define TipCornerRadius 12
#define MidCornerRadius 5
#define TipTopBtnH  36
#define ActionBtnH 44
#define SheetActionBtnH 56
//中间提示框左右的间距
#define MidActionMargin 16
//中间提示框
#define MidAlertViewWidth 280
//按钮Tag
#define AlertActionTag 92841


//-------------------提示框样式----------------------
typedef NS_ENUM (NSInteger, FQ_AlertType)
{
    FQ_AlertTypeActionAlert = 0 ,  //中间
    FQ_AlertTypeActionTop ,        //顶部
    FQ_AlertTypeActionSheet,       //底部
};

//-------------------Action样式----------------------
typedef NS_ENUM (NSInteger, FQ_AlertActionType)
{
    FQ_AlertActionStyleDefault = 0, //默认样式 - 使用边框
    FQ_AlertActionStyleConfirm,     //确定样式
    FQ_AlertActionStyleDestructive,  //慎重样式
    FQ_AlertActionStyleCancel,  //取消样式
    FQ_AlertActionStyleGradient  //渐变样式
};


//-------------------按钮文本显示样式----------------------
typedef NS_ENUM (NSInteger, FQ_AlertActionButtonTextType)
{
    FQ_AlertActionButtonTextType_FixedWH_FitWidth = 0, //自适应样式.即宽高固定.文字大小随着指定的宽度缩小
    FQ_AlertActionButtonTextType_FixedWH_None, //默认样式,即宽高固定,文字大小固定.内容中间...展示
    FQ_AlertActionButtonTextType_TextWH,     //根据文本大小设定按钮的宽高.固定字体大小.全部展示文本
};

//-------------------提示框样式----------------------
typedef enum : NSInteger{
    FQ_AlertCancelBtnType_None = 0 ,        //隐藏
    FQ_AlertCancelBtnType_Normal ,          //在AlertView的右上角.内侧
    FQ_AlertCancelBtnType_TopRight ,        //在AlertView的右上角.外侧
    FQ_AlertCancelBtnType_Bottom,           //在AlertView的底部.外侧
}FQ_AlertCancelBtnType;

@interface FQ_AlertConfiguration : NSObject


/**
 FQ_AlertActionStyleDefault = 0, //默认样式
 */
@property (strong, nonatomic) UIColor *defaultTextColor;
@property (strong, nonatomic) UIColor *defaultBackgroundColor;
@property (strong, nonatomic) UIFont  *defaultTextFont;

/**
 FQ_AlertActionStyleConfirm       //确定样式
 */
@property (strong, nonatomic) UIColor *confirmTextColor;
@property (strong, nonatomic) UIColor *confirmBackgroundColor;
@property (strong, nonatomic) UIFont  *confirmTextFont;

/**
 FQ_AlertActionStyleDestructive  //重要样式
 */
@property (strong, nonatomic) UIColor *destructiveTextColor;
@property (strong, nonatomic) UIColor *destructiveBackgroundColor;
@property (strong, nonatomic) UIFont  *destructiveTextFont;

/**
 FQ_AlertActionStyleCencel  //取消样式
 */
@property (strong, nonatomic) UIColor *cancelTextColor;
@property (strong, nonatomic) UIColor *cancelBackgroundColor;
@property (strong, nonatomic) UIFont  *cancelTextFont;

/**
 FQ_AlertActionStyleGradient  //渐变样式
 */
@property (strong, nonatomic) UIColor *gradientTextColor;
@property (strong, nonatomic) NSArray *gradientBackColors; //使用CGColor
@property (strong, nonatomic) UIFont  *gradientTextFont;
@property (nonatomic, strong) UIImage *gradientBgImg;

/**
 圆角大小
 */
@property (assign, nonatomic) CGFloat cornerRadius;

/**
 //能否点击遮盖消失
 */
@property (assign, nonatomic) BOOL isClickClear;

/**
 遮罩背景颜色
 */
@property (nonatomic, strong) UIColor *coverBackgroundColor;

/**
 //自定义ContentView.需要传入其Size.默认宽度为AlertW - 2 * FQAlertPaddingW.
 */
@property (nonatomic, strong) UIView *customView;

/**
 //自定义HeaderView.需要传入其Size.默认宽度为AlertW - 2 * FQAlertPaddingW.
 */
@property (nonatomic, strong) UIView *headerView;

/**
 //alert自定义的文本描述部分-背景视图
 */
@property (nonatomic, strong) UIView *alertTextContentBgView;

/**
//alert背景毛玻璃效果.默认为UIBlurEffectStyleExtraLight
*/
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle;

/**
 //messageStr的对齐方式
 */
@property (nonatomic, assign) NSTextAlignment messageTextAlignment;

/**
 //设置标题的文字
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 //设置内容的文字
 */
@property (nonatomic, strong) UIFont *messageFont;

/**
 //设置标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 //设置描述颜色
 */
@property (nonatomic, strong) UIColor *messageColor;

/**
 设置顶部按钮的默认字体大小
 */
@property (nonatomic, strong) UIFont *alertTipDefaultFont;

/**
 设置顶部样式按钮取消字体大小
 */
@property (nonatomic, strong) UIFont *alertTipCancelFont;

/**
 按钮文本展示的样式.默认为FQ_AlertActionButtonTextType_FixedWH_FitWidth
 */
@property (nonatomic, assign) FQ_AlertActionButtonTextType actionBtnTextType;

/**
 是否需要背景控件 - 暂放在这里.默认为YES
 */
@property (nonatomic, assign) BOOL isNeedCoverBackView;

/**
 分割线的宽或高
 */
@property (nonatomic, assign) CGFloat separatorPadding;

/**
 默认顶部的按钮高度为36.中间的高度为44.底部的高度为56
 #define TipCornerRadius 12
 #define TipTopBtnH  36
 #define ActionBtnH 44
 #define SheetActionBtnH 56
 */
@property (nonatomic, assign) CGFloat alertActionH;

/**
 是否清理所有的alertView,默认为NO
 */
@property (nonatomic, assign) BOOL isClearAllAlertView;

/**
 取消按钮图片
 */
@property (nonatomic, copy) NSString *cancelImg;

/**
 展示取消按钮的样式.默认是FQ_AlertCancelBtnType_None类型
 */
@property (nonatomic, assign) FQ_AlertCancelBtnType cancelBtnType;

/// 文本描述背景色.一般指整个背景色
@property (nonatomic, strong) UIColor *textContentBgColor;

/// 当为两个按钮时.是使用横向布局还是纵向布局.横向布局指:两个action等分.纵向指的是:上下布局
/// alert样式两个action是否为水平样式.默认为NO
@property (nonatomic, assign) BOOL hasAlertActionHorizontal;

/// 整个alertContentView的背景色.默认为透明
@property (nonatomic, strong) UIColor* alertContentViewBgColor;

/// titleLab/headerView与边界均与左右间距横向间距.默认为10.
@property (nonatomic, assign) CGFloat fq_alertViewPaddingWidth;

/// titlelab与headerView之间的间距纵向间距.以及messageLab与Action视图之间的间距为2 * fq_alertViewPaddingHeight.默认为8.0.
@property (nonatomic, assign) CGFloat fq_alertViewPaddingHeight;

/// 当有headerView时.使用fq_alertViewTitlePaddingHeight.无headerView时.使用fq_alertViewTitlePaddingHeight做title的间距.默认为20.0
@property (nonatomic, assign) CGFloat fq_alertViewTitlePaddingHeight;

/// messageLab与左右两侧的间距.默认为16.0
@property (nonatomic, assign) CGFloat fq_alertViewContentPaddingWidth;

/**
 // 默认的配置项.类属性.
 */
@property (class, nonatomic)  FQ_AlertConfiguration *defaultConfiguration;

@end


@interface JTFQ_NewAlertViewManager : NSObject

/**
 提示alertAction数组
 */
@property (strong, nonatomic) NSMutableArray *alertViewArr;

@end

@interface FQ_AlertAction : NSObject

/**
 alertAction的样式
 */
@property (assign, nonatomic) FQ_AlertActionType actionType;

/**
 alertAction标题
 */
@property (copy, nonatomic,readonly) NSString *title;

/**
 点击alertAction回调
 */
@property (copy, nonatomic) void(^ actionBlock)(FQ_AlertAction *action,NSInteger index);

//#warning 应该在这里纪录他的宽高.这样提前判断是否需要更改方式.获取最大高度
//
///**
// action的size.获取的契机是什么
// */
//@property (nonatomic, assign) CGSize actionSize;

/**
 快速创建AlertAction对象
 
 @param title AlertAction标题
 @param actionType AlertAction类型
 @param handler 响应事件回调
 @return AlertAction对象
 */
+ (instancetype)actionWithTitle:( NSString *)title type:(FQ_AlertActionType)actionType handler:(void (^)(FQ_AlertAction *action,NSInteger index))handler;

@end


@interface FQ_AlertView : UIView


/**
 快捷展示多种样式
 
 @param title 标题
 @param message 内容信息
 @param alertType 展示样式
 @param gradientActionStr 渐变样式
 @param confirmActionStr 确定样式
 @param otherActionStrArr 其他样式
 @param destructiveActionStr 删除样式
 @param cancelActionStr 取消样式
 @param configuration 配置文件
 @param actionBlock 点击回调
 @return AlertView
 */
+ (instancetype)showAlertViewWithTitle:(NSString *)title
                               message:(NSString *)message
                             alertType:(FQ_AlertType)alertType
                     gradientActionStr:(NSString *)gradientActionStr
                      confirmActionStr:(NSString *)confirmActionStr
                     otherActionStrArr:(NSArray *)otherActionStrArr
                  destructiveActionStr:(NSString *)destructiveActionStr
                       cancelActionStr:(NSString *)cancelActionStr
                         configuration:(FQ_AlertConfiguration*)configuration
                           actionBlock:(void(^)(FQ_AlertAction * action,NSInteger index))actionBlock;

/**
 快捷展示多种样式
 
 @param title 标题
 @param message 内容信息
 @param alertType 展示样式
 @param confirmActionStr 确定样式
 @param otherActionStrArr 其他样式
 @param destructiveActionStr 删除样式
 @param cancelActionStr 取消样式
 @param configuration 配置文件
 @param actionBlock 点击回调
 @return AlertView
 */
+ (instancetype)showAlertViewWithTitle:(NSString *)title
                               message:(NSString *)message
                             alertType:(FQ_AlertType)alertType
                      confirmActionStr:(NSString *)confirmActionStr
                     otherActionStrArr:(NSArray *)otherActionStrArr
                  destructiveActionStr:(NSString *)destructiveActionStr
                       cancelActionStr:(NSString *)cancelActionStr
                         configuration:(FQ_AlertConfiguration*)configuration
                           actionBlock:(void(^)(FQ_AlertAction * action,NSInteger index))actionBlock;


/**
 快捷展示顶部样式
 
 @param title 标题
 @param message 内容信息
 @return AlertView
 */
+ (instancetype)showTopAlertViewWithTitle:(NSString *)title message:(NSString *)message;

/**
 获取当前提示框的宽度
 
 @param alertType 提示类型
 @return 提示框宽度
 */
+(CGFloat)getAlertTypeWidth:(FQ_AlertType)alertType;

/**
 如果有.即隐藏.没有就不隐藏
 */
+ (void)hiddenWithAnimation:(BOOL)animation;

// ============ 自定义弹框顺序时.需要使用以下方法 ==============

/**
 展示提示框
 */
-(void)showAlertView;

/**
 添加自定义Action
 */
-(void)addAction:(FQ_AlertAction *)alertAction;

/**
 基础展示
 
 @param title 标题
 @param message 内容信息
 @param alertType 展示样式
 @param configuration 配置文件
 @return alertView
 */
+ (instancetype)showAlertViewWithTitle:(NSString *)title
                               message:(NSString *)message
                             alertType:(FQ_AlertType)alertType
                         configuration:(FQ_AlertConfiguration*)configuration;


@end

