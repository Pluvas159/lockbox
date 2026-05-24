#import "ReactNativeLockbox.h"

// Forward declare the Swift Lockbox class exposed to Objective-C
@interface Lockbox : NSObject
+ (nonnull instancetype)shared;
- (BOOL)saveSecureString:(nonnull NSString *)key value:(nonnull NSString *)value;
- (nullable NSString *)getSecureString:(nonnull NSString *)key;
- (BOOL)deleteSecureString:(nonnull NSString *)key;
@end

@implementation ReactNativeLockbox

- (void)saveSecureString:(NSString *)key
                   value:(NSString *)value
                 resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject {
  BOOL success = [[Lockbox shared] saveSecureString:key value:value];
  resolve(@(success));
}

- (void)getSecureString:(NSString *)key
                resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject {
  NSString *value = [[Lockbox shared] getSecureString:key];
  resolve(value);
}

- (void)deleteSecureString:(NSString *)key
                   resolve:(RCTPromiseResolveBlock)resolve
                    reject:(RCTPromiseRejectBlock)reject {
  BOOL success = [[Lockbox shared] deleteSecureString:key];
  resolve(@(success));
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeReactNativeLockboxSpecJSI>(params);
}

+ (NSString *)moduleName
{
  return @"ReactNativeLockbox";
}

@end
