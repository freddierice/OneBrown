//
//  UserManager.m
//  OneBrown
//
//  Created by Valentin Perez on 1/8/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

@synthesize userName, userImage, userNetworks, stalkedUserName, stalkedUserImage, stalkedUserNetworks, socialNetworks, socialNetworkImages, manager;

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
        userNetworks = [[NSMutableDictionary alloc] init];
        stalkedUserName = [[NSString alloc] init];
        stalkedUserImage = [[UIImage alloc]init];
        stalkedUserNetworks = [[NSMutableArray alloc] init];
        
        socialNetworks = [[NSMutableArray alloc] initWithObjects:@"Facebook",@"Twitter", @"Instagram", @"Snapchat", nil];
        
        NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"facebookIcon"], [UIImage imageNamed:@"twitterIcon"], [UIImage imageNamed:@"instagramIcon"], [UIImage imageNamed:@"snapchatIcon"], nil];
        
        socialNetworkImages = [[NSMutableDictionary alloc] initWithObjects:images forKeys: socialNetworks];
        
        
    }
    return self;
}

+ (NSString *) socialNetworkForIndex: (int) index
{
    
    NSString *socialNetwork = [[NSString alloc]init];
    
    switch ((int)index)
    {
        case 0:
            socialNetwork = @"Facebook";
            break;
        case 1:
            socialNetwork = @"Twitter";
            break;
        case 2:
            socialNetwork = @"Instagram";
            break;
        case 3:
            socialNetwork = @"Snapchat";
            break;
        default:
            break;
    }
    
    return socialNetwork;
}

- (void) didReceiveJSON:(NSDictionary *)JSON
{
    
    
}
@end
