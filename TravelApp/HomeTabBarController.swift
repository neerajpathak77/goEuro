//
//  HomeTabBarController.swift
//  TravelApp
//
//  Created by Neeraj on 9/15/16.
//  Copyright © 2016 GoEuro. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabIcons()
        // Do any additional setup after loading the view.
    }

    private func setTabIcons()
    {
        let tabBar = self.tabBar;
        tabBar.tintColor = UIColor(string: "2eb77c");
        //	tabBar.tintColor = UIColor(string: "f39c3d");
        for(var i = 0; i < tabBar.items?.count; i += 1)
        {
            let tabItem:UITabBarItem = (tabBar.items?[i])!;
            tabItem.imageInsets = UIEdgeInsetsMake(5.0, 0.0, -5.0, 0.0);
            tabItem.image = tabItem.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        }
    }

}
