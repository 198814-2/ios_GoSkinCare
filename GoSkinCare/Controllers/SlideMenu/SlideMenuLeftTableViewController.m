//
//  SlideMenuLeftTableViewController.m
//  BeaconApp
//


#import "SlideMenuLeftTableViewController.h"

#import "SlideMenuMainViewController.h"

#import "SlideMenuContentSegue.h"

@interface SlideMenuLeftTableViewController ()

@property (strong, nonatomic) NSString* segueIdentifier;

@end

@implementation SlideMenuLeftTableViewController


#pragma mark - Lifecycle -


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)openContentNavigationController:(UINavigationController *)nvc
{
#ifdef SlideMenuWithoutStoryboards
    SlideMenuContentSegue *contentSegue = [[SlideMenuContentSegue alloc] initWithIdentifier:@"contentSegue" source:self destination:nvc];
    [contentSegue perform];
#else
    NSLog(@"This methos is only for NON storyboard use! You must define SlideMenuWithoutStoryboards \n (e.g. #define SlideMenuWithoutStoryboards)");
#endif
}



#pragma mark - TableView Delegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (![self.mainVC respondsToSelector:@selector(navigationControllerForIndexPathInLeftMenu:)]) {
        self.segueIdentifier = [self.mainVC segueIdentifierForIndexPathInLeftMenu:indexPath];
        if (self.segueIdentifier && self.segueIdentifier.length > 0) {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:gsc_user_is_guest_login] && indexPath.row > MenuItem_FastOrder && indexPath.row < MenuItem_Terms) {
                [self.mainVC performSegueWithIdentifier:Segue_ShowLoginManagerVC sender:nil];
                return nil;
            }
        }
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.mainVC respondsToSelector:@selector(navigationControllerForIndexPathInLeftMenu:)]) {
        UINavigationController *navController = [self.mainVC navigationControllerForIndexPathInLeftMenu:indexPath];
        SlideMenuContentSegue *segue = [[SlideMenuContentSegue alloc] initWithIdentifier:@"ContentSugue" source:self destination:navController];
        [segue perform];
    } else {
        self.segueIdentifier = [self.mainVC segueIdentifierForIndexPathInLeftMenu:indexPath];
        if (self.segueIdentifier && self.segueIdentifier.length > 0) {
            if (indexPath.row == MenuItem_Logout) {
                [self performSelector:@selector(logout)];
            }
            else {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:gsc_user_is_guest_login] && indexPath.row > MenuItem_FastOrder && indexPath.row < MenuItem_Terms) {
                    [self.mainVC performSegueWithIdentifier:Segue_ShowLoginManagerVC sender:nil];
                    return;
                }
                
                [self performSegueWithIdentifier:self.segueIdentifier sender:self];
                self.segueIdentifier = nil;
            }
        }
    }
}

- (void)showFastOrderVC {
    NSIndexPath* fastOrderIndexPath = [NSIndexPath indexPathForRow:MenuItem_FastOrder inSection:0];
    [self.tableView selectRowAtIndexPath:fastOrderIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:fastOrderIndexPath];
}

- (void)logout {
}

- (void)performSelectedSegue {
    if (self.segueIdentifier)
        [self performSegueWithIdentifier:self.segueIdentifier sender:self];
}


@end
