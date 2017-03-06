//
//  Define.h
//  BeaconApp


#ifndef BeaconApp_Define_h
#define BeaconApp_Define_h

#define Parse_ApplicationID                 @"QtasBN3UJ0Gto57sV9wf5TCiPxy3YTKGGhTx67nD"
#define Parse_ClientKey                     @"8RToFfYAT6Vd7kZOIhOVhs7KzdYjj634Gf7ElkQf"


#define Documents_Folder                    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define ServerUrl                           [[[NSBundle mainBundle] infoDictionary] valueForKey:@"GOAPIServerURL"]
#define LoginUrl                            [[ServerUrl stringByAppendingPathComponent:@"user/login"] stringByAppendingString:@"/"]
#define SignupUrl                           [[ServerUrl stringByAppendingPathComponent:@"user/register"] stringByAppendingString:@"/"]
#define VerifyAddressUrl                    [ServerUrl stringByAppendingPathComponent:@"user/verifyaddress"]
#define UpdateProfileUrl                    [[ServerUrl stringByAppendingPathComponent:@"user/updateProfile"] stringByAppendingString:@"/"]
#define ResetPasswordUrl                    [[ServerUrl stringByAppendingPathComponent:@"user/resetPassword"] stringByAppendingString:@"/"]
#define ProductListUrl                      [ServerUrl stringByAppendingPathComponent:@"product/list"]
#define OrderCalculateUrl                   [[ServerUrl stringByAppendingPathComponent:@"order/calculate"] stringByAppendingString:@"/"]
#define OrderPlaceUrl                       [[ServerUrl stringByAppendingPathComponent:@"order/placeOrder"] stringByAppendingString:@"/"]
#define OrderListUrl                        [[ServerUrl stringByAppendingPathComponent:@"order/list"] stringByAppendingString:@"/"]
#define CountryListUrl                      [ServerUrl stringByAppendingPathComponent:@"library/getCountryCodes"]
#define PlaceIncompleteOrderUrl             [[ServerUrl stringByAppendingPathComponent:@"order/placeIncompleteOrder"] stringByAppendingString:@"/"]
#define PlaceConfirmOrderUrl                [[ServerUrl stringByAppendingPathComponent:@"order/confirmOrder"] stringByAppendingString:@"/"]
#define TermsPageUrl                        @"http://www.gotoskincare.com/apiv2/pages/terms/"
#define HelpPageUrl                         @"http://www.gotoskincare.com/apiv2/pages/help/"
#define MagicOrderHelpPageUrl               @"http://www.gotoskincare.com/apiv2/pages/magicOrder/"
#define CreditCardListUrl                   [[ServerUrl stringByAppendingPathComponent:@"user/creditCardList"] stringByAppendingString:@"/"]
#define CreditCardAddUrl                    [[ServerUrl stringByAppendingPathComponent:@"user/creditCardAdd"] stringByAppendingString:@"/"]
#define CreditCardDeleteUrl                 [[ServerUrl stringByAppendingPathComponent:@"user/creditCardDelete"] stringByAppendingString:@"/"]
#define CreditCardMakeFavouriteUrl          [[ServerUrl stringByAppendingPathComponent:@"user/creditCardMakeFavourite"] stringByAppendingString:@"/"]
#define GetMagicOrderUrl                    [[ServerUrl stringByAppendingPathComponent:@"magicOrders/getMagicOrder"] stringByAppendingString:@"/"]
#define AddMagicOrderUrl                    [[ServerUrl stringByAppendingPathComponent:@"magicOrders/addMagicOrder"] stringByAppendingString:@"/"]
#define PayByTokenUrl                       [[ServerUrl stringByAppendingPathComponent:@"order/payByToken"] stringByAppendingString:@"/"]


//#define ApiToken                            @"DJG93HFQ7"

#define Sandbox_ClientID                    @"AQq6gYTF1MVJ8zRXRCNZHsgifm44YND0jsd45gBfomaiakJHASTdTrZq9ZIUXeBRi4gBhoRUst6E8jt2"     // Stefan's
//#define Sandbox_ClientID                    @"AbZqAzcb3E_kpYqUkE9320oLAUME7p4FoSxILMEfmQu1Ktahb3StMeo2suPrIryKgk3AHEvsLTT10gyv"     // Luokey's
#define Live_ClientID                       @"AQ6_uhnuoSuC17mfHdmcTIxj5PYyGlv0Vkp2RNlXe3R_MAzXr32PPju1fhE6hwku_g0on2zBILTEM2Ae"

#define GA_ID                               @"UA-646016-40"

#define GA_SCREENNAME_FAST_ORDER            @"Fast Order"
#define GA_SCREENNAME_MAGIC_ORDER           @"Magic Order"
#define GA_SCREENNAME_MY_PROFILE            @"My Profile"
#define GA_SCREENNAME_ORDER_HISTORY         @"Order History"
#define GA_SCREENNAME_TERMS_OF_USE          @"Terms of Use"
#define GA_SCREENNAME_HELP                  @"Help"


