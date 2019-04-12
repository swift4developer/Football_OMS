//
//  SettingViewController.swift
//  FootBallApp
//
//  Created by Praveen Khare on 07/04/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Social
import Alamofire
protocol UpdtaeDataOnFixtureDelegate {
    func comesFrom(setting : String)
}
class SettingViewController: UIViewController,UISearchBarDelegate,UISearchControllerDelegate,UITextFieldDelegate {

   
   
    @IBOutlet var viewLanguage: UIView!
    @IBOutlet var viewCountry: UIView!
    @IBOutlet var viewTeam: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var SelectCountryTxt: UITextField!
    @IBOutlet weak var selectTeamTxt: UITextField!
  
     var delegate: UpdtaeDataOnFixtureDelegate?
    var teamTableView = UITableView()
    var countryTableView = UITableView()
    var languageTableView = UITableView()
    var strgoal = "0"
    var strfifremin = "0"
    var stronedaybefore = "0"
    var strfirsteleven = "0"
    var teamnameArray = NSArray()
      var teamnameFilterArray = NSArray()
    var teamnameListArray = NSArray()
    var countryArray = NSArray()
    var countryFilterdArray = NSArray()
    var strKeyEvents = ""
      var strOtherEvents = ""
    var resultSearchController = UISearchController()
    var issearchActive = false
      var isTeamsearchActive = false
     var TeamsearchBar = UISearchBar()
        var searchBar = UISearchBar()
     var search:String=""
    var comesFrom = ""
    
    
    @IBOutlet weak var keyEvents: UISwitch!
    
    @IBOutlet weak var otherEvents: UISwitch!
    @IBAction func first11Clk(_ sender: Any) {
        
        if switchFirst11.isOn {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "First11")
            strfirsteleven = "1"
            notificationApi()
        }
        else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "First11")
             strfirsteleven = "0"
            notificationApi()
        }
    }

    @IBAction func reminder1Days(_ sender: Any) {
        if switch1DayRemin.isOn {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "reminder1Days")
            stronedaybefore = "1"
            notificationApi()
        }
        else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "reminder1Days")
             stronedaybefore = "0"
            notificationApi()
        }
    }
    @IBAction func reminder15min(_ sender: Any) {
        if switch15minRemin.isOn {
//            let userDefaults = UserDefaults.standard
//            userDefaults.set(true, forKey: "reminder15min")
             UserDefaults.standard.set("1", forKey: "reminder15min")
            strfifremin = "1"
            notificationApi()
        }
        else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "reminder15min")
             strfifremin = "0"
            notificationApi()
            
        }
    }
    @IBAction func goalClk(_ sender: UISwitch) {
        if switchGoals.isOn {
//            let userDefaults = UserDefaults.standard
//            userDefaults.set("1", forKey: "GOAL")
             UserDefaults.standard.set("1", forKey: "GOAL")
            strgoal = "1"
            notificationApi()
        }
        else {
//            let userDefaults = UserDefaults.standard
//            userDefaults.set("0", forKey: "GOAL")
             UserDefaults.standard.set("0", forKey: "GOAL")
             strgoal = "0"
            notificationApi()
        }
    }
    @IBOutlet weak var selectTeamLabel: UILabel!
    @IBOutlet weak var selectCountryLabel: UILabel!
    @IBOutlet weak var selectLanguageLabel: UILabel!
    @IBOutlet weak var switchGoals: UISwitch!
    @IBOutlet weak var switchFirst11: UISwitch!
    @IBOutlet weak var switch15minRemin: UISwitch!
    @IBOutlet weak var switch1DayRemin: UISwitch!

    var selected_teamID:String = ""
    var selected_country_id:String = ""
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    @IBAction func shareOnTwitter(_ sender: UIButton) {
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
//            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//            self.present(tweetShare, animated: true, completion: nil)
//
//        } else {
//            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
        guard
            
            //let url = URL(string: "https://plus.google.com/u/0/communities/111377830439408117391" )
            let url = URL(string: "https://twitter.com/football_cal" )
            else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url )
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func shareOnGoogle(_ sender: UIButton) {
//        let shareGoogle = UIActivityViewController(activityItems: ["The string you want to share"], applicationActivities: nil)
//        self.popoverPresentationController?.sourceView = self.view
//        self.present(shareGoogle, animated: true) { 
//           
//        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(NSURL(string:"https://plus.google.com/u/0/communities/111377830439408117391")! as URL, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func shareOnFacebook(_ sender: UIButton) {
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
//            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            self.present(fbShare, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(NSURL(string:"https://www.facebook.com/footballcalendar")! as URL, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func shareOnYoutube(_ sender: UIButton) {
        let shareGoogle = UIActivityViewController(activityItems: ["The string you want to share"], applicationActivities: nil)
        self.popoverPresentationController?.sourceView = self.view
        self.present(shareGoogle, animated: true, completion: nil)
    }
