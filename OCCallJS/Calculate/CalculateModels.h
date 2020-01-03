//
//  CalculateModels.h
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CalInputTypeHavenow,
    CalInputTypeRate,
    CalInputTypeSvC,
    CalInputTypeYC,
    CalInputTypeTC
} CalInputType;

typedef enum : NSUInteger {
    CalResultTypeTC,
    CalResultTypeRate,
    CalResultTypeYC,
    CalResultTypeSavePM
} CalResultType;

@interface CalInputModel : NSObject
@property(nonatomic, assign) CalInputType inputType;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSNumber *value;

- (instancetype)initWithType:(CalInputType)type title:(NSString *)title value:(NSNumber *)value;

@end

@interface CalResultModel : NSObject

@property(nonatomic, assign) CalResultType resultType;
@property(nonatomic, copy) NSArray *results;
@property(nonatomic, assign) BOOL expand; // 是否展开显示

@property(nonatomic, assign) CGFloat total;
@property(nonatomic, assign) CGFloat rate;
@property(nonatomic, assign) CGFloat savePM;
@property(nonatomic, assign) CGFloat longY;

@end

NS_ASSUME_NONNULL_END
