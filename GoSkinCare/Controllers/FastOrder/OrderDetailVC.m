//
//  OrderDetailVC.m
//  GoSkinCare


#import "OrderDetailVC.h"
#import "UIViewController+SlideMenu.h"
#import "ProfileVC.h"
#import "OrderResultVC.h"

@implementation OrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

@end



@implementation OrderFooterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

@end



@implementation CardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

@end



@interface OrderDetailVC () <PayPalPaymentDelegate>

@property (weak, nonatomic) IBOutlet UIView* infoWrapper;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* infoLabel;
@property (weak, nonatomic) IBOutlet UIButton* changeButton;

@property (weak, nonatomic) IBOutlet UIView* orderWrapper;
@property (weak, nonatomic) IBOutlet UITableView* orderTableView;
@property (weak, nonatomic) IBOutlet UILabel* orderLabel;
@property (weak, nonatomic) IBOutlet UILabel* totalCostLabel;

@property (weak, nonatomic) IBOutlet UIView* optionWrapper;
@property (weak, nonatomic) IBOutlet UIView* expressWrapper;
@property (weak, nonatomic) IBOutlet UIView* giftWrapper;
@property (weak, nonatomic) IBOutlet UISwitch* expressSwitch;
@property (weak, nonatomic) IBOutlet UISwitch* giftSwitch;
@property (weak, nonatomic) IBOutlet UIButton* checkOutButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* orderWrapperHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* giftWrapperBottom;

@property (strong, nonatomic) NSString* orderId;
@property (strong, nonatomic) NSMutableDictionary* calcOrder;

@property (nonatomic, strong) PayPalConfiguration* payPalConfig;

