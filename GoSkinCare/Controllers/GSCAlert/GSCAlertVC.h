//
//  GSCAlertVC.h
//  GoSkinCare


#import <UIKit/UIKit.h>

@protocol GSCAlertDelegate <NSObject>

- (void)alertOKClicked;
- (void)confirmOKClicked;
- (void)confirmCancelClicked;

@end

@interface GSCAlertVC : UIViewController

@property (strong, nonatomic) id<GSCAlertDelegate> delegate;

@property (strong, nonatomic) NSString* alertTitle;
@property (strong, nonatomic) NSString* alertMessage;

- (void)setAlertType:(GSCAlertType)alertType;

@end
