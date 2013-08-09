//
//  ViewController.h
//  BoxSyncSampleApp
//
//  Created by Ian Fisher on 8/7/13.
//  Copyright (c) 2013 Taptera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FileDownloader;
@class SyncableFile;


@interface ViewController : UITableViewController

@property(nonatomic, strong) NSArray *syncFiles;
@property(nonatomic, strong) FileDownloader *fileDownloader;

- (void)updateFile:(SyncableFile *)file downloadProgress:(float)progress;

@end
