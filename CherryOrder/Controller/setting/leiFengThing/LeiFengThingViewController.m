//
//  LeiFengThingViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LeiFengThingViewController.h"
#import "RefreshFootView.h"
#import "HistoryHeaderview.h"
#import "NameSelView.h"

@interface LeiFengThingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray * dataSource;
@property (assign, nonatomic) BOOL noMore;
@property (strong, nonatomic) UIRefreshControl * refresh;
@property (strong, nonatomic) RefreshFootView * refreshFoot;

@end

@implementation LeiFengThingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initInterface];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - private method

- (void)initInterface {
    self.title = @"我代点的";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"remove_btn"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(search)];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [self.collectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionElementKindSectionHeader];
    [self requestDate];
    [self.collectionView addSubview:self.refreshFoot];
    [self.collectionView addSubview:self.refresh];
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    [RACObserve(self.collectionView, contentSize) subscribeNext:^(id x) {
        CGFloat pointY = [x CGPointValue].y;
        [self.refreshFoot setFrame:CGRectMake(0, pointY, SCREEN_WIDTH, 80)];
    }];
}

- (void)requestDate {
    self.dataSource = [NSMutableArray array];
    NSMutableArray * list = [NSMutableArray arrayWithObjects:@{@"name":@"name",@"list":@"na",@"data":@"date"},@{@"name":@"name",@"list":@"na",@"data":@"date"},nil];
    NSMutableDictionary * arr = [@{@"name":@"11",@"count":@(12),@"list":[list mutableCopy]} mutableCopy];
    for (int i = 0; i < 10; i ++) {
        [self.dataSource addObject:[arr mutableCopy]];
    }
        [self.collectionView reloadData];
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ((NSArray *)self.dataSource[self.dataSource.count-1-section][@"list"]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString * name = self.dataSource[self.dataSource.count-1-indexPath.section][@"list"][indexPath.row][@"name"];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self earlierThenEndTime]>0) {
        return YES;
//    }
//    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < SCREEN_HEIGHT) {
        return;
    }
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) { // 最后一个cell完全进入视野范围内
        [self more];
    }
}

- (BOOL)earlierThenEndTime {
    NSDate * curDate = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * curStr = [formatter stringFromDate:curDate];
    NSString * tempCurStr = [curStr substringFromIndex:11];
    return ![tempCurStr compare:END_TIME_440];
}

- (void)search {
    // remove
    NSArray * selectedItems = self.collectionView.indexPathsForSelectedItems;
    for (NSIndexPath * indexPath in selectedItems) {
        [self.dataSource[self.dataSource.count-1-indexPath.section][@"list"] removeObjectAtIndex:indexPath.row];
    }
    [self.collectionView reloadData];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)more {
    NSMutableArray * list = [NSMutableArray arrayWithObjects:@{@"name":@"name",@"list":@"na",@"data":@"date"},@{@"name":@"name",@"list":@"na",@"data":@"date"},nil];
    NSMutableDictionary * arr = [@{@"name":@"11",@"count":@(12),@"list":[list mutableCopy]} mutableCopy];
        for (int i = 0; i < 10; i ++) {
            [self.dataSource addObject:arr];
        }
        [self.collectionView reloadData];
    
//    [[LKAPIClient sharedClient] requestGETForcurDateOrderList:@"order/all"
//                                                       params:@{@"end_time":[LKUser sharedUser].end_time}
//                                                   modelClass:[AllHistory class]
//                                            completionHandler:^(LKJSonModel *aModelBaseObject) {
//                                                AllHistory * dic;
//                                                if ([aModelBaseObject isKindOfClass:[AllHistory class]]) {
//                                                    dic = (AllHistory *)aModelBaseObject;
//                                                }
//                                                if (![dic.end_time  isEqualToString:@"0"]) {
//                                                    [self.dataSource addObjectsFromArray:dic.list];
//                                                } else {
//                                                    self.noMore = YES;
//                                                }
//                                                [self.collectionView reloadData];
//                                            } errorHandler:^(LKAPIError *engineError) {
//                                            }];
}

#pragma mark - getter

- (RefreshFootView *)refreshFoot {
    if (!_refreshFoot) {
        _refreshFoot = [RefreshFootView viewFromNib];
        self.refreshFoot.frame = CGRectMake(0, self.collectionView.frame.size.height, SCREEN_WIDTH, 80);
    }
    return _refreshFoot;
}

- (UIRefreshControl *)refresh {
    if (!_refresh) {
        _refresh = [[UIRefreshControl alloc] init];
        [_refresh addTarget:self action:@selector(requestDate) forControlEvents:UIControlEventValueChanged];
    }
    return _refresh;
}

@end
