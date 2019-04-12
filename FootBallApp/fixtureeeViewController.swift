//
//  fixtureeeViewController.swift
//  FootBallApp
//
//  Created by AS182 on 7/19/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire
import StoreKit


class fixtureeeViewController: UIViewController,UpdtaeDataOnFixtureDelegate {
    
    var filterTableView = UITableView()
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    
    
    @IBOutlet weak var collView: UICollectionView!
    
    @IBOutlet weak var fixtureView: UIView!
    @IBOutlet weak var overviewBtn: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet var btnOver_View: UIView!
    @IBOutlet weak var teamName: UILabel!
    var fixture  = [fixtureCellDataClass1]()
    var futureFixture  = [fixtureCellDataClass1]()
    var fixture1  = NSMutableArray()
    var futureMatchArray  = NSMutableArray()
    var PastMatchesCountArray  = NSMutableArray()
    var indexerArray  = NSMutableArray()
    var fixture2  = NSMutableArray()
    var matchArray  = NSArray()
    var DropDownArray  = [NSMutableArray]()
    var IndexArray = NSMutableArray()
    var leagueName = [String]()
    var leagueName1 = [String]()
    var stirngfilter = String()
    var searchStr  = String()
    var selectedMatchId = String()
    var headerName = [String] ()
    var green  = ""
    var selectedIndex : Int = 0
    var blinkStatus = false
    var NoWin : Int = 0
    var Nodraw : Int = 0
    var NoLoss : Int = 0
    var LiveOn : Int = 0
    var FixtureIndex : Int = 0
    