@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self loadCreditCards];
    
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"Flydigital";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // set paypal environment
    //[PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self refreshOrderInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
    //    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = self.orderProducts.count + 1;
    if (section == 1)
        rowCount = [GSCManager sharedManager].creditCards.count;
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 30.f;
    if (indexPath.section == 1) {
        cellHeight = 45.f;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        OrderCell* cell = (OrderCell*)[tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
        
        if (indexPath.row == self.orderProducts.count) {
            cell.infoLabel.text = @"";
            if (self.calcOrder) {
                cell.infoLabel.text = self.calcOrder[key_shippingName];
                cell.costLabel.text = [NSString stringWithFormat:@"%@ %@", self.calcOrder[key_priceCurrencySymbol], self.calcOrder[key_shippingPrice]];
            }
            else {
                cell.infoLabel.text = @"";
                cell.costLabel.text = @"";
            }
        }
        else {
            NSMutableDictionary* orderProduct = self.orderProducts[indexPath.row];
            if (orderProduct) {
                cell.infoLabel.text = [NSString stringWithFormat:@"%ld x %@", [orderProduct[key_amount] integerValue], orderProduct[key_productName]];
                cell.costLabel.text = [NSString stringWithFormat:@"$%.2f", [orderProduct[key_itemPrice] doubleValue]];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    CardCell* cell = (CardCell*)[tableView dequeueReusableCellWithIdentifier:@"CardCell" forIndexPath:indexPath];
    
    if (indexPath.row < [GSCManager sharedManager].creditCards.count) {
        NSMutableDictionary* cardInfo = [GSCManager sharedManager].creditCards[indexPath.row];
        if (cardInfo) {
            cell.cardButton.tag = indexPath.row;
            [cell.cardButton setTitle:cardInfo[key_pan] forState:UIControlStateNormal];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat footerHeight = 0.f;
    if (section == 0)
        footerHeight = 80.f;
    
    return footerHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        OrderFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderFooterCell"];
        
        cell.infoLabel.text = @"Total";
        if (self.calcOrder)
            cell.costLabel.text = [NSString stringWithFormat:@"%@ %.2f", self.calcOrder[key_priceCurrencySymbol], [self.calcOrder[key_totalPrice] doubleValue]];
        
        return cell;
    }
    
    return nil;
}


#pragma mark -
#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowProfileVCModally]) {
        ProfileVC* vc = segue.destinationViewController;
        vc.profileSourceType = ProfileSourceType_OrderDetail;
        vc.isForMagicOrder = NO;
    }
    else if ([segue.identifier isEqualToString:Segue_ShowOrderResultVC]) {
        OrderResultVC* vc = segue.destinationViewController;
        vc.orderId = self.orderId;
    }
}


#pragma mark -
#pragma mark - Main methods

- (void)initUI {
    CGFloat maxHeight = ScreenBounds.size.height - CGRectGetMaxY(self.changeButton.frame) - 10.f - CGRectGetHeight(self.optionWrapper.frame) - 10.f - ScreenBounds.size.width * 64 / 256 - 15.f;
    CGFloat orderWrapperHeight = 25.f * (self.orderProducts.count + 1) + CGRectGetHeight(self.orderLabel.frame) + CGRectGetHeight(self.totalCostLabel.frame) + 15.f;
    self.orderWrapperHeight.constant = MIN(maxHeight, orderWrapperHeight);
    
    NSDictionary* userDetails = [[APIManager sharedManager] getUserDetails];
    if ([userDetails[key_address_country] isEqualToString:@"AU"]) {
        self.expressWrapper.alpha = 1.f;
        self.giftWrapperBottom.constant = 0.f;
    }
    else {
        self.expressWrapper.alpha = 0.f;
        self.giftWrapperBottom.constant = 20.f;
    }
}

- (void)refreshOrderInfo {
    self.nameLabel.text = [[APIManager sharedManager] formattedUserName];
    self.infoLabel.text = [[APIManager sharedManager] formattedAddress];
    
    if ([GSCManager sharedManager].creditCards != nil) {
        [self.orderTableView reloadData];
    }
}

- (IBAction)tapMenuButton:(UIButton*)sender {
    [[self mainSlideMenu] openLeftMenu];
}

- (IBAction)tapBackButton:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapChangeButton:(UIButton*)sender {
}

- (IBAction)switchChanged:(UISwitch*)sender {
    [self calculateOrder];
}

- (IBAction)tapEditCardsButton:(UIButton*)sender {
    
}

- (IBAction)tapPayNowButton:(UIButton*)sender {
    NSInteger index = sender.tag;
    
    if (index < [GSCManager sharedManager].creditCards.count) {
        NSMutableDictionary* cardInfo = [GSCManager sharedManager].creditCards[index];
        if (cardInfo) {
            NSString* cardId = cardInfo[key_cardid];
            NSLog(@"Pay Now with %@(%@)", cardId, cardInfo[key_pan]);
            
            [self placeIncompleteOrderWithCardId:cardId];
        }
    }
}

- (void)payNowWithCardId:(NSString*)cardId {
    
    [GoToProgressHUD showWithStatus:@"Processing..."];
    [[APIManager sharedManager] payByTokenWithOrderID:self.orderId cardId:cardId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* responseDict = responseObject;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (responseString) {
                responseString = [responseString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
            }
#if DEBUG
            NSLog(@"PayNowWithCardId response string : %@", responseString);
#endif
            responseDict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        }
        else {
#if DEBUG
            NSLog(@"PayNowWithCardId response : %@", responseObject);
#endif
        }
        
        [GoToProgressHUD dismiss];
        
        if (responseDict) {
            BOOL success = [responseDict[key_success] boolValue];
            if (success) {
                NSString* confirmedOrderId = responseDict[key_orderid];
                NSLog(@"OrderId = %@", confirmedOrderId);
                
                [self showResultVC:responseDict];
                return;
            }
        }
        
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //                [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:[error localizedDescription] parentVC:self okHandler:nil];
    }];
}

- (IBAction)tapCheckOutButton:(UIButton*)sender {
    
    sender.userInteractionEnabled = NO;
    
    [self placeIncompleteOrderWithCardId:nil];
}

- (IBAction)unwindToOrderDetailVC:(UIStoryboardSegue*)segue {
    [self refreshOrderInfo];
}

- (NSMutableArray*)getOrderItems {
    NSMutableArray* orderItems = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary* orderProduct in self.orderProducts) {
        NSDictionary* orderItem = @{key_productId: orderProduct[key_productId],
                                    key_amount: orderProduct[key_amount],
                                    key_sku: orderProduct[key_productId]
                                    };
        [orderItems addObject:orderItem];
    }
    return orderItems;
}

