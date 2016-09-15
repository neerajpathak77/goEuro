//
//  BusyIndicator.swift
//  TravelApp
//
//  Created by Neeraj on 9/14/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

import UIKit

class BusyIndicator: NSObject {

    static var activityIndicator:UIActivityIndicatorView!;
    class func show(view:UIView)->UIActivityIndicatorView
    {
        if(activityIndicator == nil)
        {
            activityIndicator = UIActivityIndicatorView();
        }
        activityIndicator.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.6);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge;
        view.addSubview(activityIndicator);
        activityIndicator.startAnimating();
        return activityIndicator;
    }
    
}