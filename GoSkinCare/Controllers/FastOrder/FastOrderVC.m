//
//  FastOrderVC.m
//  GoSkinCare


#import "FastOrderVC.h"
#import "UIViewController+SlideMenu.h"
#import "OrderDetailVC.h"


@implementation ProductCell

- (void)awakeFromNib {
    // Initialization code
    
    self.plusButton.layer.borderWidth = 2.f;
    self.plusButton.layer.borderColor = [MainTintColor CGColor];
    self.plusButton.layer.cornerRadius = 2.f;
    
    self.minuseButton.layer.borderWidth = 2.f;
    self.minuseButton.layer.borderColor = [MainTintColor CGColor];
    self.minuseButton.layer.cornerRadius = 2.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    if (selected) {
        self.nameLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
        self.priceLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
        self.descLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
        self.amountField.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
        self.totalCostLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
    }
    else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.priceLabel.textColor = [UIColor blackColor];
        self.descLabel.textColor = [UIColor blackColor];
        self.amountField.textColor = [UIColor blackColor];
        self.totalCostLabel.textColor = [UIColor blackColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.nameLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
        self.priceLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
        self.descLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
        self.amountField.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
        self.totalCostLabel.textColor = [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f];
    }
    else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.priceLabel.textColor = [UIColor blackColor];
        self.descLabel.textColor = [UIColor blackColor];
        self.amountField.textColor = [UIColor blackColor];
        self.totalCostLabel.textColor = [UIColor blackColor];
    }
}

@end



@interface FastOrderVC () <LoginManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView* orderTableView;

@property (strong, nonatomic) UIView* thumbBgWrapper;
@property (strong, nonatomic) UIView* thumbWrapper;
@property (strong, nonatomic) UIImageView* thumbImageView;

@property (strong, nonatomic) NSMutableArray* products;

@end

@implementation FastOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    [self initUI];
    
    [self loadProducts];
    
    // track GA
    [UtilManager trackingScreenView:GA_SCREENNAME_FAST_ORDER];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
//    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
//    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* product = [self.products objectAtIndex:indexPath.row];
    CGFloat cellHeight = 110.f + [self getDetailHeight:product[key_detail]];
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell* cell = (ProductCell*)[tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    
//    [self configureCell:cell atIndexPath:indexPath];
    
    NSMutableDictionary* product = self.products[indexPath.row];
    if (product) {
        cell.plusButton.tag = indexPath.row;
        cell.minuseButton.tag = indexPath.row;
        cell.nameLabel.text = product[key_productName];
        cell.priceLabel.text = [NSString stringWithFormat:@"%@%@", product[key_priceCurrencySymbol], @([product[key_price] doubleValue])];
        cell.descLabel.text = product[key_detail];
        cell.amountField.text = [NSString stringWithFormat:@"%ld", [product[key_amount] integerValue]];
        cell.totalCostLabel.text = [NSString stringWithFormat:@"= %@%@", product[key_priceCurrencySymbol], @([product[key_price] doubleValue] * [product[key_amount] integerValue])];
        
//        if ([product[key_amount] integerValue] > 0) {
//            cell.layer.borderWidth = 5.f;
//            cell.layer.borderColor = [ProductBorderColor CGColor];
//        }
//        else {
//            cell.layer.borderWidth = 0.f;
//            cell.layer.borderColor = [[UIColor clearColor] CGColor];
//        }
        
        UIImage* placeholderImage = [UIImage imageNamed:@"AppIcon60x60@2x"];
        NSString* smallImageUrl = product[key_imageUrlSmall];
//        NSString* mediumImageUrl = product[key_imageUrlMedium];
//        NSString* largeImageUrl = product[key_imageUrlLarge];
        if (smallImageUrl) {
            [cell.activityIndicator startAnimating];
            [cell.productImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:smallImageUrl]] placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                cell.productImageView.image = image;
                [cell.activityIndicator stopAnimating];
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                NSLog(@"=====> ERROR %ld : %@", indexPath.row, smallImageUrl);
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:CoreDataEntity_GSCProduct inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:CoreDataAttribute_productName ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //  NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.orderTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch((int)type) {
        case NSFetchedResultsChangeInsert:
            [self.orderTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.orderTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.orderTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.orderTableView endUpdates];
}

- (void)configureCell:(ProductCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    GSCProduct* productObject = (GSCProduct*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.plusButton.tag = indexPath.row;
    cell.minuseButton.tag = indexPath.row;
    cell.nameLabel.text = productObject.productName;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@%@", productObject.priceCurrencySymbol, @(productObject.price.doubleValue)];
    cell.descLabel.text = productObject.detail;
//    cell.amountField.text = productObject.amount;
    cell.totalCostLabel.text = [NSString stringWithFormat:@"= %@%@", productObject.priceCurrencySymbol, @(productObject.price.doubleValue * 1)];
    
    NSString* smallImageUrl = productObject.imageUrlSmall;
//    NSString* mediumImageUrl = productObject.imageUrlMedium;
//    NSString* largeImageUrl = productObject.imageUrlLarge;
    if (smallImageUrl) {
        cell.activityIndicator.hidden = NO;
        [cell.activityIndicator startAnimating];
        [cell.productImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:smallImageUrl]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            cell.productImageView.image = image;
            [cell.activityIndicator stopAnimating];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            [cell.activityIndicator stopAnimating];
        }];
    }
}


