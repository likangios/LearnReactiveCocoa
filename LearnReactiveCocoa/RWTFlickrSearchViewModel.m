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

@property (nonatomic,weak)  id<RWTViewModelServices>  service;

@end

@implementation RWTFlickrSearchViewModel
- (instancetype)initWithService:(id<RWTViewModelServices>)service{
    self = [super init];
    if (self) {
        _service = service;
        [self initialize];
    }
    
    return self;
}
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
    RACSignal *validSearchSignal = [[[RACObserve(self, searchText) filter:^BOOL(NSString *value) {
        
        return value.length>2;
        
    }] map:^id(NSString *value) {
        return @(value.length > 3);
    }] distinctUntilChanged];
    
    self.executeSearch = [[RACCommand  alloc]initWithEnabled:validSearchSignal signalBlock:^RACSignal *(id input) {
        return [self executeSearchSignal];
    }];
    
}
- (RACSignal *)executeSearchSignal{
    
    return [[self.service getFlickrSearchService] flickrSearchSignal:self.searchText];;
}

@end
