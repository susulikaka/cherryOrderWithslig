//
//  LKLog.m 
//

#import "LKLog.h"
#import "LKInternal.h"
#import <sys/time.h>


/*
 NSDocumentDirectory/log/
 */
NSString *NVInternalGetLogPath() {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if(![arr count])
        return nil;
    NSString *documentsDirectory = [arr objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"log"];
    
    BOOL isDirectory = NO;
    if(![fileManager fileExistsAtPath:path isDirectory:&isDirectory] || !isDirectory) {
        if(!isDirectory) {
            if(![fileManager removeItemAtPath:path error:NULL]) {
                return nil;
            }
        }
        if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL]) {
            return nil;
        }
    }
    
    NSMutableArray *files = [NSMutableArray array];
    for(NSString *str in [fileManager contentsOfDirectoryAtPath:path error:NULL]) {
        if([[str pathExtension] isEqualToString:@"log"]) {
            [files addObject:str];
        }
    }
    [files sortUsingSelector:@selector(compare:)];
    
    for(NSInteger i = 0, n = [files count] - 10; i < n; i++) {
        NSString *file = [files objectAtIndex:i];
        [fileManager removeItemAtPath:file error:NULL];
    }
    
    return path;
}


FILE *__log_file() {
    static FILE *pfile = nil;
    if(!pfile) {
        NSString *path = NVInternalGetLogPath();
        time_t tm;
        time(&tm);
        struct tm *t_tm;
        t_tm = localtime(&tm);
        NSString *name = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d.log", t_tm->tm_year + 1900,t_tm->tm_mon+1,t_tm->tm_mday,t_tm->tm_hour,t_tm->tm_min,t_tm->tm_sec];
        FILE *file = fopen([[path stringByAppendingPathComponent:name] UTF8String], "w");
        
        // avoid some multithread issue
        if(file && pfile == nil) {
            pfile = file;
        } else if(file){
            fclose(file);
        }
    }
    return pfile;
}


void __LKLog(NSString *file, NSInteger line, NSString * content) {
    static time_t dtime = -1;
    if(dtime == -1) {
        time_t tm;
        time(&tm);
        struct tm *t_tm;
        t_tm = localtime(&tm);
        dtime = t_tm->tm_gmtoff;
    }
	struct timeval time;
    gettimeofday(&time, NULL);
    int secOfDay = (time.tv_sec + dtime) % (3600*24);
    int hour = secOfDay / 3600;
    int minute = secOfDay % 3600 / 60;
    int second = secOfDay % 60;
    int millis = time.tv_usec / 1000;
    NSString *str = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d.%03d %@[%ld] %@\n", hour, minute, second, millis, [[file pathComponents] lastObject], (long)line, content];
    const char *buf = [str cStringUsingEncoding:NSUTF8StringEncoding];
    printf("%s", buf);
    
    FILE *fp = __log_file();
    if(fp) {
        fputs(buf, fp);
        fflush(fp);
    }
}

