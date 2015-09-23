//
//  PictureLoopView.m
//  PictureLoop
//
//  Created by Jefferson on 15/9/23.
//  Copyright © 2015年 Jefferson. All rights reserved.
//

#import "PictureLoopView.h"

#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height
#define KpageCount 5

@interface PictureLoopView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

// 核心
@property (nonatomic, strong) NSMutableSet *visibleImageViews;
@property (nonatomic, strong) NSMutableSet *reusedImageViews;
@property (nonatomic, strong) NSTimer *timer;

// 图片数组
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger page;
@end

@implementation PictureLoopView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    CGRect rect = self.bounds;
    rect.size.height = 200;
    self.bounds = rect;
    
    [self addScrollView];
    [self addPageControl];
    
    return self;
}

// 添加scrollView
- (void)addScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.contentSize = CGSizeMake(self.imageNames.count * CGRectGetWidth(_scrollView.bounds), 200);
    //    NSLog(@"%zd", self.imageNames.count);
    //    self.scrollView.contentOffset = CGPointMake(Kwidth, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.scrollView];
    
    [self showImageViewAtIndex:0];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger page = offSetX / scrollView.bounds.size.width;
    
    self.pageControl.currentPage = page;
    NSLog(@"%zd",page);
    
    [self showCurrentImages];
    //    [self test];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

- (void)test {
    NSMutableString *rs = [NSMutableString string];
    NSInteger count = [self.scrollView.subviews count];
    for (UIImageView *imageView in self.scrollView.subviews) {
        [rs appendFormat:@"%p - ", imageView];
    }
    [rs appendFormat:@"%ld", (long)count];
    NSLog(@"%@", rs);
}

#pragma mark - Private Method

- (void)showCurrentImages {
    
    NSInteger page = self.pageControl.currentPage;
    
    page = page % 6;
    
    // 获取当前索引
    CGRect visibleBounds = self.scrollView.bounds;
    CGFloat minX = CGRectGetMinX(visibleBounds);
    CGFloat maxX = CGRectGetMaxX(visibleBounds);
    CGFloat width = CGRectGetWidth(visibleBounds);
    
    NSInteger firstIndex = (NSInteger)floorf(minX / width);
    NSInteger lastIndex = (NSInteger)floorf(maxX / width);
    
    //     处理越界情况
    if (firstIndex < 0) {
        firstIndex = 0;
    }
    
    if (lastIndex >= self.imageNames.count) {
        lastIndex = self.imageNames.count - 1;
    }
    
    // 回收不需要显示的图片
    NSInteger imageViewIndex = 0;
    for (UIImageView *imageView in self.visibleImageViews) {
        imageViewIndex = imageView.tag;
        
        // 不在显示范围
        if (imageViewIndex < firstIndex || imageViewIndex > lastIndex) {
            [self.reusedImageViews addObject:imageView];
            [imageView removeFromSuperview];
        }
    }
    
    [self.visibleImageViews minusSet:self.reusedImageViews];
    
    // 是否需要新的视图
    for (NSInteger index = firstIndex; index <= lastIndex; index++) {
        BOOL isShow = NO;
        
        for (UIImageView *imageView  in self.visibleImageViews) {
            if (imageView.tag == index) {
                isShow = YES;
            }
        }
        
        if (!isShow) {
            // TODO: 待续
            [self showImageViewAtIndex:index];
        }
    }
}

// 显示一个图片的view
- (void)showImageViewAtIndex:(NSInteger)index {
    
    UIImageView *imageView = [self.reusedImageViews anyObject];
    
    if (imageView) {
        [self.reusedImageViews removeObject:imageView];
    } else {
        
        imageView = [[UIImageView alloc] init];
        //        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    CGRect bounds = self.scrollView.bounds;
    CGRect imageViewFrame = bounds;
    imageViewFrame.origin.x = CGRectGetWidth(bounds) * index;
    imageView.tag = index;
    imageView.frame = imageViewFrame;
    imageView.image = [UIImage imageNamed:self.imageNames[index]];
    
    [self.visibleImageViews addObject:imageView];
    [self.scrollView addSubview:imageView];
}

// 分页控件
- (void)addPageControl {
    
    CGFloat x = CGRectGetMaxX(self.bounds) - 100;
    CGFloat y = CGRectGetMaxY(self.bounds) - 20;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(x, y, 80, 30)];
    self.pageControl.numberOfPages = KpageCount;
    self.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.currentPage = self.page;
    //    NSLog(@"%zd",self.page);
    
    [self addSubview:self.pageControl];
}

// 定时器
- (void)addTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showCurrentImages) userInfo:nil repeats:YES];
}

- (void)removeTimer {
    [self.timer invalidate];
}

#pragma mark - Getters and Setters

- (NSArray *)imageNames {
    
    if (_imageNames == nil) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:50];
        
        for (int i=0; i < 50; ++i) {
            NSString *imageName = [NSString stringWithFormat:@"%d",i % 6];
            
            [tempArray addObject:imageName];
        }
        _imageNames = tempArray;
    }
    return _imageNames;
}

- (NSMutableSet *)visibleImageViews {
    
    if (!_visibleImageViews) {
        _visibleImageViews = [[NSMutableSet alloc] init];
    }
    return _visibleImageViews;
}

- (NSMutableSet *)reusedImageViews {
    
    if (!_reusedImageViews) {
        _reusedImageViews = [[NSMutableSet alloc] init];
    }
    return _reusedImageViews;
}


@end
