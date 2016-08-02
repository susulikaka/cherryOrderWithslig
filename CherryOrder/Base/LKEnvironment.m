//
//  LKEnvironment.m 
//

#import <UIKit/UIKit.h>
#import "LKEnvironment.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <AdSupport/ASIdentifierManager.h>
#import "UDID/UIDevice+IdentifierAddition.h"
#import "Reachability.h"

@implementation LKEnvironment

+ (LKEnvironment *)defaultEnv {
    static LKEnvironment *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)isDebug {
    return NO;
}

- (NSString *)platformString{
	size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (NSString *)deviceId {
    return [[UIDevice currentDevice] uniqueOpenUDIDIdentifier];
}

- (NSString *)version {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSString *)shortVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)phoneModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *model = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return model;
}

//- (NSString *)token {
//    return [[DefaultAccountService sharedInstance] token];
//}

- (BOOL)isIOS7 {
    return [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0;
}

- (BOOL)isIOS8 {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0;
}

- (BOOL)isIOS9 {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0;
}

- (BOOL)isWifi {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if (reachability.isReachableViaWiFi) {
        return YES;
    }
    return NO;
}

@end
