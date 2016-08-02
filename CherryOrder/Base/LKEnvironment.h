//
//  LKEnvironment.h
//

#import <Foundation/Foundation.h>

#define ISDEBUG [[NVEnvironment defaultEnvironment] isDebug]


@interface LKEnvironment : NSObject

+ (LKEnvironment *)defaultEnv;

- (BOOL)isDebug;

- (NSString *)platformString;

- (NSString *)deviceId;

- (NSString *)version;

- (NSString *)shortVersion;

- (NSString *)systemVersion;

- (NSString *)phoneModel;

- (NSString *)token;

- (BOOL)isIOS7;

- (BOOL)isIOS8;

- (BOOL)isIOS9;

- (BOOL)isWifi;

@end
