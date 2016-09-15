//
//  FlightViewController.swift
//  TravelApp
//
//  Created by Neeraj on 9/15/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

import UIKit
import Foundation

class FlightViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ServiceAdapterDelegate,sortingRequestDelegate{
    
    var activityIndicator:UIActivityIndicatorView!;
    var flightArray: [DataModel]=[DataModel]();
    var arrivelTimeArray = [String]();
    var sortArray : SortArray?
    
    
    @IBOutlet weak var flightTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFlightService()
        setUpTableView()
    }
    
    private func getFlightService(){
        showBusyIndicator()
        let flightService = ServiceAdapter();
        flightService.delegate = self;
        flightService.initiateGetRequest(WebService.SERVICE_PREFIX+ServiceRequest.FLIGHTS);
    }
    
    
    private func setUpTableView(){
        flightTableView.registerNib(UINib(nibName: "TransportInfo", bundle: nil), forCellReuseIdentifier: "TransportInfoCell")
        self.flightTableView.delegate = self
        flightTableView.dataSource = self;
        self.flightTableView.reloadData()
        
    }
    
    //-------- ServiceAdapterDelegate----
    
    func serviceAdapterResponse(responseVO: ResponseVO) {
        print(responseVO.status)
        if(responseVO.status == responseVO.SUCCESS)
        {
            parseFlightServiceResponseData(responseVO.data)
            dispatch_async(dispatch_get_main_queue())
                {
                    self.activityIndicator.stopAnimating();
                    self.flightTableView.reloadData()
            }
        }
        else
        {
            PopupManager.toast("Something went wrong with network!!!", parent: self.view);
            self.hideBusyIndicator();
        }
        
    }
    
    private func parseFlightServiceResponseData(data:NSArray)
    {
        if(data.count == 0){
            PopupManager.toast("No Flight Records found!!!", parent: self.view);
            self.activityIndicator.stopAnimating();
        }
        else{
            for item in data{
                let flight = item as! NSMutableDictionary;
                arrivelTimeArray.append(item["arrival_time"] as! String)
                let flightVO : DataModel = DataModel.init(transportWebservice: flight)
                flightArray.append(flightVO);
            }
            sortArray = SortArray();
            flightArray = (sortArray?.sortByDepartureTimeAscending(flightArray))!
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let flightInfoCell:TransportInfoCell = tableView.dequeueReusableCellWithIdentifier("TransportInfoCell", forIndexPath: indexPath) as! TransportInfoCell
        flightInfoCell.transportVo = flightArray[indexPath.row]
        let lineFrame = CGRectMake(0, 85, self.view.frame.size.width, 2)
        let line = UIView(frame: lineFrame)
        line.backgroundColor = UIColor(string: "F0F0F0");
        flightInfoCell.addSubview(line)
        return flightInfoCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        PopupManager.toast("Offer details are not yet implemented!", parent: self.view)
    }
    
    
    /**
     This method shows busy indicator on screen.
     */
    private func showBusyIndicator()->Void
    {
        dispatch_async(dispatch_get_main_queue()){
            self.activityIndicator = BusyIndicator.show(self.view);
        }
    }
    
    /**
     This method hides busy indicator on screen.
     */
    private func hideBusyIndicator()->Void
    {
        dispatch_async(dispatch_get_main_queue()){
            self.activityIndicator.stopAnimating();
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let sortVC : SortByViewController = segue.destinationViewController as! SortByViewController
        sortVC.delegate = self;
        self.setPresentationStyleForSelfController(self, presentingController: sortVC)
    }
    
    func setPresentationStyleForSelfController(selfController : UIViewController, presentingController:UIViewController)
    {
        presentingController.providesPresentationContextTransitionStyle = true;
        presentingController.definesPresentationContext = true;
        if #available(iOS 8.0, *) {
            presentingController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        } else {
            presentingController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        };
    }
    
    func getSortingRequestType(requestType: String) {
        if(requestType == SortByRequest.ARRIVAl_ASCENDING){
            flightArray = (sortArray?.sortByArrivalTimeAscending(flightArray))!
        }
        if(requestType == SortByRequest.ARRIVAl_DESCENDING){
            flightArray = (sortArray?.sortByArrivalTimeDescending(flightArray))!
        }
        if(requestType == SortByRequest.DEPARTURE_ASCENDING){
            flightArray = (sortArray?.sortByDepartureTimeAscending(flightArray))!
        }
        if(requestType == SortByRequest.DEPARTURE_DESCENDING){
            flightArray = (sortArray?.sortByDepartureTimeDescending(flightArray))!
        }
        dispatch_async(dispatch_get_main_queue()){
            self.flightTableView.reloadData()
        }
    }
    
    

}
