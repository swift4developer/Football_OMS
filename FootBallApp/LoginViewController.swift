//
//  LoginViewController.swift
//  FootBallApp
//
//  Created by Praveen Khare on 24/03/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate,UITextFieldDelegate, GIDSignInUIDelegate,UISearchBarDelegate, UISearchControllerDelegate {
    var search:String=""
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var countrySearchBar: UISearchBar!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var teamView: UIView!
    @IBOutlet var countryView: UIView!
    var countryArray = NSArray ()
    var  teamnameArray = NSArray ()
    var  teamnameListArray = NSArray ()
    var device_id = ""
    var strfirsteleven = "1"
    var strgoal = "1"
    var stronedaybefore = "1"
    var strfifremin = "1"
    var strKeyEvents = "1"
    var strOtherEvents = "1"
    lazy var searchBar:UISearchBar = UISearchBar()
    var TeamsearchBar = UISearchBar()
     var Countryfiltered: [String]?
    var openKeyboard = false
    
    @IBOutlet weak var titleBarLbl: UILabel!
    
    @IBOutlet weak var teamTxt: UITextField!
    var isTeamsearchActive = false
  var  teamnameFilterArray = NSArray ()
 var   issearchActive = false
 var   countryFilterdArray = NSArray ()
  
    @IBOutlet weak var countryTxt: UITextField!
    
   
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        let user_email = user.profile.email!
        print("USER GMAIL ID>>> \(user_email)")
        let userdefaults = UserDefaults.standard
        userdefaults.set(user_email, forKey: "EMAIL")
        self.emailTextField.text = user_email
    }
    
    @IBAction func googleAction(_ sender: Any) {
        //    GIDSignIn.sharedInstance().signIn()
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
    
    //    var teamPickerView = UIPickerView()
    //    var countryPickerView = UIPickerView()
    
    @IBAction func instaAction(_ sender: Any) {
  
    //    @IBAction func googleLoginAction(_ sender: UIButton) {
    //    //    GIDSignIn.sharedInstance().signIn()
            guard
    
                //let url = URL(string: "https://plus.google.com/u/0/communities/111377830439408117391" )
         let url = URL(string: "https://www.instagram.com/footballcalendar_/" )
                
        else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url )
            } else {
                UIApplication.shared.openURL(url)
            }
  
        }
    
    @IBAction func fbAction(_ sender: Any) {
        //        activityIndicator.startAnimating()
        //        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        //            fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
        //                if (error == nil){
        //                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
        //                    if(fbloginresult.grantedPermissions.contains("email"))
        //                    {
        //                        self.getFBUserData()
        //                    }
        //                }
        //            }
        guard
            
            let url = URL(string: "https://www.facebook.com/footballcalendar" )
            else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url )
        } else {
            UIApplication.shared.openURL(url)
        }
        
        
        
        
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result!)
                    let fb_data = result as? NSDictionary
                    if let email_fb = fb_data?["email"] as? String {
                        self.activityIndicator.stopAnimating()
                        print("USER EMAIL ID >>> \(email_fb)")
                        let userdefaults = UserDefaults.standard
                        userdefaults.set(email_fb, forKey: "EMAIL")
                        self.emailTextField.text = email_fb
                    }
                }
            })
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var selectCountryLabel: UILabel!
    @IBOutlet weak var selectTeamLabel: UILabel!
    
    var selected_country_id: String = ""
    var selected_team_id: String  = ""
    
    
    var country_data = [CountryDataClass]()
    var team_data = [TeamClassData]()
    
    var teamTableView = UITableView()
    var countryTableView = UITableView()
    
    @IBAction func btnLogIn(_ sender: UIButton) {
        
        //        let rootVC:TabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "tab_bar") as! TabBarViewController
        //        let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "root") as! UINavigationController
        //        nvc.viewControllers = [rootVC]
        //        UIApplication.shared.keyWindow?.rootViewController = nvc
        
        if (emailTextField.text == "") {
            let alertBox = UIAlertController(title: "Error !!!!", message: "Please enter email ID", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "Ok, Try Again", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            
        }
        else if selected_country_id == "" {
            let alertBox = UIAlertController(title: "Error !!!!", message: "Please select country", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "Ok, Try Again", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            
        }
        else if selected_team_id == "" {
            let alertBox = UIAlertController(title: "Error !!!!", message: "Please select team", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "Ok, Try Again", style: .default, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
            
        }
        else {
            postLoginData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      let titlename = NSLocalizedString("Registration", comment: "")
        self.titleBarLbl.text = titlename
        
//        self.countryTxt.delegate = self
//         self.teamTxt.delegate = self
       self.emailTextField.delegate = self
//    removeBorder(textField: self.countryTxt)
//    removeBorder(textField: self.teamTxt)

        self.countryTableView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0);
        addSearchBarOnTableHeader()
        var error : NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        
        activityIndicator.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
        if error != nil {
            print(error as Any)
            return
        }
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
            activityIndicator.stopAnimating()
        }
        
        // Present a view that prompts the user to sign in with Google
        func sign(_ signIn: GIDSignIn!,
                  present viewController: UIViewController!) {
            activityIndicator.stopAnimating()
            self.present(viewController, animated: true, completion: nil)
        }
        
        // Dismiss the "Sign in with Google" view
        func sign(_ signIn: GIDSignIn!,
                  dismiss viewController: UIViewController!) {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                if textField == countryTxt {
                    textField.resignFirstResponder()
                    countryTableView.isHidden = true
                      searchBar.isHidden = true
                }else if textField == teamTxt {
                    textField.resignFirstResponder()
                    teamTableView.isHidden = true
        }
                else{
                    textField.resignFirstResponder()

        }
        
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
        if textField == countryTxt{
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
           
            
            
        }else if textField == teamTxt{
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
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
            //countryTxt.becomeFirstResponder()
            self.view.frame.origin.y -= 100
        }
        
        return true
   
    }
   
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if ( openKeyboard == false ){
                 self.view.frame.origin.y = 0
                UIApplication.shared.statusBarView?.backgroundColor = .clear
            }

            else if openKeyboard == true{
                UIApplication.shared.statusBarView?.backgroundColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)

               self.view.frame.origin.y -= 130
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                UIApplication.shared.statusBarView?.backgroundColor = .clear
                self.view.frame.origin.y = 0
            }
        }
    }
  
        
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            openKeyboard = false
                searchBar.isHidden = true
            self.countryTableView.isHidden = true
             self.teamTableView.isHidden = true
            
        }
    }
