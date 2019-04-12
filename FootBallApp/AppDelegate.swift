//
//  AppDelegate.swift
//  FootBallApp
//
//  Created by Praveen Khare on 24/03/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn
import UserNotifications
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var teamnameArray = NSArray ()
    var countryArray = NSArray ()
    var select_match = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        UserDefaults.standard.set(deviceID, forKey: "device_id")
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[ .alert, .sound]){
                (granted, error) in }
            UNUserNotificationCenter.current().delegate = (self as! UNUserNotificationCenterDelegate)
            //            let content = UNMutableNotificationContent()
            //            content.badge = 0
            
        } else {
            
            // Fallback on earlier versions
        }
        application.registerForRemoteNotifications()
        // for skip loginViewController each time
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore  {
            //Not the first time, show login screen.
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let rootController = mainStoryboard.instantiateViewController(withIdentifier: "tab_bar") as! TabBarViewController
            if let window = self.window {
                window.rootViewController = rootController
            }
        }
        else {
            // UserDefaults.standard.set(true, forKey: "launchedBefore")
            //First time, open a new page view controller.
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let rootController = mainStoryboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
            if let window = self.window {
                window.rootViewController = rootController
            }
            
        }
        getCountryData()
        let pref = UserDefaults.standard
        let team_id = pref.object(forKey: "TEAM_ID") as? String
        if team_id != nil{
            navigatetoLiveMatch(id: team_id! )
        }
        let backgroundImage = UIImage(named: "top_tab_Bar")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 15, 0, 15), resizingMode: UIImageResizingMode.stretch)
        UINavigationBar.appearance().setBackgroundImage(backgroundImage, for: .default)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        UINavigationBar.appearance().tintColor = UIColor.white
        
        let backArrowImage = UIImage(named: "backbtn")
        let renderedImage = backArrowImage?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = renderedImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = renderedImage
        //  getTeamData()
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        checkLanguage ()
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func checkLanguage () {
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
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    
                    print(error)
                }
            }
        }).resume()
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
        return  FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication!, annotation: annotation)
        
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
                                //                                let i = TeamClassData(team_id: team_id as! String, team_name: team_name, session_id: s_id, logo: logo, twitter_data: twitter_data, venue: venue, coach_id: coach_id, chairman_id: chairman_id)
                                //                                self.team_data.append(i)
                                
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                // self.teamTableView.reloadData()
                                
                            })
                        }
                    }
                }catch let error as NSError{
                    let alert = UIAlertController(title: nil, message:"Network Error", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    print(error)
                }
            }
        }).resume()
        
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
                                
                                //                                let i = CountryDataClass(c_name: countryName!, c_id: countryID!, flag_url: flag!, iso_code: iso!)
                                //                                self.country_data.append(i)
                                
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                //   self.countryTableView.reloadData()
                            })
                        }
                    }
                }catch let error as NSError{
                    let alert = UIAlertController(title: nil, message:"Network Error", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    
                    print(error)
                }
            }
        }).resume()
        
    }
    // implemented in your application delegate
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceTokenString")
        // UserDefaults.standard.set(deviceTokenString, forKey: "device_id")
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    // Push notification received
    @available(iOS 10.0, *)
    func application(_ application: UIApplication, didReceiveRemoteNotification data: UNUserNotificationCenter) {
        // Print notification payload data
        print("Push notification received: \(data)")
        let pushData = data.value(forKey: "aps") as! NSDictionary
        let matchId = pushData.value(forKey: "match_id") as? Int
        if select_match == "\(matchId)" {
            
            UserDefaults.standard.set(true, forKey: "yes")
            navigateToLive ()
        }
        //        if (application.applicationState.rawValue == 0) // active --- forground
        //        {
        //
        //
        //        }
        
        
    }
    func navigateToLive (){
        
        //        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let rootController = mainStoryboard.instantiateViewController(withIdentifier: "LiveGame_detail") as! LiveViewController
        //        rootController.match_id = select_match
        //        if let window = self.window {
        //            window.rootViewController = rootController
        //        }
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = mainStoryboard.instantiateViewController(withIdentifier: "tab_bar") as! TabBarViewController
        //rootController.gotoLive = "yes"
        if let window = self.window {
            window.rootViewController = rootController
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        completionHandler([.alert, .badge, .sound])
    }
    func navigatetoLiveMatch(id:String) {
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
                            if let futureMatches = arr["upcomingMatch"] as? [AnyObject] {
                                if futureMatches.count != 0 {
                                    var counter = 0
                                    for future in futureMatches {
                                        if counter == 1 {
                                            break
                                        }
                                        let match_id = future["match_id"] as? String
                                        self.select_match = match_id!
                                        let stadiumName = future["venue_id"] as? String
                                        if stadiumName != "" {
                                            let StName  = String(format: "%@", stadiumName!)
                                            
                                            UserDefaults.standard.set(stadiumName, forKey: "stadiumName")
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
                                        let timeStamp2 = dateFormatter2.date(from: TIme!)
                                        print(timeStamp2)
                                        let dateFormatter3 = DateFormatter()
                                        dateFormatter3.dateFormat = "HH:mm"
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
                                        formattar50.dateFormat = "EEEE, MMM d, HH:mm:ss"
                                        formattar50.timeZone = TimeZone.current
                                        let matDate1 =  formattar50.string(from: matDate as Date)
                                        print(matDate1)
                                        counter += 1
                                        
                                    }
                                }
                                else {
                                    print("No data for selected team ID")
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
            else if response.result.isFailure {
            }
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
       // FBSDKAppEvents.activateApp()
        
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    //    @available(iOS 10.0, *)
    //    lazy var persistentContainer: NSPersistentContainer = {
    //        /*
    //         The persistent container for the application. This implementation
    //         creates and returns a container, having loaded the store for the
    //         application to it. This property is optional since there are legitimate
    //         error conditions that could cause the creation of the store to fail.
    //         */
    //        let container = NSPersistentContainer(name: "FootBallApp")
    //        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
    //            if let error = error as NSError? {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //
    //                /*
    //                 Typical reasons for an error here include:
    //                 * The parent directory does not exist, cannot be created, or disallows writing.
    //                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
    //                 * The device is out of space.
    //                 * The store could not be migrated to the current model version.
    //                 Check the error message to determine what the actual problem was.
    //                 */
    //                fatalError("Unresolved error \(error), \(error.userInfo)")
    //            }
    //        })
    //        return container
    //    }()
    
    // MARK: - Core Data Saving support
    
    //    func saveContext () {
    //        if #available(iOS 10.0, *) {
    //            let context = persistentContainer.viewContext
    //        } else {
    //            // Fallback on earlier versions
    //        }
    //        if context.hasChanges {
    //            do {
    //                try context.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nserror = error as NSError
    //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    //            }
    //        }
    //    }
    
}

