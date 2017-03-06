//
//  ForgotPasswordVC.m
//  GoSkinCare


#import "ForgotPasswordVC.h"

@interface ForgotPasswordVC ()

@property (weak, nonatomic) IBOutlet UITableView* infoTableView;
@property (weak, nonatomic) IBOutlet UIView* infoWrapper;
@property (weak, nonatomic) IBOutlet UITextField* emailField;
@property (weak, nonatomic) IBOutlet UIButton* resetButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* topBarBorderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bottomConstraint;

@property (strong, nonatomic) UITextField* curTextField;

@end

@implementation ForgotPasswordVC

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
    
    self.topBarBorderHeight.constant = 0.5f;
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
    self.infoWrapper.frame = CGRectMake(0.f, 0.f, ScreenBounds.size.width, ScreenBounds.size.height - 64.f);
}

- (IBAction)tapResetButton:(UIButton*)sender {
    
    NSString* email = self.emailField.text;
    if (!email || [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Please type your email address" parentVC:self okHandler:^{
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
    
    
    if (sender)
        sender.userInteractionEnabled = NO;
    
    [GoToProgressHUD showWithStatus:@"Resetting..."];
    [[APIManager sharedManager] resetPasswordWithEmail:email success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* responseDict = responseObject;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
            NSLog(@"ResetPassword response string : %@", responseString);
#endif
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        }
        else {
#if DEBUG
            NSLog(@"ResetPassword response : %@", responseObject);
#endif
        }
        
        [GoToProgressHUD dismiss];
        
        if (sender)
            sender.userInteractionEnabled = YES;
        
        
        if (responseDict) {
            BOOL success = [responseDict[key_success] boolValue];
            if (success) {
                NSString* message = responseDict[key_message];
                if (!message || message.length < 1)
                    message = @"Your password is reset. Please check your email.";
                
                [[AlertManager sharedManager] showAlertWithTitle:@"" message:message parentVC:self okHandler:^{
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:gsc_user_is_guest_login])
                        [self performSegueWithIdentifier:Segue_UnWindToLoginManagerVC sender:nil];
                    else
                        [self performSegueWithIdentifier:Segue_UnWindToLoginVC sender:nil];
                }];
                return;
            }
        }
        
        [[AlertManager sharedManager] showAlertWithTitle:@"Failed to reset password" message:responseDict[key_message] parentVC:self okHandler:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [GoToProgressHUD dismiss];
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:[error localizedDescription] parentVC:self okHandler:nil];
        
        if (sender)
            sender.userInteractionEnabled = YES;
    }];
}

- (IBAction)tapCancelButton:(UIButton*)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resignInfoFields {
    [self.emailField resignFirstResponder];
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
    [self tapResetButton:self.resetButton];
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
