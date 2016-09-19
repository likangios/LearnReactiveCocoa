//
//  FRPGalleryViewModel.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/19.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "FRPGalleryViewModel.h"

@implementation FRPGalleryViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        RAC(self,model) = [self creatDataSignal];
    }
    return self;
}
- (RACSignal *)creatDataSignal{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        int64_t delta = 2.0;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delta);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i<20; i++) {
                UIColor *color = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
                [array addObject:color];
            }
            [subscriber sendNext:array];
            
        });
        return nil;
    }];
}
@end
