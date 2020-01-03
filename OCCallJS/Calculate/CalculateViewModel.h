//
//  CalculateViewModel.h
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CalculateModels.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalculateViewModel : NSObject

@property(nonatomic, strong) NSArray *dataSource;

- (void)changeItem:(CalInputModel *)item;

- (NSArray *)calculateCountWithHaveNow:(CGFloat)haveNow rate:(CGFloat)rate sapm:(CGFloat)savePM longY:(NSInteger)how;

- (NSArray *)calculateRateWithHaveNow:(CGFloat)haveNow totalCount:(CGFloat)count sapm:(CGFloat)savePM longY:(NSInteger)howLong;

- (NSArray *)calculateLongWithHaveNow:(CGFloat)haveNow rate:(CGFloat)rate sapm:(CGFloat)savePM totalCount:(CGFloat)count;

- (NSArray *)calculateSavePMWithHaveNow:(CGFloat)haveNow totalCount:(CGFloat)count rate:(CGFloat)rate howLong:(NSInteger)howLong;

@end


NS_ASSUME_NONNULL_END
