//
//  LoginViewModel.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/21.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initlized];
    }
    return self;
}
- (void)initlized{
    RACSignal *nameSignal = RACObserve(self, name);
    
    RACSignal *passwordSignal = RACObserve(self, password);
    
    RACSignal *validSignal = [RACSignal combineLatest:@[nameSignal,passwordSignal] reduce:^id(NSString *name,NSString *password){
        
        return @([self isValidUserName:name] && [self isValidPassword:password]);
        
    }];
    _loginCommand = [[RACCommand alloc]initWithEnabled:validSignal signalBlock:^RACSignal *(id input) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"OK"];
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
}
- (BOOL)isValidUserName:(NSString *)name{
    if (name.length > 8 && name.length < 16) {
        return YES;
    }
    return NO;
}
- (BOOL)isValidPassword:(NSString *)password{
    
    NSString *pattern = @"[0-9|A-Z|a-z]{8,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    
    return isMatch;
}
@end
