//
//  APIManager.m
//  GoSkinCare
//


#import "APIManager.h"

@implementation APIManager

+ (APIManager*)sharedManager {
    
    static APIManager* _sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (AFHTTPRequestOperationManager*)operationManager {
    
    AFHTTPRequestOperationManager* operationManager = [AFHTTPRequestOperationManager manager];
    
    // test code to mark json format
//    operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operationManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:
                                                                    @"application/x-www-form-urlencoded",
                                                                    @"application/json",
                                                                    @"text/plain",
                                                                    @"text/html",
                                                                    nil]];
    
//    if (self.apiToken)
//        [operationManager.requestSerializer setValue:self.apiToken forHTTPHeaderField:key_apitoken];
    
    return operationManager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.apiToken = [[NSBundle mainBundle] objectForInfoDictionaryKey:key_apitoken];
    }
    
    return self;
}

- (NSString*)jsonStringWithJsonDict:(NSDictionary*)jsonDict {
    NSString* jsonString = @"";
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:nil];
    if (jsonData)
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

- (NSString*)deviceToken {
    NSString* uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    if (uuid && uuid.length > 0)
        return uuid;
    return @"";
}

- (NSString*)getUserId {
    NSDictionary* userDetails = [self getUserDetails];
    if (userDetails && [userDetails isKindOfClass:[NSDictionary class]]) {
        return [userDetails objectForKey:key_userId];
    }
    return nil;
}

- (NSDictionary*)getUserDetails {
    return [[NSUserDefaults standardUserDefaults] valueForKey:gsc_user_details];
}

- (void)saveUserDetails:(NSDictionary*)userInfo {
    if (!userInfo) {
        return;
    }
    
    //A hack fix here. The userId field that should be returned by server is mistaken as "userid"
    if (userInfo[@"userid"] && !userInfo[key_userId]) {
        userInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        [(NSMutableDictionary*)userInfo setObject:userInfo[@"userid"] forKey:key_userId];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:gsc_user_details];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isUserLoggedIn {
    NSString* userId = [self getUserId];
    return userId && userId.length > 0;
}

- (NSString*)getUrlWith:(NSString*)mainUrl {
    NSString* urlString = [mainUrl stringByAppendingFormat:@"?%@=%@", key_apitoken, self.apiToken];
    return urlString;
}

- (NSString*)formattedUserName {
    NSDictionary* userDetails = [self getUserDetails];
    NSString* userName = [NSString stringWithFormat:@"%@ %@",
                          userDetails[key_firstname],
                          userDetails[key_surname]];
    return userName;
}

- (NSString*)formattedAddress {
    NSDictionary* userDetails = [self getUserDetails];
    NSString* address = [NSString stringWithFormat:@"%@, %@, %@ %@",
                         userDetails[key_address_street],
                         userDetails[key_address_suburb],
                         userDetails[key_address_state],
                         userDetails[key_address_postcode]];
    return address;
}

#pragma mark -
#pragma mark - // Apis

- (void)loginWithEmail:(NSString*)email
              password:(NSString*)password
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_apitoken: self.apiToken,
                             key_email: email,
                             key_password: password
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:LoginUrl parameters:params success:success failure:failure];
}

- (void)verifyAddressWithCountryCode:(NSString*)countryCode
                              street:(NSString*)street
                             street2:(NSString*)street2
                              suburb:(NSString*)suburb
                               state:(NSString*)state
                            postCode:(NSString*)postCode
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_address_country: countryCode,
                             key_address_street: street,
                             key_address_street_2: street2,
                             key_address_suburb: suburb,
                             key_address_state: state,
                             key_address_postcode: postCode
                             };
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:[self getUrlWith:VerifyAddressUrl] parameters:params success:success failure:failure];
}

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
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_apitoken: self.apiToken,
                             key_firstname: firstname,
                             key_surname: surname,
                             key_nickname: nickname,
                             key_email: email,
                             key_password: password,
                             key_company: company,
                             key_address_country: countryCode,
                             key_address_street: street,
                             key_address_street_2: street2,
                             key_address_suburb: suburb,
                             key_address_state: state,
                             key_address_postcode: postCode
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:SignupUrl parameters:params success:success failure:failure];
}

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
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    
    if (createProfile) {
        NSDictionary* params = @{key_apitoken: self.apiToken,
                                 key_firstname: firstname,
                                 key_surname: surname,
                                 key_nickname: nickname,
                                 key_email: email,
                                 key_password: password,
                                 key_company: company,
                                 key_address_country: countryCode,
                                 key_address_street: street,
                                 key_address_street_2: street2,
                                 key_address_suburb: suburb,
                                 key_address_state: state,
                                 key_address_postcode: postCode
                                 };
        [operationManager POST:SignupUrl parameters:params success:success failure:failure];
    }
    else {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:@{key_apitoken: self.apiToken,
                                                                                      key_userId: [self getUserId],
                                                                                      key_firstname: firstname,
                                                                                      key_surname: surname,
                                                                                      key_nickname: nickname,
                                                                                      key_email: email,
                                                                                      key_password: password,
                                                                                      key_company: company,
                                                                                      key_address_country: countryCode,
                                                                                      key_address_street: street,
                                                                                      key_address_street_2: street2,
                                                                                      key_address_suburb: suburb,
                                                                                      key_address_state: state,
                                                                                      key_address_postcode: postCode
                                                                                      }];
        NSString* oldPassword = [self getUserDetails][key_password];
        if (!password || [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1 || [password isEqualToString:oldPassword]) {
            [params removeObjectForKey:key_password];
        }
        [operationManager POST:UpdateProfileUrl parameters:params success:success failure:failure];
    }
}

