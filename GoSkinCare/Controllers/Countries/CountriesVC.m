//
//  CountriesVC.m
//  GoSkinCare


#import "CountriesVC.h"

@interface CountriesVC ()

@property (weak, nonatomic) IBOutlet UIView* topBarBorderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* topBarBorderHeight;

@property (weak, nonatomic) IBOutlet UITableView* countryTableView;

@end

@implementation CountriesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GSCManager sharedManager].countries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryCell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSDictionary* country = [[GSCManager sharedManager].countries objectAtIndex:indexPath.row];
    if (country) {
        cell.textLabel.text = country[key_label];
        if (self.countryInfo && [self.countryInfo[key_label] isEqualToString:country[key_label]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark -
#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.countryInfo = [GSCManager sharedManager].countries[indexPath.row];
    [self.countryTableView reloadData];
    
    [self performSegueWithIdentifier:Segue_UnWindToProfileVC sender:self];
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
    self.topBarBorderHeight.constant = 0.5f;
    
    [self loadCountries];
}

- (void)loadCountries {
    
    GSCManager* gscManager = [GSCManager sharedManager];
    if (gscManager.countries && gscManager.countries.count > 0) {
        [self.countryTableView reloadData];
        return;
    }
    
    [SVProgressHUD show];
    [gscManager loadCountriesWithSuccess:^{
//        [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
        [self.countryTableView reloadData];
    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
        [GoToProgressHUD dismiss];
    }];
}


@end
