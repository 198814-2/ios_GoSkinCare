//
//  HistoryVC.m
//  GoSkinCare


#import "HistoryVC.h"
#import "UIViewController+SlideMenu.h"
#import "HistoryDetailVC.h"

@implementation HistoryCell

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



@interface HistoryVC ()

@property (weak, nonatomic) IBOutlet UITableView* historyTableView;

@property (strong, nonatomic) NSMutableArray* orders;

@end

@implementation HistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initUI];
    [self loadOrderHistory];
    
    
    // track GA
    [UtilManager trackingScreenView:GA_SCREENNAME_ORDER_HISTORY];
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
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = (HistoryCell*)[tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    NSDictionary* order = [self.orders objectAtIndex:indexPath.row];
    if (order) {
        cell.orderLabel.text = order[key_orderId];
//        cell.detailTextLabel.text = order[key_placeDate];
        
        NSDate* date = [UtilManager dateFromString:order[key_placeDate] inFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        NSString* dateString = [UtilManager dateStringFromDate:date inMediumFormat:@"d MMMM yyyy"];
        NSString* timeString = [UtilManager dateStringFromDate:date inMediumFormat:@"hh:mm a"];
        timeString = [timeString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0"]];
        dateString = [dateString stringByAppendingFormat:@" %@", timeString];
        cell.dateLabel.text = dateString;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* order = [self.orders objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:Segue_ShowHistoryDetailVC sender:order];
}


#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:Segue_ShowHistoryDetailVC]) {
        HistoryDetailVC* vc = segue.destinationViewController;
        vc.historyOrder = sender;
    }
}


#pragma mark -
#pragma mark - Main methods

- (void)initUI {
    
}

- (IBAction)tapMenuButton:(UIButton*)sender {
    [[self mainSlideMenu] openLeftMenu];
}

- (void)loadOrderHistory {
    
//    [SVProgressHUD showWithStatus:@"Loading..."];
    [GoToProgressHUD showWithStatus:@"Loading..."];
    [[APIManager sharedManager] getOrderListWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseDict = responseObject;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
            NSLog(@"GetOrders response string : %@", responseString);
#endif
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        }
        else {
#if DEBUG
            NSLog(@"GetOrders response : %@", responseObject);
#endif
        }
        
//        [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
        
        if (responseDict) {
            BOOL success = [responseDict[key_success] boolValue];
            if (success) {
                self.orders = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < [responseDict[key_orders] count]; i ++) {
                    NSMutableDictionary* order = [NSMutableDictionary dictionaryWithDictionary:responseDict[key_orders][i]];
                    if (order)
                        [self.orders addObject:order];
                }
                [self.historyTableView reloadData];
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


@end
