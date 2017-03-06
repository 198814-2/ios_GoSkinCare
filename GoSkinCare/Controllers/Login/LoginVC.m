//
//  LoginVC.m
//  GoSkinCare


#import "LoginVC.h"
#import "ProfileVC.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITableView* infoTableView;
@property (weak, nonatomic) IBOutlet UIView* infoWrapper;
@property (weak, nonatomic) IBOutlet UILabel* emailLabel;
@property (weak, nonatomic) IBOutlet UITextField* emailField;
@property (weak, nonatomic) IBOutlet UITextField* passwordField;

@property (weak, nonatomic) IBOutlet UIButton* forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton* signinButton;
@property (weak, nonatomic) IBOutlet UIButton* guestLoginButton;
@property (weak, nonatomic) IBOutlet UIButton* joinNowButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* infoLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* emailLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* forgotPasswordTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* emailFieldHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* passwordFieldHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* signinButtonCenterYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* guestLoginButtonCenterYConstraint;

@property (strong, nonatomic) UITextField* curTextField;

@end

@implementation LoginVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
    
    [self updateConstraints];
    [self updateButtonFonts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initUI];
}

- (void)viewDidLayoutSubviews {
    self.infoWrapper.frame = CGRectMake(0.f, 0.f, ScreenBounds.size.width, ScreenBounds.size.height - 64.f);
    self.infoTableView.contentSize = self.infoWrapper.frame.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowSignupVC]) {
        ProfileVC* vc = segue.destinationViewController;
        vc.profileSourceType = ProfileSourceType_Login;
    }
}


#pragma mark -
#pragma mark - Main methods

- (void)updateConstraints {
    if (CGRectGetHeight(ScreenBounds) < 500.f) {
        self.infoLabelTopConstraint.constant = 10.f;
        self.emailLabelTopConstraint.constant = 15.f;
        self.forgotPasswordTopConstraint.constant = 10.f;
        
        self.emailFieldHeightConstraint.constant = 25.f;
        self.passwordFieldHeightConstraint.constant = 25.f;
        
        self.signinButtonCenterYConstraint.constant = -10.f;
        self.guestLoginButtonCenterYConstraint.constant = -5.f;
    }
}

- (void)updateButtonFonts {
    
    NSLog(@"\n%@\n%@", self.forgotPasswordButton.titleLabel.font, self.emailLabel.font);
    
    UIFontDescriptor* fontDescriptor = self.emailLabel.font.fontDescriptor;
    UIFont* font = [UIFont fontWithDescriptor:fontDescriptor size:16.f];
    if (CGRectGetWidth(ScreenBounds) < 350.f) {
        font = [UIFont fontWithDescriptor:fontDescriptor size:12.f];
    }
    else if (CGRectGetWidth(ScreenBounds) < 400.f) {
        font = [UIFont fontWithDescriptor:fontDescriptor size:15.f];
    }

    // GuestLogin Button
    NSString* text = @"JUST BROWSING? TROT ON IN AS A GUEST";
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:font}
                            range:[text rangeOfString:text]];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:font}
                            range:[text rangeOfString:@"TROT ON IN AS A GUEST"]];
    [self.guestLoginButton setAttributedTitle:attributedText forState:UIControlStateNormal];
    
    NSMutableAttributedString* highlightedText = [[NSMutableAttributedString alloc] initWithString:text];
    [highlightedText setAttributes:@{NSForegroundColorAttributeName:ProductBorderColor, NSFontAttributeName:font}
                             range:[text rangeOfString:text]];
    [self.guestLoginButton setAttributedTitle:highlightedText forState:UIControlStateHighlighted];
    
    
    // JoinNow Button
    text = @"NOT A GOCONUT? JOIN NOW!";
    attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:font}
                            range:[text rangeOfString:text]];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:font}
                            range:[text rangeOfString:@"JOIN NOW!"]];
    [self.joinNowButton setAttributedTitle:attributedText forState:UIControlStateNormal];
    
    highlightedText = [[NSMutableAttributedString alloc] initWithString:text];
    [highlightedText setAttributes:@{NSForegroundColorAttributeName:ProductBorderColor, NSFontAttributeName:font}
                             range:[text rangeOfString:text]];
    [self.joinNowButton setAttributedTitle:highlightedText forState:UIControlStateHighlighted];
}

