//
//  ViewController.h
//  TestFFmpeg
//
//  Created by 刘旭辉 on 16/6/15.
//  Copyright © 2016年 刘旭辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
//文件相关信息
@property (nonatomic, retain) NSMutableDictionary *currentFileInfo;
//转换模式
@property (nonatomic, assign) BOOL isVideo;
//目标格式
@property (nonatomic, retain) NSString *targetExt;
//输入文件路径
@property (nonatomic, retain) NSString *inputFilePath;
//输出文件路径
@property (nonatomic, retain) NSString *outputFilePath;
//转换状态
@property (nonatomic, assign) int isRuning;
//总时长
@property (nonatomic, assign) long long int fileDuration;
//页面控件
@property (nonatomic, retain) UILabel *infoLabel;
@property (nonatomic, retain) UIProgressView *currentProgress;
@property (nonatomic, retain) UILabel *progressLabel;
@property (nonatomic, retain) UIButton *finishedButton;
//转换标记
@property (nonatomic, assign) BOOL isBegin;
//转3D功能无法实现,该属性已废弃
@property (nonatomic, assign) BOOL is3D;
//记录次数
@property (nonatomic, assign) int runTimes;
//单例类方法
+(ViewController *)getInstance;
//更换文件信息
- (void)setFileInfo:(NSMutableDictionary *)fileInfo;
//开始转换
- (void)startConver;
//转换完成
+(void)stopRuningOC;
//转换log
+ (void)OCLoger:(NSString *)log;
//设置转换进度
+ (void)setProgress:(float)progress;
//设置文件总时长
+ (void)setDuration:(long long int)second;
//设置当前时间
+ (void)setCurrentTime:(long long int)second;
@end

