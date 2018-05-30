//
//  ViewController.m
//  FFmpegCommandDemo
//
//  Created by mac mini on 30/5/18.
//  Copyright © 2018年 何少博. All rights reserved.
//

#import "ViewController.h"
#import "ffmpeg.h"

#define DocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define BundlePath(res) [[NSBundle mainBundle] pathForResource:res ofType:nil]
#define DocumentPath(res) [DocumentDir stringByAppendingPathComponent:res]

//extern int ffmpeg_main(int argc, char * argv[]);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",DocumentDir);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Events


-(void)encodeFFmpeg{
    NSString *commond = [NSString stringWithFormat:@"ffmpeg -i %@ -b:v 400k -s 1280x640 %@",BundlePath(@"1.mp4"),DocumentPath(@"logo.mp4")];
    
    NSArray *argv_array = [commond componentsSeparatedByString:@" "];
    int argc = (int)argv_array.count;
    char **argv = malloc(sizeof(char)*1024);
    //把我们写的命令转成c的字符串数组
    for (int i = 0; i < argc; i++) {
        argv[i] = (char *)malloc(sizeof(char)*1024);
        strcpy(argv[i], [[argv_array objectAtIndex:i] UTF8String]);
    }
    ffmpeg_main(argc, argv);
    
    for(int i=0;i<argc;i++)
        free(argv[i]);
    free(argv);
}





-(void)sliceimages{
    char *movie = (char *)[BundlePath(@"1.mp4") UTF8String];
    char *outPic = (char *)[DocumentPath(@"%05d.jpg") UTF8String];
    char* argv[] = {
        "ffmpeg",
        "-i",
        movie,
        "-r",
        "100",
        outPic
    };
    int argc = sizeof(argv)/sizeof(*argv);
    ffmpeg_main(argc, argv);
    for(int i=0;i<argc;i++)
        free(argv[i]);
    free(argv);
    //    NSString *commond = [NSString stringWithFormat:@"ffmpeg -i %@ -r 100 %@",BundlePath(@"1.mp4"),DocumentPath(@"%05d.jpg")];
    //
    //    NSArray *argv_array = [commond componentsSeparatedByString:@" "];
    //    int argc = (int)argv_array.count;
    //    char **argv = malloc(sizeof(char)*1024);
    //    //把我们写的命令转成c的字符串数组
    //    for (int i = 0; i < argc; i++) {
    //        argv[i] = (char *)malloc(sizeof(char)*1024);
    //        strcpy(argv[i], [[argv_array objectAtIndex:i] UTF8String]);
    //    }
    //    ffmpeg_main(argc, argv);
    //
    //    for(int i=0;i<argc;i++)
    //        free(argv[i]);
    //    free(argv);
}

- (IBAction)sliceBtnClick:(UIButton *)sender
{
    NSThread * newT = [[NSThread alloc]initWithTarget:self selector:@selector(sliceimages) object:nil];
    
    [newT start];
    
}

-(void)compose{
    char *outPic = (char *)[DocumentPath(@"%05d.jpg") UTF8String];
    char *movie = (char *)[DocumentPath(@"1.mp4") UTF8String];
    char* argv[] = {
        "ffmpeg",
        "-i",
        outPic,
        "-vcodec",
        "mpeg4",
        movie
    };
    int argc = sizeof(argv)/sizeof(*argv);
    ffmpeg_main(argc, argv);
    for(int i=0;i<argc;i++)
        free(argv[i]);
    free(argv);
    //    NSString *commond = [NSString stringWithFormat:@"ffmpeg -i %@ -vcodec mpeg4 %@",DocumentPath(@"%05d.jpg"),DocumentPath(@"1.mp4")];
    //
    //    NSArray *argv_array = [commond componentsSeparatedByString:@" "];
    //    int argc = (int)argv_array.count;
    //    char **argv = malloc(sizeof(char)*1024);
    //    //把我们写的命令转成c的字符串数组
    //    for (int i = 0; i < argc; i++) {
    //        argv[i] = (char *)malloc(sizeof(char)*1024);
    //        strcpy(argv[i], [[argv_array objectAtIndex:i] UTF8String]);
    //    }
    //    ffmpeg_main(argc, argv);
    //
    //    for(int i=0;i<argc;i++)
    //        free(argv[i]);
    //    free(argv);
    
}

