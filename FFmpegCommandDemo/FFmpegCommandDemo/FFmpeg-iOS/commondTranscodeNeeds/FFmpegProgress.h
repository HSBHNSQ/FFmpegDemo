//
//  FFmpegProgress.h
//  FFmpegCommandDemo
//
//  Created by mac mini on 25/6/18.
//  Copyright © 2018年 何少博. All rights reserved.
//


#import <Foundation/Foundation.h>


typedef void(^FFmpegProgressBlock)(BOOL startRuning,float progress, BOOL stopRuning);

@interface FFmpegProgress : NSObject

@property (assign, nonatomic) long long int duration;

@property (assign, nonatomic) long long int currentTime;

@property (copy, nonatomic) FFmpegProgressBlock progressBlock;

+(instancetype)shareInstance;

@end
