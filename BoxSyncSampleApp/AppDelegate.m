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

static NSString *const REFRESH_TOKEN_KEY = @"REFRESH_TOKEN_KEY";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureBoxSDK];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boxUserDidAuthenticate:)
                                                 name:BoxOAuth2SessionDidBecomeAuthenticatedNotification
                                               object:[BoxSDK sharedSDK].OAuth2Session];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boxAPITokensDidRefresh:)
                                                 name:BoxOAuth2SessionDidBecomeAuthenticatedNotification
                                               object:[BoxSDK sharedSDK].OAuth2Session];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boxAPITokensDidRefresh:)
                                                 name:BoxOAuth2SessionDidRefreshTokensNotification
                                               object:[BoxSDK sharedSDK].OAuth2Session];


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    NSString *storedRefreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:REFRESH_TOKEN_KEY];
    if (storedRefreshToken) {
        [BoxSDK sharedSDK].OAuth2Session.refreshToken = storedRefreshToken;
        [self showFilesView];
    }
    else {
        UIViewController *authorizationController = [[BoxAuthorizationViewController alloc] initWithAuthorizationURL:[[BoxSDK sharedSDK].OAuth2Session authorizeURL]
                                                                                                         redirectURI:nil];
        self.window.rootViewController = authorizationController;
    }

    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[BoxSDK sharedSDK].OAuth2Session performAuthorizationCodeGrantWithReceivedURL:url];
    return YES;
}

- (void)boxUserDidAuthenticate:(id)boxUserDidAuthenticate {
    [self showFilesView];
}

- (void)boxAPITokensDidRefresh:(id)boxAPITokensDidRefresh {
    [[NSUserDefaults standardUserDefaults] setObject:[BoxSDK sharedSDK].OAuth2Session.refreshToken
                                              forKey:REFRESH_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)configureBoxSDK {
#error Set your client ID and client secret in the BoxSDK
    [BoxSDK sharedSDK].OAuth2Session.clientID = @"YOUR_CLIENT_ID";
    [BoxSDK sharedSDK].OAuth2Session.clientSecret = @"YOUR_CLIENT_SECRET";
}

- (void)showFilesView {
    ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = viewController;
}

@end
