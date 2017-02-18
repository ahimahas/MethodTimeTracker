//
//  NSInvocation+SwizzleHelper.m
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 17..
//  Copyright © 2017년 Coupang. All rights reserved.
//

#import "NSInvocation+SwizzleHelper.h"
#import "MSSwizzleMethodStatics.h"
#import "NSObject+SwizzleMethodPrivate.h"
#import "NSNull+WasNil.h"

@implementation NSInvocation (SwizzleHelper)

- (id)argumentInVaList:(va_list)args atIndex:(NSUInteger)index {
    NSMethodSignature *signature = self.methodSignature;
    NSUInteger argc = [signature numberOfArguments];
    
    if (index > argc) {
        return nil;
    }
    
    const char *argType = [signature getArgumentTypeAtIndex:index];
    
    if (argType[0] == @encode(id)[0]) {
        __unsafe_unretained id arg = va_arg(args, __unsafe_unretained id);
        if (arg == nil) {
            NSNull *null = [NSNull null];
            [null setWasNil:YES];
            arg = null;
        }
        return arg ? arg : [NSNull null];
        
    } else if(!strcmp(argType, @encode(SEL))) {
        SEL arg = va_arg(args, SEL);
        return NSStringFromSelector(arg);
        
    } else if(!strcmp(argType, @encode(Class))) {
        __unsafe_unretained Class arg = va_arg(args, __unsafe_unretained Class);
        return arg;
        
    } else if(!strcmp(argType, @encode(char))) {
        char arg = va_arg(args, int);
        return [NSNumber numberWithChar:arg];
        
    } else if(!strcmp(argType, @encode(int))) {
        int arg = va_arg(args, int);
        return [NSNumber numberWithInt:arg];
        
    } else if(!strcmp(argType, @encode(bool))) {
        bool arg = va_arg(args, int);
        return [NSNumber numberWithBool:arg];
        
    } else if(!strcmp(argType, @encode(BOOL))) {
        BOOL arg = va_arg(args, int);
        return [NSNumber numberWithBool:arg];
        
    } else if(!strcmp(argType, @encode(short))) {
        short arg = va_arg(args, int);
        return [NSNumber numberWithShort:arg];
        
    } else if(!strcmp(argType, @encode(unichar))) {
        unichar arg = va_arg(args, int);
        return [NSNumber numberWithUnsignedShort:arg];
        
    } else if(!strcmp(argType, @encode(float))) {
        float arg = va_arg(args, double);
        return [NSNumber numberWithFloat:arg];
        
    } else if(!strcmp(argType, @encode(double))) {
        float arg = va_arg(args, double);
        return [NSNumber numberWithFloat:arg];
        
    } else if(!strcmp(argType, @encode(long))) {
        long arg = va_arg(args, long);
        return [NSNumber numberWithLong:arg];
        
    } else if(!strcmp(argType, @encode(long long))) {
        long long arg = va_arg(args, long long);
        return [NSNumber numberWithLongLong:arg];
        
    } else if(!strcmp(argType, @encode(unsigned int))) {
        unsigned int arg = va_arg(args, unsigned int);
        return [NSNumber numberWithUnsignedInt:arg];
        
    } else if(!strcmp(argType, @encode(unsigned char))) {
        unsigned char arg = va_arg(args, int);
        return [NSNumber numberWithUnsignedChar:arg];
        
    } else if(!strcmp(argType, @encode(unsigned short))) {
        unsigned short arg = va_arg(args, int);
        return [NSNumber numberWithUnsignedShort:arg];
        
    } else if(!strcmp(argType, @encode(unsigned long))) {
        unsigned long arg = va_arg(args, unsigned long);
        return [NSNumber numberWithUnsignedLong:arg];
        
    } else if(!strcmp(argType, @encode(unsigned long long))) {
        unsigned long long arg = va_arg(args, unsigned long long);
        return [NSNumber numberWithUnsignedLongLong:arg];
        
    } else if(!strcmp(argType, @encode(char *))) {
        char *arg = va_arg(args, char *);
        return [NSString stringWithCString:arg encoding:NSASCIIStringEncoding];
        
    } else if(!strcmp(argType, @encode(void *))) {
        void *arg = va_arg(args, void *);
        return (__bridge id)(arg);
        
    } else {
        NSLog(@"^ Argument type is not supported!. %s", argType);
    }
    
    return nil;
}


