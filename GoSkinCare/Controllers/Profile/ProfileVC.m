//
//  ProfileVC.m
//  GoSkinCare


#import "ProfileVC.h"
#import "CountriesVC.h"
#import "UIViewController+SlideMenu.h"


typedef enum InfoFieldTag
{
    InfoField_Firstname = 0,
    InfoField_Surname,
    InfoField_Email,
    InfoField_Password,
    InfoField_Company,
    InfoField_Street,
    InfoField_Street2,
    InfoField_Suburb,
    InfoField_State,
    InfoField_PostCode,
    InfoField_Country
}
InfoFieldTag;


@interface ProfileVC () {
    CGFloat animateDistance;
}

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;

@property (weak, nonatomic) IBOutlet UITableView* profileTableView;
@property (weak, nonatomic) IBOutlet UIView* headerWrapper;
@property (weak, nonatomic) IBOutlet UIView* footerWrapper;
@property (weak, nonatomic) IBOutlet UIView* tableFooterWrapper;

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
@property (weak, nonatomic) IBOutlet UIView* countryBorder;

@property (weak, nonatomic) IBOutlet UIButton* menuButton;
@property (weak, nonatomic) IBOutlet UIButton* updateButton;
@property (weak, nonatomic) IBOutlet UIButton* tableUpdateButton;
@property (weak, nonatomic) IBOutlet UIButton* cancelButton;
@property (weak, nonatomic) IBOutlet UIButton* tableCancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* footerBottom;

@property (weak, nonatomic) IBOutlet UIView* topBarBorderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* topBarBorderHeight;

@property (strong, nonatomic) NSDictionary* countryInfo;

@property (strong, nonatomic) UITextField* curTextField;

@end

@implementation ProfileVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
    self.topBarBorderHeight.constant = 0.5f;
    
    [self resetProfileInfo];
    
    
    // track GA
    if (self.profileSourceType != ProfileSourceType_Login) {
        [UtilManager trackingScreenView:GA_SCREENNAME_MY_PROFILE];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initUI];
}

//- (void)viewDidLayoutSubviews {
//    CGFloat scrollHeight = CGRectGetMaxY(self.tableFooterWrapper.frame);
//    self.profileTableView.contentSize = CGSizeMake(self.profileTableView.contentSize.width, scrollHeight);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Navigation

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
    CGFloat scrollHeight = CGRectGetMaxY(self.tableFooterWrapper.frame);
    self.profileTableView.contentSize = CGSizeMake(self.profileTableView.contentSize.width, scrollHeight);
}

- (void)resetProfileInfo {
    
    if (self.profileSourceType == ProfileSourceType_Login) {    // Create Profile
        self.titleLabel.text = @"Become a Goconuts";
        [self.updateButton setTitle:@"Create Profile" forState:UIControlStateNormal];
        [self.tableUpdateButton setTitle:@"Create Profile" forState:UIControlStateNormal];
        self.menuButton.alpha = 0.f;
        self.cancelButton.alpha = 1.f;
        self.tableCancelButton.alpha = 1.f;
    }
    else {  // Update Profile
        self.titleLabel.text = @"My Goconuts Profile";
        [self.updateButton setTitle:@"Update Profile" forState:UIControlStateNormal];
        [self.tableUpdateButton setTitle:@"Update Profile" forState:UIControlStateNormal];
        
        NSDictionary* userDetails = [[APIManager sharedManager] getUserDetails];
        self.countryInfo = [NSDictionary dictionaryWithDictionary:userDetails[key_country]];
        
        self.firstnameField.text = userDetails[key_firstname];
        self.surnameField.text = userDetails[key_surname];
        self.nicknameField.text = userDetails[key_nickname];
        self.emailField.text = userDetails[key_email];
        self.passwordField.text = nil;  // userDetails[key_password];
        self.companyField.text = userDetails[key_company];
        self.streetField.text = userDetails[key_address_street];
        self.street2Field.text = userDetails[key_address_street_2];
        self.suburbField.text = userDetails[key_address_suburb];
        self.stateField.text = userDetails[key_address_state];
        self.postCodeField.text = userDetails[key_address_postcode];
        
        [self loadCountry];
        
        self.firstnameField.enabled = self.profileSourceType != ProfileSourceType_OrderDetail;
        self.surnameField.enabled = self.profileSourceType != ProfileSourceType_OrderDetail;
        self.nicknameField.enabled = self.profileSourceType != ProfileSourceType_OrderDetail;
        self.emailField.enabled = self.profileSourceType != ProfileSourceType_OrderDetail;
        self.passwordField.enabled = self.profileSourceType != ProfileSourceType_OrderDetail;
        self.passwordField.placeholder = self.profileSourceType != ProfileSourceType_OrderDetail ? @"Type new password if want to change" : nil;
        
        self.firstnameField.textColor = self.firstnameField.enabled ? [UIColor blackColor] : [UIColor lightGrayColor];
        self.surnameField.textColor = self.surnameField.enabled ? [UIColor blackColor] : [UIColor lightGrayColor];
        self.nicknameField.textColor = self.nicknameField.enabled ? [UIColor blackColor] : [UIColor lightGrayColor];
        self.emailField.textColor = self.emailField.enabled ? [UIColor blackColor] : [UIColor lightGrayColor];
        self.passwordField.textColor = self.passwordField.enabled ? [UIColor blackColor] : [UIColor lightGrayColor];
        
        self.menuButton.alpha = self.profileSourceType != ProfileSourceType_OrderDetail;
        self.cancelButton.alpha = self.profileSourceType == ProfileSourceType_OrderDetail;
        self.tableCancelButton.alpha = self.profileSourceType == ProfileSourceType_OrderDetail;
    }
}

