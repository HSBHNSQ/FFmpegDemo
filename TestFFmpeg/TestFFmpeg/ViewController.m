//
//  ViewController.m
//  TestFFmpeg
//
//  Created by 刘旭辉 on 16/6/15.
//  Copyright © 2016年 刘旭辉. All rights reserved.
//

#import "ViewController.h"
#import "ffmpeg.h"
#import "KxMovieViewController.h"
@interface ViewController ()

@end

@implementation ViewController
//静态单例类
static ViewController *instance;
//为了静态方法跟类方法能更便捷的交互，故将该类写成单例类
+(ViewController *)getInstance{
    @synchronized (self) {
        if(!instance){
            instance=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
        }
        return instance;
    }
}
//自定义初始化
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.infoLabel=[self.view viewWithTag:TagOfUILabel];
        self.currentProgress=[self.view viewWithTag:TagOfUIProgress];
        self.finishedButton = [self.view viewWithTag:TagOfUIButton];
        self.progressLabel = [self.view viewWithTag:TagOfUILabel + 1];
        self.progressLabel.text=@"0%";
        //添加点击事件
        [self.finishedButton addTarget:self action:@selector(finishedButtonClicked:) forControlEvents:UIControlEventTouchDown];
        self.finishedButton.enabled = false;
        //默认0次
        self.runTimes = 0;
        //默认转音频
        self.isVideo = NO;
    }
    return self;
}

