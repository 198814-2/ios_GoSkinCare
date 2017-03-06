//
//  MainVC.m
//  GoSkinCare


#import "MainVC.h"


@interface MainVC () <LoginManagerDelegate>

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowLoginManagerVC]) {
        UINavigationController* navVC = segue.destinationViewController;
        LoginManagerVC* loginManager = (LoginManagerVC*)navVC.viewControllers[0];
        loginManager.delegate = self;
    }
}


#pragma mark -
#pragma mark - Main methods

- (void)initUI {
    
}

#pragma mark - Overriden Methods -

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    switch (indexPath.row) {
        case MenuItem_FastOrder:
            identifier = Segue_ShowFastOrderVC;
            break;
        case MenuItem_MagicOrder:
            identifier = Segue_ShowMagicOrderVC;
            break;
        case MenuItem_Profile:
            identifier = Segue_ShowProfileVC;
            break;
        case MenuItem_History:
            identifier = Segue_ShowHistoryVC;
            break;
        case MenuItem_Terms:
            identifier = Segue_ShowTermsVC;
            break;
        case MenuItem_Help:
            identifier = Segue_ShowHelpVC;
            break;
        case MenuItem_Logout:
            identifier = Segue_Logout;
            break;
    }
    
    return identifier;
}

- (CGFloat)leftMenuWidth {
    return ScreenBounds.size.width * 0.8f;
}

- (void)configureLeftMenuButton:(UIButton *)button {
    CGRect frame = button.frame;
    frame = CGRectMake(0.f, 0.f, 36.f, 36.f);
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
}

- (void) configureSlideLayer:(CALayer *)layer {
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 1.f;
    layer.shadowOffset = CGSizeMake(0.f, 0.f);
    layer.shadowRadius = 5.f;
    layer.masksToBounds = NO;
    layer.shadowPath =[UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
}

- (PrimaryMenu)primaryMenu {
    return PrimaryMenuLeft;
}

// Enabling Deepnes on left menu
- (BOOL)deepnessForLeftMenu {
    return YES;
}

// Enabling darkness while left menu is opening
- (CGFloat)maxDarknessWhileLeftMenu {
    return 0.5;
}

// Enabling darkness while right menu is opening
- (CGFloat)maxDarknessWhileRightMenu {
    return 0.5;
}


#pragma mark -
#pragma mark - LoginManager delegate

- (void)loginManager:(LoginManagerVC *)loginManager didSuccessToLoginWithEmail:(NSString *)email password:(NSString *)password {
    [self.leftMenu performSelectedSegue];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginManager:(LoginManagerVC *)loginManager didFailToLoginWithEmail:(NSString *)email {
    [self closeLeftMenu];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
