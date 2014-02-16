//
//  SocialNetworkViewController.m
//  OneBrown
//
//  Created by Valentin Perez on 2/3/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "SocialNetworkViewController.h"
#import "UserManager.h"
#import "UserProfileViewController.h"

static NSString *TableViewCellIdentifier = @"SNCells";

@interface SocialNetworkViewController ()
{
    UserManager *sharedUserManager;
    NSUserDefaults *defaults;
    NSMutableArray *userPictures;
    NSMutableArray *userPictureNames;
}
@end

@implementation SocialNetworkViewController

@synthesize networkImageView, networkNameLabel;

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
    
    networkNameLabel.text = sharedUserManager.stalkedNetworkName;
    networkImageView.image = sharedUserManager.stalkedNetworkImage;
    
    [self.usersInNetworkTableView setDataSource:self];
    [self.usersInNetworkTableView setDelegate:self];
    
    self.usersInNetworkTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.usersInNetworkTableView.separatorInset =  UIEdgeInsetsMake(5, 3, 5, 5);
    [self.usersInNetworkTableView registerClass:[ UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    
    /* Make sure our table view resizes correctly */
    self.usersInNetworkTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    userPictureNames = [[NSMutableArray alloc]init];
    userPictures = [[NSMutableArray alloc]init];
    
    userPictureNames = [NSMutableArray arrayWithObjects: @"Valentin Perez", @"Ben Murphy", @"sara", nil];
    
    for (NSString *name in userPictureNames)
        [userPictures addObject:[UIImage imageNamed: name]];
    
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

- (UIImage *)cropImage:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    //CGRect CropRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+15);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}
# pragma mark TableView Delegate Methods
- (NSInteger) numberOfSectionsInTableView:( UITableView *) tableView
{
    if ([ tableView isEqual: self.usersInNetworkTableView] && [defaults objectForKey:@"loggedIn"])
    {
        return 1;
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([tableView isEqual:self.usersInNetworkTableView] && [defaults objectForKey:@"loggedIn"])
    {
        if ([sharedUserManager.stalkedNetworkUsers count]!=0)
            return [sharedUserManager.stalkedNetworkUsers  count];
    }
    
    return 0;
}

- (UITableViewCell *) tableView:( UITableView *) tableView cellForRowAtIndexPath:( NSIndexPath *) indexPath
{
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.usersInNetworkTableView] && [defaults objectForKey:@"loggedIn"])
    {
        
        //NSString *user = [[NSString alloc]init];
        
        //user = [UserManager socialNetworkForIndex:(int)indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier: TableViewCellIdentifier forIndexPath:indexPath];
        
        //cell.imageView.image = sharedUserManager.socialNetworkImages[socialNetwork];
        
        UIImage *scaledUserImage = [self resizeImage:userPictures[indexPath.row] newSize:CGSizeMake(40, 40)];
        
        //[cell.imageView setFrame:CGRectMake(0, 0, 20, 20)];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        cell.textLabel.text = [sharedUserManager.stalkedNetworkUsers objectAtIndex: indexPath.row];
        
        
        cell.imageView.layer.cornerRadius = 20;
        cell.imageView.clipsToBounds = YES;
        cell.imageView.layer.borderWidth = 1;
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
        //UIColor *brownColor = [UIColor colorWithRed:89 green:38 blue:11 alpha:1];
        cell.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.imageView.image = scaledUserImage;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        /*
         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
         [button setImage:[UIImage imageNamed:@"IconProfile"] forState:UIControlStateNormal];
         [button addTarget:self action:@selector(tappedButton) forControlEvents:UIControlEventTouchUpInside];
         button.tag = indexPath.row;
         cell.accessoryView = button;
         */
        [cell.textLabel setFont: [UIFont fontWithName:@"Helvetica" size:14]];
        
        [cell.textLabel setTextColor: [UIColor whiteColor]];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    return cell;
}

/*
 * This is just to hide the separators of the empty cells.
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

-(void) tappedButton
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sharedUserManager.stalkedUserName = userPictureNames[indexPath.row];
    sharedUserManager.stalkedUserImage  = userPictures[indexPath.row];
    sharedUserManager.stalkedUserNetworks = [NSMutableArray arrayWithObjects:@"Facebook", @"Twitter", @"Instagram", @"Snapchat", nil];
    
    UserProfileViewController *uPViewController = (UserProfileViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileController"];
    [self presentViewController:uPViewController animated:YES completion:nil];
    
    NSLog(@"selected ");
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tapped disclosure");

}


// Returns a UILabel with the given NSString.
- (UILabel *) newLabelWithTitle:( NSString *) paramTitle
{
    UILabel *label = [[ UILabel alloc] initWithFrame:CGRectZero];
    label.text = paramTitle;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit]; return label;
}


- (IBAction)clickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
