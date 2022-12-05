//
//  RouteViewController.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 6/12/2565 BE.
//

import UIKit

class RouteViewController: UIViewController {
    @IBOutlet weak var welcomeMessage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        InitSetupWelcomeMessage()
    }
    
    func InitSetupWelcomeMessage() {
        welcomeMessage.text = "Hi \(UserDefaults.standard.string(forKey: "RailTrip_User_Name") ?? "")"
    }
    
    @IBAction func btnSelectRoute(_ sender: Any) {
        UserDefaults.standard.set("route", forKey: "RailTrip_Temp_PreferMode")
        UserDefaults.standard.set("false", forKey: "RailTrip_Temp_PreferModeStatus")
        UserDefaults.standard.removeObject(forKey: "RailTrip_Temp_Start_Station")
        UserDefaults.standard.removeObject(forKey: "RailTrip_Temp_End_Station")
        UserDefaults.standard.removeObject(forKey: "RailTrip_Temp_RouteID")
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "ShareSelectStartStationViewController_ID") as? ShareSelectStartStationViewController else {
           return
       }
        
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve

        self.present(mainVC, animated: true, completion: nil)
    }
    

}
