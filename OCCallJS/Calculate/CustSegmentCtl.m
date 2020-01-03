//
//  CustSegmentCtl.m
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import "CustSegmentCtl.h"

@interface CustSegmentCtl()
@property(nonatomic, strong) UIView *backTitleContainer; // some
@property(nonatomic, strong) UIView *titleContainer;
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, copy) NSArray *items;
@property(nonatomic, assign) NSInteger selectedIndex;
@end

@implementation CustSegmentCtl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backTitleContainer.frame = self.bounds;
    self.titleContainer.frame = self.bounds;
    
    // config items frames
    NSArray *backItems = self.backTitleContainer.subviews;
//    NSArray *forginItems = self.titleContainer.subviews;
//    if (backItems.count == 0 || backItems.count !=forginItems.count) {
//        return;
//    }
    
    CGFloat itemW = self.bounds.size.width / backItems.count;
    CGFloat itemH = self.bounds.size.height;
    for (NSInteger index = 0; index < backItems.count; index ++) {
        CGRect frame = CGRectMake(itemW * index, 0, itemW, itemH);
        
        UIView *backItem = backItems[index];
        backItem.frame = frame;
//        UIView *forginItem = forginItems[index];
//        forginItem.frame = frame;
    }
    
    self.titleContainer.frame = CGRectMake(itemW * self.selectedIndex, 0, itemW, itemH);

    
}

- (void)buildUI {
    self.backTitleContainer = [UIView new];
    [self addSubview:self.backTitleContainer];
    
    self.titleContainer = [UIView new];
    self.titleContainer.clipsToBounds = true;
    [self addSubview:self.titleContainer];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = UIColor.redColor;
    [self.titleContainer addSubview:self.titleLabel];
    
    self.backTitleContainer.backgroundColor = UIColor.lightGrayColor;
    self.titleContainer.backgroundColor = UIColor.grayColor;
}

- (void)configSegmentItems:(NSArray *)items {
    self.items = items;
    
    NSInteger i = 0;
    for (NSString *item in self.items) {
//        // add title
//        UILabel *label = [UILabel new];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = UIColor.redColor;
//        label.font = [UIFont systemFontOfSize:15];
//        label.text = item;
//        [self.titleContainer addSubview:label];
        
        // add back button
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:item forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(itemTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.backTitleContainer addSubview:btn];
        
        i += 1;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - actions

- (void)itemTapped:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    self.selectedIndex = index;
    
    CGFloat itemW = self.bounds.size.width / self.items.count;
    CGFloat itemH = self.bounds.size.height;
    self.titleLabel.text = self.items[self.selectedIndex];
    
    self.titleContainer.frame = CGRectMake(self.selectedIndex * itemW, 0, itemW, itemH);
    self.titleLabel.frame = CGRectMake(0, 0, itemW, itemH);
    
    self.titleContainer.frame = CGRectMake(self.selectedIndex * itemW + itemW/2, 0, 1, itemH);
    [UIView animateWithDuration:1.5 animations:^{
        self.titleContainer.frame = CGRectMake(self.selectedIndex * itemW, 0, itemW, itemH);
    }];
}

@end
