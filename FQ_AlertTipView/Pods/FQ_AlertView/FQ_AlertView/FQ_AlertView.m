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
CGFloat const FQAlertViewPaddingWidth = 10.0;
CGFloat const FQAlertViewPaddingHeight = 8.0;
CGFloat const FQAlertViewTitlePaddingHeight = 20.0;
CGFloat const FQAlertViewContentPaddingWidth = 16.0;

-(instancetype)init
{
    if (self = [super init]) {
        self.defaultTextColor = DefaultTextColor;
        self.defaultTextFont = [UIFont systemFontOfSize:18.0];// RegularFont(TitleFontSize);
        self.defaultBackgroundColor = OtherActionBackColor;
        
        self.confirmTextColor = ConfirmTextColor;
        self.confirmTextFont = [UIFont systemFontOfSize:18.0];// RegularFont(TitleFontSize);
        self.confirmBackgroundColor = OtherActionBackColor;
        
        self.destructiveTextColor = DestructiveTextColor;
        self.destructiveTextFont =[UIFont systemFontOfSize:18.0];// RegularFont(TitleFontSize);
        self.destructiveBackgroundColor = OtherActionBackColor;
        
        self.cancelTextColor = CancelTextColor;
        self.cancelTextFont = [UIFont boldSystemFontOfSize:18.0];//RegularFont(TitleFontSize);
        self.cancelBackgroundColor =  CancelBackgroundColor;
        
        self.cornerRadius = TipCornerRadius;
        self.isClickClear = YES;
        self.messageTextAlignment = NSTextAlignmentCenter;
        self.titleFont = [UIFont boldSystemFontOfSize:18.0]; //SemiboldFont(TitleFontSize);
        self.messageFont = [UIFont systemFontOfSize:14.0]; //RegularFont(ContentFontSize);
        self.titleColor = TitleTextColor;
        self.messageColor = MessageTextColor;
        self.alertTipDefaultFont = [UIFont systemFontOfSize:14.0];
        self.alertTipCancelFont = [UIFont boldSystemFontOfSize:14.0];
        self.actionBtnTextType = FQ_AlertActionButtonTextType_FixedWH_FitWidth;
        self.coverBackgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        self.isNeedCoverBackView =  YES;
        self.separatorPadding = 1.0f;
        self.actionBtnType = FQ_AlertActionButtonType_Default;
        self.alertActionH = 0;
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
        [alert fq_clickCoverView];
    }
    [[FQ_AlertViewManager shareManager].alertViewArr addObject:alertView];
    
    alertView.titleStr = title;
    alertView.messageStr = message;
    alertView.alertType = alertType;
    alertView.configuration = configuration ? :FQ_AlertConfiguration.defaultConfiguration;
    
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

/**
 如果有.即隐藏.没有就不隐藏
 */
+ (void)hidden
{
    for (FQ_AlertView * alert in [FQ_AlertViewManager shareManager].alertViewArr) {
        [alert fq_clickCoverView];
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
            [self performSelector:@selector(fq_clickCoverView) withObject:nil afterDelay:2.6];
        }
    }];
}

-(void)hiddenAlertAnimation:(BOOL)animation{
    //只允许存在一个
    [UIView animateWithDuration:animation ? 0.5 :0 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:0 animations:^{
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
    }];
}

#pragma mark ============ 响应事件 ==============

/**
 点击遮盖View
 */
-(void)fq_clickCoverView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fq_clickCoverView) object:nil];
    [self hiddenAlertAnimation:YES];
    [[FQ_AlertViewManager shareManager].alertViewArr removeAllObjects];
}


/**
 点击遮盖view.
 */
