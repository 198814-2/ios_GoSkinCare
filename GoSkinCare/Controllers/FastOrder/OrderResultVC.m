//
//  OrderResultVC.m
//  GoSkinCare
//


#import "OrderResultVC.h"
#import "UIViewController+SlideMenu.h"

@interface OrderResultVC ()

@property (weak, nonatomic) IBOutlet UILabel* orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel* emailLabel;

@end

@implementation OrderResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark - Main methods

- (void)initUI {
    if (self.orderId) {
        self.orderIDLabel.text = [NSString stringWithFormat:@"Corfirmation %@", self.orderId];
        self.emailLabel.text = [[APIManager sharedManager] getUserDetails][key_email];
    }
}

- (IBAction)tapMenuButton:(UIButton*)sender {
    [[self mainSlideMenu] openLeftMenu];
}

- (IBAction)tapBackButton:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
