//
//  GSCManager.m
//  GoSkinCare


#import "GSCManager.h"

@interface GSCManager () {
    NSManagedObjectContext* managedObjectContext;
}

@end

@implementation GSCManager

+ (GSCManager*)sharedManager {
    
    static GSCManager* _sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.countries = [NSMutableArray arrayWithCapacity:0];
        self.products = [NSMutableArray arrayWithCapacity:0];
        self.creditCards = [NSMutableArray arrayWithCapacity:0];
        self.magicOrders = [NSMutableArray arrayWithCapacity:0];
        
        AppDelegate* appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        managedObjectContext = appdelegate.managedObjectContext;
    }
    return self;
}


- (void)loadCountriesWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    self.countries = [NSMutableArray arrayWithArray:[GSCManager sharedManager].countries];
    if (self.countries.count > 0) {
        return;
    }
    
    [[APIManager sharedManager] getCountriesWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* responseDict = responseObject;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
#if DEBUG
            NSLog(@"GetCountries response string : %@", responseString);
#endif
            responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        }
        else {
#if DEBUG
            NSLog(@"GetCountries response : %@", responseObject);
#endif
        }
        
        if (responseDict) {
            BOOL isSuccess = [responseDict[key_success] boolValue];
            if (isSuccess) {
                NSArray* countryList = responseDict[key_countries];
                if (countryList && countryList.count > 0) {
                    self.countries = [NSMutableArray arrayWithArray:countryList];
                    
                    if (success)
                        success();
                    
                    return;
                }
            }
        }
        
        if (failure)
            failure(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure)
            failure(error);
    }];
}

- (NSDictionary*)getCountryInfo:(NSString*)countryCode {
    
    for (NSDictionary* countryInfo in self.countries) {
        if (countryInfo && [countryInfo[key_code] isEqualToString:countryCode])
            return countryInfo;
    }
    return nil;
}

- (NSDictionary*)getMagicOrderInfoWith:(NSString*)productId {
    for (NSDictionary* magicOrderInfo in self.magicOrders) {
        if (magicOrderInfo && [magicOrderInfo[key_sku] isEqualToString:productId])
            return magicOrderInfo;
    }
    return nil;
}

- (NSDictionary*)getFavoriteCreditCard {
    if (self.creditCards.count > 0 && self.favouriteCardIndexPath != nil) {
        NSDictionary* cardInfo = self.creditCards[self.favouriteCardIndexPath.row];
        return cardInfo;
    }
    
    return nil;
}

@end
