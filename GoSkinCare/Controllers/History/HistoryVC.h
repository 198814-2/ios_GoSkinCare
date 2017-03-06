//
//  HistoryVC.h
//  GoSkinCare


#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView* wrapper;
@property (weak, nonatomic) IBOutlet UILabel* orderLabel;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;

@end

@interface HistoryVC : UIViewController

@end
