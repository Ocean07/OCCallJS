//
//  CalculateController.m
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import "CalculateController.h"
#import "CurrencyListController.h"
#import "CustSegmentCtl.h"
#import "CalculateInfoCell.h"
#import "CalculateResultListVC.h"
//#import "CalculateModels.h"
#import "CalculateViewModel.h"

@interface CalculateController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) CustSegmentCtl *segmentCtl;
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) CalculateViewModel *viewModel;
@end

@implementation CalculateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewModel = [[CalculateViewModel alloc] init];
    
    [self buildUI];
    // have now | savePM(分段) | rate | Y | count
    // -> count: have now | rate | savePM | Y
    // -> rate: have now | count | savePM | Y
    // -> long: have now | count | savePM | rate
    // -> savePM: have now | count | rate | Y
}

- (void)buildUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    // right item -> $
    NSString *currency = NSLocale.currentLocale.currencyCode;
    NSString *result = [NSLocale.currentLocale localizedStringForCurrencyCode:currency];
    NSString *symbol = [NSLocale.currentLocale displayNameForKey:NSLocaleCurrencySymbol value:currency];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:currency style:UIBarButtonItemStylePlain target:self action:@selector(changeCurrency:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // segmentCrl -> section header
    CGRect frame = CGRectMake((self.view.bounds.size.width - 300)/2, 20, 300, 45);
    self.segmentCtl = [[CustSegmentCtl alloc] initWithFrame:frame];
    [self.segmentCtl configSegmentItems:@[@"Count", @"Rate", @"Long", @"savePM"]];
    [self.view addSubview:self.segmentCtl];
    
    [self.view addSubview:self.tableView];

    // button
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = UIColor.lightGrayColor;
    btn.frame = CGRectMake(30, self.view.bounds.size.height - 70 - 64, self.view.bounds.size.width - 60, 50);
    [btn addTarget:self action:@selector(startCalculate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - actions
- (void)changeCurrency:(id)sender {
    CurrencyListController *currencyListVC = [[CurrencyListController alloc] init];
    currencyListVC.selectedCRY = self.navigationItem.rightBarButtonItem.title;
    currencyListVC.resultBlock = ^(NSString * currency) {
        [self.navigationItem.rightBarButtonItem setTitle:currency];
        
        // config datasource, refresh
    };
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:currencyListVC];
    [self presentViewController:navC animated:true completion:nil];
}

- (void)startCalculate {
    
    CGFloat haveNow = 0;
    CGFloat rate = 0;
    CGFloat savePM = 0;
    NSInteger howLong = 0;
    CGFloat totalCount = 0;
    
    for (CalInputModel *infoModel in self.viewModel.dataSource) {
        CalInputType inputType = infoModel.inputType;
        switch (inputType) {
            case CalInputTypeHavenow:
                haveNow = infoModel.value.floatValue;
                break;
            case CalInputTypeRate:
                rate = infoModel.value.floatValue;
                break;
            case CalInputTypeSvC:
                savePM = infoModel.value.floatValue;
                break;
            case CalInputTypeYC:
                howLong = infoModel.value.integerValue;
                break;
            case CalInputTypeTC:
                totalCount = infoModel.value.floatValue;
                break;
            default:
                break;
        }
    }
    
    NSInteger selectedIndex = self.segmentCtl.selectedIndex;
    NSLog(@"selectedIndex = %ld", (long)selectedIndex);
    NSArray *result = nil;
    if (selectedIndex == 0) {
        result = [self.viewModel calculateCountWithHaveNow:haveNow rate:rate sapm:savePM longY:howLong];
    } else if (selectedIndex == 1) {
        result = [self.viewModel calculateRateWithHaveNow:haveNow totalCount:totalCount sapm:savePM longY:howLong];
        if (result == nil) {
            // alert
            return;
        }
    } else if (selectedIndex == 2) {
        result = [self.viewModel calculateLongWithHaveNow:haveNow rate:rate sapm:savePM totalCount:totalCount];
        if (result == nil) {
            return;
        }
    } else if (selectedIndex == 3) {
        result = [self.viewModel calculateSavePMWithHaveNow:haveNow totalCount:totalCount rate:rate howLong:howLong];
        if (result == nil) {
            
            return;
        }
    }
    
    CalculateResultListVC *resultVC = [CalculateResultListVC new];
    resultVC.resultList = result;
    [self.navigationController pushViewController:resultVC animated:true];
}

- (void)itemChanged:(CalInputModel *)changedInfo {
    [self.viewModel changeItem:changedInfo];
}

#pragma mark - UITabelView delegate, datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CalculateInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    CalInputModel *inputModel = self.dataSource[indexPath.row];
    [cell showInfo:inputModel];
    cell.changeBlock = ^(CalInputModel * _Nonnull infoModel) {
        [self itemChanged:infoModel];
    };
    
    return cell;
}


#pragma mark - readonly
- (UITableView *)tableView {
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height - 150);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.tableFooterView = [UIView new];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:CalculateInfoCell.class forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