- (void)setArguments:(NSArray *)arguments {
    NSMethodSignature *signature = self.methodSignature;
    
    const char *argType;
    NSUInteger ai;
    NSUInteger argc = [signature numberOfArguments];
    
    for (int i = defaultNumberOfMethodArguments; i < argc; i++) {
        argType = [signature getArgumentTypeAtIndex:i];
        ai = i - defaultNumberOfMethodArguments;
        
        if (argType[0] == @encode(id)[0]) {
            __unsafe_unretained id arg = arguments[ai];
            if ([arg isEqual:[NSNull null]]) {
                NSNull *null = (NSNull *)arg;
                if (null.wasNil) {
                    arg = nil;
                }
            }
            [self setArgument:&arg atIndex:i];
            
        } else if(!strcmp(argType, @encode(SEL))) {
            NSString *arg = arguments[ai];
            SEL selector = NSSelectorFromString(arg);
            [self setArgument:&selector atIndex:i];
            
        } else if(!strcmp(argType, @encode(Class))) {
            __unsafe_unretained Class arg = arguments[ai];
            [self setArgument:&arg atIndex:i];
            
        } else if(!strcmp(argType, @encode(char))) {
            NSNumber *arg = arguments[ai];
            char value = [arg charValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(int))) {
            NSNumber *arg = arguments[ai];
            int value = [arg intValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(bool))) {
            NSNumber *arg = arguments[ai];
            bool value = [arg boolValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(BOOL))) {
            NSNumber *arg = arguments[ai];
            BOOL value = [arg boolValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(short))) {
            NSNumber *arg = arguments[ai];
            short value = [arg shortValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(unichar))) {
            NSNumber *arg = arguments[ai];
            unichar value = [arg unsignedShortValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(float))) {
            NSNumber *arg = arguments[ai];
            float value = [arg floatValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(double))) {
            NSNumber *arg = arguments[ai];
            double value = [arg doubleValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(long))) {
            NSNumber *arg = arguments[ai];
            long value = [arg longValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(long long))) {
            NSNumber *arg = arguments[ai];
            long long value = [arg longLongValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(unsigned int))) {
            NSNumber *arg = arguments[ai];
            unsigned int value = [arg unsignedIntValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(unsigned char))) {
            NSNumber *arg = arguments[ai];
            char value = [arg unsignedCharValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(unsigned short))) {
            NSNumber *arg = arguments[ai];
            unsigned short value = [arg unsignedLongLongValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(unsigned long))) {
            NSNumber *arg = arguments[ai];
            unsigned long value = [arg unsignedLongValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(unsigned long long))) {
            NSNumber *arg = arguments[ai];
            unsigned long long value = [arg unsignedLongLongValue];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(char *))) {
            NSString *arg = arguments[ai];
            const char * _Nullable value = [arg cStringUsingEncoding:NSASCIIStringEncoding];
            [self setArgument:&value atIndex:i];
            
        } else if(!strcmp(argType, @encode(void *))) {
            id arg = arguments[ai];
            void *value = (__bridge void *)(arg);
            [self setArgument:&value atIndex:i];
            
        } else {
            NSLog(@"^ Argument type is not supported!. %s", argType);
        }
    }
}

