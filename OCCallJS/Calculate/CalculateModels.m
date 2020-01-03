//
//  CalculateModels.m
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import "CalculateModels.h"

@implementation CalInputModel

- (instancetype)initWithType:(CalInputType)type title:(NSString *)title value:(NSNumber *)value {
    if (self = [super init]) {
        self.inputType = type;
        self.title = title;
        self.value = value;
    }
    return self;
}

@end


@implementation CalResultModel

@end