    var colValue = "0"
    var gotoDetail : String = ""
    var livematchID : String = ""
    //  var abbreviationName = ""
    
    
    var currentDate = Date()
    var matchDate = Date()
    var strMatchDate :String = ""
    // var tableData = NSArray()
    var filterData: [String] = ["All","Superliga","Premiership"]
    var filtertable :String = ""
    var collIndex = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableData = [NSArray (array: ["All","Superliga","Premiership"])]
        let team_id:String = UserDefaults.standard.string(forKey: "TEAM_ID")!
        self.newData()
        getTeamDataFromAPI(id: team_id)
        self.hideKeyboardWhenTappedAround()
        activityIndicator.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/4)
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        let data = UserDefaults.standard.object(forKey: "name")
        self.teamName.text = data as? String
        let mylogo = UserDefaults.standard.object(forKey: "logo")
        self.teamLogo.loadImage(urlString: mylogo as! String)
        self.filterTableView.isHidden = true
        filterTableView.delegate = self
        filterTableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.myTableView.frame.size.width, height: 190))
                self.myTableView.tableFooterView = customView
                
            case 1334:
                print("iPhone 6/6S/7/8")
                let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.myTableView.frame.size.width, height: 280))
                self.myTableView.tableFooterView = customView
                
            case 2208:
                print("iPhone 6+/6S+/7+/8+")
                let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.myTableView.frame.size.width, height: 355))
                self.myTableView.tableFooterView = customView
                
                
            case 2436:
                print("iPhone X")
                let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.myTableView.frame.size.width, height: 365))
                self.myTableView.tableFooterView = customView

            default:
                print("unknown")
            }
        }
        self.stirngfilter = "All"
        self.update()
        var timer = Timer.scheduledTimer(timeInterval: 01.0, target: self, selector: #selector(self.BlinkCells), userInfo: nil, repeats: true )
        //        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "setting") as? SettingViewController
        //        settingVC?.delegate = self
        
        
    }
    func BlinkCells() {
        if IndexArray.count == 1{
            
            let firstIndexArr = IndexArray.firstObject as! NSDictionary
            let reloadIndex = firstIndexArr.value(forKey: "index") as! Int
            
       
        let indexPath = IndexPath(item: reloadIndex, section: 0)
            updateBlinkLbl ()
        myTableView.reloadRows(at: [indexPath], with: .none)
            
        }
    }
    func updateBlinkLbl () {
        let firstIndexArr1 = IndexArray.firstObject as! NSDictionary
        let reloadIndex1 = firstIndexArr1.value(forKey: "index") as! Int
         let c = self.myTableView.cellForRow(at: NSIndexPath(row: reloadIndex1, section: 0) as IndexPath) as? customCell1
        c?.blinkLbl.layer.cornerRadius = (c?.blinkLbl.frame.width)!/2
        c?.blinkLbl.layer.masksToBounds = true
        if blinkStatus == false {
            c?.blinkLbl.backgroundColor = UIColor.white
            blinkStatus = true
        }else{
           c?.blinkLbl.backgroundColor = UIColor.red
              blinkStatus = false
        }
    }
    func didTapSettingButton(sender: AnyObject){
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "setting") as? SettingViewController
        settingVC?.comesFrom = "Fixture"
        self.navigationController?.pushViewController(settingVC!, animated: true)
    }
    func didTapSearchButton(sender: AnyObject){
        if (filterTableView.isHidden == true ) {
            filterTableView.isHidden = false
            //            filterTableView.delegate = self
            //            filterTableView.dataSource = self
            //            filtertable  = "yes"
        }
        else {
            filterTableView.isHidden = true
            // filtertable  = ""
        }
        
    }
    func comesFrom(setting: String) {
        if setting == "Setting"{
            self.viewDidLoad()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let settingImage = UIImage(named: "setting_tabbar_btn")!
        
        let settingButton   = UIBarButtonItem(image: settingImage, landscapeImagePhone: settingImage, style: .plain, target: self, action: #selector(fixtureeeViewController.didTapSettingButton(sender:)))
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        let tittlename = NSLocalizedString("Fixture", comment: "")
        self.navigationItem.title = tittlename 
        self.navigationItem.rightBarButtonItems = [settingButton]
        
        self.hideKeyboardWhenTappedAround()
        let tabIndex = self.tabBarController?.selectedIndex
        
        
        colValue = "0"
        
        self.fixture.removeAll()
        //self.fixture1.removeAllObjects()
        filterTableView.frame = CGRect(x: 150, y: 70, width: 200, height: 120)
        
        filterTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        filterTableView.rowHeight = 40
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
                                                 constant: 160)
        let heightConstraint = NSLayoutConstraint(item: filterTableView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 120)
        self.view.addConstraints([trailingConstraint])
        view.addConstraints([topConstraint, bottomConstraint, widthConstraint, heightConstraint])
        collView.delegate = self
        collView.dataSource = self
        let setting =   UserDefaults.standard.object(forKey:"setting") as? String
        if setting != nil{
            if setting! == "setting"{
                self.viewDidLoad()
                UserDefaults.standard.removeObject(forKey: "setting")
            }
        }
        
    }
    
    func  update(){
        self.getTeamDataFromAPI()
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        // self.navigationController?.popViewController(animated: false)
    }
    @IBAction func overview(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
        
    }
    func getTeamDataFromAPI(id:String) {
        self.view.isUserInteractionEnabled = false
        
        // self.team_id = UserDefaults.standard.string(forKey: "TEAM_ID")!
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
                                self.teamName.text = name!
                                self.teamLogo.loadImage(urlString: logo!)
                                self.view.isUserInteractionEnabled = true
                            }
                            
                        }
                    }
                }
            }
        }
    }
    func newData()
    {
        activityIndicator.startAnimating()
        let url : URLConvertible = URL(string: "https://soccer.sportmonks.com/api/v2.0/livescores?api_token=qs0SFsIwHskD0pFRK2nDgAU66RIUJc9tTb6mPcHes9H0eOGX5HSKvfm44eIK&include=localTeam,visitorTeam,substitutions,goals,cards,league,season,events,venue")!
        print(url)
        
        //   let url : URLConvertible = URL(string: "https://soccer.sportmonks.com/api/v2.0/fixtures/between/2017-09-27/2017-09-27?api_token=qs0SFsIwHskD0pFRK2nDgAU66RIUJc9tTb6mPcHes9H0eOGX5HSKvfm44eIK&page=1&include=localTeam,visitorTeam,substitutions,goals,league,season,events,venue")!
        
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if(response.result.isSuccess){
                if let myData = response.result.value as? [String: AnyObject]{
                    print(myData)
                    print(myData["data"] as? NSArray as Any)
                    self.matchArray = (myData["data"] as? NSArray)!
                    //                    let searchPredicate = NSPredicate(format: "id == 1847285")
                    //                    let filtered = (matchArray)?.filtered(using: searchPredicate ) as! NSArray
                    //                    print(filtered)
                }
            }
        }
        
        //            else if response.result.isFailure {
        //
        //                print( "SOME ERROR IS JSON DATA")
        //            }
    }
    //    }
    
    
    
    func getTeamDataFromAPI() {
        //   self.view.isUserInteractionEnabled = false
        self.activityIndicator.startAnimating()
        let team_id:String = UserDefaults.standard.string(forKey: "TEAM_ID")!
        print("TEAM ID >>>>>\(team_id)")
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=getTeamDetailMetch&team_id=\(team_id)")!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let resJson = response.result.value as? NSDictionary {
                    if let responceCode = resJson["RESPONSECODE"] as? Int {
                        print("RESPONSE CODE>> \(responceCode )")
                    }
                    if let resArray = resJson.value(forKey: "RESPONSE") as? [AnyObject] {
                        // let result = resJson.value(forKey: "matchResults") as? [AnyObject]
                        self.fixture1.removeAllObjects()
                        self.PastMatchesCountArray.removeAllObjects()
                        self.futureMatchArray.removeAllObjects()
                        self.headerName.append("All")
                        
                        for arr in resArray {
                            _ = arr["logo"] as? String
                            if (arr["pastmatches"] as? NSArray) != nil {
                                // print(pastMachtes)
                            }
                            if let overAllWinDraw = arr["windraw"] as? [AnyObject] {
                                // self.headerName.append("All")
                                if overAllWinDraw.count != 0 {
                                    for allwin in overAllWinDraw{
                                        // let name = allwin.value(forKey: "name")
                                        let win = allwin.value(forKey: "win") as! String
                                        self.NoWin  = Int(win )!
                                        print( self.NoWin)
                                        let draw = allwin.value(forKey: "draw") as! String
                                        self.Nodraw  = Int(draw )!
                                        print( self.Nodraw)
                                        let  Loss = allwin.value(forKey: "loss") as! String
                                        self.NoLoss  = Int(Loss )!
                                        print( self.NoLoss)
                                    }
                                }
                            }
                            
                            // win of Superliga
                            
                            //                            else{
                            if let finalValue = arr["matchResults"] as? String {
                                // there's a value!
                            }
                            else{
                                if let winmatches = (arr.value(forKey: "matchResults") as! NSDictionary).value(forKey: "win") as? [AnyObject]{
                                    if winmatches.count != 0 {
                                        self.fixture.removeAll()
                                        
                                        var countCheck = 0
                                        for future in winmatches {
                                            let league = future["competition_name"] as! String
                                            self.leagueName1 = [league]
                                            self.leagueName .append(league)
                                            self.headerName.append(league as! String)
                                            let match_id = future["match_id"] as? String
                                            
                                            UserDefaults.standard.set(match_id, forKey: "match_id")
                                            UserDefaults.standard.synchronize()
                                            
                                            let startingDate = future["starting_date"] as? String
                                            let ht_score = future["ht_score"] as? String
                                            let ft_score = future["ft_score"] as? String
                                            let startingTime = future["starting_time"] as! String
                                            let a_name = future["AwayTeam"] as? String
                                            let h_name = future["HomeTeam"] as? String
                                            let hometeamID = future["home_team_id"] as? String
                                            let AwayTeamId = future["away_team_id"] as? String
                                            let AwayTeamLogo = future["AwayTeamLogo"] as? String
                                            let compatitonName =  future["competition_name"] as? String
                                            let obj = fixtureCellDataClass1(away_team_name: a_name!, homwe_team_name: h_name!, startingTime: startingTime, startingDte: startingDate!, matchID: match_id!, ht_score: ht_score!,compatitonName: compatitonName!,ft_score: ft_score!)
                                            let HomeTemaLogo = future["HomeTemaLogo"] as? String
                                            let stadiumName = future["venue_id"] as? String
                                            let newAdd = ["away_team_name":"\(a_name ?? "")","AwayTeamId":"\(AwayTeamId ?? "")","AwayTeamLogo":"\(AwayTeamLogo ?? "")","homwe_team_name":"\(h_name ?? "")","hometeamID":"\(hometeamID ?? "")","startingTime":"\(startingTime)","startingDte":"\(startingDate ?? "")","matchID":"\(match_id ?? "")","ht_score":"\(ft_score ?? "")","compatitonName":"\(compatitonName ?? "")","HomeTemaLogo":"\(HomeTemaLogo ?? "")","stadiumName":"\(stadiumName ?? "")"] as NSDictionary
                                            self.fixture1.add(newAdd)
                                            self.PastMatchesCountArray.add(newAdd)
                                            self.fixture.append(obj)
                                            countCheck += 1
                                            
                                        }
                                    }
                                    else {
                                        print("No future matches available for selecetd team ID")
                                        self.activityIndicator.stopAnimating()
                                    }
                                }
                                
                                //  }
                                //Draw matches for Premiership
                                
                                if let Drawmatches = (arr.value(forKey: "matchResults") as! NSDictionary).value(forKey: "draw")as? [AnyObject]{
                                    if Drawmatches.count != 0 {
                                        var drawCount = 0
                                        for draw in Drawmatches {
                                            let league = draw["competition_name"] as! String
                                            self.leagueName1 = [league]
                                            self.leagueName .append(league)
                                            self.headerName.append(league as! String)
                                            let match_id = draw["match_id"] as? String
                                            
                                            UserDefaults.standard.set(match_id, forKey: "match_id")
                                            UserDefaults.standard.synchronize()
                                            
                                            
                                            let startingDate = draw.value(forKey: "starting_date")
                                            let startingTime = draw.value(forKey: "starting_time") as! String
                                            
                                            var a_name = "" as String
                                            if (draw["AwayTeam"] as? String) != nil {
                                                a_name = draw.value(forKey: "AwayTeam") as! String
                                            }
                                            var h_name = "" as String
                                            if (draw["HomeTeam"] as? String) != nil {
                                                h_name = draw.value(forKey: "HomeTeam") as! String                                }
                                            let ht_score = draw.value(forKey: "ht_score")
                                            let ft_score = draw.value(forKey: "ft_score")
                                            let compatitonName = draw.value(forKey: "competition_name")
                                            let hometeamID = draw["home_team_id"] as? String
                                            let AwayTeamId = draw["away_team_id"] as? String
                                            print(draw)
                                            let obj = fixtureCellDataClass1(away_team_name: a_name, homwe_team_name: h_name, startingTime: startingTime as! String, startingDte: startingDate! as! String, matchID: match_id!, ht_score: ht_score! as! String, compatitonName: compatitonName! as! String,ft_score: ft_score! as! String)
                                            
                                            let AwayTeamLogo = draw["AwayTeamLogo"] as? String
                                            let HomeTemaLogo = draw["HomeTemaLogo"] as? String
                                            let stadiumName = draw["venue_id"] as? String
                                            let newAdd = ["away_team_name":"\(a_name ?? "")","AwayTeamId":"\(AwayTeamId ?? "")","AwayTeamLogo":"\(AwayTeamLogo ?? "")","homwe_team_name":"\(h_name ?? "")","hometeamID":"\(hometeamID ?? "")","startingTime":"\(startingTime)","startingDte":"\(startingDate ?? "")","matchID":"\(match_id ?? "")","ht_score":"\(ft_score ?? "")","compatitonName":"\(compatitonName ?? "")","HomeTemaLogo":"\(HomeTemaLogo ?? "")","stadiumName":"\(stadiumName ?? "")"] as NSDictionary
                                            
                                            self.fixture1.add(newAdd)
                                            self.PastMatchesCountArray.add(newAdd)
                                            self.fixture.append(obj)
                                            drawCount += 1
                                        }
                                        
                                    }
                                    else {
                                        print("No future matches available for selecetd team ID")
                                        self.activityIndicator.stopAnimating()
                                    }
                                }
                                
                                
                                //loss matches for Premiership
                                
                                if let winmatches = (arr.value(forKey: "matchResults") as! NSDictionary).value(forKey: "loss")as?  [AnyObject]{
                                    if winmatches.count != 0 {
                                        //self.fixture.removeAll()
                                        var lossCount = 0
                                        for future in winmatches {
                                            let league =   future["competition_name"] as! String
                                            let leaugechar =  league.substring(to:league.index(league.startIndex, offsetBy: 4))
                                            self.leagueName1 = [league]
                                            self.leagueName .append(league)
                                            self.headerName.append(league as! String)
                                            
                                            let match_id = future["match_id"] as? String
                                            
                                            UserDefaults.standard.set(match_id, forKey: "match_id")
                                            UserDefaults.standard.synchronize()
                                            let startingDate = future.value(forKey: "starting_date")
                                            let startingTime = future.value(forKey: "starting_time") as! String
                                            var a_name = "" as String
                                            if (future["AwayTeam"] as? String) != nil {
                                                a_name = future.value(forKey: "AwayTeam") as! String                                }
                                            
                                            var h_name = "" as String
                                            if (future["HomeTeam"] as? String) != nil {
                                                h_name = future.value(forKey: "HomeTeam") as! String                                }
                                            let ht_score = future.value(forKey: "ht_score")
                                            let ft_score = future.value(forKey: "ft_score")
                                            let hometeamID = future["home_team_id"] as? String
                                            let AwayTeamId = future["away_team_id"] as? String
                                            print(future)
                                            let compatitonName = future.value(forKey: "competition_name")
                                            let obj = fixtureCellDataClass1(away_team_name: a_name, homwe_team_name: h_name, startingTime: startingTime , startingDte: startingDate! as! String, matchID: match_id!, ht_score: ht_score! as! String, compatitonName: compatitonName! as! String,ft_score: ft_score! as! String)
                                            
                                            let AwayTeamLogo = future["AwayTeamLogo"] as? String
                                            
                                            let HomeTemaLogo = future["HomeTemaLogo"] as? String
                                            let stadiumName = future["venue_id"] as? String
                                            let newAdd = ["away_team_name":"\(a_name ?? "")","AwayTeamId":"\(AwayTeamId ?? "")","AwayTeamLogo":"\(AwayTeamLogo ?? "")","homwe_team_name":"\(h_name ?? "")","hometeamID":"\(hometeamID ?? "")","startingTime":"\(startingTime)","startingDte":"\(startingDate ?? "")","matchID":"\(match_id ?? "")","ht_score":"\(ft_score ?? "")","compatitonName":"\(compatitonName ?? "")","HomeTemaLogo":"\(HomeTemaLogo ?? "")","stadiumName":"\(stadiumName ?? "")"] as NSDictionary
                                            
                                            self.fixture1.add(newAdd)
                                            self.PastMatchesCountArray.add(newAdd)
                                            self.fixture.append(obj)
                                            lossCount += 1
                                        }
                                        print(self.PastMatchesCountArray)
                                        self.selectedIndex = self.PastMatchesCountArray.count - 1
                                        
                                    }
                                    else {
                                        print("No future matches available for selecetd team ID")
                                        self.activityIndicator.stopAnimating()
                                    }
                                }
                            }
                            
                            if self.searchStr == "true"{
                                let filter = self.stirngfilter
                                if filter == "All"{
                                    
                                }
                                else{
                                    let searchPredicate = NSPredicate(format: "compatitonName = %@",filter as CVarArg)
                                    let filtered = (self.PastMatchesCountArray ).filtered(using: searchPredicate ) as NSArray
                                    self.PastMatchesCountArray.removeAllObjects()
                                    print(self.PastMatchesCountArray.count)
                                    self.PastMatchesCountArray = filtered.mutableCopy() as! NSMutableArray
                                    print(self.PastMatchesCountArray.count)
                                    print(self.fixture1.count)
                                    
                                }
                            }
                            //Upcoming matches
                            if let futureMatches = arr["upcomingMatch"] as? [AnyObject] {
                                if futureMatches.count != 0 {
                                    print(self.fixture1)
                                    for future in futureMatches {
                                        
                                        let match_id = future["match_id"] as? String
                                        let match_status = future["status"] as? String
                                        let date = NSDate()
                                        // "Jul 23, 2014, 11:01 AM" <-- looks local without seconds. But:
                                        var formatter = DateFormatter()
                                        formatter.dateFormat = "HH:mm:ss "
                                        let defaultTimeZoneStr = formatter.string(from: date as Date as Date)
                                        // "2014-07-23 11:01:35 -0700" <-- same date, local, but with seconds
                                        formatter.timeZone = NSTimeZone(abbreviation: "UTC") as! TimeZone
                                        let utcTimeZoneStr = formatter.string(from: date as Date)
                                        var formatter1 = DateFormatter()
                                        formatter1.dateFormat = "dd.MM.yyyy"
                                        formatter1.timeZone = NSTimeZone(abbreviation: "UTC") as! TimeZone
                                        var utCDate = formatter1.string(from: date as Date)
                                        
                                        let league = future["competition_name"] as! String
                                        self.leagueName1 = [league]
                                        self.leagueName .append(league)
                                        self.headerName.append(league )
                                        UserDefaults.standard.set(match_id, forKey: "match_id")
                                        UserDefaults.standard.synchronize()
                                        
                                        let startingDate = future["starting_date"] as? String
                                        let startingTime = future["starting_time"] as! String
                                        let a_name = future["AwayTeam"] as? String
                                        let h_name = future["HomeTeam"] as? String
                                        let ID = future["match_id"] as? String
                                        self.selectedMatchId = ID!
                                        
                                        let ft_score = future["ft_score"] as? String
                                        let ht_score = future["ht_score"] as? String
                                        let compatitonName = future.value(forKey: "competition_name")
                                        let hometeamID = future["home_team_id"] as? String
                                        let AwayTeamId = future["away_team_id"] as? String
                                        let AwayTeamLogo = future["AwayTeamLogo"] as? String
                                        let HomeTemaLogo = future["HomeTeamLogo"] as? String
                                        let stadiumName = future["venue_id"] as? String
                                        let obj = fixtureCellDataClass1(away_team_name: a_name!, homwe_team_name: h_name!, startingTime: startingTime , startingDte: startingDate! , matchID: match_id!, ht_score: ht_score! , compatitonName: compatitonName! as! String,ft_score: ft_score! )
                                        
                                        //                                        if ht_score == ""{
                                        
                                        let newAdd = ["away_team_name":"\(a_name ?? "")","AwayTeamId":"\(AwayTeamId ?? "")","AwayTeamLogo":"\(AwayTeamLogo ?? "")","homwe_team_name":"\(h_name ?? "")","hometeamID":"\(hometeamID ?? "")","startingTime":"\(startingTime)","startingDte":"\(startingDate ?? "")","matchID":"\(match_id ?? "")","ht_score":"\(ft_score ?? "")","compatitonName":"\(compatitonName ?? "")","HomeTemaLogo":"\(HomeTemaLogo ?? "")","stadiumName":"\(stadiumName ?? "")"] as NSDictionary
                                        let filter = self.stirngfilter
                                        self.fixture1.add(newAdd)
                                        self.futureMatchArray.add(newAdd)
                                        self.fixture.append(obj)
                                        //                                        }
                                    }
                                    //                                    let arr = self.fixture
                                    print(self.fixture1)
                                    
                                    let newArr = self.fixture1.sortedArray(using: [NSSortDescriptor(key: "starting_date", ascending: true)])
                                    let sortedArr = (newArr as NSArray)
                                    print(sortedArr)
                                    self.fixture1.removeAllObjects()
                                    self.fixture1 = sortedArr.mutableCopy() as! NSMutableArray
                                    
                                    if  self.leagueName1 == [self.stirngfilter]{
                                        self.myTableView.reloadData()
                                        self.activityIndicator.stopAnimating()
                                        //                                    }else if self.leagueName == self.stirngfilter{
                                        //                                        self.myTableView.reloadData()
                                        //                                        self.activityIndicator.stopAnimating()
                                    }
                                    else if self.stirngfilter == "All"{
                                        self.myTableView.reloadData()
                                        let indexes  = UserDefaults.standard.value(forKey: "gotoDetail") as? String
                                        if indexes == nil{
                                            self.gotoDetail = ""
                                        }else{
                                            self.gotoDetail = indexes!
                                        }
                                        if self.gotoDetail == "Yes"{
                                            // self.selectedIndex =  (UserDefaults.standard.value(forKey:"FixtureIndex") as? Int)!
                                            let indexPath = NSIndexPath(item: self.selectedIndex, section:0 )
                                            self.self.myTableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.top, animated: true)
                                        }else{
                                            if self.selectedIndex != nil{
                                                let indexPath = NSIndexPath(item: self.selectedIndex, section:0 )
                                                self.self.myTableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.top, animated: true)
                                            }
                                        }
                                        self.activityIndicator.stopAnimating()
                                        self.view.isUserInteractionEnabled = true
                                    }
                                    else
                                    {
                                        
                                    }
                                    
                                }
                                else {
                                    print("No future matches available for selecetd team ID")
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                            // self.headerName.append("All")
                            self.view.isUserInteractionEnabled = true
                            let arrForSort = self.fixture1 as NSArray
                            let newArr = arrForSort.sortedArray(using: [NSSortDescriptor(key: "startingDte", ascending: true)]) as  NSArray
                            print( newArr)
                            self.fixture1.removeAllObjects()
                            self.fixture1 = newArr.mutableCopy() as! NSMutableArray
                            print( self.fixture1)
                            
                            let categories =  self.headerName
                            print(categories)
                            
                            let unique = NSSet.init(array: categories as [Any])
                            print(unique)
                            self.headerName.removeAll()
                            let   FiltercategoriesUnique = unique.allObjects as NSArray
                            var sortedArray = FiltercategoriesUnique.sorted { ($0 as AnyObject).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
                            
                            self.headerName = sortedArray as! [String]
                            //  self.filterTableView .reloadData()
                            if   self.colValue == "0" {
                                self.collView .reloadData()
                                self.activityIndicator.stopAnimating()
                            }
                            if self.searchStr == "true"{
                                // self.fixture2.removeAllObjects()
                                self.fixture2 = self.fixture1
                                let filter = self.stirngfilter
                                if filter == "All"{
                                    self.fixture2 = self.fixture1 as! NSMutableArray
                                    self.myTableView.reloadData()
                                    self.activityIndicator.stopAnimating()
                                }else{
                                    let searchPredicate = NSPredicate(format: "compatitonName = %@",filter as CVarArg)
                                    let filtered = (self.fixture2).filtered(using: searchPredicate ) as NSArray
                                    self.fixture1.removeAllObjects()
                                    print(self.PastMatchesCountArray.count)
                                    self.fixture1 = filtered.mutableCopy() as! NSMutableArray
                                    print(self.fixture1.count)
                                    self.myTableView.reloadData()
                                    if self.selectedIndex != nil{
                                        if self.PastMatchesCountArray.count>0{
                                            self.selectedIndex = self.PastMatchesCountArray.count - 1
                                            
                                        }
                                        else{
                                            self.selectedIndex = self.PastMatchesCountArray.count - 1
                                        }
                                        let indexPath = NSIndexPath(item: self.selectedIndex, section:0 )
                                        self.self.myTableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.top, animated: true)
                                    }
                                    self.activityIndicator.stopAnimating()
                                    self.searchStr = "false"
                                    
                                }
                            }
                        }
                    }
                }
            }
            else if response.result.isFailure {
                //                print(response.result.error as Any)
                //                let alert = UIAlertController(title: "Server Error !", message: "No Record Found !!", preferredStyle: .alert)
                //                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                //
                //                }))
                //                self.present(alert, animated: true, completion: nil)
                
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func archivefutureFixture(futureFixture:[fixtureCellDataClass1]) -> NSData {
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: futureFixture as NSArray)
        return archivedObject as NSData
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            self.filterTableView.isHidden=true
        }
        super.touchesBegan(touches, with: event)
    }
}

