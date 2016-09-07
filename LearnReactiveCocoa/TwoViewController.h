//
//  TwoViewController.h
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/6.
//  Copyright © 2016年 lk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoViewController : UIViewController

@property (nonatomic,strong) RACSubject                *delegateSignal;
@end
