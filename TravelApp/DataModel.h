//
//  DataModel.h
//  TravelApp
//
//  Created by Neeraj on 9/14/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property (strong,nonatomic) NSString*transportId;
@property  float price;
@property (strong,nonatomic) NSString*departureTime;
@property (strong,nonatomic) NSString*arrivalTime;
@property  NSInteger noOfStops;
@property (strong,nonatomic) NSString*providerLogoImage;

- (instancetype)initWithTransportWebservice :(NSMutableDictionary*) dictinary;
@end
