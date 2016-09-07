//
//  RWTFlickrSearchViewController.h
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/7.
//  Copyright © 2016年 lk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWTFlickrSearchViewModel.h"

@interface RWTFlickrSearchViewController : UIViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithModel:(RWTFlickrSearchViewModel *)viewModel;
@end
