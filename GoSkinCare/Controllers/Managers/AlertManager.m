//
//  AlertManager.m
//  GoSkinCare
//


#import "AlertManager.h"
#import "GSCAlertVC.h"

typedef void (^GSCAlertHandler)();

@interface AlertManager () <GSCAlertDelegate>

@property (strong, nonatomic) GSCAlertVC* gscAlert;
@property (nonatomic) GSCAlertType gscAlertType;

@property (strong, nonatomic) GSCAlertHandler alertOKHandler;
@property (strong, nonatomic) GSCAlertHandler confirmOKHandler;
@property (strong, nonatomic) GSCAlertHandler confirmCancelHandler;

@end

@implementation AlertManager

+ (AlertManager* _Nullable)sharedManager {
    
    static AlertManager* _sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (GSCAlertVC*)gscAlert {
    if (_gscAlert)
        return _gscAlert;
    
    _gscAlert = (GSCAlertVC*)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"GSCAlertVC"];
    _gscAlert.view.frame = ScreenBounds;
    
    return _gscAlert;
}

- (void)setGscAlertType:(GSCAlertType)gscAlertType {
    _gscAlertType = gscAlertType;
    [self.gscAlert setAlertType:_gscAlertType];
}

- (void)updateAlertLabelTextColor:(UIView*)superView {
    
    NSArray* subViews = superView.subviews;
    for (UIView* subView in subViews) {
        if (!subView)
            continue;
        
        
        if ([subView isKindOfClass:[UIButton class]]) {
            NSLog(@"BUTTON : \n%@", subView);
        }
        else if ([subView isKindOfClass:[UILabel class]]) {
            NSLog(@"LABEL : \n%@\n%@", subView, ((UILabel*)subView).font);
            ((UILabel*)subView).textColor = [UIColor whiteColor];
        }
        else {
            [self updateAlertLabelTextColor:subView];
        }
    }
}

- (void)showAlertWithTitle:(NSString* __nullable)title message:(NSString* __nullable)message parentVC:(UIViewController* __nullable)parentVC okHandler:(void (^ __nullable)())okHandler {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (okHandler)
            okHandler();
    }]];
    /*
    NSMutableAttributedString* attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [attrTitle addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0] range:NSMakeRange(0, attrTitle.length)];
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrTitle.length)];
    [alert setValue:attrTitle forKey:@"attributedTitle"];
    
    NSMutableAttributedString* attrMessage = [[NSMutableAttributedString alloc] initWithString:message];
    [attrMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, attrMessage.length)];
    [attrMessage addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrMessage.length)];
    [alert setValue:attrMessage forKey:@"attributedMessage"];
    
    UIView* firstView = alert.view.subviews.firstObject;
    UIView* nextView = firstView.subviews.firstObject;
    nextView.backgroundColor = MainTintColor;
    nextView.layer.cornerRadius = 12.f;
    
    alert.view.tintColor = [UIColor whiteColor];
    */
    
    alert.view.tintColor = MainTintColor;
    
    [parentVC presentViewController:alert animated:YES completion:^{
    }];
    
    
    /*
    self.gscAlertType = GSCAlertType_Alert;
    self.alertOKHandler = okHandler;
    
    self.gscAlert.delegate = self;
    self.gscAlert.alertTitle = title;
    self.gscAlert.alertMessage = message;
    
    if (!self.gscAlert.view.superview) {
        NSEnumerator* frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.gscAlert.view];
                break;
            }
        }
    }
    */
}

- (void)showConfirmWithTitle:(NSString* __nullable)title message:(NSString* __nullable)message parentVC:(UIViewController* __nullable)parentVC cancelHandler:(void (^ __nullable)())cancelHandler okHandler:(void (^ __nullable)())okHandler {
    
    UIAlertController* confirm = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [confirm addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (okHandler)
            okHandler();
    }]];
    [confirm addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelHandler)
            cancelHandler();
    }]];
    
    /*
    NSMutableAttributedString* attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [attrTitle addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0] range:NSMakeRange(0, attrTitle.length)];
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrTitle.length)];
    [confirm setValue:attrTitle forKey:@"attributedTitle"];
    
    NSMutableAttributedString* attrMessage = [[NSMutableAttributedString alloc] initWithString:message];
    [attrMessage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, attrMessage.length)];
    [attrMessage addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrMessage.length)];
    [confirm setValue:attrMessage forKey:@"attributedMessage"];
    
    UIView* firstView = confirm.view.subviews.firstObject;
    UIView* nextView = firstView.subviews.firstObject;
    nextView.backgroundColor = MainTintColor;
    nextView.layer.cornerRadius = 12.f;
    
    confirm.view.tintColor = [UIColor whiteColor];
     */
    
    confirm.view.tintColor = MainTintColor;
    
    [parentVC presentViewController:confirm animated:YES completion:^{
    }];
    
    
    /*
    self.gscAlertType = GSCAlertType_Confirm;
    self.confirmOKHandler = okHandler;
    self.confirmCancelHandler = cancelHandler;
    
    self.gscAlert.delegate = self;
    self.gscAlert.alertTitle = title;
    self.gscAlert.alertMessage = message;
    
    if (!self.gscAlert.view.superview) {
        NSEnumerator* frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.gscAlert.view];
                break;
            }
        }
    }
    */
}

- (void)dismiss {
    [self.gscAlert.view removeFromSuperview];
}


#pragma mark -
#pragma mark - GSCAlertVC delegate

- (void)alertOKClicked {
    [self dismiss];
    
    if (self.gscAlertType == GSCAlertType_Alert) {
        if (self.alertOKHandler)
            self.alertOKHandler();
    }
}

- (void)confirmOKClicked {
    [self dismiss];
    
    if (self.gscAlertType == GSCAlertType_Confirm) {
        if (self.confirmOKHandler)
            self.confirmOKHandler();
    }
}

- (void)confirmCancelClicked {
    [self dismiss];
    
    if (self.gscAlertType == GSCAlertType_Confirm) {
        if (self.confirmCancelHandler)
            self.confirmCancelHandler();
    }
}

@end
