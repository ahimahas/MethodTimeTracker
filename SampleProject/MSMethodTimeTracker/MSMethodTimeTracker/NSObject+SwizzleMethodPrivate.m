//
//  NSObject+SwizzleMethodPrivate.m
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 15..
//  Copyright © 2017년 MS. All rights reserved.
//

#import "NSObject+SwizzleMethodPrivate.h"
#import "MSSwizzleMethodStatics.h"
#import "NSInvocation+SwizzleHelper.h"
#import <objc/message.h>


@implementation NSObject (SwizzleMethodPrivate)


#pragma mark - Setter/Getter

- (void)setOriginImps:(NSMutableDictionary<NSString *,MSOriginImpContainer *> *)originImps {
    objc_setAssociatedObject(self, &categoryKeySwizzledClasses, originImps, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary<NSString *, MSOriginImpContainer *> *)originImps {
    return objc_getAssociatedObject(self, &categoryKeySwizzledClasses);
}


#pragma mark - Internal swizzling logics

- (NSInvocation *)processSwizzledLogicWithVaList:(va_list)args selector:(SEL)selector {
    // get arguments
    NSString *key = NSStringFromSelector(selector);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    NSArray *arguments = [self retrieveArgumentsFromArgs:args invocation:invocation];
    
    // restore origin imp
    [self restoreOriginImpWithSelector:selector];
    
    // pre
    [self runPreProcedureAtKey:key withArguments:arguments];
    
    // call origin imp
    [self callOriginImpForInvocation:invocation selector:selector withArguments:arguments];
    
    // post
    [self runPostProcedureAtKey:key withArguments:arguments];
    
    // swizzle again if needed
    [self swizzleMethodWithInvocation:invocation selector:selector];
    
    return invocation;
}

- (void)restoreOriginImpWithSelector:(SEL)selector {
    NSString *key = NSStringFromSelector(selector);
    Method originMethod = class_getInstanceMethod([self class], selector);
    
    MSOriginImpContainer *impContainer = self.originImps[key];
    IMP originImp = [impContainer.value pointerValue];
    if (originImp == nil) {
        SWIZZLE_ERROR_LOG(@"Storing origin imp fail", NSStringFromSelector(selector));
        return;
    }
    
    method_setImplementation(originMethod, originImp);
}

- (void)callOriginImpForInvocation:(NSInvocation *)invocation selector:(SEL)selector withArguments:(NSArray *)arguments {
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation setArguments:arguments];
    [invocation invoke];
}


- (NSArray *)retrieveArgumentsFromArgs:(va_list)args invocation:(NSInvocation *)invocation {
    NSMethodSignature *signature = invocation.methodSignature;
    NSUInteger argc = signature.numberOfArguments;
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:argc - defaultNumberOfMethodArguments];

    const char *argType;
    NSUInteger ai;
    
    for (NSUInteger i = defaultNumberOfMethodArguments; i < argc; i++) {
        argType = [signature getArgumentTypeAtIndex:i];
        ai = i - defaultNumberOfMethodArguments;
        
        [arguments addObject:[invocation argumentInVaList:args atIndex:i]];
    }
    
    return arguments;
}

- (void)swizzleMethodWithInvocation:(NSInvocation *)invocation selector:(SEL)selector {
    IMP swizzledImp = [invocation selectSwizzledMethod];
    Method originMethod = class_getInstanceMethod([self class], selector);
    method_setImplementation(originMethod, (IMP)swizzledImp);
}

- (void)runPreProcedureAtKey:(NSString *)key withArguments:(NSArray <id> *)arguments {
    MSOriginImpContainer *impContainer = self.originImps[key];
    if (impContainer.preProcedure) {
        impContainer.preProcedure(key, arguments);
    }
}

- (void)runPostProcedureAtKey:(NSString *)key withArguments:(NSArray <id> *)arguments {
    MSOriginImpContainer *impContainer = self.originImps[key];
    if (impContainer.postProcedure) {
        impContainer.postProcedure(key, arguments);
    }
}


#pragma mark - #######################################################################################################################
#pragma mark - Swizzled Method Forms

void methodReturnVoid(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    [self processSwizzledLogicWithVaList:args selector:cmd];
}

id methodReturnId(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    __unsafe_unretained id rtnValue;
    [invocation getReturnValue:&rtnValue];

    return rtnValue;
}

Class methodReturnClass(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    __unsafe_unretained Class rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

char methodReturnChar(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    char rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

int methodReturnInt(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    int rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

short methodReturnShort(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    short rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

long methodReturnLong(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    long rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}


long long methodReturnLongLong(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    long long rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

unsigned char methodReturnUnsignedChar(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    unsigned char rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

unsigned int methodReturnUnsignedInt(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    unsigned int rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

unsigned short methodReturnUnsignedShort(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    unsigned short rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

unsigned long methodReturnUnsignedLong(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    unsigned long rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

unsigned long long methodReturnUnsignedLongLong(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    unsigned long long rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

float methodReturnFloat(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    float rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

double methodReturnDouble(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    double rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

SEL methodReturnSel(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    SEL rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

bool methodReturnBool(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    bool rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

BOOL methodReturnBOOL(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    BOOL rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

unichar methodReturnUnichar(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    unichar rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

void * methodReturnVoidPointer(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    void * rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}

char * methodReturnCharPointer(id self, SEL cmd, ...) {
    va_list args;
    va_start(args, cmd);
    
    NSInvocation *invocation = [self processSwizzledLogicWithVaList:args selector:cmd];
    char * rtnValue;
    [invocation getReturnValue:&rtnValue];
    return rtnValue;
}


@end

