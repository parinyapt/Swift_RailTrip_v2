//
//  LoginViewController.swift
//  RailTrip
//
//  Created by Trin Pongsri on 4/12/2565 BE.
//

import UIKit
import LGButton
import PopupDialog

class LoginViewController: UIViewController {
//    @State var loadingstatus:Bool = false
    
    @IBOutlet weak var TFemail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.showAnimatedSkeleton()

        // Do any additional setup after loading the view.
        
        
        utilsAPIConnect().DeleteTrip(TripID: 9) { response,statusCode,error in
            switch(error){
            case false:
                switch(statusCode){
                case 200:
                    print("========200========")
                    print(response)
//                    print(UserDefaults.standard.string(forKey: "RailTrip_User_Token") ?? "")
//                    print(response?.data?.count ?? 0)
//                    for datax in response?.data ?? [] {
//                        print(datax.tripName)
//                        print(datax.tripID)
//                    }
                    break
                default:
                    print("========default========")
                    print(response)
                    break
                }
                
                break
            case true:
                print("========error========")
                break
            }
        }
        
        
    }
    
    @IBAction func btnLoginSubmit(_ sender: LGButton) {
        //config
        sender.isLoading = true
//        loadingstatus.toggle()
        var pass = true
        let inputEmail = TFemail.text ?? ""
        //validate
        if !utilsValidator().isEmpty(input: inputEmail) {
            pass.toggle()
            self.present(utilsAlert().AlertWithDisableButton(
                title: "Email field is required",
                message: "Please Try again",
                buttontext: "Ok"
            ), animated: true, completion: nil)
        }
        if !utilsValidator().isEmail(input: inputEmail) {
            pass.toggle()
            self.present(utilsAlert().AlertWithDisableButton(
                title: "Invalid email format",
                message: "Please Try again",
                buttontext: "Ok"
            ), animated: true, completion: nil)
        }

        if pass {
            utilsAPIConnect().RequestOTP(email: inputEmail) { reponse,statusCode,error in
                switch(error){
                case false:
//                    self.dataUse["ref_id"] = reponse?.data.refID
//                    print(reponse?.data.refID ?? "")
//                    self.dataUse["status"] = reponse?.data.status
//                    print("false")
//                    print(reponse?.message ?? "")
//                    print(error ?? "")
                    switch(statusCode){
                    case 200:
                        UserDefaults.standard.set(String(reponse?.data?.refID ?? ""), forKey: "RailTrip_AuthData_RefID")
                        UserDefaults.standard.set(inputEmail, forKey: "RailTrip_AuthData_Email")
                        switch(reponse?.data?.status){
                        case "login":
                            //login redirect to otp verify page
                            let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            guard let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "OTPVerifyViewController_ID") as? OTPVerifyViewController else {
                               return
                           }
                            mainVC.modalPresentationStyle = .fullScreen
                            mainVC.modalTransitionStyle = .crossDissolve
                    
                            self.present(mainVC, animated: true, completion: nil)
                            break
                        case "register":
                            //register redirect to register page
                            let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            guard let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "RegisterViewController_ID") as? RegisterViewController else {
                               return
                           }
                            mainVC.modalPresentationStyle = .fullScreen
                            mainVC.modalTransitionStyle = .crossDissolve
                    
                            self.present(mainVC, animated: true, completion: nil)
                            break
                        default:
                            self.present(utilsAlert().AlertWithDisableButton(
                                title: reponse?.message ?? "",
                                message: "Please Try again",
                                buttontext: "Ok"
                            ), animated: true, completion: nil)
                            break
                        }
                        break
                    default:
                        self.present(utilsAlert().AlertWithDisableButton(
                            title: reponse?.message ?? "",
                            message: "Please Try again",
                            buttontext: "Ok"
                        ), animated: true, completion: nil)
                        break
                    }
//                    sender.isLoading = false
                    
                    break
                case true:
                    self.present(utilsAlert().AlertWithDisableButton(
                        title: "Internal Server Error",
                        message: "Please Try again",
                        buttontext: "Ok"
                    ), animated: true, completion: nil)
//                    sender.isLoading = false
                    break
                }
                sender.isLoading = false
            }
        }else{
            sender.isLoading = false
        }

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

