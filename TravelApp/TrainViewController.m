//
//  TrainViewController.m
//  TravelApp
//
//  Created by Neeraj on 9/14/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

#import "TrainViewController.h"

@interface TrainViewController ()
{
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray* trainArray;
    SortArray *sortArray;
    
}

@end
@implementation TrainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getFlightService];
    [self setUpTableView];
    
}

- (void) getFlightService{
    [self showBusyIndicator];
    ServiceAdapter* trainService = [[ServiceAdapter alloc]init];
    trainService.delegate = self;
    NSString * strUrl = [[Constants getServicePrefix] stringByAppendingString:[Constants getTrainsService]];
    [trainService initiateGetRequest:strUrl];
}

- (void)setUpTableView
{
    UINib *cellNib = [UINib nibWithNibName:@"TransportInfo" bundle:nil];
    [self.trainTableView registerNib:cellNib forCellReuseIdentifier:@"TransportInfoCell"];
    self.trainTableView.delegate = self;
    self.trainTableView.dataSource = self;
    [self.trainTableView reloadData];
    
}

//-------- ServiceAdapterDelegate----

- (void) serviceAdapterResponse : (ResponseVO *)responseVO {
    if([responseVO.status isEqualToString:responseVO.SUCCESS])
    {
        [self parseBusServiceResponseData : responseVO.data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideBusyIndicator];
            [self.trainTableView reloadData];
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
        [PopupManager toast:@"No Train Records found!!!" parent:self.view];
        [self hideBusyIndicator];
    }
    else{
        trainArray = [NSMutableArray array];
        for (NSMutableDictionary *item in data)
        {
            DataModel *data_model = [[DataModel alloc]initWithTransportWebservice:item];
            [self->trainArray addObject:data_model];
        }
        sortArray = [[SortArray alloc] init];
        trainArray = [sortArray sortByDepartureTimeAscending:trainArray];
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return trainArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    TransportInfoCell *trainInfoCell = (TransportInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"TransportInfoCell" forIndexPath:indexPath];
    trainInfoCell.transportVo = (DataModel*)trainArray[indexPath.row];
    CALayer *separator = [CALayer layer];
    UIColor *color = [UIColor colorWithString:@"F0F0F0"];
    if (color)
    {
        separator.backgroundColor = color.CGColor;
    }
    separator.frame = CGRectMake(0, 85, self.view.frame.size.width, 2);
    [trainInfoCell.layer addSublayer:separator];
    return trainInfoCell;
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
- (IBAction)sortButtonTapped:(UIButton *)sender {
    
    //[self performSegueWithIdentifier:@"showView" sender:self];
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
        trainArray = [sortArray sortByArrivalTimeAscending:trainArray];
    }
    if([requestType isEqualToString:[Constants getArrivalDescendingType]]){
        trainArray = [sortArray sortByArrivalTimeDescending:trainArray];
    }
    if([requestType isEqualToString:[Constants getDepartureAscendingType]]){
        trainArray = [sortArray sortByDepartureTimeAscending:trainArray];
    }
    if([requestType isEqualToString:[Constants getDepartureDescendingType]]){
        trainArray = [sortArray sortByDepartureTimeDescending:trainArray];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.trainTableView reloadData];
    });
    
}





@end
