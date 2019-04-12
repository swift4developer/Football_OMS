



//
//  TeamTableViewController.swift
//  FootBallApp
//
//  Created by Praveen Khare on 12/04/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class TeamTableViewController: UIViewController {
    
    
    @IBOutlet var table_view: UITableView!
    @IBOutlet var collView: UICollectionView!
    var team_table_data = [teamTableData]()
    var name_logo = [NameAndLogo]()
    var count = [CountWnLossDraw]()
    var wonCount:Int = 0
    var lossCount:Int = 0
    var drawCount:Int = 0
    var wonID = [String]()
    var lossID = [String]()
     var headerName = [String]()
    var drawID = [String]()
    var colValue = "0"

    var indexstr : Int = 1
      var serialNo : Int = 0
    var serialNoArray = NSMutableArray ()
    
    @IBOutlet weak var selectedTeamImage: UIImageView!
    
    @IBOutlet weak var selectedTeamName: UILabel!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var getTheCount = [String]()
    // var keysarray : [String] = ["Superliga","Premiership"]
    var keysarray  = NSMutableArray()
     var keysarray2  = NSMutableArray()
    var resultData = NSDictionary()
    var DictData = NSDictionary()
    var resultData1 = NSArray()
    var resultDat = NSArray()
    var arr = NSArray()
    var mutablearr : NSMutableArray = NSMutableArray()
   
    @IBAction func settingBarBtn(_ sender: UIBarButtonItem) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "setting") as! SettingViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = UserDefaults.standard.object(forKey: "name")
        self.selectedTeamName.text = data as? String
        let mylogo = UserDefaults.standard.object(forKey: "logo")
        self.selectedTeamImage.loadImage(urlString: mylogo as! String)
        activityIndicator.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        //downloadDataFormApi()
    }
    func returnCount(dictionary:NSDictionary, draw:String,league:String) -> Int {
        let Stringmr = dictionary.value(forKey: "matchResults") as? String
        if Stringmr == "" {
            return 0
        }
        else{
            let s = ((dictionary.value(forKey: "matchResults") as! NSDictionary).value(forKey: draw) as? NSDictionary )
            if s != nil && s?.count != 0
            {
                return (((dictionary.value(forKey: "matchResults") as! NSDictionary).value(forKey: draw) as! NSDictionary).value(forKey: league) as! NSArray).count
                
            }
            else{
                return 0
                
            }
            
        }
      
    }
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "FixtureIndex")
        UserDefaults.standard.removeObject(forKey: "gotoDetail")
        UserDefaults.standard.removeObject(forKey: "filterstr")
        UserDefaults.standard.removeObject(forKey: "collIndex")
        let tittlename = NSLocalizedString("Team Table", comment: "")
             self.navigationItem.title = tittlename
         colValue = "0"
        serialNo = 1
        getTeamDataFromAPI()
          downloadDataFormApi()
    }
   
    func getTeamDataFromAPI() {
           self.view.isUserInteractionEnabled = false
           let team_id:String = UserDefaults.standard.string(forKey: "TEAM_ID")!
        // self.team_id = UserDefaults.standard.string(forKey: "TEAM_ID")!
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=getTeamDetailMetch&team_id=\(team_id)")!
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
    func downloadDataFormApi() {
        self.view.isUserInteractionEnabled = false

        let team_id:String = UserDefaults.standard.string(forKey: "TEAM_ID")!
        self.activityIndicator.startAnimating()
        //        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=getTeamTable")!
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=getStanding&team_id=\(team_id)")!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let resJson = response.result.value as? NSDictionary {
                    if (resJson["RESPONSECODE"] as? Int) != nil {
                        //  print("RESPONSE CODE>> \(responceCode )")
                    }
                    
                    // if let resArray = resJson.value(forKey: "RESPONSE") as? NSArray
                    if(resJson["RESPONSECODE"] as? Int) == 1{
                        self.headerName.removeAll()
                        self.serialNoArray.removeAllObjects()
                        let resArray = resJson.value(forKey: "RESPONSE") as! NSDictionary
                        for v in resArray{
                            let namearr = v.value as! NSDictionary
                            let name = namearr.value(forKey: "name") as? String
                            
                            self.keysarray.add(name as Any)
                            self.headerName.append(name!
                            )
                            //                          let NameArr = name?.characters.split{$0 == ":"}.map(String.init)
                            //                            let finalName = NameArr?[0]
                            //  self.keysarray.removeAllObjects()
                            // self.keysarray.add(finalName)
                            
                        }
                     
                        let indexNo =  String(format: "%d",self.indexstr)
                        let standarr = resArray.value(forKey: indexNo as String) as! NSDictionary
                        let standdetail = standarr.value(forKey: "standing_detail") as! NSArray
                      
                        self.arr = standdetail 
                                          
                        let newArr = self.arr.sortedArray(using: [NSSortDescriptor(key: "points", ascending: false)])
                       // self.arr.removeAllObjects()
                        self.arr = (newArr as NSArray)
                        
                        self.resultDat = self.arr.object(at: 0) as! NSArray
                        var serialCount : Int = 0
                        
                        for i in self.resultDat {
                            serialCount += 1
                            let serialNo = ["SerialNo" : serialCount ]
                            self.serialNoArray.add(serialNo)
                            
                        }
                        if self.colValue == "0"{
                        self.collView.reloadData()
                        }
                        self.table_view.reloadData()
                        self.activityIndicator.stopAnimating()
                          self.view.isUserInteractionEnabled = true
                         }
                }
                     self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true

            }
            else if response.result.isFailure {
                print(response.result.error as Any)
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
}