//    func keyboardWillHide(sender: NSNotification) {
//        self.view.frame.origin.y = 0
//         self.scrollView.frame.origin.y = 0
//        self.view.gestureRecognizers = nil
//
//    }

    override func viewWillAppear(_ animated: Bool) {
//        getCountryData()
//        getTeamData()
        let backgroundImage = UIImage(named: "top_tab_Bar")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.stretch)
        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        self.navigationController?.navigationBar.isHidden = false
    
        teamTableView.isHidden = true
        countryTableView.isHidden = true
        
        teamTableView.delegate = self
        teamTableView.dataSource = self
        
        countryTableView.delegate = self
        countryTableView.dataSource = self
        if selectCountryLabel.text == "Select Country"{
            selectTeamLabel.isUserInteractionEnabled = false
        }else{
             selectTeamLabel.isUserInteractionEnabled = true
            
        }
        let tappedOnTeam = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tappedOnTeam(_:)))
        selectTeamLabel.addGestureRecognizer(tappedOnTeam)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTap(_:)))
        selectCountryLabel.addGestureRecognizer(gestureRecognizer)
        
       // self.hideKeyboardWhenTappedAround()
        
        //        teamPickerView.frame = CGRect(x: 0, y: self.view.frame.size.height - 320, width: self.view.frame.width, height: 320)
        //        teamPickerView.backgroundColor = UIColor.white
        //        teamPickerView.layer.borderColor = UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
        //        teamPickerView.layer.borderWidth = 1.0
        //        teamPickerView.layer.cornerRadius = 7.0
        //        teamPickerView.layer.masksToBounds = true
        //        self.view.addSubview(teamPickerView)
        //
        //        countryPickerView.frame = CGRect(x: 0, y: self.view.frame.size.height - 320, width: self.view.frame.width, height: 320)
        //        countryPickerView.backgroundColor = UIColor.white
        //        countryPickerView.layer.borderColor = UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
        //        countryPickerView.layer.borderWidth = 1.0
        //        countryPickerView.layer.cornerRadius = 7.0
        //        countryPickerView.layer.masksToBounds = true
        //        self.view.addSubview(countryPickerView)
        

        teamTableView.register(UINib(nibName: "pickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
        countryTableView.register(UINib(nibName: "pickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
        let countryData = UserDefaults.standard.object(forKey: "countryArray") as? NSData
        if let countryData = countryData {
            let countries = NSKeyedUnarchiver.unarchiveObject(with: countryData as Data)
            print(countries)
            self.countryArray = countries as! NSArray
            self.countryTableView.reloadData()
        }
        else{
           // getCountryData()
            getCountryList()
            
        }
        
        let teamData = UserDefaults.standard.object(forKey: "teamnameArray") as? NSData
        if let teamData = teamData {
            let teams = NSKeyedUnarchiver.unarchiveObject(with: teamData as Data)
            print(teams)
            self.teamnameListArray = teams as! NSArray
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.teamTableView.reloadData()
            })
        }
        else{
            getTeamList()
            //getTeamData()
        }
        
    }
    override func viewDidLayoutSubviews() {
         // addSearchBarOnTableHeader()
    }
    func addSearchBarOnTableHeader () {
        
        TeamsearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        TeamsearchBar.barTintColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
        TeamsearchBar.delegate = self
        self.teamTableView.tableHeaderView = TeamsearchBar
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar != TeamsearchBar{
            if (searchBar.text?.isEmpty)!{
                  self.countryTableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
                issearchActive = false
                countryTableView .reloadData()
            } else {
                issearchActive = true
                    self.countryTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    // Do the search...view
    }
    func presentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }

    func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        if emailTextField.text! == "" {
            let alertMsg = NSLocalizedString("Please Enter E-mail", comment: "")
            let otherAlert = UIAlertController(title: nil, message:alertMsg , preferredStyle: UIAlertControllerStyle.alert)
            
           
            let dismiss = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            
            // relate actions to controllers
         
            otherAlert.addAction(dismiss)
            
            present(otherAlert, animated: true, completion: nil)
        }
        else{
        if (countryTableView.isHidden == true ) {
            countryTableView.isHidden = false
            searchBar = UISearchBar(frame: CGRect(x: 16, y: self.countryView.frame.origin.y + 90, width: self.countryView.frame.size.width, height: 40))
            searchBar.barTintColor = UIColor(red:0.55, green:0.77, blue:0.30, alpha:1.0)
            searchBar.delegate = self
            self.view.addSubview(searchBar)
            searchBar.isHidden = false;
            countryTableView.frame = CGRect(x: 16, y: self.countryView.frame.origin.y + 130 , width: self.countryView.frame.size.width, height: 200)
            countryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
            //countryTableView.rowHeight = 60
            countryTableView.layer.borderWidth = 2
            countryTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor
            
         
            self.view.addSubview(countryTableView)
           // countryTxt.becomeFirstResponder()
            openKeyboard = true
            emailTextField.resignFirstResponder()
            searchBar.becomeFirstResponder()
               teamTableView.isHidden = true
        }
        else {
            countryTableView.isHidden = true
               searchBar.isHidden = true
            searchBar.resignFirstResponder()
            
            
        }
        }
    }
    func tappedOnTeam(_ gestureRecognizer: UIGestureRecognizer) {
        if emailTextField.text! == ""{
        let alertMsg = NSLocalizedString("Please Enter E-mail", comment: "")
        let otherAlert = UIAlertController(title: nil, message:alertMsg , preferredStyle: UIAlertControllerStyle.alert)
        let dismiss = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        
        // relate actions to controllers
        
        otherAlert.addAction(dismiss)
        
        present(otherAlert, animated: true, completion: nil)
        }else{
        if (teamTableView.isHidden == true ) {
            teamTableView.frame = CGRect(x: 16, y: self.teamView.frame.origin.y + 90, width: self.teamView.frame.size.width , height: 220)
            teamTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
            //teamTableView.rowHeight = 60
            teamTableView.layer.borderWidth = 2
            teamTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor

            self.view.addSubview(teamTableView)
            
            print("Search==\(searchBar.frame)")
            print("Team View==\(teamView.frame)")
            print(teamTableView.frame)
            
            countryTableView.isHidden = true
            searchBar.isHidden = true
            openKeyboard = true

              searchBar.resignFirstResponder()
              TeamsearchBar.becomeFirstResponder()
            filterTeam()
            teamTableView.isHidden = false

        }
        else {
            teamTableView.isHidden = true
        }
        }
    }
    func notificationApi() {
        let userId = UserDefaults.standard.object(forKey:"ID")
        let userid = String(describing: userId)
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "First11")
            userDefaults.set(true, forKey: "reminder1Days")
            userDefaults.set(true, forKey: "reminder15min")
             userDefaults.set(true, forKey: "GOAL")
        userDefaults.set(true, forKey: "keyEvents")
        userDefaults.set(true, forKey: "otherEvents")
        
   
     
     
       // let url = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=updatenotification&user_id=\(userid)&once=\(strfirsteleven)&goals=\(strgoal)&game_reminder_one_day=\(stronedaybefore)&game_reminder_fifteen_day=\(strfifremin)")!
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
    func getCountryData() {
          self.activityIndicator.startAnimating()
        let url = URL(string: "https://omsoftware.us/overachievers/football_api/service.php?action=getCountry")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                let alertController = UIAlertController(title: nil, message: "Network Error", preferredStyle: .alert)
                let dismis = UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                })
                alertController.addAction(dismis)
                self.present(alertController, animated: true, completion: nil)
                

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
                                
                                let i = CountryDataClass(c_name: countryName!, c_id: countryID!, flag_url: flag!, iso_code: iso!)
                                self.country_data.append(i)
                                
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.countryTableView.reloadData()
                            })
                        }
                    }
                }
                catch let error as NSError{
                                                            let alertController = UIAlertController(title: nil, message: "Network Error", preferredStyle: .alert)
                                                            let dismis = UIAlertAction(title: "OK", style: .default, handler: { action in
                                                             
                                                            })
                                                            alertController.addAction(dismis)
                                                            self.present(alertController, animated: true, completion: nil)
                    
                    print(error)
                }
            }
        }).resume()
        
    }
    func getCountryList() {
        self.activityIndicator.startAnimating()
        let parameters = [""]
        
        //create the url with URL
        let url = URL(string: "https://omsoftware.us/overachievers/football_api/service.php?action=getCountry")! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 3600
        //create dataTask using the session object to send data to the server
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                self.activityIndicator.stopAnimating()
                let alertController = UIAlertController(title: nil, message: "Network Error", preferredStyle: .alert)
                let dismis = UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                })
                alertController.addAction(dismis)
                self.present(alertController, animated: true, completion: nil)

                
                
                
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : AnyObject] {
                    print(json)
                    // handle json..
                    let root = json
                    if root  != nil {
                        
                        if let responceCode = root["RESPONSECODE"] as? Int {
                            print("RESPONSE CODE>> \(responceCode )")
                        }
                        if let responseData = root["RESPONSE"] as? [AnyObject] {
                            self.countryArray = responseData as NSArray
//                            let data = root["RESPONSE"] as! Data
//                            let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue)


                            let newArr = self.countryArray.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)])
