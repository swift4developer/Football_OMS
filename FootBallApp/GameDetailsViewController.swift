
//
//  GameDetailsViewController.swift
//  FootBallApp
//
//  Created by Praveen Khare on 07/04/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire
import KFSwiftImageLoader

class GameDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var flag2ImageView: UIImageView!
    @IBOutlet weak var flag1ImageView: UIImageView!
    
    @IBOutlet weak var ownTeamScore: UILabel!
    @IBOutlet weak var againstTeamScore: UILabel!
    @IBOutlet weak var fullTimeLbl: UILabel!
    
    @IBOutlet var halfTimeScore: UILabel!
    @IBOutlet weak var matchNotsatarted: UILabel!
    @IBOutlet weak var stadiumName: UILabel!
    @IBOutlet weak var againstTeamscore: UILabel!
    
    @IBOutlet weak var matchDateAndTime: UILabel!
    
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var match_id: String = ""
    var hometeamId: String = ""
    var stadiumNamestr = ""
    var haif_Time_Score = ""
    
    var halfScore = true
    var halfTimePresent = "present"
    var team_data = [teamData]()
    var teamDeatilDict = NSDictionary()
    var name = String()
    
    var image1URL = String()
    var image2URL = String()
    var goal = NSMutableArray()
    var goalhome = NSMutableArray()
    var finalScore = String()
    var  selectedTeamName = String()
    
    var HomeTeam = String()
    var AwayTeam = String()
    var teamid = String()
    var comesFrom = ""
    
    @IBAction func filterBtn(_ sender: Any) {
    }
    @IBAction func serchBtn(_ sender: Any) {
    }
    @IBAction func settingBtn(_ sender: UIBarButtonItem) {
//        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "setting") as? SettingViewController
//        self.navigationController?.pushViewController(settingVC!, animated: true)
    }
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        //        let myTeamVC:TabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "tab_bar") as! TabBarViewController
        //        self.present(myTeamVC, animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = UserDefaults.standard.object(forKey: "TEAM_ID")
        self.hometeamId = (data as? String)!
        //        self.halfTimeScore.text = (String, format: "HT: %@",teamDeatilDict.value(forKey: "ht_score") )
       // self.halfTimeScore.text = String(format: "HT (%@)",teamDeatilDict.value(forKey: "ht_score") as! CVarArg)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        
        //        let pref = UserDefaults.standard
        //        if let t_id = pref.object(forKey: "TEAM_ID") {
        //            self.hometeamId = (t_id as? String)!
        //
        //        }
        
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let tittlename = NSLocalizedString("Game Details", comment: "")
        self.navigationItem.title = tittlename
        
        self.matchNotsatarted.isHidden = true
        
        activityIndicator.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        let data = UserDefaults.standard.object(forKey: "name")
        // self.team1Label.text = data as? String
        selectedTeamName = (data as? String)!
        //        let mylogo = UserDefaults.standard.object(forKey: "logo")
        //        self.flag1ImageView.loadImage(urlString: mylogo as! String)
        self.stadiumName.text = stadiumNamestr
        downloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("disappear")
        if comesFrom == "Fixture" {
            let fixtureeeViewController = self.storyboard?.instantiateViewController(withIdentifier: "fixtureeeViewController") as? fixtureeeViewController
            fixtureeeViewController?.gotoDetail = "Yes"
            fixtureeeViewController?.searchStr = "true"
            self.navigationController?.popViewController(animated: false)
        }else{
            let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "home") as? HomeViewController

            self.navigationController?.popViewController(animated: false)
        }

        
    }
    func downloadData() {
        activityIndicator.startAnimating()
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=getEvent&match_id=\(match_id)")!
        //   let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=getEvent&match_id=795365")!
        
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let resJson = response.result.value as? [String: AnyObject]{
                    let responseCode = resJson["RESPONSECODE"] as! NSNumber
                    print(responseCode)
                    
                    if responseCode == 1{
                        if let response = resJson["RESPONSE"] as? NSDictionary {
                            let MatchDetail = response["match"] as? NSArray
                            let MatchData = MatchDetail?.object(at: 0) as! NSDictionary
                            let h_tScore = MatchData["ht_score"] as? String
                            self.haif_Time_Score = (MatchData["ht_score"] as? String)!
                            if h_tScore != nil {
                             self.halfTimeScore.text = String(format: "HT (%@)",h_tScore!)
                        }
                            let venueName = MatchData.value(forKey: "venue_id")
                            self.stadiumName.text = venueName as? String
                            let res = response["match_detail"] as? [AnyObject]
                            if res != nil{
                                for resData in res! {
                                    let teamName = resData["team_name"] as? String
                                    self.teamid = (resData["team_id"] as? String)!
                                    let teamLogo = resData["team_logo"] as? String
                                    let minute = resData["minute_val"] as? String
                                    let min = Int (minute!)
                                    let typrValue = resData["type_val"] as? String
                                    let finalScoree = resData["ft_score"] as? String
                                    self.HomeTeam = (resData["home_team_id"] as? String)!
                                    self.AwayTeam = (resData["away_team_id"] as? String)!
                                    self.finalScore = finalScoree!
                                    if self.HomeTeam == self.hometeamId{
                                        if self.teamid != self.hometeamId{
                                            self.flag2ImageView.loadImage(urlString: teamLogo!)
                                            self.team2Label.text = teamName
                                        }else{
                                            self.flag1ImageView.loadImage(urlString: teamLogo!)
                                            self.team1Label.text = teamName
                                            
                                        }
                                        
                                    }else{
                                        if self.AwayTeam == self.hometeamId  {
                                            if self.teamid != self.hometeamId{
                                                
                                                self.flag1ImageView.loadImage(urlString: teamLogo!)
                                                self.team1Label.text = teamName
                                                
                                            }
                                            else{
                                                self.flag2ImageView.loadImage(urlString: teamLogo!)
                                                self.team2Label.text = teamName
                                            }
                                        }
                                    }
                                    if self.teamid == self.hometeamId && typrValue == "goal"  {
                                        self.goalhome.add(typrValue)
                                       
                                    }
                                   
                                    else {
                                      
                                        if typrValue == "goal" {
                                            self.goal.add(typrValue)
                                            
                                        }
                                    }
                                    let teamID = resData["team_id"] as? String
                                    let playerName = resData["player_in_name"] as? String
                                    if (self.halfScore){
                                        if min! <= 45 {
                                            if min! == 45 {
                                                print("MInute 45 available in this Event ")
                                                let newObj = teamData(teamName: teamName!, teamLogo: teamLogo!, typeValue: typrValue!, minute: min!, teamID: teamID!, player_name:playerName!)
                                                self.team_data.append(newObj)
                                                self.halfScore = false
                                            }else {
                                                let newObj = teamData(teamName:"", teamLogo: "", typeValue: "", minute: 45, teamID: teamID!, player_name:"")
                                                self.team_data.append(newObj)
                                                self.halfScore = false
                                            }
                                        }
                                    }
                                    
                                    if min! == 45 {
                                        
                                        continue
                                    }
                                    else {
                                        let newObj = teamData(teamName: teamName!, teamLogo: teamLogo!, typeValue: typrValue!, minute: min!, teamID: teamID!, player_name:playerName!)
                                        self.team_data.append(newObj)
                                    }
                                }
                               
                                let lastMinute = self.team_data.last?.minute
                                
                                if lastMinute! > 45 {
                                    
                                    let newObj = teamData(teamName:"", teamLogo: "", typeValue: "", minute: 45, teamID: "", player_name:"")
                                    self.team_data.append(newObj)
                                }
                                
                                let nohomGoal = self.goalhome.count
                                self.ownTeamScore.text = self.finalScore
                                let noGoal = self.goal.count
                                //self.againstTeamScore.text = String(noGoal)
                                
                                
                                //  let groupArr = res.flatMap({ element in (res["team_logo"] as? String)!})
                                self.myTableView.reloadData()
                                self.name = self.team_data[0].teamID
                                // self.team1Label.text = self.team_data[0].teamName
                                self.activityIndicator.stopAnimating()
                                // self.flag1ImageView.loadImage(urlString: self.team_data[0].teamLogo)
                            }
                            else{
                                print("done")
                                self.matchNotsatarted.isHidden = false
                                self.ownTeamScore.isHidden = true
                                self.fullTimeLbl.isHidden = true
                                self.activityIndicator.stopAnimating()
                                let awayteamName = MatchData.value(forKey: "away_team")
                                self.team2Label.text = awayteamName as! String
                                let hometeamName = MatchData.value(forKey: "home_team")
                                self.team1Label.text = hometeamName as! String
                                let homeLogo = MatchData["home_team_logo"] as? String
                                self.flag1ImageView.loadImage(urlString: homeLogo!)
                                let away_team_logo = MatchData["away_team_logo"] as? String
                                self.flag2ImageView.loadImage(urlString: away_team_logo!)
                                let s : String = (MatchData["start_date"] as? String)!
                                let formattar = DateFormatter()
                                formattar.dateFormat = "yyyy-MM-dd"
                                formattar.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                                let  matchDate =  formattar.date(from: s)!
                                
                                formattar.dateFormat = "yyyy-MM-dd"
                                //formattar.timeZone = NSTimeZone(name: "GMT")! as TimeZone
                                let matchDate1 =  formattar.string(from: matchDate)
                                print(matchDate1)
                                
                                let dateFormatter1 = DateFormatter()
                                dateFormatter1.dateFormat = "EEE dd/M/yyyy "
                                
                                dateFormatter1.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                                let timeStamp1 = dateFormatter1.string(from: matchDate)
                                print(timeStamp1)
                                // cell.DateLbel.text = timeStamp1
                                //Time
                                let StartinTime = (MatchData["start_time"] as? String)!
                                
                                let dateFormatter2 = DateFormatter()
                                dateFormatter2.dateFormat = "HH:mm:ss"
                                //dateFormatter2.timeZone = NSTimeZone(name: "UTC")! as TimeZone
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
                                //formattar5.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                formattar5.dateFormat = "EEE MMM-dd HH:mm"
                                formattar5.timeZone = TimeZone.current
                                let matDate =  formattar5.string(from: matDate1 as Date)
                                print(matDate)
                                self.matchDateAndTime.text = String(format :"%@",matDate)
                                self.ownTeamScore.text = ""
                                self.matchNotsatarted.text = "Match not started yet"
                                self.halfTimeScore.isHidden = true
                                
                            }
                            
                        }
                    }
                    else{
                        self.ownTeamScore.text="0"
                        self.againstTeamScore.text="0"
                        
                        let msg = resJson["RESPONSE"] as? String
                        let alertController = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
                        let goToProList = UIAlertAction(title: "OK", style: .default, handler: { action in
                            //                            let myTeamVC:TabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "tab_bar") as! TabBarViewController
                            //                            self.present(myTeamVC, animated: true, completion: nil)
                            self.dismiss(animated: false, completion: nil)
                            self.navigationController?.popViewController(animated: true)
                            self.activityIndicator.stopAnimating()
                            
                            self.ownTeamScore.text="0"
                            self.againstTeamScore.text="0"
                            
                            
                        })
                        alertController.addAction(goToProList)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            else if response.result.isFailure {
                print( "SOME ERROR IS JSON DATA")
            }
        }
        
    }
    
}

