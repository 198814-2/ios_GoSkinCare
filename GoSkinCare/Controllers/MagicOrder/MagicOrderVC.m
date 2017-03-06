//
//  MagicOrderVC.m
//  GoSkinCare


#import "MagicOrderVC.h"
#import "UIViewController+SlideMenu.h"
#import "ProfileVC.h"
#import "CreditCardVC.h"


@implementation MagicOrderCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    if (selected) {
        self.nameLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
        self.priceLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
    }
    else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.priceLabel.textColor = [UIColor blackColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    /*
    if (highlighted) {
        self.nameLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
        self.priceLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
    }
    else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.priceLabel.textColor = [UIColor blackColor];
    }
    */
}

@end



@implementation MagicInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end



@interface MagicOrderVC ()

@property (weak, nonatomic) IBOutlet UITableView* magicTableView;
@property (weak, nonatomic) IBOutlet UIView* topWrapper;
@property (weak, nonatomic) IBOutlet UIView* sendToWrapper;
@property (weak, nonatomic) IBOutlet UIView* sendToBorderView;
@property (weak, nonatomic) IBOutlet UILabel* sendToAddressLabel;
@property (weak, nonatomic) IBOutlet UIView* payWithWrapper;
@property (weak, nonatomic) IBOutlet UIView* payWithBorderView;
@property (weak, nonatomic) IBOutlet UITableView* cardTableView;

@property (weak, nonatomic) IBOutlet UIView* frequencyWrapper;
@property (weak, nonatomic) IBOutlet UIPickerView* frequencyPickerView;

@property (weak, nonatomic) IBOutlet UIView* nextOrderWrapper;
@property (weak, nonatomic) IBOutlet UIDatePicker* nextOrderDatePicker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* sendToWrapperHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* payWithWrapperHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* frequencyWrapperTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* nextOrderWrapperTop;

@property (strong, nonatomic) UIView* thumbBgWrapper;
@property (strong, nonatomic) UIView* thumbWrapper;
@property (strong, nonatomic) UIImageView* thumbImageView;

@property (strong, nonatomic) NSMutableArray* magicOrders;

@end

@implementation MagicOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initUI];
    
    [self loadCreditCards];
    
    
    // track GA
    [UtilManager trackingScreenView:GA_SCREENNAME_MAGIC_ORDER];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.cardTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.cardTableView])
        return [GSCManager sharedManager].creditCards.count;
    
    return self.magicOrders.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 180.f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.cardTableView]) {
//        if ([GSCManager sharedManager].creditCards.count < 2)
//            return 80.f;
        return 60.f;
    }
    
    NSDictionary* product = [self.magicOrders objectAtIndex:indexPath.row];
    CGFloat cellHeight = 110.f + [self getDetailHeight:product[key_detail]];
    cellHeight = 180.f;
    
    return cellHeight;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    MagicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MagicInfoCell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.cardTableView]) {
        MagicInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MagicInfoCell" forIndexPath:indexPath];
        
        NSMutableDictionary* cardInfo = [GSCManager sharedManager].creditCards[[GSCManager sharedManager].favouriteCardIndexPath.row];
        if (cardInfo) {
            cell.cardNumberLabel.text = cardInfo[key_pan];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    
    MagicOrderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MagicOrderCell" forIndexPath:indexPath];
    
    NSMutableDictionary* productInfo = self.magicOrders[indexPath.row];
    if (productInfo) {
        cell.frequencyButton.tag = indexPath.row;
        cell.editButton.tag = indexPath.row;
        cell.nameLabel.text = productInfo[key_name];
        cell.priceLabel.text = [NSString stringWithFormat:@"%@%@",
                                productInfo[key_priceCurrencySymbol] ? productInfo[key_priceCurrencySymbol] : @"$",
                                @([productInfo[key_price] doubleValue])];
        cell.nextOrderLabel.text = [NSString stringWithFormat:@"Next Order: Never"];
        
        NSInteger frequencyIndex = [productInfo[key_frequency] integerValue];
        if (frequencyIndex < 0)
            frequencyIndex = 0;
        
        if (Frequencies.count > frequencyIndex) {
            NSString* frequency = Frequencies[frequencyIndex];
            [cell.frequencyButton setTitle:frequency forState:UIControlStateNormal];
        }
        
        
        NSString* strNextOrderDate = productInfo[key_nextorderdate];
        NSDate* nextOrderDate = [UtilManager dateFromString:strNextOrderDate inFormat:@"yyyy-MM-dd"];
        if (nextOrderDate) {
            NSString* dateString = [UtilManager dateStringFromDate:nextOrderDate inFormat:@"dd MMMM"];
            if (dateString.length < 1)
                dateString = @"Never";
            cell.nextOrderLabel.text = [NSString stringWithFormat:@"Next Order: %@", dateString];
        }
        else {
            cell.nextOrderLabel.text = [NSString stringWithFormat:@"Next Order: Never"];
        }
        
        UIImage* placeholderImage = [UIImage imageNamed:@"AppIcon60x60@2x"];
        NSString* smallImageUrl = productInfo[key_imageUrlSmall];
        if (smallImageUrl) {
            [cell.activityIndicator startAnimating];
            [cell.productImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:smallImageUrl]] placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                cell.productImageView.image = image;
                [cell.activityIndicator stopAnimating];
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                [cell.activityIndicator stopAnimating];
            }];
        }
        
        cell.thumbButton.tag = indexPath.row;
        [cell.thumbButton addTarget:self action:@selector(tapThumbButton:) forControlEvents:UIControlEventTouchUpInside];
    }

    return cell;
}