- (void)resetPasswordWithEmail:(NSString*)email
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_apitoken: self.apiToken,
                             key_email: email
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:ResetPasswordUrl parameters:params success:success failure:failure];
}

- (void)getProductListWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:[self getUrlWith:ProductListUrl] parameters:nil success:success failure:failure];
}

- (void)calculateOrderPriceWithOrder:(NSDictionary*)order
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:order];
    [params setObject:self.apiToken forKey:key_apitoken];
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:OrderCalculateUrl parameters:params success:success failure:failure];
}

- (void)placeOrderPriceWithOrder:(NSDictionary*)order
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:order];
    [params setObject:self.apiToken forKey:key_apitoken];
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:OrderPlaceUrl parameters:params success:success failure:failure];
}

- (void)placeIncompleteOrderWithOrder:(NSDictionary*)order
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:order];
    [params setObject:self.apiToken forKey:key_apitoken];
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:PlaceIncompleteOrderUrl parameters:params success:success failure:failure];
}

- (void)confirmOrderWithOrderID:(NSString*)orderId
                paypalReference:(NSString*)paypalReference
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_apitoken: self.apiToken,
                             key_orderId: orderId,
                             key_payPal_reference: paypalReference
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:PlaceConfirmOrderUrl parameters:params success:success failure:failure];
}

- (void)getOrderListWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_apitoken: self.apiToken,
                             key_userId: [self getUserId]
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:OrderListUrl parameters:params success:success failure:failure];
}

- (void)getCountriesWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:[self getUrlWith:CountryListUrl] parameters:nil success:success failure:failure];
}


- (void)getCreditCardListWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_apitoken: self.apiToken,
//                             key_UserId: @"742" //[self getUserId]
                             key_UserId: [self getUserId]
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:CreditCardListUrl parameters:params success:success failure:failure];
}

- (void)addCreditCardWithCardNumber:(NSString*)cardNumber
                        expiryMonth:(NSString*)expiryMonth
                         expiryYear:(NSString*)expiryYear
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_apitoken: self.apiToken,
                             key_UserId: [self getUserId],
                             key_cardnumber: cardNumber,
                             key_expirymonth: expiryMonth,
                             key_expiryyear: expiryYear
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:CreditCardAddUrl parameters:params success:success failure:failure];
}

- (void)deleteCreditCardWithCardId:(NSString*)cardId
                               pan:(NSString*)pan
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_apitoken: self.apiToken,
                             key_UserId: [self getUserId],
                             key_cardid: cardId,
                             key_pan: pan
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:CreditCardDeleteUrl parameters:params success:success failure:failure];
}

- (void)makeFavouriteCreditCardWithCardId:(NSString*)cardId
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_apitoken: self.apiToken,
                             key_UserId: [self getUserId],
                             key_cardid: cardId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:CreditCardMakeFavouriteUrl parameters:params success:success failure:failure];
}

- (void)getMagicOrderWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_apitoken: self.apiToken,
                             key_UserId: [self getUserId]
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:GetMagicOrderUrl parameters:params success:success failure:failure];
}

- (void)addMagicOrderWithOrderDetails:(NSMutableArray*)orderDetails
                               cardId:cardId
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* magicOrdersInfo = @{key_UserId: [self getUserId],
                                      key_cardid: cardId,
                                      key_orderDetails: orderDetails
                                      };
    NSArray* magicOrders = @[magicOrdersInfo];
//    NSString* jsonMagicOrders = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:magicOrders options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
    NSDictionary* params = @{key_apitoken: self.apiToken,
//                             key_magicOrders: jsonMagicOrders
                             key_magicOrders: magicOrders
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:AddMagicOrderUrl parameters:params success:success failure:failure];
}

- (void)payByTokenWithOrderID:(NSString*)orderId
                       cardId:cardId
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{key_apitoken: self.apiToken,
                             key_userid: [self getUserId],
                             key_orderId: orderId,
                             key_cardid: cardId
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager POST:PayByTokenUrl parameters:params success:success failure:failure];
}


@end
