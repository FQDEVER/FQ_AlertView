//
//  FQ_AlertController.m
//  FQ_AlertController
//
//  Created by mac on 2017/8/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "FQ_AlertView.h"

@implementation FQ_AlertConfiguration

static FQ_AlertConfiguration * _defaultConfiguration = nil;
static CGFloat FQScreenW = 0.0f;
static CGFloat FQScreenH = 0.0f;

-(instancetype)init
{
    if (self = [super init]) {
        self.defaultTextColor = DefaultTextColor;
        self.defaultTextFont = ActionBtnFont;
        self.defaultBackgroundColor = OtherActionBackColor;
        
        self.confirmTextColor = ConfirmTextColor;
        self.confirmTextFont = ActionBtnFont;
        self.confirmBackgroundColor = OtherActionBackColor;
        
        self.destructiveTextColor = DestructiveTextColor;
        self.destructiveTextFont = ActionBtnFont;
        self.destructiveBackgroundColor = OtherActionBackColor;
        
        self.cancelTextColor = MidCancelTextColor;
        self.cancelTextFont = ActionBtnFont;
        self.cancelBackgroundColor =  CancelBackgroundColor;
        
        self.gradientTextColor = UIColor.whiteColor;
        self.gradientBackColors = @[(id)RGBA(0, 122, 255, 1).CGColor,(id)RGBA(0, 178, 255, 1).CGColor]; //使用CGColor
        //        self.gradientBackColors = @[(id)RGBA(255, 182, 0, 1).CGColor,(id)RGBA(255, 207, 0, 1).CGColor]; //使用CGColor
        self.gradientTextFont = ActionBtnFont;
        
        self.cornerRadius = TipCornerRadius;
        self.isClickClear = YES;
        self.messageTextAlignment = NSTextAlignmentCenter;
        self.titleFont = TitleTextFont;
        self.messageFont = MessageTextFont;
        self.titleColor = TitleTextColor;
        self.messageColor = MessageTextColor;
        self.alertTipDefaultFont = [UIFont systemFontOfSize:14.0];
        self.alertTipCancelFont = [UIFont boldSystemFontOfSize:14.0];
        self.actionBtnTextType = FQ_AlertActionButtonTextType_FixedWH_FitWidth;
        self.coverBackgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        self.isNeedCoverBackView =  YES;
        self.separatorPadding = 1.0f;
        self.alertActionH = 0;
        self.isClearAllAlertView = NO;
        self.textContentBgColor = UIColor.whiteColor;
        self.blurEffectStyle = UIBlurEffectStyleExtraLight;
        self.alertContentViewBgColor = UIColor.clearColor;
        self.fq_alertViewPaddingWidth = 10.0f; //title/headerView/以及textContentView均与左右间距
        self.fq_alertViewPaddingHeight = 8.0f; //title与顶部/title月headerView之间的间距
        self.fq_alertViewTitlePaddingHeight = 20.0f;//当有headerView时.使用fq_alertViewTitlePaddingHeight.无headerView时.使用fq_alertViewTitlePaddingHeight做title的间距
        self.fq_alertViewContentPaddingWidth = 16.0f;//message与左右两侧的间距
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


@implementation JTFQ_NewAlertViewManager

+ (instancetype)shareManager
{
    static JTFQ_NewAlertViewManager *instance = nil;
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
 提示框
 */
@property (nonatomic, strong) UIView *alertContentView;

@property (nonatomic, strong) UIView * textContentView;

@property (nonatomic, strong) UIVisualEffectView *backEffectView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * messageLabel;

/**
 //整体遮盖
 */
@property (strong, nonatomic) UIButton *coverBtn;

/**
 取消按钮.默认隐藏
 */
@property (nonatomic, strong) UIButton *cancelBtn;

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
    
    alertView.titleStr = title;
    alertView.messageStr = message;
    alertView.alertType = alertType;
    alertView.configuration = configuration ? :FQ_AlertConfiguration.defaultConfiguration;
    
    if (alertType != FQ_AlertTypeActionTop) {
        for (FQ_AlertView * alert in [JTFQ_NewAlertViewManager shareManager].alertViewArr) {
            if (alertView.configuration.isClearAllAlertView) {
                [alert fq_clearAllAlertViewWithAnimation:NO];
            }else{
                [alert fq_temporaryClearAlertViewWithAnimation:YES];//临时清理.
            }
        }
    }
    [[JTFQ_NewAlertViewManager shareManager].alertViewArr addObject:alertView];
    
    return alertView;
}

/**
 快捷展示多种样式 -有渐变
 
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
                           actionBlock:(void(^)(FQ_AlertAction * action,NSInteger index))actionBlock{
    
    FQ_AlertView * alertView = [FQ_AlertView showAlertViewWithTitle:title message:message alertType:alertType configuration:configuration];
    
    alertView.frame = CGRectMake(0, 0, FQScreenW, FQScreenH);//superView.bounds;
    
    if (gradientActionStr.length) {
        FQ_AlertAction * gradient = [FQ_AlertAction actionWithTitle:gradientActionStr type:FQ_AlertActionStyleGradient handler:actionBlock];
        gradient.actionBlock = actionBlock;
        [alertView addAction:gradient];
    }
    
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
 快捷展示多种样式 - 无渐变
 
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
                           actionBlock:(void(^)(FQ_AlertAction * action,NSInteger index))actionBlock
{
    return [FQ_AlertView showAlertViewWithTitle:title message:message alertType:alertType gradientActionStr:nil confirmActionStr:confirmActionStr otherActionStrArr:otherActionStrArr destructiveActionStr:destructiveActionStr cancelActionStr:cancelActionStr configuration:configuration actionBlock:actionBlock];
}

/**
 快捷展示顶部样式
 
 @param title 标题
 @param message 内容信息
 @return AlertView
 */
+ (instancetype)showTopAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
    alertConfiguration.isNeedCoverBackView = NO;
    
    return  [FQ_AlertView showAlertViewWithTitle:title message:message alertType:FQ_AlertTypeActionTop confirmActionStr:@"好的" otherActionStrArr:nil destructiveActionStr:nil cancelActionStr:nil configuration:alertConfiguration actionBlock:nil];
}

/**
 快捷展示顶部样式
 
 @param title 标题
 @param message 内容信息
 @return AlertView
 */
+ (instancetype)showTopAlertViewWithTitle:(NSString *)title message:(NSString *)message isShowCoverView:(BOOL)isShowCover
{
    FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
    alertConfiguration.isNeedCoverBackView = isShowCover;
    
    return  [FQ_AlertView showAlertViewWithTitle:title message:message alertType:FQ_AlertTypeActionTop confirmActionStr:nil otherActionStrArr:nil destructiveActionStr:nil cancelActionStr:nil configuration:alertConfiguration actionBlock:nil];
}

/**
 如果有.即隐藏.没有就不隐藏
 */
+ (void)hiddenWithAnimation:(BOOL)animation
{
    NSMutableArray * alertViewArr =  [JTFQ_NewAlertViewManager shareManager].alertViewArr;
    for (FQ_AlertView * alert in alertViewArr) {
        [alert fq_clickCoverViewWithAnimation:animation completion:nil];
    }
}


/**
 获取当前提示框的宽度
 
 @param alertType 提示类型
 @return 提示框宽度
 */
+(CGFloat)getAlertTypeWidth:(FQ_AlertType)alertType{
    if (alertType == FQ_AlertTypeActionTop || alertType == FQ_AlertTypeActionSheet) {
        return MIN(FQScreenH, FQScreenW) - 16.0;
    }else{
        return MidAlertViewWidth;
    }
}

#pragma mark ============ 视图展示逻辑 ==============

/**
 展示提示框
 */
-(void)showAlertView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self layoutIfNeeded];
    [self initializeAlertView];
    [self subviewsValidateView];
    [self uploadAlertViewWithAnimation:YES];
}

