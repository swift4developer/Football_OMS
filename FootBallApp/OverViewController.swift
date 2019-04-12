
//
//  OverViewController.swift
//  FootBallApp
//
//  Created by Praveen Khare on 04/04/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class OverViewController: UIViewController{
    
    var team_id:String?
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var overView = [OverveiwDataClass]()
    var last_played = [LastPlayedMatches]()
    var customDict = Dictionary<String, Int>()
    var customDict1 = NSArray()
     var matchStatusArray = NSMutableArray()
    
    @IBOutlet var oddViewInside: UIView!
    @IBOutlet var imgAwayTeam: UIImageView!
    @IBOutlet weak var stasiumName: UILabel!
    
    @IBOutlet var imgHomeTeam: UIImageView!
    @IBOutlet var lblDrawDetail: UILabel!
    @IBOutlet weak var OddsAway: UILabel!
    @IBOutlet weak var oddsHome: UILabel!
    @IBOutlet weak var oddsView: UIView!
    var responseCode:Int = 0
    var wonCount:Int = 0
    var lossCount:Int = 0
    var drawCount:Int = 0
    var matchCount:Int = 0
    var leagueName:String  = ""
    var wonID = [String]()
    var lossID = [String]()
    var drawID = [String]()
    var headerName = [String]()
    var overAllWin  = NSMutableArray()
    var firstpAllWin  = NSDictionary()
    var superAllWin  = NSDictionary()
    var secondpAllWin  = NSDictionary()
    var RegularAllWin  = NSDictionary()
    var allmatches : Int = 0
    var NoLoss : Int = 0
    var NoWin : Int = 0
    var select_match = String()
    var futureMatchDate = String()
    
    
    @IBOutlet weak var Team2Time: UILabel!
    @IBOutlet var lblLeagueName: UILabel!
    @IBOutlet weak var team2DateTime: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var team2NameLabel: UILabel!
    @IBOutlet weak var team2ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        oddsView.layer.borderColor = UIColor.lightGray.cgColor
