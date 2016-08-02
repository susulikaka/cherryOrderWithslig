//
//  NVInternal.h 
//

#import <Foundation/Foundation.h>
#import "LKEnvironment.h"
#import "LKStatisticsCenter.h"


//
// Environment
//
#pragma mark - Environment

void NVInternalSetDefaultEnvironment(LKEnvironment *env);

//
// Log
//
#pragma mark - Log

NSString *NVInternalGetLogPath();

//
// Statistics
//
#pragma mark - Statistics

@interface LKStatisticsCenter (Internal)

@property (nonatomic, retain) NSString *uploadUrl;

- (id)initWithUploadUrl:(NSString *)url uploadCount:(NSInteger)upload maxCount:(NSInteger)max path:(NSString *)path;

@end


void NVInternalSetDefaultStatisticsCenter(LKStatisticsCenter *stat);
