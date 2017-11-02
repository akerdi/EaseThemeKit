//
//  ViewController.m
//  EaseThemeKit
//
//  Created by aKerdi on 2017/10/28.
//  Copyright © 2017年 XXT. All rights reserved.
//

#import "ViewController.h"
#import "EaseThemeKit.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *themeArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    UIView *headView = [UIView new];
    headView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    tableView.tableHeaderView = headView;
    
    self.themeArray = @[@"default",@"typewriter"];
    
    tableView.et.backgroundColor(@"Global.backgroundColor");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.themeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"111"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"111"];
    }
    NSString *str = self.themeArray[indexPath.row];
    cell.textLabel.text = str;
    
    NSString *string = [ETManager getCurrentThemeName];
    if ([str isEqualToString:string]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.themeArray[indexPath.row];
    [ETManager shiftThemeName:str];
    [tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
