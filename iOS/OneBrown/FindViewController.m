//
//  FindViewController.m
//  OneBrown
//
//  Created by Valentin Perez on 1/6/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "FindViewController.h"
#import "SignInViewController.h"
#import "UserCell.h"
#import "UserProfileViewController.h"
#import "UserManager.h"

@interface FindViewController ()
{
    
    NSUserDefaults *defaults;
    NSMutableArray *userPictures;
    NSMutableArray *userPictureNames;
    UserManager *sharedUserManager;
}

@end

@implementation FindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    defaults = [NSUserDefaults standardUserDefaults];
   
    sharedUserManager = [UserManager sharedUserManager];
    
    [self.collectionView setDataSource: self];
    [self.collectionView setDelegate: self];
    
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    userPictureNames = [[NSMutableArray alloc]init];
    userPictures = [[NSMutableArray alloc]init];

    userPictureNames = [NSMutableArray arrayWithObjects: @"Valentin Perez", @"Ben Murphy", @"sara", @"joan", @"erik", @"john", nil];
    
    for (NSString *name in userPictureNames)
        [userPictures addObject:[UIImage imageNamed: name]];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated
{
    // Show the sign up/log in view if the user is not loggedIn
    if(![defaults boolForKey:@"loggedIn"])
    {
        SignInViewController *signIn = [[SignInViewController alloc] init];
        signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInController"];
        [self presentViewController:signIn animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - CollectionView methods.


- (NSInteger) collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [userPictureNames count];
}


/*
 * Return 1 for number of sections.
 */
- (NSInteger) collectionView:(UICollectionView *)view numberOfSection:(NSInteger)section
{
    return 1;
}

/*
 * Displays the cells of the collectionView
 */
- (UICollectionViewCell *) collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"UserCell" forIndexPath: indexPath];
    
    // Set the appropiate image and name to it.
    [cell.userImageView setImage: userPictures[indexPath.row]];
    [cell.userNameLabel setText: userPictureNames[indexPath.row]];
    
    return cell;
}


/*
 * Handles the cell the user clicked in the collectionView.
 */
- (void) collectionView:(UICollectionView *) cv didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    sharedUserManager.stalkedUserName = userPictureNames[indexPath.row];
    
    sharedUserManager.stalkedUserImage  = userPictures[indexPath.row];
    
    sharedUserManager.stalkedUserNetworks = [NSMutableArray arrayWithObjects:@"Facebook", @"Instagram", @"Twitter", @"Snapchat", @"Vine", @"Tumblr", @"LinkedIn", nil];
    
    //sharedUserManager.stalkedUserImage = [userPictures[indexPath.row] image];
    
    UserProfileViewController *viewController = (UserProfileViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileController"];
    
    [self presentViewController:viewController animated:YES completion:nil];

    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main.storyboard" bundle:nil];
   //UserProfileViewController *viewController = (UserProfileViewController *) self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileController"];
    
    //UserProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileController"];
    
    
    
   // viewController.nameLabel.text = userPictureNames[indexPath.row];
   
    
    //[self presentViewController:viewController animated:YES completion:nil];
    //[self setProfileViewController: userPictureNames[indexPath.row]];
}

- (void) setProfileViewController: (NSString *) uName
{
    //UserProfileViewController *viewController = [[UserProfileViewController alloc] init];
    
    UserProfileViewController *viewController = (UserProfileViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileController"];
    //UIViewController *viewController = [[UIViewController alloc]init];
    /*[viewController.view setBackgroundColor: [UIColor colorWithRed:89 green:38 blue:11 alpha:1]];
    
    UILabel *nameLabel = [self newLabelWithTitle:uName];
    [nameLabel setFrame: CGRectMake(50, 50, 200, 50)];
    
    [viewController.view addSubview:nameLabel];
    */
    
    //viewController.delegate = self;
    //viewController.delegate.name = @"cuchirrimin";
    
    //=  [self newLabelWithTitle: @"what"];
   // [viewController.nameLabel setText:@"vali"];
    
    [self presentViewController:viewController animated:YES completion:nil];

    
    //[viewController.userImageView setImage: userPictures[indexPath.row]];
    
}

// Returns a UILabel with the given NSString.
- (UILabel *) newLabelWithTitle:( NSString *) paramTitle
{
    UILabel *label = [[ UILabel alloc] initWithFrame:CGRectZero];
    label.text = paramTitle;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    
    return label;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([_searchBar isFirstResponder] && [touch view] != _searchBar)
        [_searchBar resignFirstResponder];
    
}


@end