- (IBAction)tapMenuButton:(UIButton*)sender {
    [[self mainSlideMenu] openLeftMenu];
}

- (IBAction)tapUpdateButton:(UIButton*)sender {
    
    [self resignInfoFields];
    
    NSString* firstname = self.firstnameField.text;
    if (!firstname || [firstname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Firstname should not be empty." parentVC:self okHandler:^{
            [self.firstnameField becomeFirstResponder];
        }];
        return;
    }
    
    NSString* surname = self.surnameField.text;
    if (!surname || [surname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Surname should not be empty." parentVC:self okHandler:^{
            [self.surnameField becomeFirstResponder];
        }];
        return;
    }
    
    NSString* nickname = self.nicknameField.text;
    if (nickname == nil)
        nickname = @"";
    
    NSString* email = self.emailField.text;
    if (!email || [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Email address should not be empty." parentVC:self okHandler:^{
            [self.emailField becomeFirstResponder];
        }];
        return;
    }
    
    if (![UtilManager validateEmail:email]) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Email address is not valid." parentVC:self okHandler:^{
            [self.emailField becomeFirstResponder];
        }];
        return;
    }
    
    NSString* password = self.passwordField.text;
    if (self.profileSourceType == ProfileSourceType_Login) {
        if (!password || [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
            [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Password should not be empty." parentVC:self okHandler:^{
                [self.passwordField becomeFirstResponder];
            }];
            return;
        }
    }
    
    NSString* company = self.companyField.text;
    if (company == nil)
        company = @"";
    
    NSString* street = self.streetField.text;
    if (!street || [street stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Street should not be empty." parentVC:self okHandler:^{
            [self.streetField becomeFirstResponder];
        }];
        return;
    }
    
    NSString* street2 = self.street2Field.text;
    if (street2 == nil)
        street2 = @"";
    
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
    
    NSString* loadingString = @"Updating...";
    if (self.profileSourceType == ProfileSourceType_Login)
        loadingString = @"Creating...";
    
//    [SVProgressHUD showWithStatus:loadingString];
    [GoToProgressHUD showWithStatus:loadingString];
    [[APIManager sharedManager] verifyAddressWithCountryCode:self.countryInfo[key_code] street:street street2:street2 suburb:suburb state:state postCode:postCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseDict = [self responseDictFromResponse:responseObject];
        
        if (responseDict) {
            BOOL success = [responseDict[key_success] boolValue];
            BOOL isValidAddress = [responseDict[key_isValidAddress] boolValue];
            if (success && isValidAddress) {
//                [self updateProfileWithFirstname:firstname surname:surname nickname:nickname email:email password:password company:company countryCode:self.countryInfo[key_code] street:street street2:street2 suburb:suburb state:state postCode:postCode sender:sender];
                
                // update profile with address info from web service
                [self updateProfileWithFirstname:firstname
                                         surname:surname
                                        nickname:nickname
                                           email:email
                                        password:password
                                         company:company
                                     countryCode:self.countryInfo[key_code]
                                          street:responseDict[key_address_street]
                                         street2:responseDict[key_address_street_2]
                                          suburb:responseDict[key_address_suburb]
                                           state:responseDict[key_address_state]
                                        postCode:responseDict[key_address_postcode]
                                          sender:sender
                 ];
                
                return;
            }
        }
        
//        [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
        
        if (sender)
            sender.userInteractionEnabled = YES;
        
        NSArray* recommendations = responseDict[key_recommendations];
        if (recommendations && recommendations.count > 0) {
            [self showRecommendedAddresses:recommendations];
        }
        else {
            [[AlertManager sharedManager] showAlertWithTitle:@"Invalid Address" message:@"Your address doesn't seem to be valid." parentVC:self okHandler:nil];
            
            /*
            //A hacky translation
            NSString* msg = responseDict[key_message];
            if ([msg.lowercaseString isEqualToString:@"address not recognised"]) {
                [[AlertManager sharedManager] showAlertWithTitle:@"Invalid Address" message:
                 @"Ack! We couldn’t validate that address with Australia Post. Please confirm your details and try again." okHandler:nil];
            }
            else {
                [[AlertManager sharedManager] showAlertWithTitle:@"Invalid Address" message:msg okHandler:nil];
            }
            */
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:[error localizedDescription] parentVC:self okHandler:nil];
        
        if (sender)
            sender.userInteractionEnabled = YES;
    }];
}

