//
//  LiveViewController.swift
//  FootBallApp
//
//  Created by AS182 on 9/1/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class LiveViewController: UIViewController {
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var flag2ImageView: UIImageView!
    @IBOutlet weak var flag1ImageView: UIImageView!
    
    @IBOutlet weak var stadiumname: UILabel!
    @IBOutlet weak var LiveTime: UILabel!
    @IBOutlet weak var ownTeamScore: UILabel!
    @IBOutlet weak var againstTeamScore: UILabel!
   var halfScore = true
    @IBOutlet var halfTimeScore: UILabel!
    @IBOutlet weak var scorelivelabel: UILabel!
    @IBOutlet weak var matchNotStart: UILabel!
    @IBOutlet weak var againstTeamscore: UILabel!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var fixture1  = NSMutableArray()
    var match_id: String = ""
    var match_B = Bool()
    var selectedeteamId: String = ""
    var team_data = [teamData1]()
    var name = String()
    var image1URL = String()
    var image2URL = String()
    var goal = NSMutableArray()
    var goalhome = NSMutableArray()
    var finalScore = String()
    var  selectedTeamName = String()
    var visitorTeamId = Int()
    var haif_Time_Score = String()
    
    var HomeTeam = String()
    var AwayTeam = String()
    var teamid = String()
    var matchDate = String()
    var localTeamId = Int()
    var comesFrom = ""
    
    @IBAction func filterBtn(_ sender: Any) {
    }
    @IBAction func serchBtn(_ sender: Any) {
    }
    @IBAction func settingBtn(_ sender: UIBarButtonItem) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "setting") as? SettingViewController
        self.navigationController?.pushViewController(settingVC!, animated: true)
    }
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        //        let myTeamVC:TabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "tab_bar") as! TabBarViewController
        //        self.present(myTeamVC, animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        let data = UserDefaults.standard.object(forKey: "TEAM_ID")
        self.selectedeteamId = (data as? String)!
        self.LiveTime.isHidden = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("disappear")
        if comesFrom == "Fixture" {
            let fixtureeeViewController = self.storyboard?.instantiateViewController(withIdentifier: "fixtureeeViewController") as? fixtureeeViewController
            self.navigationController?.popViewController(animated: false)
        }else{
            let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "home") as? HomeViewController
            
            self.navigationController?.popViewController(animated: false)
        }
        
        
    }

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let tittlename = NSLocalizedString("Live Match", comment: "")
        self.navigationItem.title = tittlename
     
        self.matchNotStart.isHidden = true
        activityIndicator.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        //        let data = UserDefaults.standard.object(forKey: "name")
        //           selectedTeamName = (data as? String)!
        apicall()
        
        
    }
    
    func apicall() {
        downloadData()
        var timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.updateLiveScoreData), userInfo: nil, repeats: true )
        
        
    }
    func  updateLiveScoreData(){
        self.team_data.removeAll()
        self.fixture1.removeAllObjects()
     self.halfScore = true
        downloadData()
    }
    
    func downloadData() {
        activityIndicator.startAnimating()
       let url : URLConvertible = URL(string: "https://soccer.sportmonks.com/api/v2.0/livescores?api_token=qs0SFsIwHskD0pFRK2nDgAU66RIUJc9tTb6mPcHes9H0eOGX5HSKvfm44eIK&include=localTeam,visitorTeam,substitutions,goals,cards,league,season,events,venue")!
        print(url)
        
//       let url : URLConvertible = URL(string: "https://soccer.sportmonks.com/api/v2.0/fixtures/between/2017-11-18/2017-11-18?api_token=qs0SFsIwHskD0pFRK2nDgAU66RIUJc9tTb6mPcHes9H0eOGX5HSKvfm44eIK&page=1&include=localTeam,visitorTeam,substitutions,goals,league,season,events,venue")!
        
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let resJson = response.result.value as? [String: AnyObject]{
                    // self.team_data.removeAll()
                    self.fixture1.removeAllObjects()
                    print(resJson)
                    let data = resJson ["data"] as? [AnyObject]
                    // let data1 = data?[0] as? NSDictionary
                    
                    for resData in (data as? [AnyObject])!{
                        let id = resData["id"] as! Int
                        
                        if "\(id)" == self.match_id{
                            
                            let gameTime = resData["time"] as! NSDictionary
                            let status = gameTime["status"] as! String
                            
                            let gameStartTime = gameTime["starting_at"] as! NSDictionary
                            let gameTimestart = gameStartTime["date_time"] as! String
                            let startingDate = gameStartTime["date"] as? String
                            
                            //HomeTeam
                            let localTeam = resData["localTeam"] as! NSDictionary
                            let L_teamName = localTeam["data"] as! NSDictionary
                            self.localTeamId = L_teamName["id"] as! Int
                            let h_name = L_teamName["name"] as? String
                            let FinalScore = resData["scores"] as! NSDictionary
                            let ht_score = FinalScore["ht_score"] as? String
                           self.haif_Time_Score = ht_score!
                            let visitScore = FinalScore["visitorteam_score"] as! Int
                            let LocalScore = FinalScore["localteam_score"] as! Int
                            // gamestartTime
                            if((ht_score) == nil || ht_score == ""){
                                
                                self.halfTimeScore.text = String(format: "HT (0-0)")
                            }
                            else{
                                self.halfTimeScore.text = String(format: "HT (%@)",ht_score!)
                                
                            }
                            let LivegameTime = resData["time"] as! NSDictionary
                            
                            let LivegameStartTime = LivegameTime["starting_at"] as! NSDictionary
                            let startingTime = LivegameStartTime["time"] as! String
                            //AwayTeam
                            let VisitorTeam = resData["visitorTeam"] as! NSDictionary
                            let VisitorteamName = VisitorTeam["data"] as! NSDictionary
                            let a_name = VisitorteamName["name"] as? String
                            self.visitorTeamId = VisitorteamName["id"] as! Int
                            // leaugeName
                            let leauge = resData["league"] as! NSDictionary
                            let LiveLeague = leauge["data"] as! NSDictionary
                            let compatitonName =  LiveLeague["name"] as? String
                            //LocallTeam flag and logo
                            let localTeamflaf = resData["localTeam"] as! NSDictionary
                            let L_teamflage = localTeam["data"] as! NSDictionary
                            let flageLocal = L_teamName["logo_path"] as? String
                            let venue = resData["venue"] as! NSDictionary
                            let venueData = venue["data"] as! NSDictionary
                            let venuename = venueData["name"] as! String
                            if venuename != ""{
                                self.stadiumname.text = venuename
                            }
                            //                            self.flag1ImageView.loadImage(urlString: flageLocal!)
                            //                            self.team1Label.text = h_name
                            
                            let visitTeamflaf = resData["visitorTeam"] as! NSDictionary
                            let V_teamflage = visitTeamflaf["data"] as! NSDictionary
                            let flagevisit = V_teamflage["logo_path"] as? String
                            //                            self.flag2ImageView.loadImage(urlString: flagevisit!)
                            //                            self.team2Label.text = a_name
                            let LocalTeamids  = "\(self.localTeamId)"
                            let VisitorTeamids  = "\(self.visitorTeamId)"
                            
                            if self.selectedeteamId == LocalTeamids {
                                self.flag1ImageView.loadImage(urlString: flageLocal!)
                                self.team1Label.text = h_name
                                let TeamScore = "\(LocalScore) - \(visitScore)"
                                //let TeamScore = "\(LocalScore) - \(visitScore)"
                                self.ownTeamScore.text = "\(TeamScore)"
                            }
                            else{
                                self.flag1ImageView.loadImage(urlString: flageLocal!)
                                self.team1Label.text = h_name
                                let TeamScore = "\(LocalScore) - \(visitScore)"
                                //let TeamScore = "\(LocalScore) - \(visitScore)"
                                self.ownTeamScore.text = "\(TeamScore)"
                                
                            }
                            if self.selectedeteamId == VisitorTeamids {
                                self.flag2ImageView.loadImage(urlString: flagevisit!)
                                self.team2Label.text = a_name
                                let TeamScore = "\(LocalScore) - \(visitScore)"
                                // let TeamScore = "\(visitScore) - \(LocalScore)"
                                self.ownTeamScore.text = "\(TeamScore)"
                                
                            }
                            else{
                                
                                self.flag2ImageView.loadImage(urlString: flagevisit!)
                                self.team2Label.text = a_name
                                //let TeamScore = "\(visitScore) - \(LocalScore)"
                                let TeamScore = "\(LocalScore) - \(visitScore)"
                                
                                self.ownTeamScore.text = "\(TeamScore)"
                            }
                            // self.ownTeamScore.text = ht_score
                            if status == "NS"{
                                self.halfTimeScore.isHidden = true
                                self.ownTeamScore.isHidden = true
                                self.matchNotStart.isHidden = false
                                let matchNotStartedString = NSLocalizedString("Match Not Started Yet", comment: "")
                                self.matchNotStart.text = matchNotStartedString
                                let formattar5 = DateFormatter()
                                formattar5.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                formattar5.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                                // formattar5.timeZone = TimeZone.current
                                let matDate =  formattar5.date(from: gameTimestart as String)! as NSDate
                                print(matDate)
                                formattar5.dateFormat = "EEE MMM-dd HH:mm"
                                formattar5.timeZone = TimeZone.current
                                let matDate1 =  formattar5.string(from: matDate as Date)
                                print(matDate1)
                                
                                self.scorelivelabel.text = "\(matDate1)"
                                self.activityIndicator.stopAnimating()
                            }else{
                                self.matchNotStart.isHidden = true
                                self.LiveTime.isHidden = false
                                let minuteOngoing = LivegameTime["minute"] as! Int
                                if(minuteOngoing < 40)
                                {
                                    self.halfTimeScore.isHidden = true
                                }
                                let minuteString = NSLocalizedString("Minute", comment: "")
                                self.LiveTime.text =  "\(minuteString) : " +  "\(minuteOngoing)"
                                
                                let eventdic = resData["events"] as! NSDictionary
                                // let eventdic =    data1?.value(forKey: "events") as! NSDictionary
                                let  eventData  = eventdic["data"] as? [AnyObject]
                                // let  eventData  = eventdic.value(forKey: "data") as? [AnyObject]
                                for liveEventdata in eventData!{
                                    let typrValue = liveEventdata["type"] as? String
                                    let minueValue = liveEventdata["minute"] as! NSNumber
                                    let min = Int(minueValue)
                                    let teamID = liveEventdata["team_id"] as? String
                                    let playerName = liveEventdata["player_name"] as? String
                                    if playerName != "" {
                                        let newAdd = ["typeValue":"\(typrValue ?? "")","minute": min ,"teamID":"\(teamID!)","player_name":"\(playerName ?? "")"] as NSDictionary
                                        self.fixture1.add(newAdd)
                                        
                                    }
                                    if (self.halfScore){
                                        if min <= 45 {
                                            if min == 45 {
                                                print("MInute 45 available in this Event ")
                                                self.halfScore = false
                                            }else {
                                              
                                                 let newAdd = ["typeValue" : "","minute" : 45,"teamID" : "","player_name" : ""] as NSDictionary
                                                self.fixture1.add(newAdd)
                                                self.halfScore = false
                                            }
                                        }else{
                                            
                                        }
                                    }
                                    let newObj = teamData1(  typeValue: typrValue!, minute: min, teamID: teamID!, player_name:playerName!)
                                    self.team_data.append(newObj)
                                    
                                }
                                print(self.fixture1)
                                let newArr = self.fixture1.sortedArray(using: [NSSortDescriptor(key: "minute", ascending: false)])
                                
                                let sortedArr = (newArr as NSArray)
                                print(sortedArr)
                                self.fixture1.removeAllObjects()
                                self.fixture1 = sortedArr.mutableCopy() as! NSMutableArray
                                
                                if   self.fixture1.count>0{
                                    self.name = self.team_data[0].teamID
                                    
                                    self.myTableView.reloadData()
                                    self.activityIndicator.stopAnimating()
                                }
                                else{
                                    self.myTableView.reloadData()
                                    self.activityIndicator.stopAnimating()
                                }
                                
                                //self.name = self.team_data[0].teamID
                            }
                            return
                        }
                        else{
                            
                            let data = UserDefaults.standard.object(forKey: "name")
                            self.team1Label.text = data as? String
                            let mylogo = UserDefaults.standard.object(forKey: "logo")
                            self.flag1ImageView.loadImage(urlString: mylogo as! String)
                            let data1 = UserDefaults.standard.object(forKey: "teamname")
                            self.team2Label.text = data1 as? String
                            let mylogo1 = UserDefaults.standard.object(forKey: "flag")
                            self.flag2ImageView.loadImage(urlString: mylogo1 as! String)
                            let stadiumName = UserDefaults.standard.object(forKey: "stadiumName") as! String
                            if stadiumName != "" {
                                self.stadiumname.text =  stadiumName
                            }
                            let matchDate = "\(self.matchDate)"
                            self.matchNotStart.isHidden = false
                               let matchNotStartedString = NSLocalizedString("Match Not Started Yet", comment: "")
                            self.matchNotStart.text = matchNotStartedString
                            if matchDate != "" {
                                let formattar50 = DateFormatter()
                                formattar50.dateFormat =  "yyyy-MM-dd, HH:mm:ss"
                                formattar50.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                                let matDate =  formattar50.date(from: matchDate as String)! as NSDate
                                print(matDate)
                                formattar50.dateFormat = "EEE MMM-dd HH:mm"
                                formattar50.timeZone = TimeZone.current
                                let matDate1 =  formattar50.string(from: matDate as Date)
                                print(matDate1)
                                
                                self.scorelivelabel.text = "\(matDate1)"
                            }
                            self.activityIndicator.stopAnimating()
                        }
                        
                    }
                    
                    
                    
                }
            }
                
            else if response.result.isFailure {
                
                print( "SOME ERROR IS JSON DATA")
            }
        }
    }
}

