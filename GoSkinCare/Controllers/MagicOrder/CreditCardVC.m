//
//  CreditCardVC.m
//  GoSkinCare


#import "CreditCardVC.h"
#import "MagicOrderVC.h"


@implementation CreditCardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end



@interface CreditCardVC ()

@property (weak, nonatomic) IBOutlet UIView* topBarBorderView;
@property (weak, nonatomic) IBOutlet UITableView* cardTableView;
@property (weak, nonatomic) IBOutlet UIView* bottomWrapper;
@property (weak, nonatomic) IBOutlet UIView* addCardWrapper;
@property (weak, nonatomic) IBOutlet UITextField* noField;
@property (weak, nonatomic) IBOutlet UITextField* cscField;
@property (weak, nonatomic) IBOutlet UIButton* monthButton;
@property (weak, nonatomic) IBOutlet UIButton* yearButton;

@property (weak, nonatomic) IBOutlet UIView* monthPickerWrapper;
@property (weak, nonatomic) IBOutlet UIPickerView* monthPickerView;
@property (weak, nonatomic) IBOutlet UIView* yearPickerWrapper;
@property (weak, nonatomic) IBOutlet UIPickerView* yearPickerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* topBarTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* topBarBorderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* cardTableViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* addWrapperTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* monthPickerWrapperBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* yearPickerWrapperBottom;

@property (strong, nonatomic) UITextField* curTextField;

@property (strong, nonatomic) NSMutableArray* allMonths;
@property (strong, nonatomic) NSMutableArray* allYears;

@property (strong, nonatomic) NSIndexPath* selectedCardIndexPath;

@property (nonatomic) BOOL noAnimate;

@end

@implementation CreditCardVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
    self.selectedCardIndexPath = [GSCManager sharedManager].favouriteCardIndexPath;
    
    [self getAllMonths];
    
    [self initUI];
    
    [self updateConstraints];
}

