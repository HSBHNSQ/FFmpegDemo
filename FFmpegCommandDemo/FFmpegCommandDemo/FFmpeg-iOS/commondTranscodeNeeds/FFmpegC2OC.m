//
//  FFmpegC2OC.m
//  FFmpegCommandDemo
//
//  Created by mac mini on 25/6/18.
//  Copyright © 2018年 何少博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFmpegProgress.h"
//转换停止
void stopRuning(void){
    NSLog(@"FFmpegC2OC:%@",@"stopRuning");
    [FFmpegProgress shareInstance].duration = 0;
    [FFmpegProgress shareInstance].currentTime = 0;
    if ([FFmpegProgress shareInstance].progressBlock) {
        [FFmpegProgress shareInstance].progressBlock(NO, 0, YES);
    }
}

//获取总时常
void setDuration(long long int time){
    //将这个数值除以1000000后得到的是秒数
    NSLog(@"FFmpegC2OC:%@",@"setDuration");
    [FFmpegProgress shareInstance].duration = time/1000000 + 1;
    if ([FFmpegProgress shareInstance].progressBlock) {
        [FFmpegProgress shareInstance].progressBlock(YES, 0, NO);
    }
}

//获取当前时间
void setCurrentTime(char info[1024]){
    NSString *temp = @"";
    BOOL isBegin = false;
    int j = 5;
    for (int i = 0; i < 1024; i++) {
        //获得时间开始的标记t
        if (info[i] == 't') {
            isBegin = true;
        }
        if (isBegin) {
            //判断是否结束,结束了会输出空格
            if (info[i] == ' ') {
                break;
            }
            if (j > 0) {
                j--;
                continue;
            }else{
                temp = [temp stringByAppendingFormat:@"%c",info[i]];
            }
        }
    }
    //结果是00:00:00.00格式,转换为秒的格式
    int hour,min,second;
    hour = [[temp substringWithRange:NSMakeRange(0, 2)] intValue];
    min = [[temp substringWithRange:NSMakeRange(3, 2)] intValue];
    second = [[temp substringWithRange:NSMakeRange(6, 2)] intValue];
    second = hour * 3600 + min * 60 + second + 1;
    
    [FFmpegProgress shareInstance].currentTime = second;
    float druation = [FFmpegProgress shareInstance].duration * 1.0;
    float progress = second*1.0 / druation;
    if ([FFmpegProgress shareInstance].progressBlock) {
       [FFmpegProgress shareInstance].progressBlock(NO, progress, NO);
    }
    NSLog(@"FFmpegC2OC:%f",progress);
    
}