#define gsc_user_details                    @"gsc_user_details"
#define gsc_user_is_guest_login             @"gsc_user_is_guest_login"


#define ScreenBounds                        [UIScreen mainScreen].bounds

#define SecondsInAMin                       60
#define MinsInAnHour                        60
#define HoursInADay                         24
#define DaysInAMonth                        30
#define MonthsInAYear                       12


#define Segue_ShowLogin                     @"ShowLogin"
#define Segue_ShowSignupVC                  @"ShowSignupVC"
#define Segue_ShowForgotPasswordVC          @"ShowForgotPasswordVC"
#define Segue_ShowMainVC                    @"ShowMainVC"
#define Segue_ShowMainVCWithoutAnimation    @"ShowMainVCWithoutAnimation"
#define Segue_ShowLeftMenu                  @"ShowLeftMenu"
#define Segue_ShowRightMenu                 @"ShowRightMenu"
#define Segue_ContentSegue                  @"ContentSegue"
#define Segue_ShowFastOrderVC               @"ShowFastOrderVC"
#define Segue_ShowMagicOrderVC              @"ShowMagicOrderVC"
#define Segue_ShowProfileVC                 @"ShowProfileVC"
#define Segue_ShowProfileVCModally          @"ShowProfileVCModally"
#define Segue_ShowTermsVC                   @"ShowTermsVC"
#define Segue_ShowHelpVC                    @"ShowHelpVC"
#define Segue_ShowHistoryVC                 @"ShowHistoryVC"
#define Segue_Logout                        @"Logout"
#define Segue_ShowOrderDetailVC             @"ShowOrderDetailVC"
#define Segue_ShowOrderResultVC             @"ShowOrderResultVC"
#define Segue_ShowHistoryDetailVC           @"ShowHistoryDetailVC"
#define Segue_ShowCountriesVC               @"ShowCountriesVC"
#define Segue_ShowPaypalVC                  @"ShowPaypalVC"
#define Segue_ShowPaypalResultVC            @"ShowPaypalResultVC"
#define Segue_UnWindToSettingsVC            @"UnWindToSettingsVC"
#define Segue_UnWindToLoginVC               @"UnWindToLoginVC"
//#define Segue_UnWindToSingupVC              @"UnWindToSingupVC"
#define Segue_UnWindToProfileVC             @"UnWindToProfileVC"
#define Segue_UnWindToOrderDetailVC         @"UnWindToOrderDetailVC"
#define Segue_ShowLoginManagerVC            @"ShowLoginManagerVC"
#define Segue_UnWindToLoginManagerVC        @"UnWindToLoginManagerVC"
#define Segue_ShowMagicHelpVC               @"ShowMagicHelpVC"
#define Segue_UnWindToMagicOrderVC          @"UnWindToMagicOrderVC"
#define Segue_ShowCreditCardVC              @"ShowCreditCardVC"
#define Segue_ShowCreditCardVCModally       @"ShowCreditCardVCModally"


// Notification Keys
#define Notification_UserLocationUpdated                    @"UserLocationUpdated"
#define Notification_UserLocationUpdateFailed               @"UserLocationUpdateFailed"
#define Notification_LocationAuthorizationStatusChanged     @"LocationAuthorizationStatusChanged"
#define Notification_LocationSettingUpdated                 @"LocationSettingUpdated"
#define Notification_DistanceUnitUpdated                    @"DistanceUnitUpdated"
#define Notification_TravelModeUpdated                      @"TravelModeUpdated"
#define Notification_DisplayAccessTimeUpdated               @"DisplayAccessTimeUpdated"


#define MainTintColor                       [UIColor colorWithRed:250/255.f green:190/255.f blue:165/255.f alpha:1.f]
#define GreenColor                          [UIColor colorWithRed:14/255.f green:140/255.f blue:69/255.f alpha:1.f]
#define GreyColor                           [UIColor colorWithRed:62/255.f green:69/255.f blue:73/255.f alpha:1.f]
#define LightGreyColor                      [UIColor colorWithRed:159/255.f green:170/255.f blue:177/255.f alpha:1.f]
#define ProductBorderColor                  [UIColor colorWithRed:214/255.f green:214/255.f blue:214/255.f alpha:1.f]


#define Frequencies                         @[@"Never", @"Every week", @"Every 2 weeks", @"Every 3 weeks", @"Every 4 weeks", @"Every 5 weeks", @"Every 6 weeks", @"Every 7 weeks", @"Every 8 weeks"]


#define key_success                         @"success"
#define key_message                         @"message"

#define key_apitoken                        @"apitoken"
#define key_user                            @"user"
#define key_userId                          @"userId"
#define key_userid                          @"userid"

#define key_nickname                        @"nickname"
#define key_email                           @"email"
#define key_password                        @"password"
#define key_name                            @"name"
#define key_firstname                       @"firstname"
#define key_surname                         @"surname"
#define key_company                         @"company"

#define key_address                         @"address"
#define key_address_country                 @"address_country"
#define key_address_street                  @"address_street"
#define key_address_street_2                @"address_street_2"
#define key_address_suburb                  @"address_suburb"
#define key_address_state                   @"address_state"
#define key_address_postcode                @"address_postcode"

