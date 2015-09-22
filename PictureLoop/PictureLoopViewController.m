//
//  PictureLoopViewController.m
//  PictureLoop
//
//  Created by Jefferson on 15/9/22.
//  Copyright © 2015年 Jefferson. All rights reserved.
//

#import "PictureLoopViewController.h"

#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height
#define KpageCount 5

@interface PictureLoopViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation PictureLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self layoutSubViews];
}

// 添加scrollView
- (void)addScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, 200)];
    self.scrollView.contentSize = CGSizeMake(Kwidth * 5, 200);
    self.scrollView.contentOffset = CGPointMake(Kwidth, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.scrollView];
}

// 添加图片
- (void)addImageViewToScrollView {
    
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Kwidth, Kheight)];
    self.currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Kwidth, 0, Kwidth, Kheight)];
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Kwidth * 2, 0, Kwidth, Kheight)];
    
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.currentImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.leftImageView];
    [self.view addSubview:self.currentImageView];
    [self.view addSubview:self.rightImageView];
    
}

// 分页控件
- (void)addPageControl {
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(280, 170, 80, 30)];
    self.pageControl.numberOfPages = KpageCount;
    self.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    self.pageControl.userInteractionEnabled = NO;
    
    [self.view addSubview:self.pageControl];
}

- (void)setImageByCurrentPage:(NSInteger)currentPage {
    
    NSArray *images = @[@"bbqner", @"zghsy", @"mmgw", @"jxtz", @"ertsd"];
    
    self.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",KpageCount - 1]];
    self.currentImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",0]];
    self.rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",0]];
    currentPage = 0;
    
    self.pageControl.currentPage = currentPage;
    
    
    
    
    
}

// 布局控件
- (void)layoutSubViews {
    
    [self addScrollView];
    [self addImageViewToScrollView];
    [self addPageControl];
}



@end
