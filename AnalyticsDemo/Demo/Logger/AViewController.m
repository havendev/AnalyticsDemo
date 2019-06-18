//
//  AViewController.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/5/28.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "AViewController.h"

@interface AViewController ()
@property (weak, nonatomic) IBOutlet UIButton *playerButton;


@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"icon_exit"];
    NSLog(@"__image %@", image.accessibilityIdentifier);
    [self.playerButton setImage:image forState:UIControlStateNormal];
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setImage:image forState:UIControlStateNormal];
    testButton.frame = CGRectMake(100, 100, 34, 39);
    [testButton addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
}

- (IBAction)play:(UIButton *)sender {
    
}

- (IBAction)test:(UIButton *)sender {
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