- (void)loadCreditCards {
    
    [GoToProgressHUD showWithStatus:@"Loading..."];
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
                
                
                [self calculateOrder];
                
                return;
            }
        }
        
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GoToProgressHUD dismiss];
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:[error localizedDescription] parentVC:self okHandler:nil];
    }];
}

- (void)calculateOrder {
    if (self.orderProducts && self.orderProducts.count > 0) {
        NSMutableDictionary* orderInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [orderInfo setObject:[self getOrderItems] forKey:key_items];
        [orderInfo setObject:@(self.expressSwitch.on) forKey:key_sendExpress];
        [orderInfo setObject:@(self.giftSwitch.on) forKey:key_isGift];
        [orderInfo setObject:[[APIManager sharedManager] getUserDetails][key_address_country] forKey:key_countryCode];
        
//        [SVProgressHUD showWithStatus:@"Calculating..."];
        [GoToProgressHUD showWithStatus:@"Calculating..."];
        [[APIManager sharedManager] calculateOrderPriceWithOrder:@{key_order: orderInfo} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* responseDict = responseObject;
            if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if (responseString) {
                    responseString = [responseString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
                }
#if DEBUG
                NSLog(@"CalculatorOrder response string : %@", responseString);
#endif
                responseDict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            }
            else {
#if DEBUG
                NSLog(@"CalculatorOrder response : %@", responseObject);
#endif
            }
            
//            [SVProgressHUD dismiss];
            [GoToProgressHUD dismiss];
            
            if (responseDict) {
                BOOL success = [responseDict[key_success] boolValue];
                if (success) {
                    self.calcOrder = [NSMutableDictionary dictionaryWithDictionary:responseDict[key_order]];
                    for (int i = 0; i < self.orderProducts.count; i ++) {
                        NSMutableDictionary* orderProduct = self.orderProducts[i];
                        if (orderProduct) {
                            NSDictionary* calculatedProduct = [self getCalculatedOrderProductWith:orderProduct[key_productId]];
                            [orderProduct addEntriesFromDictionary:calculatedProduct];
                        }
                    }
                    
                    self.totalCostLabel.text = [NSString stringWithFormat:@"%@ %.2f", self.calcOrder[key_priceCurrencySymbol], [self.calcOrder[key_totalPrice] doubleValue]];
                    [self.orderTableView reloadData];
                    return;
                }
            }
            
            [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [SVProgressHUD dismiss];
            [GoToProgressHUD dismiss];
            [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:[error localizedDescription] parentVC:self okHandler:nil];
        }];
    }
}

- (NSMutableDictionary*)getOrderProductWith:(NSString*)productId {
    for (NSMutableDictionary* orderProduct in self.orderProducts) {
        if ([orderProduct[key_productId] isEqualToString:productId])
            return orderProduct;
    }
    return nil;
}

- (NSDictionary*)getCalculatedOrderProductWith:(NSString*)productId {
    for (NSDictionary* calculatedProduct in self.calcOrder[key_items]) {
        if ([calculatedProduct[key_productId] isEqualToString:productId])
            return calculatedProduct;
    }
    return nil;
}

