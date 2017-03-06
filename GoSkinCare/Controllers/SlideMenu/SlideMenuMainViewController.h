//
//  SlideMenuMainViewController.h
//  BeaconApp
//


#import <UIKit/UIKit.h>
#import "SlideMenuProtocols.h"
#import "SlideMenuLeftTableViewController.h"

typedef enum {
    PrimaryMenuLeft,
    PrimaryMenuRight
} PrimaryMenu;

typedef enum {
    SlideMenuLeft,
    SlideMenuRight
} SlideMenu;

typedef enum {
    SlideMenuClosed,
    SlideMenuLeftOpened,
    SlideMenuRightOpened,
} SlideMenuState;

@protocol SlideMenuMultipleStoryboarding <NSObject>

@optional
/**
 * Override this method and return instantiated navigation controller that will opened
 * when cell at indexPath will be selected from left menu
 * NOTE! If you override this method, then segueIdentifierForIndexPathInLeftMenu will be ignored
 * @param indexPath of left menu table
 * @return UINavigationController instance for input indexPath
 */
- (UINavigationController *)navigationControllerForIndexPathInLeftMenu:(NSIndexPath *)indexPath;

/**
 * Override this method and return instantiated navigation controller that will opened
 * when cell at indexPath will be selected from left menu
 * NOTE! If you override this method, then segueIdentifierForIndexPathInRightMenu will be ignored
 * @param indexPath of right menu table
 * @return UINavigationController instance for input indexPath
 */
- (UINavigationController *)navigationControllerForIndexPathInRightMenu:(NSIndexPath *)indexPath;


@end

@interface SlideMenuMainViewController : UIViewController <SlideMenuMultipleStoryboarding>

#pragma mark - Properties

@property (weak, nonatomic) id<SlideMenuDelegate> slideMenuDelegate;

@property (strong, nonatomic) SlideMenuLeftTableViewController *leftMenu;
@property (strong, nonatomic) UINavigationController *currentActiveNVC;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (nonatomic) BOOL leftPanDisabled;
@property (nonatomic) BOOL rightPanDisabled;

@property (nonatomic) BOOL isInitialStart;

@property (nonatomic) SlideMenuState menuState;

+ (SlideMenuMainViewController *)getInstanceForVC:(UIViewController *)vc;
+ (NSArray *)allInstances;

#pragma mark - Overridable Public Methods

/**
 * Override this method for customize left menu button.
 * @param Left button instance to encapsulate
 */
- (void)configureLeftMenuButton:(UIButton *)button;

/**
 * Override this method for customize right menu button.
 * @param Left button instance to encapsulate
 */
- (void)configureRightMenuButton:(UIButton *)button;

/**
 * Override this method for setting visible width for left menu.
 * @return The left menu width (Default will return 250)
 */
- (CGFloat)leftMenuWidth;

/**
 * Override this method for setting visible width for right menu.
 * @return The right menu width (Default will return 250)
 */
- (CGFloat)rightMenuWidth;

/**
 * Override this method to change the animation duration of opening the menu
 * @return Open animation duration (Default will return 0.35f
 */
- (CGFloat) openAnimationDuration;

/**
 * Override this method to change the animation duration of closing the menu
 * @return Closing animation duration (Default will return 0.35f
 */
- (CGFloat) closeAnimationDuration;

/**
 * Override this method to select whether of
 * menues is the primary and which's root vc will be presented in first time.
 * @return Type of primary menu (Default will return PrimaryMenuLeft)
 */
- (PrimaryMenu)primaryMenu;

/**
 * Override this method to set which of indexPaths
 * will be selected automatically on first time for left menu
 * @return Default will return (0, 0)
 */
- (NSIndexPath *)initialIndexPathForLeftMenu;

/**
 * Override this method to set which of
 * indexPaths will be selected automatically on first time for right menu
 * @return Default will return (0, 0)
 */
- (NSIndexPath *)initialIndexPathForRightMenu;

/**
 * Override this method and return segue identifier that will be performed
 * when cell at indexPath will be selected from left menu
 * @param indexPath of left menu table
 * @return Segue identifier for input indexPath
 */
- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath;

/**
 * Override this method and return segue identifier that will be performed
 * when cell at indexPath will be selected from right menu
 * @param indexPath of right menu table
 * @return Segue identifier for input indexPath
 */
- (NSString *)segueIdentifierForIndexPathInRightMenu:(NSIndexPath *)indexPath;

/**
 * Override this method to configure slide layer. (e.g. for shadow)
 * @param layer of slider
 */
- (void)configureSlideLayer:(CALayer *)layer;

/**
 * Override this method if you want that pan work only on edges of view
 * Default value is 100%
 * @return percentage of pan's working area in view.
 */
- (CGFloat)panGestureWarkingAreaPercent;

/**
 * Override this method if you want to enable or disable deepness in left menu
 * Default value is NO
 * @return YES or NO
 */
- (BOOL)deepnessForLeftMenu;

/**
 * Override this method if you want to enable or disable deepness in right menu
 * Default value is NO
 * @return YES or NO
 */
- (BOOL)deepnessForRightMenu;

/**
 * Override this method if you want to enable or disable darkness effect on content vc while left menu is opening
 * Default value is 0
 * @return CGFloat range of [0,1]
 */
- (CGFloat)maxDarknessWhileLeftMenu;

/**
 * Override this method if you want to enable or disable darkness effect on content vc while right menu is opening
 * Default value is 0
 * @return CGFloat range of [0,1]
 */
- (CGFloat)maxDarknessWhileRightMenu;

/**
 * Call this method if you want to fix status bar with custom view
 * @method
 * Works ONLY for iOS > 7.0 !
 * @param UIView* that will be shown as background of status bar. Must be 20px height.
 */
- (void)fixStatusBarWithView:(UIView *)view;

/**
 * Call this method if you want to uunfix status bar with custom view
 * @method
 * Works ONLY for iOS > 7.0 !
 */
- (void)unfixStatusBarView;

#pragma mark - Methods

#pragma mark -- Actions

/**
 * Opens Left menu by animation
 */
- (void)openLeftMenu;

/**
 * Opens Left menu
 * @param animated indicates if menu should be openen
 * by animation
 */
- (void)openLeftMenuAnimated:(BOOL)animated;

/**
 * Opens Right menu by animation
 */
- (void)openRightMenu;

/**
 * Opens Right menu
 * @param animated indicates if menu should be openen
 * by animation
 */
- (void)openRightMenuAnimated:(BOOL)animated;

/**
 * Closes Left menu by animation
 */
- (void)closeLeftMenu;

/**
 * Closes Left menu
 * @param animated indicates if menu should be closed
 * by animation
 */
- (void)closeLeftMenuAnimated:(BOOL)animated;

/**
 * Closes Right menu by animation
 */
- (void)closeRightMenu;

/**
 * Closes Right menu
 * @param animated indicates if menu should be closed
 * by animation
 */
- (void)closeRightMenuAnimated:(BOOL)animated;

/**
 * makes switch between active controller to input controller
 * @param Destination controller
 * @param Menu from where switch should be done
 */
- (void)switchCurrentActiveControllerToController:(UINavigationController *)nvc
                                         fromMenu:(UITableViewController *)menu;

/**
 * makes switch between active controller to input controller at indexPath in input menu
 * @param Menu enum from where switch should be done
 * @param indexPath destination ViewController's indexPath in menu
 */
- (void)openContentViewControllerForMenu:(SlideMenu)menu atIndexPath:(NSIndexPath *)indexPath;
@end
