//
//  ViewController.m
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/28.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import "ViewController.h"
#import "EaseThemeKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(gogogo:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.et.backgroundColor(@"Global.backgroundColor");
}

- (void)gogogo:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [ETManager shiftThemeName:@"typewriter"];
    }else{
        [ETManager shiftThemeName:@"default"];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
