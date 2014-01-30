//
//  TabController.h
//  OneBrown
//
//  Created by Benjamin Murphy on 1/7/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetworkManager;

@interface TabController : UITabBarController {
    NetworkManager *manager;
}

@property (nonatomic, retain) NetworkManager *manager;

@end
