//
//  FilePreviewDataSource.h
//  BoxSyncSampleApp
//
//  Created by Ian Fisher on 8/7/13.
//  Copyright (c) 2013 Taptera. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@class SyncableFile;


@interface FilePreviewDataSource : NSObject <QLPreviewControllerDataSource>

@property(nonatomic, strong) SyncableFile *file;

+ (instancetype)dataSourceWithSyncableFile:(SyncableFile *)file;

- (void)previewFileWithParentViewController:(UIViewController *)controller;
@end
