//
//  BusViewController.h
//  TravelApp
//
//  Created by Neeraj on 9/14/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelApp-swift.h"
#import "ColorUtils.h"

@interface BusViewController : UIViewController<ServiceAdapterDelegate,UITableViewDelegate,UITableViewDataSource,sortingRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *busTableView;

@property NSMutableArray *responseArray;

@end
