//
//  RWTFlickSearchResults.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/13.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "RWTFlickSearchResults.h"

@implementation RWTFlickSearchResults

- (NSString *)description{
    return [NSString stringWithFormat:@"searchString= %@,totalresults=%lu,phots=%@",self.searchString,self.totalResults,self.phots];
}
@end
