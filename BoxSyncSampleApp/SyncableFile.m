//
//  SyncableFile.m
//  BoxSyncSampleApp
//
//  Created by Ian Fisher on 8/7/13.
//  Copyright (c) 2013 Taptera. All rights reserved.
//


#import <BoxSDK/BoxFile.h>
#import "SyncableFile.h"


@implementation SyncableFile

+ (instancetype)fileWithBoxFile:(BoxFile *)boxFile {
    SyncableFile *syncableFile = [self new];
    syncableFile.boxFile = boxFile;
    return syncableFile;
}

- (NSString *)filePath {
    NSString *fileName = self.boxFile.modelID;
    NSString *fileExtension = [self.boxFile.name pathExtension];
    if ([fileExtension length]) {
        fileName = [fileName stringByAppendingFormat:@".%@", fileExtension];
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

@end
