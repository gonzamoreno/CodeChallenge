//
//  CCViewController.h
//  CodeChallenge
//
//  Created by Gonzalo Moreno F. on 19/06/13.
//  Copyright (c) 2013 Gonzalo Moreno F. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView* mainTableView;
@property (nonatomic, strong) NSMutableArray* mainTableViewData;
@property (nonatomic, strong) UIRefreshControl* tableRefresher;
@property (nonatomic, strong) UIActivityIndicatorView* loadingIndicatorView;
@property (nonatomic, strong) UILabel* loadingFailedLabel;
@property (nonatomic, strong) UIButton* retryBtn;

@end
