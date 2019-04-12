//
//  HomeViewController.swift
//  FootBallApp
//
//  Created by Praveen Khare on 13/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire
import KFSwiftImageLoader

class HomeViewController: UIViewController {

    var filterTableView = UITableView()
    var team_id:String?
    var window: UIWindow?
    var strfilter = "0";
    
    @IBOutlet var overviewContainer: UIView!
    
    @IBAction func btnFixtureClk(_ sender: Any) {
        
        searchButton.isEnabled=true
      let image = UIImage(named: "filter")
        searchButton = UIBarButtonItem(image: image, landscapeImagePhone: image, style: .plain, target: self, action: #selector(HomeViewController.didTapSearchButton(sender:)))
        
        if self.filterTableView.isHidden == false {
            self.filterTableView.isHidden = true
        }
        else{
            self.filterTableView.isHidden = true
        }
        self.overviewContainer.isHidden = true
        self.containerFixture.isHidden = false
        self.btnOver_View.backgroundColor = UIColor.white
      //  self.btnOverview.titleLabel?.textColor = UIColor.gray
       // self.btnFixture.setTitleColor(UIColor.black, for: .normal)
        self.btnFixtView.backgroundColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
    }
    @IBAction func btnOverviewClk(_ sender: Any) {
        searchButton.isEnabled=false
//          let image = UIImage(named: " ")
//       searchButton = UIBarButtonItem(image: image, landscapeImagePhone: image, style: .plain, target: self, action: #selector(HomeViewController.didTapSearchButton(sender:)))
        
        if self.filterTableView.isHidden == false {
            self.filterTableView.isHidden = true
        }
        else{
        self.filterTableView.isHidden = true
        }
        self.overviewContainer.isHidden = false
        self.containerFixture.isHidden = true
        self.btnFixtView.backgroundColor = UIColor.white
       // self.btnFixture.titleLabel?.textColor = UIColor.gray
        //self.btnOverview.setTitleColor(UIColor.black, for: .selected)
        self.btnOver_View.backgroundColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
       
    }
    @IBOutlet var containerFixture: UIView!
    @IBOutlet var btnFixtView: UIView!
    @IBOutlet var btnOver_View: UIView!
    @IBOutlet var btnFixture: UIButton!
    @IBOutlet var btnOverview: UIButton!
    @IBOutlet var btnBackgroungView: UIView!
    @IBOutlet var selectedTeamName: UILabel!
    @IBOutlet var selectedTeamImage: UIImageView!
    var tableData: [String] = ["All","Superliga","Premiership"]
    var searchButton = UIBarButtonItem()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filterTableView.isHidden = true
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.hideKeyboardWhenTappedAround()
        
        self.overviewContainer.isHidden = false
        self.containerFixture.isHidden = true
        self.btnFixtView.backgroundColor = UIColor.white
        self.btnOver_View.backgroundColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
        //let filterImage   = UIImage(named: "filter")!
        
        let settingImage = UIImage(named: "setting_tabbar_btn")!
       
        
        let settingButton   = UIBarButtonItem(image: settingImage, landscapeImagePhone: settingImage, style: .plain, target: self, action: #selector(HomeViewController.didTapSettingButton(sender:)))
//       searchButton = UIBarButtonItem(image: filterImage, landscapeImagePhone: filterImage, style: .plain, target: self, action: #selector(HomeViewController.didTapSearchButton(sender:)))
        
        //searchButton = UIBarButtonItem(image: nil, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
      //  searchButton.isEnabled=false
     let tittlename = NSLocalizedString("My Team", comment: "")
        self.navigationItem.title =  tittlename
       // self.navigationItem.rightBarButtonItems = [settingButton, searchButton]
         self.navigationItem.rightBarButtonItem = settingButton
        
        let pref = UserDefaults.standard
        if let t_id = pref.object(forKey: "TEAM_ID") {
            self.team_id = t_id as? String
            if team_id == "" {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
                UIApplication.shared.keyWindow?.rootViewController = viewController
            }
            else
            {
                getTeamDataFromAPI(id: team_id!)
            }
        }
        else {
            let alert = UIAlertController(title: "Error", message: "You are not logged in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
                UIApplication.shared.keyWindow?.rootViewController = viewController
            })
        }
        
        filterTableView.frame = CGRect(x: 200, y: 70, width: 140, height: 120)
        filterTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        filterTableView.rowHeight = 40
        filterTableView.backgroundColor = UIColor(red:0.96, green:0.98, blue:1.00, alpha:1.0)
        self.view.addSubview(filterTableView)
        filterTableView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: filterTableView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: self.topLayoutGuide,
                                               attribute: .bottom,
                                               multiplier: 1,
                                               constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: self.view,
                                                    attribute: .trailingMargin,
                                                    relatedBy: .equal,
                                                    toItem: filterTableView,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: self.bottomLayoutGuide,
                                                  attribute: .top,
                                                  relatedBy: .equal,
                                                  toItem: filterTableView,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: 300)
        
        let widthConstraint = NSLayoutConstraint(item: filterTableView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: 140)
        let heightConstraint = NSLayoutConstraint(item: filterTableView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 120)
        self.view.addConstraints([trailingConstraint])
        view.addConstraints([topConstraint, bottomConstraint, widthConstraint, heightConstraint])

    }

    func didTapSettingButton(sender: AnyObject){
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "setting") as? SettingViewController
        self.navigationController?.pushViewController(settingVC!, animated: true)
    }
    
    func didTapSearchButton(sender: AnyObject){
        if (filterTableView.isHidden == true ) {
            filterTableView.isHidden = false
        }
        else {
            filterTableView.isHidden = true
        }

    }
    func getTeamDataFromAPI(id:String) {
        // self.team_id = UserDefaults.standard.string(forKey: "TEAM_ID")!
        self.view.isUserInteractionEnabled = false
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=getTeamDetailMetch&team_id=\(id)")!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let resJson = response.result.value as? NSDictionary {
                    if (resJson["RESPONSECODE"] as? Int) != nil {
                        //   print("RESPONSE CODE>> \(responceCode )")
                    }
                    if let resArray = resJson.value(forKey: "RESPONSE") as? [AnyObject] {
                        
                      //  UserDefaults.standard.set(resJson, forKey: "resArray")
                        for arr in resArray {
                            let name = arr["name"] as? String
                               UserDefaults.standard.set(name, forKey: "name")
                            let logo = arr["logo"] as? String
                               UserDefaults.standard.set(logo, forKey: "logo")
                            DispatchQueue.main.async {
                                self.selectedTeamName.text = name!
                                
                                self.selectedTeamImage.loadImage(urlString: logo!)
                        self.view.isUserInteractionEnabled = true
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        cell.textLabel?.font = UIFont(name:"Avenir", size:16)
        // cell.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.98, alpha:1.0)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterTableView.isHidden = true
    }
    
}
