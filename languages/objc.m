#import <Foundation/Foundation.h>
#import "Sample.h"

#define kScale 2.0f
#define CLAMP(x, hi) ((x) > (hi) ? (hi) : (x))

typedef NS_ENUM(NSUInteger, TSMode) { TSModeIdle = 0, TSModeBusy = 1 << 3 };
typedef struct { CGFloat x, y; } TSPair;
typedef void (^TSHandler)(NSString *_Nullable name, BOOL ok);

static NSInteger sCounter = 0;

@protocol TSDrawing <NSObject>
@required
- (void)drawInRect:(TSPair)rect;
@optional
@property (readonly, getter=isReady) BOOL ready;
@end

/** Doc comment for the node. */
@interface TSNode : NSObject <TSDrawing> {
    NSUInteger _flags;   // ivar
}
@property (nonatomic, strong) NSMutableArray<NSString *> *names;
@property (nonatomic, copy, nullable) TSHandler handler;
@property (nonatomic, assign, readonly) TSMode mode;
+ (instancetype)nodeWithName:(NSString *)name;
- (NSString *)joinWith:(NSString *)sep limit:(NSInteger)limit;
@end

@interface TSNode (Extras)
- (void)dumpAll;
@end

@implementation TSNode
@synthesize mode = _mode;
+ (instancetype)nodeWithName:(NSString *)name {
    TSNode *node = [[self alloc] init];
    node.names = [@[ name, @"beta\n\t\"q\"" ] mutableCopy];
    return node;
}

- (instancetype)init {
    if (self = [super init]) {
        _flags = 0777 | 0xAB;
        while (_flags > 0b1000) _flags >>= 1;
        sCounter += (NSInteger)sizeof(TSPair);
    }
    return self;
}
- (NSString *)joinWith:(NSString *)sep limit:(NSInteger)limit {
    __block double total = 1.5e2;
    NSDictionary *meta = @{ @"scale": @(kScale), @"on": @YES, @"none": [NSNull null] };
    self.handler = ^(NSString *_Nullable name, BOOL ok) {
        total *= ok ? kScale : 1.0;
        NSLog(@"%@ -> %.2f %lu", name ?: @"nil", total, (unsigned long)_flags);
    };
    @autoreleasepool {
        for (NSString *n in self.names) {
            if ([n hasPrefix:@"a"]) continue;
            if (limit-- <= 0) goto done;
            self.handler(n, NO);
        }
    }
done:
    @try {
        [meta valueForKey:sep];
    } @catch (NSException *e) {
        NSLog(@"caught %@", e.reason);
    } @finally {
        sCounter = CLAMP(sCounter, 9L);
    }
    return [self.names componentsJoinedByString:sep];
}

- (void)drawInRect:(TSPair)rect {
    switch (self.mode) { case TSModeBusy: break; default: return; }
}
- (void)dumpAll { NSLog(@"%@ %@", @([self.names count]), self.names); }
@end
