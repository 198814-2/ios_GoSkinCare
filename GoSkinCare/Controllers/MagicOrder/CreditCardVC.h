//
//  CreditCardVC.h
//  GoSkinCare


#import <UIKit/UIKit.h>

@interface CreditCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView* wrapper;
@property (weak, nonatomic) IBOutlet UIButton* optionButton;
@property (weak, nonatomic) IBOutlet UILabel* cardNumberLabel;

@end

@interface CreditCardVC : UIViewController

@property (nonatomic) BOOL showModally;

@end
