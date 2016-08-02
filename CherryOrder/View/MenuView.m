//
//  MenuView.m
//  CherryOrder
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "MenuView.h"

@interface MenuView ()

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@end

@implementation MenuView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.alpha = 0;
    self.accountChange.selected = NO;
    self.accountHistory.selected = NO;
    
    self.backgroundColor = BLUE_NEW_COLOR;
    self.accountChange.backgroundColor = MAIN_COLOR;
    self.accountChange.layer.cornerRadius = self.accountChange.frame.size.width/2;
    self.accountChange.layer.masksToBounds = YES;
    
    self.accountHistory.backgroundColor = BLUE_COLOR;
    self.accountHistory.layer.cornerRadius = self.accountHistory.frame.size.height/2;
    self.accountHistory.layer.masksToBounds = YES;

    self.allHistory.backgroundColor = YELLOW_COLOR;
    self.allHistory.layer.cornerRadius = self.allHistory.frame.size.height/2;
    self.allHistory.layer.masksToBounds = YES;
    
    self.helpOrder.backgroundColor = [UIColor whiteColor];
    self.helpOrder.layer.cornerRadius = self.helpOrder.frame.size.height/2;
    self.helpOrder.layer.masksToBounds = YES;
    
    self.tapGesture = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:self.tapGesture];
    
    [self.accountChange.layer addAnimation:[self outAnimationFromPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2) ToPoint:CGPointMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2)] forKey:@"accountChange"];
    [self.accountHistory.layer addAnimation:[self outAnimationFromPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2) ToPoint:CGPointMake(SCREEN_WIDTH/2+100, SCREEN_HEIGHT/2)] forKey:@"history"];
    [self.allHistory.layer addAnimation:[self outAnimationFromPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2) ToPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-100)] forKey:@"allhistory"];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.95;
    } completion:^(BOOL finished) {
        
    }];
}

- (CABasicAnimation *)outAnimationFromPoint:(CGPoint)fromPoint ToPoint:(CGPoint)toPoint{
    CABasicAnimation * poiAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    poiAnim.duration = 0.3;
    poiAnim.repeatCount = 1;
    poiAnim.fromValue = [NSValue valueWithCGPoint:fromPoint];
    poiAnim.toValue = [NSValue valueWithCGPoint:toPoint];
    poiAnim.removedOnCompletion = NO;
    poiAnim.fillMode = kCAFillModeBoth;
    poiAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return poiAnim;
}

- (IBAction)accountChangeAction:(id)sender {
    self.accountChange.selected = !self.accountChange.selected;
    [self removeFromSuperview];
}

- (IBAction)accountHistoryAction:(id)sender {
    self.accountHistory.selected = !self.accountHistory.selected;
    [self removeFromSuperview];
}

- (IBAction)allHistory:(id)sender {
    self.allHistory.selected = !self.allHistory.selected;
    [self removeFromSuperview];
}

- (IBAction)helpOrderAction:(id)sender {
    self.helpOrder.selected = !self.helpOrder.selected;
    [self removeFromSuperview];
}

#pragma mark - gesture

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    [self removeFromSuperview];
}

@end
