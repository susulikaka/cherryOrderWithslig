//
//  AccountInfoViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "InfoItemCell.h"
#import "PhotoPickerViewController.h"
#import "SelectablePhotoAssets.h"
#import "PhotoAsset.h"
#import "RSKImageCropViewController.h"
#import "AccountInfoTableViewCell.h"

@interface AccountInfoViewController ()<RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray * datasource;

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initInterface];
}

#pragma mark - private method

- (void)initInterface {
    self.datasource = @[@[@"头像",@"昵称",@"生日",@"名片",@"电话",@"邮箱",@"部门"]];
    [self.tableView registerNib:[InfoItemCell nib] forCellReuseIdentifier:NSStringFromClass([InfoItemCell class])];
    [self.tableView registerNib:[AccountInfoTableViewCell nib] forCellReuseIdentifier:NSStringFromClass([AccountInfoTableViewCell class])];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datasource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)(self.datasource[section])).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
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
    InfoItemCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InfoItemCell class])];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.aTitleLabel.text = self.datasource[indexPath.section][indexPath.row];
    cell.aDetailLabel.text = self.datasource[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PhotoPickerViewController * vc = [[PhotoPickerViewController alloc] init];
        vc.viewCompact = YES;
        @weakify(vc);
        vc.selectionDoneAction = ^() {
            @strongify(vc);
            [self.navigationController popViewControllerAnimated:YES];
            SelectablePhotoAssets *result = vc.photoAssets.selectedPhotoAssets;
            PhotoAsset *photoAsset = result.assets.firstObject;
            if (photoAsset) {
                CGImageRef imageRef = [[photoAsset.asset defaultRepresentation] fullScreenImage];
                UIImage *image = [UIImage imageWithCGImage:imageRef];
                
                [LKUser sharedUser].image = UIImageJPEGRepresentation(image, 1.0);
                [[UserInfoManager sharedManager] saveUserInfo:[LKUser sharedUser]];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
