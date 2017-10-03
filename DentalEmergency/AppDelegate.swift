//
//  AppDelegate.swift
//  DentalEmergency
//
//  Created by Lisue She on 7/19/17.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let stack = CoreDataStack(modelName: "Selected")
    
    var googlePageToken: String = ""
    var googleSearchApi: String = ""
    
    var lastVisitView: ViewControllerEnum = ViewControllerEnum.startView
    var initialViewDone: Bool = false
    
    var myLocation: PracticePinAnnotation?
    var selectedOffice: SelectedOfficeData?
    
    var selectedOffices = [SelectedOfficeData]()
    
    func checkIfFirstLaunch() {

        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            if let myLastVisitView = UserDefaults.standard.value(forKey: "lastVisitView") as? Int {
                lastVisitView=convertViewControllerConstantToEnum( viewController: myLastVisitView)
            } else {
                lastVisitView = ViewControllerEnum.startView
            }
            print("App has launched before")
        } else {
            print("This is the first launch ever!")
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.synchronize()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        checkIfFirstLaunch()
       
        if  !(lastVisitView == ViewControllerEnum.startView) {
            selectedOffice = SelectedOfficeData(
                name: (UserDefaults.standard.value(forKey: "practiceName") as? String)!,
                photo: nil,
                rating: (UserDefaults.standard.value(forKey: "practiceRating") as? Float)!,
                placeId: (UserDefaults.standard.value(forKey: "practicePlaceId") as? String)!,
                photoReference: (UserDefaults.standard.value(forKey: "practicePhotoReference") as? String)! )
            selectedOffice?.latitude = (UserDefaults.standard.value(forKey: "practiceLat") as? Double)!
            selectedOffice?.longitude = (UserDefaults.standard.value(forKey: "practiceLong") as? Double)!
            if  let officeAddr = (UserDefaults.standard.value(forKey: "practiceAddress") as? String) {
                selectedOffice?.officeAddr = (UserDefaults.standard.value(forKey: "practiceAddress") as? String)!
            }
        }
        
        stack?.autoSave(120)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        let myView: Int = convertViewControllerEnumToInt( viewController: lastVisitView )
        UserDefaults.standard.set(myView, forKey: "lastVisitView")
        let tempView = UserDefaults.standard.value(forKey: "lastVisitView")
        if  !(lastVisitView == ViewControllerEnum.startView) {
            UserDefaults.standard.set(selectedOffice?.name, forKey: "practiceName")
            UserDefaults.standard.set(selectedOffice?.placeId, forKey: "practicePlaceId")
            UserDefaults.standard.set(selectedOffice?.photoReference, forKey: "practicePhotoReference")
            UserDefaults.standard.set(selectedOffice?.rating, forKey: "practiceRating")
            UserDefaults.standard.set(selectedOffice?.latitude, forKey: "practiceLat")
            UserDefaults.standard.set(selectedOffice?.longitude, forKey: "practiceLong")
            UserDefaults.standard.set(selectedOffice?.longitude, forKey: "practiceAddress")
        }
        
        stack?.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

