//
//  SortArray.swift
//  TravelApp
//
//  Created by Neeraj on 9/14/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

import Foundation

class SortArray: NSObject {
    
    func sortByDepartureTimeAscending(var trasportArray: [DataModel])->[DataModel]{
        trasportArray = trasportArray.sort{($0.departureTime as String) < ($1.departureTime as String)}
        return trasportArray;
    }
    
    func sortByDepartureTimeDescending(var trasportArray: [DataModel])->[DataModel]{
        trasportArray = trasportArray.sort{($0.departureTime as String) > ($1.departureTime as String)}
        return trasportArray;
    }
    
    func sortByArrivalTimeAscending(var trasportArray: [DataModel])->[DataModel]{
        trasportArray = trasportArray.sort{($0.arrivalTime as String) < ($1.arrivalTime as String)}
        return trasportArray;
    }
    
    func sortByArrivalTimeDescending(var trasportArray: [DataModel])->[DataModel]{
        trasportArray = trasportArray.sort{($0.arrivalTime as String) > ($1.arrivalTime as String)}
        return trasportArray;
    }
}

