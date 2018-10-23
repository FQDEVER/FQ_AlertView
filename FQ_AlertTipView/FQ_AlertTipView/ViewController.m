//
//  ViewController.m
//  FQ_AlertController
//
//  Created by mac on 2017/8/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"
#import "FQ_AlertView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController


#pragma mark ============ 测试屏幕旋转 ==============
//设置样式
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}

////设置是否隐藏
//- (BOOL)prefersStatusBarHidden {
//    return NO;
//}
//
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
//}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
- (BOOL)shouldAutorotate
{
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

-(NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = @[
                     @{@"顶部显示":@"icon_acceleration"},
                     @{@"中间显示Type-FixedWH_FitWidth":@"icon_pip"},
                     @{@"中间显示Type-FixedWH_None":@"icon_spring"},
                     @{@"中间显示Type-TextWH":@"icon_rotation"},
                     @{@"底部显示Type-FixedWH_FitWidth":@"icon_momentum"},
                     @{@"底部显示Type-FixedWH_None":@"icon_rubber"},
                     @{@"底部显示Type-TextWH":@"icon_flash"},
                     @{@"自定义View1":@"icon_calc"},
                     @{@"自定义View2":@"icon_calc"},
                     @{@"自定义底部View1":@"icon_calc"},
                     @{@"自定义底部View2":@"icon_calc"},
                     @{@"自定义底部View3":@"icon_calc"},
                     @{@"自定义底部View4":@"icon_calc"},
                     ];
    }
    return _dataArr;
}

#pragma -mark UITableView数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //添加三种样式
    UITableViewCell * tableviewCell = [tableView dequeueReusableCellWithIdentifier:@"AlertController" forIndexPath:indexPath];
    tableviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dict = self.dataArr[indexPath.row];
    tableviewCell.textLabel.text = dict.allKeys.firstObject;
    tableviewCell.imageView.image = [UIImage imageNamed:dict.allValues.firstObject];
    tableviewCell.textLabel.textColor = [UIColor whiteColor];
    tableviewCell.accessoryType   =  UITableViewCellAccessoryDisclosureIndicator;
    tableviewCell.backgroundColor = [UIColor blackColor];
    tableviewCell.textLabel.font = RegularFont(18);
    
    return tableviewCell;
}


