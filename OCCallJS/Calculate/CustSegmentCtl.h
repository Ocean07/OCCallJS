//
//  CustSegmentCtl.h
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustSegmentCtl : UIView

@property (nonatomic, assign, readonly) NSInteger selectedIndex;

- (void)configSegmentItems:(NSArray *)items;

@end

NS_ASSUME_NONNULL_END
