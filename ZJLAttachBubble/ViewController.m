//
//  ViewController.m
//  ZJLAttachBubble
//
//  Created by ZhongZhongzhong on 16/6/14.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ViewController.h"
#import "ZJLAttachBubble.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ZJLAttachBubble *bubble = [[ZJLAttachBubble alloc] init];
    [self.view addSubview:bubble];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
