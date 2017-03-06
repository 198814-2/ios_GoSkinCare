//
//  SignupVC.m
//  GoSkinCare


#import "SignupVC.h"
#import "CountriesVC.h"

@interface SignupVC ()

@property (weak, nonatomic) IBOutlet UIScrollView* infoScrollView;
@property (weak, nonatomic) IBOutlet UITextField* firstnameField;
@property (weak, nonatomic) IBOutlet UITextField* surnameField;
@property (weak, nonatomic) IBOutlet UITextField* nicknameField;
@property (weak, nonatomic) IBOutlet UITextField* emailField;
@property (weak, nonatomic) IBOutlet UITextField* passwordField;
@property (weak, nonatomic) IBOutlet UITextField* companyField;
@property (weak, nonatomic) IBOutlet UITextField* streetField;
@property (weak, nonatomic) IBOutlet UITextField* street2Field;
@property (weak, nonatomic) IBOutlet UITextField* suburbField;
@property (weak, nonatomic) IBOutlet UITextField* stateField;
@property (weak, nonatomic) IBOutlet UITextField* postCodeField;
@property (weak, nonatomic) IBOutlet UITextField* countryField;
@property (weak, nonatomic) IBOutlet UIButton* signupButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* infoScrollBottom;

@property (strong, nonatomic) NSDictionary* countryInfo;

@property (strong, nonatomic) UITextField* curTextField;
@property (nonatomic) CGRect keyboardBounds;

@end

@implementation SignupVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initUI];
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
    
    if ([segue.identifier isEqualToString:Segue_ShowCountriesVC]) {
        CountriesVC* vc = segue.destinationViewController;
        vc.countryInfo = self.countryInfo;
    }
}


#pragma mark -
#pragma mark - Main methods

- (void)initUI {
    CGFloat scrollHeight = MAX(self.infoScrollView.frame.size.height, 751.f);
    self.infoScrollView.contentSize = CGSizeMake(self.infoScrollView.frame.size.width, scrollHeight);
//    [self.infoScrollView flashScrollIndicators];
}

- (IBAction)tapCreateButton:(UIButton*)sender {
    
    NSString* firstname = self.firstnameField.text;
    if (!firstname || [firstname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Firstname should not be empty." parentVC:self okHandler:^{
            [self.firstnameField becomeFirstResponder];
        }];
        return;
    }
    
    NSString* surname = self.firstnameField.text;
    if (!surname || [surname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Surname should not be empty." parentVC:self okHandler:^{
            [self.surnameField becomeFirstResponder];
        }];
        return;
    }
    
    NSString* nickname = self.nicknameField.text;
    if (!nickname)
        nickname = @"";
    
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
    
    NSString* company = self.companyField.text;
    if (company == nil)
        company = @"";
    /*
    if (!company || [company stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Company should not be empty." okHandler:^{
            [self.companyField becomeFirstResponder];
        }];
        return;
    }
    */
    
    NSString* street = self.streetField.text;
    if (!street || [street stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Street should not be empty." parentVC:self okHandler:^{
            [self.streetField becomeFirstResponder];
        }];
        return;
    }
    
    NSString* street2 = self.street2Field.text;
    
    NSString* suburb = self.suburbField.text;
    if (!suburb || [suburb stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Suburb should not be empty." parentVC:self okHandler:^{
            [self.suburbField becomeFirstResponder];
        }];
        return;
    }
    
    NSString* state = self.stateField.text;
    if (!state || [state stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"State should not be empty." parentVC:self okHandler:^{
            [self.stateField becomeFirstResponder];
        }];
        return;
    }
    
    NSString* postCode = self.postCodeField.text;
    if (!postCode || [postCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Post code should not be empty." parentVC:self okHandler:^{
            [self.postCodeField becomeFirstResponder];
        }];
        return;
    }
    
    if (!self.countryInfo) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Country should not be empty." parentVC:self okHandler:nil];
        return;
    }
    
//    [SVProgressHUD showWithStatus:@"Creating..."];
    [GoToProgressHUD showWithStatus:@"Creating..."];
    [[APIManager sharedManager] verifyAddressWithCountryCode:self.countryInfo[key_code] street:street street2:street2 suburb:suburb state:state postCode:postCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseDict = responseObject;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
            NSLog(@"VerifyAddress response string : %@", responseString);
#endif
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        }
        else {
#if DEBUG
            NSLog(@"VerifyAddress response : %@", responseObject);
#endif
        }
        
        if (responseDict) {
            BOOL success = [responseDict[key_success] boolValue];
            BOOL isValidAddress = [responseDict[key_isValidAddress] boolValue];
            if (success && isValidAddress) {
                [self signupWithFirstname:firstname surname:surname nickname:nickname email:email password:password company:company countryCode:self.countryInfo[key_code] street:street street2:street2 suburb:suburb state:state postCode:postCode sender:sender];
                return;
            }
        }
        
        NSArray* recommendations = responseDict[key_recommendations];
        