- (IBAction)tapCancelButton:(UIButton*)sender {
    if (self.profileSourceType != ProfileSourceType_LeftMenu)
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
    
    if (self.curTextField)
        [self.curTextField resignFirstResponder];
}

- (void)updateProfileWithFirstname:(NSString*)firstname surname:(NSString*)surname nickname:(NSString*)nickname email:(NSString*)email password:(NSString*)password company:(NSString*)company countryCode:(NSString*)countryCode street:(NSString*)street street2:(NSString*)street2 suburb:(NSString*)suburb state:(NSString*)state postCode:(NSString*)postCode sender:(UIButton*)sender {
    
    NSString* loadingString = @"Updating...";
    if (self.profileSourceType == ProfileSourceType_Login)
        loadingString = @"Creating...";
    
//    [SVProgressHUD showWithStatus:loadingString];
    [GoToProgressHUD showWithStatus:loadingString];
    [[APIManager sharedManager] updateProfileWithFirstname:firstname surname:surname nickname:nickname email:email password:password company:company countryCode:countryCode street:street street2:street2 suburb:suburb state:state postCode:postCode isCreateProfile:(self.profileSourceType == ProfileSourceType_Login) success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseDict = [self responseDictFromResponse:responseObject];
        
//        [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
        
        if (sender)
            sender.userInteractionEnabled = YES;
        
        
        if (responseDict) {
            BOOL success = [responseDict[key_success] boolValue];
            if (success) {
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:responseDict[key_user]];
                NSString* oldPassword = [[APIManager sharedManager] getUserDetails][key_password];
                if (!password || [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1 || [password isEqualToString:oldPassword]) {
                    [userInfo setObject:oldPassword forKey:key_password];
                }
                [userInfo setObject:company forKey:key_company];
                [[APIManager sharedManager] saveUserDetails:userInfo];
                
                
                if (self.profileSourceType == ProfileSourceType_Login) {
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:gsc_user_is_guest_login])
                        [self performSegueWithIdentifier:Segue_UnWindToLoginManagerVC sender:nil];
                    else
                        [self performSegueWithIdentifier:Segue_UnWindToLoginVC sender:nil];
                }
                else if (self.profileSourceType == ProfileSourceType_OrderDetail) {
                    if (self.isForMagicOrder)
                        [self performSegueWithIdentifier:Segue_UnWindToMagicOrderVC sender:nil];
                    else
                        [self performSegueWithIdentifier:Segue_UnWindToOrderDetailVC sender:nil];
                }
                else if (self.profileSourceType == ProfileSourceType_LeftMenu) {
                    [[AlertManager sharedManager] showAlertWithTitle:@"Go-To" message:@"Update successful" parentVC:self okHandler:^{
                        [[self mainSlideMenu].leftMenu showFastOrderVC];
                    }];
                }
                
                return;
            }
        }
        
        [[AlertManager sharedManager] showAlertWithTitle:@"UpdateProfile Failed" message:responseDict[key_message] parentVC:self okHandler:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:[error localizedDescription] parentVC:self okHandler:nil];
        
        if (sender)
            sender.userInteractionEnabled = YES;
    }];
}

