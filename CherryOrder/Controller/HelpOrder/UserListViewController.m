//
//  UserListViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/1.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "UserListViewController.h"
#import "UserList.h"
#import "UIButton+stateColor.h"
#import "NameSelView.h"
#import "RegisterView.h"

@interface UserListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)NSArray        * userListDataSource;
@property (nonatomic, strong)NSMutableArray * addOrderList;

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshListView) name:@"refreshOrderBtn" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"添加代点用户";
    self.UserListCollectionView.backgroundColor = [UIColor whiteColor];
    [self.UserListCollectionView registerClass:[NameSelView class] forCellWithReuseIdentifier:NSStringFromClass([NameSelView class])];
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus-symbol"] style:UIBarButtonItemStylePlain target:self action:@selector(addUser)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = [UIColor whiteColor];
    self.UserListCollectionView.allowsMultipleSelection = YES;
    [self requestData];
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.userListDataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(NAME_COLLECTION_CELL_WIDTH, NAME_COLLECTION_CELL_WIDTH);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *name = [self.userListDataSource objectAtIndex:indexPath.row][@"name"];
    NameSelView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NameSelView class])
                                                                  forIndexPath:indexPath];
    
    NameSelView * view = [NameSelView viewFromNib];
    view.bounds = CGRectMake(0, 0, NAME_COLLECTION_CELL_WIDTH, NAME_COLLECTION_CELL_WIDTH);
    [view renderWithName:name enabled:YES];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.addOrderList addObject:self.userListDataSource[indexPath.row][@"name"]];
    NameSelView * cell = (NameSelView *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.mark.highlighted = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.addOrderList removeObject:self.userListDataSource[indexPath.row][@"name"]];
}

#pragma mark - private method

- (void)requestData {
    self.userListDataSource = [NSMutableArray array];
    self.addOrderList = [NSMutableArray array];
    [[LKAPIClient sharedClient] requestGETForUserList:@"user/all" params:nil modelClass:[UserList class] completionHandler:^(LKJSonModel *aModelBaseObject) {
        
        UserList * list ;
        if ([aModelBaseObject isKindOfClass:[UserList class]]) {
            list = (UserList *)aModelBaseObject;
        }
        self.userListDataSource = [list.list mutableCopy];
        [self.UserListCollectionView reloadData];
    } errorHandler:^(LKAPIError *engineError) {
        [LKUOUtils showError:engineError.message];
    }];
}

- (void)addUser {
    RegisterView * view = [RegisterView viewFromNib];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.view addSubview:view];
    [view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)refreshListView {
    [self requestData];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)back {
    NSMutableArray * nameArr = [NSMutableArray array];
    NSMutableArray * rowArr = [NSMutableArray array];
    
    NSArray * selIndexArr = self.UserListCollectionView.indexPathsForSelectedItems;
    for (NSIndexPath * path in selIndexArr) {
        [rowArr addObject:@(path.row)];
    }
    for (id row in rowArr) {
        [nameArr addObject:self.userListDataSource[[row intValue]][@"name"]];
        [[UserInfoManager sharedManager] addUserList:self.userListDataSource[[row intValue]][@"name"]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