#define key_isValidAddress                  @"isValidAddress"
#define key_recommendations                 @"recommendations"

#define key_countries                       @"countries"
#define key_country                         @"country"
#define key_code                            @"code"
#define key_label                           @"label"

#define key_products                        @"products"
#define key_productName                     @"productName"
#define key_productId                       @"productId"
#define key_price                           @"price"
#define key_priceCurrency                   @"priceCurrency"
#define key_priceCurrencySymbol             @"priceCurrencySymbol"
#define key_detail                          @"detail"
#define key_imageUrlSmall                   @"imageUrlSmall"
#define key_imageUrlMedium                  @"imageUrlMedium"
#define key_imageUrlLarge                   @"imageUrlLarge"

#define key_orders                          @"orders"
#define key_order                           @"order"
#define key_orderId                         @"orderId"
#define key_orderid                         @"orderid"
#define key_items                           @"items"
#define key_amount                          @"amount"
#define key_sendExpress                     @"sendExpress"
#define key_isGift                          @"isGift"
#define key_itemPrice                       @"itemPrice"
#define key_productsPrice                   @"productsPrice"
#define key_shippingPrice                   @"shippingPrice"
#define key_shippingName                    @"shippingName"
#define key_shippingCode                    @"shippingCode"
#define key_totalPrice                      @"totalPrice"
#define key_status                          @"status"
#define key_placeDate                       @"placeDate"
#define key_countryCode                     @"countryCode"

#define key_sku                             @"sku"
#define key_payPal_reference                @"payPal_reference"
#define key_response                        @"response"
#define key_id                              @"id"
#define key_address_to                      @"address_to"

#define key_cardnumber                      @"cardnumber"
#define key_UserId                          @"UserId"
#define key_expirymonth                     @"expirymonth"
#define key_expiryyear                      @"expiryyear"
#define key_cardid                          @"cardid"
#define key_pan                             @"pan"
#define key_favourite                       @"favourite"
#define key_cards                           @"cards"

#define key_frequency                       @"frequency"
#define key_magicOrders                     @"magicOrders"
#define key_nextorderdate                   @"nextorderdate"
#define key_orderDetails                    @"orderDetails"

#define key_expirymonth                     @"expirymonth"
#define key_expirymonth                     @"expirymonth"
#define key_expirymonth                     @"expirymonth"



#define Suffix_24_hours                     @"24 hours"
#define Suffix_am                           @"am"
#define Suffix_pm                           @"pm"


#define PedestrianSpeed                     0.75f    // 0.75 m/s
#define VehicleSpeed                        1.5f    // 1.5 m/s


typedef enum MenuItem
{
    MenuItem_FastOrder = 0,
    MenuItem_MagicOrder = 1,
    MenuItem_Profile = 2,
    MenuItem_History = 3,
    MenuItem_Terms = 4,
    MenuItem_Help = 5,
    MenuItem_Logout = 6,
}
MenuItem;

typedef enum Weekday
{
    Weekday_Sunday = 1,
    Weekday_Monday = 2,
    Weekday_Tuesday = 3,
    Weekday_Wednesday = 4,
    Weekday_Thursday = 5,
    Weekday_Friday = 6,
    Weekday_Saturday = 7,
}
Weekday;

typedef enum UnitType
{
    UnitType_Distance = 0,
    UnitType_TravelMode = 1,
    UnitType_AccessTime = 2,
}
UnitType;

typedef enum GSCAlertType
{
    GSCAlertType_Alert = 0,
    GSCAlertType_Confirm = 1,
}
GSCAlertType;

typedef enum ProfileSourceType
{
    ProfileSourceType_LeftMenu = 0,
    ProfileSourceType_Login = 1,
    ProfileSourceType_OrderDetail = 2,
}
ProfileSourceType;


#define CoreDataEntity_GSCProduct                   @"GSCProduct"
#define CoreDataEntity_GSCOrder                     @"GSCOrder"

#define CoreDataAttribute_detail                    @"detail"
#define CoreDataAttribute_imageUrlLarge             @"imageUrlLarge"
#define CoreDataAttribute_imageUrlMedium            @"imageUrlMedium"
#define CoreDataAttribute_imageUrlSmall             @"imageUrlSmall"
#define CoreDataAttribute_price                     @"price"
#define CoreDataAttribute_priceCurrency             @"priceCurrency"
#define CoreDataAttribute_priceCurrencySymbol       @"priceCurrencySymbol"
#define CoreDataAttribute_productId                 @"productId"
#define CoreDataAttribute_productName               @"productName"

#define CoreDataAttribute_hours_open                @"hours_open"
#define CoreDataAttribute_install_Name              @"install_Name"
#define CoreDataAttribute_installation              @"installation"
#define CoreDataAttribute_latitude                  @"latitude"
#define CoreDataAttribute_location_des              @"location_des"
#define CoreDataAttribute_longitude                 @"longitude"
#define CoreDataAttribute_nav                       @"nav"
#define CoreDataAttribute_unit_Model                @"unit_Model"



#endif
