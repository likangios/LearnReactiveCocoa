//
//  FRPPhotoViewController.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/19.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "FRPPhotoViewController.h"

@interface FRPPhotoViewController ()

@property (nonatomic,weak) IBOutlet  UIView                   *imageView;

@property (nonatomic,strong) UIColor                *color;

@end

@implementation FRPPhotoViewController

- (instancetype)initWithObj:(id)obj index:(NSInteger)index{
    NSString *nibname = NSStringFromClass([self class]);
    self = [super initWithNibName:nibname bundle:nil];
    if (self) {
        self.color = (UIColor *)obj;
        self.index = index;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.imageView,backgroundColor) = RACObserve(self,color);
    
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
