//
//  APIManager.h
//  GoSkinCare


#import <Foundation/Foundation.h>

@interface APIManager : NSObject

@property (strong, nonatomic) NSString* apiToken;

+ (APIManager*)sharedManager;
- (AFHTTPRequestOperationManager*)operationManager;

- (instancetype)init;

- (NSString*)deviceToken;

- (NSString*)getUserId;
- (NSDictionary*)getUserDetails;
- (void)saveUserDetails:(NSDictionary*)userInfo;
- (BOOL)isUserLoggedIn;

- (NSString*)formattedUserName;
- (NSString*)formattedAddress;

- (void)loginWithEmail:(NSString*)email
              password:(NSString*)password
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)verifyAddressWithCountryCode:(NSString*)countryCode
                              street:(NSString*)street
                             street2:(NSString*)street2
                              suburb:(NSString*)suburb
                               state:(NSString*)state
                            postCode:(NSString*)postCode
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)signupWithFirstname:(NSString*)firstname
                    surname:(NSString*)surname
                   nickname:(NSString*)nickname
                      email:(NSString*)email
                   password:(NSString*)password
                    company:(NSString*)company
                countryCode:(NSString*)countryCode
                     street:(NSString*)street
                    street2:(NSString*)street2
                     suburb:(NSString*)suburb
                      state:(NSString*)state
                   postCode:(NSString*)postCode
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)updateProfileWithFirstname:(NSString*)firstname
                           surname:(NSString*)surname
                          nickname:(NSString*)nickname
                             email:(NSString*)email
                          password:(NSString*)password
                           company:(NSString*)company
                       countryCode:(NSString*)countryCode
                            street:(NSString*)street
                           street2:(NSString*)street2
                            suburb:(NSString*)suburb
                             state:(NSString*)state
                          postCode:(NSString*)postCode
                   isCreateProfile:(BOOL)createProfile
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)resetPasswordWithEmail:(NSString*)email
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getProductListWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)calculateOrderPriceWithOrder:(NSDictionary*)order
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)placeOrderPriceWithOrder:(NSDictionary*)order
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)placeIncompleteOrderWithOrder:(NSDictionary*)order
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)confirmOrderWithOrderID:(NSString*)orderId
                paypalReference:(NSString*)paypalReference
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getOrderListWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getCountriesWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (void)getCreditCardListWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)addCreditCardWithCardNumber:(NSString*)cardNumber
                        expiryMonth:(NSString*)expiryMonth
                         expiryYear:(NSString*)expiryYear
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)deleteCreditCardWithCardId:(NSString*)cardId
                               pan:(NSString*)pan
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)makeFavouriteCreditCardWithCardId:(NSString*)cardId
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getMagicOrderWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)addMagicOrderWithOrderDetails:(NSMutableArray*)orderDetails
                               cardId:cardId
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)payByTokenWithOrderID:(NSString*)orderId
                       cardId:cardId
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
