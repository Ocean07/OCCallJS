//
//  CalculateInfoCell.h
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculateModels.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChangeInfoBlock)(CalInputModel *infoModel);

@interface CalculateInfoCell : UITableViewCell

@property(nonatomic, copy) ChangeInfoBlock changeBlock;

- (void)showInfo:(CalInputModel *)infoModel;

@end

NS_ASSUME_NONNULL_END
