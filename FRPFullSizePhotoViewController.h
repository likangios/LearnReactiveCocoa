//
//  FRPFullSizePhotoViewController.h
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/19.
//  Copyright © 2016年 lk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRPGalleryViewModel.h"

@interface FRPFullSizePhotoViewController : UIViewController

@property (nonatomic,strong) FRPGalleryViewModel               *viewmodel;

@property (nonatomic,assign) NSInteger             index;
@end
