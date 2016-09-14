//
//  RWTFlickrSearchImpl.m
//  LearnReactiveCocoa
//
//  Created by FengLing on 16/9/13.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "RWTFlickrSearchImpl.h"
#import "RWTFlickrPhoto.h"



@interface RWTFlickrSearchImpl ()<OFFlickrAPIRequestDelegate>

@property (nonatomic,strong) NSMutableSet               *requests;
@property (nonatomic,strong) OFFlickrAPIContext               *flickrContext;

@end

@implementation RWTFlickrSearchImpl

- (instancetype)init{
    self = [super init];
    if (self) {
        
        NSString *OFSampleAppApiKey = @"YOU_API_KEY_GOES_HERE";
        NSString *OFSampleAppApiSharedSecret = @"YOUR_SECRET_GOES_HERE";
        _flickrContext = [[OFFlickrAPIContext alloc]initWithAPIKey:OFSampleAppApiKey sharedSecret:OFSampleAppApiSharedSecret];
        _requests = [NSMutableSet new];
        
    }
    return self;
}
- (RACSignal *)flickrSearchSignal:(NSString *)searchString{
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        manager.requestSerializer.timeoutInterval = 30.0;
        
        NSString *url =[NSString stringWithFormat:@"http://www.kuaidi100.com/query?type=yunda&postid=%@",searchString];
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                
            });


        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [subscriber sendError:error];
            [subscriber sendCompleted];

        }];
        
        return  nil;
        
    }];
    
    return signal;
    
    
}

- (RACSignal *)signalFromAPIMethod:(NSString *)method arguments:(NSDictionary *)args transform:(id (^)(NSDictionary *response))block{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        OFFlickrAPIRequest *flickRequest = [[OFFlickrAPIRequest alloc]initWithAPIContext:self.flickrContext];
        [self.requests addObject:flickRequest];
        
        RACSignal *successSignal = [self rac_signalForSelector:@selector(flickrAPIRequest:didCompleteWithResponse:) fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
        
       [[ [successSignal map:^id(RACTuple *tuple) {
           
           return tuple.second;
           
        }] map:block] subscribeNext:^(id x) {
            
            [subscriber sendNext:x];
            [subscriber sendCompleted];
            
        }];
        
        [flickRequest callAPIMethodWithGET:method arguments:args];
        
        return [RACDisposable  disposableWithBlock:^{
            [self.requests removeObject:flickRequest];
        }];
        
    }];
}

@end