#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowOrderDetailVC]) {
        OrderDetailVC* vc = segue.destinationViewController;
        vc.orderProducts = [NSMutableArray arrayWithArray:sender];
    }
    else if ([segue.identifier isEqualToString:Segue_ShowLoginManagerVC]) {
        UINavigationController* navVC = segue.destinationViewController;
        LoginManagerVC* loginManager = (LoginManagerVC*)navVC.viewControllers[0];
        loginManager.delegate = self;
    }
}


#pragma mark -
#pragma mark - Main methods

- (void)initUI {
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

- (IBAction)tapNextButton:(UIButton*)sender {
    BOOL isMemberLogin = [[NSUserDefaults standardUserDefaults] boolForKey:gsc_user_is_guest_login];
    if (isMemberLogin) {
        [self performSegueWithIdentifier:Segue_ShowLoginManagerVC sender:nil];
        return;
    }
    
    NSMutableArray* orderProducts = [NSMutableArray arrayWithCapacity:0];
    for (NSMutableDictionary* product in self.products) {
        if (!product)
            continue;
        
        if ([product[key_amount] integerValue] > 0) {
            [orderProducts addObject:product];
        }
    }
    
    if (orderProducts.count > 0) {
        [self performSegueWithIdentifier:Segue_ShowOrderDetailVC sender:orderProducts];
    }
    else {
        [[AlertManager sharedManager] showAlertWithTitle:@"Error" message:@"Please select at least one product first!" parentVC:self okHandler:nil];
    }
}

- (IBAction)tapMenuButton:(UIButton*)sender {
    [[self mainSlideMenu] openLeftMenu];
}

- (IBAction)tapPlusButton:(UIButton*)sender {
    ProductCell* cell = [self.orderTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    if (cell) {
        NSInteger amount = cell.amountField.text.integerValue;
        amount += 1;
        
        NSMutableDictionary* product = self.products[sender.tag];
        [product setObject:@(amount) forKey:key_amount];
        
        cell.amountField.text = [NSString stringWithFormat:@"%ld", [product[key_amount] integerValue]];
        cell.totalCostLabel.text = [NSString stringWithFormat:@"= $%@", @([product[key_price] doubleValue] * [product[key_amount] integerValue])];
        
//        if (amount > 0) {
//            cell.layer.borderWidth = 5.f;
//            cell.layer.borderColor = [ProductBorderColor CGColor];
//        }
    }
}

- (IBAction)tapMinuseButton:(UIButton*)sender {
    ProductCell* cell = [self.orderTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    if (cell) {
        NSInteger amount = cell.amountField.text.integerValue;
        amount = MAX(amount - 1, 0);
        
        NSMutableDictionary* product = self.products[sender.tag];
        [product setObject:@(amount) forKey:key_amount];
        
        cell.amountField.text = [NSString stringWithFormat:@"%ld", [product[key_amount] integerValue]];
        cell.totalCostLabel.text = [NSString stringWithFormat:@"= $%@", @([product[key_price] doubleValue] * [product[key_amount] integerValue])];
        
//        if (amount < 1) {
//            cell.layer.borderWidth = 0.f;
//            cell.layer.borderColor = [[UIColor clearColor] CGColor];
//        }
    }
}

- (void)tapThumbButton:(UIButton*)thumbButton {
    [self showThumbWrapper:thumbButton.tag];
    [self loadThumbImage:thumbButton.tag];
}

- (void)hideThumbWrapper {
    NSInteger tag = self.thumbWrapper.tag;
    
    [GoToProgressHUD dismiss];
    
    [UIView animateWithDuration:0.25f animations:^{
        ProductCell* cell = [self.orderTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
        if (cell) {
            CGRect frame = CGRectMake(cell.frame.origin.x + cell.thumbButton.frame.origin.x,
                                      cell.frame.origin.y + cell.thumbButton.frame.origin.y - self.orderTableView.contentOffset.y,
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
    
    ProductCell* cell = [self.orderTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    if (cell) {
        frame = CGRectMake(cell.frame.origin.x + cell.thumbButton.frame.origin.x,
                           cell.frame.origin.y + cell.thumbButton.frame.origin.y - self.orderTableView.contentOffset.y,
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
    if (self.products && self.products.count > tag) {
        NSDictionary* product = self.products[tag];
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

- (IBAction)unwindToFastOrderVC:(UIStoryboardSegue*)segue {
}

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
                self.products = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < [responseDict[key_products] count]; i ++) {
                    NSMutableDictionary* product = [NSMutableDictionary dictionaryWithDictionary:responseDict[key_products][i]];
                    if (product)
                        [self.products addObject:product];
                }
                [self.orderTableView reloadData];
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
#pragma mark - LoginManager delegate

- (void)loginManager:(LoginManagerVC *)loginManager didSuccessToLoginWithEmail:(NSString *)email password:(NSString *)password {
    [self dismissViewControllerAnimated:YES completion:^{
        [self tapNextButton:nil];
    }];
}

- (void)loginManager:(LoginManagerVC *)loginManager didFailToLoginWithEmail:(NSString *)email {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
