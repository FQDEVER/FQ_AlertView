
# FQ_AlertView
[![Version](https://img.shields.io/cocoapods/v/FQ_AlertView.svg?style=flat)](http://cocoapods.org/pods/FQ_AlertView)
[![License](https://img.shields.io/cocoapods/l/FQ_AlertView.svg?style=flat)](http://cocoapods.org/pods/FQ_AlertView)
[![Platform](https://img.shields.io/cocoapods/p/FQ_AlertView.svg?style=flat)](http://cocoapods.org/pods/FQ_AlertView)

**效果图**

 
![FQ_AlertTipView.gif](https://upload-images.jianshu.io/upload_images/2100495-fb54913b8d5bbb0d.gif?imageMogr2/auto-orient/strip)

**前言:只是刚好看到别人App自定义的弹框挺不错.自己花点时间封装了一下.支持横竖屏切换!**

**介绍:**
   
     -------------------提示框样式----------------------
       typedef NS_ENUM (NSInteger, FQ_AlertType)
      {
      FQ_AlertTypeActionAlert = 0 ,  //中间
      FQ_AlertTypeActionTop ,        //顶部
      FQ_AlertTypeActionSheet,       //底部
      };

     -------------------Action样式----------------------
     typedef NS_ENUM (NSInteger, FQ_AlertActionType)
    {
    FQ_AlertActionStyleDefault = 0, //默认样式
    FQ_AlertActionStyleConfirm,     //确定样式
    FQ_AlertActionStyleDestructive,  //慎重样式
    FQ_AlertActionStyleCancel  //取消样式
     };  


**主要三个类:**

1.配置类:`FQ_AlertConfiguration`.如果需要丰富.可以添加什么文字边距等.我做了默认处理

     //FQ_AlertActionStyleDefault = 0, //默认样式
      @property (strong, nonatomic) UIColor *defaultTextColor;
      @property (strong, nonatomic) UIColor *defaultBackgroundColor;
      @property (strong, nonatomic) UIFont  *defaultTextFont;`
      ......
      @property (assign, nonatomic) CGFloat cornerRadius;
      // 默认的配置项.类属性.(苹果兼容swift添加的属性)
      @property (class, nonatomic)  FQ_AlertConfiguration *defaultConfiguration;

2.响应控件配置类:`FQ_AlertAction`.其实就是按钮

      `  //初始化.
        + (instancetype)actionWithTitle:( NSString *)title type:(FQ_AlertActionType)actionType handler:(void (^)(FQ_AlertAction *action))handler;`

3.展示类:`FQ_AlertView`.

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
                             actionBlock:(void(^)(FQ_AlertAction * action))actionBlock;


**其他类**

1.管理类:`FQ_AlertViewManager`.保证当前界面只显示一个FQAlertView控件.一般情况下没有同时出现的情况.

2.工具类:`FQ_AlertWindowVc`.弹框ContentView使用UIWindow.在处理横竖屏切换时用到.

**使用:**

1.快捷创建方式:一句代码搞定

        [FQ_AlertView showAlertViewWithTitle:@"可以的"  message:@"取消关注以后!您将再也收不到该用户的所有动态?"  alertType:FQ_AlertTypeActionSheet confirmActionStr:@"确定" otherActionStrArr:nil destructiveActionStr:nil cancelActionStr:@"取消" configuration:nil actionBlock:^(FQ_AlertAction *action) {
            NSLog(@"action= %@",action.title); //根据字符串比较找到对应的Action事件做处理
           }];

2.自定义方式创建:(借鉴苹果创建方式)

        FQ_AlertView * alertView =  [FQ_AlertView showAlertViewWithTitle:@"确定?" message:@"随便打得XXXXXXXXXXXXXXXXXXXX,可以吗?" alertType:FQ_AlertTypeActionSheet configuration:nil];
        FQ_AlertAction * test = [FQ_AlertAction actionWithTitle:@"拍摄" type:FQ_AlertActionStyleConfirm handler:^(FQ_AlertAction *action) {
            NSLog(@"点击拍摄");
        }];
        FQ_AlertAction * test1 = [FQ_AlertAction actionWithTitle:@"从手机相册选择" type:FQ_AlertActionStyleConfirm handler:^(FQ_AlertAction *action) {
            NSLog(@"点击从手机相册选择");
        }];
        FQ_AlertAction * test2 = [FQ_AlertAction actionWithTitle:@"取消" type:FQ_AlertActionStyleCancel handler:^(FQ_AlertAction *action) {
            NSLog(@"点击取消");
        }];
        [alertView addAction:test];
        [alertView addAction:test1];
        [alertView addAction:test2];
        [alertView showAlertView];

END:暂未上传至github账号!需要请留言!