extension fixtureeeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == filterTableView {
            return 1
        }else{
            //return fixture1.count
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == filterTableView {
            return self.headerName.count
        }else{
            return fixture1.count
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == filterTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if self.headerName.count > 0 {
                cell.textLabel?.text = ""
                cell.textLabel?.text = self.headerName[indexPath.row]
                cell.textLabel?.font = UIFont(name:"Avenir", size:14)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! customCell1
            if fixture1.count>0{
                cell.blinkLbl.isHidden = true
                let formattar = DateFormatter()
                let dic = fixture1[indexPath.row] as? NSDictionary
                let s : String = dic!.value(forKey: "startingDte") as! String
                formattar.dateFormat = "yyyy-MM-dd"
                formattar.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                matchDate =  formattar.date(from: s)!
                formattar.dateFormat = "yyyy-MM-dd"
                let matchDate1 =  formattar.string(from: matchDate)
                print(matchDate1)
                
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "EEE dd/M/yyyy "
                dateFormatter1.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                let timeStamp1 = dateFormatter1.string(from: matchDate)
                print(timeStamp1)
                //Time
                let StartinTime = dic?.value(forKey: "startingTime") as! String
                
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "HH:mm:ss"
                let timeStamp2 = dateFormatter2.date(from: StartinTime as! String)
                dateFormatter2.dateFormat = "HH:mm:ss"
                let timeStamp3 = dateFormatter2.string(from: timeStamp2!)
                print(timeStamp3)
                let DateTime =   NSString(format:"%@ %@", matchDate1,timeStamp3)
                print(DateTime)
                let formattar5 = DateFormatter()
                formattar5.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formattar5.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                let matDate1 =  formattar5.date(from: DateTime as String)! as NSDate
                print(matDate1)
                formattar5.dateFormat = "MMM-dd HH:mm"
                formattar5.timeZone = TimeZone.current
                let matDate =  formattar5.string(from: matDate1 as Date)
                print(matDate)
                let PastmatchDate = matDate.components(separatedBy: " ")
                let PastDate    = PastmatchDate[0]
                let PastTime = PastmatchDate[1]
                print(PastDate)
                let leauge = dic?.value(forKey: "compatitonName") as! String
                //  let first3LetterOfLeauge = leauge.substring(to:leauge.index(leauge.startIndex, offsetBy: 4))
                let stringInputArr = leauge.components(separatedBy: " ")
                var abbreviationName = ""
                for string in stringInputArr {
                    abbreviationName = abbreviationName + String(string.characters.first!)
                }
                
                print(abbreviationName)
                 //  IndexArray.removeAllObjects()
                if matchDate == currentDate {
                    if(matDate1 as Date > Date()){
                        //                        self.newData()
                    }
                    let score =  dic?.value(forKey: "ht_score") as! String
                    if score == "" {
                        cell.matchDateLbl.text = "\(matDate) "
                    }else{
                        cell.score.text = score
                        
                    }
                    
                }
                else if matchDate > currentDate {
                    
                    cell.ScoreView.layer.backgroundColor = UIColor(red:139/255.0, green:140/255.0, blue:141/255.0, alpha:1.0).cgColor
                    let score = dic?.value(forKey: "ht_score") as! String
                    if score == "" {
                        cell.laugeName.text = "\(abbreviationName)"
                        cell.matchDateLbl.text = "\(matDate)"
                        cell.score.text = ""
                        
                    }
                } else {
                    let formattar10 = DateFormatter()
                    formattar10.dateFormat = "yyyy-MM-dd HH:mm"
                    formattar10.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                    let curDate =  formattar10.string(from: currentDate)
                    print(curDate)
                    let fullDateArr = curDate.components(separatedBy: " ")
                    
                    let DateStr    = fullDateArr[0]
                    let surname = fullDateArr[1]
                    
                    if s == DateStr{
                        if(matDate1 as Date > Date()){
                            cell.score.text = ""
                        }
                        else{
                            let latestMatcharray = matchArray.copy() as! NSArray
                            let ID = Int(dic?.value(forKey: "matchID") as! String)
                            let searchPredicate = NSPredicate(format: "id == %d",ID!)
                            let filtered = (latestMatcharray) .filtered(using: searchPredicate ) as NSArray
                            print(filtered)
                            if(filtered.count > 0){
                                let filteredData =  filtered.object(at: 0) as! NSDictionary
                                let FinalScore = filteredData["scores"] as! NSDictionary
                                let ht_score = FinalScore["ht_score"] as? String
                                let visitScore = FinalScore["visitorteam_score"] as! Int
                                let LocalScore = FinalScore["localteam_score"] as! Int
                                let score = String(format: "%d-%d", LocalScore,visitScore)
                                cell.score.text = score
                            }                          }
                        green = "true"
                        cell.ScoreView.layer.backgroundColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0).cgColor
                        let score =  dic?.value(forKey: "ht_score") as! String
                        if score == "" {
                            
                            cell.matchDateLbl.text = "\(matDate) "
                               cell.laugeName.text = "\(abbreviationName)"
                            
                            cell.blinkLbl.isHidden = false
                           // cell.blinkLbl.backgroundColor = UIColor.red
                            IndexArray.removeAllObjects()
                            let obj = ["index" : indexPath.row] as NSDictionary
                            IndexArray.add(obj)
                            
                        }else{
                            cell.ScoreView.layer.backgroundColor = UIColor(red:113/255.0, green:128/255.0, blue:255/255.0, alpha:1.0).cgColor
                            cell.laugeName.text = "\(abbreviationName)"
                            cell.matchDateLbl.text = "\(PastDate)"
                        }
                    }else{
                        cell.ScoreView.layer.backgroundColor = UIColor(red:30/255.0, green:79/255.0, blue:239/255.0, alpha:1.0).cgColor
                        let score = dic?.value(forKey: "ht_score") as! String
                        if score == "" {
                            cell.laugeName.text = "\(abbreviationName)"
                            cell.matchDateLbl.text = "\(PastDate)"
                        }else{
                            cell.laugeName.text = "\(abbreviationName)"
                            cell.score.text = "\(score)"
                            cell.matchDateLbl.text = "\(PastDate)"
                        }
                    }
                }
                let homeTeam = dic?.value(forKey: "homwe_team_name")
                cell.team1Name.text = homeTeam as! String
                let awayteam = dic?.value(forKey: "away_team_name")
                cell.team2Name.text = awayteam as! String
                let hometeamLogo = dic?.value(forKey: "HomeTemaLogo") as! String
                cell.firstTeamLogo.loadImage(urlString: hometeamLogo as! String)
                let awayteamLogo = dic?.value(forKey: "AwayTeamLogo")
                cell.secondteamLogo.loadImage(urlString: awayteamLogo! as! String)
                cell.ScoreView.layer.cornerRadius = 10
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FixtureIndex = indexPath.row
        UserDefaults.standard.set(FixtureIndex, forKey: "FixtureIndex")
        gotoDetail = "Yes"
        UserDefaults.standard.set(gotoDetail, forKey: "gotoDetail")
        if tableView==filterTableView {
            let filterstr = self.headerName[indexPath.row]
            stirngfilter = filterstr
            searchStr = "true"
            self.filterTableView.isHidden = true
            getTeamDataFromAPI()
        }else{
            // let dic = fixture1[indexPath.section] as! NSDictionary
            let dic = fixture1[indexPath.row] as! NSDictionary
            let s : String = dic.value(forKey: "startingDte") as! String
            let formattar10 = DateFormatter()
            formattar10.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formattar10.timeZone = NSTimeZone(name: "UTC")! as TimeZone
            let curDate =  formattar10.string(from: currentDate)
            print(curDate)
            let fullDateArr = curDate.components(separatedBy: " ")
            
            let DateStr    = fullDateArr[0]
            let surname = fullDateArr[1]
            
            
            if s == DateStr {
                let dic = fixture1[indexPath.row] as! NSDictionary
                // let dic = fixture1[indexPath.row] as! NSDictionary
                selectedMatchId = dic.value(forKey: "matchID") as! String
                // selectedMatchId = "2020284"
                
                let  localTeamId = dic.value(forKey: "matchID") as! String
                
                let LiveViewController = self.storyboard?.instantiateViewController(withIdentifier: "LiveGame_detail") as? LiveViewController
                LiveViewController?.match_B = false
                LiveViewController?.comesFrom = "Fixture"
                
                LiveViewController?.match_id = selectedMatchId
                self.navigationController?.pushViewController(LiveViewController!, animated: true)
            }else{
                
                //               //  let dic = fixture1[indexPath.section] as! NSDictionary
                let dic = fixture1[indexPath.row] as! NSDictionary
                selectedMatchId = dic.value(forKey: "matchID") as! String
                let Stadiumname = dic.value(forKey: "stadiumName") as! String
                
                let GameDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "game_detail") as? GameDetailsViewController
                GameDetailsViewController?.match_id = selectedMatchId
                GameDetailsViewController?.stadiumNamestr = Stadiumname
                GameDetailsViewController?.teamDeatilDict = dic
                GameDetailsViewController?.comesFrom = "Fixture"
                self.navigationController?.pushViewController(GameDetailsViewController!, animated: true)
            }
        }
    }
}
extension fixtureeeViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.headerName.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // print (resultData)
        let cell = collectionView.cellForItem(at: indexPath) as! myCell1
        collIndex = indexPath.row
        UserDefaults.standard.set(collIndex, forKey: "collIndex")
        cell.selectedTabView.backgroundColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
        cell.myLabel?.textColor = UIColor.black
        let filterstr = self.headerName[indexPath.row]
        UserDefaults.standard.set(filterstr, forKey: "filterstr")
        stirngfilter = filterstr
        searchStr = "true"
        cell.selectedBackgroundView?.backgroundColor = UIColor.black
        getTeamDataFromAPI()
        collectionView.scrollToItem(at: NSIndexPath(row: indexPath.row, section: 0) as IndexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as? myCell1
        cell?.isSelected = false
        cell?.selectedTabView.backgroundColor = UIColor.clear
        cell?.myLabel?.textColor = UIColor.lightGray
        collView.deselectItem(at: indexPath, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? myCell1
        let str = self.headerName[indexPath.item] as? String
        
        colValue = "1"
        cell?.myLabel?.text = str?.uppercased()
        if indexPath.item == collIndex {
            collView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            cell?.selectedTabView.backgroundColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
            cell?.myLabel?.textColor = UIColor.black
        }
        else {
            let indexPath = IndexPath(row: collIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: false)
            cell?.selectedTabView.backgroundColor = UIColor.clear
            cell?.myLabel?.textColor = UIColor.lightGray
        }
        return cell!
    }
}
class myCell1 : UICollectionViewCell {
    
