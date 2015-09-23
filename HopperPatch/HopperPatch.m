#import <Foundation/Foundation.h>
#include <objc/runtime.h>
#include <objc/message.h>

id stringListComponentWithLabelAndList(id self, SEL _cmd, NSString *label, NSArray *list) {
    Class loaderOptionComponentsClass = objc_getClass("LoaderOptionComponents");
    return ((id (*)(id, SEL, id, id))objc_msgSend)(loaderOptionComponentsClass, _cmd, label, list);
}

id stringListComponentWithLabel(id self, SEL _cmd, NSString *label) {
    return stringListComponentWithLabelAndList(self, _cmd, label, @[]);
}

void NSLog(NSString *format, ...) {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        Class hopperServicesClass = objc_getClass("HopperServices");
        class_addMethod(hopperServicesClass, @selector(stringListComponentWithLabel:), (IMP)stringListComponentWithLabel, "@@:@");
        class_addMethod(hopperServicesClass, @selector(stringListComponentWithLabel:andList:), (IMP)stringListComponentWithLabelAndList, "@@:@@");        
    });
}
