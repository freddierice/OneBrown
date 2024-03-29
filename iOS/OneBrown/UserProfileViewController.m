//
//  UserProfileViewController.m
//  OneBrown
//
//  Created by Valentin Perez on 1/7/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserManager.h"

static NSString *TableViewCellIdentifier = @"SNCells";

@interface UserProfileViewController ()
{
    UserManager *sharedUserManager;
    NSUserDefaults *defaults;
}

@end

@implementation UserProfileViewController

@synthesize nameLabel, userImageView;


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

    NSLog(@"didLoad");
    defaults = [NSUserDefaults standardUserDefaults];
    sharedUserManager = [UserManager sharedUserManager];
    
    nameLabel.text = sharedUserManager.stalkedUserName;
    
    userImageView.layer.cornerRadius = 80;
    userImageView.clipsToBounds = YES;
    userImageView.layer.borderWidth = 2;
    userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
   [userImageView setImage: sharedUserManager.stalkedUserImage];
    
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.tableView.separatorInset =  UIEdgeInsetsMake(5, 3, 5, 5);
    [self.tableView registerClass:[ UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];

    
    /* Make sure our table view resizes correctly */
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

# pragma mark TableView Delegate Methods
- (NSInteger) numberOfSectionsInTableView:( UITableView *) tableView
{
    if ([ tableView isEqual:self.tableView] && [defaults objectForKey:@"loggedIn"])
    {
        return 1;
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([tableView isEqual:self.tableView] && [defaults objectForKey:@"loggedIn"])
    {
        if ([sharedUserManager.stalkedUserNetworks count]!=0)
            return [sharedUserManager.stalkedUserNetworks  count];
    }
    
    return 0;
}

- (UITableViewCell *) tableView:( UITableView *) tableView cellForRowAtIndexPath:( NSIndexPath *) indexPath
{
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.tableView] && [defaults objectForKey:@"loggedIn"])
    {
        
        NSString *socialNetwork = [[NSString alloc]init];
        
        socialNetwork = [UserManager socialNetworkForIndex:(int)indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier: TableViewCellIdentifier forIndexPath:indexPath];
        
        cell.imageView.image = sharedUserManager.socialNetworkImages[socialNetwork];
        
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        cell.textLabel.text = [sharedUserManager.stalkedUserNetworks objectAtIndex: indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        
        /*
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"IconProfile"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tappedButton) forControlEvents:UIControlEventTouchUpInside];
        button.tag = indexPath.row;
        cell.accessoryView = button;
        */
        [cell.textLabel setFont: [UIFont fontWithName:@"Helvetica" size:12]];
        
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
    NSLog(@"sacagawea");
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *userName = @"BrownUniversity";
    // Clicked on the Facebook icon.
    if(indexPath.row==0)
    {
        //This would be the action we need. fb://profile/(fbid)/addfriend
        NSURL *url = [NSURL URLWithString:@"fb://notifications"];
        [[UIApplication sharedApplication] openURL:url];
         
    }
    // Twitter
    else if (indexPath.row==1)
    {
        NSString *stringURL = [NSString stringWithFormat: @"twitter://user?screen_name=%@", userName];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    // Instagram
    else if (indexPath.row==2)
    {
        // apparently there is no normal brownuniversity instagram
        userName = @"brownuniversitylibrary";
        NSString *stringURL = [NSString stringWithFormat: @"instagram://user?username=%@", userName];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    else if (indexPath.row==3)
    {
        NSString *stringURL = [NSString stringWithFormat:@"snapchat://?u=%@", userName];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
        NSLog(@"Only fb, twitter, instagram, and snapchat for now.");
    
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

/*
- (UIView *) tableView:( UITableView *) tableView viewForHeaderInSection:( NSInteger) section
{
    //if (section == 0)
    return [self newLabelWithTitle:@"  Social Networks"];
    
    //return nil;
}*/




- (IBAction)clickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