- (void)placeIncompleteOrderWithCardId:(NSString*)cardId {
    if (self.orderProducts && self.orderProducts.count > 0) {
        NSDictionary* userDetails = [[APIManager sharedManager] getUserDetails];
        NSMutableDictionary* orderInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [orderInfo setObject:[self getOrderItems] forKey:key_items];
        [orderInfo setObject:self.calcOrder[key_shippingCode] forKey:key_shippingCode];
        [orderInfo setObject:self.calcOrder[key_shippingPrice] forKey:key_shippingPrice];
        [orderInfo setObject:self.calcOrder[key_shippingName] forKey:key_shippingName];
        [orderInfo setObject:self.calcOrder[key_totalPrice] forKey:key_totalPrice];
        [orderInfo setObject:@(self.expressSwitch.on) forKey:key_sendExpress];
        [orderInfo setObject:@(self.giftSwitch.on) forKey:key_isGift];
        [orderInfo setObject:userDetails[key_userId] forKey:key_userId];
        [orderInfo setObject:userDetails[key_address_street] forKey:key_address_street];
        [orderInfo setObject:userDetails[key_address_street_2] forKey:key_address_street_2];
        [orderInfo setObject:userDetails[key_address_state] forKey:key_address_state];
        [orderInfo setObject:userDetails[key_address_suburb] forKey:key_address_suburb];
        [orderInfo setObject:userDetails[key_address_country] forKey:key_address_country];
        [orderInfo setObject:userDetails[key_address_postcode] forKey:key_address_postcode];
        [orderInfo setObject:@"" forKey:key_payPal_reference];
        [orderInfo setObject:[[APIManager sharedManager] formattedUserName] forKey:key_address_to];
        
        
//        [SVProgressHUD showWithStatus:@"Preparing..."];
        [GoToProgressHUD showWithStatus:@"Preparing..."];
        [[APIManager sharedManager] placeIncompleteOrderWithOrder:@{key_order: orderInfo} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* responseDict = responseObject;
            if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if (responseString) {
                    responseString = [responseString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
                }
#if DEBUG
                NSLog(@"IncompleteOrder response string : %@", responseString);
#endif
                responseDict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            }
            else {
#if DEBUG
                NSLog(@"IncompleteOrder response : %@", responseObject);
#endif
            }
            
//            [SVProgressHUD dismiss];
            [GoToProgressHUD dismiss];
            if (self.checkOutButton)
                self.checkOutButton.userInteractionEnabled = YES;
            
            if (responseDict) {
                BOOL success = [responseDict[key_success] boolValue];
                if (success) {
                    self.orderId = responseDict[key_orderid];
                    if (self.orderId) {
                        if (cardId) {
                            [self payNowWithCardId:cardId];
                        }
                        else {
                            [self doPay];
                        }
                        return;
                    }
                }
            }
            
            [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [SVProgressHUD dismiss];
            [GoToProgressHUD dismiss];
            [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:[error localizedDescription] parentVC:self okHandler:nil];
        }];
    }
}

- (void)confirmOrder:(PayPalPayment*)payment {
    if (self.orderId && payment && payment.confirmation) {
        NSString* paypalReference = payment.confirmation[key_response][key_id];
        if (paypalReference) {
//            [SVProgressHUD showWithStatus:@"Uploading..."];
            [GoToProgressHUD showWithStatus:@"Uploading..."];
            [[APIManager sharedManager] confirmOrderWithOrderID:self.orderId paypalReference:paypalReference success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary* responseDict = responseObject;
                if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                    NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    if (responseString) {
                        responseString = [responseString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
                    }
#if DEBUG
                    NSLog(@"ConfirmOrder response string : %@", responseString);
#endif
                    responseDict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                }
                else {
#if DEBUG
                    NSLog(@"ConfirmOrder response : %@", responseObject);
#endif
                }
                
//                [SVProgressHUD dismiss];
                [GoToProgressHUD dismiss];
                if (self.checkOutButton)
                    self.checkOutButton.userInteractionEnabled = YES;
                
                if (responseDict) {
                    BOOL success = [responseDict[key_success] boolValue];
                    if (success) {
                        NSString* confirmedOrderId = responseDict[key_orderid];
                        
                        [self showResultVC:responseDict];
                        return;
                    }
                }
                
                [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:nil];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [SVProgressHUD dismiss];
                [GoToProgressHUD dismiss];
                [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:[error localizedDescription] parentVC:self okHandler:nil];
            }];
        }
    }
}

