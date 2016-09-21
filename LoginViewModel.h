//
//  LoginViewModel.h
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/21.
//  Copyright © 2016年 lk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

@property (nonatomic,strong) NSString               *name;

@property (nonatomic,strong) NSString               *password;

@property (nonatomic,strong) RACCommand               *loginCommand;

@end