/**
 初始化数据
 */
-(void)initializeAlertView{
    
    if (!self.configuration.alertActionH) {
        if (self.alertType == FQ_AlertTypeActionTop) {
            self.configuration.alertActionH = TipTopBtnH;
        }else if (self.alertType ==FQ_AlertTypeActionAlert){
            self.configuration.alertActionH = ActionBtnH;
        }else if (self.alertType == FQ_AlertTypeActionSheet){
            self.configuration.alertActionH = SheetActionBtnH;
        }
    }
}

/**
 更新alertView布局
 */
-(void)uploadAlertViewWithAnimation:(BOOL)animation
{
    UIView * transforView = self.alertContentView;
    if (KEY_WINDOW.bounds.size.width < KEY_WINDOW.bounds.size.height && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        //旋转
        BOOL isLeft = [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft;
        
        CGFloat angleFloat = isLeft ? -M_PI_2 : M_PI_2;
        transforView.transform = CGAffineTransformMakeRotation(angleFloat);
        
    }else{
        transforView.transform = CGAffineTransformIdentity;
    }
    //更新布局时.保障在最上层
    if (self.configuration.isNeedCoverBackView) {
        [KEY_WINDOW bringSubviewToFront:self.coverBtn];
    }else{
        [KEY_WINDOW bringSubviewToFront:self.alertContentView];
    }
    //添加展示时动画
    [self showAlertAnimation:animation];
}

#pragma mark - 显示与隐藏AlertView

-(void)showAlertAnimation:(BOOL)animation{
    
    if (self.alertType == FQ_AlertTypeActionAlert) {
        self.alertContentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }else if (self.alertType == FQ_AlertTypeActionSheet){
        self.alertContentView.transform = CGAffineTransformMakeTranslation(0, self.alertContentView.frame.size.height);
    }else{
        self.alertContentView.transform = CGAffineTransformMakeTranslation(0, -self.alertContentView.frame.size.height);
    }
    
    [UIView animateWithDuration:animation ? 0.5 : 0 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:0 animations:^{
        if (self.configuration.isNeedCoverBackView) {
            self.coverBtn.alpha = 1;
        }
        self.alertContentView.alpha = 1;
        self.alertContentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (self.alertType == FQ_AlertTypeActionTop) {
            [self performSelector:@selector(fq_performSelectorClickTopAlertView) withObject:nil afterDelay:2.6];
        }
    }];
}


-(void)hiddenAlertAnimation:(BOOL)animation completion:(void (^ __nullable)(BOOL finished))completion{
    
    //只允许存在一个
    //    [UIView animateWithDuration:animation ? 10.33 :0 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:0 animations:^{
    
    [UIView animateWithDuration:animation ? 0.33 :0 animations:^{
        if (self.configuration.isNeedCoverBackView) {
            self.coverBtn.alpha = 0.0f;
        }
        if (self.alertType == FQ_AlertTypeActionTop) {
            self.alertContentView.transform = CGAffineTransformMakeTranslation(0, -self.alertContentView.frame.size.height);
        }else if(self.alertType == FQ_AlertTypeActionSheet){
            self.alertContentView.transform = CGAffineTransformMakeTranslation(0, self.alertContentView.frame.size.height);
        }else{
            self.alertContentView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        }
        self.alertContentView.alpha = 0.0;
        self.textContentView.alpha = 0.0;
        self.backEffectView.alpha = 0.0;
        self.messageLabel.alpha = 0.0;
        self.titleLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (self.configuration.isNeedCoverBackView) {
            [self.coverBtn removeFromSuperview];
        }
        [self removeFromSuperview];
        [[JTFQ_NewAlertViewManager shareManager].alertViewArr removeObject:self];
        if (self.alertType != FQ_AlertTypeActionTop) {
            if ([JTFQ_NewAlertViewManager shareManager].alertViewArr.count > 0) {
                FQ_AlertView * alert = [JTFQ_NewAlertViewManager shareManager].alertViewArr.firstObject;
                [alert showAlertAnimation:YES];
            }
        }
        if (completion) {
            completion(finished);
        }
    }];
}

#pragma mark ============ 响应事件 ==============

/**
 点击遮盖View
 */
-(void)fq_clickCoverViewWithAnimation:(BOOL)animation completion:(void (^ __nullable)(BOOL finished))completion
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fq_performSelectorClickTopAlertView) object:nil];
    
    [self hiddenAlertAnimation:animation completion:completion];
}

