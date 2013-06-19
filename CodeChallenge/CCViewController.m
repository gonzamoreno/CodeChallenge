//
//  CCViewController.m
//  CodeChallenge
//
//  Created by Gonzalo Moreno F. on 19/06/13.
//  Copyright (c) 2013 Gonzalo Moreno F. All rights reserved.
//

#import "CCViewController.h"
#import "CCPostInfo.h"
#import "CCTableViewCell.h"
#import "Reachability.h"

@interface CCViewController ()

@end

static NSUInteger const kCCRetryButtonWidth = 100;
static NSUInteger const kCCRetryButtonHeight = 44;

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Draw failure controls
    
    self.loadingFailedLabel = [[UILabel alloc] init];
    self.loadingFailedLabel.textAlignment = NSTextAlignmentCenter;
    [self.loadingFailedLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.loadingFailedLabel.backgroundColor = [UIColor clearColor];
    self.loadingFailedLabel.numberOfLines = 2;
    self.retryBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.retryBtn setTitle:@"Retry!" forState:UIControlStateNormal];
    [self.retryBtn addTarget:self action:@selector(retryLoad) forControlEvents:UIControlEventTouchUpInside];
    [self.retryBtn setHidden:YES];
    self.loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.loadingIndicatorView startAnimating];
    self.loadingIndicatorView.frame = CGRectMake(self.view.bounds.size.width/2 - self.loadingIndicatorView.bounds.size.width/2, self.view.bounds.size.height/2 - self.loadingIndicatorView.bounds.size.height/2, self.loadingIndicatorView.bounds.size.width, self.loadingIndicatorView.bounds.size.height);
    [self.view addSubview:self.loadingIndicatorView];
    self.retryBtn.frame = CGRectMake(self.view.bounds.size.width/2 - kCCRetryButtonWidth/2 , self.view.bounds.size.height/2 - kCCRetryButtonHeight - 10, kCCRetryButtonWidth, kCCRetryButtonHeight);
    [self.view addSubview:self.retryBtn];
    self.loadingFailedLabel.frame = CGRectMake(10, self.view.bounds.size.height/2, self.view.bounds.size.width - 20, 50);
    [self.view addSubview:self.loadingFailedLabel];
    [self.mainTableView setHidden:YES];

	// Fill with data.

    [self fillDataToShow];
    
    // Add refresh control
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(fillDataToShow) forControlEvents:UIControlEventValueChanged];
    [self.mainTableView addSubview:refreshControl];
    self.tableRefresher = refreshControl;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fillDataToShow {
    
    NSURL *url = [NSURL URLWithString:@"https://alpha-api.app.net/stream/0/posts/stream/global"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus] != NotReachable) {
        // Reachable
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSArray* data = [JSON valueForKeyPath:@"data"];
            self.mainTableViewData = [NSMutableArray array];
            NSLog(@"Data: %@", data);
            for (NSDictionary* post in data) {
                CCPostInfo* postObject = [[CCPostInfo alloc] init];
                postObject.text = [post valueForKey:@"text"];
                postObject.createdAt = [post valueForKey:@"created_at"];
                NSDictionary* user = [post valueForKey:@"user"];
                if (user) {
                    NSDictionary* avatarImage = [user valueForKey:@"avatar_image"];
                    if (avatarImage) {
                        postObject.avatarImageUrl = [avatarImage valueForKey:@"url"];
                    }
                    postObject.authorName = [user valueForKey:@"name"];
                }
                if (![self.mainTableViewData containsObject:postObject]) {
                    [self.mainTableViewData addObject:postObject];
                }
            }
            NSArray* sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO], nil];
            [self.mainTableViewData sortUsingDescriptors:sortDescriptors];
            [self showData];
        } failure:nil];
        
        [operation start];
    } else {
        // Not reachable
        [self.loadingIndicatorView stopAnimating];
        [self.mainTableView setHidden:YES];
        [self.loadingFailedLabel setText:@"Oops! Something happened. Please try again."];
        [self.loadingFailedLabel setHidden:NO];
        [self.retryBtn setHidden:NO];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Internet Connection" message:@"Your device can't reach the internet. Please check your connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
}

- (void) showData {
    [self.mainTableView reloadData];
    [self.loadingIndicatorView stopAnimating];
    [self.loadingIndicatorView setHidden:YES];
    [self.loadingFailedLabel setHidden:YES];
    [self.tableRefresher endRefreshing];
    if ([self.mainTableViewData count] > 0) {
        [self.mainTableView setHidden:NO];
    }
    else {
        [self.loadingFailedLabel setText:@"Oops! Something happened. Please try again."];
        [self.retryBtn setHidden:NO];
        [self.loadingFailedLabel setHidden:NO];
    }
}

- (void) retryLoad {
    
    [self.loadingIndicatorView startAnimating];
    [self.loadingIndicatorView setHidden:NO];
    [self.retryBtn setHidden:YES];
    [self.loadingFailedLabel setHidden:YES];
    [self fillDataToShow];
    
}

#pragma  mark - UITableViewDelegate methods

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Make row height variable according to content.
    CGSize sizeToReturn = CGSizeZero;
    if ([self.mainTableViewData count] > indexPath.row) {
        CCPostInfo* postInfo = (CCPostInfo*)[self.mainTableViewData objectAtIndex:indexPath.row];
        sizeToReturn = [postInfo.text sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:28] constrainedToSize:CGSizeMake(self.mainTableView.frame.size.width*0.75, self.mainTableView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    }
    return ((sizeToReturn.height+20) > 130)? sizeToReturn.height+20 : 130;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mainTableViewData count];
}

- (NSString*) defaultCellClass {
	return @"CCTableViewCell";
}

- (UITableViewCellStyle) defaultCellStyle {
	return UITableViewCellStyleDefault;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell_%@_%i",[self class],(int)self];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        Class responseClass = NSClassFromString(self.defaultCellClass);
        if(responseClass) {
            cell = [[responseClass alloc] initWithStyle:self.defaultCellStyle reuseIdentifier:CellIdentifier];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:self.defaultCellStyle reuseIdentifier:CellIdentifier];
        }
    }
    if ([self.mainTableViewData count] > indexPath.row) {
        //Filling the cell
        ((CCTableViewCell*)cell).postInfo = [self.mainTableViewData objectAtIndex:indexPath.row];
        ((CCTableViewCell*)cell).sortingOrder = indexPath.row;
    }
    return cell;

}

@end
