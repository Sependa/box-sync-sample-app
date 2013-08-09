//
//  ProgressTableViewCell.m
//  BoxSyncSampleApp
//
//  Created by Ian Fisher on 8/7/13.
//  Copyright (c) 2013 Taptera. All rights reserved.
//


#import "ProgressTableViewCell.h"


@implementation ProgressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];

        CGRect frame = self.contentView.bounds;
        frame.size = CGSizeMake(0, frame.size.height);
        self.progressView = [[UIView alloc] initWithFrame:frame];
        self.progressView.backgroundColor = [UIColor greenColor];
        [self.contentView insertSubview:self.progressView atIndex:0];
    }

    return self;
}

- (void)setPercentComplete:(float)progress {
    CGFloat newWidth = roundf(progress * self.contentView.bounds.size.width);

    CGRect frame = self.progressView.frame;
    frame.size = CGSizeMake(newWidth, frame.size.height);
    self.progressView.frame = frame;
}

@end
