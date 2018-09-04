//
//  FQ_AlertController.m
//  FQ_AlertController
//
//  Created by mac on 2017/8/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "FQ_AlertView.h"
#import <Masonry/Masonry.h>

@implementation FQ_AlertConfiguration

static FQ_AlertConfiguration * _defaultConfiguration = nil;
static CGFloat FQScreenW = 0.0f;
static CGFloat FQScreenH = 0.0f;

-(instancetype)init
{
    if (self = [super init]) {
        self.defaultTextColor = DefaultTextColor;
        self.defaultTextFont = RegularFont(TitleFontSize);
        self.defaultBackgroundColor = OtherActionBackColor;
        
        self.confirmTextColor = ConfirmTextColor;
        self.confirmTextFont = RegularFont(TitleFontSize);
        self.confirmBackgroundColor = OtherActionBackColor;
        
        self.destructiveTextColor = DestructiveTextColor;
        self.destructiveTextFont = RegularFont(TitleFontSize);
        self.destructiveBackgroundColor = OtherActionBackColor;
        
        self.cancelTextColor = CancelTextColor;
        self.cancelTextFont = RegularFont(TitleFontSize);
        self.cancelBackgroundColor =  CancelBackgroundColor;
        
        self.cornerRadius = TipTopCornerRadius;
        self.isClickClear = YES;
        self.messageTextAlignment = NSTextAlignmentCenter;
        self.titleFont = SemiboldFont(TitleFontSize);
        self.messageFont = RegularFont(ContentFontSize);
        self.titleColor = TitleTextColor;
        self.messageColor = MessageTextColor;
        
    }
    return self;
}

+(FQ_AlertConfiguration *)defaultConfiguration
{
    if (_defaultConfiguration == nil) {
        _defaultConfiguration = [[FQ_AlertConfiguration alloc]init];
    }
    return _defaultConfiguration;
}

+(void)setDefaultConfiguration:(FQ_AlertConfiguration *)defaultConfiguration
{
    if (defaultConfiguration != _defaultConfiguration) {
        _defaultConfiguration = defaultConfiguration;
    }
}

@end


@implementation FQ_AlertViewManager

+ (instancetype)shareManager
{
    static FQ_AlertViewManager *instance = nil;
    static dispatch_once_t alertManager;
    
    dispatch_once(&alertManager, ^{
        
        instance = [[self alloc]init];
        
    });
    
    return instance;
}

-(NSMutableArray *)alertViewArr
{
    if (!_alertViewArr) {
        _alertViewArr = [NSMutableArray array];
    }
    return _alertViewArr;
    
}

@end

@interface FQ_AlertAction ()

@property (copy, nonatomic) NSString *title;

@end

@implementation FQ_AlertAction

+ (instancetype)actionWithTitle:( NSString *)title type:(FQ_AlertActionType)actionType handler:(void (^)(FQ_AlertAction *alertAction,NSInteger index))handler
{
    FQ_AlertAction *alertAction = [[FQ_AlertAction alloc]init];
    alertAction.actionType = actionType;
    alertAction.title = title;
    alertAction.actionBlock = handler;
    return alertAction;
}

@end


@interface FQ_AlertView ()


/**
 顶部提示框
 */
@property (strong, nonatomic) UIView *alertTopView;

/**
 //中间提示框
 */
@property (weak, nonatomic) UIView *alertMidView;

/**
 //底部提示框
 */
@property (strong, nonatomic) UIView *alertSheetView;

/**
 //整体遮盖
 */
@property (strong, nonatomic) UIButton *coverBtn;

/**
 //点击的按钮个数
 */
@property (strong, nonatomic) NSMutableArray *actionArr;

/**
 //提示文字
 */
@property (copy, nonatomic) NSString *titleStr;

/**
 //提示内容
 */
@property (copy, nonatomic) NSString *messageStr;

/**
 //弹出样式
 */
@property (assign, nonatomic) FQ_AlertType alertType;

/**
 //提示框的配置
 */
@property (strong, nonatomic) FQ_AlertConfiguration*configuration;


@end

@implementation FQ_AlertView



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
                         configuration:(FQ_AlertConfiguration*)configuration{
    
    FQ_AlertView * alertView = [[FQ_AlertView alloc]init];
    
    FQScreenW = SJScreenW;
    FQScreenH = SJScreenH;
    
    for (FQ_AlertView * alert in [FQ_AlertViewManager shareManager].alertViewArr) {
        [alert clickCoverView];
    }
    [[FQ_AlertViewManager shareManager].alertViewArr addObject:alertView];
    
    alertView.titleStr = title;
    alertView.messageStr = message;
    alertView.alertType = alertType;
    alertView.configuration = configuration ? :FQ_AlertConfiguration.defaultConfiguration;
    [FQKeyWindowRootView addSubview:alertView];
    
    return alertView;
}

