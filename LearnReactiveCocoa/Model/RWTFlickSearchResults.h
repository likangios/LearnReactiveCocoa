//
//  RWTFlickSearchResults.h
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/13.
//  Copyright © 2016年 lk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTFlickSearchResults : NSObject
@property (nonatomic,strong) NSString               *searchString;
@property (nonatomic,strong) NSArray               *phots;
@property (nonatomic,assign ) NSUInteger               totalResults;
@end
