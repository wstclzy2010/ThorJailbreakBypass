#line 1 "/Users/paigu/Documents/ThorJBbypass/ThorJBbypass/ThorJBbypass.xm"

#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class NSFileManager; @class NSURL; 
static NSArray * (*_logos_orig$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$)(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSString *, NSError **); static NSArray * _logos_method$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSString *, NSError **); static NSURL * (*_logos_meta_orig$_ungrouped$NSURL$fileURLWithPath$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *); static NSURL * _logos_meta_method$_ungrouped$NSURL$fileURLWithPath$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *); 

#line 1 "/Users/paigu/Documents/ThorJBbypass/ThorJBbypass/ThorJBbypass.xm"


static NSArray * _logos_method$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * path, NSError ** error) {
    
    if([path containsString:@"/Library/MobileSubstrate/DynamicLibraries"])
    {
        path = @"/Library/";
    }
    
    if([path containsString:@"/var/mobile/Library/Application Support/Supercharge"] ||
       [path containsString:@"/var/mobile/Library/Application Support/Flex3"] )
    {
        path = @"/var/";
    }

    if([path containsString:@"/var/mobile/Library/UserConfiguration/Profiles/PublicInfo/Flex3Patches.plist"])
    {
        path = @"/var/mobile/Library/";
    }

    HBLogDebug(@"-[<NSFileManager: %p> contentsOfDirectoryAtPath:%@ error:%p]", self, path, error);
    return _logos_orig$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$(self, _cmd, path, error);
}















    









    









































static NSURL * _logos_meta_method$_ungrouped$NSURL$fileURLWithPath$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * path) {

    if([path containsString:@"/Library/MobileSubstrate/DynamicLibraries/"])
    {
        path = @"/Library/";
    }

    if([path containsString:@"/Library/Application Support/Supercharge"] ||
       [path containsString:@"/Library/Application Support/Flex3"] )
    {
        path = @"/var";
    }







    HBLogDebug(@"+[<NSURL: %p> fileURLWithPath:%@]", self, path);
    return _logos_meta_orig$_ungrouped$NSURL$fileURLWithPath$(self, _cmd, path);
}




static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$NSFileManager = objc_getClass("NSFileManager"); MSHookMessageEx(_logos_class$_ungrouped$NSFileManager, @selector(contentsOfDirectoryAtPath:error:), (IMP)&_logos_method$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$, (IMP*)&_logos_orig$_ungrouped$NSFileManager$contentsOfDirectoryAtPath$error$);Class _logos_class$_ungrouped$NSURL = objc_getClass("NSURL"); Class _logos_metaclass$_ungrouped$NSURL = object_getClass(_logos_class$_ungrouped$NSURL); MSHookMessageEx(_logos_metaclass$_ungrouped$NSURL, @selector(fileURLWithPath:), (IMP)&_logos_meta_method$_ungrouped$NSURL$fileURLWithPath$, (IMP*)&_logos_meta_orig$_ungrouped$NSURL$fileURLWithPath$);} }
#line 117 "/Users/paigu/Documents/ThorJBbypass/ThorJBbypass/ThorJBbypass.xm"
