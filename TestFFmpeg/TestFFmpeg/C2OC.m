//
//  C2OC.m
//  TestFFmpeg
//
//  Created by 刘旭辉 on 16/6/16.
//  Copyright © 2016年 刘旭辉. All rights reserved.
//

#import "C2OC.h"
#import <Foundation/Foundation.h>
#import "ViewController.h"
//转换停止
void stopRuning(){
    NSLog(@"%@",@"停止转换");
}

//获取总时常
void setDuration(long long int time){
    //将这个数值除以1000000后得到的是秒数
    [ViewController setDuration:time/1000000 + 1];
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
    [ViewController setCurrentTime:second];
}
