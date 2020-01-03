//
//  CurrencyListController.h
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ResultBlock)(NSString * _Nonnull currency);

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyListController : UIViewController
@property(nonatomic, copy) NSString *selectedCRY;
@property(nonatomic, copy) ResultBlock resultBlock;
@end


@interface CurrencyListViewModel : NSObject
@property(nonatomic, strong, readonly) NSArray *currencyArr;
@end

NS_ASSUME_NONNULL_END
