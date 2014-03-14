//
//  TTFilesystemManager.h
//  TT
//
//  Created by Andrzej Auchimowicz on 05/07/2013.
//  Copyright (c) 2013 Transition Technologies. All rights reserved.
//

#import "TTSingleton.h"

@interface TTFilesystemManager : TTSingleton

- (BOOL)createDirectory:(NSString*)dirPath withIntermediateDirectories:(bool)createIntermediates error:(NSError**)error;

- (NSArray*)listFilenamesOfFilesInDirectoryAtPath:(NSString*)path;

- (BOOL)isDirectoryOrFilePresentAtPath:(NSString*)path;

- (NSString*)imagePathForBaseFilePath:(NSString*)filePath;
- (NSString*)imagePathForBaseFileName:(NSString*)fileName inBundle:(NSBundle*)bundle;

- (BOOL)moveFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath error:(NSError**)error;
- (BOOL)copyFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath error:(NSError**)error;
- (BOOL)deleteFileAtPath:(NSString*)filePath error:(NSError**)error;

- (BOOL)deleteDirectoryAtPath:(NSString*)dirPath evenWhenNotEmpty:(BOOL)evenWhenNotEmpty error:(NSError**)error;
- (BOOL)mergeDirectoryAtPath:(NSString*)sourceDirectory intoDirectoryAtPath:(NSString*)destinationDirectory overwrittingFilesAtDestination:(BOOL)overwrittingFilesAtDestination error:(NSError**)error;

- (BOOL)guardPath:(NSString*)path;

- (BOOL)isPathEncrypted:(NSString*)path;
- (BOOL)isPathExcludedFromBackup:(NSString*)path;

//! Checks whether file at filePath has PDF file signature.
- (BOOL)isPdfFile:(NSString*)filePath;

- (unsigned long long)computeFileSize:(NSString*)filePath;
- (NSString*)computeSha1HashOfFileAtPath:(NSString*)filePath;

@end
