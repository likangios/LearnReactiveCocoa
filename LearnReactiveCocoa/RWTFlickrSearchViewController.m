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
    RACSignal *test = [self rac_signalForSelector:@selector(bindViewModel)];
    
    [test subscribeNext:^(RACTuple *x) {
        
        NSLog(@"x %@",x.second);
        
    }];
    self.view.backgroundColor = [UIColor grayColor];
    _loadingIndicator = [[UIActivityIndicatorView alloc]init];
    _loadingIndicator.frame = CGRectMake(120, 0, 30, 30);
    _loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    [_loadingIndicator startAnimating];
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
    self.searchTextField.rightView = _loadingIndicator;
    [self bindViewModel];

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
