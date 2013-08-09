//
//  SyncableFile.h
//  BoxSyncSampleApp
//
//  Created by Ian Fisher on 8/7/13.
//  Copyright (c) 2013 Taptera. All rights reserved.
//


#import <Foundation/Foundation.h>

@class BoxFile;


@interface SyncableFile : NSObject

@property(nonatomic, strong) BoxFile *boxFile;

+ (instancetype)fileWithBoxFile:(BoxFile *)boxFile;
- (NSString *)filePath;

@end