//        oddsView.layer.backgroundColor = UIColor.lightGray.cgColor
//
//        oddsView.backgroundColor = UIColor.lightGray
//        oddsView.backgroundColor?.setFill()
//
        self.hideKeyboardWhenTappedAround()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        activityIndicator.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/4)
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
//        self.oddsView.layer.borderWidth = 1
//        self.oddsView.layer.borderColor = (UIColor.black.cgColor)
        //        getTheLastFiveMatchData()
        
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        let fixtureeeViewController = self.storyboard?.instantiateViewController(withIdentifier: "fixtureeeViewController") as? fixtureeeViewController
        
        self.navigationController?.pushViewController(fixtureeeViewController!, animated: false)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "FixtureIndex")
        UserDefaults.standard.removeObject(forKey: "gotoDetail")
        UserDefaults.standard.removeObject(forKey: "filterstr")
        UserDefaults.standard.removeObject(forKey: "collIndex")
        let tap = UITapGestureRecognizer(target: self, action: #selector(OverViewController.tapOnNextMatchImage))
        team2ImageView.addGestureRecognizer(tap)
        team2ImageView.isUserInteractionEnabled = true
        
        self.hideKeyboardWhenTappedAround()
        DispatchQueue.main.async { [unowned self] in
            self.lblLeagueName.text = ""
            self.stasiumName.text = ""
            self.futureMatchDate = ""
            self.team2DateTime.text = ""
            self.team2NameLabel.text = ""
            self.team2ImageView.image = nil
        }
        drawID.removeAll()
        customDict.removeAll()
        headerName.removeAll()
        self.overAllWin.removeAllObjects()
        let gotoLive =  UserDefaults.standard.value(forKey:"yes")
        if (gotoLive != nil) {
            tapOnNextMatchImage()
            //            let LiveViewController = self.storyboard?.instantiateViewController(withIdentifier: "LiveGame_detail") as? LiveViewController
            //            self.navigationController?.pushViewController(LiveViewController!, animated: true)
            UserDefaults.standard.removeObject(forKey: "yes")
        }
        else {
            
            let pref = UserDefaults.standard
            if let t_id = pref.object(forKey: "TEAM_ID") {
                self.team_id = t_id as? String
                if team_id == "" {
                    self.rootVC()
                }
                else
                {
                    getTheLastFiveMatchData(id: team_id!)
                }
            }
            else {
                let alert = UIAlertController(title: "Log IN Error !!", message: "You are not logged in.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: {
                    self.rootVC()
                })
            }
        }
    }
    
    func tapOnNextMatchImage()
    {
        
        let LiveViewController = self.storyboard?.instantiateViewController(withIdentifier: "LiveGame_detail") as? LiveViewController
        LiveViewController?.match_id = select_match
        LiveViewController?.matchDate = futureMatchDate
    
        self.navigationController?.pushViewController(LiveViewController!, animated: true)
        
        print("Tapped on Image")
    }
    
    
    func rootVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    func getTheLastFiveMatchData(id:String) {
        self.activityIndicator.startAnimating()
        // let team_id:String = UserDefaults.standard.string(forKey: "TEAM_ID")!
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=getTeamDetailMetch&team_id=\(id)")!
        print(id)
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let resJson = response.result.value as? NSDictionary {
                    if (resJson["RESPONSECODE"] as? Int) != nil {
                    }
                    if let resArray = resJson.value(forKey: "RESPONSE") as? [AnyObject] {
                        for arr in resArray {
                            self.headerName.removeAll()
                            self.matchStatusArray.removeAllObjects()
                            if let overAllWinDraw = arr["windraw"] as? [AnyObject] {
                                if overAllWinDraw.count != 0 {
                                    for allwin in overAllWinDraw{
                                        let name = allwin.value(forKey: "name") as! String
                                        let win = allwin.value(forKey: "win") as! String
                                        self.NoWin  = Int(win)!
                                        let draw = allwin.value(forKey: "draw") as! String
                                        let Nodraw : Int = Int(draw)!
                                        let Loss = allwin.value(forKey: "loss") as! String
                                        self.NoLoss = Int(Loss)!
                                        self.allmatches = Int (self.NoWin + self.NoLoss )
                                        if name == ""{
                                            print(name)
                                        }else{
                                            self.headerName.append(name as! String)
                                        }
                                    }
                                    self.overAllWin.add(overAllWinDraw)
                                    //  self.overAllWin = overAllWinDraw as! NSMutableArray
                                    self.myTableView.reloadData()
                                }
                                else {
                                    print("No data for selected team ID")
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                            if let pastMachtes = arr["pastresult"] as? NSArray  {
                                
                                if pastMachtes.count != 0 {
//                                    for pastFiveMatc in pastMachtes.reversed() {
//
//                                       self.matchStatusArray.add(pastFiveMatc)
//                                        print(pastFiveMatc)
//                                    }
                                    self.matchStatusArray = pastMachtes.mutableCopy() as! NSMutableArray
                                    print(self.matchStatusArray)
                                    self.customDict1 = pastMachtes
                                    //                                    for (key, value) in pastMachtes {
                                    //                                        self.customDict.updateValue(value as! Int, forKey: key as! String)
                                    //
                                    //                                    }
                                    
                                    self.myCollectionView.reloadData()
                                    self.activityIndicator.stopAnimating()
                                }
                                else {
                                    print("No data for selected team ID")
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                            if let matchResult = arr["matchResults"] as? [String: AnyObject] {
                                //  self.headerName = ((arr.value(forKey: "matchResults") as! NSDictionary).value(forKey: "draw") as! NSDictionary).allKeys as! [String]
                                if matchResult.count != 0 {
                                    if let drawResult = (arr.value(forKey: "matchResults") as! NSDictionary).value(forKey: "draw")as? [AnyObject] {
                                        // if let res = drawResult["Superliga"] as! [AnyObject]? {
                                        self.drawID.removeAll()
                                        for draw in drawResult {
                                            let matchId = draw["match_id"]
                                            self.drawID.append(matchId as! String)
                                            // self.drawCount = self.drawCount + 1
                                            print(self.drawID)
                                            //}
                                        }
                                    }
                                    if let loseResult = (arr.value(forKey: "matchResults") as! NSDictionary).value(forKey: "loss")as? [AnyObject]  {
                                        // if let res = loseResult["Superliga"] as! [AnyObject]? {
                                        self.lossID.removeAll()
                                        for lose in loseResult {
                                            let matchIdloss = lose["match_id"]
                                            self.lossID.append(matchIdloss as! String)
                                            //  self.lossCount = self.lossCount + 1
                                            print(self.lossID)
                                            // }
                                        }
                                    }
                                    if let wonResult = (arr.value(forKey: "matchResults") as! NSDictionary).value(forKey: "win")as? [AnyObject]   {
                                        // if let res = wonResult["Premiership"] as? [AnyObject] {
                                        self.wonID.removeAll()
                                        for won in wonResult {
                                            let matchIdWon = won["match_id"]
                                            self.wonID.append(matchIdWon as! String)
                                            //   self.wonCount = self.wonCount + 1
                                            print(self.wonID)
                                            // }
                                        }
                                    }
                                }
                                else {
                                    print("No data for selected team ID")
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                            print(self.lossID.count)
                             print(self.wonID.count)
                             print(self.drawID.count)
                            self.drawCount = self.drawID.count
                            self.lossCount = self.lossID.count
                            self.wonCount = self.wonID.count
                            let allWon = Float (self.wonID.count)
                            let WinLossCount = self.lossCount + self.wonCount
                            let AllMatcesCount = self.drawCount + self.lossCount + self.wonCount
                            let winNdAllMatchesCount = Float (self.wonCount + AllMatcesCount)
                             print(winNdAllMatchesCount)
                             print(AllMatcesCount)
                            let ChancesOfWin = Float (allWon / winNdAllMatchesCount)
                               print(ChancesOfWin)
                            let odds = NSLocalizedString("Odds", comment: "")
                            
                            let TotalOdds = String(format: "%@ %.2f",odds, ChancesOfWin)
                            if let futureMatches = arr["upcomingMatch"] as? [AnyObject] {
                                if futureMatches.count != 0 {
                                    self.overView.removeAll()
                                    var counter = 0
                                    for future in futureMatches {
                                        if counter == 1 {
                                            break
                                        }
                                        let away_team_name = future["AwayTeam"] as? String
                                        let away_team_logo = future["AwayTeamLogo"] as? String
                                        let Home_team_name = future["HomeTeam"] as? String
                                        let Home_team_logo = future["HomeTeamLogo"] as? String
                                        
                                        let away_team_id = future["away_team_id"] as? String
                                        let Home_team_id = future["home_team_id"] as? String
                                        let match_id = future["match_id"] as? String
                                        let homeTeamOdds = future["oddsHome"] as? String
                                        let AwayTeamOdds = future["oddsAway"] as? String
                                        let oddDrawDetails = future["drawDetail"] as? String
                                        self.select_match = match_id!
                                        let home_team_name = future["HomeTeam"] as? String
                                        self.lblLeagueName.text = future["competition_name"] as? String
                                        let stadiumName = future["venue_id"] as? String
                                        if stadiumName != "" {
                                            let StName  = String(format: "%@", stadiumName!)
                                            UserDefaults.standard.set(stadiumName, forKey: "stadiumName")
                                            self.stasiumName.text = StName
                                        }
                                
                                        let date = future["starting_date"] as? String
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                                        let timeStamp =  dateFormatter.date(from: date!)
                                        print(timeStamp)
                                        let dateFormatter1 = DateFormatter()
                                        dateFormatter1.dateFormat = "yyyy-MM-dd, "
                                        //  dateFormatter1.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                                        // dateFormatter1.timeZone = TimeZone.current
                                        let timeStamp1 = dateFormatter1.string(from: timeStamp!)
                                        print(timeStamp1)
                                        let TIme = future["starting_time"] as? String
                                        let dateFormatter2 = DateFormatter()
                                        dateFormatter2.dateFormat = "HH:mm:ss"
                                        //  dateFormatter2.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                                        // dateFormatter2.timeZone = TimeZone.current
                                        let timeStamp2 = dateFormatter2.date(from: TIme!)
                                        print(timeStamp2)
                                        let dateFormatter3 = DateFormatter()
                                        dateFormatter3.dateFormat = "HH:mm"
                                        // dateFormatter3.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                                        //  dateFormatter3.timeZone = TimeZone.current
                                        let timeStamp3 = dateFormatter2.string(from: timeStamp2!)
                                        print(timeStamp3)
                                        let finalDate = timeStamp1 +  timeStamp3
                                        print(finalDate)
                                        let formattar50 = DateFormatter()
                                        formattar50.dateFormat = "yyyy-MM-dd, HH:mm:ss"
                                        formattar50.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                                        let matDate =  formattar50.date(from: finalDate as String)! as NSDate
                                        print(matDate)
                                        let str = String(format:"%@",matDate )
                                        formattar50.dateFormat = "EEEE, MMM d, HH:mm"
                                        formattar50.timeZone = TimeZone.current
                                        let matDate1 =  formattar50.string(from: matDate as Date)
                                        print(matDate1)
                                        self.futureMatchDate = finalDate
                                        self.team2DateTime.text = matDate1
                                        // let week = String(format: "Week %@", (future["weekno"] as? NSNumber)!)
                                        // self.team2DateTime.text = week
                                        if id == Home_team_id{
                                            self.team2ImageView.loadImage(urlString: away_team_logo!)
                                            let awayteamname = away_team_name!
                                            self.team2NameLabel.text = awayteamname
                                            self.oddsHome.text = homeTeamOdds
                                            self.OddsAway.text = AwayTeamOdds
                                            self.lblDrawDetail.text = oddDrawDetails
                                            self.imgAwayTeam.loadImage(urlString: away_team_logo!)
                                            self.imgHomeTeam.loadImage(urlString: Home_team_logo!)
                                            
                                            UserDefaults.standard.set(awayteamname, forKey: "teamname")
                                            
                                            UserDefaults.standard.set(away_team_logo, forKey: "flag")
                                            
                                        }else{
                                            self.team2ImageView.loadImage(urlString: Home_team_logo!)
                                            self.imgAwayTeam.loadImage(urlString: away_team_logo!)
                                            self.imgHomeTeam.loadImage(urlString: Home_team_logo!)
                                            let awayteamname = home_team_name!
                                            self.team2NameLabel.text = awayteamname
                                            UserDefaults.standard.set(awayteamname, forKey: "teamname")
                                            UserDefaults.standard.set(Home_team_logo, forKey: "flag")
                                            self.oddsHome.text = AwayTeamOdds
                                            self.OddsAway.text = homeTeamOdds
                                            self.lblDrawDetail.text = oddDrawDetails
                                        }
                                        let awayteamname = away_team_name!
                                        if awayteamname == nil{
                                            self.team2NameLabel.text = ""
                                        }else{
                                            //self.team2NameLabel.text = awayteamname
                                        }
                                        
                                        //  self.team2ImageView.loadImage(urlString: away_team_logo!)
                                        
                                        let over = OverveiwDataClass(away_team_name: away_team_name!, home_team_name: home_team_name!, away_team_id: away_team_id!, away_team_logo: away_team_logo!, match_id: match_id!)
                                        self.overView.append(over)
                                        counter += 1
                                    }
                                    //self.myTableView.reloadData()
                                    self.activityIndicator.stopAnimating()
                                }
                                else {
                                    print("No data for selected team ID")
                                    
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                            
                        }
                    }
                }
                
                self.activityIndicator.stopAnimating()
            }
            else if response.result.isFailure {
                print(response.error as Any)
//                let alert = UIAlertController(title: "Server Error !", message: "No Record Found !!", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
//
//                }))
//                self.present(alert, animated: true, completion: nil)
                
                self.activityIndicator.stopAnimating()
                
            }
        }
    }
    func checkResponse(match_id:String) {
        activityIndicator.startAnimating()
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=getEvent&match_id=\(match_id)")!
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let resJson = response.result.value as? [String: AnyObject]{
                    if let responsCode = resJson["RESPONSECODE"] as? Int {
                        self.responseCode = responsCode
                        print("CODE>> \(self.responseCode)")
                        if self.responseCode == 0 {
                            print("JSON>>>>\(resJson)")
                        }
                    }
                    if let res = resJson["RESPONSE"] as? [AnyObject] {
                        
                        print(res)
                        //                        for resData in res {
                        //                           let teamName = resData["team_name"] as? String
                        //                            let teamLogo = resData["team_logo"] as? String
                        //                            let min = resData["minute_val"] as? String
                        //                            let typrValue = resData["type_val"] as? String
                        //                            let teamID = resData["team_id"] as? String
                        //                              let newObj = teamData(teamName: teamName!, teamLogo: teamLogo!, typeValue: typrValue!, minute: min!, teamID: teamID!)
                        //                              self.team_data.append(newObj)
                        //                        }
                    }
                }
                self.activityIndicator.stopAnimating()
            }
            else if response.result.isFailure {
                print( "SOME ERROR IS JSON DATA")
            }
        }
        
    }
}

extension OverViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerName.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! tableCell
        if self.overAllWin.count > 0 {
            
        let overAllWinList = self.overAllWin.object(at: 0) as! NSArray
        let allWin = overAllWinList[indexPath.section] as? NSDictionary
        let draw = allWin?.value(forKey: "draw") as! String
        //cell.drawMatches.text = "\(self.drawID.count) Draw"
              let drawLocaliseStr = NSLocalizedString("Draw", comment: "")
        cell.drawMatches.text = "\(draw) \(drawLocaliseStr)"
          
        
        let losse = allWin?.value(forKey: "loss") as! String
               let LossLocaliseStr = NSLocalizedString("Loss", comment: "")
        cell.loseMatches.text = "\(losse) \(LossLocaliseStr)"
      
        let win = allWin?
            
            .value(forKey: "win") as! String
         let WinLocaliseStr = NSLocalizedString("Win", comment: "")
        cell.wonMatches.text = "\(win) \(WinLocaliseStr)"
        
        
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if headerName.count > 0 {
             return headerName[section]
        }else {
            return nil
        }
    }
}

extension OverViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
     
        return matchStatusArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! customCollectionViewCell
        let pastMatchecsdict = self.matchStatusArray [indexPath.section] as? NSDictionary
        let firstValue = pastMatchecsdict?.value(forKey: "matchstatus") as? Int

        if firstValue == 0 {
            
            cell.imageForResult.image = UIImage(named: "lose")
        }else if firstValue == 2 {
            cell.imageForResult.image = UIImage(named: "drawGray")
            
        }
        else {
            cell.imageForResult.image = UIImage(named: "won")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let matchdict = self.matchStatusArray[indexPath.section] as! NSDictionary
        let select_match : String = matchdict.value(forKey: "matchid") as! String
        let cell = collectionView.cellForItem(at: indexPath) as! customCollectionViewCell

        if select_match != " " {
          
            let detail:GameDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "game_detail") as! GameDetailsViewController
            detail.match_id = select_match
            self.navigationController?.pushViewController(detail, animated: true)
        }
        else {
            let alert = UIAlertController(title: "Something went wrong !!", message: "No Record Found !!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                let firstValue = Array(self.customDict.values)[indexPath.section]
                if firstValue == 0 {
                    cell.imageForResult.image = UIImage(named: "lossGray")
                } else {
                    cell.imageForResult.image = UIImage(named: "wonGray")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}


class tableCell: UITableViewCell {
    @IBOutlet weak var opponentName4: UILabel!
    @IBOutlet weak var opponentName3: UILabel!
    @IBOutlet weak var opponentName2: UILabel!
    @IBOutlet weak var opponentName1: UILabel!
    @IBOutlet weak var loseMatches: UILabel!
    @IBOutlet weak var drawMatches: UILabel!
    @IBOutlet weak var wonMatches: UILabel!
    @IBOutlet weak var totalMatchPlayed: UILabel!
    @IBOutlet weak var pointsStackView: UIStackView!
}

class customCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var imageForResult: UIImageView!
}

class OverveiwDataClass {
    
    var away_team_name: String = ""
    var home_team_name: String = ""
    var away_team_id: String = ""
    var away_team_logo: String = ""
    var match_id: String = ""
    
    init(away_team_name: String,home_team_name: String,away_team_id: String,away_team_logo: String,match_id:String) {
        self.away_team_name = away_team_name
        self.home_team_name = home_team_name
        self.away_team_id = away_team_id
        self.away_team_logo = away_team_logo
        self.match_id = match_id
        
    }
}

class LastPlayedMatches {
    var result: String = ""
    var matchID: String = ""
    
    init(result:String, matchID:String) {
        self.matchID = matchID
        self.result = result
    }
}

