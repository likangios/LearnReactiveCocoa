//
//  FRPGalleryFlowLayout.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/19.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "FRPGalleryFlowLayout.h"

@implementation FRPGalleryFlowLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(60, 60);
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}
@end