- (CGFloat)getDetailHeight:(NSString*)detail {
    
    CGFloat width = ScreenBounds.size.width - 115.f - ScreenBounds.size.width * 30.f / 375.f;
    CGSize expectedSize = [detail boundingRectWithSize:CGSizeMake(width, 9999.f)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]}
                                               context:nil].size;
    
    return MAX(expectedSize.height + 15.f, 40.f);
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
    if ([tableView isEqual:self.cardTableView]) {
//        [GSCManager sharedManager].selectedCardIndexPath = indexPath;
//        [tableView reloadData];
    }
    else
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return Frequencies.count;
}


#pragma mark -
#pragma mark - UIPickerView delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (Frequencies.count > row) {
        return Frequencies[row];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%@", @(row));
}


#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowProfileVCModally]) {
        ProfileVC* vc = segue.destinationViewController;
        vc.profileSourceType = ProfileSourceType_OrderDetail;
        vc.isForMagicOrder = YES;
    }
    else if ([segue.identifier isEqualToString:Segue_ShowCreditCardVC]) {
        CreditCardVC* vc = segue.destinationViewController;
        vc.showModally = NO;
    }
    else if ([segue.identifier isEqualToString:Segue_ShowCreditCardVCModally]) {
        CreditCardVC* vc = segue.destinationViewController;
        vc.showModally = YES;
    }
}


#pragma mark -
#pragma mark - Main methods

- (void)initUI {
    [self initThumbWrappers];
    
    self.sendToBorderView.layer.borderColor = MainTintColor.CGColor;
    self.sendToBorderView.layer.borderWidth = 0.5f;
    self.payWithBorderView.layer.borderColor = MainTintColor.CGColor;
    self.payWithBorderView.layer.borderWidth = 0.5f;
    
    [self updateSendToConstraints];
    
    self.frequencyWrapperTop.constant = ScreenBounds.size.height;
    self.nextOrderWrapperTop.constant = ScreenBounds.size.height;
}

- (void)initThumbWrappers {
    self.thumbBgWrapper = [[UIView alloc] initWithFrame:ScreenBounds];
    self.thumbBgWrapper.backgroundColor = [UIColor blackColor];
    self.thumbBgWrapper.alpha = 0.6f;
    [self.navigationController.view addSubview:self.thumbBgWrapper];
    [self.navigationController.view sendSubviewToBack:self.thumbBgWrapper];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideThumbWrapper)];
    [self.thumbBgWrapper addGestureRecognizer:tapGestureRecognizer];
    
    
    CGRect frame = CGRectMake(20.f, ScreenBounds.size.height - self.view.frame.size.height + 20.f, ScreenBounds.size.width - 40.f, self.view.frame.size.height - 40.f);
    self.thumbWrapper = [[UIView alloc] initWithFrame:frame];
    self.thumbWrapper.backgroundColor = [UIColor clearColor];
    self.thumbWrapper.userInteractionEnabled = NO;
    
    self.thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, frame.size.height)];
    self.thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.thumbWrapper addSubview:self.thumbImageView];
    
    [self.navigationController.view addSubview:self.thumbWrapper];
    [self.navigationController.view sendSubviewToBack:self.thumbWrapper];
}

