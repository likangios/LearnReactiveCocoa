//
//  RWTFlickrSearchViewController.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/7.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "RWTFlickrSearchViewController.h"
#import "RWTFlickrSearchViewModel.h"

@interface RWTFlickrSearchViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) RWTFlickrSearchViewModel               *viewModel;
@property (nonatomic,weak) IBOutlet  UITextField                   *searchTextField;
@property (nonatomic,weak) IBOutlet  UIButton                   *GoBtn;
@property (nonatomic,strong) UIActivityIndicatorView               *loadingIndicator;

@end

@implementation RWTFlickrSearchViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithModel:(RWTFlickrSearchViewModel *)viewModel{
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    _loadingIndicator = [[UIActivityIndicatorView alloc]init];
    _loadingIndicator.frame = CGRectMake(120, 0, 30, 30);
    _loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    [_loadingIndicator startAnimating];
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
    self.searchTextField.rightView = _loadingIndicator;
    [self bindViewModel];
    
//    learn
    
    RACSignal *test = [self rac_signalForSelector:@selector(bindViewModel)];
    
    [test subscribeNext:^(RACTuple *x) {
        
        NSLog(@"x %@",x.second);
        
    }];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求");
        [subscriber sendNext:@2];
        
        return nil;
    }];
//    防止多次调用发送请求
    RACMulticastConnection *connect = [signal publish];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"connect %@",x);
    }];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"connect2 %@",x);
    }];
    
    [connect connect];
    
    RACCommand *command = [[RACCommand alloc ]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"请求数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    
    [command.executionSignals subscribeNext:^(id x) {
        
        [x subscribeNext:^(id x) {
            NSLog(@"x %@",x);
        }];
    }];
    
    [command execute:@1];

    [[command.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue]) {
            
            NSLog(@"正在执行");
            
        }else{
            
        NSLog(@"执行完成");
            
        }
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"" object:nil] subscribeNext:^(NSNotification *notification) {
        
        NSLog(@"notification received ");
    }];
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        double delayInSeconds = 2.0;
        
        dispatch_time_t poptime=  dispatch_time(DISPATCH_TIME_NOW, (int64_t)delayInSeconds*NSEC_PER_SEC);
        dispatch_after(poptime, dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"A"];
        });
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"B"];
        [subscriber sendNext:@"OTHER B"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    [signal setName:@"signalName"];
    [self  rac_liftSelector:@selector(doA:withB:) withSignals:signalA,signalB, nil];
    
    
    
}
- (void)doA:(NSString *)A withB:(NSString *)B{
    NSLog(@"A:%@,B:%@",A,B);
}
- (void)bindViewModel{
    
    self.title = self.viewModel.title;
    
    RAC(self.viewModel,searchText) = self.searchTextField.rac_textSignal;
    
    self.GoBtn.rac_command = self.viewModel.executeSearch;
    
    RAC([UIApplication sharedApplication],networkActivityIndicatorVisible) = self.viewModel.executeSearch.executing;
    
    
    [self.GoBtn.rac_command.executing subscribeNext:^(NSNumber *value) {
        
        if (value.boolValue) {
            [self.loadingIndicator startAnimating];
        }else{
            [self.loadingIndicator stopAnimating];
        }
        
    }];
    
    [self.GoBtn.rac_command.executionSignals subscribeNext:^(id x) {
       
        [self.searchTextField resignFirstResponder];
        
    }];
    
    
    [[[self.GoBtn.rac_command.executionSignals.flatten filter:^BOOL(NSDictionary  *value) {
        if ([value[@"status"] isEqualToString:@"200"]) {
            return YES;
        }
        NSLog(@"message is %@",value[@"message"]);
        
        return NO;
        
    }] map:^id(NSDictionary *value) {
    
        return value[@"data"];
        
    }] subscribeNext:^(NSArray *array) {
        
        [array.rac_sequence.signal subscribeNext:^(NSDictionary *tup) {
            
            [tup.rac_sequence.signal subscribeNext:^(RACTuple *x) {
               
                RACTupleUnpack(NSString *key , NSString *value) = x;
                if ([key isEqualToString:@"context"]) {
                    NSLog(@"%@:%@",key,value);    
                }
            }];
            
        }];
        
    }];;
    
    
    [self.viewModel.executeSearch.errors subscribeNext:^(id x) {
      
        NSLog(@"error is %@",x);
        
    }];
    
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