/**
 快捷展示多种样式
 
 @param title 标题
 @param message 内容信息
 @param alertType 展示样式
 @param confirmActionStr 确定Action样式文本
 @param otherActionStrArr 其他Action样式文本数组
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
                           actionBlock:(void(^)(FQ_AlertAction * action,NSInteger index))actionBlock{
    
    FQ_AlertView * alertView = [FQ_AlertView showAlertViewWithTitle:title message:message alertType:alertType configuration:configuration];
    
    alertView.frame = CGRectMake(0, 0, FQScreenW, FQScreenH);//superView.bounds;
    
    if (confirmActionStr.length) {
        FQ_AlertAction * confirm = [FQ_AlertAction actionWithTitle:confirmActionStr type:FQ_AlertActionStyleConfirm handler:actionBlock];
        confirm.actionBlock = actionBlock;
        [alertView addAction:confirm];
    }
    
    for (NSString * otherStr in otherActionStrArr) {
        FQ_AlertAction * other = [FQ_AlertAction actionWithTitle:otherStr type:FQ_AlertActionStyleDefault handler:actionBlock];
        other.actionBlock = actionBlock;
        [alertView addAction:other];
    }
    
    if (destructiveActionStr.length) {
        FQ_AlertAction * destructive = [FQ_AlertAction actionWithTitle:destructiveActionStr type:FQ_AlertActionStyleDestructive handler:actionBlock];
        destructive.actionBlock = actionBlock;
        [alertView addAction:destructive];
    }
    
    if (cancelActionStr.length) {
        FQ_AlertAction * cancel = [FQ_AlertAction actionWithTitle:cancelActionStr type:FQ_AlertActionStyleCancel handler:actionBlock];
        cancel.actionBlock = actionBlock;
        [alertView addAction:cancel];
    }
    
    [alertView showAlertView];
    return alertView;
}

/**
 快捷展示顶部样式
 
 @param title 标题
 @param message 内容信息
 @return AlertView
 */
+ (instancetype)showTopAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
   return  [FQ_AlertView showAlertViewWithTitle:title message:message alertType:FQ_AlertTypeActionTop confirmActionStr:nil otherActionStrArr:nil destructiveActionStr:nil cancelActionStr:nil configuration:nil actionBlock:nil];
}

#pragma mark ============ 视图展示逻辑 ==============

/**
 展示提示框
 */
-(void)showAlertView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self layoutIfNeeded];
    [self uploadAlertView];
}

/**
 更新alertView布局
 */
-(void)uploadAlertView
{
    UIView * transforView = nil;
    if (self.alertType == FQ_AlertTypeActionAlert) {
        transforView = self.alertMidView;
    }else if(self.alertType == FQ_AlertTypeActionTop){
        transforView = self.alertTopView;
    }else{
        transforView = self.alertSheetView;
    }
    if (KEY_WINDOW.bounds.size.width < KEY_WINDOW.bounds.size.height && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        //旋转
        BOOL isLeft = [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft;
        
        CGFloat angleFloat = isLeft ? -M_PI_2 : M_PI_2;
        transforView.transform = CGAffineTransformMakeRotation(angleFloat);
        
    }else{
        transforView.transform = CGAffineTransformIdentity;
    }
    //更新布局时.保障在最上层
    [KEY_WINDOW bringSubviewToFront:self.coverBtn];
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.coverBtn.alpha = 1;
    } completion:nil];
    
    if (self.alertType == FQ_AlertTypeActionTop) {
        [self showAlertTopView];
    }else if(self.alertType == FQ_AlertTypeActionAlert){
        [self showAlertMidView];
    }else{
        [self showAlertSheetView];
    }
}

/**
 顶部提示方式
 */
-(void)showAlertTopView
{
    CGRect alertTransRect = self.alertTopView.frame;
    alertTransRect.origin.y = KIsiPhoneX ? 34 : 5;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alertTopView.frame = alertTransRect;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self clickCoverView];
        });
    }];
}


/**
 展示为中间的样式.模拟苹果
 */
-(void)showAlertMidView
{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alertMidView.alpha = 1;
    } completion:nil];
    
}


/**
 展示为底部样式.
 */
-(void)showAlertSheetView
{
    CGRect alertTransRect = self.alertSheetView.frame;
    alertTransRect.origin.y = FQScreenH - alertTransRect.size.height - SheetHorizontalMargin;
    [UIView animateWithDuration:0.3 animations:^{
        self.alertSheetView.frame = alertTransRect;
    }];
}