- (void)updateSendToConstraints {
    
    NSString* formattedAddress = [[APIManager sharedManager] formattedAddress];
    self.sendToAddressLabel.text = formattedAddress;
    
    CGFloat width = ScreenBounds.size.width * 315.f / 375.f - 85.f;
    CGSize expectedSize = [formattedAddress boundingRectWithSize:CGSizeMake(width, 9999.f)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:self.sendToAddressLabel.font}
                                                         context:nil].size;
    CGFloat expectedHeight = fmax(40.f, expectedSize.height + 2.f);
    
    self.sendToWrapperHeight.constant = expectedHeight + 30.f + 30.f;
    [self.view layoutIfNeeded];
    
    CGRect topWrapperFrame = self.topWrapper.frame;
    topWrapperFrame.size.height = expectedHeight + 30.f + 30.f + self.payWithWrapperHeight.constant + 8.f;
    self.topWrapper.frame = topWrapperFrame;
    
}

- (IBAction)tapMenuButton:(UIButton*)sender {
    [[self mainSlideMenu] openLeftMenu];
}

- (IBAction)tapHelpButton:(UIButton*)sender {
    [self performSegueWithIdentifier:Segue_ShowMagicHelpVC sender:nil];
}

- (IBAction)tapSaveButton:(UIButton*)sender {
    [self addMagicOrder];
}

- (IBAction)tapEditButtonOfSendTo:(UIButton*)sender {
    
}

- (IBAction)tapEditButtonPayWith:(UIButton*)sender {
    [self performSegueWithIdentifier:Segue_ShowCreditCardVC sender:nil];
}

- (IBAction)tapFrequencyButton:(UIButton*)sender {
    self.frequencyWrapper.tag = sender.tag;
    
    [self showFrequencyWrapper:YES];
}

- (IBAction)tapFrequencyDoneButton:(id)sender {
    [self showFrequencyWrapper:NO];
    
    NSInteger row = [self.frequencyPickerView selectedRowInComponent:0];
    if (row < 0)
        row = 0;
    
    [self updateFrequencyButton:row orderIndex:self.frequencyWrapper.tag];
    
    if (row > 0) {
        NSMutableDictionary* productInfo = self.magicOrders[self.frequencyWrapper.tag];
        if (productInfo) {
            NSString* strNextOrderDate = productInfo[key_nextorderdate];
            NSDate* nextOrderDate = [UtilManager dateFromString:strNextOrderDate inFormat:@"yyyy-MM-dd"];
            
            if (nextOrderDate)
                return;
        }
        [self updateNextOrderLabel:[self getDateOfTomorrow] orderIndex:self.frequencyWrapper.tag];
    }
}

- (IBAction)tapEditDateButton:(UIButton*)sender {
    self.nextOrderWrapper.tag = sender.tag;
    
    [self showNextOrderWrapper:YES];
}

- (IBAction)tapNextOrderDoneButton:(id)sender {
    [self showNextOrderWrapper:NO];
    
    NSDate* nextOrderDate = self.nextOrderDatePicker.date;
    [self updateNextOrderLabel:nextOrderDate orderIndex:self.nextOrderWrapper.tag];
}

- (IBAction)tapNextOrderCancelButton:(id)sender {
    [self showNextOrderWrapper:NO];
    
    [self updateNextOrderLabel:nil orderIndex:self.nextOrderWrapper.tag];
    [self updateFrequencyButton:0 orderIndex:self.nextOrderWrapper.tag];
}

- (IBAction)unwindToMagicOrderVC:(UIStoryboardSegue*)segue {
    [self updateSendToConstraints];
}

- (IBAction)unwindToMagicOrderVCFromCreditCardVC:(UIStoryboardSegue*)segue {
    NSLog(@"HERE");
}

- (void)tapThumbButton:(UIButton*)thumbButton {
    [self showThumbWrapper:thumbButton.tag];
    [self loadThumbImage:thumbButton.tag];
}


#pragma mark -
#pragma mark - Thumbnail

