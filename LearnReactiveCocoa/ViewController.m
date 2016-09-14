//
//  ViewController.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/6.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "ViewController.h"
#import "TestViewModel.h"
#import "TwoViewController.h"   

@interface ViewController ()

@property (nonatomic,weak) IBOutlet  UIButton                   *myButton;

@property (nonatomic,weak) IBOutlet  UITextField                   *myTextField;

@property (nonatomic,strong) TestViewModel               *viewmodel;


@end

@implementation ViewController

- (IBAction)buttonClick:(id)sender{
    
    TwoViewController *two = [[TwoViewController alloc]initWithNibName:@"TwoViewController" bundle:nil];
    
    two.delegateSignal = [RACSubject subject];
    
    [two.delegateSignal subscribeNext:^(id x) {
       
        NSLog(@"点击  %@",x);
    }];
    [self presentViewController:two animated:YES completion:NULL];
    
}
- (RACSignal *)executeSearchSignal {
    return [[[[RACSignal empty]
              logAll]
             delay:2.0]
            logAll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor grayColor];
    
    RACSignal *validMyTextField = [[self.myTextField.rac_textSignal map:^id(NSString * value) {
        
        return @(value.length > 3);
        
    }] distinctUntilChanged];
    
    [validMyTextField subscribeNext:^(id x) {
        
        NSLog(@"valid %@",x);
        
    }];
    
    RACSignal *validMyTextField2 = [[self.myTextField.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 2);
    }] distinctUntilChanged];
    [validMyTextField subscribeNext:^(id x) {
        
        NSLog(@"x is %@",x);
        
    }];
    
    RACCommand *execute = [[RACCommand alloc]initWithEnabled:validMyTextField signalBlock:^RACSignal *(id input) {
        
        return [self executeSearchSignal];
        
    }];
    
    
    RACSignal *controlUpdate = [_myButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    
    RACSignal *signal  =[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
            NSLog(@"发送完成");
        }];
    }];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"x is %@",x);
        
    }];
    
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"第一个 订阅者  %@",x);
    }];
    
    
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个 订阅者  %@",x);
    }];
    
    [subject sendNext:@"haha"];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"第san个 订阅者  %@",x);
    }];
    
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    [replaySubject sendNext:@"1"];
    
    [replaySubject sendNext:@"2"];
    
    [replaySubject subscribeNext:^(id x) {
    
        NSLog(@"第一个 订阅者  %@",x);
    }];
    
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第er个 订阅者  %@",x);
    }];
    
    [replaySubject sendNext:@"11"];
    
    
//    RACTuple  元祖类
    
    NSArray *numbers = @[@1,@2,@3,@4];
    
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
       
        NSLog(@"x is %@",x);
        
    }];
    
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    
    [dict.rac_sequence.signal subscribeNext:^(RACTuple  *x) {
        
        RACTupleUnpack(NSString *key , NSString *value) = x;
        
        NSLog(@"x is %@",x);
        
        NSLog(@"key :%@ value :%@",x[0],x[1]);
        
    }];
    
    RACSignal *signal22  =[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        NSLog(@"发送请求");
        
        [subscriber sendNext:@1];
        
        return nil;
        
    }];
//    防止多次调用发送请求 block
    RACMulticastConnection *connect = [signal22 publish];
    
    [connect.signal subscribeNext:^(id x) {
    
        NSLog(@"订阅者 1 ");
    }];
    
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者 2 ");
    }];
    
    [connect connect];
    
    RACCommand *command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
       
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"请求数据"];
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    [command  execute:@1];
    
    [command.executionSignals subscribeNext:^(id x) {
       
        [x subscribeNext:^(id x) {
            NSLog(@"subscribeNext:%@",x);
        }];
    }];
    
    RACTuple *tuple = RACTuplePack(@1,@2);
    
    [tuple.rac_sequence.signal subscribeNext:^(id x) {
        
        NSLog(@"tuple.rac_sequence.signal %@",x);
        
    }];
    
    RACTupleUnpack(NSString *name,NSString *age) = tuple;
    
    NSLog(@"name %@ age %@",name,age);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
