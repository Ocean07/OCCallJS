//
//  CalculateResultListVC.m
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import "CalculateResultListVC.h"

@interface CalculateResultListVC () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UILabel *headerLabel;
@property(nonatomic, assign) BOOL expand;
@end

@implementation CalculateResultListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
}

- (void)buildUI {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    
    CalResultModel *resultModel = self.resultList.firstObject;
    CalResultType type = resultModel.resultType;
    if (type == CalResultTypeTC) {
        _headerLabel.text = [NSString stringWithFormat:@"total: %.2f", resultModel.total];
    } else if (type == CalResultTypeRate) {
        _headerLabel.text = [NSString stringWithFormat:@"rate: %.2f%%", resultModel.rate*100];
    } else if (type == CalResultTypeYC) {
        _headerLabel.text = [NSString stringWithFormat:@"YC: %.1f", resultModel.longY];
    } else if (type == CalResultTypeSavePM) {
        _headerLabel.text = [NSString stringWithFormat:@"pm: %.2f", resultModel.savePM];
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"expand" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAct)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - actions
- (void)rightItemAct {
    for (CalResultModel *model in self.resultList) {
        model.expand = !model.expand;
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.resultList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CalResultModel *resultM = self.resultList[section];
    if (resultM.expand) {
        return resultM.results.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    CalResultModel *resultM = self.resultList[indexPath.section];
    
    CGFloat count = [resultM.results[indexPath.row] floatValue];
    CGFloat wC = count / 10000;
    cell.textLabel.text = [NSString stringWithFormat:@"%.4f", wC];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect frame = cell.frame;
    frame.origin.x = -frame.size.width;
    cell.frame = frame;
    frame.origin.x = 0;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        cell.frame = frame;
    } completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *container = [UIView new];
    container.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
    container.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(15, (50-35)/2, 150, 35);
    label.textColor = UIColor.blackColor;
    [container addSubview:label];
    
    CalResultModel *resultM = self.resultList[section];
    CGFloat count = [resultM.results.lastObject floatValue];
    CGFloat wC = count / 10000;
    label.text = [NSString stringWithFormat:@"%.4f --> %@", wC, @(section+1)];
    
    return container;
}

#pragma mark - getters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
        
        _headerLabel = [UILabel new];
        _headerLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 80);
        _headerLabel.textColor = UIColor.purpleColor;
        _tableView.tableHeaderView = _headerLabel;
    }
    return _tableView;
}

@end
