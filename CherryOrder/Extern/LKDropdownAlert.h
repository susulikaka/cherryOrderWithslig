//
//  LKDropdownAlert.h
//
 

#import <UIKit/UIKit.h>
@class LKDropdownAlert;
extern NSString *const RKDropdownAlertDismissAllNotification;

@protocol RKDropdownAlertDelegate <NSObject>
-(BOOL)dropdownAlertWasTapped:(LKDropdownAlert*)alert;
-(BOOL)dropdownAlertWasDismissed;
@end

@interface LKDropdownAlert : UIButton


//%%% Additions: title, message, time, background color, text color

+(void)show;
+(void)title:(NSString*)title;
+(void)title:(NSString*)title time:(NSInteger)seconds;
+(void)title:(NSString*)title backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor;
+(void)title:(NSString*)title backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor time:(NSInteger)seconds;

+(void)title:(NSString*)title message:(NSString*)message;
+(void)title:(NSString*)title message:(NSString*)message time:(NSInteger)seconds;
+(void)title:(NSString*)title message:(NSString*)message backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor;
+(void)title:(NSString*)title message:(NSString*)message backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor time:(NSInteger)seconds;

+(void)showWithDelegate:(id<RKDropdownAlertDelegate>)delegate;
+(void)title:(NSString*)title delegate:(id<RKDropdownAlertDelegate>)delegate;
+(void)title:(NSString*)title time:(NSInteger)seconds delegate:(id<RKDropdownAlertDelegate>)delegate;
+(void)title:(NSString*)title backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor delegate:(id<RKDropdownAlertDelegate>)delegate;
+(void)title:(NSString*)title backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor time:(NSInteger)seconds delegate:(id<RKDropdownAlertDelegate>)delegate;
+(void)title:(NSString*)title message:(NSString*)message delegate:(id<RKDropdownAlertDelegate>)delegate;
+(void)title:(NSString*)title message:(NSString*)message time:(NSInteger)seconds delegate:(id<RKDropdownAlertDelegate>)delegate;
+(void)title:(NSString*)title message:(NSString*)message backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor delegate:(id<RKDropdownAlertDelegate>)delegate;
+(void)title:(NSString*)title message:(NSString*)message backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor time:(NSInteger)seconds delegate:(id<RKDropdownAlertDelegate>)delegate;
+(void)dismissAllAlert;

@property UIColor *defaultViewColor;
@property UIColor *defaultTextColor;
@property BOOL isShowing;
@property id<RKDropdownAlertDelegate> delegate;

-(void)title:(NSString*)title message:(NSString*)message backgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor time:(NSInteger)seconds;

@end