#pragma mark ============ 响应事件 ==============

/**
 点击遮盖View
 */
-(void)clickCoverView
{
    //只允许存在一个
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.alertType == FQ_AlertTypeActionTop) {
            self.alertTopView.transform = CGAffineTransformMakeTranslation(0, -self.alertTopView.frame.size.height);
        }else if(self.alertType == FQ_AlertTypeActionSheet){
            self.alertSheetView.transform = CGAffineTransformMakeTranslation(0, self.alertSheetView.frame.size.height);
        }
        self.coverBtn.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.coverBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
    [[FQ_AlertViewManager shareManager].alertViewArr removeAllObjects];
}


/**
 点击遮盖view.
 */
-(void)clickClearCoverView
{
    if (self.configuration.isClickClear) {
        [self clickCoverView];
    }
}


/**
 点击提示按钮
 
 @param alertBtn 提示按钮
 */
-(void)clickAlertBtn:(UIButton *)alertBtn
{
    FQ_AlertAction * alertAction = self.actionArr[alertBtn.tag - AlertActionTag];
    //先清除界面再调用block
    [self clickCoverView];
    if (alertAction.actionBlock) {
        alertAction.actionBlock(alertAction,alertBtn.tag- AlertActionTag);
    }
}



#pragma mark ============ 公共方法 ==============

- (NSDictionary *)textStyleWithAlignment:(NSTextAlignment)alignment font:(UIFont *)font textColor:(UIColor *)textColor
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.paragraphSpacing = 0.3f * font.lineHeight;
//    style.lineSpacing = 5.0;
    style.alignment = alignment;
    
    if (alignment == NSTextAlignmentCenter) {
        style.firstLineHeadIndent = 0;
    }else{
        style.tailIndent = -2; //设置与尾部的距离
        style.headIndent = 7;
        style.firstLineHeadIndent = 2.0f * font.pointSize;
    }
    return @{ NSFontAttributeName: font,
              NSParagraphStyleAttributeName: style,
              NSKernAttributeName : @0.5,
              NSForegroundColorAttributeName:textColor};
    
}


- (NSMutableAttributedString*)getAttrWithTextStr:(NSString*)textStr textFont:(UIFont *)textFont textColor:(UIColor *)textColor descrStr:(NSString *)descr descrFont:(UIFont *)descrFont descrColor:(UIColor *)descrColor{
    
    NSMutableAttributedString * resultAttr;
    if (descr && descr.length > 0 && textStr && textStr.length > 0) {
        resultAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:\n%@",textStr,descr]];
    }else if(descr && descr.length > 0){
        resultAttr = [[NSMutableAttributedString alloc] initWithString:descr];
    }else if (textStr && textStr.length > 0){
        resultAttr = [[NSMutableAttributedString alloc] initWithString:textStr];
    }else{
        return nil;
    }

    //设置字体大小
    NSRange range = NSMakeRange(0, resultAttr.string.length);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.paragraphSpacing = 5.0;
    [resultAttr addAttributes:@{NSFontAttributeName:descrFont,NSForegroundColorAttributeName:descrColor,NSKernAttributeName:@1.0,NSParagraphStyleAttributeName:style} range:range];
    if (textStr.length && textStr) {
        //可以设置某段字体的大小
        [resultAttr addAttributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textColor} range:NSMakeRange(0, textStr.length)];
    }
    
    return resultAttr;
}


/**
 设置按钮的参数值
 
 @param button 按钮
 @param alertAction 按钮状态值
 */
