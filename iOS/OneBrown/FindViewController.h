//
//  FindViewController.h
//  OneBrown
//
//  Created by Valentin Perez on 1/6/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@interface FindViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, NetworkManagerDelegate>

@property (nonatomic, weak) NetworkManager *manager; //Keep weak reference to manager for sending data

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
