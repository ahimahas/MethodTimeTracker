//
//  NSObject+SwizzleMethodPrivate.h
//  MSMethodTimeTracker
//
//  Created by ahimahas on 2017. 2. 15..
//  Copyright © 2017년 MS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSOriginImpContainer.h"

void methodReturnVoid(id self, SEL cmd, ...);
id methodReturnId(id self, SEL cmd, ...);
SEL methodReturnSel(id self, SEL cmd, ...);
Class methodReturnClass(id self, SEL cmd, ...);
char methodReturnChar(id self, SEL cmd, ...);
int methodReturnInt(id self, SEL cmd, ...);
bool methodReturnBool(id self, SEL cmd, ...);
BOOL methodReturnBOOL(id self, SEL cmd, ...);
short methodReturnShort(id self, SEL cmd, ...);
unichar methodReturnUnichar(id self, SEL cmd, ...);
float methodReturnFloat(id self, SEL cmd, ...);
double methodReturnDouble(id self, SEL cmd, ...);
long methodReturnLong(id self, SEL cmd, ...);
long long methodReturnLongLong(id self, SEL cmd, ...);
unsigned int methodReturnUnsignedInt(id self, SEL cmd, ...);
unsigned char methodReturnUnsignedChar(id self, SEL cmd, ...);
unsigned short methodReturnUnsignedShort(id self, SEL cmd, ...);
unsigned long methodReturnUnsignedLong(id self, SEL cmd, ...);
unsigned long long methodReturnUnsignedLongLong(id self, SEL cmd, ...);
void * methodReturnVoidPointer(id self, SEL cmd, ...);
char * methodReturnCharPointer(id self, SEL cmd, ...);



@interface NSObject (SwizzleMethodPrivate)

//! Storage for origin implementation, preProcedure and postPrecedure at method name as a key.
@property (atomic, strong) NSMutableDictionary<NSString *, MSOriginImpContainer *> *originImps;

@end
