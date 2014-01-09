//
//  AddSocialNetworksViewController.m
//  OneBrown
//
//  Created by Valentin Perez on 1/8/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "AddSocialNetworksViewController.h"
#import "UserManager.h"

static NSString *TableViewCellIdentifier = @"SNCells";

@interface AddSocialNetworksViewController ()
{
    UserManager *sharedUserManager;
    NSUserDefaults *defaults;
}
@end

@implementation AddSocialNetworksViewController

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
    
    sharedUserManager = [UserManager sharedUserManager];
    defaults = [NSUserDefaults standardUserDefaults];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.tableView registerClass:[ UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    
    /* Make sure our table view resizes correctly */
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        cell = [tableView dequeueReusableCellWithIdentifier: TableViewCellIdentifier forIndexPath:indexPath];
        
        cell.imageView.image = [UIImage imageNamed:@"IconProfile"];
        //cell.userInteractionEnabled = NO;
        cell.textLabel.text = [sharedUserManager.stalkedUserNetworks objectAtIndex: indexPath.row];
        
        [cell.textLabel setFont: [UIFont fontWithName:@"Helvetica" size:12 ]];
    
        [cell setBackgroundColor:[UIColor grayColor]];
        
    }
    return cell;
}


// Returns a UILabel with the given NSString.
- (UILabel *) newLabelWithTitle:( NSString *) paramTitle
{
    UILabel *label = [[ UILabel alloc] initWithFrame:CGRectZero];
    label.text = paramTitle;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit]; return label;
}

- (UIView *) tableView:( UITableView *) tableView viewForHeaderInSection:( NSInteger) section
{
    //if (section == 0)
        return [self newLabelWithTitle:@"  Social Networks"];
    
    //return nil;
}

@end
