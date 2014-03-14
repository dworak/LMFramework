//
//  BackgroundEmail.h
//  OnTheRoad
//
//  Created by Robert Kalecinski on 23.01.2014.
//
//

#import <Foundation/Foundation.h>

#import "SKPSMTPMessage.h"

@class BackgroundEmail;

typedef void (^BackgroundEmailCompletionBlock) (BackgroundEmail *message, NSError* error);

@interface BackgroundEmail : NSObject<SKPSMTPMessageDelegate>

@property (nonatomic, strong) __block BackgroundEmailCompletionBlock completionBlock;
@property (nonatomic, assign) NSString* subject;
@property (nonatomic, assign) NSString* body;

- (id)initWithSubject:(NSString*) subject
      withInputString:(NSString*) inputString
   toDestinationEmail:(NSString*) destinationEmail
      completionBlock:(BackgroundEmailCompletionBlock)completionBlock;

- (void)send;
- (void)sendWaitingUntilFinished:(NSError**)error;
- (void)setCompletionBlock:(BackgroundEmailCompletionBlock)completionBlock;
- (void)addAttachment:(NSString*)name withData:(NSData*)data;

@end

@interface BackgroundEmailCrashlog : BackgroundEmail

@end

@interface BackgroundEmailPfgInteractionFail : BackgroundEmail

@end
