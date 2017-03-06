//
//  MenuCell.h
//  GoSkinCare


#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView* wrapper;
@property (weak, nonatomic) IBOutlet UIImageView* menuImageView;
@property (weak, nonatomic) IBOutlet UILabel* menuNameLabel;

@property (strong, nonatomic) NSString* imageName;

- (void)setImageName:(NSString*)imageName;

@end
