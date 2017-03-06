//
//  GoToProgressHUD.m
//  GoSkinCare
//

#import "GoToProgressHUD.h"
#import "GSCProgressVC.h"

typedef void (^GSCAlertHandler)();

@interface GoToProgressHUD ()

@property (strong, nonatomic) GSCProgressVC* gscProgressVC;

@end

@implementation GoToProgressHUD

+ (GoToProgressHUD*)progressHUD {
    
    static GoToProgressHUD* _progressHUD = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _progressHUD = [[self alloc] init];
    });
    
    return _progressHUD;
}

- (GSCProgressVC*)gscProgressVC {
    if (_gscProgressVC)
        return _gscProgressVC;
    
    _gscProgressVC = (GSCProgressVC*)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"GSCProgressVC"];
    _gscProgressVC.view.frame = ScreenBounds;
    
    return _gscProgressVC;
}

+ (void)showWithStatus:(NSString*)status {
    [[self progressHUD] showWithStatus:status];
}

- (void)showWithStatus:(NSString*)status {
    [self.gscProgressVC setStatus:status];
    if (!self.gscProgressVC.view.superview) {
        NSEnumerator* frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.gscProgressVC.view];
                break;
            }
        }
    }
}

+ (void)dismiss {
    [[self progressHUD].gscProgressVC.view removeFromSuperview];
}


@end
