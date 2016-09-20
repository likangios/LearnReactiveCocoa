//
//  FRPGalleryViewController.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/19.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "FRPGalleryViewController.h"
#import "FRPGalleryViewModel.h"
#import "FRPFullSizePhotoViewController.h"

#import "FRPGalleryFlowLayout.h"
@interface FRPGalleryViewController ()

@property (nonatomic,strong) FRPGalleryViewModel               *viewmodel;
@end

@implementation FRPGalleryViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init{    
    self = [super initWithCollectionViewLayout:[[FRPGalleryFlowLayout alloc]init]];
    if (self) {
        self.viewmodel = [[FRPGalleryViewModel alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [RACObserve(self.viewmodel,model) subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [[self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol( UICollectionViewDelegate)] subscribeNext:^(RACTuple *x) {
        @strongify(self);
        NSIndexPath *index=  x.second;
                
        FRPFullSizePhotoViewController *full = [[FRPFullSizePhotoViewController alloc]init];
        full.viewmodel = self.viewmodel;
        
        full.index = index.item;
        
        [self.navigationController pushViewController: full animated:YES];
        
        NSLog(@"click index.item %ld",index.item);
        
    }];
    self.collectionView.delegate = nil;
    
    self.collectionView.delegate = self;
    
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [subscriber sendNext:@"signalA"];
        });
        
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 *NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"signalB2"];
        });
        return nil;
    }];
    
    [self rac_liftSelector:@selector(doA:withB:) withSignals:signalA,signalB, nil];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"" object:nil] subscribeNext:^(id x) {
        
    }];
    
    
}
- (void)doA:(NSString *)A withB:(NSString *)B{
    
    NSLog(@"A :%@ B:%@",A,B);
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewmodel.model.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.viewmodel.model[indexPath.item];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
