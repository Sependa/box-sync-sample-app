//
//  FileDownloader.m
//  BoxSyncSampleApp
//
//  Created by Ian Fisher on 8/7/13.
//  Copyright (c) 2013 Taptera. All rights reserved.
//


#import <BoxSDK/BoxFile.h>
#import <BoxSDK/BoxSDK.h>
#import "FileDownloader.h"
#import "SyncableFile.h"


@implementation FileDownloader

- (void)queueFileForDownload:(SyncableFile *)file progress:(BoxAPIDataProgressBlock)progress {
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:[file filePath] append:NO];

    BoxDownloadSuccessBlock success = ^(NSString *fileID, long long int expectedTotalBytes) {
        NSLog(@"File %@ downloaded successfully", file.boxFile.modelID);
    };
    BoxDownloadFailureBlock failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        // TODO
        NSLog(@"File download failed");
    };

    [[BoxSDK sharedSDK].filesManager downloadFileWithID:file.boxFile.modelID
                                           outputStream:outputStream
                                         requestBuilder:nil
                                                success:success failure:failure progress:progress];
}

@end
