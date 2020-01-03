//
//  CalculateInfoCell.m
//  OCCallJS
//
//  Created by ocean on 2020/1/2.
//  Copyright © 2020 Auth. All rights reserved.
//

#import "CalculateInfoCell.h"

@interface CalculateInfoCell() <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *inputField;

@property (nonatomic, strong) CalInputModel *inputModel;
@end

@implementation CalculateInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat itemW = (width - 30 - 10) / 2;
    CGFloat itemH = 35;
    CGFloat itemY = (self.bounds.size.height - itemH) / 2;
    
    self.titleLabel.frame = CGRectMake(15, itemY, itemW, itemH);
    self.inputField.frame = CGRectMake(width/2 + 5, itemY, itemW, itemH);
}

- (void)buildUI {
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    
    self.inputField = [UITextField new];
    self.inputField.backgroundColor = UIColor.lightTextColor;
    self.inputField.textAlignment = NSTextAlignmentRight;
    self.inputField.keyboardType = UIKeyboardTypeNumberPad;
    self.inputField.delegate = self;
    [self.contentView addSubview:self.inputField];
}

- (void)showInfo:(CalInputModel *)inputModel {
    self.inputModel = inputModel;
    self.titleLabel.text = inputModel.title;
    self.inputField.text = [inputModel.value stringValue];
}


#pragma mark - delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.inputModel.value = @(textField.text.floatValue);
    
    if (self.changeBlock) {
        self.changeBlock(self.inputModel);
    }
}


@end
