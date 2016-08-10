//
//  LKSSTabViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LKSSTabViewController.h"
#import "SSBustomBtn.h"
#import "HelpOrderViewController.h"
#import "PersonalHistoryViewController.h"
#import "AllOrderHistoryViewController.h"
#import "SettingViewController.h"
#import "AllHistoryViewController.h"

const NSInteger BTNTAG = 1000;
const CGFloat TABHEIGHT = 50;
const CGFloat VIEWORIGIN = 80;

@interface LKSSTabViewController ()

@property (weak, nonatomic) IBOutlet UIView *btnBackView;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation LKSSTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)initInterface {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.btnBackView.backgroundColor = [UIColor whiteColor];
    self.lineView.backgroundColor = LK_BACK_COLOR_LIGHT_GRAY;
    self.titleArr = @[@"历史",@"代点",@"全部",@"设置"];
    self.imageArr = @[@"icon_history",@"icon_help",@"icon_all",@"icon_more"];
    self.selImgArr = @[@"icon_history_sel",@"icon_help_sel",@"icon_all_sel",@"icon_more_sel"];
    self.currIndex = 0;
    [self actionFlow:self.currIndex];
    
    for (int i = 0; i < self.btnArr.count; i ++) {
        [self.btnBackView addSubview:self.btnArr[i]];
    }
    SSBustomBtn * btn = [self.view viewWithTag:BTNTAG+self.currIndex];
    [btn setSelected:YES];
}

- (void)actionFlow:(NSInteger)index {
    if (self.currIndex == index && self.currVC != nil) {
        return;
    }
    SSBustomBtn * lastBtn = [self.view viewWithTag:BTNTAG+self.currIndex];
    SSBustomBtn * curBtn = [self.view viewWithTag:BTNTAG+index];
    lastBtn.selected = NO;
    curBtn.selected = YES;
    UIViewController * lastVC = self.currVC;
    if (lastVC != nil) {
        [lastVC.view removeFromSuperview];
        [lastVC removeFromParentViewController];
        [lastVC didMoveToParentViewController:nil];
    }
    UIViewController * curVC;
    switch (index) {
        case 0:
        {
            PersonalHistoryViewController * perVC = [[PersonalHistoryViewController alloc] initWithNibName:nil bundle:nil];
            curVC = perVC;
        }
            break;
        case 1:
        {
            HelpOrderViewController * helpVC = [[HelpOrderViewController alloc] initWithNibName:nil bundle:nil];
            curVC = helpVC;
        }
            break;
        case 2:
        {
            AllHistoryViewController * allVC = [[AllHistoryViewController alloc] initWithNibName:nil bundle:nil];
//            AllOrderHistoryViewController * allVC = [[AllOrderHistoryViewController alloc] initWithNibName:nil bundle:nil];
            curVC = allVC;
        }
            
            break;
        case 3:
        {
            SettingViewController * accVC = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
            curVC = accVC;
        }
            break;
        default:
            break;
    }
    
    [self.view addSubview:curVC.view];
    [self addChildViewController:curVC];
    CGRect rect = CGRectMake(0, VIEWORIGIN, self.view.bounds.size.width, self.view.bounds.size.height-VIEWORIGIN);
    curVC.view.frame = CGRectOffset(rect, 0, 0);
    [curVC didMoveToParentViewController:self];
    NSLog(@"-----------------%lf,SCREEN_WIDTH:%lf",curVC.view.frame.size.width,SCREEN_WIDTH);
    self.currVC = curVC;
    self.currIndex = index;
}

#pragma mark - getter

- (NSArray *)btnArr {
    if (!_btnArr) {
        _btnArr = ({
            NSMutableArray * arr = [NSMutableArray array];
            
            for (int i = 0; i < self.titleArr.count; i ++) {
                SSBustomBtn * btn = [[SSBustomBtn alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/self.titleArr.count)*i, 0, SCREEN_WIDTH/self.titleArr.count, 50) title:self.titleArr[i] cordius:0 Type:SSBtnCordiusType tapBlock:^{
                    [self actionFlow:i];
                }];
                btn.tag = BTNTAG + i;
                [arr addObject:btn];
            }
            arr;
        });
    }
    return _btnArr;
}

- (NSArray *)VCArr {
    if (!_VCArr) {
        _VCArr = ({
            HelpOrderViewController * helpVC = [[HelpOrderViewController alloc] initWithNibName:nil bundle:nil];
            AllHistoryViewController * allVC = [[AllHistoryViewController alloc] initWithNibName:nil bundle:nil];
            PersonalHistoryViewController * perVC = [[PersonalHistoryViewController alloc] initWithNibName:nil bundle:nil];
            SettingViewController * accVC = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
            
            UINavigationController * nHelpVC = [[UINavigationController alloc] initWithRootViewController:helpVC];
            UINavigationController * nAllVC = [[UINavigationController alloc] initWithRootViewController:allVC];
            UINavigationController * nPerVC = [[UINavigationController alloc] initWithRootViewController:perVC];
            UINavigationController * nAccVC = [[UINavigationController alloc] initWithRootViewController:accVC];
            nHelpVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
            nAllVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
            nPerVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
            nAccVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
            NSArray * arr= @[nPerVC,nHelpVC,nAllVC,nAccVC];
            arr;
        });
    }
    return _VCArr;
}

@end
