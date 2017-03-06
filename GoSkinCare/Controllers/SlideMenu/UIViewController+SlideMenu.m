//
//  UIViewController+SlideMenu.m
//  BeaconApp


#import "UIViewController+SlideMenu.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIViewController (SlideMenu)


#pragma mark - Public Actions -


+ (void)load
{
    Method origMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method newMethod = class_getInstanceMethod([self class], @selector(my_dealloc));
    method_exchangeImplementations(origMethod, newMethod);
    
    [self swizzleOriginalSelectorWithName:@"dealloc" toSelectorWithName:@"my_dealloc"];
    [self swizzleOriginalSelectorWithName:@"viewWillAppear:" toSelectorWithName:@"my_viewWillAppear:"];
    [self swizzleOriginalSelectorWithName:@"viewWillDisappear:" toSelectorWithName:@"my_viewWillDisappear:"];
}


#pragma mark - Swizzle Utils methods
+ (void)swizzleOriginalSelectorWithName:(NSString *)origName toSelectorWithName:(NSString *)swizzleName
{
    Method origMethod = class_getInstanceMethod([self class], NSSelectorFromString(origName));
    Method newMethod = class_getInstanceMethod([self class], NSSelectorFromString(swizzleName));
    method_exchangeImplementations(origMethod, newMethod);
}

#pragma marl -
- (void)addLeftMenuButton
{
    SlideMenuMainViewController *mainVC = [SlideMenuMainViewController getInstanceForVC:self];
    
    UINavigationItem *navItem = self.navigationItem;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mainVC configureLeftMenuButton:leftBtn];
    [leftBtn addTarget:mainVC action:@selector(openLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)addRightMenuButton
{
    SlideMenuMainViewController *mainVC = [SlideMenuMainViewController getInstanceForVC:self];
    
    UINavigationItem *navItem = self.navigationItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mainVC configureRightMenuButton:rightBtn];
    [rightBtn addTarget:mainVC action:@selector(openRightMenu) forControlEvents:UIControlEventTouchUpInside];
    
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)removeLeftMenuButton
{
    UINavigationItem *navItem = self.navigationItem;
    
    navItem.leftBarButtonItem = nil;
}

- (void)removeRightMenuButton
{
    UINavigationItem *navItem = self.navigationItem;
    
    navItem.rightBarButtonItem = nil;
}

- (void)enableSlidePanGestureForLeftMenu
{
    SlideMenuMainViewController *mainVC = [SlideMenuMainViewController getInstanceForVC:self];
    
    mainVC.rightPanDisabled = NO;
}

- (void)enableSlidePanGestureForRightMenu
{
    SlideMenuMainViewController *mainVC = [SlideMenuMainViewController getInstanceForVC:self];
    mainVC.leftPanDisabled = NO;
}

- (void)disableSlidePanGestureForLeftMenu
{
    SlideMenuMainViewController *mainVC = [SlideMenuMainViewController getInstanceForVC:self];
    mainVC.rightPanDisabled = YES;
}

- (void)disableSlidePanGestureForRightMenu
{
    SlideMenuMainViewController *mainVC = [SlideMenuMainViewController getInstanceForVC:self];
    mainVC.leftPanDisabled = YES;
}

- (SlideMenuMainViewController *)mainSlideMenu
{
    SlideMenuMainViewController *mainVC = [SlideMenuMainViewController getInstanceForVC:self];
    return mainVC;
}

#pragma mark - Lifecycle -


#pragma marl - Swizzled Methods

- (void)my_dealloc
{
    // Additional code Here
    
    // Call original dealloc method
    [self my_dealloc];
}

- (void)my_viewWillAppear:(BOOL)animated
{
    // Additional code Here
    
    // Call original viewWillAppear method
    [self my_viewWillAppear:animated];
}

- (void)my_viewWillDisappear:(BOOL)animated
{
    // Additional code Here
    
    // Enabling pan gesture for left and right menus
    SlideMenuMainViewController *mainVC = [SlideMenuMainViewController getInstanceForVC:self];
    mainVC.leftPanDisabled = NO;
    mainVC.rightPanDisabled = NO;
    
    // Call original viewWillDisappear method
    [self my_viewWillDisappear:animated];
}

@end
