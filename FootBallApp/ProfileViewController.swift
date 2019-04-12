
//
//  ProfileViewController.swift
//  FootBallApp
//
//  Created by Praveen Khare on 07/04/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var genderPicker: UIPickerView!
    var team_data = [TeamClassData]()
    var country_data = [CountryDataClass]()
    var gende_picker = UIPickerView ()
    
    var teamPickerView = UIPickerView()
    var countryPickerView = UIPickerView()
    var myPickerView = UIPickerView()
    @IBOutlet var teamView: UIView!
    @IBOutlet var countryView: UIView!
    @IBOutlet weak var SaveBtnOutlet: UIButton!
    
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var genderOutlet: UILabel!
    
    var selected_country_id: String = ""
    var selected_team_id: String = ""
    var f_name:String = ""
    var l_name:String = ""
    var c_number:String = ""
    var genderArr = [String] ()
    
    @IBOutlet weak var genderTxt: UITextField!
    
    var GenderTableView = UITableView()
    var countryTableView = UITableView()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNamefield: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var contactNumberField: UITextField!
    @IBOutlet weak var selectCountryLabel: UILabel!
    @IBOutlet weak var selectTeamLabel: UILabel!
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        
//        if (firstNamefield.text == "") {
//            let alertBox = UIAlertController(title: "Error !!!!", message: "Please enter first name", preferredStyle: .alert)
//            alertBox.addAction(UIAlertAction(title: "Ok, Try Again", style: .default, handler: nil))
//            self.present(alertBox, animated: true, completion: nil)
//            
//        }
//        else if lastNameField.text == "" {
//            let alertBox = UIAlertController(title: "Error !!!!", message: "Please enter last name", preferredStyle: .alert)
//            alertBox.addAction(UIAlertAction(title: "Ok, Try Again", style: .default, handler: nil))
//            self.present(alertBox, animated: true, completion: nil)
//            
//        }
//        else if contactNumberField.text == "" {
//            let alertBox = UIAlertController(title: "Error !!!!", message: "Please enter contact number", preferredStyle: .alert)
//            alertBox.addAction(UIAlertAction(title: "Ok, Try Again", style: .default, handler: nil))
//            self.present(alertBox, animated: true, completion: nil)
//            
//        }
//        else {
//            
//
//        }
        updateProfile()
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeBorder(textField: self.genderTxt)
        self.genderTxt.delegate = self
//        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
//        self.myPickerView.delegate = self
//        self.myPickerView.dataSource = self
//        self.myPickerView.backgroundColor = UIColor.white
//        genderTxt.inputView = self.myPickerView
//
//        let toolBar = UIToolbar()
//        toolBar.barStyle = .default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
//        toolBar.sizeToFit()
//
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ProfileViewController.doneClick))
//
//        toolBar.setItems([ doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        genderTxt.inputAccessoryView = toolBar
//        teamPickerView.isHidden = true
//        countryPickerView.isHidden = true
//       
//        teamPickerView.delegate = self
//        teamPickerView.dataSource = self
//        
//        countryPickerView.delegate = self
//        countryPickerView.dataSource = self
        let savebtnTitle = NSLocalizedString("SAVE", comment: "")
   SaveBtnOutlet.setTitle(savebtnTitle, for: UIControlState .normal)
        genderArr = ["Male","Female"]
                gende_picker.delegate = self
                gende_picker.dataSource = self
       //  gende_picker.isHidden = true
        
//        getCountryDATA()
//        getTeamData()
        let tittlename = NSLocalizedString("My Profile", comment: "")
        self.navigationItem.title = tittlename
        let userDefaults = UserDefaults.standard
        let name = userDefaults.string(forKey: "COUNTRY")
        let team = userDefaults.string(forKey: "TEAM")
       
//        selectCountryLabel.text = name
//        selectTeamLabel.text = team
//
        let email = userDefaults.string(forKey: "EMAIL")
        emailTextField.text = email
        