extension GameDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team_data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.hometeamId == team_data[indexPath.row].teamID {
            if self.HomeTeam == self.hometeamId{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! secondTeamCell
                let typeCheck = team_data[indexPath.row].typeValue
                if typeCheck == "substitution"
                {
                    cell.image2.image = UIImage(named: "arrow 1x")
                    cell.team2Name.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "goal"{
                    cell.image2.image = UIImage(named: "football-1x")
                    cell.team2Name.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "redcard"{
                    cell.image2.image = UIImage(named: "redcard")
                    cell.team2Name.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "yellowred"{
                    cell.image2.image = UIImage(named: "yelloRed")
                    cell.team2Name.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "penalty"{
                    cell.image2.image = UIImage(named: "penalty")
                    let penaltystr = team_data[indexPath.row].player_name
                    let penaltystring = String(format:"%@  Pen",penaltystr )
                    cell.team2Name.text = penaltystring
                }
                else if  typeCheck == "missed_penalty"{
                    cell.image2.image = UIImage(named: "missedPenalty")
                    cell.team2Name.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "own-goal"{
                    cell.image2.image = UIImage(named: "football-1x")
                    let OwnGoalstr = team_data[indexPath.row].player_name
                    let ownGoalString = String(format:"%@  OG",OwnGoalstr )
                    cell.team2Name.text = ownGoalString
                }
                    
                else if  typeCheck == "yellowcard"   {
                    cell.image2.image = UIImage(named: "3x_0003_Ellipse-3-copy-8")
                    cell.team2Name.text = team_data[indexPath.row].player_name
                }
             
                let minuteValue = team_data[indexPath.row].minute
               
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
                     cell.team2TimeLabel.text = "\(minuteValue)"
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
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! gameCustomCell
             
                let typeCheck = team_data[indexPath.row].typeValue
                if typeCheck == "substitution"
                {
                    cell.indicatorTickImageView.image = UIImage(named: "arrow 1x")
                    cell.teamNameLabel.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "goal"{
                    cell.indicatorTickImageView.image = UIImage(named: "football-1x")
                    cell.teamNameLabel.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "redcard"{
                    cell.indicatorTickImageView.image = UIImage(named: "redcard")
                    cell.teamNameLabel.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "yellowred"{
                    cell.indicatorTickImageView.image = UIImage(named: "yelloRed")
                    cell.teamNameLabel.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "penalty"{
                    
                    cell.indicatorTickImageView.image = UIImage(named: "penalty")
                    let penaltystr = team_data[indexPath.row].player_name
                    let penaltystring = String(format:"Pen  %@",penaltystr )
                    cell.teamNameLabel.text = penaltystring
                    
                }
                else if  typeCheck == "missed_penalty"{
                    cell.indicatorTickImageView.image = UIImage(named: "missedPenalty")
                    cell.teamNameLabel.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "own-goal"{
                    cell.indicatorTickImageView.image = UIImage(named: "football-1x")
                    
                    let OwnGoalstr = team_data[indexPath.row].player_name
                    let ownGoalString = String(format:"OG  %@",OwnGoalstr )
                    cell.teamNameLabel.text = ownGoalString
                }
                    
                    
                else if  typeCheck == "yellowcard"  {
                    cell.indicatorTickImageView.image = UIImage(named: "3x_0003_Ellipse-3-copy-8")
                    cell.teamNameLabel.text = team_data[indexPath.row].player_name
                }
               let minuteValue = team_data[indexPath.row].minute
                    if minuteValue == 45 {
                        cell.indicatorTickImageView.image = UIImage(named: "")
                        cell.teamNameLabel.text = ""
                        cell.HalfTimeScore .isHidden = false
                        cell.HalfTimeScore.text = "HT " + self.haif_Time_Score
                        cell.timeLabel.text = ""
                        halfScore = false
                        cell.whistleimg.isHidden = false
                    }

                    else {
                     cell.HalfTimeScore .isHidden = true
                        cell.timeLabel.text = "\(minuteValue)"
                        cell.whistleimg.isHidden = true
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
            
        else {
            if self.AwayTeam == self.hometeamId  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! secondTeamCell
                let typeCheck = team_data[indexPath.row].typeValue
                if typeCheck == "substitution"
                {
                    cell.image2.image = UIImage(named: "arrow 1x")
                    cell.team2Name.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "goal"{
                    cell.image2.image = UIImage(named: "football-1x")
                    cell.team2Name.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "redcard"{
                    cell.image2.image = UIImage(named: "redcard")
                    cell.team2Name.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "yellowred"{
                    cell.image2.image = UIImage(named: "yelloRed")
                    cell.team2Name.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "penalty"{
                    cell.image2.image = UIImage(named: "penalty")
                    let penaltystr = team_data[indexPath.row].player_name
                    let penaltystring = String(format:"Pen  %@",penaltystr )
                    cell.team2Name.text = penaltystring
                    
                }
                else if  typeCheck == "missed_penalty"{
                    cell.image2.image = UIImage(named: "missedPenalty")
                    cell.team2Name.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "own-goal"{
                    cell.image2.image = UIImage(named: "football-1x")
                    let OwnGoalstr = team_data[indexPath.row].player_name
                    let OwnGoalstring = String(format:"OG  %@",OwnGoalstr )
                    cell.team2Name.text = OwnGoalstring
                    
                }
                    
                    
                else if  typeCheck == "yellowcard"  {
                    cell.image2.image = UIImage(named: "3x_0003_Ellipse-3-copy-8")
                    cell.team2Name.text = team_data[indexPath.row].player_name
                }
                    let minuteValue = team_data[indexPath.row].minute
            
                if minuteValue == 45 {
                    cell.image2.image = UIImage(named: "")
                    cell.team2Name.text = ""
                    cell.secondTeamHalfTimeScore .isHidden = false
                    cell.secondTeamHalfTimeScore.text = "HT " + self.haif_Time_Score
                        cell.team2TimeLabel.text = " "
                    halfScore = false
                    cell.whistleSecondImg.isHidden = false
                }
                    
                else {
                    cell.secondTeamHalfTimeScore .isHidden = true
                        cell.team2TimeLabel.text = "\(minuteValue)"
                                        cell.whistleSecondImg.isHidden = true
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
                
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! gameCustomCell
              
                let typeCheck = team_data[indexPath.row].typeValue
                if typeCheck == "substitution"
                {
                    cell.indicatorTickImageView.image = UIImage(named: "arrow 1x")
                    cell.teamNameLabel.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "goal"{
                    cell.indicatorTickImageView.image = UIImage(named: "football-1x")
                    cell.teamNameLabel.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "redcard"{
                    cell.indicatorTickImageView.image = UIImage(named: "redcard")
                    cell.teamNameLabel.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "yellowred"{
                    cell.indicatorTickImageView.image = UIImage(named: "yelloRed")
                    cell.teamNameLabel.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "penalty"{
                    cell.indicatorTickImageView.image = UIImage(named: "penalty")
                    let penaltystr = team_data[indexPath.row].player_name
                    let penaltystring = String(format:"Pen  %@",penaltystr )
                    cell.teamNameLabel.text = penaltystring
                }
                else if  typeCheck == "missed_penalty"{
                    cell.indicatorTickImageView.image = UIImage(named: "missedPenalty")
                    cell.teamNameLabel.text = team_data[indexPath.row].player_name
                }
                else if  typeCheck == "own-goal"{
                    cell.indicatorTickImageView.image = UIImage(named: "football-1x")
                    let OwnGoalstr = team_data[indexPath.row].player_name
                    let ownGoalString = String(format:"OG  %@",OwnGoalstr )
                    cell.teamNameLabel.text = ownGoalString
                }
                    
                    
                else  if  typeCheck == "yellowcard" {
                    cell.indicatorTickImageView.image = UIImage(named: "3x_0003_Ellipse-3-copy-8")
                    cell.teamNameLabel.text = team_data[indexPath.row].player_name
                }
           let minuteValue = team_data[indexPath.row].minute
            
                    if minuteValue == 45 {
                        cell.indicatorTickImageView.image = UIImage(named: "")
                        cell.teamNameLabel.text = ""
                    cell.HalfTimeScore .isHidden = false
                    cell.HalfTimeScore.text = "HT " + self.haif_Time_Score
                            cell.timeLabel.text =  ""
                    halfScore = false
                        cell.whistleimg.isHidden = false
                    }
      
                else {
                        cell.HalfTimeScore .isHidden = true
                            cell.timeLabel.text =  "\(minuteValue)"
                        cell.whistleimg.isHidden = true
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

class gameCustomCell : UITableViewCell{
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var indicatorTickImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var HalfTimeScore: UILabel!
    @IBOutlet weak var whistleimg: UIImageView!
}

class secondTeamCell : UITableViewCell {
    
    @IBOutlet weak var whistleSecondImg: UIImageView!
    @IBOutlet weak var team2TimeLabel: UILabel!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var team2Name: UILabel!
    @IBOutlet weak var secondTeamHalfTimeScore: UILabel!
}

class headerViewCell : UITableViewHeaderFooterView {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var indicatorTickImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
}

class teamData {
    
    var teamName: String = ""
    var teamLogo: String = ""
    var typeValue: String = ""
    var minute = Int()
    var teamID:String = ""
    var player_name:String = ""
    
    init(teamName:String, teamLogo:String, typeValue:String, minute:Int, teamID:String, player_name:String) {
        self.teamLogo = teamLogo
        self.teamName = teamName
        self.typeValue = typeValue
        self.minute = minute
        self.teamID = teamID
        self.player_name = player_name
    }
    
}
