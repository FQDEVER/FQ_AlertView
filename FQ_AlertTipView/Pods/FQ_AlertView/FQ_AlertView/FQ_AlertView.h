//
//  FQ_AlertController.h
//  FQ_AlertController
//
//  Created by mac on 2017/8/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBA(r, g, b, a)           [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define Color(r)                    RGBA(r, r, r, 1)
#define GlobalBlueColor             RGBA(9.0, 99.0, 204.0, 1.0)
#define SJScreenH      [UIScreen mainScreen].bounds.size.height
#define SJScreenW      [UIScreen mainScreen].bounds.size.width
#define KEY_WINDOW        [[UIApplication sharedApplication] keyWindow]
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define GetSystemVersion     [[[UIDevice currentDevice] systemVersion] floatValue]
#define RegularFont(Size) [UIFont systemFontOfSize:Size]
#define SemiboldFont(Size) [UIFont boldSystemFontOfSize:Size]
#define FQKeyWindowRootView [[UIApplication sharedApplication] keyWindow].rootViewController.view
//默认值
#define TitleFontSize 18
#define ContentFontSize 14
#define AlertViewW MIN(SJScreenH,SJScreenW)
#define ActionBtnH 44
#define ConfirmTextColor [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] //Color(0)
#define DefaultTextColor [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]// Color(128)
#define CancelTextColor [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]//RGBA(1.0,104.0,204.0,1.0)
#define TitleTextColor Color(0)
#define MessageTextColor Color(60)
#define DestructiveTextColor RGBA(228,57,60,1.0)
#define ContentTextColor Color(102)
#define CancelBackgroundColor     [[UIColor whiteColor] colorWithAlphaComponent:1.0]
#define OtherActionBackColor      [[UIColor whiteColor] colorWithAlphaComponent:1.0]
#define BackViewBackgroundColor   [[UIColor whiteColor] colorWithAlphaComponent:1.0]

#define TipCornerRadius 12
//顶部提示框
#define TipTopBtnH  36
//中间提示框
#define MidAlertViewWidth 280
//按钮Tag
#define AlertActionTag 92841


extern CGFloat const FQAlertViewPaddingWidth;
extern CGFloat const FQAlertViewPaddingHeight;
extern CGFloat const FQAlertViewTitlePaddingHeight;
extern CGFloat const FQAlertViewContentPaddingWidth;


//-------------------提示框样式----------------------
typedef NS_ENUM (NSInteger, FQ_AlertType)
{
    FQ_AlertTypeActionAlert = 0 ,  //中间
    FQ_AlertTypeActionTop ,        //顶部
    FQ_AlertTypeActionTop_NoneCover ,//顶部无遮罩的情况
    FQ_AlertTypeActionSheet,       //底部
};

//-------------------Action样式----------------------
typedef NS_ENUM (NSInteger, FQ_AlertActionType)
{
    FQ_AlertActionStyleDefault = 0, //默认样式
    FQ_AlertActionStyleConfirm,     //确定样式
    FQ_AlertActionStyleDestructive,  //慎重样式
    FQ_AlertActionStyleCancel  //取消样式
};


//-------------------按钮样式----------------------
typedef NS_ENUM (NSInteger, FQ_AlertActionButtonType)
{
    FQ_AlertActionButtonType_FixedWH_FitWidth = 0, //自适应样式.即宽高固定.文字大小随着指定的宽度缩小
    FQ_AlertActionButtonType_FixedWH_None, //默认样式,即宽高固定,文字大小固定.内容中间...展示
    FQ_AlertActionButtonType_TextWH,     //根据文本大小设定按钮的宽高.固定字体大小.全部展示文本
};


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
 //自定义的View.需要传入其Size
 */
@property (nonatomic, strong) UIView *customView;

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
 按钮展示的样式.默认为FQ_AlertActionButtonType_FixedWH_FitWidth
 */
@property (nonatomic, assign) FQ_AlertActionButtonType actionBtnType;

/**
 是否需要背景控件 - 暂放在这里.默认为YES
 */
@property (nonatomic, assign) BOOL isNeedCoverBackView;

/**
 // 默认的配置项.类属性.
 */
@property (class, nonatomic)  FQ_AlertConfiguration *defaultConfiguration;

@end


@interface FQ_AlertViewManager : NSObject

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
 @param confirmActionStr 确定Action样式文本
 @param otherActionStrArr 其他Action样式文本数组
 @param destructiveActionStr 删除Action样式文本
 @param configuration 配置文件
 @param actionBlock 点击Action回调
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
 如果有.即隐藏.没有就不隐藏
 */
+ (void)hidden;

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