//    var languagePickerView = UIPickerView()
//    var teamPickerView = UIPickerView()
//    var countryPickerView = UIPickerView()
    
    var country_data = [Country2DataClass]()
     var country_array = [NSMutableArray]()
    var team_data = [Team2ClassData]()
    
 
     var langArray: [String] = ["Dutch", "English", "German", "Italian","Spanish","Turkish"]
    
    @IBAction func profileBtn(_ sender: UIButton) {
        
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/4)
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
     
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
     //   getCountryData()
        //notificationApi ()
        
//        teamPickerView.isHidden = true
//        countryPickerView.isHidden = true
//        languagePickerView.isHidden = true
//        
//        languagePickerView.delegate = self
//        languagePickerView.dataSource = self
//        
//        teamPickerView.delegate = self
//        teamPickerView.dataSource = self
//        
//        countryPickerView.delegate = self
//        countryPickerView.dataSource = self
        
        switchGoals.transform = CGAffineTransform(scaleX: 0.60, y: 0.60)
        switchFirst11.transform = CGAffineTransform(scaleX: 0.60, y: 0.60)
        switch1DayRemin.transform = CGAffineTransform(scaleX: 0.60, y: 0.60)
        switch15minRemin.transform = CGAffineTransform(scaleX: 0.60, y: 0.60)
        keyEvents.transform = CGAffineTransform(scaleX: 0.60, y: 0.60)
        otherEvents.transform = CGAffineTransform(scaleX: 0.60, y: 0.60)

        let userDef = UserDefaults()
        self.selectTeamLabel.text = userDef.object(forKey: "TEAM") as? String
        self.selectCountryLabel.text = userDef.object(forKey: "COUNTRY") as? String
        
     //   self.hideKeyboardWhenTappedAround()
   }
    func keyboardWillShow(sender: NSNotification) {
//       self.view.frame.origin.y = -50
//        //self.scrollView.frame.origin.y = -250
//        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
//        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
//        let keyboardSize = keyboardInfo.cgRectValue.size
//        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
        
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
//        self.view.frame.origin.y = 0
//        self.scrollView.frame.origin.y = 0
//        self.view.gestureRecognizers = nil
        
    }
    func addSearchBarOnTbaleHeader () {
      TeamsearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
       TeamsearchBar.barTintColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
        TeamsearchBar.delegate = self
        self.teamTableView.tableHeaderView = TeamsearchBar
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar != TeamsearchBar{
        if (searchBar.text?.isEmpty)!{
          issearchActive = false
            countryTableView .reloadData()
            self.countryTableView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0)

        } else {
            self.countryTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            issearchActive = true
                    print(" search text %@ ",searchBar.text! as NSString)
              let searchPredicate =  NSPredicate(format: "name contains[c] %@", searchText)
            let filtered = (self.countryArray).filtered(using: searchPredicate ) as NSArray
            countryFilterdArray = filtered
            print(filtered)
            countryTableView.reloadData()
        }
        }else{
            if (searchBar.text?.isEmpty)!{
                isTeamsearchActive = false
                teamTableView .reloadData()
            } else {
                isTeamsearchActive = true
                print(" search text %@ ",searchBar.text! as NSString)
                let searchPredicate =  NSPredicate(format: "name contains[c] %@", searchText)
                let filtered = (self.teamnameArray).filtered(using: searchPredicate ) as NSArray
                teamnameFilterArray = filtered
                print(filtered)
                teamTableView.reloadData()
            }
        }
            
    }
    func checkLanguage () {
        let preferredLanguage = Bundle.main.preferredLocalizations.first
        if preferredLanguage == "en" {
            self.selectLanguageLabel.text = "English"
            print("this is English")
        } else if preferredLanguage == "es" {
               self.selectLanguageLabel.text = "Spanish"
            print("this is spanish")
        }
        else if preferredLanguage == "tr" {
             self.selectLanguageLabel.text = "Turkish"
            print("this is Turkish")
        }
        else if preferredLanguage == "it" {
               self.selectLanguageLabel.text = "Italian"
            print("this is Italian")
        }
        else if preferredLanguage == "nl" {
               self.selectLanguageLabel.text = "Dutch"
            print("this is Dutch")
        }
        else if preferredLanguage == "de" {
            self.selectLanguageLabel.text = "German"
            print("this is German")
        }
        else {
            self.selectLanguageLabel.text = "English"
            print("this is English")
        }

        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "FixtureIndex")
        UserDefaults.standard.removeObject(forKey: "gotoDetail")
        UserDefaults.standard.removeObject(forKey: "filterstr")
        UserDefaults.standard.removeObject(forKey: "collIndex")
        let tittlename = NSLocalizedString("Settings", comment: "")
        self.navigationItem.title = tittlename
//      self.selectTeamTxt.delegate = self
//        self.SelectCountryTxt.delegate = self
//        removeBorder(textField: self.selectTeamTxt)
//          removeBorder(textField: self.SelectCountryTxt)
     //   checkLanguage ()
        self.checkSwitch()
           self.countryTableView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0)
        teamTableView.isHidden = true
        countryTableView.isHidden = true
        
        teamTableView.delegate = self
        teamTableView.dataSource = self
        
        countryTableView.delegate = self
        countryTableView.dataSource = self
        
        languageTableView.isHidden = true
        
        languageTableView.delegate = self
        languageTableView.dataSource = self
        if selectCountryLabel.text == "Select Country"{
            selectTeamLabel.isUserInteractionEnabled = false
        }else{
            selectTeamLabel.isUserInteractionEnabled = true
          
        }
        let tappedOnTeam = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.tappedOnTeam(_:)))
        selectTeamLabel.addGestureRecognizer(tappedOnTeam)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.handleTap(_:)))
        selectCountryLabel.addGestureRecognizer(gestureRecognizer)
        
       
        