- (void)placeOrder {
    if (self.orderProducts && self.orderProducts.count > 0) {
        NSMutableArray* orderItems = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary* orderProduct in self.orderProducts) {
            NSDictionary* item = @{key_productId: orderProduct[key_productId],
                                        key_amount: orderProduct[key_amount]
                                        };
            [orderItems addObject:item];
        }
        
        NSMutableDictionary* orderInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [orderInfo setObject:orderItems forKey:key_items];
        [orderInfo setObject:@(self.expressSwitch.on) forKey:key_sendExpress];
        [orderInfo setObject:@(self.giftSwitch.on) forKey:key_isGift];
        
//        [SVProgressHUD showWithStatus:@"Uploading..."];
        [GoToProgressHUD showWithStatus:@"Uploading..."];
        [[APIManager sharedManager] placeOrderPriceWithOrder:@{key_order: orderInfo} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* responseDict = responseObject;
            if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if (responseString) {
                    responseString = [responseString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
                }
#if DEBUG
                NSLog(@"PlaceOrder response string : %@", responseString);
#endif
                responseDict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            }
            else {
#if DEBUG
                NSLog(@"PlaceOrder response : %@", responseObject);
#endif
            }
            
//            [SVProgressHUD dismiss];
            [GoToProgressHUD dismiss];
            
            if (responseDict) {
                BOOL success = [responseDict[key_success] boolValue];
                if (success) {
                    NSDictionary* placedOrder = responseDict[key_order];
                    [self performSegueWithIdentifier:Segue_ShowOrderResultVC sender:placedOrder];
                    
                    return;
                }
            }
            
            [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [SVProgressHUD dismiss];
            [GoToProgressHUD dismiss];
            [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:[error localizedDescription] parentVC:self okHandler:nil];
        }];
    }
}

- (void)showResultVC:(NSDictionary*)order {
    [self performSegueWithIdentifier:Segue_ShowOrderResultVC sender:self.orderId];
}

- (void)doPay {
    
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:0];
    
    NSString* currency = self.calcOrder[key_priceCurrencySymbol];
    
    for (NSDictionary* order in self.orderProducts) {
        PayPalItem* paypalItem = [PayPalItem itemWithName:order[key_productName]
                                             withQuantity:[order[key_amount] integerValue]
                                                withPrice:[[NSDecimalNumber alloc] initWithString:order[key_price]]
                                             withCurrency:order[key_priceCurrency]
                                                  withSku:order[key_productId]];
        [items addObject:paypalItem];
        
        currency = order[key_priceCurrency];
    }
    
//    NSDecimalNumber* productsPrice = [[NSDecimalNumber alloc] initWithString:self.calculateResult[key_productsPrice]];
    NSDecimalNumber* productsPrice = [PayPalItem totalPriceForItems:items];
    if (productsPrice.doubleValue <= 0.f)
        return;
    
    NSDecimalNumber* shippingPrice = [[NSDecimalNumber alloc] initWithString:self.calcOrder[key_shippingPrice]];
    NSDecimalNumber* totalPrice = [[NSDecimalNumber alloc] initWithString:self.calcOrder[key_totalPrice]];
    totalPrice = [productsPrice decimalNumberByAdding:shippingPrice];
    
    PayPalPaymentDetails* paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:productsPrice
                                                                               withShipping:shippingPrice
                                                                                    withTax:nil];
    
    PayPalPayment* payment = [[PayPalPayment alloc] init];
    payment.amount = totalPrice;
    payment.currencyCode = currency;
    payment.shortDescription = @"Go-To";
    payment.items = items;
    payment.paymentDetails = paymentDetails;
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}


#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    
    // Payment was processed successfully;
    [self dismissViewControllerAnimated:YES completion:^{
        [self sendCompletedPaymentToServer:completedPayment]; // send to server for verification and fulfillment
    }];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    
    [self confirmOrder:completedPayment];
}


@end
