


//
//  TabBarViewController.swift
//  FootBallApp
//
//  Created by Praveen Khare on 03/04/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class TabBarViewController: UITabBarController,UITabBarControllerDelegate {

    var leageName:[String] = []
    var gotoLive = ""
    var gotLeagueName = Set<String>()
    var customDict = Dictionary<String, AnyObject>()
    
    let tab = UITabBarController()
    override func viewDidLoad() {
        super.viewDidLoad()
       // getTheTabCount()
        self.tabBar.barTintColor = UIColor(red:0.80, green:0.88, blue:0.93, alpha:1.0)
    
        print("COUNT>> \(gotLeagueName)")
        self.delegate = self
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    
//        var viewControllers: [UIViewController]? = self.tabBarController?.viewControllers
//        let listView: TeamTableViewController? = (viewControllers?[1] as? TeamTableViewController)
        // listView?.tabCount = leageName
        tabBarController?.selectedIndex = 1
//        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
//        var listView: TeamTableViewController? = (storyboard.instantiateViewController(withIdentifier: "team_table") as? TeamTableViewController)
//
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("the selected index is : \(tabBar.items?.index(of: item))")
        let selectedTab = "\(tabBar.items?.index(of: item))" as! String
        if selectedTab == "Optional(1)"{
//            let fixtureeeViewController = self.storyboard?.instantiateViewController(withIdentifier: "fixtureeeViewController") as? fixtureeeViewController
//
//            self.navigationController?.pushViewController(fixtureeeViewController!, animated: false)
            
        }
    }
}


