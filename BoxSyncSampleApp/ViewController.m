//
//  ViewController.m
//  BoxSyncSampleApp
//
//  Created by Ian Fisher on 8/7/13.
//  Copyright (c) 2013 Taptera. All rights reserved.
//

#import <BoxSDK/BoxSDK.h>
#import <QuickLook/QLPreviewController.h>
#import "ViewController.h"
#import "FileDownloader.h"
#import "SyncableFile.h"
#import "ProgressTableViewCell.h"
#import "FilePreviewDataSource.h"

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fileDownloader = [FileDownloader new];
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchSyncFileList];
}

- (void)fetchSyncFileList {
    BoxCollectionBlock success = ^(BoxCollection *collection) {
        for (NSUInteger i = 0; i < collection.numberOfEntries; i++) {
            BoxModel *model = [collection modelAtIndex:i];
            if ([model isKindOfClass:[BoxFolder class]]) {
                BoxFolder *syncFolder = (BoxFolder *) model;
                if ([[syncFolder name] isEqualToString:@"Sync"]) {
                    NSLog(@"Found sync folder %@", syncFolder);
                    [self fetchItemsForFolder:syncFolder];
                }
            }
        }
    };
    BoxAPIJSONFailureBlock failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        // TODO
        NSLog(@"Error fetching files %@", error);
    };

    [[BoxSDK sharedSDK].foldersManager folderItemsWithID:@"0" requestBuilder:nil success:success failure:failure];
}

- (void)fetchItemsForFolder:(BoxFolder *)folder {
    BoxCollectionBlock success = ^(BoxCollection *collection) {
        [self updateSyncCollection:collection];
    };
    BoxAPIJSONFailureBlock failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary) {
        // TODO
        NSLog(@"Error fetching files %@", error);
    };

    BoxFoldersRequestBuilder *builder = [[BoxFoldersRequestBuilder alloc] initWithQueryStringParameters:@{
            @"fields" : @"name,size"
    }];
    [[BoxSDK sharedSDK].foldersManager folderItemsWithID:folder.modelID requestBuilder:builder
                                                 success:success
                                                 failure:failure];
}

- (void)updateSyncCollection:(BoxCollection *)folder {
    NSMutableArray *files = [NSMutableArray array];
    for (NSUInteger i = 0; i < folder.numberOfEntries; i++) {
        BoxModel *model = [folder modelAtIndex:i];
        if ([model isKindOfClass:[BoxFile class]]) {
            BoxFile *file = (BoxFile *) model;
            NSLog(@"Found file %@", file);

            SyncableFile *syncableFile = [SyncableFile fileWithBoxFile:file];
            [files addObject:syncableFile];
        }
    }

    [files sortUsingComparator:^NSComparisonResult(SyncableFile *file1, SyncableFile *file2) {
        return [file1.boxFile.size compare:file2.boxFile.size];
    }];

    self.syncFiles = files;
    [self.tableView reloadData];

    [self downloadFiles];
}

- (void)downloadFiles {
    __weak typeof (self) weakSelf = self;

    for (SyncableFile *file in self.syncFiles) {
        BoxAPIDataProgressBlock progress = ^(long long int expectedTotalBytes, unsigned long long int bytesReceived) {
            float percentComplete = (float) bytesReceived / expectedTotalBytes;
            [weakSelf updateFile:file downloadProgress:percentComplete];
        };

        [self.fileDownloader queueFileForDownload:file progress:progress];
    }
}

- (void)updateFile:(SyncableFile *)file downloadProgress:(float)progress {
    NSUInteger index = [self.syncFiles indexOfObject:file];

    for (ProgressTableViewCell *cell in [self.tableView visibleCells]) {
        if ([self.tableView indexPathForCell:cell].row == index) {
            [cell setPercentComplete:progress];
            break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.syncFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SyncCell";
    ProgressTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ProgressTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    SyncableFile *file = self.syncFiles[(NSUInteger) indexPath.row];
    cell.textLabel.text = file.boxFile.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", file.boxFile.size];
    [cell setPercentComplete:0];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SyncableFile *file = self.syncFiles[(NSUInteger) indexPath.row];

    FilePreviewDataSource *previewController = [FilePreviewDataSource dataSourceWithSyncableFile:file];
    [previewController previewFileWithParentViewController:self];
}

@end
