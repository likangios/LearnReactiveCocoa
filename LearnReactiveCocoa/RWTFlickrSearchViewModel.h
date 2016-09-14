//
//  RWTFlickrSearchViewModel.h
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/7.
//  Copyright © 2016年 lk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTViewModelServices.h"


@interface RWTFlickrSearchViewModel : NSObject
@property (nonatomic,strong) NSString               *searchText;
@property (nonatomic,strong) NSString               *title;
@property (nonatomic,strong) RACCommand               *executeSearch;

@property (nonatomic,strong) RACSignal               *requestSignal;

- (instancetype)initWithService:(id<RWTViewModelServices>)service;
@end