-(void)settingActionBtn:(UIButton *)button action:(FQ_AlertAction *)alertAction
{
    switch (alertAction.actionType) {
        case FQ_AlertActionStyleDefault: //默认样式
        {
            [button setTitleColor:self.configuration.defaultTextColor forState:UIControlStateNormal];
            button.titleLabel.font = self.configuration.defaultTextFont;
            [button setBackgroundImage:[self imageWithColor:self.configuration.defaultBackgroundColor] forState:UIControlStateNormal];
            
            break;
        }
        case FQ_AlertActionStyleConfirm:  //确定样式
        {
            [button setTitleColor:self.configuration.confirmTextColor forState:UIControlStateNormal];
            button.titleLabel.font = self.configuration.confirmTextFont;
            [button setBackgroundImage:[self imageWithColor:self.configuration.confirmBackgroundColor] forState:UIControlStateNormal];
            break;
        }
        case FQ_AlertActionStyleDestructive: //慎重样式
        {
            [button setTitleColor:self.configuration.destructiveTextColor forState:UIControlStateNormal];
            button.titleLabel.font = self.configuration.destructiveTextFont;
            [button setBackgroundImage:[self imageWithColor:self.configuration.destructiveBackgroundColor] forState:UIControlStateNormal];
            break;
        }
        case FQ_AlertActionStyleCancel: //取消样式
        {
            [button setTitleColor:self.configuration.cancelTextColor forState:UIControlStateNormal];
            button.titleLabel.font = self.configuration.cancelTextFont;
            [button setBackgroundImage:[self imageWithColor:self.configuration.cancelBackgroundColor] forState:UIControlStateNormal];
            
            break;
        }
        default:
            break;
    }

    [button setBackgroundImage:[self imageWithColor:[[UIColor whiteColor]colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setTitle:alertAction.title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAlertBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 添加多个提示按钮
 
 @param alertAction 提示按钮
 */
-(void)addAction:(FQ_AlertAction *)alertAction
{
    [self.actionArr addObject:alertAction];
}


/**
 获取纯色图片

 @param color 颜色值
 @return 图片
 */
- (UIImage *)imageWithColor:(UIColor *)color{

    CGSize size = CGSizeMake(1, 1);
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark ============ 处理横竖屏幕切换 ==============

/**
 添加通知
 */
-(void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangStatusNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}


/**
 屏幕横竖转换通知
 
 @param notification 通知对象
 */
-(void)didChangStatusNotification:(NSNotification *)notification
{
    FQScreenW = SJScreenW;
    FQScreenH = SJScreenH;
    
    //虽然keywindow没有变化.但是其实它横屏状态
    [self layoutSubviews];
    [self uploadAlertView];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

}

#pragma mark ============ 初始化控件 ==============

-(instancetype)init
{
    if (self = [super init]) {
        [self addNotification];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addNotification];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addNotification];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.alertType == FQ_AlertTypeActionAlert) {
        [self layoutMidAlertView] ;
    }else if(self.alertType == FQ_AlertTypeActionSheet){
        [self layoutSheetView];
    }else{
        [self layoutTopView];
    }
    
}

-(UIView *)alertTopView
{
    if (!_alertTopView) {
        
        CGFloat topViewSumH = 0.0f;
        CGFloat topViewW = AlertViewW - 2 * TopViewMargin;
        
        UIView * backView = [[UIView alloc]init];
        UIView * containerView = [[UIView alloc]init];
        backView.backgroundColor = BackViewBackgroundColor;
        
        backView.tag = AlertTopViewBackViewTag;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *backEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        
        _alertTopView = containerView;
        [backEffectView.contentView addSubview:backView];
        [containerView addSubview:backEffectView];
        
        [backEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.offset(0);
        }];
        
        [self.coverBtn addSubview:containerView];
        
        [KEY_WINDOW addSubview:self.coverBtn];
        
        [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.offset(0);
        }];
        
//        [KEY_WINDOW addSubview:containerView];
        
        containerView.layer.cornerRadius = TipTopCornerRadius;
        containerView.layer.masksToBounds = YES;
        
        UILabel * titleText = [[UILabel alloc]initWithFrame:CGRectMake(TopViewMargin,TopViewMargin, topViewW - TopViewMargin * 2, 0)];
        titleText.textColor = self.configuration.titleColor;
        titleText.textAlignment = NSTextAlignmentLeft;
        titleText.numberOfLines = 0;
        titleText.tag = 1;
        [backView addSubview:titleText];
        
        titleText.attributedText = [self getAttrWithTextStr:self.titleStr textFont:SemiboldFont(15) textColor:[UIColor blackColor] descrStr:self.messageStr descrFont:RegularFont(13) descrColor:RGBA(88, 87, 86, 1.0)];
        CGFloat textH  = [titleText.attributedText boundingRectWithSize:CGSizeMake(topViewW - TopViewMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
        CGRect tempRect = titleText.frame;
        tempRect.size.height = textH;
        titleText.frame = tempRect;
        
        topViewSumH += CGRectGetMaxY(titleText.frame) + TopViewMargin;
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.offset(0);
        }];
        
        [self.alertTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(KIsiPhoneX ? 34 : 20);
            make.centerX.offset(0);
            make.width.equalTo(@(topViewW));
            make.height.equalTo(@(topViewSumH));
        }];
        
    }
    return _alertTopView;
}