//                            let alert = UIAlertController(title: "Alert", message: datastring! as String, preferredStyle: UIAlertControllerStyle.alert)
//                            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
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
                                
                                let i = CountryDataClass(c_name: countryName!, c_id: countryID!, flag_url: flag!, iso_code: iso!)
                                self.country_data.append(i)
                                
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.countryTableView.reloadData()
                                //self.activityIndicator.stopAnimating()
                            })
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        })
            .resume()
    }

    func getTeamList() {
        self.activityIndicator.startAnimating()
        let parameters = [""]
        
        //create the url with URL
        let url = URL(string: "https://omsoftware.us/overachievers/football_api/service.php?action=getTeam")! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 3600
        //create dataTask using the session object to send data to the server
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                self.activityIndicator.stopAnimating()
                let alertController = UIAlertController(title: nil, message: "Network Error", preferredStyle: .alert)
                let dismis = UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                })
                alertController.addAction(dismis)
                self.present(alertController, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : AnyObject] {
                    print(json)
                    // handle json..
                    let root = json
                    if root  != nil {
                        
                        if let responceCode = root["RESPONSECODE"] as? Int {
                            print("RESPONSE CODE>> \(responceCode )")
                        }
                        if let responseData = root["RESPONSE"] as? [AnyObject] {
                            
                            self.teamnameArray = responseData as NSArray
                            
                            let newArr = self.teamnameArray.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)])
                            
                            let sortedArr = (newArr as NSArray)
                            print(sortedArr)
                            self.teamnameListArray = sortedArr
                            
                            let placesData = NSKeyedArchiver.archivedData(withRootObject: self.teamnameArray)
                            UserDefaults.standard.set(placesData, forKey: "teamnameArray")
                            
                            
                            
                            
                            for arrData in responseData {
                                
                                let team_id = arrData["team_id"] as? NSString
                                
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
                                let i = TeamClassData(team_id: team_id as! String, team_name: team_name, session_id: s_id, logo: logo, twitter_data: twitter_data, venue: venue, coach_id: coach_id, chairman_id: chairman_id)
                                self.team_data.append(i)
                                
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.teamTableView.reloadData()
                                self.activityIndicator.stopAnimating()
                                
                            })
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        .resume()
    }
    
    
    
    func getTeamData() {
        self.activityIndicator.startAnimating()
        let url = URL(string: "https://omsoftware.us/overachievers/football_api/service.php?action=getTeam")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            if(error != nil){
                 self.activityIndicator.stopAnimating()
                let alertController = UIAlertController(title: nil, message: "Network Error", preferredStyle: .alert)
                let dismis = UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                })
                alertController.addAction(dismis)
                self.present(alertController, animated: true, completion: nil)
                
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
                            self.teamnameListArray = sortedArr
                            
                            let placesData = NSKeyedArchiver.archivedData(withRootObject: self.teamnameArray)
                            UserDefaults.standard.set(placesData, forKey: "teamnameArray")
                            

                            
                            
                            for arrData in responseData {
                                
                                let team_id = arrData["team_id"] as? NSString
                                
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
                                let i = TeamClassData(team_id: team_id as! String, team_name: team_name, session_id: s_id, logo: logo, twitter_data: twitter_data, venue: venue, coach_id: coach_id, chairman_id: chairman_id)
                                self.team_data.append(i)
                                
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.teamTableView.reloadData()
                                 self.activityIndicator.stopAnimating()
                              
                            })
                        }
                    }
                }
                catch let error as NSError{
                    let alertController = UIAlertController(title: nil, message: "Network Error", preferredStyle: .alert)
                    let dismis = UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                    })
                    alertController.addAction(dismis)
                    self.present(alertController, animated: true, completion: nil)

                    print(error)
                }
            }
        }).resume()
        
    }
    
    func postLoginData() {
        
        let Email_id: String = emailTextField.text!
        
//        if !Email_id.isValidEmail {
//            let alert = UIAlertController(title: "Error !!", message: "Enter valid email ID", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        
       // } else {
//            var deviceID = UserDefaults.standard.string(forKey: "deviceTokenString")
//                  if deviceID == nil {
//                  deviceID = UserDefaults.standard.string(forKey: "device_id")
            
                    #if (arch(i386) || arch(x86_64)) && os(iOS)
                        let DEVICE_IS_SIMULATOR = true
                        device_id = ""
                        
                    #else
                        let DEVICE_IS_SIMULATOR = false
                        device_id  =  UserDefaults.standard.value(forKey:"deviceTokenString" ) as! String
                        UserDefaults.standard.set(device_id, forKey: "device_id")
                        
                    #endif

                    
                    
        //    }
            
            let userdefaults1 = UserDefaults.standard
               userdefaults1.set(Email_id, forKey: "EMAIL")
            
            
            let url: URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=SignUp&email=\(Email_id.trim())&country_id=\(selected_country_id)&password=\("1234567")&team_id=\(selected_team_id)&status=\("2")&device_id=\(device_id)&device_type=\("IOS")")!
            Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if response.result.isSuccess {
                    if let resJson = response.result.value as? NSDictionary {
                        if let responseCode = resJson.value(forKey: "RESPONSECODE") as? Int {
                            if responseCode == 0 {
                                if let message1 = resJson.value(forKey: "RESPONSE") as? NSDictionary{
                                    if  let messages = message1.value(forKey: "error") as? String {
                                        
                                        
                                        if messages == " Email Id  already exists"  {
                                            let registered_ID = (resJson.value(forKey: "RESPONSE") as! NSDictionary).value(forKey: "ID") as! String
                                            let userdefaults = UserDefaults.standard
                                            userdefaults.set(registered_ID, forKey: "ID")
                                            self.checkLanguage ()
                                             UserDefaults.standard.set(true, forKey: "launchedBefore")
                                            self.notificationApi()
                                            self.gotoNextVC()
                                            
                                        }
                                    }
                                    
                                }
                                if let message = resJson.value(forKey: "RESPONSE") as? String {
                                    let alert = UIAlertController(title: "Error !!", message: message, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok, Try Again", style: .default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            else if responseCode == 1 {
                                if let registered_ID = resJson.value(forKey: "ID")  {
                                    let userdefaults = UserDefaults.standard
                                    userdefaults.set(registered_ID, forKey: "ID")
                                    self.checkLanguage ()
                                    userdefaults.set(Email_id, forKey: "EMAIL")
                                    print("ID----\(userdefaults.integer(forKey: "ID"))")
                                }
                                if let message = resJson.value(forKey: "RESPONSE") as? String {
                                    let alert = UIAlertController(title: "Success ", message: "Thank you for registering", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                                        self.notificationApi()
                                        self.gotoNextVC()
                                         UserDefaults.standard.set(true, forKey: "launchedBefore")
                                        
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
                                else if let message1 = resJson.value(forKey: "RESPONSE") as? String{
                                    print(message1)
                                }
                                
                            }
                        }
                        
                    }
                }
                if response.result.isFailure {
                    print(response.result.error as Any)
                    let alert = UIAlertController(title:nil, message: "Check Internet Connection", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.activityIndicator.stopAnimating()

                    
                }
            }
            
       }
//    }
  func checkLanguage ()  {
    let preferredLanguage = Bundle.main.preferredLocalizations.first
    if preferredLanguage == "en" {
    print("this is English")
    } else if preferredLanguage == "es" {
    print("this is spanish")
    }
    else if preferredLanguage == "tr" {
    print("this is Turkish")
    }
    else if preferredLanguage == "it" {
    print("this is Italian")
    }
    else if preferredLanguage == "nl" {
    print("this is Dutch")
    } else if preferredLanguage == "de" {
    print("this is German")
    }
    else {
    print("this is English")
    }
    let prefDefault = UserDefaults.standard
    let userID = prefDefault.object(forKey:"ID") as? String
    if userID != nil  {
    self.shareLangauge(userId: userID! , languageName: preferredLanguage!)
    }
    
    
    }
    func shareLangauge(userId : String , languageName : String)  {
        let url = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=updateLanguage&user_id=\(userId)&language=\(languageName)")
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
                            print(responseData)
                        }
                    }
                }catch let error as NSError{
                    let alert = UIAlertController(title: nil, message:"Network Error", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    print(error)
                }
            }
        }).resume()
    }
    func gotoNextVC() {
        
        if device_id == ""{
            let alert = UIAlertController(title:nil, message: "Your device doesn't allow notification please go to setting and switch on the notification", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                let tabBarRoot = self.storyboard?.instantiateViewController(withIdentifier: "tab_bar") as! TabBarViewController
                self.present(tabBarRoot, animated: true, completion: nil)
  
            }))
            self.present(alert, animated: true, completion: nil)
  
        }
        else{
        
        let tabBarRoot = self.storyboard?.instantiateViewController(withIdentifier: "tab_bar") as! TabBarViewController
        self.present(tabBarRoot, animated: true, completion: nil)
        }
    }
    
}
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == teamTableView {
            if isTeamsearchActive == false {
            return teamnameArray.count
            }else {
                  return teamnameFilterArray.count
            }
        } else {
            if issearchActive == false {
            return countryArray.count
        }
            else {
                  return countryFilterdArray.count
            }
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
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as! pickerCell
            if issearchActive == false {
            let countryData = self.countryArray[indexPath.row]
            let data = countryData as! NSDictionary
            let name = data.value(forKey: "name") as! String
            cell.lbl.text = name
            let logo = data.value(forKey: "flag") as! String
            cell.img.loadImage(urlString: logo)

            
            return cell
            }
            else {
                let countryData = self.countryFilterdArray[indexPath.row]
                let data = countryData as! NSDictionary
                let name = data.value(forKey: "name") as! String
                cell.lbl.text = name
                let logo = data.value(forKey: "flag") as! String
                cell.img.loadImage(urlString: logo)
                return cell
            }
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == countryTableView {
            if issearchActive == false {
            tableView.cellForRow(at: indexPath)
            let countryData = self.countryArray[indexPath.row]
            let data = countryData as! NSDictionary
            let  selectedCountryName : String = data.value(forKey: "name") as! String
            let countryId = data.value(forKey: "country_id") as! String
            selected_country_id = data.value(forKey: "country_id") as! String
            //let selectedCountryName : String = country_data[indexPath.row].c_name
            selectCountryLabel.text = selectedCountryName
            // selected_country_id = country_data[indexPath.row].c_id
            let userdefaults = UserDefaults.standard
            userdefaults.set(selectedCountryName, forKey: "COUNTRY")
             userdefaults.set(countryId, forKey: "countryId")
            userdefaults.synchronize()
            countryTableView.isHidden = true
                searchBar.isHidden = true
              selectTeamLabel.isUserInteractionEnabled = true
                openKeyboard = false
                searchBar.resignFirstResponder()
            }
            else {
                tableView.cellForRow(at: indexPath)
                let countryData = self.countryFilterdArray[indexPath.row]
                let data = countryData as! NSDictionary
                let  selectedCountryName : String = data.value(forKey: "name") as! String
                let countryId = data.value(forKey: "country_id") as! String
                selected_country_id = data.value(forKey: "country_id") as! String
                //let selectedCountryName : String = country_data[indexPath.row].c_name
                selectCountryLabel.text = selectedCountryName
                // selected_country_id = country_data[indexPath.row].c_id
                let userdefaults = UserDefaults.standard
                userdefaults.set(selectedCountryName, forKey: "COUNTRY")
                userdefaults.set(countryId, forKey: "countryId")
                userdefaults.synchronize()
                countryTableView.isHidden = true
                searchBar.isHidden = true
                selectTeamLabel.isUserInteractionEnabled = true
                openKeyboard = false
                searchBar.resignFirstResponder()
            }
        }
        else {
            if isTeamsearchActive == false {
            tableView.cellForRow(at: indexPath)
            let teamData = self.teamnameArray[indexPath.row]
            let data = teamData as! NSDictionary
            let selecteTeamName:String = data.value(forKey: "name") as! String
            selectTeamLabel.text = selecteTeamName
             selected_team_id = data.value(forKey: "team_id") as! String
       let imageURL: String = data.value(forKey: "logo") as! String
            let userdefaults = UserDefaults.standard
            userdefaults.set(selecteTeamName, forKey: "TEAM")
            userdefaults.set(imageURL, forKey: "TEAM_LOGO")
            userdefaults.set(selected_team_id, forKey: "TEAM_ID")
            userdefaults.synchronize()
            teamTableView.isHidden = true
              //  teamTxt.resignFirstResponder()
                openKeyboard = false
                TeamsearchBar.resignFirstResponder()

        }
            else {
                tableView.cellForRow(at: indexPath)
                let teamData = self.teamnameFilterArray[indexPath.row]
                let data = teamData as! NSDictionary
                let selecteTeamName:String = data.value(forKey: "name") as! String
                selectTeamLabel.text = selecteTeamName
                selected_team_id = data.value(forKey: "team_id") as! String
                let imageURL: String = data.value(forKey: "logo") as! String
                let userdefaults = UserDefaults.standard
                userdefaults.set(selecteTeamName, forKey: "TEAM")
                userdefaults.set(imageURL, forKey: "TEAM_LOGO")
                userdefaults.set(selected_team_id, forKey: "TEAM_ID")
                userdefaults.synchronize()
                teamTableView.isHidden = true
                openKeyboard = false
                TeamsearchBar.resignFirstResponder()
              //  teamTxt.resignFirstResponder()
            }
        }
    }
   
    func filterTeam(){
        let userDef = UserDefaults()
        let countryID = userDef.object(forKey: "countryId")
        let searchPredicate = NSPredicate(format: "country_id = %@",countryID as! CVarArg)
             let filtered = ( self.teamnameListArray).filtered(using: searchPredicate ) as NSArray
         if filtered.count > 0{

        self.teamnameArray = filtered
        print(self.teamnameArray.count)
              if self.teamnameArray.count > 0 {
             self.teamTableView.reloadData()
        }
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

}
/*
 extension LoginViewController : UIPickerViewDelegate, UIPickerViewDataSource {
 
 func numberOfComponents(in pickerView: UIPickerView) -> Int {
 return 1
 }
 func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
 if pickerView == teamPickerView {
 return team_data.count
 } else {
 return country_data.count
 }
 
 }
 func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
 return 60
 }
 /*
 func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
 if pickerView == teamPickerView {
 return team_data[row].team_name
 } else {
 return country_data[row].c_name
 }
 }
 */
 func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
 
 if pickerView == teamPickerView {
 let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
 let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
 var rowString = String()
 
 myImageView.loadImage(urlString: team_data[row].logo)
 rowString = team_data[row].team_name
 
 let myLabel = UILabel(frame: CGRect(x: 80, y: 0, width: pickerView.bounds.width - 90, height: 60))
 myLabel.text = rowString
 
 myView.addSubview(myLabel)
 myView.addSubview(myImageView)
 return myView
 }
 else {
 let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
 let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
 var rowString = String()
 
 myImageView.loadImage(urlString: country_data[row].flag_url)
 rowString = country_data[row].c_name
 
 let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60))
 myLabel.text = rowString
 
 myView.addSubview(myLabel)
 myView.addSubview(myImageView)
 return myView
 }
 }
 
 func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
 print("SELECTED>>>> \(row)")
 if pickerView == countryPickerView {
 
 let selectedCountryName : String = country_data[row].c_name
 selectCountryLabel.text = selectedCountryName
 selected_country_id = country_data[row].c_id
 let userdefaults = UserDefaults.standard
 userdefaults.set(selectedCountryName, forKey: "COUNTRY")
 userdefaults.set(selected_country_id, forKey: "COUNTRY_ID")
 userdefaults.synchronize()
 countryPickerView.isHidden = true
 }
 else {
 
 let selecteTeamName:String = team_data[row].team_name
 selectTeamLabel.text = selecteTeamName
 selected_team_id = team_data[row].team_id
 let imageURL: String = team_data[row].logo
 let userdefaults = UserDefaults.standard
 userdefaults.set(selecteTeamName, forKey: "TEAM")
 userdefaults.set(imageURL, forKey: "TEAM_LOGO")
 userdefaults.set(selected_team_id, forKey: "TEAM_ID")
 userdefaults.synchronize()
 teamPickerView.isHidden = true
 }
 }
 }
 */
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension UIViewController {
    func removeBorder(textField: UITextField)  {
        textField.borderStyle = UITextBorderStyle.none

    }
}
