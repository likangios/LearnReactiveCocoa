//
//  FRPPhotoViewController.h
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/19.
//  Copyright © 2016年 lk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRPPhotoViewController : UIViewController

@property (nonatomic,assign) NSInteger             index;

- (instancetype)initWithObj:(id)obj index:(NSInteger)index;

@end
