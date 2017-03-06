//
//  AlertManager.h
//  GoSkinCare


#import <Foundation/Foundation.h>

@interface AlertManager : NSObject

+ (AlertManager* _Nullable)sharedManager;

- (void)showAlertWithTitle:(NSString* __nullable)title message:(NSString* __nullable)message parentVC:(UIViewController* __nullable)parentVC okHandler:(void (^ __nullable)())okHandler;
- (void)showConfirmWithTitle:(NSString* __nullable)title message:(NSString* __nullable)message parentVC:(UIViewController* __nullable)parentVC cancelHandler:(void (^ __nullable)())cancelHandler okHandler:(void (^ __nullable)())okHandler;
- (void)dismiss;

@end
