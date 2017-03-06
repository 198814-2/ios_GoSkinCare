//
//  SlideMenuLeftMenuSegue.m
//  BeaconApp
//


#import "SlideMenuLeftMenuSegue.h"

#import "SlideMenuContentSegue.h"
#import "SlideMenuLeftTableViewController.h"
#import "SlideMenuMainViewController.h"

@implementation SlideMenuLeftMenuSegue


#pragma mark - Actions -


- (void)perform
{
    SlideMenuMainViewController* mainVC = self.sourceViewController;
    SlideMenuLeftTableViewController* leftMenu = self.destinationViewController;
    
    mainVC.leftMenu = leftMenu;
    leftMenu.mainVC = mainVC;
    
    [mainVC addChildViewController:leftMenu];
    
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        CGRect bounds = mainVC.view.bounds;
        leftMenu.view.frame = CGRectMake(0,0,bounds.size.width,bounds.size.height);
    });
    
    [mainVC.view addSubview:leftMenu.view];
    
    [leftMenu.navigationController setNavigationBarHidden:YES];
    
    NSIndexPath *initialIndexPath = [mainVC initialIndexPathForLeftMenu];
    
#ifndef SlideMenuWithoutStoryboards
    if ([mainVC respondsToSelector:@selector(navigationControllerForIndexPathInLeftMenu:)]) {
        UINavigationController *navController = [mainVC navigationControllerForIndexPathInLeftMenu:initialIndexPath];
        SlideMenuContentSegue *segue = [[SlideMenuContentSegue alloc] initWithIdentifier:@"ContentSugue" source:leftMenu destination:navController];
        [segue perform];
    } else {
        NSString *segueIdentifier = [mainVC segueIdentifierForIndexPathInLeftMenu:initialIndexPath];
        [leftMenu performSegueWithIdentifier:segueIdentifier sender:self];
    }
#else
    [leftMenu tableView:leftMenu.tableView didSelectRowAtIndexPath:initialIndexPath];
#endif
}


@end
