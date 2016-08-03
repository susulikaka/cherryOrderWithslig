//
//  AllHistoryViewController.m
//  CherryOrder
//
//  Created by admin on 16/7/28.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "AllHistoryViewController.h"
#import "OrderInfoViewController.h"
#import "SearchWordsCell.h"
#import "HistoryHeaderview.h"
#import "AllHistory.h"
#import "UserOrderInfo.h"

@interface AllHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray * dataSource;
@property (nonatomic, strong)NSArray * cellDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL noMore;
@property (nonatomic, strong)PullToBounceWrapper * PullToBounceWrapper;

@end

@implementation AllHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.noMore = NO;
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"所有历史";
    [self.tableView addSubview:self.PullToBounceWrapper];
    [self.PullToBounceWrapper didPullToRefresh];
    [self requestDate];
}

- (void)requestDate {
    self.dataSource = [NSMutableArray array];
    self.cellDataSource = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchWordsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SearchWordsCell class])];
    
    [[LKAPIClient sharedClient] requestGETForcurDateOrderList:@"order/all"
                                                       params:nil
                                                   modelClass:[AllHistory class]
                                            completionHandler:^(LKJSonModel *aModelBaseObject) {
                                                AllHistory * dic;
                                                if ([aModelBaseObject isKindOfClass:[AllHistory class]]) {
                                                    dic = (AllHistory *)aModelBaseObject;
                                                }
                                                if ([dic.end_time  isEqualToString:@"0"]) {
                                                    self.noMore = YES;
                                                }
                                                self.dataSource = [dic.list mutableCopy];
                                                [LKUser sharedUser].end_time = dic.end_time;
                                                [[UserInfoManager sharedManager] saveUserInfo:[LKUser sharedUser]];
                                                self.cellDataSource = [self getCellDataSource];
                                                [self.tableView reloadData];
                                                [self.PullToBounceWrapper stopLoadingAnimation];
                                            } errorHandler:^(LKAPIError *engineError) {
                                                [LKUOUtils showError:engineError.message];
                                            }];
}

- (NSArray *)getCellDataSource {
    
    NSMutableArray * mitArr = [NSMutableArray array];
    for (int i = 0; i < self.dataSource.count; i ++) {
        NSDictionary * dic = self.dataSource[i];
        NSMutableArray * inArr = [NSMutableArray array];
        NSArray * list = dic[@"list"];
        for (NSDictionary * smallDic in list) {
            [inArr addObject:smallDic[@"name"]];
        }
        [mitArr addObject:inArr];
    }
    return mitArr;
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchWordsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchWordsCell class])];
    [cell initWithDataSource:self.cellDataSource[indexPath.section] onTap:^(NSString *name) {
        
        OrderInfoViewController * vc = [[OrderInfoViewController alloc] initWithNibName:nil bundle:nil];
        vc.dataDic = @{@"name":name,@"date":self.dataSource[indexPath.section][@"date"]};
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = ((NSArray *)self.dataSource[indexPath.section][@"list"]).count;
    NSInteger cellRowCount = (int)((SCREEN_WIDTH-ITEM_SPACING) / ((NAME_COLLECTION_CELL_WIDTH+ITEM_SPACING))+0.5);
    CGFloat height = (int)((((count)/cellRowCount)+1)+0.5)*(NAME_COLLECTION_CELL_WIDTH+ITEM_SPACING);
    height += ITEM_SPACING/2;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray * nibArr = [[NSBundle mainBundle] loadNibNamed:@"HistoryHeaderview" owner:nil options:nil];
    HistoryHeaderview *header = nibArr[0];
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    header.dateLabel.text = self.dataSource[section][@"date"];
    header.countLabel.text = [NSString stringWithFormat:@"%@",self.dataSource[section][@"count"]];
    return header;
}

#pragma mark - private method

- (void)more {
    [[LKAPIClient sharedClient] requestGETForcurDateOrderList:@"order/all"
                                                       params:@{@"end_time":[LKUser sharedUser].end_time}
                                                   modelClass:[AllHistory class]
                                            completionHandler:^(LKJSonModel *aModelBaseObject) {
                                                AllHistory * dic;
                                                if ([aModelBaseObject isKindOfClass:[AllHistory class]]) {
                                                    dic = (AllHistory *)aModelBaseObject;
                                                }
                                                if (![dic.end_time  isEqualToString:@"0"]) {
                                                    [self.dataSource addObjectsFromArray:dic.list];
                                                } else {
                                                    self.noMore = YES;
                                                }
                                                self.cellDataSource = [self getCellDataSource];
                                                [self.tableView reloadData];
                                            } errorHandler:^(LKAPIError *engineError) {
                                                [LKUOUtils showError:engineError.message];
                                            }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