- (void)hideThumbWrapper {
    NSInteger tag = self.thumbWrapper.tag;
    
    [GoToProgressHUD dismiss];
    
    [UIView animateWithDuration:0.25f animations:^{
        MagicOrderCell* cell = [self.magicTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
        if (cell) {
            CGRect frame = CGRectMake(cell.frame.origin.x + cell.thumbButton.frame.origin.x,
                                      cell.frame.origin.y + cell.thumbButton.frame.origin.y - self.magicTableView.contentOffset.y,
                                      cell.thumbButton.frame.size.width,
                                      cell.thumbButton.frame.size.height);
            
            self.thumbWrapper.frame = CGRectMake(CGRectGetMinX(frame),
                                                 CGRectGetMinY(frame) + ScreenBounds.size.height - CGRectGetHeight(self.view.frame),
                                                 CGRectGetWidth(frame),
                                                 CGRectGetHeight(frame));
            self.thumbImageView.frame = CGRectMake(0.f,
                                                   0.f,
                                                   CGRectGetWidth(self.thumbWrapper.frame),
                                                   CGRectGetHeight(self.thumbWrapper.frame));
            self.thumbImageView.image = cell.productImageView.image;
        }
        
        self.thumbBgWrapper.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.navigationController.view sendSubviewToBack:self.thumbWrapper];
        [self.navigationController.view sendSubviewToBack:self.thumbBgWrapper];
    }];
}

- (void)showThumbWrapper:(NSInteger)tag {
    self.thumbWrapper.tag = tag;
    
    CGRect frame = CGRectZero;
    
    MagicOrderCell* cell = [self.magicTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    if (cell) {
        frame = CGRectMake(cell.frame.origin.x + cell.thumbButton.frame.origin.x,
                           cell.frame.origin.y + cell.thumbButton.frame.origin.y - self.magicTableView.contentOffset.y,
                           cell.thumbButton.frame.size.width,
                           cell.thumbButton.frame.size.height);
        
        self.thumbWrapper.frame = CGRectMake(CGRectGetMinX(frame),
                                             CGRectGetMinY(frame) + ScreenBounds.size.height - CGRectGetHeight(self.view.frame),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
        self.thumbImageView.frame = CGRectMake(0.f,
                                               0.f,
                                               CGRectGetWidth(self.thumbWrapper.frame),
                                               CGRectGetHeight(self.thumbWrapper.frame));
        self.thumbImageView.image = cell.productImageView.image;
    }
    
    [self.navigationController.view bringSubviewToFront:self.thumbBgWrapper];
    [self.navigationController.view bringSubviewToFront:self.thumbWrapper];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.thumbBgWrapper.alpha = 0.6f;
        
        self.thumbWrapper.frame = CGRectMake(30.f,
                                             30.f + ScreenBounds.size.height - CGRectGetHeight(self.view.frame),
                                             CGRectGetWidth(self.view.frame) - 60.f,
                                             CGRectGetHeight(self.view.frame) - 60.f);
        self.thumbImageView.frame = CGRectMake(0.f,
                                               0.f,
                                               CGRectGetWidth(self.thumbWrapper.frame),
                                               CGRectGetHeight(self.thumbWrapper.frame));
        
    } completion:^(BOOL finished) {
    }];
}

- (void)loadThumbImage:(NSInteger)tag {
    if (self.magicOrders && self.magicOrders.count > tag) {
        NSDictionary* product = self.magicOrders[tag];
        if (product) {
            NSString* largeImageUrl = product[key_imageUrlLarge];
            if (largeImageUrl && largeImageUrl.length > 0) {
                
                __weak __typeof(self)weakSelf = self;
                
                [GoToProgressHUD showWithStatus:@"Loading..."];
                [self.thumbImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:largeImageUrl]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                    weakSelf.thumbImageView.image = image;
                    [GoToProgressHUD dismiss];
                } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                    [GoToProgressHUD dismiss];
                }];
            }
        }
    }
}


#pragma mark -
#pragma mark - Frequency