//        let tappedOnLng = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.tappedOnLng(_:)))
//        selectLanguageLabel.addGestureRecognizer(tappedOnLng)

        
      //  self.hideKeyboardWhenTappedAround()
     
        
        teamTableView.register(UINib(nibName: "pickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
        
        
        countryTableView.register(UINib(nibName: "pickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")

//        languageTableView.register(UINib(nibName: "pickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
        languageTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
   
//        teamPickerView.frame = CGRect(x: 0, y: self.view.frame.size.height - 260, width: self.view.frame.width, height: 260)
//        teamPickerView.backgroundColor = UIColor.white
//        teamPickerView.layer.borderColor = UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
//        teamPickerView.layer.borderWidth = 1.0
//        teamPickerView.layer.cornerRadius = 7.0
//        teamPickerView.layer.masksToBounds = true
//        self.view.addSubview(teamPickerView)
//        self.hideKeyboardWhenTappedAround()
//        
//        countryPickerView.frame = CGRect(x: 0, y: self.view.frame.size.height - 180, width: self.view.frame.width, height: 180)
//        countryPickerView.backgroundColor = UIColor.white
//        countryPickerView.layer.borderColor = UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
//        countryPickerView.layer.borderWidth = 1.0
//        countryPickerView.layer.cornerRadius = 7.0
//        countryPickerView.layer.masksToBounds = true
//        self.view.addSubview(countryPickerView)
//        self.hideKeyboardWhenTappedAround()
        
//        languagePickerView.frame = CGRect(x: 0, y: self.viewLanguage.frame.size.height - 40, width: self.viewLanguage.frame.width, height: 0)
//        languagePickerView.backgroundColor = UIColor.white
//        languagePickerView.layer.borderColor = UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
//        languagePickerView.layer.borderWidth = 1.0
//        languagePickerView.layer.cornerRadius = 7.0
//        languagePickerView.layer.masksToBounds = true
//        
//        self.viewLanguage.addSubview(languagePickerView)
//        self.hideKeyboardWhenTappedAround()
//
        
        let userDef = UserDefaults()
        self.selectTeamLabel.text = userDef.object(forKey: "TEAM") as? String
        self.selectCountryLabel.text = userDef.object(forKey: "COUNTRY") as? String
        
        
        let countryData = UserDefaults.standard.object(forKey: "countryArray") as? NSData
        if let countryData = countryData {
            let countries = NSKeyedUnarchiver.unarchiveObject(with: countryData as Data)
            print(countries)
            self.countryArray = countries as! NSArray
            self.countryTableView.reloadData()
        }
        else{
            getCountryData()
        }

        let countryID = userDef.object(forKey: "countryId") as? String
        let teamData = UserDefaults.standard.object(forKey: "teamnameArray") as? NSData
        if let teamData = teamData {
            let teams = NSKeyedUnarchiver.unarchiveObject(with: teamData as Data)
            print(teams)
            self.teamnameListArray = teams as! NSArray

            let searchPredicate = NSPredicate(format: "country_id = %@",countryID!)
            let filtered = ( self.teamnameListArray).filtered(using: searchPredicate ) as NSArray
              self.teamnameArray = filtered 
            
            DispatchQueue.main.async(execute: { () -> Void in
                if self.teamnameArray.count > 0 {
                self.teamTableView.reloadData()
                }
            })
        }
        else{
            getTeamData()
        }
        addSearchBarOnTbaleHeader()


    }
    override func viewWillDisappear(_ animated: Bool) {
        if selected_teamID != "" {
        TeamUpdate()
    }
    }
    func filterTeam() {
        let userDef = UserDefaults()

        let countryID = userDef.object(forKey: "countryId") as? String
        let teamData = UserDefaults.standard.object(forKey: "teamnameArray") as? NSData
                  let searchPredicate = NSPredicate(format: "country_id = %@",countryID!)
            let filtered = ( self.teamnameListArray).filtered(using: searchPredicate ) as NSArray
        let newArr = filtered.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)])
        
        let sortedArr = (newArr as NSArray)
        print(sortedArr)
      
            self.teamnameArray = sortedArr
