//
//  CurrencyListController.m
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import "CurrencyListController.h"

@interface CurrencyListController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) CurrencyListViewModel *viewModel;
@end

@implementation CurrencyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [[CurrencyListViewModel alloc] init];
    [self buildUI];
}

- (void)buildUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.title = @"Currency";
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView delegate, UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.currencyArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *currency = self.viewModel.currencyArr[indexPath.row];
    cell.textLabel.text = currency;
    if ([currency isEqualToString:self.selectedCRY]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSString *currency = self.viewModel.currencyArr[indexPath.row];
    if (self.resultBlock) {
        self.resultBlock(currency);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - readonly
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 65;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end



#pragma mark - CurrencyListViewModel

@interface CurrencyListViewModel()
@end

@implementation CurrencyListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _currencyArr = NSLocale.ISOCurrencyCodes;
    }
    return self;
}

@end
