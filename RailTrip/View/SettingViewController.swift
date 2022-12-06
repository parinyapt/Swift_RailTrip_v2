//
//  SettingViewController.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 6/12/2565 BE.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var LBName: UILabel!
    @IBOutlet weak var SMLanguage: UISegmentedControl!
    @IBOutlet weak var SMTheme: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LBName.text = UserDefaults.standard.string(forKey: "RailTrip_User_Name")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "RailTrip_User_Language") == "th" {
            SMLanguage.selectedSegmentIndex = 1
        }else{
            SMLanguage.selectedSegmentIndex = 0
        }
        
    }
    
    @IBAction func ChangeLanguage(_ sender: Any) {
        let s:UISegmentedControl = sender as! UISegmentedControl
        let index = s.selectedSegmentIndex
        UserDefaults.standard.set(index == 1 ? "th" : "en", forKey: "RailTrip_User_Language")
    }
    
    @IBAction func ChangeTheme(_ sender: Any) {
        let s:UISegmentedControl = sender as! UISegmentedControl
        let addDelegate = UIApplication.shared.windows.first
        if s.selectedSegmentIndex == 0 {
            addDelegate?.overrideUserInterfaceStyle = .light
        }else{
            addDelegate?.overrideUserInterfaceStyle = .dark
        }
        
        
        
    }
    
    @IBAction func btnSignout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "RailTrip_User_Token")
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController_ID") as? ViewController else {
           return
       }
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve

        self.present(mainVC, animated: false, completion: nil)
    }
    
    
}
