//
//  RWTFlickrSearchViewModel.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/7.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "RWTFlickrSearchViewModel.h"

@interface RWTFlickrSearchViewModel ()

@property (nonatomic,strong) RACSignal               *executeSignal;

@end

@implementation RWTFlickrSearchViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (RACSignal *)executeSignal{
    if (!_executeSearch) {
        _executeSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            return nil;
        }];
    }
    return _executeSignal;
}
- (void)initialize{
    self.searchText =  @"search text";
    self.title = @"flickr search";
    RACSignal *validSearchSignal = [[RACObserve(self, searchText) map:^id(NSString *value) {
        return @(value.length > 3);
    }] distinctUntilChanged];
    [validSearchSignal subscribeNext:^(id x) {
        
        NSLog(@"search text is valid %@",x);
    }];
    
    self.executeSearch = [[RACCommand alloc]initWithEnabled:validSearchSignal signalBlock:^RACSignal *(id input) {
        return [self executeSearchSignal];
    }];
    
}
- (RACSignal *)executeSearchSignal{
    
    return [[[[RACSignal empty] logAll]delay:2.0] logAll];
}

@end
