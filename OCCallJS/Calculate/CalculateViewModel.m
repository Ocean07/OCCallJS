//
//  CalculateViewModel.m
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import "CalculateViewModel.h"

@implementation CalculateViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configDataSource];
    }
    return self;
}

- (void)configDataSource {
    self.dataSource = @[
            [[CalInputModel alloc] initWithType:CalInputTypeHavenow title:@"havenow" value:@0],
            [[CalInputModel alloc] initWithType:CalInputTypeRate title:@"rate" value:@0.04],
            [[CalInputModel alloc] initWithType:CalInputTypeSvC title:@"savepm" value:@1000],
            [[CalInputModel alloc] initWithType:CalInputTypeYC title:@"howlong" value:@30],
            [[CalInputModel alloc] initWithType:CalInputTypeTC title:@"count" value:@100000]
    ];
}

- (void)changeItem:(CalInputModel *)item {
    NSMutableArray *temp = [self.dataSource mutableCopy];
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.dataSource.count; i ++) {
        CalInputModel *infoDic = self.dataSource[i];
        if (infoDic.title == item.title) {
            index = i;
            break;
        }
    }
    
    if (index >= 0) {
        [temp replaceObjectAtIndex:index withObject:item];
        self.dataSource = temp;
    }
}

- (NSArray *)calculateCountWithHaveNow:(CGFloat)haveNow rate:(CGFloat)rate sapm:(CGFloat)savePM longY:(NSInteger)how {
    
    CGFloat rateM = rate / 12.0;
    NSInteger mcount = how * 12;
    CGFloat count = haveNow;
    
    NSMutableArray *result = [NSMutableArray new];
    NSMutableArray *temp = [NSMutableArray new];
    for (NSInteger i = 1; i <= mcount; i ++) {
        count = count * (1 + rateM) + savePM;
        [temp addObject:@(count)];
        
        if (i % 12 == 0) {
            CalResultModel *resultM = [CalResultModel new];
            resultM.resultType = CalResultTypeTC;
            resultM.results = temp;
            [result addObject:resultM];
            
            [temp removeAllObjects];
        }
    }
    
    for (CalResultModel *resultM in result) {
        resultM.total = count;
    }
    
    return result;
}

- (NSArray *)calculateRateWithHaveNow:(CGFloat)haveNow totalCount:(CGFloat)count sapm:(CGFloat)savePM longY:(NSInteger)howLong {
    
    if (haveNow >= count) {
        // alert
        return nil;
    }
    
    NSInteger mcount = howLong * 12;
    CGFloat rate = -1;
    for (CGFloat rateY = 0; rateY <= 1; rateY += 0.0001) {
        CGFloat rateM = rateY/12.0;
        CGFloat total = haveNow;
        for (NSInteger mIndex = 0; mIndex < mcount; mIndex ++) {
            total = total*(1+rateM) + savePM;
        }
        if (total >= count) {
            rate = rateY;
            break;
        }
    }
    
    if (rate < 0) {
        //
        return nil;
    }
    
    // calculate every m
    CGFloat total = haveNow;
    NSMutableArray *result = [NSMutableArray new];
    NSMutableArray *temp = [NSMutableArray new];
    CGFloat rateM = rate/12.0;
    for (NSInteger i = 1; i <= mcount; i ++) {
        total = total * (1 + rateM) + savePM;
        [temp addObject:@(total)];
        
        if (i % 12 == 0) {
            CalResultModel *resultM = [CalResultModel new];
            resultM.resultType = CalResultTypeRate;
            resultM.results = temp;
            resultM.rate = rate;
            [result addObject:resultM];
            
            [temp removeAllObjects];
        }
    }
    
    return result;
}
// segment ctl
- (NSArray *)calculateLongWithHaveNow:(CGFloat)haveNow rate:(CGFloat)rate sapm:(CGFloat)savePM totalCount:(CGFloat)count {
    
    CGFloat rateM = rate / 12.0;
    NSInteger mcount = NSIntegerMax;
    CGFloat saveCount = haveNow;
    
    NSMutableArray *result = [NSMutableArray new];
    if (saveCount >= count) {
        // alert
        return nil;
    }
    
    NSInteger howLong = -1;
    NSMutableArray *temp = [NSMutableArray new];
    for (NSInteger i = 1; i <= mcount; i ++) {
        saveCount = saveCount * (1 + rateM) + savePM;
        [temp addObject:@(saveCount)];
        
        if (i % 12 == 0) {
            CalResultModel *resultM = [CalResultModel new];
            resultM.resultType = CalResultTypeYC;
            resultM.results = temp;
            [result addObject:resultM];
            
            [temp removeAllObjects];
        } else if (saveCount >= count) {
            CalResultModel *resultM = [CalResultModel new];
            resultM.resultType = CalResultTypeYC;
            resultM.results = temp;
            [result addObject:resultM];
            
            howLong = i;
            [temp removeAllObjects];
            break;
        }
    }
    
    if (howLong < 0) {
        return nil;
    }
    
    for (CalResultModel *resultM in result) {
        resultM.longY = howLong/12.0;
    }
    
    return result;
}

- (NSArray *)calculateSavePMWithHaveNow:(CGFloat)haveNow totalCount:(CGFloat)count rate:(CGFloat)rate howLong:(NSInteger)howLong {
    
    if (haveNow >= count) {
        // alert, return
        return nil;
    }
    
    CGFloat savePM = -1.0;
    CGFloat rateM = rate/12.0;
    NSInteger mcount = howLong * 12;
    for (NSInteger saveM = 0; saveM < NSIntegerMax; saveM ++) {
        CGFloat total = haveNow;
        for (NSInteger mIndex = 0; mIndex < mcount; mIndex ++) {
            total = total*(1+rateM) + saveM;
        }
        if (total >= count) {
            savePM = saveM;
            break;
        }
    }
    
    if (savePM < 0) {
        // alert, no
        return nil;
    }
    
    // calculate every m
    CGFloat total = haveNow;
    NSMutableArray *result = [NSMutableArray new];
    NSMutableArray *temp = [NSMutableArray new];
    for (NSInteger i = 1; i <= mcount; i ++) {
        total = total * (1 + rateM) + savePM;
        [temp addObject:@(total)];
        
        if (i % 12 == 0) {
            CalResultModel *resultM = [CalResultModel new];
            resultM.resultType = CalResultTypeSavePM;
            resultM.results = temp;
            resultM.savePM = savePM;
            [result addObject:resultM];
            
            [temp removeAllObjects];
        }
    }
    
    NSLog(@"%@", result);
    return result;
}

@end