extension LiveViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fixture1.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic = fixture1[indexPath.row] as! NSDictionary
        let teamIDS  = dic.value(forKey: "teamID") as! String
        let visitteamId = "\(visitorTeamId)"
        let LocalteamId = "\(self.localTeamId)"
        print(self.selectedeteamId)
        if self.selectedeteamId == teamIDS  {
            
            
            if self.selectedeteamId == LocalteamId {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! secondTeamCell1
                //  let typeCheck = team_data[indexPath.row].typeValue
                let dic = fixture1[indexPath.row] as! NSDictionary
                let typeCheck  = dic.value(forKey: "typeValue") as! String
                
                if typeCheck == "substitution"
                {
                    cell.image2.image = UIImage(named: "arrow 1x")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.team2Name.text = playerName
                }
                else if  typeCheck == "goal"{
                    cell.image2.image = UIImage(named: "football-1x")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    
                    cell.team2Name.text = playerName
                }
                else if  typeCheck == "redcard"{
                    cell.image2.image = UIImage(named: "redcard")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    
                    cell.team2Name.text = playerName
                }
                else if  typeCheck == "yellowred"{
                    cell.image2.image = UIImage(named: "yelloRed")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    
                    cell.team2Name.text = playerName
                }
                    
                    
                else if  typeCheck == "penalty"{
                    cell.image2.image = UIImage(named: "penalty")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    let penaltystring = String(format:"%@  Pen",playerName )
                    cell.team2Name.text = penaltystring
                    
                }
                else if  typeCheck == "missed_penalty"{
                    cell.image2.image = UIImage(named: "missedPenalty")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    
                    cell.team2Name.text = playerName
                }
                else if  typeCheck == "own-goal"{
                    cell.image2.image = UIImage(named: "football-1x")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    let ownGoalString = String(format:"%@  OG",playerName )
                    cell.team2Name.text = ownGoalString
                }
                    
                    
                else   {
                    cell.image2.image = UIImage(named: "3x_0003_Ellipse-3-copy-8")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    
                    cell.team2Name.text = playerName
                }
                
                
                let minute  = dic.value(forKey: "minute") as! Int
                
                
             
                let minuteValue = Int(minute)
                
                if minuteValue == 45 {
                    cell.image2.image = UIImage(named: "")
                    cell.team2Name.text = ""
                    cell.secondTeamHalfTimeScore .isHidden = false
                    cell.secondTeamHalfTimeScore.text = "HT " + self.haif_Time_Score
                    halfScore = false
                    cell.team2TimeLabel.text = " "
                    cell.whistleSecondImg.isHidden = false
                }
                    
                else {
                    cell.secondTeamHalfTimeScore .isHidden = true
                    cell.whistleSecondImg.isHidden = true
                    cell.team2TimeLabel.text = "\(minute)"
                }
                
               
//                cell.layer.cornerRadius = 8
//                cell.layer.masksToBounds = true
//
//                cell.layer.masksToBounds = false
//                cell.layer.shadowOffset = CGSize(width: 0, height: 0)
//                cell.layer.shadowColor = UIColor.cyan.cgColor
//                cell.layer.shadowOpacity = 0.23
//                cell.layer.shadowRadius = 4
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! gameCustomCell1
                //   let typeCheck = team_data[indexPath.row].typeValue
                let dic = fixture1[indexPath.row] as! NSDictionary
                let typeCheck  = dic.value(forKey: "typeValue") as! String
                
                if typeCheck == "substitution"
                {
                    cell.indicatorTickImageView.image = UIImage(named: "arrow 1x")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.teamNameLabel.text = playerName
                    
                }
                else if  typeCheck == "goal"{
                    cell.indicatorTickImageView.image = UIImage(named: "football-1x")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.teamNameLabel.text = playerName
                    
                }
                else if  typeCheck == "redcard"{
                    cell.indicatorTickImageView.image = UIImage(named: "redcard")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.teamNameLabel.text = playerName
                    
                }
                else if  typeCheck == "yellowred"{
                    cell.indicatorTickImageView.image = UIImage(named: "yelloRed")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.teamNameLabel.text = playerName
                    
                }
                else if  typeCheck == "penalty"{
                    cell.indicatorTickImageView.image = UIImage(named: "penalty")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    let penaltystring = String(format:"%@  Pen",playerName )
                    cell.teamNameLabel.text = penaltystring
                    
                }
                else if  typeCheck == "missed_penalty"{
                    cell.indicatorTickImageView.image = UIImage(named: "missedPenalty")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.teamNameLabel.text = playerName
                    
                }
                else if  typeCheck == "own-goal"{
                    cell.indicatorTickImageView.image = UIImage(named: "football-1x")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    let ownGoalString = String(format:"%@  OG",playerName )
                    cell.teamNameLabel.text = ownGoalString
                    
                }
                    
                    
                    
                else   {
                    cell.indicatorTickImageView.image = UIImage(named: "3x_0003_Ellipse-3-copy-8")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.teamNameLabel.text = playerName
                    
                }
                
                let minute  = dic.value(forKey: "minute") as! Int
               
                let minuteValue = Int(minute)
                
                if minuteValue == 45 {
                    cell.indicatorTickImageView.image = UIImage(named: "")
                    cell.teamNameLabel.text = ""
                    cell.HalfTimeScore .isHidden = false
                    cell.HalfTimeScore.text = "HT " + self.haif_Time_Score
                    halfScore = false
                    cell.teamNameLabel.text = " "
                    cell.whistleimg.isHidden = false
                }
                    
                else {
                    cell.HalfTimeScore .isHidden = true
                    cell.whistleimg.isHidden = true
                    cell.timeLabel.text = "\(minute)"
                }
//                cell.layer.cornerRadius = 8
//                cell.layer.masksToBounds = true
//
//                cell.layer.masksToBounds = false
//                cell.layer.shadowOffset = CGSize(width: 0, height: 0)
//                cell.layer.shadowColor = UIColor.cyan.cgColor
//                cell.layer.shadowOpacity = 0.23
//                cell.layer.shadowRadius = 4
                return cell        }
        }
        else{
            if selectedeteamId == visitteamId {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! secondTeamCell1
                //  let typeCheck = team_data[indexPath.row].typeValue
                let dic = fixture1[indexPath.row] as! NSDictionary
                let typeCheck  = dic.value(forKey: "typeValue") as! String
                
                if typeCheck == "substitution"
                {
                    cell.image2.image = UIImage(named: "arrow 1x")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.team2Name.text = playerName
                }
                else if  typeCheck == "goal"{
                    cell.image2.image = UIImage(named: "football-1x")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.team2Name.text = playerName
                }
                else if  typeCheck == "redcard"{
                    cell.image2.image = UIImage(named: "redcard")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.team2Name.text = playerName
                }
                else if  typeCheck == "yellowred"{
                    cell.image2.image = UIImage(named: "yelloRed")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.team2Name.text = playerName
                }
                    
                else if  typeCheck == "penalty"{
                    cell.image2.image = UIImage(named: "penalty")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    let penaltystring = String(format:"%@  Pen",playerName )
                    cell.team2Name.text = penaltystring
                }
                else if  typeCheck == "missed_penalty"{
                    cell.image2.image = UIImage(named: "missedPenalty")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    
                    cell.team2Name.text = playerName
                }
                else if  typeCheck == "own-goal"{
                    cell.image2.image = UIImage(named: "football-1x")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    let ownGoalString = String(format:"%@  OG",playerName )
                    cell.team2Name.text = ownGoalString
                }
                    
                else   {
                    cell.image2.image = UIImage(named: "3x_0003_Ellipse-3-copy-8")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.team2Name.text = playerName
                }
                let minute  = dic.value(forKey: "minute") as! Int
            
                let minuteValue = Int(minute)
                
                if minuteValue == 45 {
                    cell.image2.image = UIImage(named: "")
                    cell.team2Name.text = ""
                    cell.secondTeamHalfTimeScore .isHidden = false
                    cell.secondTeamHalfTimeScore.text = "HT " + self.haif_Time_Score
                    halfScore = false
                    cell.team2TimeLabel.text = " "
                    cell.whistleSecondImg.isHidden = false
                }
                    
                else {
                    cell.secondTeamHalfTimeScore .isHidden = true
                    cell.whistleSecondImg.isHidden = true
                     cell.team2TimeLabel.text = "\(minute)"
                }
                
//                cell.layer.cornerRadius = 8
//                cell.layer.masksToBounds = true
//                cell.layer.masksToBounds = false
//                cell.layer.shadowOffset = CGSize(width: 0, height: 0)
//                cell.layer.shadowColor = UIColor.cyan.cgColor
//                cell.layer.shadowOpacity = 0.23
//                cell.layer.shadowRadius = 4
                return cell        }
            else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! gameCustomCell1
                //   let typeCheck = team_data[indexPath.row].typeValue
                let dic = fixture1[indexPath.row] as! NSDictionary
                let typeCheck  = dic.value(forKey: "typeValue") as! String
                if typeCheck == "substitution"
                {
                    cell.indicatorTickImageView.image = UIImage(named: "arrow 1x")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.teamNameLabel.text = playerName
                }
                else if  typeCheck == "goal"{
                    cell.indicatorTickImageView.image = UIImage(named: "football-1x")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.teamNameLabel.text = playerName
                }
                else if  typeCheck == "redcard"{
                    cell.indicatorTickImageView.image = UIImage(named: "redcard")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.teamNameLabel.text = playerName
                }
                else if  typeCheck == "yellowred"{
                    cell.indicatorTickImageView.image = UIImage(named: "yelloRed")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.teamNameLabel.text = playerName
                }
                else if  typeCheck == "penalty"{
                    cell.indicatorTickImageView.image = UIImage(named: "penalty")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    let penaltystring = String(format:"%@  Pen",playerName )
                    cell.teamNameLabel.text = penaltystring
                    
                }
                else if  typeCheck == "missed_penalty"{
                    cell.indicatorTickImageView.image = UIImage(named: "missedPenalty")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.teamNameLabel.text = playerName
                    
                }
                else if  typeCheck == "own-goal"{
                    cell.indicatorTickImageView.image = UIImage(named: "football-1x")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    let ownGoalString = String(format:"%@  OG",playerName )
                    cell.teamNameLabel.text = ownGoalString
                    
                }
                else   {
                    cell.indicatorTickImageView.image = UIImage(named: "3x_0003_Ellipse-3-copy-8")
                    let playerName  = dic.value(forKey: "player_name") as! String
                    cell.teamNameLabel.text = playerName
                    
                }
                
                let minute  = dic.value(forKey: "minute") as! Int
           
                 let minuteValue = Int(minute)
                if minuteValue == 45 {
                    cell.indicatorTickImageView.image = UIImage(named: "")
                    cell.teamNameLabel.text = ""
                    cell.HalfTimeScore .isHidden = false
                    cell.HalfTimeScore.text = "HT " + self.haif_Time_Score
                    halfScore = false
                    cell.teamNameLabel.text = " "
                    cell.whistleimg.isHidden = false
                }
                    
                else {
                    cell.HalfTimeScore .isHidden = true
                    cell.whistleimg.isHidden = true
                      cell.timeLabel.text = "\(minute)"
                }
//                cell.layer.cornerRadius = 8
//                cell.layer.masksToBounds = true
//
//                cell.layer.masksToBounds = false
//                cell.layer.shadowOffset = CGSize(width: 0, height: 0)
//                cell.layer.shadowColor = UIColor.cyan.cgColor
//                cell.layer.shadowOpacity = 0.23
//                cell.layer.shadowRadius = 4
                return cell
            }
        }
        
    }
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     // Dequeue with the reuse identifier
     let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
     let header = cell as! headerViewCell
     header.timeLabel.text = "99"
     
     return cell
     }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 40
     }
     */
}

class gameCustomCell1 : UITableViewCell{
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var indicatorTickImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var HalfTimeScore: UILabel!
    @IBOutlet weak var whistleimg: UIImageView!
}

class secondTeamCell1 : UITableViewCell {
    
    @IBOutlet weak var team2TimeLabel: UILabel!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var team2Name: UILabel!
    @IBOutlet weak var whistleSecondImg: UIImageView!
      @IBOutlet weak var secondTeamHalfTimeScore: UILabel!

}

class headerViewCell1 : UITableViewHeaderFooterView {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var indicatorTickImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
}

class teamData1 {
    //var teamName: String = ""
    //var teamLogo: String = ""
    var typeValue: String = ""
    var minute:Int = 0
    var teamID:String = ""
    var player_name:String = ""
    
    init(  typeValue:String, minute:Int, teamID:String, player_name:String) {
        //  self.teamLogo = teamLogo
        //self.teamName = teamName
        self.typeValue = typeValue
        self.minute = minute
        self.teamID = teamID
        self.player_name = player_name
    }
    
}
