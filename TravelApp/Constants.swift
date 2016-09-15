//
//  Constants.swift
//  TravelApp
//
//  Created by Neeraj on 9/15/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//


import Foundation;
import UIKit;

struct WebService
{
    static let HOST_NAME:String = "https://api.myjson.com/";
    static let SERVICE_PREFIX:String =  HOST_NAME + "bins/";

};

struct ServiceRequest
{
    static let FLIGHTS:String = "w60i";
    static let TRAINS:String = "3zmcy";
    static let BUSES:String = "37yzm";
};

struct SortByRequest
{
    static let ARRIVAl_ASCENDING:String = "ARRIVAl_ASCENDING";
    static let ARRIVAl_DESCENDING:String = "ARRIVAl_DESCENDING";
    static let DEPARTURE_ASCENDING:String = "DEPARTURE_ASCENDING";
    static let DEPARTURE_DESCENDING:String = "DEPARTURE_DESCENDING";
};

@objc class Constants : NSObject{
    private override init() {}
    class func getServicePrefix() -> String { return WebService.SERVICE_PREFIX }
    class func getTrainsService() -> String { return ServiceRequest.TRAINS }
    class func getBusService() -> String { return ServiceRequest.BUSES }
    class func getArrivalAscendingType() -> String { return SortByRequest.ARRIVAl_ASCENDING }
    class func getArrivalDescendingType() -> String { return SortByRequest.ARRIVAl_DESCENDING }
    class func getDepartureAscendingType() -> String { return SortByRequest.DEPARTURE_ASCENDING }
    class func getDepartureDescendingType() -> String { return SortByRequest.DEPARTURE_DESCENDING }
}