    @IBOutlet weak var selectedTabView: UIView!
    @IBOutlet weak var myLabel :UILabel?
}

class customCell1: UITableViewCell{
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var team2Name: UILabel!
    @IBOutlet weak var team1Name: UILabel!
    @IBOutlet weak var leagueName: UILabel!
    
    @IBOutlet weak var blinkLbl: UILabel!
    @IBOutlet weak var secondteamLogo: UIImageView!
    @IBOutlet weak var firstTeamLogo: UIImageView!
    @IBOutlet weak var DateLbel: UILabel!
    @IBOutlet weak var ScoreView: UIView!
    
    @IBOutlet weak var matchDateLbl: UILabel!
    
    @IBOutlet weak var laugeName: UILabel!
}

class fixtureCellDataClass1 : NSObject {
    
    var away_team_name: String = ""
    var homwe_team_name: String = ""
    var startingTime: String = ""
    var startingDte: String = ""
    var matchID: String = ""
    var ht_score: String = ""
    var compatitonName: String = ""
    var ft_score: String = ""
    
    init(away_team_name: String,homwe_team_name: String,startingTime: String,startingDte: String,matchID: String,ht_score: String,compatitonName: String,ft_score: String){
        self.away_team_name = away_team_name
        self.homwe_team_name = homwe_team_name
        self.startingTime = startingTime
        self.startingDte = startingDte
        self.matchID = matchID
        self.ht_score = ht_score
        self.compatitonName = compatitonName
        self.ft_score = ft_score
    }
}
