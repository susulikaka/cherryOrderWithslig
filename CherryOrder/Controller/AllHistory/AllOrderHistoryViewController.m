//
//  AllOrderViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "AllOrderHistoryViewController.h"
#import "AllHistory.h"
#import "HistoryHeaderview.h"

@interface AllOrderHistoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray * dataSource;
@property (assign, nonatomic) BOOL noMore;
@property (strong, nonatomic) UIRefreshControl * refresh;

@end

@implementation AllOrderHistoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initInterface];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - private method

- (void)initInterface {
    self.title = @"全部历史";
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [self.collectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionElementKindSectionHeader];
    [self requestDate];
    [self.collectionView addSubview:self.refresh];
}

- (void)requestDate {
    self.dataSource = [NSMutableArray array];
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
                                                [self.collectionView reloadData];
                                                [self.refresh endRefreshing];
                                            } errorHandler:^(LKAPIError *engineError) {
                                                [LKUOUtils showError:engineError.message];
                                            }];
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ((NSArray *)self.dataSource[self.dataSource.count-1-section][@"list"]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    NSString * name = self.dataSource[self.dataSource.count-1-indexPath.section][@"list"][indexPath.row][@"name"];
    UILabel *label = [[UILabel alloc] init];
    label.bounds = CGRectMake(0, 0, NAME_COLLECTION_CELL_WIDTH, NAME_COLLECTION_CELL_WIDTH);
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = DARK_MAIN_COLOR.CGColor;
    label.layer.cornerRadius = label.bounds.size.height/2;
    label.layer.masksToBounds = YES;
    label.textColor = LK_TEXT_COLOR_GRAY;
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = [UIColor whiteColor];
    if (name.length > 2) {
        label.text = [name substringWithRange:NSMakeRange(name.length - 2, 2)];
    } else {
        label.text = name;
    }
    for (int i = (int)cell.contentView.subviews.count - 1; i >= 0; i --) {
        UIView *subView = [cell.contentView.subviews lastObject];
        [subView removeFromSuperview];
    }
    
    [cell.contentView addSubview:label];
    [label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 40);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString * reuserID;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reuserID = UICollectionElementKindSectionHeader;
    }
    UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuserID forIndexPath:indexPath];
    
    NSArray * nibArr = [[NSBundle mainBundle] loadNibNamed:@"HistoryHeaderview" owner:nil options:nil];
    HistoryHeaderview *header = nibArr[0];
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    header.dateLabel.text = self.dataSource[self.dataSource.count-1-indexPath.section][@"date"];
    header.countLabel.text = [NSString stringWithFormat:@"%@",self.dataSource[self.dataSource.count-1-indexPath.section][@"count"]];
    [view addSubview:header];
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < SCREEN_HEIGHT) {
        return;
    }
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) { // 最后一个cell完全进入视野范围内
        [self more];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

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
                                                [self.collectionView reloadData];
                                            } errorHandler:^(LKAPIError *engineError) {
                                                [LKUOUtils showToast:@"没有更多数据啦"];
                                            }];
}

#pragma mark - getter

- (UIRefreshControl *)refresh {
    if (!_refresh) {
        _refresh = [[UIRefreshControl alloc] init];
        [_refresh addTarget:self action:@selector(requestDate) forControlEvents:UIControlEventValueChanged];
    }
    return _refresh;
}

@end
