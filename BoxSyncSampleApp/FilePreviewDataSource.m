//
//  FilePreviewDataSource.m
//  BoxSyncSampleApp
//
//  Created by Ian Fisher on 8/7/13.
//  Copyright (c) 2013 Taptera. All rights reserved.
//


#import "FilePreviewDataSource.h"
#import "SyncableFile.h"


@implementation FilePreviewDataSource

+ (instancetype)dataSourceWithSyncableFile:(SyncableFile *)file {
    FilePreviewDataSource *dataSource = [self new];
    dataSource.file = file;
    return dataSource;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return [NSURL fileURLWithPath:[self.file filePath]];
}

- (void)previewFileWithParentViewController:(UIViewController *)controller {
    QLPreviewController *previewController = [QLPreviewController new];
    previewController.dataSource = self;
    [controller presentViewController:previewController animated:YES completion:NULL];
}

@end
