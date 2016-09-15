//
//  DataModel.m
//  TravelApp
//
//  Created by Neeraj on 9/14/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (id)initWithTransportWebservice :(NSMutableDictionary*) dictinary
{
    self = [super init];
    if (self) {
        self.transportId =[NSString stringWithFormat:@"%@", [dictinary valueForKey:@"id"]];
        self.price = [[dictinary valueForKey:@"price_in_euros"] doubleValue];
        self.departureTime = [dictinary valueForKey:@"departure_time"];
        self.arrivalTime = [dictinary valueForKey:@"arrival_time"];
        self.noOfStops = [[dictinary valueForKey:@"number_of_stops"] integerValue];
        self.providerLogoImage = [dictinary valueForKey:@"provider_logo"];
    }
    return self;
}


@end
