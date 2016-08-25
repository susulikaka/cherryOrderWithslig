//
//  SearchUserViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "SearchUserViewController.h"
#import "UserList.h"
#import "UserInfoViewController.h"

@interface SearchUserViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating>

@property (strong, nonatomic) UISearchController *searchVC;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * oldList;
@property (nonatomic, strong) NSMutableArray * resultList;

@end

@implementation SearchUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initInterface];
    [self requestData];
}

#pragma mark - private method

- (void)initInterface {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.tableHeaderView = self.searchVC.searchBar;
    self.tableView.tableFooterView = [UIView new];
}

- (void)requestData {
    self.oldList = [NSMutableArray array];
    [[LKAPIClient sharedClient] requestGETForUserList:@"user/all" params:nil modelClass:[UserList class] completionHandler:^(LKJSonModel *aModelBaseObject) {
        
        UserList * list ;
        if ([aModelBaseObject isKindOfClass:[UserList class]]) {
            list = (UserList *)aModelBaseObject;
        }
        for (NSDictionary * dic in list.list) {
            [self.oldList addObject:dic[@"name"]];
        }
        [self refreshDataSource:self.oldList];
    } errorHandler:^(LKAPIError *engineError) {
        [LKUIUtils showError:engineError.message];
    }];
}

- (void)refreshDataSource:(NSArray *)list {
    self.dataSource = [list mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoViewController * vc = [[UserInfoViewController alloc] initWithNibName:nil bundle:nil];
    vc.name = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - search result

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (self.searchVC.isActive) {
        NSString * value = [self.searchVC.searchBar.text lowercaseString];
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",value];
        self.resultList = [[self.oldList filteredArrayUsingPredicate:searchPredicate] mutableCopy];
        if (self.resultList.count != 0) {
            [self refreshDataSource:self.resultList];
        } else {
            [self refreshDataSource:self.oldList];
        }
    }
}

#pragma mark -getter

- (UISearchController *)searchVC {
    if (!_searchVC) {
        _searchVC = ({
            UISearchController * vc = [[UISearchController alloc] initWithSearchResultsController:nil];
            vc.searchResultsUpdater = self;
            vc.dimsBackgroundDuringPresentation = YES;
            [vc.searchBar sizeToFit];
            [vc.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
            vc.searchBar.tintColor = MAIN_COLOR;
            vc.searchBar.placeholder = @"请输入姓名";
            vc.searchBar.backgroundColor = LK_BACK_COLOR_LIGHT_GRAY;
            vc;
        });
    }
    return _searchVC;
}


@end
