//
//  ServiceAdapter.swift
//  TravelApp
//
//  Created by Neeraj on 9/14/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

import UIKit

class ServiceAdapter: NSObject, NSURLSessionDelegate {
    
    var dataTask:NSURLSessionDataTask!;
   var delegate:ServiceAdapterDelegate!;
    
    func initiateGetRequest(requestURL:String)
    {
        let encodedURL = requestURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding);
        getRequest(encodedURL!);
    }
    
    
    private func getRequest(getRequestURL:String)
    {
        let urll:NSURL? = NSURL(string: getRequestURL);
        let request = NSMutableURLRequest(URL: urll!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 10.0);
        request.HTTPMethod = "GET";
        let session = NSURLSession.sharedSession();
        let responseVo:ResponseVO = ResponseVO();
        dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse
            {
                print("status code==", httpResponse.statusCode)
                if(httpResponse.statusCode == 200)
                {
                    responseVo.status = "SUCCESS";
                    responseVo.data = self.parseResult(data!);
                }
                else
                {
                    print("no responce");
                    responseVo.status = "FAILURE";
                    responseVo.error = "INVALID_DATA"
                }
            }
            else
            {
                responseVo.status = "FAILURE";
                responseVo.error = "NETWORK_ERROR";
            }
            
            self.delegate?.serviceAdapterResponse(responseVo);
            self.suspendDataService();
        })
        
        dataTask.resume();
    }
    
    func suspendDataService()
    {
        if(dataTask != nil)
        {
            dataTask.suspend();
            dataTask = nil;
        }
        
    }
    
    func parseResult(data:NSData)->NSArray
    {
        let dataString = NSString(data: data, encoding:NSUTF8StringEncoding)
        print("data \(dataString)")
        var jsonObject:NSArray!;
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSArray
        } catch let error {
            print("json error: \(error)")
        }
        return jsonObject;
        
    }
}

//--------EXTENSIONS-----------

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        appendData(data!);
    }
}


//--------- PROTOCOLS ---------//

@objc protocol ServiceAdapterDelegate:class
{
    func serviceAdapterResponse(responseVO:ResponseVO);
}