//        let countryRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.countryTableTap(_:)))
//        selectCountryLabel.addGestureRecognizer(countryRecognizer)
//        
//        let teamRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.teamTableTap(_:)))
//        selectTeamLabel.addGestureRecognizer(teamRecognizer)
//        
//        self.hideKeyboardWhenTappedAround()
        
                let genderRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.genderTableTap(_:)))
                genderOutlet.addGestureRecognizer(genderRecognizer)
 // genderPicker.isHidden = true
    }
    func doneClick() {
        genderTxt.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        GenderTableView.isHidden = true
        countryTableView.isHidden = true
        
        GenderTableView.delegate = self
        GenderTableView.dataSource = self
        
        countryTableView.delegate = self
        countryTableView.dataSource = self
        //        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleTap(_:)))
//        selectCountryLabel.addGestureRecognizer(gestureRecognizer)
        let tappedOnTeam = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tappedOnGenderView))
        genderTxt.addGestureRecognizer(tappedOnTeam)
        self.hideKeyboardWhenTappedAround()
        GenderTableView.register(UINib(nibName: "pickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
        countryTableView.register(UINib(nibName: "pickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
//        
//        teamPickerView.frame = CGRect(x: 0, y: self.view.frame.size.height - 260, width: self.view.frame.width, height: 260)
//        teamPickerView.backgroundColor = UIColor.white
//        teamPickerView.layer.borderColor = UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
//        teamPickerView.layer.borderWidth = 1.0
//        teamPickerView.layer.cornerRadius = 7.0
//        teamPickerView.layer.masksToBounds = true
//        self.view.addSubview(teamPickerView)
//        
//        countryPickerView.frame = CGRect(x: 0, y: self.view.frame.size.height - 180, width: self.view.frame.width, height: 180)
//        countryPickerView.backgroundColor = UIColor.white
//        countryPickerView.layer.borderColor = UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
//        countryPickerView.layer.borderWidth = 1.0
//        countryPickerView.layer.cornerRadius = 7.0
//        countryPickerView.layer.masksToBounds = true
//        self.view.addSubview(countryPickerView)
//
//        self.hideKeyboardWhenTappedAround()
        
        let userDef = UserDefaults.standard
        let newF = userDef.string(forKey: "F_NAME")
        let newL = userDef.string(forKey: "L_NAME")
        let new_num = userDef.string(forKey: "NUMBER")
         let email = userDef.string(forKey: "EMAIL")
        let gender = userDef.string(forKey: "gender")

        
        if newF != nil {
            firstNamefield.text = newF!
            // print("F_NAME \(newF!)")
        }
        if newL != nil {
            lastNameField.text = newL!
            //print("L_NAME \(newL!)")
        }
        if new_num != nil {
            contactNumberField.text = new_num!
            //print("NUMBER \(new_num!)")
        }
        if email != nil {
            emailTextField.text = email!
            //print("NUMBER \(new_num!)")
        }
        if gender != nil {
            genderTxt.text = gender!
            //print("NUMBER \(new_num!)")
        }else{
            genderTxt.text = "Male"
        }


    }
    func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        if (countryTableView.isHidden == true ) {
            countryTableView.isHidden = false
            countryTableView.frame = CGRect(x: 20, y:  self.countryView.frame.origin.y + 105, width: self.countryView.frame.size.width, height: 120)
            countryTableView.layer.borderWidth = 2
            countryTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor

            countryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
            //countryTableView.rowHeight = 60
            self.view.addSubview(countryTableView)
             GenderTableView.isHidden = true
            genderPicker.isHidden = true
        }
        else {
            countryTableView.isHidden = true
        }
        
    }
    func tappedOnGenderView(_ gestureRecognizer: UIGestureRecognizer) {
        if (GenderTableView.isHidden == true ) {
            GenderTableView.isHidden = false
            GenderTableView.frame = CGRect(x: 20, y: self.genderView.frame.origin.y + 105, width: self.genderView.frame.size.width, height: 200)
            GenderTableView.layer.borderWidth = 2
            GenderTableView.layer.borderColor =  UIColor(colorLiteralRed: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0) .cgColor

            GenderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
            //teamTableView.rowHeight = 60
            self.view.addSubview(GenderTableView)
            emailTextField.resignFirstResponder()
            firstNamefield.resignFirstResponder()
            lastNameField.resignFirstResponder()
            contactNumberField.resignFirstResponder()
            countryTableView.isHidden = true
        }
        else {
            GenderTableView.isHidden = true
        }
    }
//    func countryTableTap(_ gestureRecognizer: UIGestureRecognizer) {
//        if (countryPickerView.isHidden == true) {
//            teamPickerView.isHidden = true
//            countryPickerView.isHidden = false
//        }
//    }
//    func teamTableTap(_ gestureRecognizer: UIGestureRecognizer) {
//        if (teamPickerView.isHidden == true) {
//            teamPickerView.isHidden = false
//            countryPickerView.isHidden = true
//        }
//    }
    
        func genderTableTap(_ gestureRecognizer: UIGestureRecognizer) {
            if (  genderPicker.isHidden == true) {
                  genderPicker.isHidden = false
               

               
            }
            else{
               genderPicker.isHidden = true
           }
        }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == genderTxt {
               GenderTableView.isHidden = false
        }else{
            countryTableView.isHidden = true
            GenderTableView.isHidden = true
        }
     

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        firstNamefield.resignFirstResponder()
        lastNameField.resignFirstResponder()
        contactNumberField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == genderTxt {
            return false; //do not show keyboard nor cursor
        }
        return true
    }
    func getCountryDATA() {
    
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=getCountry")!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let resJson = response.result.value as? [String: AnyObject] {
                    if let responceCode = resJson["RESPONSECODE"] as? Int {
                        print("RESPONSE CODE>> \(responceCode )")
                    }
                    if let responseData = resJson["RESPONSE"] as? [AnyObject] {
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
            else if response.result.isFailure {
                print("SOMEERROR")
            }
        }
    }
    
    func getTeamData() {
        
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=getTeam")!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let resJson = response.result.value as? NSDictionary {
                    if let responceCode = resJson["RESPONSECODE"] as? Int {
                        print("RESPONSE CODE>> \(responceCode )")
                    }
                    if let responseData = resJson["RESPONSE"] as? [AnyObject] {
                        for arrData in responseData {
//                            let team_name = arrData["name"] as? String
//                            let s_id = arrData["session_id"] as? String
//                            let logo = arrData["logo"] as? String
//                            let team_id = arrData["team_id"] as? String
//                            guard let twitter_data = arrData["twitter"] as? String else {
//                                return
//                            }
//                            let venue = arrData["venue_id"] as? String
//                            let coach_id = arrData["coach_id"] as? String
//                            let chairman_id = arrData["chairman_id"] as? String
//                            let i = TeamClassData(team_id: team_id!, team_name: team_name!, session_id: s_id!, logo: logo!, twitter_data: twitter_data, venue: venue!, coach_id: coach_id!, chairman_id: chairman_id!)
                            let team_id = arrData["team_id"] as? NSString
                            if(team_id?.isEqual(to: "15359"))!{
                                print("gotIT")
                            };
                            var team_name = "" as String
                            if (arrData["name"] as? String) != nil {
                                team_name = arrData.value(forKey: "name") as! String
                                
                            }
                            
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
                            self.GenderTableView.reloadData()
                        })
                    }
                }
            }
            else if response.result.isFailure {
                print("SOMEERROR")
            }
        }
    }
    
    func updateProfile() {
    
        let userDef = UserDefaults.standard
        let id = userDef.integer(forKey: "ID")
        let f_name: String = firstNamefield.text!
        let l_name:String = lastNameField.text!
        // let email:String = emailTextField.text!
        let contact_number :String = contactNumberField.text!
          let gender :String = self.genderTxt.text!
        
        
        
        let trimmedString1:String = f_name.replacingOccurrences(of: " ", with: "%20")
        let trimmedString2:String = l_name.replacingOccurrences(of: " ", with: "%20")
        let trimmedString3:String = contact_number.replacingOccurrences(of: " ", with: "%20")
          let trimmedString4:String = gender.replacingOccurrences(of: " ", with: "%20")
         userDef.set(trimmedString4, forKey: "gender")
        // let trimmedString4:String = email.replacingOccurrences(of: " ", with: "%20")
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=updateProfile&user_id=\(id)&first_name=\(trimmedString1)&last_name=\(trimmedString2)&age=\(trimmedString3)&country_id=\(selected_country_id)&team_id=\(selected_team_id)&gender=\(trimmedString4)")!
        print("URL>>\(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let root = response.result.value as? [String: AnyObject] {
                    if let res = root["RESPONSE"] as? String {
                        print("RESULTS>>\(res)")
                        let alertTitlemsg = NSLocalizedString("Success !!!!", comment: "")
                        let alertmsg = NSLocalizedString("Your profile updated successfully", comment: "")
                        let alertCancelbtnTitle  = NSLocalizedString("OK", comment: "")
                        
                        
                        let alertBox = UIAlertController(title:alertTitlemsg, message: alertmsg, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: alertCancelbtnTitle, style: .default) { (action) in
                       
                        }
                        alertBox.addAction(OKAction)
                        self.present(alertBox, animated: true, completion: nil)
                        self.firstNamefield.text = f_name
                        self.lastNameField.text = l_name
                        self.contactNumberField.text = contact_number
                        self.genderTxt.text = trimmedString4
                        userDef.set(f_name, forKey: "F_NAME")
                        userDef.set(l_name, forKey: "L_NAME")
                        userDef.set(contact_number, forKey: "NUMBER")
                          userDef.set(trimmedString4, forKey: "gender")
                    }
                 }
            }
            else if response.result.isFailure {
                print("ERROR IN RESPONSE")
            }
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      
            return genderArr.count
            
    }
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 60
//    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArr[row]
       
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let genderName = genderArr[row]

        self.genderTxt.text = genderName
    }

    
    @IBAction func back(_ sender: UIBarButtonItem) {
   self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
}
/*
extension ProfileViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == GenderTableView {
            return genderArr.count
        } else {
            return country_data.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == GenderTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as! pickerCell
            cell.lbl.text = genderArr[indexPath.row]
          //  cell.img.loadImage(urlString: team_data[indexPath.row].logo)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as! pickerCell
            cell.lbl.text = country_data[indexPath.row].c_name
            cell.img.loadImage(urlString: country_data[indexPath.row].flag_url)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == countryTableView {
            tableView.cellForRow(at: indexPath)
            let selectedCountryName : String = country_data[indexPath.row].c_name
            selectCountryLabel.text = selectedCountryName
            selected_country_id = country_data[indexPath.row].c_id
            let userdefaults = UserDefaults.standard
            userdefaults.set(selectedCountryName, forKey: "COUNTRY")
            userdefaults.synchronize()
            countryTableView.isHidden = true
        }
        else {
            tableView.cellForRow(at: indexPath)
            let selecteTeamName:String = genderArr[indexPath.row]
            genderTxt.text = selecteTeamName
        //    selected_team_id = team_data[indexPath.row].team_id
        //    let imageURL: String = team_data[indexPath.row].logo
       //     let userdefaults = UserDefaults.standard
//            userdefaults.set(selecteTeamName, forKey: "TEAM")
//            userdefaults.set(imageURL, forKey: "TEAM_LOGO")
//            userdefaults.set(selected_team_id, forKey: "TEAM_ID")
//            userdefaults.synchronize()
            GenderTableView.isHidden = true
        }
    }
    
}