#pragma -mark 完成按钮事件
- (void)finishedButtonClicked:(UIButton *)button;{
    if (self.isRuning > 0) {
        NSLog(@"%@",@"正在转换,无法退出!");
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark 更换文件信息
- (void)setFileInfo:(NSMutableDictionary *)fileInfo{
    if (self.targetExt == nil) {
        NSLog(@"请先设置目标文件格式!");
        return;
    }
    //默认为非3D
    self.is3D = false;
    self.currentFileInfo = [fileInfo mutableCopy];
    //判断源文件地址
    if ([[[self.currentFileInfo valueForKey:@"url"] substringToIndex:5] isEqualToString:@"asset"]){
        self.inputFilePath = [self.currentFileInfo valueForKey:@"temppath"];
    }else{
        self.inputFilePath = [self.currentFileInfo valueForKey:@"url"];
    }
    self.outputFilePath = [self getOutputFilePath];
    //更改标题
    NSString *info = [NSString stringWithFormat:@"正在将%@转换为%@格式文件,转换完成后会保存在out文件夹中",[self.currentFileInfo valueForKey:@"title"],self.targetExt];
    self.infoLabel.text = info;
    //获得文件总时长
    [[[NSThread alloc] initWithTarget:self selector:@selector(runCmd:) object:[NSString stringWithFormat:@"ffmpeg!#$-i!#$%@",self.inputFilePath]] start];
    //    NSString *testCmd1 = [NSString stringWithFormat:@"ffmpeg -ss 00:00:00 -t 00:00:30 -i %@ -y %@",self.inputFilePath,self.outputFilePath];
    //    [[[NSThread alloc] initWithTarget:self selector:@selector(runCmd:) object:testCmd1] start];
}

//生成输出文件Path
- (NSString *)getOutputFilePath{
    NSString *tempStr = @"";
    //unichar是字符对应的int值,Unicode码
    unichar temp;
    unichar dot = '.';
    NSString *fileName = [self.currentFileInfo valueForKey:@"title"];
    for (int i = 1; i < fileName.length; i++) {
        //每次从末尾取一个字符
        temp = [fileName characterAtIndex:fileName.length - i];
        //判断是否是.
        if (temp == dot) {
            //返回输出文件路径
            tempStr = [NSString stringWithFormat:@"%@/%@%@",AppOutPath,[fileName substringToIndex:fileName.length - i + 1],self.targetExt];
            break;
        }
    }
    
    return tempStr;
}
#pragma -mark 转换方法
//开始转换
- (void)startConver{
    //先标记失败
    self.isBegin = NO;
    //清空次数
    self.runTimes = 0;
    //将空格转换
    //原参数列表@"ffmpeg -ss 00:00:00 -i %@ -y %@"
    
    NSString *testCmd1;
    if (!self.isVideo) {
        testCmd1 = [NSString stringWithFormat:@"ffmpeg!#$-i!#$%@!#$-y!#$%@",self.inputFilePath,self.outputFilePath];
    }else{
        testCmd1 = [NSString stringWithFormat:@"ffmpeg!#$-ss!#$00:00:00!#$-i!#$%@!#$-b:v!#$1500K!#$-y!#$%@",self.inputFilePath,self.outputFilePath];
    }
    
    //查看支持的滤镜
    //    [[[NSThread alloc] initWithTarget:self selector:@selector(runCmd:) object:@"ffmpeg!#$-filters"] start];
    //转换成3D
    //    if (self.is3D) {
    //        //因为参数数组中可能包含空格,所以无法用空格分割数组,这里用!#$来分割
    //        //因为参数数组是用空格来分割的,所以参数中的空格需要替换为别的字符串,这里用!@#来替换空格
    //        //原参数字符串为
    //        testCmd1 = [NSString stringWithFormat:@"ffmpeg!#$-i!#$%@!#$-vf!#$\"movie=%@ [in1]; [in]pad=iw*2:ih:iw:0[in0]; [in0][in1] overlay=0:0 [out]\"!#$-b:v!#$1200k!#$-r:v!#$25!#$-f!#$%@!#$-y!#$%@",self.inputFilePath,self.inputFilePath,self.targetExt,self.outputFilePath];
    //    }
    //    NSLog(@"%@",[testCmd1 stringByReplacingOccurrencesOfString:@"!#$" withString:@" "]);
    //    NSString *testCmd1 = @"ffmpeg -ss 00:00:00 -t 00:00:30 -i /Users/houjiahui/Desktop/test.mp3 -y /Users/houjiahui/Desktop/test.aac";
    //ffmpeg需要每次运行结束后结束线程,否则很多资源无法回收
    //这样会在主线程中运行,结束后会结束主线程,导致无法继续使用
    //    [self runCmd:testCmd1];
    //这样会放入非主线程,但是转换完一次后线程将会结束,无法继续使用
    //    [self performSelectorInBackground:@selector(runCmd:) withObject:testCmd1];
    //直接申明一个线程并运行,每次都是新线程
    [[[NSThread alloc] initWithTarget:self selector:@selector(runCmd:) object:testCmd1] start];
    //测试两个任务阻塞
    //转换视频任务
    //    NSString *testCmd2 = @"ffmpeg -ss 00:00:00 -t 00:00:10 -i /Users/houjiahui/Desktop/test.avi -b:v 400k -s 848x480 -y /Users/houjiahui/Desktop/test.mov";
    //    [[[NSThread alloc] initWithTarget:self selector:@selector(runCmd:) object:testCmd2] start];
}
//停止转换
+(void)stopRuningOC{
    //这里没转换一个文件会调用两次
    //第一次是获取时长信息
    //第二次才是是否装换完成
    //若第二次时候isBegin还是NO则抓换失败,若装换成功isBegin会变为YES;
    if ([self getInstance].runTimes != 0) {
        //判断是否开始过
        if (![self getInstance].isBegin) {
            //没开始过就设置失败
            //主线程中更新UI
            [[self getInstance].infoLabel performSelectorOnMainThread:@selector(setText:) withObject:@"转换失败,请检查源文件的编码格式!" waitUntilDone:false];
            //设置进度百分比
            [[self getInstance].progressLabel performSelectorOnMainThread:@selector(setText:) withObject:@"0%" waitUntilDone:false];
        }else{
            //成功转换完成!
            //主线程中更新UI
            [[self getInstance].infoLabel performSelectorOnMainThread:@selector(setText:) withObject:@"文件已转换完成!" waitUntilDone:false];
            //设置进度百分比
            [[self getInstance].progressLabel performSelectorOnMainThread:@selector(setText:) withObject:@"100%" waitUntilDone:false];
        }
        //返回按钮可点击
        [self getInstance].finishedButton.enabled = YES;
    }
    [self getInstance].runTimes++;
    //状态标记为完成
    [self getInstance].isRuning = 0;
}
//设置log
+ (void)OCLoger:(NSString *)log{
    
}
//设置进度
+ (void)setProgress:(float)progress{
    //更改转换标题
    if (![self getInstance].isBegin) {
        [self getInstance].isBegin = YES;
    }
    float temp = progress/([self getInstance].fileDuration * 1.00);
    NSInteger intTemp = temp * 100;
    
    //这样无法更新
    //    [[self getInstance].progressLabel setText:[NSString stringWithFormat:@"%ld%%",intTemp]];
    //    [[self getInstance].currentProgress performSelectorOnMainThread:@selector(setProgress:) withObject:temp waitUntilDone:false];
    //发送到主线程进行更新
    //更新进度标签
    [[self getInstance].progressLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%ld%%",(long)intTemp] waitUntilDone:false];
    //更新进度条
    [[self getInstance] performSelectorOnMainThread:@selector(setCurrentProgressNumber:) withObject:[NSString stringWithFormat:@"%f",temp] waitUntilDone:false];
}
//这里只能接收id类型参数,所以需要间接赋值
- (void)setCurrentProgressNumber:(NSString *)progress{
    self.currentProgress.progress = [progress floatValue];
}
+ (void)setDuration:(long long int)second{
    [self getInstance].fileDuration = second;
}
+ (void)setCurrentTime:(long long)second{
    [self setProgress:second];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputFilePath=@"/Users/lxh/Desktop/viedo.mp4";
    self.isVideo=YES;
    self.outputFilePath=[NSString stringWithFormat:@"%@/test.mov",AppOutPath];
    self.targetExt=@"mov";
    [self startConver];
    
}

//执行指令
- (void)runCmd:(NSString *)command_str{
    //判断转换状态
    while (self.isRuning > 0) {
        NSLog(@"%@",@"正在转换,该线程已等待!");
        sleep(0.2);
        //        [self runCmd:command_str];
    }
    self.isRuning = 1;
    //根据!#$将指令分割为指令数组
    NSArray *argv_array=[command_str componentsSeparatedByString:(@"!#$")];
    //将OC对象转换为对应的C对象
    int argc=(int)argv_array.count;
    char** argv=(char**)malloc(sizeof(char*)*argc);
    for(int i=0;i<argc;i++)
    {
        argv[i]=(char*)malloc(sizeof(char)*1024);
        strcpy(argv[i],[[argv_array objectAtIndex:i] UTF8String]);
    }
    NSString *finalCommand = @"运行参数:";
    for (NSString *temp in argv_array) {
        finalCommand = [finalCommand stringByAppendingFormat:@"%@",temp];
    }
    NSLog(@"%@",finalCommand);
    //传入指令数及指令数组
    ffmpeg_main(argc,argv);
    //线程已杀死,下方的代码不会执行
}


- (void)viewDidAppear:(BOOL)animated {
    NSString *path = @"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    // increase buffering for .wmv, it solves problem with delaying audio frames
    if ([path.pathExtension isEqualToString:@"wmv"])
        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path
                                                                               parameters:parameters];
    [self presentViewController:vc animated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
