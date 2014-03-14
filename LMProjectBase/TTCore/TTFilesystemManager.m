//
//  TTFilesystemManager.m
//  TT
//
//  Created by Andrzej Auchimowicz on 05/07/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import "TTFilesystemManager.h"

#import "TTMacros.h"
#import "TTSystemInfo.h"

#include <CommonCrypto/CommonDigest.h>
#include <sys/xattr.h>

@implementation TTFilesystemManager

//MARK: Public methods

- (BOOL)createDirectory:(NSString*)dirPath withIntermediateDirectories:(bool)createIntermediates error:(NSError**)error
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:createIntermediates attributes:nil error:error];
}

- (NSArray*)listFilenamesOfFilesInDirectoryAtPath:(NSString*)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    NSArray* result = [fileManager contentsOfDirectoryAtPath:path error:&error];
    assert(!error);
    return result;
}

- (BOOL)isDirectoryOrFilePresentAtPath:(NSString*)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

- (NSString*)imagePathForBaseFilePath:(NSString*)filePath
{
    if (!filePath)
    {
        return nil;
    }
    
    NSBundle* tmpBundle = [[NSBundle alloc] initWithPath:[filePath stringByDeletingLastPathComponent]];
    return [self imagePathForBaseFileName:[filePath lastPathComponent] inBundle:tmpBundle];
}

- (NSString*)imagePathForBaseFileName:(NSString*)fileName inBundle:(NSBundle*)bundle
{
    if (!fileName)
    {
        return nil;
    }
    
#if DEBUG
    {
        NSString* baseFileName = [[fileName lastPathComponent] stringByDeletingPathExtension];
        NSRange postfixRange = [baseFileName rangeOfString:@"@2x" options:NSCaseInsensitiveSearch | NSBackwardsSearch];
        
        assert(postfixRange.location == NSNotFound || postfixRange.location + postfixRange.length < baseFileName.length);
    }
#endif
    
    assert([fileName pathExtension].length == 0);
    
    if (!bundle)
    {
        bundle = [NSBundle mainBundle];
    }
    
    NSString* result = nil;
    
    if ([TTSystemInfo rasterizationScale] == 1)
    {
        result = [bundle pathForResource:fileName ofType:@"png"];
        
        if (!result)
        {
            INFO(@"Falling back to retina for fileName:\n%@", fileName);
            result = [bundle pathForResource:[fileName stringByAppendingString:@"@2x"] ofType:@"png"];
        }
    }
    else
    {
        result = [bundle pathForResource:[fileName stringByAppendingString:@"@2x"] ofType:@"png"];
        
        if (!result)
        {
            INFO(@"Falling back to nonRetina for fileName:\n%@", fileName);
            result = [bundle pathForResource:fileName ofType:@"png"];
        }
    }
    
    assert(result);
    return result;
}

- (BOOL)moveFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath error:(NSError**)error
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager moveItemAtPath:fromPath toPath:toPath error:error];
}

- (BOOL)copyFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath error:(NSError**)error
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager copyItemAtPath:fromPath toPath:toPath error:error];
}

- (BOOL)deleteFileAtPath:(NSString*)filePath error:(NSError**)error
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:error];
}

- (BOOL)deleteDirectoryAtPath:(NSString*)dirPath evenWhenNotEmpty:(BOOL)evenWhenNotEmpty error:(NSError**)error
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    
    if ([fileManager fileExistsAtPath:dirPath isDirectory:&isDir])
    {
        if (!isDir)
        {
            if (error)
            {
                *error = TT_MAKE_ERROR([self class], 1, nil);
            }
            
            return NO;
        }
        
        if (isDir && !evenWhenNotEmpty)
        {
            if ([fileManager contentsOfDirectoryAtPath:dirPath error:error].count > 0)
            {
                if (error)
                {
                    *error = TT_MAKE_ERROR([self class], 1, nil);
                }
                
                return NO;
            }
            
            if (error && *error)
            {
                return NO;
            }
        }
    }
    else
    {
        if (error)
        {
            *error = TT_MAKE_ERROR([self class], 1, nil);
        }
        
        WARN(@"Directory or file %@ does not exist.", dirPath);
        return NO;
    }
    
    return [fileManager removeItemAtPath:dirPath error:error];
}

- (BOOL)mergeDirectoryAtPath:(NSString*)sourceDirectory intoDirectoryAtPath:(NSString*)destinationDirectory overwrittingFilesAtDestination:(BOOL)overwrittingFilesAtDestination error:(NSError**)error
{
    NSFileManager* fileManager = [ NSFileManager defaultManager];
    
    NSArray* keys = @[ NSURLIsDirectoryKey ];
    
    NSDirectoryEnumerator* enumerator = [fileManager enumeratorAtURL:[NSURL fileURLWithPath:sourceDirectory] includingPropertiesForKeys:keys options:0 errorHandler:^(NSURL* url, NSError* error)
        {
            return NO;
        }];
    
    // Make sure that both paths end with or without /
    
    NSString* tmp = [sourceDirectory lastPathComponent];
    sourceDirectory = [[sourceDirectory stringByDeletingLastPathComponent] stringByAppendingPathComponent:tmp];
    
    tmp = [destinationDirectory lastPathComponent];
    destinationDirectory = [[destinationDirectory stringByDeletingLastPathComponent] stringByAppendingPathComponent:tmp];
    
    for (NSURL* url in enumerator)
    {
        NSError* error;
        NSNumber* isDirectory = nil;
        
        if (![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error])
        {
            return NO;
        }
        else
        {
            if (![isDirectory boolValue])
            {
                @autoreleasepool
                {
                    NSString* tmpPath = [url path];
                    NSRange tmpRange = [tmpPath rangeOfString:sourceDirectory];
                    
                    tmpPath = [tmpPath stringByReplacingOccurrencesOfString:sourceDirectory withString:destinationDirectory options:0 range:tmpRange];
                    
                    BOOL isFilePresentAtDestination = [self isDirectoryOrFilePresentAtPath:tmpPath];
                    
                    if (isFilePresentAtDestination)
                    {
                        if (overwrittingFilesAtDestination)
                        {
                            if (![self deleteFileAtPath:tmpPath error:&error])
                            {
                                return NO;
                            }
                            
                            if (![self copyFileFromPath:[url path] toPath:tmpPath error:&error])
                            {
                                return NO;
                            }
                        }
                        else
                        {
                            return NO;
                        }
                    }
                    else
                    {
                        if (![self copyFileFromPath:[url path] toPath:tmpPath error:&error])
                        {
                            return NO;
                        }
                    }
                }
            }
        }
    }
    
    return YES;
}

