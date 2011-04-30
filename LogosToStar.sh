#!/bin/sh
if [[ ! -f $1 ]]; then
echo "$1: No such file or directory.">/dev/stderr
exit 1
fi
# dirty hack
cat > star.h << EOF
#import <Foundation/Foundation.h>

#import <objc/runtime.h>
@interface Star : NSObject {
}
+(IMP)hookSelector:(SEL)selector inClass:(Class)cls withImp:(IMP)impl;
+(void)hookSelector:(SEL)selector inClass:(Class)cls withImp:(IMP)impl andOrig:(IMP*)orig;
+(id)hookIvar:(NSString*)name inInstance:(id)inst;
+(BOOL)addSelector:(SEL)selector inClass:(Class)cls withImp:(IMP)impl andType:(NSString*)type;
@end
#define Star objc_getClass("Star")
#define MSHookMessageEx(class, selector, repl, orig) [Star hookSelector:selector inClass:class withImp:repl andOrig:orig]
EOF
echo '#import "star.h"' 
logos.pl $1 | sed 's/#include <substrate.h>//g'
