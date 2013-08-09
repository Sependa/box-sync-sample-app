//
//  FileDownloader.h
//  BoxSyncSampleApp
//
//  Created by Ian Fisher on 8/7/13.
//  Copyright (c) 2013 Taptera. All rights reserved.
//


#import <Foundation/Foundation.h>

@class SyncableFile;


@interface FileDownloader : NSObject

- (void)queueFileForDownload:(SyncableFile *)file progress:(BoxAPIDataProgressBlock)progress;

@end