//        [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
        
        if (sender)
            sender.userInteractionEnabled = YES;
        
        [[AlertManager sharedManager] showAlertWithTitle:@"Invalid Address" message:@"Your address doesn't seem to be valid." parentVC:self okHandler:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:[error localizedDescription] parentVC:self okHandler:nil];
        
        if (sender)
            sender.userInteractionEnabled = YES;
    }];
}

- (void)signupWithFirstname:(NSString*)firstname surname:(NSString*)surname nickname:(NSString*)nickname email:(NSString*)email password:(NSString*)password company:(NSString*)company countryCode:(NSString*)countryCode street:(NSString*)street street2:(NSString*)street2 suburb:(NSString*)suburb state:(NSString*)state postCode:(NSString*)postCode sender:(UIButton*)sender {
    
    [SVProgressHUD show];
    
    [[APIManager sharedManager] signupWithFirstname:firstname surname:surname nickname:nickname email:email password:password company:company countryCode:countryCode street:street street2:street2 suburb:suburb state:state postCode:postCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseDict = responseObject;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
            NSLog(@"Signup response string : %@", responseString);
#endif
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        }
        else {
#if DEBUG
            NSLog(@"Signup response : %@", responseObject);
#endif
        }
        
//        [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
        
        if (sender)
            sender.userInteractionEnabled = YES;
        
        
        if (responseDict) {
            BOOL success = [responseDict[key_success] boolValue];
            if (success) {
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:responseDict[key_user]];
                [userInfo setObject:password forKey:key_password];
                [userInfo setObject:company forKey:key_company];
                [[APIManager sharedManager] saveUserDetails:userInfo];
                
                [self performSegueWithIdentifier:Segue_UnWindToLoginVC sender:nil];
                
                return;
            }
        }
        
        [[AlertManager sharedManager] showAlertWithTitle:@"Signup Failed" message:responseDict[key_message] parentVC:self okHandler:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        [SVProgressHUD dismiss];
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
    [self.firstnameField resignFirstResponder];
    [self.surnameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.companyField resignFirstResponder];
    [self.countryField resignFirstResponder];
    [self.streetField resignFirstResponder];
    [self.street2Field resignFirstResponder];
    [self.suburbField resignFirstResponder];
    [self.stateField resignFirstResponder];
    [self.postCodeField resignFirstResponder];
}

- (void)showCountryVC {
    [self performSegueWithIdentifier:Segue_ShowCountriesVC sender:nil];
}

- (IBAction)unwindToSignupVC:(UIStoryboardSegue*)segue {
    CountriesVC* vc = segue.sourceViewController;
    self.countryInfo = vc.countryInfo;
    
    if (self.countryInfo)
        self.countryField.text = self.countryInfo[key_label];
}


#pragma mark -
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.countryField]) {
        [self showCountryVC];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField*)sender {
    self.curTextField = sender;
    
    if ([self.curTextField respondsToSelector:@selector(inputAssistantItem)]) {
        UITextInputAssistantItem* item = [self.curTextField inputAssistantItem];
        item.leadingBarButtonGroups = @[];
        item.trailingBarButtonGroups = @[];
    }
}


#pragma mark -
#pragma mark - Keyboard delegate

- (void)keyboardWillShow:(NSNotification*)notif {
    
    // get keyboard size and loctaion
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &_keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    _keyboardBounds = [self.view convertRect:_keyboardBounds toView:nil];
    
    [self animateTextFieldUp:YES duration:(CGFloat)duration.floatValue keyboardBounds:_keyboardBounds];
}

- (void)keyboardWillHide:(NSNotification*)notif {
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [self animateTextFieldUp:NO duration:(CGFloat)duration.floatValue keyboardBounds:keyboardBounds];
}

- (void)animateTextFieldUp:(BOOL)up duration:(CGFloat)duration keyboardBounds:(CGRect)keyboardBounds {
    
//    CGRect frame = self.infoScrollView.frame;
//    CGPoint contentOffset = self.infoScrollView.contentOffset;
//    if (up) {
//        contentOffset.y = self.passwordWrapper.frame.origin.y + self.passwordWrapper.frame.size.height + 10.f + self.joinWrapper.frame.size.height / 2;
//    }
//    else {
//        contentOffset.y = ScreenBounds.size.height - self.joinWrapper.frame.size.height / 2.f;
//    }
    
    
    [UIView animateWithDuration:duration animations:^{
        if (up)
            self.infoScrollBottom.constant = keyboardBounds.size.height - (ScreenBounds.size.height - CGRectGetMinY(self.signupButton.frame)) + 5.f;
        else
            self.infoScrollBottom.constant = 30.f;
        
//        [self.view layoutIfNeeded];
    
    } completion:^(BOOL finished) {
        
        CGFloat scrollHeight = MAX(self.infoScrollView.frame.size.height, 751.f);
        self.infoScrollView.contentSize = CGSizeMake(self.infoScrollView.frame.size.width, scrollHeight);
    }];
}


@end
