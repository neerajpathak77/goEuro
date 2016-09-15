//
//  ResponseVO.swift
//  TravelApp
//
//  Created by Neeraj on 9/13/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

import UIKit

class ResponseVO: NSObject {
    override init()
    {
        
    }
    
    var requestName:String!;
    
    var _status:String?;
    
    let SUCCESS:String = "SUCCESS";
    let FAILURE:String = "FAILURE";
    
    var status:String?{
        set{
            _status = newValue;
        }
        get{
            return _status;
        }
    }
    
    var error:String!;
    var data:NSArray!
}