- (IMP)selectSwizzledMethod {
    NSMethodSignature *methodSignature = [self methodSignature];
    const char *returnType = [methodSignature methodReturnType];
    
    if (returnType[0] == @encode(void)[0]) {
        return (IMP)methodReturnVoid;
        
    } else if (returnType[0] == @encode(id)[0]) {
        return (IMP)methodReturnId;
        
    } else if(strcmp(returnType, @encode(SEL)) == 0) {
        return (IMP)methodReturnSel;
        
    } else if(strcmp(returnType, @encode(Class)) == 0) {
        return (IMP)methodReturnClass;
        
    } else if(strcmp(returnType, @encode(char)) == 0) {
        return (IMP)methodReturnChar;
        
    } else if(strcmp(returnType, @encode(int)) == 0) {
        return (IMP)methodReturnInt;
        
    } else if(strcmp(returnType, @encode(bool)) == 0) {
        return (IMP)methodReturnBool;
        
    } else if(strcmp(returnType, @encode(BOOL)) == 0) {
        return (IMP)methodReturnBOOL;
        
    } else if(strcmp(returnType, @encode(short)) == 0) {
        return (IMP)methodReturnShort;
        
    } else if(strcmp(returnType, @encode(short)) == 0) {
        return (IMP)methodReturnUnichar;
        
    } else if(strcmp(returnType, @encode(float)) == 0) {
        return (IMP)methodReturnFloat;
        
    } else if(strcmp(returnType, @encode(double)) == 0) {
        return (IMP)methodReturnDouble;
        
    } else if(strcmp(returnType, @encode(long)) == 0) {
        return (IMP)methodReturnLong;
        
    } else if(strcmp(returnType, @encode(long long)) == 0) {
        return (IMP)methodReturnLongLong;
        
    } else if(strcmp(returnType, @encode(unsigned char)) == 0) {
        return (IMP)methodReturnUnsignedChar;
        
    } else if(strcmp(returnType, @encode(unsigned int)) == 0) {
        return (IMP)methodReturnUnsignedInt;
        
    } else if(strcmp(returnType, @encode(unsigned short)) == 0) {
        return (IMP)methodReturnUnsignedShort;
        
    } else if(strcmp(returnType, @encode(unsigned long)) == 0) {
        return (IMP)methodReturnUnsignedLong;
        
    } else if(strcmp(returnType, @encode(unsigned long long)) == 0) {
        return (IMP)methodReturnUnsignedLongLong;
        
    } else if(strcmp(returnType, @encode(char *)) == 0) {
        return (IMP)methodReturnCharPointer;
        
    } else if(strcmp(returnType, @encode(void *)) == 0) {
        return (IMP)methodReturnVoidPointer;
        
    } else {
        NSLog(@"^ Return type is not supported!. %s", returnType);
    }
    
    return nil;
}

+ (BOOL)validateArgumentsTypeInMethodSignature:(NSMethodSignature *)signature {
    NSUInteger argc = [signature numberOfArguments];
    
    const char *argType;
    for (int i = defaultNumberOfMethodArguments; i < argc; i++) {
        argType = [signature getArgumentTypeAtIndex:i];
        
        if (argType[0] == @encode(id)[0]) {
        } else if(!strcmp(argType, @encode(SEL))) {
        } else if(!strcmp(argType, @encode(Class))) {
        } else if(!strcmp(argType, @encode(char))) {
        } else if(!strcmp(argType, @encode(int))) {
        } else if(!strcmp(argType, @encode(bool))) {
        } else if(!strcmp(argType, @encode(BOOL))) {
        } else if(!strcmp(argType, @encode(short))) {
        } else if(!strcmp(argType, @encode(unichar))) {
        } else if(!strcmp(argType, @encode(float))) {
        } else if(!strcmp(argType, @encode(double))) {
        } else if(!strcmp(argType, @encode(long))) {
        } else if(!strcmp(argType, @encode(long long))) {
        } else if(!strcmp(argType, @encode(unsigned int))) {
        } else if(!strcmp(argType, @encode(unsigned char))) {
        } else if(!strcmp(argType, @encode(unsigned short))) {
        } else if(!strcmp(argType, @encode(unsigned long))) {
        } else if(!strcmp(argType, @encode(unsigned long long))) {
        } else if(!strcmp(argType, @encode(char *))) {
        } else if(!strcmp(argType, @encode(void *))) {
        } else {
            return NO;
        }
    }
    
    return YES;
}


@end