- (void)updateConstraints {
    NSInteger cardCount = [GSCManager sharedManager].creditCards.count;
    CGFloat bottomWrapperTop = 70.f + cardCount * 40.f;
    CGFloat minBottomWrapperHeight = CGRectGetWidth(ScreenBounds) * (156.f + 94.f) / 375.f + 152.f + 10.f;
    CGFloat bottomWrapperHeight = fmax(CGRectGetHeight(ScreenBounds) - 64.f - 70.f - cardCount * 40.f, minBottomWrapperHeight);
    self.bottomWrapper.frame = CGRectMake(0.f, bottomWrapperTop, ScreenBounds.size.width, bottomWrapperHeight);
    
    if (bottomWrapperHeight > minBottomWrapperHeight) {
        CGFloat constant = bottomWrapperHeight - minBottomWrapperHeight;
        self.addWrapperTop.constant = constant;
    }
    
    CGFloat bottomWrapperBottom = CGRectGetMaxY(self.bottomWrapper.frame);
    if (bottomWrapperBottom > CGRectGetHeight(self.view.frame))
        self.cardTableView.contentSize = CGSizeMake(ScreenBounds.size.width, CGRectGetMaxY(self.bottomWrapper.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark -Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GSCManager sharedManager].creditCards.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreditCardCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CreditCardCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSMutableDictionary* cardInfo = [GSCManager sharedManager].creditCards[indexPath.row];
    if (cardInfo) {
        cell.optionButton.tag = indexPath.row;
        cell.cardNumberLabel.text = cardInfo[key_pan];
        
        if (indexPath.row == [GSCManager sharedManager].favouriteCardIndexPath.row) {
            cell.cardNumberLabel.text = [cardInfo[key_pan] stringByAppendingString:@" (favourite)"];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.optionButton.selected = [indexPath isEqual:self.selectedCardIndexPath];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCardIndexPath = indexPath;
    [tableView reloadData];
}


#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark -
#pragma mark - Main methods

- (void)getAllMonths {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSDate* today = [NSDate date];
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents* yearComponents  = [currentCalendar components:NSCalendarUnitYear  fromDate:today];
    NSInteger currentYear = [yearComponents year];
    
    self.allMonths = [NSMutableArray arrayWithArray:[dateFormatter monthSymbols]];
    self.allYears = [NSMutableArray arrayWithCapacity:0];
    for (int year = 0; year < 20; year ++) {
        [self.allYears addObject:[NSString stringWithFormat:@"%ld", (currentYear + year)]];
    }
}

- (void)initUI {
    self.topBarTop.constant = self.showModally ? 20.f : -44.f;
    self.topBarBorderHeight.constant = 0.5f;
    self.topBarBorderView.alpha = self.showModally ? 1.f : 0.f;
    
    self.monthPickerWrapperBottom.constant = -CGRectGetHeight(self.monthPickerWrapper.frame);
    self.yearPickerWrapperBottom.constant = -CGRectGetHeight(self.yearPickerWrapper.frame);
}

- (IBAction)tapFavoriteButton:(id)sender {
    [self favoriteCreditCard];
}

- (IBAction)tapDeleteButton:(id)sender {
    [self deleteCreditCard];
}

- (IBAction)tapAddButton:(id)sender {
    [self addCreditCard];
}

- (IBAction)tapMonthButton:(id)sender {
    if (self.cardTableViewBottom.constant != 0) {
        self.noAnimate = YES;
    }
    [self resignInfoFields];
    [self showMonthPickerWrapper:@YES];
    
}

- (IBAction)tapYearButton:(id)sender {
    if (self.cardTableViewBottom.constant != 0) {
        self.noAnimate = YES;
    }
    
    [self resignInfoFields];
    [self showYearPickerWrapper:@YES];
}

- (IBAction)tapMonthDoneButton:(id)sender {
    [self showMonthPickerWrapper:@NO];
    
    [self updateMonthButton];
}

- (IBAction)tapYearDoneButton:(id)sender {
    [self showYearPickerWrapper:@NO];
    
    [self updateYearButton];
}

- (void)showMonthPickerWrapper:(NSNumber*)showNumber {
    if (showNumber.boolValue) {
        [self.view bringSubviewToFront:self.monthPickerWrapper];
        [self updateMonthPickerView];
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        self.yearPickerWrapperBottom.constant = -self.yearPickerWrapper.frame.size.height;
        self.monthPickerWrapperBottom.constant = showNumber.boolValue ? 0.f : -self.monthPickerWrapper.frame.size.height;
        
        if (showNumber.boolValue) {
            self.cardTableViewBottom.constant = self.monthPickerWrapper.frame.size.height;
            self.cardTableView.contentOffset = CGPointMake(0.f, fmax(self.cardTableView.contentSize.height - (CGRectGetHeight(ScreenBounds) - 64.f - CGRectGetHeight(self.monthPickerWrapper.frame)), 0.f));
        }
        else
            self.cardTableViewBottom.constant = 0.f;
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (!showNumber.boolValue)
            [self.view sendSubviewToBack:self.monthPickerWrapper];
    }];
}

- (void)updateMonthPickerView {
    NSString* month = [self.monthButton titleForState:UIControlStateNormal];
    if (month) {
        [self.monthPickerView selectRow:0 inComponent:0 animated:NO];
        for (NSInteger index = 0; index < self.allMonths.count; index ++) {
            NSString* monthString = [self.allMonths objectAtIndex:index];
            if ([monthString hasPrefix:month]) {
                [self.monthPickerView selectRow:index inComponent:0 animated:NO];
            }
        }
    }
}

- (void)updateMonthButton {
    NSInteger row = [self.monthPickerView selectedRowInComponent:0];
    if (row < 0)
        row = 0;
    
    if (self.allMonths.count > row) {
        NSString* month = self.allMonths[row];
        [self.monthButton setTitle:[month substringToIndex:3] forState:UIControlStateNormal];
    }
}

- (void)showYearPickerWrapper:(NSNumber*)showNumber {
    if (showNumber.boolValue) {
        [self.view bringSubviewToFront:self.yearPickerWrapper];
        [self updateYearPickerView];
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        self.monthPickerWrapperBottom.constant = -self.monthPickerWrapper.frame.size.height;
        self.yearPickerWrapperBottom.constant = showNumber.boolValue ? 0.f : -self.yearPickerWrapper.frame.size.height;
        
        if (showNumber.boolValue) {
            self.cardTableViewBottom.constant = self.monthPickerWrapper.frame.size.height;
            self.cardTableView.contentOffset = CGPointMake(0.f, fmax(self.cardTableView.contentSize.height - (CGRectGetHeight(ScreenBounds) - 64.f - CGRectGetHeight(self.yearPickerWrapper.frame)), 0.f));
        }
        else
            self.cardTableViewBottom.constant = 0.f;
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (!showNumber.boolValue)
            [self.view sendSubviewToBack:self.yearPickerWrapper];
    }];
}

- (void)updateYearPickerView {
    NSString* year = [self.yearButton titleForState:UIControlStateNormal];
    if (year) {
        NSInteger index = [self.allYears indexOfObject:year];
        if (index < 0)
            index = 0;
        
        [self.yearPickerView selectRow:index inComponent:0 animated:NO];
    }
}

- (void)updateYearButton {
    NSInteger row = [self.yearPickerView selectedRowInComponent:0];
    if (row < 0)
        row = 0;
    
    if (self.allYears.count > row) {
        NSString* year = self.allYears[row];
        [self.yearButton setTitle:year forState:UIControlStateNormal];
    }
}

- (IBAction)resignInfoFields {
    [self.noField resignFirstResponder];
    [self.cscField resignFirstResponder];
}

- (void)favoriteCreditCard {
    [self resignInfoFields];
    
    if ([GSCManager sharedManager].creditCards.count < 1)
        return;
    
    NSMutableDictionary* cardInfo = [GSCManager sharedManager].creditCards[self.selectedCardIndexPath.row];
    if (cardInfo) {
        NSString* cardId = cardInfo[key_cardid];
        
        [GoToProgressHUD showWithStatus:@"Working..."];
        [[APIManager sharedManager] makeFavouriteCreditCardWithCardId:cardId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* responseDict = responseObject;
            if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
                NSLog(@"FavoriteCreditCard response string : %@", responseString);
#endif
                responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            }
            else {
#if DEBUG
                NSLog(@"FavoriteCreditCard response : %@", responseObject);
#endif
            }
            
            [GoToProgressHUD dismiss];
            
            if (responseDict) {
                BOOL success = [responseDict[key_success] boolValue];
                if (success) {
                    
                    [GSCManager sharedManager].favouriteCardIndexPath = self.selectedCardIndexPath;
                    
                    [self.cardTableView reloadData];
                    
                    [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:nil];
                    
                    return;
                }
            }
            
            [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GoToProgressHUD dismiss];
            [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:[error localizedDescription] parentVC:self okHandler:nil];
        }];
    }
}

