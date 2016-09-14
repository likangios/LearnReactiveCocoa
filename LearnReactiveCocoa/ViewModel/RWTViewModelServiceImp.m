//
//  RWTViewModelServiceImp.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/13.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "RWTViewModelServiceImp.h"
#import "RWTFlickrSearchImpl.h"

@interface RWTViewModelServiceImp ()

@property (nonatomic,strong) RWTFlickrSearchImpl          *searchService;

@end

@implementation RWTViewModelServiceImp

- (instancetype)init{
    if (self = [super init]) {
        _searchService = [RWTFlickrSearchImpl new];
    }
    return self;
}
- (id<RWTFlickrSearch>)getFlickrSearchService{
    return self.searchService;
}
@end