extension TeamTableViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerName.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // print (resultData)
        let cell = collectionView.cellForItem(at: indexPath) as! myCell
        
        cell.selectedTabView.backgroundColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
        cell.myLabel?.textColor = UIColor.black
        indexstr = indexPath.item + 1
      
        downloadDataFormApi()
        collectionView.scrollToItem(at: NSIndexPath(row: indexPath.row, section: 0) as IndexPath, at: .centeredHorizontally, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as? myCell
        cell?.isSelected = false
        cell?.selectedTabView.backgroundColor = UIColor.clear
        cell?.myLabel?.textColor = UIColor.lightGray
        collView?.deselectItem(at: indexPath, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? myCell
        let str = headerName[indexPath.item] as? String
        colValue = "1"
        cell?.myLabel?.text = str?.uppercased()
        if indexPath.item == 0 {
            collView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            cell?.selectedTabView.backgroundColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
            cell?.myLabel?.textColor = UIColor.black
        }
        else {
            cell?.selectedTabView.backgroundColor = UIColor.clear
            cell?.myLabel?.textColor = UIColor.lightGray
        }
        return cell!
    }
}

extension TeamTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultDat.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! cellForTeamTableView1
    
        let dict = resultDat[indexPath.row] as! NSDictionary
        let teamSerialNO = serialNoArray [indexPath .row] as! NSDictionary
        let teamSerialNumber = teamSerialNO.value(forKey: "SerialNo") as! Int
        cell.serialNoLbl.text = "\(teamSerialNumber)"
        cell.teamFlags.loadImage(urlString: dict.value(forKey: "logo") as! String)
        let name = dict.value(forKey: "name") as? String
        cell.nameLabel.text = name
        let win = dict.value(forKey: "overall_win") as? String
        cell.wonMatches.text = win
        let draw = dict.value(forKey: "overall_draw") as? String
        cell.drawMatch.text = draw
        let loss = dict.value(forKey: "overall_loose") as? String
        cell.loseMAtch.text = loss
        //        let homewin = dict.value(forKey: "home_win") as? String
        //        cell.homeWin.text = homewin
        //        let homeDraw = dict.value(forKey: "home_draw") as? String
        //        cell.homeDraw.text = homeDraw
        //        let homeloss = dict.value(forKey: "home_loose") as? String
        //        cell.homeLoss.text = homeloss
        let homePlayed = dict.value(forKey: "home_played") as? String
        cell.homePlayed.text = homePlayed
        //        let awayWin = dict.value(forKey: "away_win") as? String
        //        cell.awayWin.text = awayWin
        //        let awayLoss = dict.value(forKey: "away_loose") as? String
        //        cell.AwayLoss.text = awayLoss
        //        let awayDraw = dict.value(forKey: "away_draw") as? String
        //        cell.AwayDraw.text = awayDraw
        let awayPlayed = dict.value(forKey: "goal_difference") as? String
        cell.awayPlayed.text = awayPlayed
        let points = dict.value(forKey: "points") as? String
        cell.points.text = points
        
        
        
        
        
        
        //        let a:Int = Int("\(dict.value(forKey: "win") ?? 0)")!
        //         let b:Int = Int("\(dict.value(forKey: "draw") ?? 0)")!
        //         let c:Int = Int("\(dict.value(forKey: "loss") ?? 0)")!
        //
        //        let MP = String(format: "%d", a+b+c)
        //        print(MP)
       
        let MP = dict.value(forKey: "overall_played") as? String
        cell.matchPlayed.text = MP
       
   
        return cell
    }
}

class cellForTeamTableView1: UITableViewCell {
    
    @IBOutlet weak var loseMAtch: UILabel!
    @IBOutlet weak var drawMatch: UILabel!
    @IBOutlet weak var wonMatches: UILabel!
    @IBOutlet weak var matchPlayed: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teamFlags: UIImageView!
    @IBOutlet weak var HomeScore: UILabel!
    @IBOutlet weak var homeWin: UILabel!
    @IBOutlet weak var homeDraw: UILabel!
    @IBOutlet weak var homeLoss: UILabel!
    @IBOutlet weak var homePlayed: UILabel!
    @IBOutlet weak var awayWin: UILabel!
    @IBOutlet weak var AwayDraw: UILabel!
    @IBOutlet weak var AwayLoss: UILabel!
    @IBOutlet weak var awayPlayed: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var serialNoLbl: UILabel!
    
}

class myCell : UICollectionViewCell {
    
    @IBOutlet weak var selectedTabView: UIView!
    @IBOutlet weak var myLabel :UILabel?
}

class teamTableData {
    
    var matchplayed:String = ""
    var loseMAtch:String = ""
    var wonMatches:String = ""
    var drawMatch:String = ""
    var teamFlags:String = ""
    var nameLabel:String = ""
    
    init(matchplayed:String, loseMAtch:String, wonMatches:String,drawMatch:String ,teamFlags:String,nameLabel:String) {
        self.matchplayed = matchplayed
        self.loseMAtch = loseMAtch
        self.wonMatches = wonMatches
        self.drawMatch = drawMatch
        self.teamFlags = teamFlags
        self.nameLabel = nameLabel
        
    }
}

class NameAndLogo {
    var teamFlags:String = ""
    var nameLabel:String = ""
    
    init(teamFlags:String,nameLabel:String) {
        self.teamFlags = teamFlags
        self.nameLabel = nameLabel
    }
}

class CountWnLossDraw {
    var win:Int = 0
    var loss:Int = 0
    var draw:Int = 0
    init(win:Int, loss:Int, draw:Int) {
        self.draw = draw
        self.win = win
        self.loss = loss
        
    }
}

