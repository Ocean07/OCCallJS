//
//  CalculateResultListVC.h
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculateModels.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalculateResultListVC : UIViewController

@property(nonatomic, assign) CalResultType resultType;
@property(nonatomic, copy) NSArray *resultList;

@end

NS_ASSUME_NONNULL_END