- (void)initUI {
    self.infoWrapper.frame = CGRectMake(0.f, 0.f, ScreenBounds.size.width, ScreenBounds.size.height - 64.f);
    
    NSDictionary* userDetails = [[APIManager sharedManager] getUserDetails];
    NSLog(@"userDetails = %@", userDetails);
    if (userDetails) {
        self.emailField.text = userDetails[key_email];
        self.passwordField.text = userDetails[key_password];
        
//        self.view.alpha = 0.f;
//        [self performSegueWithIdentifier:Segue_ShowMainVCWithoutAnimation sender:nil];
    }
    
    self.view.alpha = 1.f;
}

- (IBAction)tapSignInButton:(UIButton*)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:gsc_user_is_guest_login];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString* email = self.emailField.text;
    if (!email || [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Email address should not be empty." parentVC:self okHandler:^{
            [self.emailField becomeFirstResponder];
        }];
        return;
    }
    
    if (![UtilManager validateEmail:email]) {
        [self.emailField becomeFirstResponder];
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Email address is not valid." parentVC:self okHandler:^{
            [self.emailField becomeFirstResponder];
        }];
        return;
    }
    
    NSString* password = self.passwordField.text;
    if (!password || [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Password should not be empty." parentVC:self okHandler:^{
            [self.passwordField becomeFirstResponder];
        }];
        return;
    }
    
    
    if (sender)
        sender.userInteractionEnabled = NO;
    
    [GoToProgressHUD showWithStatus:@"Authenticating..."];
    [[APIManager sharedManager] loginWithEmail:email password:password success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseDict = responseObject;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
            NSLog(@"Login response string : %@", responseString);
#endif
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        }
        else {
#if DEBUG
            NSLog(@"Login response : %@", responseObject);
#endif
        }
        
        
        [GoToProgressHUD dismiss];
        
        if (sender)
            sender.userInteractionEnabled = YES;
        
        
        if (responseDict) {
            BOOL success = [responseDict[key_success] boolValue];
            if (success) {
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:responseDict[key_user]];
                [userInfo setObject:password forKey:key_password];
//                [userInfo setObject:company forKey:key_company];
//                [userInfo setObject:countryInfo forKey:key_country];
                [[APIManager sharedManager] saveUserDetails:userInfo];
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:gsc_user_is_guest_login];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self performSegueWithIdentifier:Segue_ShowMainVC sender:nil];
                
                return;
            }
        }
        
        [[AlertManager sharedManager] showAlertWithTitle:@"Login Failed" message:responseDict[key_message] parentVC:self okHandler:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [GoToProgressHUD dismiss];
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:[error localizedDescription] parentVC:self okHandler:nil];
        
        if (sender)
            sender.userInteractionEnabled = YES;
    }];
}

- (IBAction)tapForgotPasswordButton:(UIButton*)sender {
    
}

- (IBAction)tapGuestLoginButton:(UIButton*)sender {
    // guest login
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:gsc_user_is_guest_login];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:Segue_ShowMainVC sender:nil];
}

- (IBAction)tapJoinNowButton:(UIButton*)sender {
    [self performSegueWithIdentifier:Segue_ShowSignupVC sender:nil];
}

- (IBAction)resignInfoFields {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)unwindToLoginVC:(UIStoryboardSegue*)segue {
    self.emailField.text = nil;
    self.passwordField.text = nil;
    [self resignInfoFields];
}


#pragma mark -
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField*)sender {
    self.curTextField = sender;
    
    if ([self.curTextField respondsToSelector:@selector(inputAssistantItem)]) {
        UITextInputAssistantItem* item = [self.curTextField inputAssistantItem];
        item.leadingBarButtonGroups = @[];
        item.trailingBarButtonGroups = @[];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([textField isEqual:self.emailField]) {
        [self.passwordField becomeFirstResponder];
    }
    else if ([textField isEqual:self.passwordField]) {
//        [self.emailField becomeFirstResponder];
        [self tapSignInButton:self.signinButton];
    }
    return YES;
}


#pragma mark -
#pragma mark - Keyboard delegate

- (void)keyboardWillShow:(NSNotification*)notif {
    
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [self animateTextFieldUp:YES duration:(CGFloat)duration.floatValue keyboardBounds:keyboardBounds];
}

- (void)keyboardWillHide:(NSNotification*)notif {
    
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [self animateTextFieldUp:NO duration:(CGFloat)duration.floatValue keyboardBounds:keyboardBounds];
}

- (void)animateTextFieldUp:(BOOL)up duration:(CGFloat)duration keyboardBounds:(CGRect)keyboardBounds {
    
    self.infoTableView.scrollEnabled = up;
    
    if (up)
        self.bottomConstraint.constant = keyboardBounds.size.height;
    else
        self.bottomConstraint.constant = 0.f;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}


@end