- (void)deleteCreditCard {
    [self resignInfoFields];
    
    if ([GSCManager sharedManager].creditCards.count < 1)
        return;
    
    NSMutableDictionary* cardInfo = [GSCManager sharedManager].creditCards[self.selectedCardIndexPath.row];
    if (cardInfo) {
        NSString* cardId = cardInfo[key_cardid];
        NSString* pan = cardInfo[key_pan];
        
        [GoToProgressHUD showWithStatus:@"Deleting..."];
        [[APIManager sharedManager] deleteCreditCardWithCardId:cardId pan:pan success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* responseDict = responseObject;
            if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
                NSLog(@"DeleteCreditCard response string : %@", responseString);
#endif
                responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            }
            else {
#if DEBUG
                NSLog(@"DeleteCreditCard response : %@", responseObject);
#endif
            }
            
            [GoToProgressHUD dismiss];
            
            if (responseDict) {
                BOOL success = [responseDict[key_success] boolValue];
                if (success) {
                    /*
                    [[GSCManager sharedManager].creditCards removeObjectAtIndex:self.selectedCardIndexPath.row];
                    
                    if (self.selectedCardIndexPath.row == [GSCManager sharedManager].favouriteCardIndexPath.row) {
                        if ([GSCManager sharedManager].creditCards.count > 0)
                            [GSCManager sharedManager].favouriteCardIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        else
                            [GSCManager sharedManager].favouriteCardIndexPath = nil;
                    }
                    self.selectedCardIndexPath = [GSCManager sharedManager].favouriteCardIndexPath;
                    
                    [self.cardTableView reloadData];
                    
                    [self updateConstraints];
                    */
                    
                    [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:^{
                        [self loadCreditCards];
                    }];
                    
                    return;
                }
            }
            
            [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [GoToProgressHUD dismiss];
            [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:[error localizedDescription] parentVC:self okHandler:nil];
        }];
    }
}

