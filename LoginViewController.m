//
//  LoginViewController.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/21.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"

@interface LoginViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) IBOutlet  UITextField                   *userName;

@property (nonatomic,weak) IBOutlet  UITextField                   *password;

@property (nonatomic,weak) IBOutlet  UIButton                   *loginButton;

@property (nonatomic,weak) IBOutlet  UITableView                    *tableView;

@property (nonatomic,strong) LoginViewModel               *viewModle;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModle = [[LoginViewModel alloc]init];
    
    RAC(self.viewModle,name) = self.userName.rac_textSignal;
    
    RAC(self.viewModle,password) = self.password.rac_textSignal;
    
    self.loginButton.rac_command = self.viewModle.loginCommand;
    
    [self.viewModle.loginCommand.executionSignals.flatten subscribeNext:^(id x) {
        
        NSLog(@"x is %@",x);
        
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(RACTuple *x) {
        
        NSIndexPath *index = x.second;
        
        NSLog(@"select row is %ld",index.row);
        
    }];
    
    
    self.tableView.delegate = self;
    
    self.tableView.multipleTouchEnabled = YES;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text =[NSString stringWithFormat:@" row %ld",indexPath.row];
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
