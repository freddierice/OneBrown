//
//  UserManager.h
//  OneBrown
//
//  Created by Valentin Perez on 1/8/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

#define CHOICE ((NSInteger) 0)
#define LOGIN ((NSInteger) 1)
#define REGISTER ((NSInteger) 2)


@interface UserManager : NSObject <NetworkManagerDelegate>
{
    NSString *userName;
    UIImage *userImage;
    NSMutableDictionary *userNetworks;
    
    NSString *stalkedUserName;
    UIImage *stalkedUserImage;
    NSMutableArray *stalkedUserNetworks;
    
    NSString *stalkedNetworkName;
    UIImage *stalkedNetworkImage;
    NSMutableArray *stalkedNetworkUsers;
    
    NSMutableArray *socialNetworks;
    NSMutableDictionary *socialNetworkImages;
    NetworkManager *manager;
    
}

@property (nonatomic, retain) NetworkManager *manager;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) UIImage *userImage;
@property (nonatomic, retain) NSMutableDictionary *userNetworks;

@property (nonatomic, retain) NSString *stalkedUserName;
@property (nonatomic, retain) UIImage *stalkedUserImage;
@property (nonatomic, retain) NSMutableArray *stalkedUserNetworks;

@property (nonatomic, retain) NSString *stalkedNetworkName;
@property (nonatomic, retain) UIImage *stalkedNetworkImage;
@property (nonatomic, retain) NSMutableArray *stalkedNetworkUsers;

@property (nonatomic, retain) NSMutableArray *socialNetworks;
@property (nonatomic, retain) NSMutableDictionary *socialNetworkImages;


+ (id)sharedUserManager;
+ (NSString *) socialNetworkForIndex: (int) index;


@end