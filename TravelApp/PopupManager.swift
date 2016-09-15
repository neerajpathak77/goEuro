//
//  PopupManager.swift
//  TravelApp
//
//  Created by Neeraj on 9/14/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

import UIKit

class PopupManager: NSObject {
   
    class func toast(message:String, parent:UIView)
    {
        dispatch_async(dispatch_get_main_queue()){
            parent.makeToast(message);
            
        }
    }
}
