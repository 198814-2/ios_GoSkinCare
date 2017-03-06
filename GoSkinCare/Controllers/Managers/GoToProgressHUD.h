//
//  GoToProgressHUD.h
//  GoSkinCare
//


#import <Foundation/Foundation.h>

@interface GoToProgressHUD : NSObject

+ (GoToProgressHUD*)progressHUD;

+ (void)showWithStatus:(NSString*)status;
+ (void)dismiss;

@end
