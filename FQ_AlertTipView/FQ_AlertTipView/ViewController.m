//
//  ViewController.m
//  FQ_AlertTipView
//
//  Created by 龙腾飞 on 2018/9/4.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "ViewController.h"
#import "FQ_AlertView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [FQ_AlertView showTopAlertViewWithTitle:@"测试-" message:@"发生大路口富家大室啦房间里的萨芬了解到法律大姐夫了"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