-(void)layoutTopView
{
    CGFloat topViewSumH = 0.0f;
    CGFloat topViewW = AlertViewW - 2 * TopViewMargin;
    UIView * topBackView = [self.alertTopView viewWithTag:AlertTopViewBackViewTag];
    UILabel * titleText = [topBackView viewWithTag:1];
    titleText.frame = CGRectMake(TopViewMargin,TopViewMargin, topViewW - TopViewMargin * 2, 0);
    
    titleText.attributedText = [self getAttrWithTextStr:self.titleStr textFont:SemiboldFont(15) textColor:[UIColor blackColor] descrStr:self.messageStr descrFont:RegularFont(13) descrColor:RGBA(88, 87, 86, 1.0)];
    CGFloat textH = [titleText.attributedText boundingRectWithSize:CGSizeMake(topViewW - TopViewMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    
    CGRect tempRect = titleText.frame;
    tempRect.size.height = textH;
    titleText.frame = tempRect;
    
    topViewSumH += CGRectGetMaxY(titleText.frame) + TopViewMargin;
    
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(0);
    }];
    
    if (KEY_WINDOW.bounds.size.width < KEY_WINDOW.bounds.size.height && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        [self.alertTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ? -(FQScreenH * 0.5 - topViewSumH*0.5 - 10) : FQScreenH * 0.5 - topViewSumH*0.5 - 10);
            make.centerY.offset(0);
            make.width.equalTo(@(topViewW));
            make.height.equalTo(@(topViewSumH));
        }];
        
    }else{
        [self.alertTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(KIsiPhoneX ? 34 : 20);
            make.centerX.offset(0);
            make.width.equalTo(@(topViewW));
            make.height.equalTo(@(topViewSumH));
        }];
    }
    
}



-(UIView *)alertMidView
{
    if (!_alertMidView) {
        
        CGFloat midViewSumH = 0.0f;
        CGFloat midViewW = MidAlertViewWidth;// FQScreenW * 0.85;
        
        UIView * backView = [[UIView alloc]init];
        UIView * containerView = [[UIView alloc]init];
        backView.backgroundColor = BackViewBackgroundColor;
        
        backView.tag = AlertMidViewBackViewTag;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *backEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        
        _alertMidView = containerView;
        [backEffectView.contentView addSubview:backView];
        [containerView addSubview:backEffectView];
        
        [backEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.offset(0);
        }];
        
        [self.coverBtn addSubview:containerView];
        
        
        [KEY_WINDOW addSubview:self.coverBtn];
        
        [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.offset(0);
        }];
        
        containerView.layer.cornerRadius = self.configuration.cornerRadius;
        containerView.layer.masksToBounds = YES;
        
        CGFloat titleViewH = 0.0f;
        UILabel * titleLabel;
        if (self.titleStr.length > 0) {
            titleViewH = [self.titleStr boundingRectWithSize:CGSizeMake(midViewW -  2 *Mid_TextTopMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self textStyleWithAlignment:NSTextAlignmentCenter font:self.configuration.titleFont textColor:self.configuration.titleColor] context:nil].size.height;
            
            titleLabel = [[UILabel alloc]initWithFrame:CGRectIntegral(CGRectMake(Mid_TextTopMargin, MidBtnMargin,midViewW - 2* Mid_TextTopMargin , titleViewH))];
            titleLabel.numberOfLines = 0;
            [backView addSubview:titleLabel];
            titleLabel.attributedText = [[NSAttributedString alloc]initWithString:self.titleStr attributes:[self textStyleWithAlignment:NSTextAlignmentCenter font:self.configuration.titleFont textColor:self.configuration.titleColor]];
            midViewSumH = CGRectGetMaxY(titleLabel.frame);
            titleLabel.tag = 1;
        }
        
        UILabel * messageLabel;
        if (self.messageStr.length > 0) {
            CGFloat messageH = [self.messageStr boundingRectWithSize:CGSizeMake(midViewW - 2 * Mid_TextTopMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self textStyleWithAlignment:self.configuration.messageTextAlignment font:self.configuration.messageFont textColor:self.configuration.messageColor] context:nil].size.height;
            
            messageLabel = [[UILabel alloc]initWithFrame:CGRectIntegral(CGRectMake(Mid_TextTopMargin, self.messageStr.length ? MidBtnMargin + titleViewH + Mid_TextTopMargin : MidBtnMargin,midViewW - 2 * Mid_TextTopMargin, self.messageStr.length ? messageH : 0 ))];
            messageLabel.numberOfLines = 0;
            [backView addSubview:messageLabel];
            messageLabel.attributedText = [[NSAttributedString alloc]initWithString:self.messageStr attributes:[self textStyleWithAlignment:self.configuration.messageTextAlignment font:self.configuration.messageFont textColor:self.configuration.messageColor]];
            
            midViewSumH = CGRectGetMaxY(messageLabel.frame);
            messageLabel.tag = 2;
        }
        
        if (self.configuration.customView) {
            [backView addSubview:self.configuration.customView];
            midViewSumH += Mid_TextTopMargin;
            self.configuration.customView.frame = CGRectIntegral(CGRectMake(Mid_TextTopMargin, midViewSumH,midViewW - 2 * Mid_TextTopMargin, self.configuration.customView.bounds.size.height));
            midViewSumH += self.configuration.customView.bounds.size.height;
        }
        
        if (self.titleStr.length || self.messageStr.length) {
            midViewSumH += MidBotMargin;
        }else{
            midViewSumH = MidBotMargin;
        }
        
        NSInteger count = 0;
        CGFloat btnsSumH = 0.0f;
        for (FQ_AlertAction *alertAction in self.actionArr) {
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = count + AlertActionTag;//从3开始
            
            [self settingActionBtn:button action:alertAction];
            
            if (self.actionArr.count == 1) {
                button.frame = CGRectMake(0, midViewSumH, midViewW, ActionBtnH);
                btnsSumH = ActionBtnH;
            }else if(self.actionArr.count == 2){
                button.frame = CGRectMake(count == 0 ? 0 : (midViewW  * 0.5 + 0.5), midViewSumH, midViewW * 0.5 - 0.5, ActionBtnH);
                btnsSumH = ActionBtnH ;
            }else{
                button.frame = CGRectMake(0, midViewSumH + count * (ActionBtnH + 1), midViewW, ActionBtnH);
                btnsSumH = ActionBtnH * self.actionArr.count + 1 * (self.actionArr.count - 1);
            }
            [containerView addSubview:button];
            count ++;
        }
        midViewSumH += btnsSumH;
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.offset(-(btnsSumH + 1));
        }];
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.centerX.offset(0);
            make.width.equalTo(@(midViewW));
            make.height.equalTo(@(midViewSumH - 1));
        }];
        containerView.alpha = 0;
    }
    return _alertMidView;
}

