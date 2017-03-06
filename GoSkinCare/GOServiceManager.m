//
//  NTServiceManager+NTNotificationHandling.m
//  NoteThemes
//


#import "GOServiceManager.h"

#include <AWSSNS/AWSSNS.h>

#define AWSSNSManagerKey @"nt_sns"
#define NTErrorDomain @"GOSkinCareError"
#define NTErrorCodeGenericError 1

static NSString* __endpointArn = nil;

@implementation GOServiceManager

+(instancetype)sharedServiceManager {
    
    static GOServiceManager* __instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //AWS setup
        __instance = [GOServiceManager new];
        
        {
            NSString* pool_id = @"us-east-1:355f3190-c8ad-4985-9732-b6625a6c62bc";
            NSString* auth = @"arn:aws:iam::666066526398:role/Cognito_GoToSkinCareAuth_Role";
            NSString* unauth = @"arn:aws:iam::666066526398:role/Cognito_GoToSkinCareUnauth_Role";
            
            AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                            identityPoolId:pool_id
                                                                                                             unauthRoleArn:unauth
                                                                                                               authRoleArn:auth
                                                                                                   identityProviderManager:nil];
            
            AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                                                                 credentialsProvider:credentialsProvider];
            
            [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
            __instance->_cognitoCredentialsProvider = credentialsProvider;
        }
        
    });
    
    return __instance;
}

- (NSString*)endpointArn {
    return __endpointArn;
}

- (void)registerDeviceWithDeviceTokenData:(NSData*)deviceTokenData
                                withBlock:(void(^)(NSString* endpointArn, NSError* error))block {
    
    NSString* deviceTokenString = [self deviceTokenAsString:deviceTokenData];
    
    //TEST. Put this into config file
    
    NSString* platformARN = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"AWSSNSPlatformARN"];
    
    if (!platformARN.length) {
        //No configuration
        NSError* error = [NSError errorWithDomain:NTErrorDomain code:NTErrorCodeGenericError
                                         userInfo:@{NSLocalizedDescriptionKey: @"AWSSNSPlatformARN configuration not found"}];
        if (block) {
            block(nil, error);
        }
        
        return;
    }
    //Get IdentityID
    /*
    [[self.cognitoCredentialsProvider getIdentityId] continueWithBlock:^id _Nullable(AWSTask * _Nonnull task) {
        if (task.error) {
            
        }
        return nil;
    }];
     */
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionAPSoutheast2
                                                                         credentialsProvider:self.cognitoCredentialsProvider];
    
    [AWSSNS registerSNSWithConfiguration:configuration forKey:AWSSNSManagerKey];
    AWSSNS *snsManager = [AWSSNS SNSForKey:AWSSNSManagerKey];
    
    
    AWSSNSCreatePlatformEndpointInput *platformEndpointRequest = [AWSSNSCreatePlatformEndpointInput new];
    platformEndpointRequest.customUserData = @"";
    platformEndpointRequest.token = deviceTokenString;
    platformEndpointRequest.platformApplicationArn = platformARN;
    
    //Register end point
    [[snsManager createPlatformEndpoint:platformEndpointRequest] continueWithBlock:^id(AWSTask *task) {
        
        if (task.error) {
            if (block) {
                block(nil, task.error);
            }
        }
        else if (task.result) {
            
            AWSSNSCreateEndpointResponse* rep = task.result;
            __endpointArn = rep.endpointArn;
            //Got rep.endpointArn;
            
            NSLog(@"AWS SNS registration result: %@", task.result);
            
            //All good
            if (block) {
                block(__endpointArn, nil);
            }
        };
        return nil;
    }];
};

- (void)registerGenericTopicWithBlock:(void(^)(NSError* error))block {
    if (!__endpointArn) {
        NSError* error = [NSError errorWithDomain:NTErrorDomain code:NTErrorCodeGenericError
                                         userInfo:@{NSLocalizedDescriptionKey: @"Can not register topic; need to register device with AWS SNS first. call registerDeviceWithDeviceTokenData after you get Push Notification token"}];
        //All good
        if (block) {
            block(error);
        }
    }
    else {
        AWSSNS *snsManager = [AWSSNS SNSForKey:AWSSNSManagerKey];
        
        //Next: do subscription on app-wide generic topic
        AWSSNSSubscribeInput *genericTopicSubscribeInput = [AWSSNSSubscribeInput new];
        genericTopicSubscribeInput.topicArn = @"arn:aws:sns:ap-southeast-2:666066526398:flydigital";
        genericTopicSubscribeInput.protocols = @"application";
        genericTopicSubscribeInput.endpoint = self.endpointArn;
        
        [[snsManager subscribe:genericTopicSubscribeInput] continueWithBlock:^id _Nullable(AWSTask * _Nonnull task) {
            if (block) {
                block(task.error);
            }
            return nil;
        }];
    }
}


#pragma mark - handle push notification registration
-(NSString*)deviceTokenAsString:(NSData*)deviceTokenData
{
    NSString *rawDeviceTring = [NSString stringWithFormat:@"%@", deviceTokenData];
    NSString *noSpaces = [rawDeviceTring stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tmp1 = [noSpaces stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    return [tmp1 stringByReplacingOccurrencesOfString:@">" withString:@""];
}

@end
