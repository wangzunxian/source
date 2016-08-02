//
//  WXImageLoop.m
//  SaySecret
//
//  Created by wang on 16/1/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "WXImageLoop.h"

@interface WXImageLoop ()<UIScrollViewDelegate> {
    UIPageControl *pageControl;
    NSInteger currentPage;
    UIScrollView *mscrollView;
    UIImageView *leftImage;
    UIImageView *rightImage;
    UIImageView *centerImage;
    float width;
    float height;
    NSInteger leftIndex;
    NSInteger rightIndex;
    NSInteger centerIndex;
    
    NSTimer *timer;
    NSTimeInterval timerInterval;
}

@end

@implementation WXImageLoop

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray position:(Position)position automaticPlay:(BOOL)automaticPlay{
    if(self = [super initWithFrame:frame]){
        //初始化数据
//        width = frame.size.width;
//        height = frame.size.height;
//        centerIndex = 0;
//        leftIndex = imageArray.count -1;
//        rightIndex = 1;
        _images = imageArray;
        _position = position;
        _autoPlay = automaticPlay;
    }
    return self;
}

//初始化视图控件
- (void) initView{
    
    //初始化数据
    width = self.bounds.size.width;
    height = self.bounds.size.height;
    centerIndex = 0;
    leftIndex = _images.count -1;
    rightIndex = 1;
    
    //初始化scrollView
    mscrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    mscrollView.contentSize = CGSizeMake(width*3, 0);
    mscrollView.showsHorizontalScrollIndicator = NO;
    mscrollView.showsVerticalScrollIndicator = NO;
    mscrollView.pagingEnabled = YES;
    mscrollView.delegate = self;
    [mscrollView setContentOffset:CGPointMake(width, 0) animated:YES];
    [self addSubview:mscrollView];
    
    //初始化pageControl
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(width * 3 / 4, height - 30, width / 4, 30)];
    pageControl.numberOfPages = _images.count;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:pageControl];
    
    //初始化Image
    leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [leftImage setImage:[UIImage imageNamed:_images[_images.count-1]]];
    
    centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    [centerImage setImage:[UIImage imageNamed:_images[0]]];
    
    rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(width *2, 0, width, height)];
    [rightImage setImage:[UIImage imageNamed:_images[1]]];
    
    [mscrollView addSubview:leftImage];
    [mscrollView addSubview:centerImage];
    [mscrollView addSubview:rightImage];
    
    if (_autoPlay && _images.count > 1) {
        //添加定时器
        NSString *imageLoopTime = [Utils getUserDefaultsForKey:kImageLoopTime];
        float defaultTimerInterVal;
        if (imageLoopTime == nil || [imageLoopTime isKindOfClass:[NSNull class]]) {
            defaultTimerInterVal = 3;
        }else{
            defaultTimerInterVal = [imageLoopTime floatValue];
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:defaultTimerInterVal target:self selector:@selector(changePage) userInfo:nil repeats:YES];
        timerInterval = timer.timeInterval;
    }
}

//当减速拖拽scrollView时执行该方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float contentOffset = scrollView.contentOffset.x;
    if (contentOffset != width) {
        //向后拖拽
        if (contentOffset == width * 2) {
            leftIndex = centerIndex;
            //边界判断
            centerIndex = (centerIndex + 1) % _images.count;
            rightIndex = (centerIndex + 1) % _images.count;
        }else{//向前拖拽
            rightIndex = centerIndex;
            centerIndex = (centerIndex - 1) % _images.count;
            leftIndex = (centerIndex - 1) % _images.count;
        }
        //更新信息
        [leftImage setImage:[UIImage imageNamed:_images[leftIndex]]];
        [centerImage setImage:[UIImage imageNamed:_images[centerIndex]]];
        [scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
        [rightImage setImage:[UIImage imageNamed:_images[rightIndex]]];
        currentPage = centerIndex;
        pageControl.currentPage = centerIndex;
    }
    if (_autoPlay && _images.count > 1) {
        //重置定时器
        timerInterval = timer.timeInterval;
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(changePage) userInfo:nil repeats:YES];
    }
}

//当定时器时间到时，执行该方法
- (void)changePage{
    //判断滚动方向
    if (_position == Right) {
        leftIndex = centerIndex;
        centerIndex = (centerIndex + 1) % _images.count;
        rightIndex = (centerIndex + 1) % _images.count;
    }else{
        rightIndex = centerIndex;
        centerIndex = (centerIndex - 1) % _images.count;
        leftIndex = (centerIndex - 1) % _images.count;
    }
    
    [centerImage setImage:[UIImage imageNamed:_images[centerIndex]]];
    [mscrollView setContentOffset:CGPointMake(width, 0) animated:YES];
    [leftImage setImage:[UIImage imageNamed:_images[leftIndex]]];
    [rightImage setImage:[UIImage imageNamed:_images[rightIndex]]];
    currentPage = centerIndex;
    pageControl.currentPage = centerIndex;
}

//当视图被加载时调用
- (void)layoutSubviews{
    WXLog(@"layoutSubViews");
    [self initView];
}

@end
