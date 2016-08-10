//
//  AccountInfoViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "SettingViewController.h"
#import "MyOrderSettingViewController.h"
#import "MyNewsViewController.h"
#import "LeiFengThingViewController.h"
#import "RegisterViewController.h"
#import "AccountInfoViewController.h"
#import "VotingForRestaurantViewController.h"
#import "AccountInfoTableViewCell.h"
#import "AlarmSettingTableViewCell.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray * datasource;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initInterface];
}

#pragma mark - private method

- (void)initInterface {
    self.datasource = @[@[@"个人资料"],@[@"私人订制",@"我代点的",@"我要投票",@"我的消息",@"我的报销",@"关闭提醒"],@[@"退出",@"返回主页"]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerNib:[AccountInfoTableViewCell nib] forCellReuseIdentifier:NSStringFromClass([AccountInfoTableViewCell class])];
    [self.tableView registerNib:[AlarmSettingTableViewCell nib] forCellReuseIdentifier:NSStringFromClass([AlarmSettingTableViewCell class])];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datasource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)(self.datasource[section])).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AccountInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccountInfoTableViewCell class])];
        NSData * imgData = [[UserInfoManager sharedManager] getUserInfo].image;
        UIImage * img = [UIImage imageWithData:imgData];
        if (img == nil) {
            cell.accountImg.image = [UIImage imageNamed:@"personals"];
        }
        cell.accountImg.image = img;
        cell.titleView.text = [[UserInfoManager sharedManager] getUserInfo].name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1 && indexPath.row == 5) {
        AlarmSettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AlarmSettingTableViewCell class])];
        cell.titleView.text = self.datasource[indexPath.section][indexPath.row];
        [cell.switchView setOn:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section != 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.datasource[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"personal"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AccountInfoViewController * vc = [[AccountInfoViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            MyOrderSettingViewController * vc = [[MyOrderSettingViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            LeiFengThingViewController * vc = [[LeiFengThingViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            VotingForRestaurantViewController * vc = [[VotingForRestaurantViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 3){
            MyNewsViewController * vc = [[MyNewsViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
        }
    } else if(indexPath.section == 2) {
        if (indexPath.row == 0) {
            RegisterViewController * vc = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

@end