//一个是彻底清理掉
-(void)fq_clearAllAlertViewWithAnimation:(BOOL)animation{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fq_performSelectorClickTopAlertView) object:nil];
    //只允许存在一个
    [UIView animateWithDuration:animation ? 0.1 :0 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:0 animations:^{
        if (self.configuration.isNeedCoverBackView) {
            self.coverBtn.alpha = 0.0f;
        }
        if (self.alertType == FQ_AlertTypeActionTop) {
            self.alertContentView.transform = CGAffineTransformMakeTranslation(0, -self.alertContentView.frame.size.height);
        }else if(self.alertType == FQ_AlertTypeActionSheet){
            self.alertContentView.transform = CGAffineTransformMakeTranslation(0, self.alertContentView.frame.size.height);
        }else{
            self.alertContentView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        }
        self.alertContentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.configuration.isNeedCoverBackView) {
            [self.coverBtn removeFromSuperview];
        }
        [self removeFromSuperview];
        [[JTFQ_NewAlertViewManager shareManager].alertViewArr removeObject:self];
    }];
}

//一个是暂时清理.当其他的完成时.再弹出
-(void)fq_temporaryClearAlertViewWithAnimation:(BOOL)animation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fq_performSelectorClickTopAlertView) object:nil];
    //只允许存在一个
    [UIView animateWithDuration:animation ? 0.1 :0 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:0 animations:^{
        if (self.configuration.isNeedCoverBackView) {
            self.coverBtn.alpha = 0.0f;
        }
        if (self.alertType == FQ_AlertTypeActionTop) {
            self.alertContentView.transform = CGAffineTransformMakeTranslation(0, -self.alertContentView.frame.size.height);
        }else if(self.alertType == FQ_AlertTypeActionSheet){
            self.alertContentView.transform = CGAffineTransformMakeTranslation(0, self.alertContentView.frame.size.height);
        }else{
            self.alertContentView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        }
        self.alertContentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.configuration.isNeedCoverBackView) {
            self.coverBtn.alpha = 0;
        }
        self.alpha = 0;
    }];
}