-(void)layoutMidAlertView
{
    CGFloat midViewSumH = 0.0f;
    CGFloat midViewW = MidAlertViewWidth;// FQScreenW * 0.85;
    UIView * backView = [self.alertMidView viewWithTag:AlertMidViewBackViewTag];
    CGFloat titleViewH = 0.0f;
    if (self.titleStr.length > 0) {
        midViewSumH = MidBtnMargin;
        titleViewH = [self.titleStr boundingRectWithSize:CGSizeMake(midViewW - 2 * Mid_TextTopMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self textStyleWithAlignment:NSTextAlignmentCenter font:self.configuration.messageFont textColor:self.configuration.titleColor] context:nil].size.height;
        
        UILabel * titleView = [backView viewWithTag:1];
        titleView.frame = CGRectIntegral(CGRectMake(Mid_TextTopMargin, MidBtnMargin,midViewW - 2 *Mid_TextTopMargin , titleViewH));
        midViewSumH += titleViewH;
    }
    
    
    if (self.messageStr.length > 0) {
        
        if (self.titleStr.length > 0) {
            midViewSumH += Mid_TextTopMargin;
        }else{
            midViewSumH += MidBtnMargin;
        }
        
        CGFloat messageH = [self.messageStr boundingRectWithSize:CGSizeMake(midViewW - 2 * Mid_TextTopMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self textStyleWithAlignment:self.configuration.messageTextAlignment font:self.configuration.messageFont textColor:self.configuration.messageColor] context:nil].size.height;
        UILabel * messageView = [backView viewWithTag:2];
        messageView.frame = CGRectIntegral(CGRectMake(Mid_TextTopMargin,midViewSumH,midViewW - 2 * Mid_TextTopMargin, self.messageStr.length ? messageH : 0 ));
        midViewSumH += messageH;
    }
    
    if (self.configuration.customView) {
        midViewSumH += Mid_TextTopMargin;
        self.configuration.customView.frame = CGRectIntegral(CGRectMake(Mid_TextTopMargin, midViewSumH,midViewW - 2 * Mid_TextTopMargin, self.configuration.customView.bounds.size.height));
        midViewSumH += self.configuration.customView.bounds.size.height;
    }
    
    if (self.titleStr.length || self.messageStr.length) {
        midViewSumH += MidBotMargin;
    }else{
        midViewSumH = MidBotMargin;
    }
    
    CGFloat btnsSumH = 0.0f;
    
    for (int i = 0; i < self.actionArr.count; i++) {
        UIButton * button = [self.alertMidView viewWithTag:(i + AlertActionTag)];
        
        if (self.actionArr.count == 1) {
            button.frame = CGRectMake(0, midViewSumH, midViewW, ActionBtnH);
            btnsSumH = ActionBtnH;
        }else if(self.actionArr.count == 2){
            button.frame = CGRectMake(i == 0 ? 0 : (midViewW  * 0.5 + 0.5), midViewSumH , midViewW * 0.5 - 0.5, ActionBtnH);
            btnsSumH = ActionBtnH;
        }else{
            button.frame = CGRectMake(0, midViewSumH + i * (ActionBtnH + 1), midViewW, ActionBtnH);
            btnsSumH = ActionBtnH * self.actionArr.count + 1 * (self.actionArr.count - 1);
        }
        
    }
    
    midViewSumH += btnsSumH;
    
    [backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(-(btnsSumH + 1));
    }];
    
    [self.alertMidView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.centerX.offset(0);
        make.width.equalTo(@(midViewW));
        make.height.equalTo(@(midViewSumH - 1));
    }];
}