- (void)showFrequencyWrapper:(BOOL)show {
    if (show)
        [self updateFrequencyPickerView];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.frequencyWrapperTop.constant = show ? 0.f : self.frequencyWrapper.frame.size.height;
        [self.frequencyWrapper layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)updateFrequencyPickerView {
    NSMutableDictionary* productInfo = self.magicOrders[self.frequencyWrapper.tag];
    if (productInfo) {
        NSInteger frequencyIndex = [productInfo[key_frequency] integerValue];
        if (frequencyIndex < 0)
            frequencyIndex = 0;
        
        [self.frequencyPickerView selectRow:frequencyIndex inComponent:0 animated:NO];
    }
}

- (void)updateFrequencyButton:(NSInteger)row orderIndex:(NSInteger)orderIndex {
    if (Frequencies.count > row) {
        NSString* frequency = Frequencies[row];
        
        NSMutableDictionary* magicOrder = self.magicOrders[orderIndex];
        [magicOrder setObject:@(row) forKey:key_frequency];
        
        MagicOrderCell* cell = [self.magicTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:orderIndex inSection:0]];
        if (cell) {
            [cell.frequencyButton setTitle:frequency forState:UIControlStateNormal];
        }
    }
}


#pragma mark -
#pragma mark - Next Order

- (NSDate*)getDateOfTomorrow {
    NSDate* date = [NSDate date];
    NSDate* tomorrow = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
    return tomorrow;
}

- (void)showNextOrderWrapper:(BOOL)show {
    if (show)
        [self updateNextOrderDatePicker];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.nextOrderWrapperTop.constant = show ? 0.f : self.nextOrderWrapper.frame.size.height;
        [self.nextOrderWrapper layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)updateNextOrderDatePicker {
    NSMutableDictionary* productInfo = self.magicOrders[self.nextOrderWrapper.tag];
    if (productInfo) {
        NSString* strNextOrderDate = productInfo[key_nextorderdate];
        NSDate* nextOrderDate = [UtilManager dateFromString:strNextOrderDate inFormat:@"yyyy-MM-dd"];
        
        if (nextOrderDate)
            self.nextOrderDatePicker.date = nextOrderDate;
        else
            self.nextOrderDatePicker.date = [self getDateOfTomorrow];
    }
}

- (void)updateNextOrderLabel:(NSDate*)nextOrderDate orderIndex:(NSInteger)orderIndex {
    
    NSString* dateString = @"0000-00-00";
    if (nextOrderDate) {
        dateString = [UtilManager dateStringFromDate:nextOrderDate inFormat:@"yyyy-MM-dd"];
    }
    
    if (dateString.length < 1)
        dateString = @"0000-00-00";
    
    NSMutableDictionary* magicOrder = self.magicOrders[orderIndex];
    [magicOrder setObject:dateString forKey:key_nextorderdate];
    
    
    MagicOrderCell* cell = [self.magicTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:orderIndex inSection:0]];
    if (cell) {
        NSString* dateString = [UtilManager dateStringFromDate:nextOrderDate inFormat:@"dd MMMM"];
        if (dateString.length < 1)
            dateString = @"Never";
        cell.nextOrderLabel.text = [NSString stringWithFormat:@"Next Order: %@", dateString];
    }
}


#pragma mark -
#pragma mark - Load Magic orders

