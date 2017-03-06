//
//  NTServiceManager+NTNotificationHandling.h
//  NoteThemes
//


#import <AWSCore/AWSCore.h>
#include <AWSSNS/AWSSNS.h>

@interface GOServiceManager : NSObject {
    
}

//Get the endpointArn. Only available after correct device registration to Amazon
@property (nonatomic,readonly) NSString* endpointArn;
@property (nonatomic, strong) AWSCognitoCredentialsProvider* cognitoCredentialsProvider;

+ (instancetype)sharedServiceManager;

/*
 * Call this after the device has successfully done push notification registration. 
 */
- (void)registerDeviceWithDeviceTokenData:(NSData*)deviceTokenData
                                withBlock:(void(^)(NSString* endpointArn, NSError* error))block;

- (void)registerGenericTopicWithBlock:(void(^)(NSError* error))block;

@end
