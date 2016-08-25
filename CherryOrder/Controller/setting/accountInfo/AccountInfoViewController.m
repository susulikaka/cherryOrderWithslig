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
#import "SSAlertView.h"

@interface AccountInfoViewController ()<RSKImageCropViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * datasource;

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self initInterface];
}

#pragma mark - private method

- (void)initInterface {
//    self.datasource = @[@[@"头像"],@[@"昵称",@"生日",@"名片",@"电话",@"邮箱",@"部门"]];
    self.datasource = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObject:@"touxiang"],[NSMutableArray arrayWithObjects:@"昵称",@"生日",@"名片",@"电话",@"邮箱",@"部门", nil], nil];
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

    if (indexPath.section == 0 && indexPath.row == 0) {
        AccountInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccountInfoTableViewCell class])];
//        NSData * imgData = [[UserInfoManager sharedManager] getUserInfo].image;
//        UIImage * img = [UIImage imageWithData:imgData];
//        if (img == nil) {
            cell.accountImg.image = [UIImage imageNamed:@"lukou"];
//        }
//        cell.accountImg.image = img;
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
    if (indexPath.section == 0 && indexPath.row == 0) {
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
    } else if (indexPath.section ==1) {
        if (indexPath.row != 1 && indexPath.row != 2) {
            SSAlertView * alert = [SSAlertView viewFromNib];
            [alert rendWithText:self.datasource[indexPath.section][indexPath.row]
                          value:self.datasource[indexPath.section][indexPath.row]
                      superView:self.view
                        okBlock:^(NSString *value) {
                [self reloadDateAtIndexPath:indexPath value:value];
            } cancelBlock:^{}];
        } else if (indexPath.row == 1) {
            SSAlertView * alert = [SSAlertView viewFromNib];
            [alert rendWithDatePicker:self.datasource[indexPath.section][indexPath.row]
                                 date:[NSDate date]
                            superView:self.view
                              okBlock:^(NSString *value) {
                [self reloadDateAtIndexPath:indexPath value:value];
            } cancelBlock:^{}];
        } else if (indexPath.row == 2) {
            SSAlertView * alert = [SSAlertView viewFromNib];
            [alert rendWithValuePicker:self.datasource[indexPath.section][indexPath.row]
                               pickArr:self.datasource[1]
                             superView:self.view
                               okBlock:^(NSString *value) {
               [self reloadDateAtIndexPath:indexPath value:value];
            } cancelBlock:^{}];
        }
    }
}

#pragma mark - private method

- (void)reloadDateAtIndexPath:(NSIndexPath *)indexPath value:(NSString *)value {
    if (value == nil) {
        return ;
    }
    [self.datasource[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:value];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
