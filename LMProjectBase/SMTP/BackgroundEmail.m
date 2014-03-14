//
//  BackgroundEmail.m
//  OnTheRoad
//
//  Created by Robert Kalecinski on 23.01.2014.
//
//

#import "BackgroundEmail.h"
#import <NSData+Base64Additions.h>

@interface BackgroundEmail ()
{
    @protected
        __strong SKPSMTPMessage *mail;
    
    @private
        NSMutableArray *emailParts;
        SKPSMTPState emailSendState;
        NSError *emailSendError;
        __strong BackgroundEmail *s_Self;
}

+ (NSDictionary*)createSKPSMTPEmailAttachment:(NSString*)name
                                     withData:(NSData*)data;

@end

@implementation BackgroundEmail

@synthesize subject = _subject;
@synthesize body = _body;

- (id)initWithSubject:(NSString*) subject
      withInputString:(NSString*) inputString
   toDestinationEmail:(NSString*) destinationEmail
      completionBlock:(BackgroundEmailCompletionBlock)completionBlock
{
    if(self = [super init]){
        mail = [[SKPSMTPMessage alloc] init];
        
        s_Self = self;
        
        NSParameterAssert(subject);
        NSParameterAssert(inputString);
        NSParameterAssert(destinationEmail);
        
        mail.toEmail = destinationEmail;
        
        NSString *pathForSettings = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        NSAssert(pathForSettings, @"There is no settings.plist in your bundle");
        
        NSDictionary *mailSettingsDictionary = [[NSDictionary dictionaryWithContentsOfFile:pathForSettings] valueForKey:@"mailSettings"];
        NSAssert(mailSettingsDictionary, @"Your settings.plist should contain \"mailSettings\" key");
        
        NSString *fromEmail = [mailSettingsDictionary valueForKey:@"fromEmail"];
        NSAssert(fromEmail, @"\"mailSettings\" does not contain \"fromEmail\" key");
        mail.fromEmail = fromEmail;
        
        NSString *relayHost = [mailSettingsDictionary valueForKey:@"relayHost"];
        NSAssert(relayHost, @"\"mailSettings\" does not contain \"relayHost\" key");
        mail.relayHost = relayHost;
        
        NSArray *relayPorts = [mailSettingsDictionary valueForKey:@"relayPorts"];
        NSAssert(relayPorts, @"\"mailSettings\" does not contain \"relayPorts\" key");
        mail.relayPorts = relayPorts;
        
        NSNumber *requiresAuth = [NSNumber numberWithBool:(BOOL)[mailSettingsDictionary valueForKey:@"requiresAuth"]];
        NSAssert(requiresAuth, @"\"mailSettings\" does not contain \"requiresAuth\" key");
        mail.requiresAuth = requiresAuth.boolValue;
        
        NSString *login = [mailSettingsDictionary valueForKey:@"login"];
        NSAssert(login, @"\"mailSettings\" does not contain \"login\" key");
        mail.login = login;
        
        NSString *password = [mailSettingsDictionary valueForKey:@"password"];
        NSAssert(password, @"\"mailSettings\" does not contain \"password\" key");
        mail.pass = password;
        
        NSNumber *wantsSecure = [NSNumber numberWithBool:(BOOL)[mailSettingsDictionary valueForKey:@"wantsSecure"]];
        NSAssert(wantsSecure, @"\"mailSettings\" does not contain \"wantsSecure\" key");
        mail.wantsSecure = wantsSecure.boolValue;
        
        mail.subject = subject;
        mail.inputString = [inputString mutableCopy];
        
        emailParts = [[NSMutableArray alloc] init];
        
        _completionBlock = completionBlock;
        
        mail.delegate = self;
    }
    return self;
}

- (void)setSubject:(NSString *)subject
{
    mail.subject = subject;
}

- (NSString*)subject
{
    return mail.subject;
}

- (void)setBody:(NSString *)body
{
    [emailParts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           @"text/plain",   kSKPSMTPPartContentTypeKey,
                           body,            kSKPSMTPPartMessageKey,
                           @"8bit",         kSKPSMTPPartContentTransferEncodingKey,nil]];
}

- (NSString*)body
{
    for(NSDictionary* part in emailParts){
        for(NSString* key in part.allKeys){
            if([key isEqualToString:kSKPSMTPPartMessageKey])
                return [part valueForKey:kSKPSMTPPartMessageKey];
        }
    }
    return nil;
}

-(void)messageSent:(SKPSMTPMessage *)message
{
    emailSendState = kSKPSMTPMessageSent;
    
    if(self.completionBlock)
    {
        self.completionBlock(self, nil);
    }
    
    s_Self = nil;
}

-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    emailSendState = kSKPSMTPIdle;
    emailSendError = error;
    
    if(self.completionBlock)
    {
        self.completionBlock(self, error);
    }
    
    s_Self = nil;
}

- (void)send
{
    mail.parts = emailParts;
    
    emailSendState = kSKPSMTPConnecting;
    
    [mail send];
}

- (void)sendWaitingUntilFinished:(NSError**)error
{
    [self send];
    
    //Poll a send state
    while(emailSendState != kSKPSMTPMessageSent && emailSendState != kSKPSMTPIdle)
    {
        // Allow the run loop to do some processing of the stream
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    
    *error = emailSendError;
}

- (void)addAttachment:(NSString*)name withData:(NSData*)data
{
    [emailParts addObject:[BackgroundEmail createSKPSMTPEmailAttachment:name withData:data]];
}

+ (NSDictionary*)createSKPSMTPEmailAttachment:(NSString*)name withData:(NSData*)data
{
    NSString *directory = @"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"";
    directory = [directory stringByAppendingFormat:@"%@", name];
    directory = [directory stringByAppendingFormat:@"\""];
    NSString *attachment = @"attachment;\r\n\tfilename=\"";
    attachment = [attachment stringByAppendingFormat:@"%@", name];
    attachment = [attachment stringByAppendingFormat:@"\""];
    NSDictionary *attachmentPart = [NSDictionary dictionaryWithObjectsAndKeys:
                                    directory,kSKPSMTPPartContentTypeKey,
                                    attachment,kSKPSMTPPartContentDispositionKey,
                                    [data encodeBase64ForData],kSKPSMTPPartMessageKey,
                                    @"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    return attachmentPart;
}

@end