/**
 点击遮盖view.
 */
-(void)clickClearCoverView
{
    if (self.configuration.isClickClear) {
        [self fq_clickCoverViewWithAnimation:YES completion:nil];
    }
}


/**
 点击提示按钮
 
 @param alertBtn 提示按钮
 */
-(void)clickAlertBtn:(UIButton *)alertBtn
{
    __weak typeof(self) weakSelf = self;
    //先清除界面再调用block
    [self fq_clickCoverViewWithAnimation:YES completion:^(BOOL finished) {
        FQ_AlertAction * alertAction = weakSelf.actionArr[alertBtn.tag - AlertActionTag];
        if (alertAction.actionBlock) {
            alertAction.actionBlock(alertAction,alertBtn.tag- AlertActionTag);
        }
    }];
}

/**
 自动隐藏topView
 */
-(void)fq_performSelectorClickTopAlertView{
    [self fq_clickCoverViewWithAnimation:YES completion:nil];
}

#pragma mark ============ 公共方法 ==============

- (NSDictionary *)textStyleWithAlignment:(NSTextAlignment)alignment font:(UIFont *)font textColor:(UIColor *)textColor
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.paragraphSpacing = 0.3f * font.lineHeight;
    style.alignment = alignment;
    
    if (alignment == NSTextAlignmentCenter) {
        style.firstLineHeadIndent = 0;
    }else{
        style.tailIndent = -2; //设置与尾部的距离
        style.headIndent = 7;
        style.firstLineHeadIndent = 2.0f * font.pointSize;
    }
    if (font == nil) {
        font = [UIFont boldSystemFontOfSize:15];
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
            button.titleLabel.font = self.alertType == FQ_AlertTypeActionTop ? self.configuration.alertTipDefaultFont : self.configuration.defaultTextFont;
            [button setBackgroundImage:[self imageWithColor:self.configuration.defaultBackgroundColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[self imageWithColor:[self.configuration.defaultBackgroundColor colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
            break;
        }
        case FQ_AlertActionStyleConfirm:  //确定样式
        {
            [button setTitleColor:self.configuration.confirmTextColor forState:UIControlStateNormal];
            button.titleLabel.font = self.alertType == FQ_AlertTypeActionTop ? self.configuration.alertTipDefaultFont : self.configuration.confirmTextFont;
            [button setBackgroundImage:[self imageWithColor:self.configuration.confirmBackgroundColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[self imageWithColor:[self.configuration.confirmBackgroundColor colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
            break;
        }
        case FQ_AlertActionStyleDestructive: //慎重样式
        {
            [button setTitleColor:self.configuration.destructiveTextColor forState:UIControlStateNormal];
            button.titleLabel.font = self.alertType == FQ_AlertTypeActionTop ? self.configuration.alertTipDefaultFont : self.configuration.destructiveTextFont;
            [button setBackgroundImage:[self imageWithColor:self.configuration.destructiveBackgroundColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[self imageWithColor:[self.configuration.destructiveBackgroundColor colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
            break;
        }
        case FQ_AlertActionStyleGradient: //渐变样式
        {
            [button setTitleColor:self.configuration.gradientTextColor forState:UIControlStateNormal];
            button.titleLabel.font = self.alertType == FQ_AlertTypeActionTop ? self.configuration.alertTipDefaultFont : self.configuration.gradientTextFont;
            
            UIImage * img = self.configuration.gradientBgImg;
            if (!img && self.configuration.gradientBackColors.count > 1) {
                img = [self imageWithGradientColors:self.configuration.gradientBackColors];
            }
            [button setBackgroundImage:img forState:UIControlStateNormal];
            [button setBackgroundImage:img forState:UIControlStateHighlighted];
            [button setTitleColor:[self.configuration.gradientTextColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
            break;
        }
        case FQ_AlertActionStyleCancel: //取消样式
        {
            
            button.titleLabel.font = self.alertType == FQ_AlertTypeActionTop ? self.configuration.alertTipCancelFont : self.configuration.cancelTextFont;
            [button setBackgroundImage:[self imageWithColor:self.configuration.cancelBackgroundColor] forState:UIControlStateNormal];
            [button setTitleColor:self.configuration.cancelTextColor forState:UIControlStateNormal];
            [button setBackgroundImage:[self imageWithColor:self.configuration.cancelBackgroundColor] forState:UIControlStateHighlighted];
            [button setTitleColor:[self.configuration.cancelTextColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
            
            break;
        }
        default:
            break;
    }
    
    if (self.configuration.actionBtnTextType == FQ_AlertActionButtonTextType_FixedWH_FitWidth) {
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
    }else if (self.configuration.actionBtnTextType == FQ_AlertActionButtonTextType_FixedWH_None){
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }else{
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    [button setTitle:alertAction.title forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
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

/**
 获取渐变图
 
 @param colors 渐变图色值
 @return 图片
 */
-(UIImage *)imageWithGradientColors:(NSArray *)colors{
    
    CGFloat alertTipBtnW = [FQ_AlertView getAlertTypeWidth:self.alertType];
    CGFloat alertTipBtnH = self.configuration.alertActionH;
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, alertTipBtnW, self.configuration.alertActionH);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    NSArray * locations = @[@(0.5),@(1.0)];
    if (colors.count > 2) {
        NSMutableArray * muArr = [NSMutableArray array];
        CGFloat margin = 1.0 / (colors.count - 1);
        for (int i = 0; i < colors.count; ++i) {
            [muArr addObject:@(i * margin)];
        }
        locations = muArr.copy;
    }
    gradientLayer.locations = locations;
    [gradientLayer setColors:colors];//渐变数组
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(alertTipBtnW, alertTipBtnH), NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [gradientLayer renderInContext:context];
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
    
    if (self.configuration.isNeedCoverBackView) {
        self.coverBtn.frame = KEY_WINDOW.bounds;
    }
    
    if (self.alertType == FQ_AlertTypeActionAlert) {
        
        self.alertContentView.center = CGPointMake(FQScreenW * 0.5,FQScreenH * 0.5);
        
    }else if(self.alertType == FQ_AlertTypeActionSheet){
        
        CGSize oldSize = self.alertContentView.frame.size;
        self.alertContentView.frame = CGRectMake((FQScreenW - oldSize.width) * 0.5, FQScreenH - oldSize.height - (KIsiPhoneX ? 34 : 0), oldSize.width, oldSize.height);
    }else{
        
        CGSize oldSize = self.alertContentView.frame.size;
        
        self.alertContentView.frame = CGRectMake((FQScreenW - oldSize.width) * 0.5, KIsiPhoneX ? 34 : 20, oldSize.width, oldSize.height);
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark - Tool

/**
 获取指定按钮的size
 
 @param button 指定按钮
 @param size 限制的最大size
 @return 按钮实际的尺寸
 */
-(CGSize)getButtonWithSize:(UIButton *)button sizeThatFits:(CGSize)size
{
    CGSize btnSize = [button.titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: button.titleLabel.font} context:nil].size;
    return btnSize;
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


-(UIView *)alertContentView
{
    if (!_alertContentView) { //此时已经知道是某个alertView类型了
        
        _alertContentView = [[UIView alloc]init];
        _alertContentView.backgroundColor = self.configuration.alertContentViewBgColor;
        [self.backEffectView.contentView addSubview:self.textContentView];
        [_alertContentView addSubview:self.backEffectView];
        if (self.configuration.isNeedCoverBackView) {
            [self.coverBtn addSubview:_alertContentView];
            [KEY_WINDOW addSubview:self.coverBtn];
        }else{
            [KEY_WINDOW addSubview:_alertContentView];
        }
        
//        _backEffectView.layer.cornerRadius = self.alertType == FQ_AlertTypeActionAlert ? MidCornerRadius : self.configuration.cornerRadius;
//        _backEffectView.layer.masksToBounds = YES;
        _alertContentView.layer.cornerRadius = self.alertType == FQ_AlertTypeActionAlert ? MidCornerRadius : self.configuration.cornerRadius;
        _alertContentView.layer.masksToBounds = YES;
        
        if (self.configuration.headerView) {
            [_alertContentView addSubview:self.configuration.headerView];
        }
        
        [self.textContentView addSubview:self.titleLabel];
        [self.textContentView addSubview:self.messageLabel];
        
        if (self.configuration.customView) {
            
            [self.textContentView addSubview:self.configuration.customView];
        }
        
        NSInteger count = 0;
        for (FQ_AlertAction *alertAction in self.actionArr) {
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = count + AlertActionTag;
            [self settingActionBtn:button action:alertAction];
            if (alertAction.actionType == FQ_AlertActionStyleCancel && self.alertType == FQ_AlertTypeActionSheet) {
                [_alertContentView addSubview:button];
            }else{
                [self.backEffectView.contentView addSubview:button];
            }
            count ++;
        }
        _alertContentView.alpha = 0;
    }
    return _alertContentView;
}

/**
 重新布局所有子view的视图
 */
- (void)subviewsValidateView{
    
    CGFloat width = [FQ_AlertView getAlertTypeWidth:self.alertType];
    CGFloat contentViewSumH = 0.0f;
    
    if (self.configuration.isNeedCoverBackView) {
        self.coverBtn.frame = KEY_WINDOW.bounds;
    }
    if (self.alertType == FQ_AlertTypeActionTop) {//顶部
        self.titleLabel.attributedText = [self getAttrWithTextStr:self.titleStr textFont:PFMediumFont(15) textColor:[UIColor blackColor] descrStr:self.messageStr descrFont:PFRegularFont(13) descrColor:RGBA(88, 87, 86, 1.0)];
        CGFloat titleH = [self.titleLabel sizeThatFits:CGSizeMake(width - self.configuration.fq_alertViewPaddingWidth * 2, MAXFLOAT)].height;
        self.titleLabel.frame = CGRectMake(self.configuration.fq_alertViewPaddingWidth,self.configuration.fq_alertViewPaddingHeight, width - self.configuration.fq_alertViewPaddingWidth * 2, titleH);
        
        contentViewSumH += CGRectGetMaxY(self.titleLabel.frame) + self.configuration.fq_alertViewPaddingHeight;
        self.textContentView.frame = CGRectMake(0, 0, width, contentViewSumH);
        self.configuration.alertTextContentBgView.frame = self.textContentView.bounds;
        
        for (int i = 0; i < self.actionArr.count; ++i) {
            UIButton * button = [self.alertContentView viewWithTag:i + AlertActionTag];
            button.frame = CGRectMake((self.configuration.separatorPadding + width / self.actionArr.count) * i, contentViewSumH + self.configuration.separatorPadding, width / self.actionArr.count - self.configuration.separatorPadding * 0.5, self.configuration.alertActionH);
        }
        CGFloat btnsSumH = self.configuration.alertActionH + self.configuration.separatorPadding;
        if (self.actionArr.count) {
            contentViewSumH += btnsSumH;
        }
        self.backEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.alertContentView.frame = CGRectMake((FQScreenW - width) * 0.5, KIsiPhoneX ? 34 : 20, width, contentViewSumH);
        
    }else{//中部-底部
        
        if (self.configuration.headerView) {
            self.configuration.headerView.frame = CGRectIntegral(CGRectMake(self.configuration.fq_alertViewPaddingWidth, self.configuration.headerView.frame.origin.y,width - 2 * self.configuration.fq_alertViewPaddingWidth, self.configuration.headerView.bounds.size.height));
            contentViewSumH += CGRectGetMaxY(self.configuration.headerView.frame);
        }
        
        if (self.titleStr.length > 0) {
            self.titleLabel.attributedText = [[NSAttributedString alloc]initWithString:self.titleStr attributes:[self textStyleWithAlignment:NSTextAlignmentCenter font:self.configuration.titleFont textColor:self.configuration.titleColor]];
            CGFloat titleH = [self.titleLabel sizeThatFits:CGSizeMake(width - 2* self.configuration.fq_alertViewPaddingWidth, MAXFLOAT)].height;
            CGFloat titleY = contentViewSumH > 0 ? contentViewSumH + self.configuration.fq_alertViewPaddingHeight : self.configuration.fq_alertViewTitlePaddingHeight;
            self.titleLabel.frame = CGRectIntegral(CGRectMake(self.configuration.fq_alertViewPaddingWidth, titleY,width - 2* self.configuration.fq_alertViewPaddingWidth , titleH));
            contentViewSumH = CGRectGetMaxY(self.titleLabel.frame);
        }
        
        if (self.messageStr.length > 0) {
            self.messageLabel.attributedText = [[NSAttributedString alloc]initWithString:self.messageStr attributes:[self textStyleWithAlignment:self.configuration.messageTextAlignment font:self.configuration.messageFont textColor:self.configuration.messageColor]];
            CGFloat messageH = [self.messageLabel sizeThatFits:CGSizeMake(width - 2* self.configuration.fq_alertViewContentPaddingWidth, MAXFLOAT)].height;
            
            CGFloat messageY = contentViewSumH > 0 ? contentViewSumH + self.configuration.fq_alertViewPaddingHeight : self.configuration.fq_alertViewTitlePaddingHeight;
            self.messageLabel.frame = CGRectIntegral(CGRectMake(self.configuration.fq_alertViewContentPaddingWidth, messageY ,width - 2* self.configuration.fq_alertViewContentPaddingWidth , messageH));
            
            contentViewSumH = CGRectGetMaxY(self.messageLabel.frame);
        }
        
        if (self.configuration.customView) {
            contentViewSumH += self.configuration.fq_alertViewPaddingHeight;
            CGFloat customViewH = self.configuration.customView.bounds.size.height;
            CGFloat customViewW = self.configuration.customView.bounds.size.width;
            CGFloat customViewX = self.configuration.customView.frame.origin.x;
            if (customViewW <= 0) {
                customViewW = width - 2 * self.configuration.fq_alertViewPaddingWidth;
                customViewX = self.configuration.fq_alertViewPaddingWidth;
            }
            self.configuration.customView.frame = CGRectIntegral(CGRectMake(customViewX, contentViewSumH,customViewW, customViewH));
            contentViewSumH += customViewH;
        }
        
        if (self.titleStr.length || self.messageStr.length) {
            contentViewSumH += 2 * self.configuration.fq_alertViewPaddingHeight;
        }
        
        self.textContentView.frame = CGRectMake(0, 0, width, contentViewSumH - 1);
        self.configuration.alertTextContentBgView.frame = self.textContentView.bounds;
        if (self.alertType == FQ_AlertTypeActionAlert){
            CGFloat btnsSumH = 0.0f;
            
            if ((self.actionArr.count == 2 || self.actionArr.count == 1) && self.configuration.hasAlertActionHorizontal == YES) {
                for (int i = 0; i < self.actionArr.count; ++i) {
                    UIButton * button = [self.alertContentView viewWithTag:i + AlertActionTag];
                    button.frame = CGRectMake((self.configuration.separatorPadding + width / self.actionArr.count) * i, contentViewSumH, width / self.actionArr.count - self.configuration.separatorPadding * 0.5, self.configuration.alertActionH);
                }
                btnsSumH = self.configuration.alertActionH;
            }else{
                for (int i = 0; i < self.actionArr.count; ++i) {
                    
                    UIButton * button = [self.alertContentView viewWithTag:i + AlertActionTag];
                    
                    if (self.actionArr.count == 1) {
                        button.frame = CGRectMake(0, contentViewSumH, width, self.configuration.alertActionH);
                        btnsSumH = self.configuration.alertActionH;
                    }else{
                        button.frame = CGRectMake(MidActionMargin, contentViewSumH + i * (self.configuration.alertActionH + self.configuration.separatorPadding), width - MidActionMargin * 2.0, self.configuration.alertActionH);
                        btnsSumH = self.configuration.alertActionH * self.actionArr.count + self.configuration.separatorPadding * (self.actionArr.count - 1);
                        button.layer.masksToBounds = YES;
                        button.layer.cornerRadius = self.alertType == FQ_AlertTypeActionAlert ? MidCornerRadius : self.configuration.cornerRadius;
                    }
                }
                btnsSumH += (self.actionArr.count > 1 ? self.configuration.separatorPadding : 0);//如果是两种样式则使用10个间距
            }
            contentViewSumH += btnsSumH ;
            
            self.backEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.alertContentView.frame = CGRectMake(0,0, width, contentViewSumH- 1);
            self.alertContentView.center = CGPointMake(FQScreenW * 0.5,FQScreenH * 0.5);
            
            //这里需要分两种样式 - 一种就是contentTextView包含按钮.还有一种是contentTextView不包含按钮样式.只有当不包含且为两个action时生效
            if (self.configuration.hasAlertActionHorizontal == NO) {//如果是纵向.则contentView包含action高度.否则不包含
                self.textContentView.frame = CGRectMake(0, 0, width, contentViewSumH - 1);
            }
            
            self.configuration.alertTextContentBgView.frame = self.textContentView.bounds;
            
            self.cancelBtn.hidden = NO;
            CGFloat alertW = [FQ_AlertView getAlertTypeWidth:self.alertType];
            if (self.configuration.cancelBtnType == FQ_AlertCancelBtnType_None) {
                self.cancelBtn.hidden = YES;
            }else if(self.configuration.cancelBtnType == FQ_AlertCancelBtnType_Normal){
                self.cancelBtn.frame = CGRectMake(alertW- 4 - 28, 4, 28, 28);
                [self.textContentView addSubview:self.cancelBtn];
            }else if(self.configuration.cancelBtnType == FQ_AlertCancelBtnType_TopRight){
                CGFloat cancelBtnY = (FQScreenH - contentViewSumH) * 0.5 - 32 - 24;
                CGFloat cancelBtnX = CGRectGetMaxX(self.alertContentView.frame) - 32;
                self.cancelBtn.frame = CGRectMake(cancelBtnX, cancelBtnY, 32, 32);
                [self.coverBtn addSubview:self.cancelBtn];
            }else if(self.configuration.cancelBtnType == FQ_AlertCancelBtnType_Bottom){
                CGFloat cancelBtnY = CGRectGetMaxY(self.alertContentView.frame) + 24;
                CGFloat cancelBtnX = (FQScreenW - 32) * 0.5;
                self.cancelBtn.frame = CGRectMake(cancelBtnX,cancelBtnY, 32, 32);
                [self.coverBtn addSubview:self.cancelBtn];
            }
            
        }else{
            
            CGFloat btnsSumH = 0.0f;
            BOOL isCancel = NO;
            for (int i = 0; i < self.actionArr.count; ++i) {
                UIButton * button = [self.alertContentView viewWithTag:i + AlertActionTag];
                FQ_AlertAction *alertAction = self.actionArr[i];
                if (self.configuration.actionBtnTextType == FQ_AlertActionButtonTextType_TextWH){
                    CGFloat btnH = [self getButtonWithSize:button sizeThatFits:CGSizeMake(width - 20, CGFLOAT_MAX)].height + self.configuration.fq_alertViewPaddingHeight * 2;
                    btnH = MAX(self.configuration.alertActionH, btnH);
                    //根据文本宽高.计算按钮的高度
                    if (alertAction.actionType != FQ_AlertActionStyleCancel) {
                        button.frame = CGRectMake(0, contentViewSumH + btnsSumH, width, btnH);
                        btnsSumH += btnH + self.configuration.separatorPadding;
                        
                    }else{
                        
                        self.backEffectView.frame = CGRectMake(0, 0, width, contentViewSumH + btnsSumH - self.configuration.separatorPadding);
                        button.frame = CGRectMake(0, contentViewSumH + btnsSumH + 5, width, btnH);
                        btnsSumH += btnH + 5;
                        button.layer.cornerRadius = self.alertType == FQ_AlertTypeActionAlert ? MidCornerRadius : self.configuration.cornerRadius;
                        button.layer.masksToBounds = YES;
                        isCancel = YES;
                    }
                }else{
                    if (alertAction.actionType != FQ_AlertActionStyleCancel) {
                        
                        button.frame = CGRectMake(0, contentViewSumH + btnsSumH, width, self.configuration.alertActionH);
                        btnsSumH += self.configuration.alertActionH + self.configuration.separatorPadding;
                        
                    }else{
                        self.backEffectView.frame = CGRectMake(0, 0, width, contentViewSumH + btnsSumH - self.configuration.separatorPadding);//其他增加了一次
                        button.frame = CGRectMake(0, contentViewSumH + btnsSumH + 5, width, self.configuration.alertActionH);
                        btnsSumH += self.configuration.alertActionH + 5;
                        button.layer.cornerRadius = self.alertType == FQ_AlertTypeActionAlert ? MidCornerRadius : self.configuration.cornerRadius;
                        button.layer.masksToBounds = YES;
                        isCancel = YES;
                    }
                }
            }
            contentViewSumH += btnsSumH;
            
            CGFloat iphoneXBottomMargin = KIsiPhoneX ? 34 : 10;
            
            self.alertContentView.frame = CGRectMake((FQScreenW - width) * 0.5, FQScreenH - contentViewSumH - iphoneXBottomMargin, width, contentViewSumH);
            if (!isCancel) {
                self.backEffectView.frame = self.alertContentView.bounds;
                
            }
        }
    }
}


#pragma mark - 初始化控件

-(UIVisualEffectView *)backEffectView
{
    if (!_backEffectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:self.configuration.blurEffectStyle];
        _backEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        //        _backEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _backEffectView;
}

-(UIView *)textContentView
{
    if (!_textContentView) {
        _textContentView = [[UIView alloc]init];
        _textContentView.backgroundColor = self.configuration.textContentBgColor;
        //如果有背景视图.则使用文本描述背景视图
        if (self.configuration.alertTextContentBgView) {
            [_textContentView addSubview:self.configuration.alertTextContentBgView];
        }
    }
    return _textContentView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

-(UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

-(UIButton *)coverBtn
{
    if (!_coverBtn) {
        _coverBtn = [[UIButton alloc]initWithFrame:KEY_WINDOW.bounds];
        _coverBtn.backgroundColor = self.configuration.coverBackgroundColor;
        [_coverBtn addTarget:self action:@selector(clickClearCoverView) forControlEvents:UIControlEventTouchUpInside];
        _coverBtn.alpha = 0;
        
    }
    return _coverBtn;
}

-(UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        
        UIImage * cancelImg = [UIImage imageNamed:@"icon28_icon_top_cancel"];
        if (self.configuration.cancelImg && self.configuration.cancelImg.length > 0) {
            cancelImg = [UIImage imageNamed:self.configuration.cancelImg];
        }
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_cancelBtn setImage:cancelImg forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake([FQ_AlertView getAlertTypeWidth:self.alertType] - 4 - 28, 4, 28, 28);
        [_cancelBtn addTarget:self action:@selector(fq_performSelectorClickTopAlertView) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.hidden = YES;
    }
    return _cancelBtn;
}

-(NSMutableArray *)actionArr
{
    if (!_actionArr) {
        _actionArr = [NSMutableArray array];
    }
    return _actionArr;
}

@end

