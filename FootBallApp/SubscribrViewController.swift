//
//  SubscribrViewController.swift
//  FootBallApp
//
//  Created by Praveen Khare on 15/04/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import StoreKit
import Alamofire
import EventKit
import GoogleAPIClientForREST
import GoogleSignIn
import GTMOAuth2
import StoreKit

class SubscribrViewController: UIViewController,SKProductsRequestDelegate, SKPaymentTransactionObserver,UIWebViewDelegate,GIDSignInDelegate, GIDSignInUIDelegate {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    @IBOutlet weak var notPayment: UIButton!
    @IBOutlet weak var oneMonthView: UIView!
    @IBOutlet var indecate: UIActivityIndicatorView!
    
    @IBOutlet weak var importEventToCalender: UIButton!
    @IBOutlet weak var googleEventButton: UIButton!
    
    private let scopes = [kGTLRAuthScopeCalendarReadonly]
    
    private let service = GTLRCalendarService()
    let signInButton = GIDSignInButton()
    let output = UITextView()
    var productIDs: Array<String?> = []
    
    
    @IBOutlet weak var CancelWebView: UIButton!
    @IBOutlet weak var WebView: UIWebView!
    var kClientID =   "416402075859-71ch0p0odk88v1cbbqac0c7jja5h5ge2.apps.googleusercontent.com"
    // var kKeychainItemName   = " AIzaSyCT35NzEe3eo5HvEw80BGnZoPnoAOGXtGg"
    var kKeychainItemName   = "Google Calendar API"
    var futureFixture  = [fixtureCellDataClass1]()
    var stirngfilter = [String]()
    var fixture = [fixtureCellDataClass1]()
    var leagueName = [NSMutableArray]()
    var leagueName1 = [String]()
    var select_match = String()
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            self.signInButton.isHidden = true
            self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchEvents()
        }
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //service = GTLServiceCalendar()
        // service.authorizer = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(forName: kKeychainItemName, clientID: kClientID, clientSecret: nil)
       // SKPaymentQueue.default().add(self)
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(
            forName: kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
        //        productIDs.append("com.oms.footBallApp.buyCalender")
        self.importEventToCalender.isHidden = false
        productIDs.append("com.oms.footBallApp.buyCalender")
    
        requestProductInfo()
        
        self.WebView.scrollView.bounces = false
        self.WebView.delegate = self
        self.WebView.isHidden = true
      
        self.indecate.isHidden = true
        
        self.indecate.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        self.navigationItem.title = "Subscribe Here"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        
   
        output.frame = view.bounds
        output.isEditable = false
        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        output.isHidden = true
        view.addSubview(output);
        
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        
        oneMonthView.addGestureRecognizer(tap)
        
    }
    @IBAction func importIphone(_ sender: UIButton) {
        self.indecate.isHidden = false
        generateICSfile()
        // self.handleTap()
    }
    
    func fetchEvents() {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 10
        query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        service.executeQuery(
            query,
            delegate: self,
            didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRCalendar_Events,
        error : NSError?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        var outputText = ""
        if let events = response.items, !events.isEmpty {
            for event in events {
                let start = event.start!.dateTime ?? event.start!.date!
                let startString = DateFormatter.localizedString(
                    from: start.date,
                    dateStyle: .short,
                    timeStyle: .short)
                outputText += "\(startString) - \(event.summary!)\n"
            }
        } else {
            outputText = "No upcoming events found."
        }
        output.text = outputText
    }
    
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func importGoogle(_ sender: UIButton) {
        let productID = UserDefaults.standard.bool(forKey:"prodID")
        if (productID){
            let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .alert)
            
            let Restore = UIAlertAction(title: "Restore", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().restoreCompletedTransactions()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                
            })
            optionMenu.addAction(Restore)
            // cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
            
        }else{
            self.subscribeCalender()
        }
        
    }
    func subscribeCalender(){
        for product in self.list {
            let prodID = product.productIdentifier
            if(prodID == "com.oms.footBallApp.buyCalender") {
                self.p = product
                self.buyProduct()
            }
        }
    }
    
    func eventImportToCalender () {
        let team_id:String = UserDefaults.standard.string(forKey: "TEAM_ID")!
        print("TEAM ID >>>>>\(team_id)")
        self.indecate.isHidden = false
        self.WebView.isHidden = false
        self.indecate.startAnimating()
        
        let dictionaty = NSDictionary(object: "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36", forKey: "UserAgent" as NSCopying)
        UserDefaults.standard.register(defaults: dictionaty as! [String : Any])
        
        //    http://www.omsoftware.us/overachievers/googleauth/google-login.php
        
        if let url = URL(string:"http://omsoftware.us/overachievers/googleauth/google-login.php?team_id=\(team_id)")
        {
            print(url)
            var req = URLRequest(url: url)
            self.WebView.delegate = self
            self.WebView.loadRequest(req)
            
        }
        
        
    }
    func generateICSfile(){
        let team_id:String = UserDefaults.standard.string(forKey: "TEAM_ID")!
        print("TEAM ID >>>>>\(team_id)")
        let url : URLConvertible = URL(string: "http://omsoftware.us/overachievers/football_api/service.php?action=googlecalendar&team_id=\(team_id)")!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let resJson = response.result.value as? NSDictionary {
                    if let responceCode = resJson["RESPONSECODE"] as? Int {
                        print("RESPONSE CODE>> \(responceCode )")
                    }
                    if let resString = resJson.value(forKey: "RESPONSE") as? String
                    {
                        print(resString)
                        if resString == "Calender generated."{
                            self.openICSfile()
                        }
                    }
                }
                
                self.indecate.stopAnimating()
            }
            else if response.result.isFailure {
                print(response.result.error as Any)
                self.indecate.stopAnimating()
            }
        }
    }
    
    func webViewDidStartLoad(_ webView : UIWebView) {
        
        print("AA")
        self.indecate.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        
        self.indecate.stopAnimating()
        var urlText = String()
        if let text = webView.request?.url?.absoluteString{
            print(text)
            urlText = text
        }
        if urlText == "http://omsoftware.us/overachievers/googleauth/apple.html"{
            
            generateICSfile()
            print("ok")
        }
    }
    func openICSfile(){
        let team_id:String = UserDefaults.standard.string(forKey: "TEAM_ID")!
        print("TEAM ID >>>>>\(team_id)")
        let link = "http://omsoftware.us/overachievers/football_api/download/calendar\(team_id).ics"
        print(link)
        let webcal = NSURL(string: link)
        UIApplication.shared.openURL(webcal! as URL)
        self.indecate.stopAnimating()
    }
    
    func getTeamDataFromAPI() {
        // self.activityIndicator.startAnimating()
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
                        
                        for arr in resArray {
                            _ = arr["logo"] as? String
                            if (arr["pastmatches"] as? NSArray) != nil {
                                // print(pastMachtes)
                            }
                            
                            //Upcoming matches
                            if let futureMatches = arr["upcomingMatch"] as? [AnyObject] {
                                if futureMatches.count != 0 {
                                    //self.fixture.removeAll()
                                    self.futureFixture.removeAll()
                                    for future in futureMatches {
                                        let match_id = future["match_id"] as? String
                                        
                                        UserDefaults.standard.set(match_id, forKey: "match_id")
                                        UserDefaults.standard.synchronize()
                                        
                                        let startingDate = future["starting_date"] as? String
                                        let startingTime = future["starting_time"] as? String
                                        let a_name = future["AwayTeam"] as? String
                                        let h_name = future["HomeTeam"] as? String
                                        let ID = future["match_id"] as? String
                                        self.select_match = ID!
                                        
                                        let ht_score = future["ht_score"] as? String
                                        let ft_score = future["ft_score"] as? String
                                        let compatitonName = future["competition_name"] as? String
                                        let obj = fixtureCellDataClass1(away_team_name: a_name!, homwe_team_name: h_name!, startingTime: startingTime!, startingDte: startingDate!, matchID: match_id!, ht_score: ht_score!, compatitonName: compatitonName!,ft_score: ft_score!)
                                        self.futureFixture.append(obj)
                                        self.fixture.append(obj)
                                    }
                                }
                                else {
                                    print("No future matches available for selecetd team ID")
                                    
                                }
                            }
                        }
                        print(self.futureFixture)
                        print(self.fixture)
                        self.importToCalender()
                    }
                }
                if(self.futureFixture.count == 0){
                    let alertController = UIAlertController(title: "Alert", message: "No future matches available to Import", preferredStyle: .alert)
                    let dismis = UIAlertAction(title: "OK", style: .default, handler: { action in
                        //                                            self.leagueName1 = [""]
                        self.fixture.removeAll()
                        //                                            self.myTableView.reloadData()
                        self.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(dismis)
                    self.present(alertController, animated: true, completion: nil)
                }
                self.indecate.stopAnimating()
            }
            else if response.result.isFailure {
                print(response.result.error as Any)
                self.indecate.stopAnimating()
            }
        }
    }
    
    
    func importToCalender(){
        for i in 0..<self.futureFixture.count{
            let teamName1 = futureFixture[i].homwe_team_name
            let teamName2 = futureFixture[i].away_team_name
            let startTime = fixture[i].startingTime
            let formattar = DateFormatter()
            let s : String = fixture[i].startingDte
            formattar.dateFormat = "yyyy-MM-dd"
            formattar.timeZone = NSTimeZone(name: "GMT")! as TimeZone
            let matchDate =  formattar.date(from: s)! as Date
            formattar.dateFormat = "yyyy-MM-dd"
            formattar.timeZone = NSTimeZone(name: "GMT")! as TimeZone
            let matchDate1 =  formattar.string(from: matchDate)
            print(matchDate1)
            
            let match =  NSString(format:"%@ vs %@", teamName1,teamName2)
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "HH:mm:ss"
            dateFormatter2.timeZone = NSTimeZone(name: "GMT")! as TimeZone
            let timeStamp2 = dateFormatter2.date(from: startTime)
            dateFormatter2.dateFormat = "HH:mm:ss"
            let timeStamp3 = dateFormatter2.string(from: timeStamp2!)
            print(timeStamp3)
            let DateTime =   NSString(format:"%@ %@", matchDate1,timeStamp3)
            print(DateTime)
            let formattar5 = DateFormatter()
            formattar5.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formattar5.timeZone = NSTimeZone(name: "GMT")! as TimeZone
            let matDate =  formattar5.date(from: DateTime as String)! as NSDate
            let matchDateWithTime = matDate.addingTimeInterval(45.0 * 60.0)
            print(matchDateWithTime)
            print(matDate)
            
            
            
            
            self.addEventToCalendar(title: match as String, description: "Upcoming Football Matches", startDate: matDate as Date, endDate: matchDateWithTime as Date)
        }
        let SelectedTeamName = UserDefaults.standard.object(forKey: "name") as! String
        let AlertTitle = String(format: "The Calender \"%@ Fc\" has been added", SelectedTeamName)
        let alertController = UIAlertController(title: "Message", message: AlertTitle, preferredStyle: .alert)
        let dismis = UIAlertAction(title: "View Events", style: .default, handler: { action in
            UIApplication.shared.openURL(NSURL(string: "calshow://")! as URL)
            
        })
        let Viewevent = UIAlertAction(title: "Done", style: .default, handler: { action in
            self.fixture.removeAll()
            self.WebView.isHidden = true
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        })
        //self.activityIndicator.stopAnimating()
        
        alertController.addAction(dismis)
        alertController.addAction(Viewevent)
        self.present(alertController, animated: true, completion: nil)
        self.indecate.stopAnimating()
    }
    func retrievefutureFixture() -> [fixtureCellDataClass1]? {
        if let unarchivedObject = UserDefaults.standard.object(forKey: "futureFixture") as? NSData {
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [fixtureCellDataClass1]
        }
        return nil
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        UserDefaults.standard.removeObject(forKey: "FixtureIndex")
        UserDefaults.standard.removeObject(forKey: "gotoDetail")
        UserDefaults.standard.removeObject(forKey: "filterstr")
        UserDefaults.standard.removeObject(forKey: "collIndex")
        activityIndicator.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/4)
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        let titleName = NSLocalizedString("Subscribe", comment: "")
        self.navigationItem.title = titleName
        
        let backgroundImage = UIImage(named: "top_tab_Bar")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.stretch)
        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        self.WebView.delegate = self
        let productID = UserDefaults.standard.bool(forKey:"prodID")
        if (productID){
            self.importEventToCalender.isHidden = true
        }else{
             self.importEventToCalender.isHidden = false
        }
        eventImportToCalender()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let backgroundImage = UIImage(named: "top_tab_Bar")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.stretch)
        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
    }
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<NSObject> as! Set<String>)
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    
    
    func handleTap() {
        
    }
    func buyProduct() {
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
    // IN APP PURCHASE CODE
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        
        let myProduct = response.products
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            list.append(product)
            
        }
        // buyNow.isEnabled = true
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            switch prodID {
            case "com.oms.footBallApp.buyCalender":
                print("HERE I GET THE APP PURCHASE")
                //                print("You Already Purchased")
               // eventImportToCalender()
                self.importEventToCalender.isHidden = false
            default:
                print("IAP not found")
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error as Any)
            switch trans.transactionState {
            case .purchased:
                print("buy ok, unlock IAP HERE")
                print(p.productIdentifier)
                let prodID = p.productIdentifier
              
                switch prodID {
                case "com.oms.footBallApp.buyCalender":
                      UserDefaults.standard.set(true, forKey: "prodID")
                    print("HERE I GET THE APP PURCHASE")
                  //  eventImportToCalender()
                    self.importEventToCalender.isHidden = false
                //                    print("You Already Purchased")
               
                default:
                    print("IAP not found")
                }
                queue.finishTransaction(trans)
                
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                let alertBox = UIAlertController(title: nil, message: "Cannot connect to iTunes Store", preferredStyle: .alert)
                alertBox.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertBox, animated: true, completion: nil)
            default:
                print("Default")
                break
            }
        }
    }
    
    @IBAction func notPaymentActon(_ sender: Any) {
      //  self.WebView.isHidden = true
      
        
    }
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        let startDate = startDate
        let endDate = endDate
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)
        if existingEvents.count > 0{
            for singleEvent in existingEvents {
                if singleEvent.title == title && singleEvent.startDate == startDate {
                    print("Event exist")
                    // Event exist
                    //...
                }
                else{
                    eventStore.requestAccess(to: .event, completion: { (granted, error) in
                        if (granted) && (error == nil) {
                            let event = EKEvent(eventStore: eventStore)
                            event.title = title
                            event.startDate = startDate
                            event.endDate = endDate
                            event.notes = description
                            event.calendar = eventStore.defaultCalendarForNewEvents
                            do {
                                try eventStore.save(event, span: .thisEvent)
                                print("save")
                            } catch let e as NSError {
                                completion?(false, e)
                                print(e)
                                return
                            }
                            completion?(true, nil)
                        } else {
                            completion?(false, error as NSError?)
                        }
                    })
                    
                }
            }
        }
        else{
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = title
                    event.startDate = startDate
                    event.endDate = endDate
                    event.notes = description
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let e as NSError {
                        completion?(false, e)
                        print("failed to save event with error : \(error)")
                        return
                    }
                    completion?(true, nil)
                } else {
                    completion?(false, error as NSError?)
                }
            })
            
        }
    }
    @IBAction func CancelWebView(_ sender: Any) {
     //   self.WebView.isHidden = true
    }
}
