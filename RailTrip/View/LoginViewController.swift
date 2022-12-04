//
//  LoginViewController.swift
//  RailTrip
//
//  Created by Trin Pongsri on 4/12/2565 BE.
//

import UIKit
import SkeletonView

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.showAnimatedSkeleton()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLoginSubmit(_ sender: Any) {
        BackendConnect().demoprint()
        
        BackendConnect().demoprint()
        
        BackendConnect().demoprint()
        
        BackendConnect().demoprint()
        
        BackendConnect().demoprint()
        
        BackendConnect().demoprint()
    }
    //    func dropshadowButton(buttonName:UIButton) {
//
//        let grayColor = (UIColor(red: 56, green: 56, blue: 56, alpha: 1.0))
//
//        buttonName.layer.shadowColor = grayColor.cgColor
//        buttonName.layer.shadowRadius = 12
//        buttonName.layer.shadowOpacity = 1
//        buttonName.layer.shadowOffset = CGSize(width: 1, height: 1)
//
//
//    }
    
}
