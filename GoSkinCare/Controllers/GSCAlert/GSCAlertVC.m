//
//  GSCAlertVC.m
//  GoSkinCare


#import "GSCAlertVC.h"

@interface GSCAlertVC ()

@property (weak, nonatomic) IBOutlet UIView* wrapper;
@property (weak, nonatomic) IBOutlet UILabel* alertTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView* alertMessageView;
@property (weak, nonatomic) IBOutlet UIButton* alertOKButton;
@property (weak, nonatomic) IBOutlet UIButton* confirmOKButton;
@property (weak, nonatomic) IBOutlet UIButton* confirmCancelButton;

@end

@implementation GSCAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.wrapper.layer.cornerRadius = 15.f;
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

- (void)setAlertType:(GSCAlertType)alertType {
    self.alertOKButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.alertOKButton.layer.borderWidth = 2.f;
    self.alertOKButton.layer.cornerRadius = 8.f;
    
    self.confirmOKButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.confirmOKButton.layer.borderWidth = 2.f;
    self.confirmOKButton.layer.cornerRadius = 8.f;
    
    self.confirmCancelButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.confirmCancelButton.layer.borderWidth = 2.f;
    self.confirmCancelButton.layer.cornerRadius = 8.f;
    
    self.alertOKButton.alpha = alertType == GSCAlertType_Alert;
    self.confirmOKButton.alpha = alertType == GSCAlertType_Confirm;
    self.confirmCancelButton.alpha = alertType == GSCAlertType_Confirm;
}

- (void)setAlertTitle:(NSString *)alertTitle {
    _alertTitle = alertTitle;
    self.alertTitleLabel.text = _alertTitle;
}

- (void)setAlertMessage:(NSString *)alertMessage {
    _alertMessage = alertMessage;
    self.alertMessageView.text = _alertMessage;
}

- (IBAction)tapAlertOKButton:(UIButton*)sender {
    if (self.delegate)
        [self.delegate alertOKClicked];
}

- (IBAction)tapConfirmOKButton:(UIButton*)sender {
    if (self.delegate)
        [self.delegate confirmOKClicked];
}

- (IBAction)tapConfirmCancelButton:(UIButton*)sender {
    if (self.delegate)
        [self.delegate confirmCancelClicked];
}


@end
