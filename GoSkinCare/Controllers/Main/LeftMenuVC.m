//
//  LeftMenuVC.m
//  GoSkinCare


#import "LeftMenuVC.h"
#import "SlideMenuMainViewController.h"

@interface LeftMenuVC ()

@property (weak, nonatomic) IBOutlet UIView* headerView;

@end

@implementation LeftMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && ![UIApplication sharedApplication].isStatusBarHidden) {
        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -
#pragma mark - Logout method

- (void)logout {
    [super logout];
    NSLog(@"Logout");
    
    SlideMenuMainViewController *mainVC = (SlideMenuMainViewController *)self.parentViewController;
    [mainVC closeLeftMenuAnimated:NO];
    
    [[AlertManager sharedManager] showConfirmWithTitle:@"" message:@"Do you want to logout?" parentVC:self cancelHandler:^{
        
    } okHandler:^{
        [self performSegueWithIdentifier:Segue_Logout sender:nil];
    }];
}


@end