-(void)clickClearCoverView
{
    if (self.configuration.isClickClear) {
        [self fq_clickCoverView];
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
    [self fq_clickCoverView];
    if (alertAction.actionBlock) {
        alertAction.actionBlock(alertAction,alertBtn.tag- AlertActionTag);
    }
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
    //默认的高亮色.
    if (self.configuration.actionBtnType == FQ_AlertActionButtonType_CornerRadius) {
        //只有取消样式才是这种效果
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }else{
        [button setBackgroundImage:[self imageWithColor:[[UIColor whiteColor]colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
    }
    switch (alertAction.actionType) {
        case FQ_AlertActionStyleDefault: //默认样式
        {
            [button setTitleColor:self.configuration.defaultTextColor forState:UIControlStateNormal];
            button.titleLabel.font = self.alertType == FQ_AlertTypeActionTop ? self.configuration.alertTipDefaultFont : self.configuration.defaultTextFont;
            [button setBackgroundImage:[self imageWithColor:self.configuration.defaultBackgroundColor] forState:UIControlStateNormal];
            break;
        }
        case FQ_AlertActionStyleConfirm:  //确定样式
        {
            [button setTitleColor:self.configuration.confirmTextColor forState:UIControlStateNormal];
            button.titleLabel.font = self.alertType == FQ_AlertTypeActionTop ? self.configuration.alertTipDefaultFont : self.configuration.confirmTextFont;
            [button setBackgroundImage:[self imageWithColor:self.configuration.confirmBackgroundColor] forState:UIControlStateNormal];
            break;
        }
        case FQ_AlertActionStyleDestructive: //慎重样式
        {
            [button setTitleColor:self.configuration.destructiveTextColor forState:UIControlStateNormal];
            button.titleLabel.font = self.alertType == FQ_AlertTypeActionTop ? self.configuration.alertTipDefaultFont : self.configuration.destructiveTextFont;
            [button setBackgroundImage:[self imageWithColor:self.configuration.destructiveBackgroundColor] forState:UIControlStateNormal];
            break;
        }
        case FQ_AlertActionStyleCancel: //取消样式
        {
            [button setTitleColor:self.configuration.cancelTextColor forState:UIControlStateNormal];
            button.titleLabel.font = self.alertType == FQ_AlertTypeActionTop ? self.configuration.alertTipCancelFont : self.configuration.cancelTextFont;
            [button setBackgroundImage:[self imageWithColor:self.configuration.cancelBackgroundColor] forState:UIControlStateNormal];
            
            //只有取消样式才是这种效果
            [button setBackgroundImage:[self imageWithColor:self.configuration.cancelTextColor] forState:UIControlStateHighlighted];
            [button setTitleColor:self.configuration.cancelBackgroundColor forState:UIControlStateHighlighted];
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
        [self.backEffectView.contentView addSubview:self.textContentView];
        [_alertContentView addSubview:self.backEffectView];
        if (self.configuration.isNeedCoverBackView) {
            [self.coverBtn addSubview:_alertContentView];
            [KEY_WINDOW addSubview:self.coverBtn];
        }else{
            [KEY_WINDOW addSubview:_alertContentView];
        }
    
        _backEffectView.layer.cornerRadius = self.configuration.cornerRadius;
        _backEffectView.layer.masksToBounds = YES;
        
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
        self.titleLabel.attributedText = [self getAttrWithTextStr:self.titleStr textFont:SemiboldFont(15) textColor:[UIColor blackColor] descrStr:self.messageStr descrFont:RegularFont(13) descrColor:RGBA(88, 87, 86, 1.0)];
        CGFloat titleH = [self.titleLabel sizeThatFits:CGSizeMake(width - FQAlertViewPaddingWidth * 2, MAXFLOAT)].height;
        self.titleLabel.frame = CGRectMake(FQAlertViewPaddingWidth,FQAlertViewPaddingHeight, width - FQAlertViewPaddingWidth * 2, titleH);
        
        contentViewSumH += CGRectGetMaxY(self.titleLabel.frame) + FQAlertViewPaddingHeight;
        self.textContentView.frame = CGRectMake(0, 0, width, contentViewSumH);
        
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
            self.configuration.headerView.frame = CGRectIntegral(CGRectMake(FQAlertViewPaddingWidth, self.configuration.headerView.frame.origin.y,width - 2 * FQAlertViewPaddingWidth, self.configuration.headerView.bounds.size.height));
            contentViewSumH += CGRectGetMaxY(self.configuration.headerView.frame);
        }
        
        if (self.titleStr.length > 0) {
            self.titleLabel.attributedText = [[NSAttributedString alloc]initWithString:self.titleStr attributes:[self textStyleWithAlignment:NSTextAlignmentCenter font:self.configuration.titleFont textColor:self.configuration.titleColor]];
            CGFloat titleH = [self.titleLabel sizeThatFits:CGSizeMake(width - 2* FQAlertViewPaddingWidth, MAXFLOAT)].height;
            CGFloat titleY = contentViewSumH > 0 ? contentViewSumH + FQAlertViewPaddingHeight : FQAlertViewTitlePaddingHeight;
            self.titleLabel.frame = CGRectIntegral(CGRectMake(FQAlertViewPaddingWidth, titleY,width - 2* FQAlertViewPaddingWidth , titleH));
            contentViewSumH = CGRectGetMaxY(self.titleLabel.frame);
        }
        
        if (self.messageStr.length > 0) {
            self.messageLabel.attributedText = [[NSAttributedString alloc]initWithString:self.messageStr attributes:[self textStyleWithAlignment:self.configuration.messageTextAlignment font:self.configuration.messageFont textColor:self.configuration.messageColor]];
            CGFloat messageH = [self.messageLabel sizeThatFits:CGSizeMake(width - 2* FQAlertViewContentPaddingWidth, MAXFLOAT)].height;
            
            CGFloat messageY = contentViewSumH > 0 ? contentViewSumH + FQAlertViewPaddingHeight : FQAlertViewTitlePaddingHeight;
            self.messageLabel.frame = CGRectIntegral(CGRectMake(FQAlertViewContentPaddingWidth, messageY ,width - 2* FQAlertViewContentPaddingWidth , messageH));
            
            contentViewSumH = CGRectGetMaxY(self.messageLabel.frame);
        }
        
        if (self.configuration.customView) {
            contentViewSumH += FQAlertViewPaddingHeight;
            CGFloat customViewH = self.configuration.customView.bounds.size.height;
            CGFloat customViewW = self.configuration.customView.bounds.size.width;
            CGFloat customViewX = self.configuration.customView.frame.origin.x;
            if (customViewW <= 0) {
                customViewW = width - 2 * FQAlertViewPaddingWidth;
                customViewX = FQAlertViewPaddingWidth;
            }
            self.configuration.customView.frame = CGRectIntegral(CGRectMake(customViewX, contentViewSumH,customViewW, customViewH));
            contentViewSumH += customViewH;
        }
        
        if (self.titleStr.length || self.messageStr.length) {
            contentViewSumH += 2 * FQAlertViewPaddingHeight;
        }else{
//            contentViewSumH = 2 * FQAlertViewPaddingHeight;//在都没有时.不需要间距
        }
        
        self.textContentView.frame = CGRectMake(0, 0, width, contentViewSumH - self.configuration.separatorPadding);
        
        if (self.alertType == FQ_AlertTypeActionAlert){
            CGFloat btnsSumH = 0.0f;
            
            BOOL isActionAlertLarget = NO;
            if (self.actionArr.count == 2 && self.configuration.actionBtnTextType == FQ_AlertActionButtonTextType_TextWH) {
                 UIButton * firstBtn = [self.alertContentView viewWithTag:0 + AlertActionTag];
                 UIButton * secondBtn = [self.alertContentView viewWithTag:1 + AlertActionTag];
                CGFloat firstBtnH = [self getButtonWithSize:firstBtn sizeThatFits:CGSizeMake(width - 20, CGFLOAT_MAX)].height + FQAlertViewPaddingHeight * 2;
                CGFloat secondBtnH = [self getButtonWithSize:secondBtn sizeThatFits:CGSizeMake(width - 20, CGFLOAT_MAX)].height + FQAlertViewPaddingHeight * 2;
                isActionAlertLarget = firstBtnH > self.configuration.alertActionH || secondBtnH > self.configuration.alertActionH;
            }
            
            for (int i = 0; i < self.actionArr.count; ++i) {
                
                UIButton * button = [self.alertContentView viewWithTag:i + AlertActionTag];
                
                if (self.configuration.actionBtnTextType == FQ_AlertActionButtonTextType_TextWH){
                    //计算其高度
                    if (self.actionArr.count == 1) {
                        //上下间距为22.
                        CGFloat btnH = [self getButtonWithSize:button sizeThatFits:CGSizeMake(width - 20, CGFLOAT_MAX)].height + FQAlertViewPaddingHeight * 2;
                        btnH = MAX(self.configuration.alertActionH, btnH);
                        button.frame = CGRectMake(0, contentViewSumH, width, btnH);
                        btnsSumH = btnH;
                    }else if(self.actionArr.count == 2){
                        if (isActionAlertLarget) {
                            CGFloat btnH = [self getButtonWithSize:button sizeThatFits:CGSizeMake(width - 20, CGFLOAT_MAX)].height + FQAlertViewPaddingHeight * 2;
                            btnH = MAX(self.configuration.alertActionH, btnH);
                            button.frame = CGRectMake(0, contentViewSumH + btnsSumH, width, btnH);
                            btnsSumH += (btnH + self.configuration.separatorPadding);
                        }else{
                            
                            if (self.configuration.actionBtnType == FQ_AlertActionButtonType_CornerRadius) {
                                button.layer.masksToBounds = YES;
                                button.layer.cornerRadius = self.configuration.alertActionH * 0.5;
                                button.layer.borderColor = button.currentTitleColor.CGColor;
                                button.layer.borderWidth = 1.0;
                                
                                button.frame = CGRectMake(i == 0 ? FQAlertViewContentPaddingWidth : (width  * 0.5 + FQAlertViewContentPaddingWidth * 0.5), contentViewSumH, width * 0.5 - FQAlertViewContentPaddingWidth * 1.5, self.configuration.alertActionH);
                                btnsSumH = self.configuration.alertActionH + FQAlertViewTitlePaddingHeight;
                                
                                self.textContentView.frame = CGRectMake(0, 0, width, contentViewSumH + btnsSumH);
                            }else{
                                button.frame = CGRectMake(i == 0 ? 0 : (width  * 0.5 + self.configuration.separatorPadding * 0.5), contentViewSumH, width * 0.5 - self.configuration.separatorPadding * 0.5, self.configuration.alertActionH);
                                btnsSumH = self.configuration.alertActionH ;
                            }
                        }
                    }else{
                        
                        CGSize size = [self getButtonWithSize:button sizeThatFits:CGSizeMake(width - 20, CGFLOAT_MAX)];
                        CGFloat btnH = size.height + FQAlertViewPaddingHeight * 2;
                        btnH = MAX(self.configuration.alertActionH, btnH);
                        button.frame = CGRectMake(0, contentViewSumH + btnsSumH, width, btnH);
                        btnsSumH += (btnH + self.configuration.separatorPadding);
                    }
                }else{
                    if (self.actionArr.count == 1) {
                        button.frame = CGRectMake(0, contentViewSumH, width, self.configuration.alertActionH);
                        btnsSumH = self.configuration.alertActionH;
                    }else if(self.actionArr.count == 2){
                        button.frame = CGRectMake(i == 0 ? 0 : (width  * 0.5 + self.configuration.separatorPadding * 0.5), contentViewSumH, width * 0.5 - self.configuration.separatorPadding * 0.5, self.configuration.alertActionH);
                        btnsSumH = self.configuration.alertActionH ;
                    }else{
                        button.frame = CGRectMake(0, contentViewSumH + i * (self.configuration.alertActionH + self.configuration.separatorPadding), width, self.configuration.alertActionH);
                        btnsSumH = self.configuration.alertActionH * self.actionArr.count + 1 * (self.actionArr.count - self.configuration.separatorPadding);
                    }
                }
            }
            contentViewSumH += btnsSumH;
            
            self.backEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.alertContentView.frame = CGRectMake(0,0, width, contentViewSumH - self.configuration.separatorPadding);
            self.alertContentView.center = CGPointMake(FQScreenW * 0.5,FQScreenH * 0.5);
            
        }else{
        
            CGFloat btnsSumH = 0.0f;
            BOOL isCancel = NO;
            for (int i = 0; i < self.actionArr.count; ++i) {
                UIButton * button = [self.alertContentView viewWithTag:i + AlertActionTag];
                FQ_AlertAction *alertAction = self.actionArr[i];
                if (self.configuration.actionBtnTextType == FQ_AlertActionButtonTextType_TextWH){
                    CGFloat btnH = [self getButtonWithSize:button sizeThatFits:CGSizeMake(width - 20, CGFLOAT_MAX)].height + FQAlertViewPaddingHeight * 2;
                    btnH = MAX(self.configuration.alertActionH, btnH);
                    //根据文本宽高.计算按钮的高度
                    if (alertAction.actionType != FQ_AlertActionStyleCancel) {
                        button.frame = CGRectMake(0, contentViewSumH + btnsSumH, width, btnH);
                        btnsSumH += btnH + self.configuration.separatorPadding;
                        
                    }else{
                        
                        self.backEffectView.frame = CGRectMake(0, 0, width, contentViewSumH + btnsSumH - self.configuration.separatorPadding);
                        button.frame = CGRectMake(0, contentViewSumH + btnsSumH + 5, width, btnH);
                        btnsSumH += btnH + 5;
                        button.layer.cornerRadius = self.configuration.cornerRadius;
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
                        button.layer.cornerRadius = self.configuration.cornerRadius;
                        button.layer.masksToBounds = YES;
                        isCancel = YES;
                    }
                }
            }
            contentViewSumH += btnsSumH;
            
            CGFloat iphoneXBottomMargin = KIsiPhoneX ? 34 : 0;
            
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
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _backEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        _backEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _backEffectView;
}

-(UIView *)textContentView
{
    if (!_textContentView) {
        _textContentView = [[UIView alloc]init];
        _textContentView.backgroundColor = BackViewBackgroundColor;
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

-(NSMutableArray *)actionArr
{
    if (!_actionArr) {
        _actionArr = [NSMutableArray array];
    }
    return _actionArr;
}

@end

