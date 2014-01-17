//
//  UserManager.m
//  OneBrown
//
//  Created by Valentin Perez on 1/8/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

@synthesize userName, userImage, userNetworks, stalkedUserName, stalkedUserImage, stalkedUserNetworks, socialNetworks, socialNetworkImages;

#pragma mark Singleton Methods

+ (id)sharedUserManager
{
    static UserManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    
    // Ensure it is created only once.
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id) init
{
    if (self = [super init])
    {
        userName = [[NSString alloc] init];
        userImage = [[UIImage alloc]init];
        userNetworks = [[NSMutableArray alloc] init];
        stalkedUserName = [[NSString alloc] init];
        stalkedUserImage = [[UIImage alloc]init];
        stalkedUserNetworks = [[NSMutableArray alloc] init];
        
        socialNetworks = [[NSMutableArray alloc] initWithObjects:@"Facebook",@"Twitter", @"Instagram", @"Snapchat", @"Vine", @"LinkedIn", nil];
        socialNetworkImages = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"facebookIcon"], [UIImage imageNamed:@"twitterIcon"], [UIImage imageNamed:@"instagramIcon"], [UIImage imageNamed:@"snapchatIcon"], [UIImage imageNamed:@"vineIcon"], [UIImage imageNamed:@"linkedinIcon"], nil];

    }
    return self;
}



@end
