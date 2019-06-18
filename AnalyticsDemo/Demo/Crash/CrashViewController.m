//
//  CrashViewController.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/14.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "CrashViewController.h"

typedef struct Test {
    int a;
    int b;
} Test;

@interface CrashViewController ()

@end

@implementation CrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)arrayButtonAction:(UIButton *)sender {
    //信号捕捉不到的奔溃信息
    NSArray *array= @[@"tom", @"xxx", @"ooo"];
    [array objectAtIndex:5];
}

- (IBAction)threadButtonAction:(UIButton *)sender {
    
}

- (IBAction)mainThreadButtonAction:(UIButton *)sender {
    
}

- (IBAction)wildPointerButtonAction:(id)sender {
    //EXC_BAD_ACCESS 引起的奔溃信息,可通过信号进行捕捉
    Test *pTest = {1, 2};
    free(pTest);//导致SIGABRT的错误，因为内存中根本就没有这个空间，哪来的free，就在栈中的对象而已
    pTest->a = 5;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
