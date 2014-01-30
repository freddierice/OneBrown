//
//  FindViewController.m
//  OneBrown
//
//  Created by Valentin Perez on 1/6/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "FindViewController.h"
#import "UserCell.h"
#import "UserProfileViewController.h"
#import "UserManager.h"

@interface FindViewController ()
{
    
    NSUserDefaults *defaults;
    NSMutableArray *userPictures;
    NSMutableArray *userPictureNames;
    UserManager *sharedUserManager;
    NSString *searchType;
    // int segmentedControlTypeIndex;
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
    
    // Default search type is Person.
    searchType = @"Person";
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - CollectionView methods.


- (NSInteger) collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if ([searchType isEqualToString:@"Person"])
        return [userPictureNames count];
    
    else if ([searchType isEqualToString:@"Social"])
        return [sharedUserManager.socialNetworks count];
    
    else if ([searchType isEqualToString:@"Major"])
        return 0;
    
    else
        return 0;
    
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
    if ([searchType isEqualToString:@"Person"])
    {
        [cell.userImageView setImage: userPictures[indexPath.row]];
        [cell.userNameLabel setText: userPictureNames[indexPath.row]];
        cell.fadeView.hidden = NO;
    }
    else if ([searchType isEqualToString:@"Social"])
    {
        NSString *socialNetwork = [UserManager socialNetworkForIndex:(int)indexPath.row];
        
        [cell.userImageView setImage: sharedUserManager.socialNetworkImages[socialNetwork]];
        [cell.userNameLabel setText:@""];
        cell.fadeView.hidden = YES;
    }
    
    // The borders don't look cool with the social network icons.
    if (![searchType isEqualToString:@"Social"])
    {
        cell.userImageView.layer.cornerRadius = 10;
        cell.userImageView.clipsToBounds = YES;
        cell.userImageView.layer.borderWidth = 2;
        cell.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        cell.fadeView.layer.cornerRadius = 10;
        cell.fadeView.clipsToBounds = YES;
    }
    else
        cell.userImageView.layer.borderColor = [UIColor clearColor].CGColor;
    
    
    return cell;
}


/*
 * Handles the cell the user clicked in the collectionView.
 */
- (void) collectionView:(UICollectionView *) cv didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([searchType isEqualToString:@"Person"])
    {
        sharedUserManager.stalkedUserName = userPictureNames[indexPath.row];
        sharedUserManager.stalkedUserImage  = userPictures[indexPath.row];
        sharedUserManager.stalkedUserNetworks = [NSMutableArray arrayWithObjects:@"Facebook", @"Twitter", @"Instagram", @"Snapchat", nil];
        
        UserProfileViewController *viewController = (UserProfileViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileController"];
        
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (void) setProfileViewController: (NSString *) uName
{
    UserProfileViewController *viewController = (UserProfileViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileController"];
    
    
    [self presentViewController:viewController animated:YES completion:nil];
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


- (IBAction)choseSearchType:(id)sender
{
    
    UISegmentedControl *typeSegmentedControl = (UISegmentedControl *) sender;
    int index = (int) typeSegmentedControl.selectedSegmentIndex;
    
    switch (index)
    {
        case 0:
            searchType = @"Person";
            break;
        case 1:
            searchType = @"Social";
            break;
        case 2:
            searchType = @"Major";
            break;
        case 3:
            searchType = @"Classes";
            break;
        default:
            break;
    }
    
    [self.collectionView reloadData];
}
@end
