//
//  TermsVC.m
//  GoSkinCare


#import "TermsVC.h"
#import "UIViewController+SlideMenu.h"

@interface TermsVC ()

@property (weak, nonatomic) IBOutlet UIWebView* termsWebView;

@end

@implementation TermsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    
    // track GA
    [UtilManager trackingScreenView:GA_SCREENNAME_TERMS_OF_USE];
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
    [self.termsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:TermsPageUrl]]];
}

- (IBAction)tapMenuButton:(UIButton*)sender {
    [[self mainSlideMenu] openLeftMenu];
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
