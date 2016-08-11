//
//  SearchUserViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "SearchUserViewController.h"

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
    [self initDataSource];
}

#pragma mark - private method

- (void)initInterface {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.tableHeaderView = self.searchVC.searchBar;
}

- (void)initDataSource {
    NSString * name = @"dd";
    NSMutableArray * arr = [@[@"aa",@"bb",@"cc"] mutableCopy];
    for (int i = 0; i < 10; i ++) {
        [arr addObject:name];
    }
    
    self.oldList = arr;
    [self refreshDataSource:self.oldList];
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
    return cell;
}

#pragma mark - search result

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"----active:%d",self.searchVC.isActive);
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