- (NSDictionary*)responseDictFromResponse:(id)responseObject {
    NSDictionary* responseDict = responseObject;
    if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
        NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
        NSLog(@"UpdateProfile response string : %@", responseString);
#endif
        responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
    }
    else {
#if DEBUG
        NSLog(@"UpdateProfile response : %@", responseObject);
#endif
    }
    
    return responseDict;
}

- (void)showRecommendedAddresses:(NSArray*)addresses {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Recommendations" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSDictionary* addressInfo in addresses) {
        NSString* street = addressInfo[key_address_street];
        NSString* suburb = addressInfo[key_address_suburb];
        NSString* state = addressInfo[key_address_state];
        NSString* postCode = addressInfo[key_address_postcode];
        NSString* address = [NSString stringWithFormat:@"%@, %@, %@ %@", street, suburb, state, postCode];
        
        [alert addAction:[UIAlertAction actionWithTitle:address style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
            self.streetField.text = street;
            self.suburbField.text = suburb;
            self.stateField.text = state;
            self.postCodeField.text = postCode;
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)showCountryVC {
    [self performSegueWithIdentifier:Segue_ShowCountriesVC sender:nil];
}

- (IBAction)unwindToProfileVC:(UIStoryboardSegue*)segue {
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%@, %@ : %@", textField.text, NSStringFromRange(range), string);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if ([textField isEqual:self.nicknameField]) {
        [self.firstnameField becomeFirstResponder];
    }
    else if ([textField isEqual:self.firstnameField]) {
        [self.surnameField becomeFirstResponder];
    }
    else if ([textField isEqual:self.surnameField]) {
        [self.emailField becomeFirstResponder];
    }
    else if ([textField isEqual:self.emailField]) {
        [self.passwordField becomeFirstResponder];
    }
    else if ([textField isEqual:self.passwordField]) {
        [self.companyField becomeFirstResponder];
    }
    else if ([textField isEqual:self.companyField]) {
        [self.streetField becomeFirstResponder];
    }
    else if ([textField isEqual:self.streetField]) {
        [self.street2Field becomeFirstResponder];
    }
    else if ([textField isEqual:self.street2Field]) {
        [self.suburbField becomeFirstResponder];
    }
    else if ([textField isEqual:self.suburbField]) {
        [self.stateField becomeFirstResponder];
    }
    else if ([textField isEqual:self.stateField]) {
        [self.postCodeField becomeFirstResponder];
    }
    else if ([textField isEqual:self.postCodeField]) {
        [self.countryField becomeFirstResponder];
    }
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    [self.infoValues replaceObjectAtIndex:textField.tag withObject:newString];
//    
//    return YES;
//}


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
    
    CGFloat scrollHeight;
    if (up) {
        scrollHeight = CGRectGetMaxY(self.tableFooterWrapper.frame) + CGRectGetHeight(keyboardBounds);
    }
    else {
        scrollHeight = CGRectGetMaxY(self.tableFooterWrapper.frame);
    }
    
    [UIView animateWithDuration:duration animations:^{
        CGPoint offset = self.profileTableView.contentOffset;
        CGFloat bottom = CGRectGetMaxY(self.curTextField.frame);
        
        NSLog(@"%@ : %@", NSStringFromCGRect(self.curTextField.frame), NSStringFromCGSize(self.profileTableView.contentSize));
        
        if (up) {
            if (bottom - offset.y + CGRectGetHeight(keyboardBounds) + 10.f > CGRectGetHeight(self.profileTableView.frame)) {
                offset.y = bottom - CGRectGetHeight(self.profileTableView.frame) + CGRectGetHeight(keyboardBounds) + 10.f;
            }
            
            [self.profileTableView setContentOffset:offset animated:NO];
        }
        
        self.profileTableView.contentSize = CGSizeMake(self.profileTableView.contentSize.width, scrollHeight);
    } completion:^(BOOL finished) {
        self.tableFooterWrapper.alpha = up;
        self.footerWrapper.alpha = !up;
    }];
}


- (void)loadCountry {
    
    NSString* countryCode = [[APIManager sharedManager] getUserDetails][key_address_country];
    
    GSCManager* gscManager = [GSCManager sharedManager];
    self.countryInfo = [gscManager getCountryInfo:countryCode];
    if (self.countryInfo)
        self.countryField.text = self.countryInfo[key_label];
    else {
        [gscManager loadCountriesWithSuccess:^{
            self.countryInfo = [gscManager getCountryInfo:countryCode];
            if (self.countryInfo)
                self.countryField.text = self.countryInfo[key_label];
        } failure:nil];
    }
}


@end
