//
//  FRPFullSizePhotoViewController.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/19.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "FRPFullSizePhotoViewController.h"
#import "FRPPhotoViewController.h"

@interface FRPFullSizePhotoViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic,strong) UIPageViewController               *pageViewController;
@end

@implementation FRPFullSizePhotoViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(30)}];
        self.pageViewController.view.backgroundColor = [UIColor purpleColor];
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
        [self addChildViewController:self.pageViewController];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex:self.index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    self.pageViewController.view.frame = self.view.bounds;
    
    [self.view addSubview:self.pageViewController.view];
    
}

- (FRPPhotoViewController *)photoViewControllerForIndex:(NSInteger)index{
    
    if (index < 0 || index >= self.viewmodel.model.count) {
        return nil;
    }
    UIColor *color = self.viewmodel.model[index];
    
    if (color) {
        FRPPhotoViewController *photo = [[FRPPhotoViewController alloc]initWithObj:color index:index];
        return photo;
    }
    return nil;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    FRPPhotoViewController *index = (FRPPhotoViewController *)viewController;
    
    return [self photoViewControllerForIndex:index.index +1 ];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    FRPPhotoViewController *index = (FRPPhotoViewController *)viewController;
    
    return [self photoViewControllerForIndex:index.index - 1 ];

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
