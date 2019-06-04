//
//  ScrollViewController.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/3.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 300, 300)];
    self.mainScrollView.backgroundColor = [UIColor grayColor];
    self.mainScrollView.contentSize = CGSizeMake(100, 1000);
    self.mainScrollView.delegate = self;
    
    [self.view addSubview:self.mainScrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"__ScrollViewController Test");
}

@end
