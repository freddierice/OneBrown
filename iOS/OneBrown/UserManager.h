//
//  UserManager.h
//  OneBrown
//
//  Created by Valentin Perez on 1/8/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

@interface UserManager : NSObject <NetworkManagerDelegate>
{
    NSString *userName;
    UIImage *userImage;
    NSMutableArray *userNetworks;
    
    NSString *stalkedUserName;
    UIImage *stalkedUserImage;
    NSMutableArray *stalkedUserNetworks;
    
    NetworkManager *manager;
}

@property (nonatomic, retain) NetworkManager *manager;

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) UIImage *userImage;
@property (nonatomic, retain) NSMutableArray *userNetworks;

@property (nonatomic, retain) NSString *stalkedUserName;
@property (nonatomic, retain) UIImage *stalkedUserImage;
@property (nonatomic, retain) NSMutableArray *stalkedUserNetworks;


+ (id)sharedUserManager;

@end