-(UIView *)alertSheetView
{
    if (!_alertSheetView) {
        
        CGFloat sheetViewSumH = 0.0f;
        CGFloat sheetViewW = FQScreenW;
        
        UIView * backView = [[UIView alloc]init];
        UIView * containerView = [[UIView alloc]init];
        backView.backgroundColor = BackViewBackgroundColor;
        
        backView.tag = AlertSheetViewBackViewTag;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *backEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        
        _alertSheetView = containerView;
        [backEffectView.contentView addSubview:backView];
        [containerView addSubview:backEffectView];
        
        [backEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.offset(0);
        }];
        
        [self.coverBtn addSubview:containerView];
        [KEY_WINDOW addSubview:self.coverBtn];
        [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.offset(0);
        }];
        
        CGFloat titleViewH = 0.0f;
        UILabel * titleLabel;
        if (self.titleStr.length > 0) {
            titleViewH = [self.titleStr boundingRectWithSize:CGSizeMake(sheetViewW - 2 * SheetHorizontalMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self textStyleWithAlignment:NSTextAlignmentCenter font:self.configuration.titleFont textColor:self.configuration.titleColor] context:nil].size.height;
            
            titleLabel = [[UILabel alloc]initWithFrame:CGRectIntegral(CGRectMake(SheetHorizontalMargin, SheetTopMargin,sheetViewW - 2 * SheetHorizontalMargin , titleViewH))];
            titleLabel.numberOfLines = 0;
            [backView addSubview:titleLabel];
            titleLabel.attributedText = [[NSAttributedString alloc]initWithString:self.titleStr attributes:[self textStyleWithAlignment:NSTextAlignmentCenter font:self.configuration.titleFont textColor:self.configuration.titleColor]];
            sheetViewSumH = CGRectGetMaxY(titleLabel.frame);
            titleLabel.tag = 1;
            
        }
        UILabel * messageLabel;
        if (self.messageStr.length > 0) {
            CGFloat messageH = [self.messageStr boundingRectWithSize:CGSizeMake(sheetViewW - 2 * SheetHorizontalMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self textStyleWithAlignment:self.configuration.messageTextAlignment font:self.configuration.messageFont textColor:self.configuration.messageColor] context:nil].size.height;
            
            messageLabel = [[UILabel alloc]initWithFrame:CGRectIntegral(CGRectMake(SheetHorizontalMargin, SheetTopMargin + titleViewH + SheetSmoMargin,sheetViewW - 2 * SheetHorizontalMargin, self.messageStr.length ? messageH : 0 ))];
            messageLabel.numberOfLines = 0;
            [backView addSubview:messageLabel];
            messageLabel.attributedText = [[NSAttributedString alloc]initWithString:self.messageStr attributes:[self textStyleWithAlignment:self.configuration.messageTextAlignment font:self.configuration.messageFont  textColor:self.configuration.messageColor]];
            messageLabel.tag = 2;
            sheetViewSumH = CGRectGetMaxY(messageLabel.frame);
        }
        
        if (self.messageStr.length || self.titleStr.length) {
            sheetViewSumH += SheetContentMargin;
        }else{
//            sheetViewSumH = SheetContentMargin;
        }
        
        NSInteger count = 0;
        CGFloat btnsSumH = 0.0f;
        for (FQ_AlertAction *alertAction in self.actionArr) {
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self settingActionBtn:button action:alertAction];
            button.tag = count + AlertActionTag;
            
            if (alertAction.actionType != FQ_AlertActionStyleCancel) {
                button.frame = CGRectMake(0, sheetViewSumH + btnsSumH, sheetViewW, ActionBtnH);
                btnsSumH += ActionBtnH + 1;
                
            }else{
                button.frame = CGRectMake(0, sheetViewSumH + btnsSumH + 3, sheetViewW, ActionBtnH);
                btnsSumH += ActionBtnH + 3;
            }
            [containerView addSubview:button];
            count ++;
        }
        sheetViewSumH += btnsSumH;
        CGFloat iphoneXBottomMargin = KIsiPhoneX ? 34 : 0;
        sheetViewSumH += iphoneXBottomMargin;
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.offset( -(btnsSumH + 1 + iphoneXBottomMargin)).priorityHigh();
        }];
        containerView.frame = CGRectMake(0, FQScreenH, sheetViewW, sheetViewSumH);
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.centerX.offset(0);
            make.width.equalTo(@(sheetViewW));
            make.height.equalTo(@(sheetViewSumH));
        }];
    }
    return _alertSheetView;
}

