//
//  SortByViewController.swift
//  TravelApp
//
//  Created by Neeraj on 9/15/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//


import UIKit

class SortByViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {

    var menuItems: [String] = ["header","arrrivalAscending","arrrivalDescending","DepartureAscending","DepartureDescending"]
    var delegate:sortingRequestDelegate?;
    @IBOutlet weak var sortByTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTapGestureOnScreen();
        setDelegates()
        decorateUI()
    }
    private func decorateUI()
    {
        self.sortByTableView.layer.cornerRadius = 5.0
        self.sortByTableView.clipsToBounds = true;
    }
    private func setDelegates()
    {
        self.sortByTableView.delegate = self;
        self.sortByTableView.dataSource = self;
    }
   
    private func setTapGestureOnScreen()
    {
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "screenTapped:")
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.view.userInteractionEnabled = true;
        self.view.addGestureRecognizer(tapGesture);
    }
   
    func screenTapped(gesture:UITapGestureRecognizer)
    {
        self.dismissViewControllerAnimated(false, completion: nil);
    }
    //Handle touch so that this will not effect table view cell selection'
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if let view = touch.view{
            if(view.isDescendantOfView(sortByTableView)){
                return false
            }
        }
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier:String? = menuItems[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier!, forIndexPath: indexPath) as UITableViewCell
        let lineFrame = CGRectMake(0, 28, self.view.frame.size.width, 1)
        let line = UIView(frame: lineFrame)
        line.backgroundColor = UIColor(string: "F0F0F0");
        cell.addSubview(line)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30.0
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
        case 1:
            self.delegate?.getSortingRequestType(SortByRequest.ARRIVAl_ASCENDING);
            break;
        case 2:
            self.delegate?.getSortingRequestType(SortByRequest.ARRIVAl_DESCENDING);
            break;
        case 3:
            self.delegate?.getSortingRequestType(SortByRequest.DEPARTURE_ASCENDING);
            break;
        case 4:
            self.delegate?.getSortingRequestType(SortByRequest.DEPARTURE_DESCENDING);
            break;
        default:
            break;
        }
        self.dismissViewControllerAnimated(false, completion: nil);
    }
    
}


//--------- PROTOCOLS ---------//

@objc protocol sortingRequestDelegate:class
{
    func getSortingRequestType(requestType:String);
}
