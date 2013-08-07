//
//  AppDelegate.m
//  BoxSyncSampleApp
//
//  Created by Ian Fisher on 8/7/13.
//  Copyright (c) 2013 Taptera. All rights reserved.
//

#import <BoxSDK/BoxSDK.h>
#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureBoxSDK];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boxAPITokensDidRefresh:)
                                                 name:BoxOAuth2SessionDidBecomeAuthenticatedNotification
                                               object:[BoxSDK sharedSDK].OAuth2Session];


    UIViewController *authorizationController = [[BoxAuthorizationViewController alloc] initWithAuthorizationURL:[[BoxSDK sharedSDK].OAuth2Session authorizeURL]
                                                                                                     redirectURI:nil];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = authorizationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)boxAPITokensDidRefresh:(id)boxAPITokensDidRefresh {
    [self showFilesView];
}

- (void)configureBoxSDK {
#error Set your client ID and client secret in the BoxSDK
    [BoxSDK sharedSDK].OAuth2Session.clientID = @"YOUR_CLIENT_ID";
    [BoxSDK sharedSDK].OAuth2Session.clientSecret = @"YOUR_CLIENT_SECRET";
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[BoxSDK sharedSDK].OAuth2Session performAuthorizationCodeGrantWithReceivedURL:url];
    return YES;
}


- (void)showFilesView {
    ViewController *viewController = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {
        viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }

    self.window.rootViewController = viewController;
}

@end