- (IBAction)composeBtnClick:(UIButton *)sender
{
    NSThread * newT = [[NSThread alloc]initWithTarget:self selector:@selector(compose) object:nil];
    
    [newT start];
}

-(void)trans{
    char *outPic = (char *)[DocumentPath(@"out.avi") UTF8String];
    char *movie = (char *)[BundlePath(@"1.mp4") UTF8String];
    char* argv[] = {
        "ffmpeg",
        "-i",
        movie,
        "-vcodec",
        "mpeg4",
        outPic
    };
    int argc = sizeof(argv)/sizeof(*argv);
    ffmpeg_main(argc, argv);
    for(int i=0;i<argc;i++)
        free(argv[i]);
    free(argv);
    //    NSString *commond = [NSString stringWithFormat:@"ffmpeg -i %@ -vcodec mpeg4 %@",BundlePath(@"1.mp4"),DocumentPath(@"out.avi")];
    //
    //    NSArray *argv_array = [commond componentsSeparatedByString:@" "];
    //    int argc = (int)argv_array.count;
    //    char **argv = malloc(sizeof(char)*1024);
    //    //把我们写的命令转成c的字符串数组
    //    for (int i = 0; i < argc; i++) {
    //        argv[i] = (char *)malloc(sizeof(char)*1024);
    //        strcpy(argv[i], [[argv_array objectAtIndex:i] UTF8String]);
    //    }
    //    ffmpeg_main(argc, argv);
    //
    //    for(int i=0;i<argc;i++)
    //        free(argv[i]);
    //    free(argv);
}

- (IBAction)transBtnClick:(UIButton *)sender
{
    NSThread * newT = [[NSThread alloc]initWithTarget:self selector:@selector(trans) object:nil];
    
    [newT start];
}

-(void)logo{
    char *outPic = (char *)[DocumentPath(@"logo.mp4") UTF8String];
    char *movie = (char *)[BundlePath(@"1.mp4") UTF8String];
    char logo[1024];
    // 左上
    sprintf(logo, "movie=%s [logo]; [in][logo] overlay=30:10 [out]", [BundlePath(@"ff.jpg") UTF8String]);
    
    // 左下
    //sprintf(logo, "movie=%s [logo]; [in][logo] overlay=30:main_h-overlay_h-10 [out]", [BundlePath(@"ff.jpg") UTF8String]);
    
    // 右下
    //sprintf(logo, "movie=%s [logo]; [in][logo] overlay=main_w-overlay_w-10:main_h-overlay_h-10 [out]", [BundlePath(@"ff.jpg") UTF8String]);
    
    // 右上
    //sprintf(logo, "movie=%s [logo]; [in][logo] overlay=main_w-overlay_w-10:10 [out]", [BundlePath(@"ff.jpg") UTF8String]);
    
    char* argv[] = {
        "ffmpeg",
        "-i",
        movie,
        "-vf",
        logo,
        outPic
    };
    int argc = sizeof(argv)/sizeof(*argv);
    ffmpeg_main(argc, argv);
    for(int i=0;i<argc;i++)
        free(argv[i]);
    free(argv);
    //    NSString *commond = [NSString stringWithFormat:@"ffmpeg -i %@ -vf logo %@",BundlePath(@"1.mp4"),DocumentPath(@"logo.mp4")];
    //
    //    NSArray *argv_array = [commond componentsSeparatedByString:@" "];
    //    int argc = (int)argv_array.count;
    //    char **argv = malloc(sizeof(char)*1024);
    //    //把我们写的命令转成c的字符串数组
    //    for (int i = 0; i < argc; i++) {
    //        argv[i] = (char *)malloc(sizeof(char)*1024);
    //        strcpy(argv[i], [[argv_array objectAtIndex:i] UTF8String]);
    //    }
    //    ffmpeg_main(argc, argv);
    //
    //    for(int i=0;i<argc;i++)
    //        free(argv[i]);
    //    free(argv);
}

