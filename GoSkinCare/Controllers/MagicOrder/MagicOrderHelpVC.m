//
//  MagicOrderHelpVC.m
//  GoSkinCare


#import "MagicOrderHelpVC.h"

@interface MagicOrderHelpVC ()

@property (weak, nonatomic) IBOutlet UIWebView* helpWebView;

@end

@implementation MagicOrderHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
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
#pragma mark - Main methods

- (void)initUI {
    [GoToProgressHUD showWithStatus:@"Loading..."];
    [self.helpWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:MagicOrderHelpPageUrl]]];
}


#pragma mark -
#pragma mark - UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [GoToProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [GoToProgressHUD dismiss];
    [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:[error localizedDescription] parentVC:self okHandler:nil];
}


@end
