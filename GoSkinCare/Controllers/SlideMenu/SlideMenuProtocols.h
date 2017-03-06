//
//  SlideMenuProtocols.h
//  BeaconApp


#import <Foundation/Foundation.h>


@protocol SlideMenuDelegate <NSObject>

@optional

/**
 * Called when left menu is going to open
 */
- (void)leftMenuWillOpen;

/**
 * Called when left menu is already open
 */
- (void)leftMenuDidOpen;

/**
 * Called when right menu is going to open
 */
- (void)rightMenuWillOpen;

/**
 * Called when right menu is already open
 */
- (void)rightMenuDidOpen;


/**
 * Called when left menu is going to close
 */
- (void)leftMenuWillClose;

/**
 * Called when left menu is already closed
 */
- (void)leftMenuDidClose;

/**
 * Called when right menu is going to close
 */
- (void)rightMenuWillClose;

/**
 * Called when right menu is going to close
 */
- (void)rightMenuDidClose;

@end