- (void)addCreditCard {
    [self resignInfoFields];
    
    NSString* cardNumber = self.noField.text;
    if (!cardNumber || cardNumber.length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:@"Please type your card number" parentVC:self okHandler:nil];
        return;
    }
    
    NSString* csc = self.cscField.text;
    if (!csc || csc.length < 1) {
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:@"Please type CSC" parentVC:self okHandler:nil];
        return;
    }
    
    NSString* expMonth = @"01";
    NSString* month = [self.monthButton titleForState:UIControlStateNormal];
    if (month) {
        for (NSInteger index = 0; index < self.allMonths.count; index ++) {
            NSString* monthString = [self.allMonths objectAtIndex:index];
            if ([monthString hasPrefix:month]) {
                expMonth = [NSString stringWithFormat:@"%02ld", index + 1];
            }
        }
    }
    NSString* expYear = [self.yearButton titleForState:UIControlStateNormal];
    expYear = [expYear substringFromIndex:2];
    
    [GoToProgressHUD showWithStatus:@"Adding..."];
    [[APIManager sharedManager] addCreditCardWithCardNumber:cardNumber expiryMonth:expMonth expiryYear:expYear success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseDict = responseObject;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
            NSLog(@"AddCreditCard response string : %@", responseString);
#endif
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        }
        else {
#if DEBUG
            NSLog(@"AddCreditCard response : %@", responseObject);
#endif
        }
        
        [GoToProgressHUD dismiss];
        
        if (responseDict) {
            BOOL success = [responseDict[key_success] boolValue];
            if (success) {
                [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:^{
                    [self loadCreditCards];
                }];
                
                return;
            }
        }
        
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GoToProgressHUD dismiss];
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:[error localizedDescription] parentVC:self okHandler:nil];
    }];
}

- (void)loadCreditCards {
    
    [GoToProgressHUD showWithStatus:@"Reloading..."];
    [[APIManager sharedManager] getCreditCardListWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseDict = responseObject;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
            NSLog(@"GetCreditCards response string : %@", responseString);
#endif
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        }
        else {
#if DEBUG
            NSLog(@"GetCreditCards response : %@", responseObject);
#endif
        }
        
        [GoToProgressHUD dismiss];
        
        if (responseDict) {
            BOOL success = [responseDict[key_success] boolValue];
            if (success) {
                [GSCManager sharedManager].creditCards = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < [responseDict[key_cards] count]; i ++) {
                    NSMutableDictionary* cardInfo = [NSMutableDictionary dictionaryWithDictionary:responseDict[key_cards][i]];
                    if (cardInfo) {
                        if (cardInfo[key_favourite] && [cardInfo[key_favourite] integerValue] == 1)
                            [GSCManager sharedManager].favouriteCardIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        [[GSCManager sharedManager].creditCards addObject:cardInfo];
                    }
                }
                
                if ([GSCManager sharedManager].creditCards.count == 1)
                    [GSCManager sharedManager].favouriteCardIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                
                self.selectedCardIndexPath = [GSCManager sharedManager].favouriteCardIndexPath;
                
                [self.cardTableView reloadData];
                
                [self updateConstraints];
                
                return;
            }
        }
        
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:[error localizedDescription] parentVC:self okHandler:nil];
    }];
}


#pragma mark -
#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:self.monthPickerView])
        return self.allMonths.count;
    else if ([pickerView isEqual:self.yearPickerView])
        return self.allYears.count;
    
    return 0;
}


#pragma mark -
#pragma mark - UIPickerView delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:self.monthPickerView]) {
        if (self.allMonths.count > row) {
            return self.allMonths[row];
        }
    }
    else if ([pickerView isEqual:self.yearPickerView]) {
        if (self.allYears.count > row) {
            return self.allYears[row];
        }
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%@", @(row));
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
    return YES;
}


#pragma mark -
#pragma mark - Keyboard delegate

- (void)keyboardWillShow:(NSNotification*)notif {
    if (self.noAnimate) {
        self.noAnimate = NO;
    }
    
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [self animateTextFieldUp:YES duration:(CGFloat)duration.floatValue keyboardBounds:keyboardBounds];
}

- (void)keyboardWillHide:(NSNotification*)notif {
    if (self.noAnimate) {
        self.noAnimate = NO;
        return;
    }
    
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [self animateTextFieldUp:NO duration:(CGFloat)duration.floatValue keyboardBounds:keyboardBounds];
}

- (void)animateTextFieldUp:(BOOL)up duration:(CGFloat)duration keyboardBounds:(CGRect)keyboardBounds {
    NSLog(@"%@ : %f", NSStringFromCGRect(self.curTextField.frame), self.cardTableViewBottom.constant);
    
    self.monthPickerWrapperBottom.constant = -self.monthPickerWrapper.frame.size.height;
    self.yearPickerWrapperBottom.constant = -self.yearPickerWrapper.frame.size.height;
    
    if (up)
        self.cardTableViewBottom.constant = keyboardBounds.size.height;
    else
        self.cardTableViewBottom.constant = 0.f;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}


@end
