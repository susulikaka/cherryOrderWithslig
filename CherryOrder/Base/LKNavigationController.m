//
//  LKNavigationController.m
//  lukou
//
//  Created by feifengxu on 14/11/28.
//  Copyright (c) 2014年 lukou. All rights reserved.
//

#import "LKNavigationController.h"

@interface LKNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>
@end

@implementation LKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    };
    self.navigationBar.barStyle = UIBarStyleDefault;
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 self.navigationBar.frame.size.height,
                                                                 self.navigationBar.frame.size.width,
                                                                 PX_1)];
    
    [navBorder setBackgroundColor:UIColorFromRGB(0xdcdcdc)];
    [navBorder setOpaque:YES];
    [self.navigationBar addSubview:navBorder];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                    style:UIBarButtonItemStylePlain
                                                                                   target:nil
                                                                                   action:nil];
    [self.interactivePopGestureRecognizer setEnabled:NO];
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (self.viewControllers.count <= 1) {
            [self.interactivePopGestureRecognizer setEnabled:NO];
        } else {
            [self.interactivePopGestureRecognizer setEnabled:YES];
        }
    }
}

- (BOOL)shouldAutorotate {
    if (DEVICE_IS_IPAD) {
        return YES;
    }
    return NO;
}

@end
