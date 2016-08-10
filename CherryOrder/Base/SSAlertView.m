//
//  SSAlertView.m
//  CherryOrder
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "SSAlertView.h"

const CGFloat KTextViewHight = 30;
const CGFloat KDatePickerHight = 120;
const CGFloat KValuePickerHight = 120;
const CGFloat KSpacingHight = 10;
const CGFloat KNameHight = 30;
const CGFloat KBtnHight = 40;

@interface SSAlertView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong)NSString * resultValue;

@end

@implementation SSAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = GRAY_ALPHA_COLOR(0.5);
    self.nameLabel.textColor = LK_TEXT_COLOR_GRAY;
    self.backview.backgroundColor = [UIColor whiteColor];
    [self.okBtn setTitleColor:LK_TEXT_COLOR_GRAY forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:LK_BACK_COLOR_LIGHT_GRAY forState:UIControlStateNormal];
}

- (void)rendWithText:(NSString *)name value:(NSString *)value superView:(UIView *)superView okBlock:(okBlock)okBlock cancelBlock:(cancelBlock)cancelBlock{
    if (self ) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.nameLabel.text = name;
        self.okBlock = okBlock;
        self.cancelBlock = cancelBlock;
        [self addValueViewWithValue:value];
        self.backHeight.constant = KNameHight + KBtnHight + KSpacingHight * 2 + KTextViewHight;
        [superView addSubview:self];
    }
}

- (void)rendWithDatePicker:(NSString *)name date:(NSDate *)date superView:(UIView *)superView okBlock:(okBlock)okBlock cancelBlock:(cancelBlock)cancelBlock {
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.nameLabel.text = name;
        self.okBlock = okBlock;
        self.cancelBlock = cancelBlock;
        [self addDataPickerWithValue:date];
        self.backHeight.constant = KNameHight + KBtnHight + KSpacingHight * 2 + KDatePickerHight;
        [superView addSubview:self];
    }
}

- (void)rendWithValuePicker:(NSString *)name pickArr:(NSArray *)pickArr superView:(UIView *)superView okBlock:(okBlock)okBlock cancelBlock:(cancelBlock)cancelBlock {
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.nameLabel.text = name;
        self.pickArr = pickArr;
        self.okBlock = okBlock;
        self.cancelBlock = cancelBlock;
        [self addValuePickerWithValue:pickArr];
        self.backHeight.constant = KNameHight + KBtnHight + KSpacingHight * 2 + KValuePickerHight;
        [superView addSubview:self];
    }
}

#pragma mark - add subview

-(void)addValueViewWithValue:(NSString *)value {
    UITextField * label = [[UITextField alloc] initWithFrame:CGRectMake(10,KNameHight+KSpacingHight, self.backview.frame.size.width-20, KTextViewHight)];
    label.borderStyle = UITextBorderStyleRoundedRect;
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = LK_TEXT_COLOR_GRAY;
    label.text = value;
    [RACObserve(label, text) subscribeNext:^(id x) {
        self.resultValue = x;
    }];
    [self.backview addSubview:label];
}

- (void)addDataPickerWithValue:(NSDate *)date {
    UIDatePicker * picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.maximumDate = [NSDate date];
    picker.frame = CGRectMake(10, KNameHight+KSpacingHight, self.backview.frame.size.width-20, KDatePickerHight);
    [picker addTarget:self action:@selector(pickerValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.backview addSubview:picker];
}

- (void)addValuePickerWithValue:(NSArray *)valueArr {
    UIPickerView * picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    picker.frame = CGRectMake(10, KNameHight+KSpacingHight, self.backview.frame.size.width-20, KValuePickerHight);
    [self.backview addSubview:picker];
}

#pragma mark - delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickArr.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.resultValue = self.pickArr[row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickArr[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return KTextViewHight;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:self.pickArr[row]];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:LK_TEXT_COLOR_GRAY,
                                  NSFontAttributeName:[UIFont systemFontOfSize:8]}
                          range:NSMakeRange(0, attributeStr.length)];
    return attributeStr;
}

#pragma mark - private method

- (void)pickerValueChange:(UIDatePicker *)picker {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * timeStr = [formatter stringFromDate:picker.date];
    
    self.resultValue = timeStr;
}

#pragma mark - action

- (IBAction)cancelAction:(id)sender {
    if (self.cancelBlock) {
        [self removeFromSuperview];
        self.cancelBlock();
    }
}

- (IBAction)okAction:(id)sender {
    if (self.okBlock) {
        [self removeFromSuperview];
        self.okBlock(self.resultValue);
    }
}

@end
