//
//  HistoryDetailVC.m
//  GoSkinCare


#import "HistoryDetailVC.h"
#import "OrderDetailVC.h"
#import "UIViewController+SlideMenu.h"

@interface HistoryDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel* orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel* orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel* orderStatusLabel;
@property (weak, nonatomic) IBOutlet UITableView* historyTableView;

@property (strong, nonatomic) NSMutableArray* orderProducts;

@end

@implementation HistoryDetailVC

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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderProducts.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCell* cell = (OrderCell*)[tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    
    //    [self configureCell:cell atIndexPath:indexPath];
    
    if (indexPath.row == self.orderProducts.count) {
        cell.infoLabel.text = @"";
        if (self.historyOrder) {
            NSString* shippingName = self.historyOrder[key_shippingName];
            if (shippingName && shippingName.length > 0)
                cell.infoLabel.text = shippingName;
            else
                cell.infoLabel.text = @"Shipping";
            cell.costLabel.text = [NSString stringWithFormat:@"%@ %@", self.historyOrder[key_priceCurrencySymbol], self.historyOrder[key_shippingPrice]];
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
            cell.costLabel.text = [NSString stringWithFormat:@"%@ %.2f", self.historyOrder[key_priceCurrencySymbol], [orderProduct[key_itemPrice] doubleValue]];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    OrderFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderFooterCell"];
    
    cell.infoLabel.text = @"Total";
    if (self.historyOrder)
        cell.costLabel.text = [NSString stringWithFormat:@"%@ %.2f", self.historyOrder[key_priceCurrencySymbol], [self.historyOrder[@"totalPrice:"] doubleValue]];
    
    return cell;
}


#pragma mark -
#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark - Main methods

- (void)initUI {
    
    if (self.historyOrder) {
        
        self.orderIDLabel.text = self.historyOrder[key_orderId];
        self.orderStatusLabel.text = [@"Status : " stringByAppendingString:self.historyOrder[key_status]];
        
        NSDate* date = [UtilManager dateFromString:self.historyOrder[key_placeDate] inFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        self.orderDateLabel.text = [UtilManager dateStringFromDate:date inFormat:@"d MMMM yyyy HH:mm:ss"];
        
        
        self.orderProducts = [NSMutableArray arrayWithArray:self.historyOrder[key_items]];
        [self.historyTableView reloadData];
    }
}

- (IBAction)tapMenuButton:(UIButton*)sender {
    [[self mainSlideMenu] openLeftMenu];
}

- (IBAction)tapBackButton:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
