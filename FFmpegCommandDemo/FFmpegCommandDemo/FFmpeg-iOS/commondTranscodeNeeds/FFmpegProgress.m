//
//  FFmpegProgress.m
//  FFmpegCommandDemo
//
//  Created by mac mini on 25/6/18.
//  Copyright © 2018年 何少博. All rights reserved.
//

#import "FFmpegProgress.h"



@implementation FFmpegProgress


+(instancetype)shareInstance{
    static FFmpegProgress * _shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[FFmpegProgress alloc] init];
    });
    return _shareInstance;
}


@end