- (void)loadProducts {
    
//    [SVProgressHUD showWithStatus:@"Loading..."];
    [GoToProgressHUD showWithStatus:@"Loading..."];
    [[APIManager sharedManager] getProductListWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseDict = responseObject;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
            NSLog(@"GetProducts response string : %@", responseString);
#endif
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        }
        else {
#if DEBUG
            NSLog(@"GetProducts response : %@", responseObject);
#endif
        }
        
//        [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
        
        if (responseDict) {
            BOOL success = [responseDict[key_success] boolValue];
            if (success) {
                self.magicOrders = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < [responseDict[key_products] count]; i ++) {
                    NSMutableDictionary* productInfo = [NSMutableDictionary dictionaryWithDictionary:responseDict[key_products][i]];
                    if (productInfo) {
                        NSString* productId = productInfo[key_productId];
                        NSDictionary* magicOrderInfo = [[GSCManager sharedManager] getMagicOrderInfoWith:productId];
                        if (magicOrderInfo) {
                            NSInteger frequencyIndex = [magicOrderInfo[key_frequency] integerValue];
                            if (frequencyIndex < 0)
                                frequencyIndex = 0;
                            [productInfo setObject:@(frequencyIndex) forKey:key_frequency];
                            
                            
                            NSString* strNextOrderDate = magicOrderInfo[key_nextorderdate];
                            NSDate* nextOrderDate = [UtilManager dateFromString:strNextOrderDate inFormat:@"yyyy-MM-dd"];
                            if (nextOrderDate) {
                                [productInfo setObject:nextOrderDate forKey:key_nextorderdate];
                            }
                        }
                        
                        [self.magicOrders addObject:productInfo];
                    }
                }
                [self.magicTableView reloadData];
                
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

- (void)loadMagicOrders {
    
    [GoToProgressHUD showWithStatus:@"Loading..."];
    [[APIManager sharedManager] getMagicOrderWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseDict = responseObject;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
            NSLog(@"GetMagicOrders response string : %@", responseString);
#endif
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        }
        else {
#if DEBUG
            NSLog(@"GetMagicOrders response : %@", responseObject);
#endif
        }
        
        [GoToProgressHUD dismiss];
        
        if (responseDict) {
            BOOL success = [responseDict[key_success] boolValue];
            if (success) {
                self.magicOrders = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < [responseDict[key_magicOrders] count]; i ++) {
                    NSMutableDictionary* magicOrderInfo = [NSMutableDictionary dictionaryWithDictionary:responseDict[key_magicOrders][i]];
                    if (magicOrderInfo) {
                        NSInteger frequencyIndex = [magicOrderInfo[key_frequency] integerValue];
                        if (frequencyIndex < 0)
                            frequencyIndex = 0;
                        [magicOrderInfo setObject:@(frequencyIndex) forKey:key_frequency];
                        
                        [self.magicOrders addObject:magicOrderInfo];
                    }
                }
                
//                [self loadProducts];
                
                [self.magicTableView reloadData];
                
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
                
                [self.cardTableView reloadData];
                
                [self loadMagicOrders];
                
                return;
            }
        }
        
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_message] parentVC:self okHandler:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GoToProgressHUD dismiss];
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:[error localizedDescription] parentVC:self okHandler:nil];
    }];
}

- (void)addMagicOrder {
    NSDictionary* cardInfo = [[GSCManager sharedManager] getFavoriteCreditCard];
    if (!cardInfo) {
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:@"Before you save your magic order, we need you to store a credit card on your Goconuts profile." parentVC:self okHandler:^{
            [self performSegueWithIdentifier:Segue_ShowCreditCardVCModally sender:nil];
        }];
        return;
    }
    
    NSString* cardId = cardInfo[key_cardid];
    
    NSMutableArray* orderDetails = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary* productInfo in self.magicOrders) {
        NSString* dateString = productInfo[key_nextorderdate];
        if (!dateString || dateString.length < 1) {
            dateString = @"0000-00-00";
        }
        NSInteger frequency = 0;
        NSNumber* frequencyNumber = productInfo[key_frequency];
        if (frequencyNumber)
            frequency = [frequencyNumber integerValue];
        
        NSDictionary* orderInfo = @{key_sku: productInfo[key_sku],
                                    key_nextorderdate: dateString,
                                    key_frequency: @(frequency)
                                    };
        [orderDetails addObject:orderInfo];
    }
    
    [GoToProgressHUD showWithStatus:@"Saving..."];
    [[APIManager sharedManager] addMagicOrderWithOrderDetails:orderDetails cardId:cardId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* responseDict = responseObject;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
            NSLog(@"AddMagicOrders response string : %@", responseString);
#endif
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        }
        else {
#if DEBUG
            NSLog(@"AddMagicOrders response : %@", responseObject);
#endif
        }
        
        [GoToProgressHUD dismiss];
        
        if (responseDict && responseDict[key_magicOrders]) {
            BOOL success = [responseDict[key_magicOrders][key_success] boolValue];
            if (success) {
                [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_magicOrders][key_message] parentVC:self okHandler:nil];
                return;
            }
        }
        
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:responseDict[key_magicOrders][key_message] parentVC:self okHandler:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [GoToProgressHUD dismiss];
        [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:[error localizedDescription] parentVC:self okHandler:nil];
    }];
}

- (void)finishToSaveMagicOrder {
    [GoToProgressHUD dismiss];
    [[AlertManager sharedManager] showAlertWithTitle:@"GoSkinCare" message:@"Your Magic Order is submitted." parentVC:self okHandler:nil];
}


@end
