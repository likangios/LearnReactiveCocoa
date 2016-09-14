//
//  RWTFlickrSearch.h
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/13.
//  Copyright © 2016年 lk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RWTFlickrSearch <NSObject>

- (RACSignal *)flickrSearchSignal:(NSString *)searchString;

@end
