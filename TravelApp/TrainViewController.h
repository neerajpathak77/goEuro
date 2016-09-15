//
//  TrainViewController.h
//  TravelApp
//
//  Created by Neeraj on 9/14/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelApp-swift.h"
#import "DataModel.h"
#import "ColorUtils.h"

@interface TrainViewController : UIViewController<ServiceAdapterDelegate,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,sortingRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *trainTableView;

@end
