//
//  GSCManager.h
//  GoSkinCare


#import <Foundation/Foundation.h>

@interface GSCManager : NSObject

@property (strong, nonatomic) NSMutableArray* countries;
@property (strong, nonatomic) NSMutableArray* products;
@property (strong, nonatomic) NSMutableArray* creditCards;
@property (strong, nonatomic) NSMutableArray* magicOrders;

@property (strong, nonatomic) NSIndexPath* favouriteCardIndexPath;

+ (GSCManager*)sharedManager;

- (void)loadCountriesWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;
- (NSDictionary*)getCountryInfo:(NSString*)countryCode;
- (NSDictionary*)getMagicOrderInfoWith:(NSString*)productId;
- (NSDictionary*)getFavoriteCreditCard;

@end
