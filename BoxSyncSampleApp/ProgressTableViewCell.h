//
//  ProgressTableViewCell.h
//  BoxSyncSampleApp
//
//  Created by Ian Fisher on 8/7/13.
//  Copyright (c) 2013 Taptera. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface ProgressTableViewCell : UITableViewCell

@property(nonatomic, strong) UIView *progressView;

- (void)setPercentComplete:(float)progress;

@end
