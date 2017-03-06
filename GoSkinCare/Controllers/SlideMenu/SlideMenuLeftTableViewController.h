//
//  SlideMenuLeftTableViewController.h
//  BeaconApp


#import <UIKit/UIKit.h>

@class SlideMenuMainViewController;

@interface SlideMenuLeftTableViewController : UITableViewController

@property (weak, nonatomic) SlideMenuMainViewController *mainVC;

// Only afor non storyboard use
- (void)openContentNavigationController:(UINavigationController *)nvc;

- (void)showFastOrderVC;
- (void)logout;
- (void)performSelectedSegue;

@end