- (BOOL)guardPath:(NSString*)path
{
    NSError* error;
    
    NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    
    if (![[attributes objectForKey:NSFileProtectionKey] isEqual:NSFileProtectionComplete])
    {
        attributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
        
        BOOL success = [[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:path error:&error];
        
        if (!success)
        {
            WARN(@"Encryption failed on \"%@\" with error %@", path, error);
            return NO;
        }
    }
    
    if (&NSURLIsExcludedFromBackupKey == nil)
    { // iOS <= 5.0.1
        const char* filePath = [path cStringUsingEncoding:NSASCIIStringEncoding];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    else
    { // iOS >= 5.1
        return [[NSURL fileURLWithPath:path] setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
    
    return YES;
}

- (BOOL)isPathEncrypted:(NSString*)path
{
    NSError* error;
    
    NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    
    if (![[attributes objectForKey:NSFileProtectionKey] isEqual:NSFileProtectionComplete])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)isPathExcludedFromBackup:(NSString*)path
{
    if (&NSURLIsExcludedFromBackupKey == nil) { // iOS <= 5.0.1
        const char* filePath = [path cStringUsingEncoding:NSASCIIStringEncoding];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = -1;
        
        getxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return attrValue == 1;
    } else { // iOS >= 5.1
        NSNumber * retValue = nil;
        [[NSURL fileURLWithPath:path] getResourceValue:&retValue forKey:NSURLIsExcludedFromBackupKey error:nil];
        return [retValue boolValue];
    }
    return NO;
}


- (BOOL)isPdfFile:(NSString*)filePath
{
    assert(filePath);
    
	BOOL state = NO;
    
	if (filePath != nil) // Must have a file path
	{
		const char* path = [filePath fileSystemRepresentation];
        
		int fd = open(path, O_RDONLY); // Open the file
        
		if (fd > 0) // We have a valid file descriptor
		{
			const char sig [1024]; // File signature buffer
            
			ssize_t len = read(fd, (void*)&sig, sizeof(sig));
            
			state = (strnstr(sig, "%PDF", len) != NULL);
            
			close(fd); // Close the file
		}
	}
    
	return state;
}

- (unsigned long long)computeFileSize:(NSString*)filePath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSError* error;
    NSDictionary* attributesDictionary = [fileManager attributesOfItemAtPath:filePath error:&error];
    
    if (error)
    {
        return -1;
    }
    
    return [attributesDictionary fileSize];
}

- (NSString*)computeSha1HashOfFileAtPath:(NSString*)filePath
{
    const int chunkSizeForReadingData = 4096;
    
    // Declare needed variables.
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL.
    CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)filePath, kCFURLPOSIXPathStyle, (Boolean)false);
    
    do
    {
        if (!fileURL)
        {
            break;
        }
        
        // Create and open the read stream.
        readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault, (CFURLRef)fileURL);
        
        if (!readStream)
        {
            break;
        }
        
        bool didSucceed = (bool)CFReadStreamOpen(readStream);
        
        if (!didSucceed)
        {
            break;
        }
        
        // Initialize the hash object.
        CC_SHA1_CTX hashObject;
        CC_SHA1_Init(&hashObject);
        
        // Feed the data to the hash object.
        bool hasMoreData = true;
        
        while (hasMoreData)
        {
            uint8_t buffer [chunkSizeForReadingData];
            CFIndex readBytesCount = CFReadStreamRead(readStream, (UInt8*)buffer, (CFIndex)sizeof(buffer));
            
            if (readBytesCount == -1)
            {
                break;
            }
            
            if (readBytesCount == 0)
            {
                hasMoreData = false;
                continue;
            }
            
            CC_SHA1_Update(&hashObject, (const void*)buffer, (CC_LONG)readBytesCount);
        }
        
        // Check if the read operation succeeded.
        didSucceed = !hasMoreData;
        
        // Compute the hash digest
        unsigned char digest[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1_Final(digest, &hashObject);
        
        // Abort if the read operation failed.
        if (!didSucceed)
        {
            break;
        }
        
        // Compute the string result.
        char hash[2 * sizeof(digest) + 1];
        
        for (size_t i = 0; i < sizeof(digest); i ++)
        {
            snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        }
        
        result = CFStringCreateWithCString(kCFAllocatorDefault, (const char*)hash, kCFStringEncodingUTF8);
        break;
    }
    while (0);
    
    if (readStream)
    {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    
    if (fileURL)
    {
        CFRelease(fileURL);
    }
    
    return (__bridge_transfer NSString*)result;
}

@end