#pragma -mark UITableView代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //样式一
    if (indexPath.row == 0 ) {
        FQ_AlertConfiguration *configuration = FQ_AlertConfiguration.defaultConfiguration;
        configuration.isNeedCoverBackView = NO;
        FQ_AlertView * alertView = [FQ_AlertView showAlertViewWithTitle:@"title" message:@"message" alertType:FQ_AlertTypeActionTop configuration:configuration];
        
        FQ_AlertAction * test = [FQ_AlertAction actionWithTitle:@"查看" type:FQ_AlertActionStyleCancel handler:^(FQ_AlertAction *action, NSInteger index) {
            NSLog(@"点击确定");
        }];
        FQ_AlertAction * test1 = [FQ_AlertAction actionWithTitle:@"取消" type:FQ_AlertActionStyleCancel handler:^(FQ_AlertAction *action, NSInteger index) {
            NSLog(@"点击取消");
        }];
        [alertView addAction:test];
        [alertView addAction:test1];
        [alertView showAlertView];
        
    }else if(indexPath.row == 1){
        FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
        alertConfiguration.actionBtnTextType = FQ_AlertActionButtonTextType_FixedWH_FitWidth;
        alertConfiguration.coverBackgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        [FQ_AlertView showAlertViewWithTitle:@"可以的"  message:@"取消关注以后!您将再也收不到该用户的所有动态?"  alertType:FQ_AlertTypeActionAlert confirmActionStr:@"确定没骂你发送到,范士大夫,电视剧啊" otherActionStrArr:nil destructiveActionStr:nil cancelActionStr:@"取消发生发发呆时" configuration:alertConfiguration actionBlock:^(FQ_AlertAction *action, NSInteger index) {
            NSLog(@"action= %@",action.title); //根据字符串比较找到对应的Action事件做处理
        }];
    }else if(indexPath.row == 2){
        FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
        alertConfiguration.actionBtnTextType = FQ_AlertActionButtonTextType_FixedWH_None;
        [FQ_AlertView showAlertViewWithTitle:@"可以的"  message:nil  alertType:FQ_AlertTypeActionAlert confirmActionStr:@"确定没骂你发送到,范士大夫,电视剧啊" otherActionStrArr:nil destructiveActionStr:nil cancelActionStr:@"取消发生发发呆时" configuration:alertConfiguration actionBlock:^(FQ_AlertAction *action, NSInteger index) {
            NSLog(@"action= %@",action.title); //根据字符串比较找到对应的Action事件做处理
        }];
    }else if(indexPath.row == 3){
        FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
        alertConfiguration.actionBtnTextType = FQ_AlertActionButtonTextType_TextWH;
        [FQ_AlertView showAlertViewWithTitle:nil  message:@"取消关注以后!您将再也收不到该用户的所有动态?"  alertType:FQ_AlertTypeActionAlert confirmActionStr:@"确定没骂你发送到,范士大夫,电视剧啊" otherActionStrArr:nil destructiveActionStr:nil cancelActionStr:@"取消发生发发呆时" configuration:alertConfiguration actionBlock:^(FQ_AlertAction *action, NSInteger index) {
            NSLog(@"action= %@",action.title); //根据字符串比较找到对应的Action事件做处理
        }];
    }else if(indexPath.row == 4){
        FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
        alertConfiguration.actionBtnTextType = FQ_AlertActionButtonTextType_FixedWH_FitWidth;
        [FQ_AlertView showAlertViewWithTitle:@"可以的"  message:@"取消关注以后!您将再也收不到该用户的所有动态?取消关注以后!您将再也收不到该用户的所有动态?"  alertType:FQ_AlertTypeActionSheet confirmActionStr:@"确定没骂你发送到,范士大夫,电视剧啊确定没骂你发送到,范士大夫,电视剧啊" otherActionStrArr:nil destructiveActionStr:@"从手机相册选择了盛大交付了" cancelActionStr:@"取消发生发发呆时" configuration:alertConfiguration actionBlock:^(FQ_AlertAction *action, NSInteger index) {
            NSLog(@"action= %@",action.title); //根据字符串比较找到对应的Action事件做处理
        }];
    }else if(indexPath.row == 5){
        FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
        alertConfiguration.actionBtnTextType = FQ_AlertActionButtonTextType_FixedWH_None;
        [FQ_AlertView showAlertViewWithTitle:@"可以的"  message:nil  alertType:FQ_AlertTypeActionSheet confirmActionStr:@"确定没骂你发送到,范士大夫,电视剧啊确定没骂你发送到,范士大夫,电视剧啊" otherActionStrArr:nil destructiveActionStr:@"从手机相册选择了盛大交付了" cancelActionStr:@"取消发生发发呆时" configuration:alertConfiguration actionBlock:^(FQ_AlertAction *action, NSInteger index) {
            NSLog(@"action= %@",action.title); //根据字符串比较找到对应的Action事件做处理
        }];
    }else if(indexPath.row == 6){
        FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
        alertConfiguration.actionBtnTextType = FQ_AlertActionButtonTextType_TextWH;
        [FQ_AlertView showAlertViewWithTitle:@"可以的"  message:nil  alertType:FQ_AlertTypeActionSheet confirmActionStr:@"确定没骂你发送到,范士大夫,电视剧啊确定没骂你发送到,范士大夫,电视剧啊" otherActionStrArr:nil destructiveActionStr:@"从手机相册选择了盛大交付了" cancelActionStr:@"取消发生发发呆时" configuration:alertConfiguration actionBlock:^(FQ_AlertAction *action, NSInteger index) {
            NSLog(@"action= %@",action.title); //根据字符串比较找到对应的Action事件做处理
        }];
    }else if(indexPath.row == 7){
    
        UIImageView *logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ios_privacy_icon"]];
        logoImg.frame = CGRectMake(0, -132 * 0.5 + 10, 132, 132);
        logoImg.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"欢迎使用\"军拓运动\"！我们非常重视您的个人信息和隐私保护。在您使用\"军拓运动\"服务之前，请仔细阅读《军拓运动隐私政策》，我们将严格按照经您同意的各项条款使用您的个人信息，以便为您提供更好的服务。\n\n如您同意此政策，请点击\"同意\"并开始使用我们的产品和服务，我们会尽全力保护您的个人信息安全。\n";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor darkGrayColor];
        label.numberOfLines = 0;
        CGFloat alertW = [FQ_AlertView getAlertTypeWidth:FQ_AlertTypeActionAlert];
        CGFloat labelH = [label sizeThatFits:CGSizeMake(alertW - 16 * 2.0, CGFLOAT_MAX)].height;
        label.frame = CGRectMake(16, 0, alertW - 16 * 2.0, labelH);
        
        FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
        alertConfiguration.isClickClear = NO;
        alertConfiguration.actionBtnTextType = FQ_AlertActionButtonTextType_TextWH;
        alertConfiguration.headerView = logoImg;
        alertConfiguration.customView = label;
        alertConfiguration.separatorPadding = 0.0f;
        alertConfiguration.actionBtnType = FQ_AlertActionButtonType_CornerRadius;
        alertConfiguration.alertActionH = 32.0;
        
        alertConfiguration.defaultBackgroundColor = RGBA(0, 102, 204, 1.0);
        alertConfiguration.defaultTextColor = UIColor.whiteColor;
        alertConfiguration.defaultTextFont = [UIFont systemFontOfSize:13];
        alertConfiguration.confirmBackgroundColor = UIColor.whiteColor;
        alertConfiguration.confirmTextColor = UIColor.grayColor;
        alertConfiguration.confirmTextFont = [UIFont systemFontOfSize:13];
        
        [FQ_AlertView showAlertViewWithTitle:@"军拓运动隐私政策"  message:nil  alertType:FQ_AlertTypeActionAlert confirmActionStr:@"不同意" otherActionStrArr:@[@"同意"] destructiveActionStr:nil cancelActionStr:nil configuration:alertConfiguration actionBlock:^(FQ_AlertAction *action, NSInteger index) {
            if (index == 1) {
                FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
                alertConfiguration.actionBtnTextType = FQ_AlertActionButtonTextType_TextWH;
                alertConfiguration.separatorPadding = 0.0f;
                alertConfiguration.actionBtnType = FQ_AlertActionButtonType_CornerRadius;
                alertConfiguration.alertActionH = 32.0;
                alertConfiguration.defaultBackgroundColor = RGBA(0, 102, 204, 1.0);
                alertConfiguration.defaultTextColor = UIColor.whiteColor;
                alertConfiguration.defaultTextFont = [UIFont systemFontOfSize:13];
                alertConfiguration.confirmBackgroundColor = UIColor.whiteColor;
                alertConfiguration.confirmTextColor = UIColor.grayColor;
                alertConfiguration.confirmTextFont = [UIFont systemFontOfSize:13];
                [FQ_AlertView showAlertViewWithTitle:nil  message:@"\n若不同意协议.则无法继续登录哦.\n"  alertType:FQ_AlertTypeActionAlert confirmActionStr:@"退出" otherActionStrArr:@[@"我再想想"] destructiveActionStr:nil cancelActionStr:nil configuration:alertConfiguration actionBlock:^(FQ_AlertAction *action, NSInteger index) {
                    NSLog(@"action= %@",action.title); //根据字符串比较找到对应的Action事件做处理
                }];
            }
        }];
    }else if(indexPath.row == 8){
        UIActivityIndicatorView * progressView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        progressView.color = [UIColor redColor];
        CGFloat alertW = [FQ_AlertView getAlertTypeWidth:FQ_AlertTypeActionAlert];
        progressView.frame = CGRectMake(0, 0, alertW, 60);
        [progressView startAnimating];
        
        FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
        alertConfiguration.isClickClear = NO;
        alertConfiguration.customView = progressView;
        [FQ_AlertView showAlertViewWithTitle:@"正在加载" message:nil alertType:FQ_AlertTypeActionAlert confirmActionStr:nil otherActionStrArr:nil destructiveActionStr:nil cancelActionStr:@"取消" configuration:alertConfiguration actionBlock:nil];
    }else if(indexPath.row == 9){
        FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
        alertConfiguration.actionBtnTextType = FQ_AlertActionButtonTextType_FixedWH_FitWidth;
        [FQ_AlertView showAlertViewWithTitle:nil  message:nil alertType:FQ_AlertTypeActionSheet confirmActionStr:@"确定没骂你发送到,范士大夫,电视剧啊确定没骂你发送到,范士大夫,电视剧啊" otherActionStrArr:nil destructiveActionStr:@"从手机相册选择了盛大交付了" cancelActionStr:@"取消发生发发呆时" configuration:alertConfiguration actionBlock:^(FQ_AlertAction *action, NSInteger index) {
            NSLog(@"action= %@",action.title); //根据字符串比较找到对应的Action事件做处理
        }];
    }else if(indexPath.row == 10){
        FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
        alertConfiguration.actionBtnTextType = FQ_AlertActionButtonTextType_FixedWH_None;
        [FQ_AlertView showAlertViewWithTitle:@"可以的"  message:nil  alertType:FQ_AlertTypeActionSheet confirmActionStr:@"确定没骂你发送到,范士大夫,电视剧啊确定没骂你发送到,范士大夫,电视剧啊" otherActionStrArr:nil destructiveActionStr:@"从手机相册选择了盛大交付了" cancelActionStr:nil configuration:alertConfiguration actionBlock:^(FQ_AlertAction *action, NSInteger index) {
            NSLog(@"action= %@",action.title); //根据字符串比较找到对应的Action事件做处理
        }];
    }else if(indexPath.row == 11){
        FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
        alertConfiguration.actionBtnTextType = FQ_AlertActionButtonTextType_TextWH;
        [FQ_AlertView showAlertViewWithTitle:nil  message:@"确定没骂你发送到,范士大夫,电视剧啊确定没骂你发送到asflksjaflsjaflkasj,范士大夫,电视剧啊"  alertType:FQ_AlertTypeActionSheet confirmActionStr:nil otherActionStrArr:nil destructiveActionStr:nil cancelActionStr:@"取消发生发发呆时" configuration:alertConfiguration actionBlock:^(FQ_AlertAction *action, NSInteger index) {
            NSLog(@"action= %@",action.title); //根据字符串比较找到对应的Action事件做处理
        }];
    }else{
        FQ_AlertConfiguration * alertConfiguration = [[FQ_AlertConfiguration alloc]init];
        alertConfiguration.actionBtnTextType = FQ_AlertActionButtonTextType_TextWH;
        [FQ_AlertView showAlertViewWithTitle:nil  message:nil  alertType:FQ_AlertTypeActionSheet confirmActionStr:@"确定没骂你发送到,范士大夫,电视剧啊确定没骂你发送到,范士大夫,电视剧啊" otherActionStrArr:nil destructiveActionStr:@"从手机相册选择了盛大交付了" cancelActionStr:nil configuration:alertConfiguration actionBlock:^(FQ_AlertAction *action, NSInteger index) {
            NSLog(@"action= %@",action.title); //根据字符串比较找到对应的Action事件做处理
        }];
    }

}

/**
 可以根据自定义Custon.如进度条.选择关闭契机
 */
-(void)clickCustomBtn{
    [FQ_AlertView hidden];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:coordinator.transitionDuration animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
            self.tableView.frame = self.view.bounds;
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AlertController"];
    }
    return _tableView;
}


@end
