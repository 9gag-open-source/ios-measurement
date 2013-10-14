/*
 * Copyright 2013 Quantcast Corp.
 *
 * This software is licensed under the Quantcast Mobile App Measurement Terms of Service
 * https://www.quantcast.com/learning-center/quantcast-terms/mobile-app-measurement-tos
 * (the “License”). You may not use this file unless (1) you sign up for an account at
 * https://www.quantcast.com and click your agreement to the License and (2) are in
 * compliance with the License. See the License for the specific language governing
 * permissions and limitations under the License.
 *
 */
#import "QuantcastMeasurement+Networks.h"
#import "QuantcastMeasurement+Internal.h"
#import "QuantcastEvent.h"
#import "QuantcastParameters.h"

@implementation QuantcastMeasurement (Networks)

-(NSString*)beginMeasurementSessionWithAPIKey:(NSString*)inQuantcastAPIKey
                            attributedNetwork:(NSString*)inNetworkPCode
                               userIdentifier:(NSString*)inUserIdentifierOrNil
                                    appLabels:(id<NSObject>)inAppLabelsOrNil
                                networkLabels:(id<NSObject>)inNetworkLabelsOrNil
                      appIsDirectedAtChildren:(BOOL)inIsAppDirectedAtChildren
{
    if (nil == inNetworkPCode) {
        NSLog(@"QC Measurement: ERROR - You must pass a network p-code in attributedNetwork: if you are going to start measurement with the Network form of beginMeasurementSessionWithAPIKey:");
        return nil;
    }
    
    NSString* hashedUserID = [self internalBeginSessionWithAPIKey:inQuantcastAPIKey attributedNetwork:inNetworkPCode userIdentifier:inUserIdentifierOrNil appLabels:inAppLabelsOrNil networkLabels:inNetworkLabelsOrNil appIsDeclaredDirectedAtChildren:inIsAppDirectedAtChildren];
    
    return hashedUserID;
}

-(void)endMeasurementSessionWithAppLabels:(id<NSObject>)inAppLabelsOrNil networkLabels:(id<NSObject>)inNetworkLabelsOrNil {
    if (!self.hasNetworkIntegration) {
        NSLog(@"QC Measurement: ERROR - The network form of endMeasurementSession should only be called for network integrations. Please see QuantcastMeasurement+Networks.h for more information");
    }
    
    [self internalEndMeasurementSessionWithAppLabels:inAppLabelsOrNil networkLabels:inNetworkLabelsOrNil];
}

-(void)pauseSessionWithAppLabels:(id<NSObject>)inAppLabelsOrNil networkLabels:(id<NSObject>)inNetworkLabelsOrNil {
    if (!self.hasNetworkIntegration) {
        NSLog(@"QC Measurement: ERROR - The network form of pauseSession should only be called for network integrations. Please see QuantcastMeasurement+Networks.h for more information");
    }

    [self internalPauseSessionWithAppLabels:inAppLabelsOrNil networkLabels:inNetworkLabelsOrNil];
}


-(void)resumeSessionWithAppLabels:(id<NSObject>)inAppLabelsOrNil networkLabels:(id<NSObject>)inNetworkLabelsOrNil {
    if (!self.hasNetworkIntegration) {
        NSLog(@"QC Measurement: ERROR - The network form of resumeSession should only be called for network integrations. Please see QuantcastMeasurement+Networks.h for more information");
    }
    
    [self internalResumeSessionWithAppLabels:inAppLabelsOrNil networkLabels:inNetworkLabelsOrNil];
}


-(NSString*)recordUserIdentifier:(NSString*)inUserIdentifierOrNil withAppLabels:(id<NSObject>)inAppLabelsOrNil networkLabels:(id<NSObject>)inNetworkLabelsOrNil {
    if (!self.hasNetworkIntegration) {
        NSLog(@"QC Measurement: ERROR - The network form of recordUserIdentifier should only be called for network integrations. Please see QuantcastMeasurement+Networks.h for more information");
    }
    
    return [self internalRecordUserIdentifier:inUserIdentifierOrNil withAppLabels:inAppLabelsOrNil networkLabels:inNetworkLabelsOrNil];
}


-(void)logEvent:(NSString*)inEventName withAppLabels:(id<NSObject>)inAppLabelsOrNil networkLabels:(id<NSObject>)inNetworkLabelsOrNil {
    if (!self.hasNetworkIntegration) {
        NSLog(@"QC Measurement: ERROR - The network form of logEvent should only be called for network integrations. Please see QuantcastMeasurement+Networks.h for more information");
    }
    
    [self internalLogEvent:inEventName withAppLabels:inAppLabelsOrNil networkLabels:inNetworkLabelsOrNil];
}

-(void)logNetworkEvent:(NSString*)inNetworkEventName withNetworkLabels:(id<NSObject>)inNetworkLabelsOrNil {
    if (!self.hasNetworkIntegration) {
        NSLog(@"QC Measurement: ERROR - logNetworkEvent:withNetworkLabels: should only be called for network integrations. Please see QuantcastMeasurement+Networks.h for more information");
    }
    
    if ( !self.isOptedOut ) {
        if (self.isMeasurementActive) {
            QuantcastEvent* e = [QuantcastEvent logNetworkEventEventWithEventName:inNetworkEventName eventNetworkLabels:inNetworkLabelsOrNil sessionID:self.currentSessionID applicationInstallID:self.appInstallIdentifier enforcingPolicy:self.policy];
             
            [self recordEvent:e];
        }
        else {
            NSLog(@"QC Measurement: logNetworkEvent:withNetworkLabels: was called without first calling beginMeasurementSession:");
        }
    }
}

@end