print(self.teamnameArray.count)
        if self.teamnameArray.count > 0 {
            self.teamTableView.reloadData()
        }else{
            self.teamTableView.isHidden = true
            let alertController = UIAlertController(title: nil, message: "No team available select another country ", preferredStyle: .alert)
            let dismis = UIAlertAction(title: "OK", style: .default, handler: { action in
                
            })
            alertController.addAction(dismis)
            self.present(alertController, animated: true, completion: nil)
            self.teamTableView.isHidden = true
            
        }

    }
    
    func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        if (countryTableView.isHidden == true ) {
            countryTableView.isHidden = false
            //SearchBar Frame
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    searchBar = UISearchBar(frame: CGRect(x: 15, y: self.viewCountry.frame.origin.y+60, width: self.viewCountry.frame.size.width, height: 44))
                    searchBar.barTintColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
                    searchBar.delegate = self
                    self.view.addSubview(searchBar)
                    searchBar.isHidden = false
                    //Tableview Frame
                    //self.countryTableView.contentInset = UIEdgeInsets.zero
                    countryTableView.frame = CGRect(x: 15, y:  self.viewCountry.frame.origin.y + 105, width: self.viewCountry.frame.size.width, height: 220)
                    countryTableView.layer.borderWidth = 2
                    countryTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor
                    self.view.addSubview(countryTableView)
                    
                    print("View===\(viewCountry.frame)")
                    print("TableView===\(countryTableView.frame)")
                    print("Serach Bar===\(searchBar.frame)")
                    
                case 1334:
                    print("iPhone 6/6S/7/8")
                    searchBar = UISearchBar(frame: CGRect(x: 15, y: self.viewCountry.frame.origin.y+60, width: self.viewCountry.frame.size.width, height: 44))
                    searchBar.barTintColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
                    searchBar.delegate = self
                    self.view.addSubview(searchBar)
                    searchBar.isHidden = false
                    //Tableview Frame
                    //self.countryTableView.contentInset = UIEdgeInsets.zero
                    countryTableView.frame = CGRect(x: 15, y:  self.viewCountry.frame.origin.y + 100, width: self.viewCountry.frame.size.width, height: 220)
                    countryTableView.layer.borderWidth = 2
                    countryTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor
                    self.view.addSubview(countryTableView)
                    
                    print("View===\(viewCountry.frame)")
                    print("TableView===\(countryTableView.frame)")
                    print("Serach Bar===\(searchBar.frame)")
                    
                case 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    searchBar = UISearchBar(frame: CGRect(x: 15, y: self.viewCountry.frame.origin.y+60, width: self.viewCountry.frame.size.width, height: 44))
                    searchBar.barTintColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
                    searchBar.delegate = self
                    self.view.addSubview(searchBar)
                    searchBar.isHidden = false
                    //Tableview Frame
                 //   self.countryTableView.contentInset = UIEdgeInsets.zero
                    countryTableView.frame = CGRect(x: 15, y:  self.viewCountry.frame.origin.y + 100, width: self.viewCountry.frame.size.width, height: 220)
                    countryTableView.layer.borderWidth = 2
                    countryTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor
                    self.view.addSubview(countryTableView)
                    
                    print("View===\(viewCountry.frame)")
                    print("TableView===\(countryTableView.frame)")
                    print("Serach Bar===\(searchBar.frame)")
                    
                case 2436:
                    print("iPhone X")
                    searchBar = UISearchBar(frame: CGRect(x: 15, y: self.viewCountry.frame.origin.y+80, width: self.viewCountry.frame.size.width, height: 44))
                    searchBar.barTintColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
                    searchBar.delegate = self
                    self.view.addSubview(searchBar)
                    searchBar.isHidden = false
                    //Tableview Frame
                 //   self.countryTableView.contentInset = UIEdgeInsets.zero
                    countryTableView.frame = CGRect(x: 15, y:  self.viewCountry.frame.origin.y + 120, width: self.viewCountry.frame.size.width, height: 220)
                    countryTableView.layer.borderWidth = 2
                    countryTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor
                    self.view.addSubview(countryTableView)
                    
                    print("View===\(viewCountry.frame)")
                    print("TableView===\(countryTableView.frame)")
                    print("Serach Bar===\(searchBar.frame)")
                    
                default:
                    print("unknown")
                }
            }
           
            searchBar.becomeFirstResponder()
            TeamsearchBar.resignFirstResponder
            teamTableView.isHidden = true
              languageTableView.isHidden = true
        }
        else {
            countryTableView.isHidden = true
            searchBar.isHidden = true
            searchBar.resignFirstResponder()
            
        }
    }
    func tappedOnTeam(_ gestureRecognizer: UIGestureRecognizer) {
        if (teamTableView.isHidden == true ) {
            teamTableView.isHidden = false
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    teamTableView.frame = CGRect(x: 15, y: self.viewTeam.frame.origin.y + 68, width: self.viewTeam.frame.size.width , height: 220)
                    teamTableView.layer.borderWidth = 2
                    teamTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor
                    
                    self.view.addSubview(teamTableView)

                case 1334:
                    print("iPhone 6/6S/7/8")
                    teamTableView.frame = CGRect(x: 15, y: self.viewTeam.frame.origin.y + 68, width: self.viewTeam.frame.size.width , height: 220)
                    teamTableView.layer.borderWidth = 2
                    teamTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor
                    
                    self.view.addSubview(teamTableView)

                case 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    teamTableView.frame = CGRect(x: 15, y: self.viewTeam.frame.origin.y + 68, width: self.viewTeam.frame.size.width , height: 220)
                    teamTableView.layer.borderWidth = 2
                    teamTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor
                    
                    self.view.addSubview(teamTableView)

                case 2436:
                    print("iPhone X")
                    teamTableView.frame = CGRect(x: 15, y: self.viewTeam.frame.origin.y + 90, width: self.viewTeam.frame.size.width , height: 220)
                    teamTableView.layer.borderWidth = 2
                    teamTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor
                    self.view.addSubview(teamTableView)

                default:
                    print("unknown")
                }
            }
            searchBar.resignFirstResponder()
            TeamsearchBar.becomeFirstResponder()
              countryTableView.isHidden = true
            searchBar.isHidden = true
              languageTableView.isHidden = true
            filterTeam()
        }
        else {
            teamTableView.isHidden = true
              TeamsearchBar.resignFirstResponder()
        }
    }
    func tappedOnLng(_ gestureRecognizer: UIGestureRecognizer) {
        if (languageTableView.isHidden == true ) {
            languageTableView.isHidden = false
            languageTableView.frame = CGRect(x: 15, y: self.viewLanguage.frame.origin.y + 108, width: self.viewLanguage.frame.size.width, height: 220)
            languageTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            //teamTableView.rowHeight = 60
            languageTableView.layer.borderWidth = 2
            languageTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor

            languageTableView.reloadData()
            self.view.addSubview(languageTableView)
             countryTableView.isHidden = true
            searchBar.isHidden = true
            teamTableView.isHidden = true
        }
        else {
            languageTableView.isHidden = true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty
        {
            search = String(search.characters.dropLast())
        }
        else
        {
            search=textField.text!+string
        }
        if textField == SelectCountryTxt{
            if search == ""{
                countryTableView .reloadData()
                
            }else{
                issearchActive = true
                print(" search text %@ ",searchBar.text! as NSString)
                let searchPredicate =  NSPredicate(format: "name contains[c] %@", search)
                let filtered = (self.countryArray).filtered(using: searchPredicate ) as NSArray
                print(filtered)
                countryFilterdArray = filtered
                countryTableView.reloadData()
            }
            
            
            
        }else if textField == selectTeamTxt{
            if (search == ""){
                teamTableView .reloadData()
            } else {
                isTeamsearchActive = true
                print(" search text %@ ",searchBar.text! as NSString)
                let searchPredicate =  NSPredicate(format: "name contains[c] %@", search)
                let filtered = (self.teamnameArray).filtered(using: searchPredicate ) as NSArray
                teamnameFilterArray = filtered
                print(filtered)
                teamTableView.reloadData()
            }
        }
        
        return true
    }
//    func countryTableTap(_ gestureRecognizer: UIGestureRecognizer) {
//        if (countryPickerView.isHidden == true) {
//            teamPickerView.isHidden = true
//            languagePickerView.isHidden = true
//            countryPickerView.isHidden = false
//        }
//    }
//    func teamTableTap(_ gestureRecognizer: UIGestureRecognizer) {
//        if (teamPickerView.isHidden == true) {
//            teamPickerView.isHidden = false
//            languagePickerView.isHidden = true
//            countryPickerView.isHidden = true
//        }
//    }
//    func languageTableTap(_ gestureRecognizer: UIGestureRecognizer) {
//         if (languagePickerView.isHidden == true) {
//            teamPickerView.isHidden = true
//            languagePickerView.isHidden = false
//            countryPickerView.isHidden = true
//
//        }
//        
//    }
    func TeamUpdate() {
     let device_id = UserDefaults.standard.value(forKey: "device_id")
      let Email_id = UserDefaults.standard.value(forKey: "EMAIL")
  let userid = UserDefaults.standard.object(forKey:"ID")
let url: URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=updateTeam&team_id=\(selected_teamID)&user_id=\(userid!)")!
        
        print(url)
Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
    if response.result.isSuccess {
        if let resJson = response.result.value as? NSDictionary {
            if let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int {
                if responseCode == 1 {
                    if let message = resJson.value(forKey: "RESPONSE") as? String {
                     print(message)
                    }
        }
    }
        }
    }
    if response.result.isFailure {
        print(response.result.error as Any)
//        let alert = UIAlertController(title:nil, message: "Check Internet Connection", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
//            
//        }))
//        self.present(alert, animated: true, completion: nil)
        
        self.activityIndicator.stopAnimating()
        
    }
}


    }

    func getCountryData() {
        
        let url = URL(string: "https://omsoftware.us/overachievers/football_api/service.php?action=getCountry")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String : AnyObject]
                    
                    if let root = json{
                        
                        if let responceCode = root["RESPONSECODE"] as? Int {
                            print("RESPONSE CODE>> \(responceCode )")
                        }
                        if let responseData = root["RESPONSE"] as? [AnyObject] {
                            self.countryArray = responseData as NSArray
                            let newArr = self.countryArray.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)])
                            
                            let sortedArr = (newArr as NSArray)
                            print(sortedArr)
                            self.countryArray = sortedArr
                            let placesData = NSKeyedArchiver.archivedData(withRootObject: self.countryArray)
                            UserDefaults.standard.set(placesData, forKey: "countryArray")
 
                            for arrData in responseData {
                                let countryName = arrData["name"] as? String
                                let countryID = arrData["country_id"] as? String
                                let flag = arrData["flag"] as? String
                                let iso = arrData["iso_code"] as? String
                                
                                let i = Country2DataClass(c_name: countryName!, c_id: countryID!, flag_url: flag!, iso_code: iso!)
                                self.country_data.append(i)
                                
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.countryTableView.reloadData()
                            })
                        }
                    }
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
    }
    func notificationApi() {
               let userid = UserDefaults.standard.object(forKey:"ID")
     //   let url = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=updatenotification&user_id=\(userid)&once=\(strfirsteleven)&goals=\(strgoal)&game_reminder_one_day=\(stronedaybefore)&game_reminder_fifteen_day=\(strfifremin)")!
        
        let url = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=updatenotification&user_id=\(userid as! String )&once=\(strfirsteleven)&goals=\(strgoal)&game_reminder_one_day=\(stronedaybefore)&game_reminder_fifteen_day=\(strfifremin)&other_events=\(strOtherEvents)&key_events=\(strKeyEvents)&ht-ft_score=\(strfirsteleven)")!

        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String : AnyObject]
                    
                    if let root = json{
                        
                        if let responceCode = root["RESPONSECODE"] as? Int {
                            print("RESPONSE CODE>> \(responceCode )")
                        }
                        if let responseData = root["RESPONSE"] as? String{
                            print(responseData)
                            
//                            for arrData in responseData {
//                                let team_name = arrData["name"] as? String
//                                let s_id = arrData["session_id"] as? String
//                                let logo = arrData["logo"] as? String
//                                let team_id = arrData["team_id"] as? String
//                                guard let twitter_data = arrData["twitter"] as? String else {
//                                    return
//                                }
//                                let venue = arrData["venue_id"] as? String
//                                let coach_id = arrData["coach_id"] as? String
//                                let chairman_id = arrData["chairman_id"] as? String
//                                let i = Team2ClassData(team_id: team_id!, team_name: team_name!, session_id: s_id!, logo: logo!, twitter_data: twitter_data, venue: venue!, coach_id: coach_id!, chairman_id: chairman_id!)
//                                self.team_data.append(i)
//                                
//                            }
//                            DispatchQueue.main.async(execute: { () -> Void in
//                                self.teamTableView.reloadData()
//                            })
                        }
                    }
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
    }
    

    
    func getTeamData() {
        
        let url = URL(string: "https://omsoftware.us/overachievers/football_api/service.php?action=getTeam")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String : AnyObject]
                    
                    if let root = json{
                        
                        if let responceCode = root["RESPONSECODE"] as? Int {
                            print("RESPONSE CODE>> \(responceCode )")
                        }
                        if let responseData = root["RESPONSE"] as? [AnyObject] {
                            
                            self.teamnameArray = responseData as NSArray
                            
                            let newArr = self.teamnameArray.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)])
                          
                        let sortedArr = (newArr as NSArray)
                            print(sortedArr)
                             self.teamnameArray = sortedArr
                            
                            let placesData = NSKeyedArchiver.archivedData(withRootObject: self.teamnameArray)
                            UserDefaults.standard.set(placesData, forKey: "teamnameArray")
                            
                            for arrData in responseData {
//                                let team_name = arrData["name"] as? String
//                                let s_id = arrData["session_id"] as? String
//                                let logo = arrData["logo"] as? String
//                                let team_id = arrData["team_id"] as? String
//                                guard let twitter_data = arrData["twitter"] as? String else {
//                                    return
//                                }
//                                let venue = arrData["venue_id"] as? String
//                                let coach_id = arrData["coach_id"] as? String
//                                let chairman_id = arrData["chairman_id"] as? String
                                let team_id = arrData["team_id"] as? NSString
                                if(team_id?.isEqual(to: "15359"))!{
                                    print("gotIT")
                                };
                                var team_name = "" as String
                                if (arrData["name"] as? String) != nil {
                                    team_name = arrData.value(forKey: "name") as! String                                }
                                
                                let s_id = arrData.value(forKey: "session_id") as! String
                                let logo = arrData.value(forKey: "logo") as! String
                                
                                guard let twitter_data = arrData["twitter"] as? String else {
                                    return
                                }
                                let venue = arrData.value(forKey: "venue_id") as! String
                                let coach_id = arrData.value(forKey: "coach_id") as! String
                                
                                let chairman_id = arrData.value(forKey: "chairman_id") as! String
                                let i = Team2ClassData(team_id: team_id! as String, team_name: team_name, session_id: s_id, logo: logo, twitter_data: twitter_data, venue: venue, coach_id: coach_id, chairman_id: chairman_id)
                                self.team_data.append(i)
                                
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.teamTableView.reloadData()
                            })
                        }
                    }
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
    }

    func checkSwitch() {
        let goalDef = UserDefaults.standard.bool(forKey: "GOAL")
        print(goalDef)
        let first11Def = UserDefaults.standard.bool(forKey: "First11")
        print(first11Def)
        let remin15Def = UserDefaults.standard.bool(forKey: "reminder15min")
        print(remin15Def)
        let remin1DayDef = UserDefaults.standard.bool(forKey: "reminder1Days")
        print(remin1DayDef)
        let KeyEvent = UserDefaults.standard.bool(forKey: "keyEvents")
        print(KeyEvent)
        let otherEvent = UserDefaults.standard.bool(forKey: "otherEvents")
        print(otherEvent)
        
        if (goalDef ) {
            switchGoals.setOn(true, animated: true)
            strfirsteleven = "1"
        } else {
            switchGoals.setOn(false, animated: true)
            strfirsteleven = "0"
        }
        if (KeyEvent ) {
            keyEvents.setOn(true, animated: true)
            strKeyEvents = "1"
        } else {
            keyEvents.setOn(false, animated: true)
            strKeyEvents = "0"
        }
        if (otherEvent ) {
            otherEvents.setOn(true, animated: true)
            strOtherEvents = "1"
        } else {
            otherEvents.setOn(false, animated: true)
            strOtherEvents = "0"
        }
        if first11Def {
            switchFirst11.setOn(true, animated: true)
            strfirsteleven = "1"
        } else {
            switchFirst11.setOn(false, animated: true)
             strfirsteleven = "0"
        }
        if remin15Def {
            switch15minRemin.setOn(true, animated: true)
            strfifremin = "1"
        } else {
            switch15minRemin.setOn(false, animated: true)
             strfifremin = "0"
        }
        if remin1DayDef {
            switch1DayRemin.setOn(true, animated: true)
            stronedaybefore = "1"
              strfifremin = "1"
        } else {
            switch1DayRemin.setOn(false, animated: true)
              stronedaybefore = "0"
              strfifremin = "0"
        }
    }
    func defaultSwitch() {
        if switchFirst11.isOn {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "First11")
        }
        else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "First11")
        }
        if switch1DayRemin.isOn {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "reminder1Days")
        }
        else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "reminder1Days")
        }
        if switch15minRemin.isOn {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "reminder15min")
        }
        else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "reminder15min")
        }
        if switchGoals.isOn {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "GOAL")
        }
        else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "GOAL")
        }
    }
    
    @IBAction func otherevents(_ sender: Any) {
        if otherEvents.isOn {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "otherEvents")
            strOtherEvents = "1"
          //  notificationApi()
        }
        else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "otherEvents")
            strOtherEvents = "0"
          //  notificationApi()
        }
    }
    
    @IBAction func KeyEvents(_ sender: Any) {
        if keyEvents.isOn {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "keyEvents")
            strKeyEvents = "1"
          //  notificationApi()
        }
        else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "keyEvents")
            strKeyEvents = "0"
           // notificationApi()
        }
    }
    
    @IBAction func BackAction(_ sender: Any) {
       
                self.navigationController?.popViewController(animated: true)
       // delegate?.comesFrom(setting: "setting")
        
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == teamTableView {
            if isTeamsearchActive == false {
            return teamnameArray.count
            }else{
                 return teamnameFilterArray.count
            }
        } else if tableView == countryTableView {
            if issearchActive == true{
                  return countryFilterdArray.count
            }else{
            return countryArray.count
            }
        } else {
            return langArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == teamTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as! pickerCell
                 if isTeamsearchActive == false {
            let teamData = self.teamnameArray[indexPath.row]
            let data = teamData as! NSDictionary
            let name = data.value(forKey: "name") as! String
              let logo = data.value(forKey: "logo") as! String
            DispatchQueue.main.async {
              cell.lbl.text = name
             
                   cell.img.loadImage(urlString:logo )
            }
            return cell
            }
                 else{
                    let teamData = self.teamnameFilterArray[indexPath.row]
                    let data = teamData as! NSDictionary
                    let name = data.value(forKey: "name") as! String
                    let logo = data.value(forKey: "logo") as! String
                    DispatchQueue.main.async {
                        cell.lbl.text = name
                        cell.img.loadImage(urlString:logo )
                    }
                           return cell
            }
        }
        else if tableView == countryTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as! pickerCell
            if issearchActive == false {
            let countryData = self.countryArray[indexPath.row]
            let data = countryData as! NSDictionary
            let name = data.value(forKey: "name") as! String
            cell.lbl.text = name
              let logo = data.value(forKey: "flag") as! String
            cell.img.loadImage(urlString: logo)
           // cell.lbl.text = country_data[indexPath.row].c_name
            //cell.img.loadImage(urlString: country_data[indexPath.row].flag_url)
            return cell
            }
            else{
                let countryData = self.countryFilterdArray[indexPath.row]
                let data = countryData as! NSDictionary
                let name = data.value(forKey: "name") as! String
                cell.lbl.text = name
                let logo = data.value(forKey: "flag") as! String
                cell.img.loadImage(urlString: logo)
                // cell.lbl.text = country_data[indexPath.row].c_name
                //cell.img.loadImage(urlString: country_data[indexPath.row].flag_url)
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = langArray[indexPath.row]
            //cell.img.loadImage(urlString: country_data[indexPath.row].flag_url)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == countryTableView {
            if issearchActive == false {
            tableView.cellForRow(at: indexPath)
            let countryData = self.countryArray[indexPath.row]
            let data = countryData as! NSDictionary
            let  selectedCountryName : String = data.value(forKey: "name") as! String
            
          selected_country_id = data.value(forKey: "country_id") as! String
            //let selectedCountryName : String = country_data[indexPath.row].c_name
            selectCountryLabel.text = selectedCountryName
           // selected_country_id = country_data[indexPath.row].c_id
            let userdefaults = UserDefaults.standard
            userdefaults.set(selectedCountryName, forKey: "COUNTRY")
             userdefaults.set(selected_country_id, forKey: "countryId")
            userdefaults.synchronize()
            countryTableView.isHidden = true
                searchBar.isHidden = true
            selectTeamTxt.isUserInteractionEnabled = true
            }else{
                tableView.cellForRow(at: indexPath)
                let countryData = self.countryFilterdArray[indexPath.row]
                let data = countryData as! NSDictionary
                let  selectedCountryName : String = data.value(forKey: "name") as! String
                
                selected_country_id = data.value(forKey: "country_id") as! String
                //let selectedCountryName : String = country_data[indexPath.row].c_name
                selectCountryLabel.text = selectedCountryName
                // selected_country_id = country_data[indexPath.row].c_id
                let userdefaults = UserDefaults.standard
                userdefaults.set(selectedCountryName, forKey: "COUNTRY")
                userdefaults.set(selected_country_id, forKey: "countryId")
                userdefaults.synchronize()
                countryTableView.isHidden = true
                searchBar.isHidden = true
                selectTeamTxt.isUserInteractionEnabled = true
                searchBar.resignFirstResponder()
            }
        }
        else if tableView == teamTableView {
            if isTeamsearchActive == false {
            tableView.cellForRow(at: indexPath)
            let teamData = self.teamnameArray[indexPath.row]
            let data = teamData as! NSDictionary
            let selecteTeamName:String = data.value(forKey: "name") as! String
             selected_teamID = data.value(forKey: "team_id") as! String
            
           let imageURL: String = data.value(forKey: "logo") as! String
            
            
            //let selecteTeamName:String = team_data[indexPath.row].team_name
            selectTeamLabel.text = selecteTeamName
           // selected_teamID = team_data[indexPath.row].team_id
          //  let imageURL: String = team_data[indexPath.row].logo
            let userdefaults = UserDefaults.standard
            userdefaults.set(selecteTeamName, forKey: "TEAM")
            userdefaults.set(imageURL, forKey: "TEAM_LOGO")
            userdefaults.set(selected_teamID, forKey: "TEAM_ID")
                   UserDefaults.standard.set("setting", forKey: "setting")
            userdefaults.synchronize()
            teamTableView.isHidden = true
                selectTeamTxt.resignFirstResponder()
            }
            else{
                tableView.cellForRow(at: indexPath)
                let teamData = self.teamnameFilterArray[indexPath.row]
                let data = teamData as! NSDictionary
                let selecteTeamName:String = data.value(forKey: "name") as! String
                selected_teamID = data.value(forKey: "team_id") as! String
                
                let imageURL: String = data.value(forKey: "logo") as! String
                //let selecteTeamName:String = team_data[indexPath.row].team_name
                selectTeamLabel.text = selecteTeamName
                // selected_teamID = team_data[indexPath.row].team_id
                //  let imageURL: String = team_data[indexPath.row].logo
                let userdefaults = UserDefaults.standard
                userdefaults.set(selecteTeamName, forKey: "TEAM")
                userdefaults.set(imageURL, forKey: "TEAM_LOGO")
                userdefaults.set(selected_teamID, forKey: "TEAM_ID")
                   UserDefaults.standard.set("setting", forKey: "setting")
                userdefaults.synchronize()
                teamTableView.isHidden = true
                 TeamsearchBar.resignFirstResponder()
                selectTeamTxt.resignFirstResponder()
            }
        }
        else {
            selectLanguageLabel.text = langArray[indexPath.row]
             languageTableView.isHidden = true
        }
    }
    
}
class Country2DataClass {
    
    var c_name: String = ""
    var c_id: String = ""
    var flag_url: String = ""
    var iso_code: String = ""
    
    init(c_name: String,c_id: String,flag_url: String,iso_code: String){
        
        self.c_id = c_id
        self.c_name = c_name
        self.flag_url = flag_url
        self.iso_code = iso_code
    }
}
class Team2ClassData {
    
    var team_id: String = ""
    var team_name: String = ""
    var session_id: String = ""
    var logo: String = ""
    var twitter_data: String = ""
    var venue: String = ""
    var coach_id: String = ""
    var chairman_id: String = ""
    
    init(team_id: String,team_name: String,session_id: String,logo: String,twitter_data: String,venue: String,coach_id: String,chairman_id: String){
        
        self.team_id = team_id
        self.team_name = team_name
        self.session_id = session_id
        self.logo = logo
        self.twitter_data = twitter_data
        self.venue = venue
        self.coach_id = coach_id
        self.chairman_id = chairman_id
    }
}
