//
//  HelpOrderViewController.m
//  CherryOrder
//
//  Created by admin on 16/7/30.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "HelpOrderViewController.h"
#import "LKMSimpleMsg.h"
#import "UserListViewController.h"
#import "UserList.h"
#import "UIButton+stateColor.h"
#import "NameSelView.h"

@interface HelpOrderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong)NSMutableArray * helpOrderDataSource;

@end

@implementation HelpOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
    [self initInterface];
}

#pragma mark - private method 

- (void)requestData {
//    [[UserInfoManager sharedManager] removeUserList];
    self.helpOrderDataSource = [[[[UserInfoManager sharedManager] getUserList] mutableCopy][[[UserInfoManager sharedManager] getUserInfo].name] mutableCopy];
//    [self.helpOrderDataSource removeAllObjects];
    for (int i = 0; i < self.helpOrderDataSource.count; i ++) {
        id value = self.helpOrderDataSource[i];
        if (![value isKindOfClass:[NSDictionary class]] && [value isKindOfClass:[NSString class]]) {
            NSDictionary * dic = @{@"name":value,@"has_ordered":@(YES)};
            [self.helpOrderDataSource replaceObjectAtIndex:i withObject:dic];
        }
    }
    NSMutableArray * nameArr = [NSMutableArray array];
    for (int i = 0; i < self.helpOrderDataSource.count; i ++) {
        if ([self.helpOrderDataSource[i] isKindOfClass:[NSDictionary class]]) {
            [nameArr addObject:self.helpOrderDataSource[i][@"name"]];
        } else {
            [nameArr addObject:self.helpOrderDataSource[i]];
        }
        
    }
    NSString * nameStr = [nameArr componentsJoinedByString:@"|"];
    if (nameStr.length <= 0) {
        return;
    }
    [[LKAPIClient sharedClient] requestGETForcurDateOrderList:@"users" params:@{@"list":nameStr} modelClass:[UserList class] completionHandler:^(LKJSonModel *aModelBaseObject) {
        self.helpOrderBtn.enabled = YES;
        UserList * dic;
        if ([aModelBaseObject isKindOfClass:[UserList class]]) {
            dic = (UserList *)aModelBaseObject;
        }
        self.helpOrderDataSource = dic.list;
        [self.collectionView reloadData];
    } errorHandler:^(LKAPIError *engineError) {
        self.helpOrderBtn.enabled = NO;
        [LKUIUtils showError:engineError.message];
    }];
}

-(void)initInterface {
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus-symbol"] style:UIBarButtonItemStylePlain target:self action:@selector(addUserList)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.title = @"帮人代点";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.helpOrderBtn.backgroundColor = BLUE_COLOR;
    self.helpOrderBtn.layer.cornerRadius = self.helpOrderBtn.bounds.size.height/2;
    self.helpOrderBtn.layer.masksToBounds = YES;
    [self.collectionView reloadData];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    self.collectionView.allowsMultipleSelection = YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (buttonIndex == 1) {
        [self requestData];
    }
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.helpOrderDataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(NAME_COLLECTION_CELL_WIDTH, NAME_COLLECTION_CELL_WIDTH);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [self.helpOrderDataSource objectAtIndex:indexPath.row][@"name"];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])
                                                                           forIndexPath:indexPath];
    
    NameSelView * view = [NameSelView viewFromNib];
    view.bounds = CGRectMake(0, 0, NAME_COLLECTION_CELL_WIDTH, NAME_COLLECTION_CELL_WIDTH);
    [view renderWithName:name enabled:![self.helpOrderDataSource[indexPath.row][@"has_ordered"] boolValue]];
    if (name.length > 2) {
        view.name.text = [name substringWithRange:NSMakeRange(name.length - 2, 2)];
    } else {
        view.name.text = name;
    }
    while ([cell.contentView.subviews count] != 0) {
        UIView *subView = [cell.contentView.subviews lastObject];
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:view];
    [view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.helpOrderDataSource[indexPath.row][@"has_ordered"] boolValue]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - action

- (IBAction)helpOderAction:(id)sender {
    
    NSMutableArray * nameArr = [NSMutableArray array];
    NSMutableArray * rowArr = [NSMutableArray array];
    
    NSArray * selIndexArr = self.collectionView.indexPathsForSelectedItems;
    NSString * nameStr = [NSString string];
    for (NSIndexPath * path in selIndexArr) {
        [rowArr addObject:@(path.row)];
    }
    
    for (id row in rowArr) {
        [nameArr addObject:self.helpOrderDataSource[[row integerValue]][@"name"]];
    }
    
    nameStr = [nameArr componentsJoinedByString:@"|"];
    
    [[LKAPIClient sharedClient] requestPOSTForHelpOrder:@"order/agent"
                                                 params:@{@"name":[[UserInfoManager sharedManager] getUserInfo].name,@"list":nameStr}
                                             modelClass:[LKMSimpleMsg class]
                                      completionHandler:^(LKJSonModel *aModelBaseObject) {
        LKMSimpleMsg * dic;
        if ([aModelBaseObject isKindOfClass:[LKMSimpleMsg class]]) {
            dic = (LKMSimpleMsg *)aModelBaseObject;
        }
        UIAlertView * alert = [[UIAlertView alloc]
                               initWithTitle:@"订餐成功"
                               message:@""
                               delegate:self
                               cancelButtonTitle:@"返回上一页"
                               otherButtonTitles:@"继续",
                               nil];
        
        [self.view addSubview:alert];
        [alert show];
    } errorHandler:^(LKAPIError *engineError) {
        UIAlertView * alert = [[UIAlertView alloc]
                               initWithTitle:engineError.message
                               message:@""
                               delegate:self
                               cancelButtonTitle:@"返回上一页"
                               otherButtonTitles:@"再试一次",
                               nil];
        [self.view addSubview:alert];
        [alert show];
    }];
}

- (void)addUserList {
    UserListViewController * vc = [[UserListViewController alloc] initWithNibName:@"UserListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:nil];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