- (IBAction)logoBtnClick:(UIButton *)sender
{
    NSThread * newT = [[NSThread alloc]initWithTarget:self selector:@selector(logo) object:nil];
    
    [newT start];
    
}

-(void)filter{
    char *outPic = (char *)[DocumentPath(@"filter.mp4") UTF8String];
    char *movie = (char *)[BundlePath(@"1.mp4") UTF8String];
    // 画格子
    //char *filter = "drawgrid=w=iw/3:h=ih/3:t=2:c=white@0.5";
    
    // 画矩形
    char *filter = "drawbox=x=10:y=20:w=200:h=60:color=red@0.5";
    
    // 裁剪
    //char *filter = "crop=in_w/2:in_h/2:(in_w-out_w)/2+((in_w-out_w)/2)*sin(n/10):(in_h-out_h)/2 +((in_h-out_h)/2)*sin(n/7)";
    
    char* argv[] = {
        "ffmpeg",
        "-i",
        movie,
        "-vf",
        filter,
        outPic
    };
    int argc = sizeof(argv)/sizeof(*argv);
    ffmpeg_main(argc, argv);
    for(int i=0;i<argc;i++)
        free(argv[i]);
    free(argv);
    
    //    NSString *commond = [NSString stringWithFormat:@"ffmpeg -i %@ -vf filter %@",BundlePath(@"1.mp4"),DocumentPath(@"filter.mp4")];
    //
    //    NSArray *argv_array = [commond componentsSeparatedByString:@" "];
    //    int argc = (int)argv_array.count;
    //    char **argv = malloc(sizeof(char)*1024);
    //    //把我们写的命令转成c的字符串数组
    //    for (int i = 0; i < argc; i++) {
    //        argv[i] = (char *)malloc(sizeof(char)*1024);
    //        strcpy(argv[i], [[argv_array objectAtIndex:i] UTF8String]);
    //    }
    //    ffmpeg_main(argc, argv);
    //
    //    for(int i=0;i<argc;i++)
    //        free(argv[i]);
    //    free(argv);
}

- (IBAction)filterBtnClick:(id)sender
{
    NSThread * newT = [[NSThread alloc]initWithTarget:self selector:@selector(filter) object:nil];
    
    [newT start];
}


-(void)removeLogo{
//    ffmpeg -i a.mp4 -b:v 548k -vf delogo=x=495:y=10:w=120:h=45:show=1 delogo.mp4
    char *movie = (char *)[BundlePath(@"1.mp4") UTF8String];
    char *outPic = (char *)[DocumentPath(@"remove.mp4") UTF8String];
    char* argv[] = {
        "ffmpeg",
        "-i",
        movie,
        "-vf",
        "delogo=x=72:y=32:w=168:h=86",
        "-vcodec",
        "mpeg4",
        outPic
    };
    int argc = sizeof(argv)/sizeof(*argv);
    ffmpeg_main(argc, argv);
    for(int i=0;i<argc;i++)
        free(argv[i]);
    free(argv);
    //    NSString *commond = [NSString stringWithFormat:@"ffmpeg -i %@ -vf delogo=x=72:y=32:w=168:h=86 -vcodec mpeg4 %@",BundlePath(@"1.mp4"),DocumentPath(@"remove.mp4")];
    //
    //    NSArray *argv_array = [commond componentsSeparatedByString:@" "];
    //    int argc = (int)argv_array.count;
    //    char **argv = malloc(sizeof(char)*1024);
    //    //把我们写的命令转成c的字符串数组
    //    for (int i = 0; i < argc; i++) {
    //        argv[i] = (char *)malloc(sizeof(char)*1024);
    //        strcpy(argv[i], [[argv_array objectAtIndex:i] UTF8String]);
    //    }
    //    ffmpeg_main(argc, argv);
    //
    //    for(int i=0;i<argc;i++)
    //        free(argv[i]);
    //    free(argv);
}
- (IBAction)removeLogoBtnClick:(id)sender{
    NSThread * newT = [[NSThread alloc]initWithTarget:self selector:@selector(removeLogo) object:nil];
    
    [newT start];
}

@end
