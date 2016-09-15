//
//  BusViewController.m
//  TravelApp
//
//  Created by Neeraj on 9/14/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

#import "BusViewController.h"
#import "DataModel.h"

@interface BusViewController ()
{
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray* busArray;
    SortArray *sortArray;
    
}

@end

@implementation BusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getFlightService];
    [self setUpTableView];
    
}

- (void) getFlightService{
    [self showBusyIndicator];
    ServiceAdapter* flightService = [[ServiceAdapter alloc]init];
    flightService.delegate = self;
    NSString * strUrl = [[Constants getServicePrefix] stringByAppendingString:[Constants getBusService]];
    [flightService initiateGetRequest:strUrl];
}

- (void)setUpTableView
{
    UINib *cellNib = [UINib nibWithNibName:@"TransportInfo" bundle:nil];
    [self.busTableView registerNib:cellNib forCellReuseIdentifier:@"TransportInfoCell"];
    self.busTableView.delegate = self;
    self.busTableView.dataSource = self;
    [self.busTableView reloadData];
    
}

//-------- ServiceAdapterDelegate----

- (void) serviceAdapterResponse : (ResponseVO *)responseVO {
    if([responseVO.status isEqualToString:responseVO.SUCCESS])
    {
        [self parseBusServiceResponseData : responseVO.data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideBusyIndicator];
            [self.busTableView reloadData];
        });
    }
    else
    {
        [PopupManager toast:@"Something went wrong with network!!!" parent:self.view];
        [self hideBusyIndicator];
    }
    
}

- (void) parseBusServiceResponseData : (NSArray*)data
{
    if(data.count == 0){
        [PopupManager toast:@"No Bus Records found!!!" parent:self.view];
        [self hideBusyIndicator];
    }
    else{
        busArray = [NSMutableArray array];
        for (NSMutableDictionary *item in data)
        {
            DataModel *data_model = [[DataModel alloc]initWithTransportWebservice:item];
            [self->busArray addObject:data_model];
        }
        sortArray = [[SortArray alloc] init];
        busArray = [sortArray sortByDepartureTimeAscending:busArray];
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return busArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    TransportInfoCell *busInfoCell = (TransportInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"TransportInfoCell" forIndexPath:indexPath];
    busInfoCell.transportVo = (DataModel*)busArray[indexPath.row];
    CALayer *separator = [CALayer layer];
    UIColor *color = [UIColor colorWithString:@"F0F0F0"];
    if (color)
    {
        separator.backgroundColor = color.CGColor;
    }
    separator.frame = CGRectMake(0, 85, self.view.frame.size.width, 2);
    [busInfoCell.layer addSublayer:separator];
    return busInfoCell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 90;
}

-(void)tableView :(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [PopupManager toast : @"Offer details are not yet implemented!" parent:self.view];
     }

/**
 This method shows busy indicator on screen.
 */
- (void) showBusyIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->activityIndicator = [BusyIndicator show:self.view];
    });
}

/**
 This method hides busy indicator on screen.
 */
- (void) hideBusyIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->activityIndicator stopAnimating];
    });
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SortByViewController *newVC = segue.destinationViewController;
    newVC.delegate = self;
    [self setPresentationStyleForSelfController:self presentingController:newVC];
}

- (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    presentingController.providesPresentationContextTransitionStyle = YES;
    presentingController.definesPresentationContext = YES;
    
    [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}

-(void) getSortingRequestType:(NSString *)requestType{
    if([requestType isEqualToString:[Constants getArrivalAscendingType]]){
        busArray = [sortArray sortByArrivalTimeAscending:busArray];
    }
    if([requestType isEqualToString:[Constants getArrivalDescendingType]]){
        busArray = [sortArray sortByArrivalTimeDescending:busArray];
    }
    if([requestType isEqualToString:[Constants getDepartureAscendingType]]){
        busArray = [sortArray sortByDepartureTimeAscending:busArray];
    }
    if([requestType isEqualToString:[Constants getDepartureDescendingType]]){
        busArray = [sortArray sortByDepartureTimeDescending:busArray];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.busTableView reloadData];
    });
    
}




@end
