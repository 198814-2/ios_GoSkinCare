//
//  LoginManagerVC.h
//  GoSkinCare


#import <UIKit/UIKit.h>

@protocol LoginManagerDelegate;

@interface LoginManagerVC : UIViewController

@property (strong, nonatomic) id<LoginManagerDelegate> delegate;

@end

@protocol LoginManagerDelegate <NSObject>

- (void)loginManager:(LoginManagerVC*)loginManager didSuccessToLoginWithEmail:(NSString*)email password:(NSString*)password;
- (void)loginManager:(LoginManagerVC*)loginManager didFailToLoginWithEmail:(NSString*)email;

@end
