//
//  LKLog.h
//

#import <Foundation/Foundation.h>
#import "LKEnvironment.h"

#define LKLOG(format, ...) if([LKEnvironment defaultEnv].isDebug) {__LKLog(@__FILE__, __LINE__, [NSString stringWithFormat:format, ## __VA_ARGS__]);}

void __LKLog(NSString *file, NSInteger line, NSString * content);
