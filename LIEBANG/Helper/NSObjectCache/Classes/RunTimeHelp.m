//
//  RunTimeHelp.m
//  NSObjectCache
//
//  Created by meixf on 2018/9/27.
//

#import "RunTimeHelp.h"
#import <objc/runtime.h>

@implementation RunTimeHelp
static NSMutableDictionary *propertyListByClass;

+ (NSArray *)propertyNames:(Class)klass
{
    if (klass == [NSObject class]) {
        return [NSArray array];
    }
    
    if (!propertyListByClass) {
        propertyListByClass = [[NSMutableDictionary alloc] init];
    }
    NSString *className = NSStringFromClass(klass);
    NSArray *value = [propertyListByClass objectForKey:className];
    
    if (value) {
        return value;
    }
    
    NSMutableArray *propertyNamesArray = [NSMutableArray array];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(klass, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        [propertyNamesArray addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    NSArray* arr = [RunTimeHelp propertyNames:class_getSuperclass(klass)];
    [propertyNamesArray addObjectsFromArray:arr];
    [propertyListByClass setObject:propertyNamesArray forKey:className];
    return propertyNamesArray;
}

+(void)exchangeMethod:(SEL)originSelector sourceSelector:(SEL)sourceSelector class:(Class)theClsss
{
    Method oriMethod = class_getInstanceMethod(theClsss, originSelector);
    
    Method cusMethod = class_getInstanceMethod(theClsss, sourceSelector);
    
    BOOL addSucc = class_addMethod(theClsss, originSelector, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
    if (addSucc) {
        // class_replaceMethod(theClsss, sourceSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }else {
        method_exchangeImplementations(oriMethod, cusMethod);
    }
    
}
@end