-(void)layoutSheetView
{
    CGFloat sheetViewSumH = 0.0f;
    CGFloat sheetViewW = FQScreenW;
    UIView *backView = [self.alertSheetView viewWithTag:AlertSheetViewBackViewTag];
    CGFloat titleViewH = 0.0f;
    if (self.titleStr.length > 0) {
        sheetViewSumH = SheetTopMargin;
        titleViewH = [self.titleStr boundingRectWithSize:CGSizeMake(sheetViewW - 2 * SheetHorizontalMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self textStyleWithAlignment:NSTextAlignmentCenter font:self.configuration.titleFont textColor:self.configuration.titleColor] context:nil].size.height;

        UILabel * titleView = [backView viewWithTag:1];
        titleView.frame = CGRectIntegral(CGRectMake(SheetHorizontalMargin, sheetViewSumH,sheetViewW - 2 * SheetHorizontalMargin , titleViewH));
        sheetViewSumH += titleViewH;
    }


    if (self.messageStr.length > 0) {
        if (self.titleStr.length > 0) {
            sheetViewSumH += SheetSmoMargin;
        }else{
            sheetViewSumH += SheetContentMargin;
        }

        if (self.messageStr.length > 0) {
            CGFloat messageH = [self.messageStr boundingRectWithSize:CGSizeMake(sheetViewW - 2 * SheetHorizontalMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self textStyleWithAlignment:self.configuration.messageTextAlignment font:self.configuration.messageFont textColor:self.configuration.messageColor] context:nil].size.height;
            UILabel * messageView = [backView viewWithTag:2];
            messageView.frame = CGRectIntegral(CGRectMake(SheetHorizontalMargin, sheetViewSumH,sheetViewW - 2 * SheetHorizontalMargin, self.messageStr.length ? messageH : 0 ));
            sheetViewSumH += messageH;
        }
    }

    if (self.messageStr.length || self.titleStr.length) {
        sheetViewSumH += SheetContentMargin;
    }else{
//        sheetViewSumH = SheetContentMargin;
    }


    CGFloat btnsSumH = 0.0f;

    for (int i = 0; i < self.actionArr.count; i++) {
        UIButton * button = [self.alertSheetView viewWithTag:(i + AlertActionTag)];
        FQ_AlertAction *alertAction = self.actionArr[i];
        if (alertAction.actionType != FQ_AlertActionStyleCancel) {
            button.frame = CGRectMake(0, sheetViewSumH + btnsSumH, sheetViewW, ActionBtnH);
            btnsSumH += (ActionBtnH + 1);
        }else{
            button.frame = CGRectMake(0, sheetViewSumH + btnsSumH + 3, sheetViewW, ActionBtnH);
            btnsSumH += ActionBtnH + 3;
        }
    }

    sheetViewSumH += btnsSumH;
    CGFloat iphoneXBottomMargin = KIsiPhoneX ? 34 : 0;
    sheetViewSumH += iphoneXBottomMargin;
    [backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset( -(btnsSumH + 1 + iphoneXBottomMargin));
    }];

    if (KEY_WINDOW.bounds.size.width < KEY_WINDOW.bounds.size.height && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        [self.alertSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.centerX.offset([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ? (FQScreenH * 0.5 - sheetViewSumH*0.5 - 10) : -FQScreenH * 0.5 + sheetViewSumH*0.5 + 10);
            make.width.equalTo(@(sheetViewW));
            make.height.equalTo(@(sheetViewSumH));
        }];
    }else{
        [self.alertSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.centerX.offset(0);
            make.width.equalTo(@(sheetViewW));
            make.height.equalTo(@(sheetViewSumH));
        }];
    }
}

-(UIButton *)coverBtn
{
    if (!_coverBtn) {
        _coverBtn = [[UIButton alloc]init];
        _coverBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        [_coverBtn addTarget:self action:@selector(clickClearCoverView) forControlEvents:UIControlEventTouchUpInside];
        _coverBtn.alpha = 0;
    }
    return _coverBtn;
}

-(NSMutableArray *)actionArr
{
    if (!_actionArr) {
        _actionArr = [NSMutableArray array];
    }
    return _actionArr;
}

@end

