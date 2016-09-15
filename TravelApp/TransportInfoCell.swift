//
//  TransportInfoCell.swift
//  TravelApp
//
//  Created by Neeraj on 9/14/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

import UIKit

class TransportInfoCell: UITableViewCell {
    
    var transportVo:DataModel?{
        didSet{
            setInitialDataForTransportTable();
        }
    }
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var startTimeEndTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var noOfStopsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        logoImageView.image = nil
        startTimeEndTimeLabel.text = ""
        priceLabel.text = ""
        durationLabel.text = ""
        noOfStopsLabel.text = ""
        
    }
    
    private func setInitialDataForTransportTable()
    {
        print(transportVo!)
        print(transportVo?.transportId)
        print(transportVo?.price)
        priceLabel.text = "€ " + String(transportVo!.price)
        let imageUrl = transportVo?.providerLogoImage!.stringByReplacingOccurrencesOfString("{size}", withString: "63", options: NSStringCompareOptions.LiteralSearch, range: nil)
        loadImage(imageUrl!)
        startTimeEndTimeLabel.text = (transportVo?.departureTime)! + " - " + (transportVo?.arrivalTime)!
        noOfStopsLabel.text  = transportVo?.noOfStops == 0 ? "Direct" : String(transportVo!.noOfStops) + " Stops"
        durationLabel.text = getTravelDuration((transportVo?.departureTime)!,arrivalTime: (transportVo?.arrivalTime)!)
    }
    
    private func getTravelDuration(departureTime : String , arrivalTime : String) -> String{
        var depTimeArray = departureTime.componentsSeparatedByString(":")
        var arrivTimeArray = arrivalTime.componentsSeparatedByString(":")
        
        let depHour = Int(depTimeArray[0])
        let depMin = Int(depTimeArray[1])
        var arrivHour = Int(arrivTimeArray[0])
        var arrivMin = Int(arrivTimeArray[1])
        if(arrivMin < depMin){
            arrivMin = arrivMin! + 60;
            arrivHour = arrivHour! - 1;
        }
        let hourDiff = arrivHour! - depHour!
        let minDiff = arrivMin! - depMin!
        let diffTime = String(hourDiff) + ":" + String(minDiff) + " h"
        return diffTime
    }
    
    private func loadImage(imageUrl: String) -> Void
    {
        let key: String = imageUrl.MD5Hash() as String;
        var data: NSData? = FTWCache.objectForKey(key) as? NSData;
        if(data != nil)
        {
                dispatch_async(dispatch_get_main_queue(), {
                    self.setImage(data!);
                });
        }
        else
        {
            let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            dispatch_async(queue, {
                data = NSData(contentsOfURL: NSURL(string: imageUrl)!)
                FTWCache.setObject(data, forKey: key);
                    dispatch_async(dispatch_get_main_queue(), {
                        if let image = data{
                            self.setImage(image);
                        }
                    });
            });
        }
    }
    
    private func setImage(imageData : NSData){
        let image :UIImage = UIImage(data: imageData)!
        var imageWidth :CGFloat?
        if(image.size.width < (self.contentView.frame.width - 10)){
            imageWidth = 30 * (image.size.width/image.size.height)
        }else {
            imageWidth = self.contentView.frame.width - self.contentView.frame.width/2
        }
        imageWidthConstraint.constant = imageWidth!
        let imageData :NSData = UIImagePNGRepresentation(image)!;
        logoImageView!.image=UIImage(data:imageData)
    }

}
