//
//  OTPVerifyViewController.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 5/12/2565 BE.
//

import UIKit
import PopupDialog
import LGButton
import RAMAnimatedTabBarController

class OTPVerifyViewController: UIViewController {

    @IBOutlet weak var btnResendOTP: UIButton!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var TFotpCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelEmail.text = UserDefaults.standard.string(forKey: "RailTrip_AuthData_Email")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLoginSubmit(_ sender: LGButton) {
        //config
        sender.isLoading = true
//        loadingstatus.toggle()
        var pass = true
        let input = TFotpCode.text ?? ""
        //validate
        if !utilsValidator().isEmpty(input: input) {
            pass.toggle()
            self.present(utilsAlert().AlertWithDisableButton(
                title: "OTP Code field is required",
                message: "Please Try again",
                buttontext: "Ok"
            ), animated: true, completion: nil)
        }
        if !utilsValidator().isOTPCode(input: input) {
            pass.toggle()
            self.present(utilsAlert().AlertWithDisableButton(
                title: "Invalid OTP Code format",
                message: "Please Try again",
                buttontext: "Ok"
            ), animated: true, completion: nil)
            
        }

        if pass {
            utilsAPIConnect().Login(email: UserDefaults.standard.string(forKey: "RailTrip_AuthData_Email") ?? "", ref_id: UserDefaults.standard.string(forKey: "RailTrip_AuthData_RefID") ?? "", otp_code: input ) { response,statusCode,error in
                switch(error){
                case false:
                    switch(statusCode){
                    case 200:
                        UserDefaults.standard.set(UserDefaults.standard.string(forKey: "RailTrip_AuthData_Email")!, forKey: "RailTrip_User_Email")
                        UserDefaults.standard.set(response?.data?.name, forKey: "RailTrip_User_Name")
                        UserDefaults.standard.set(response?.data?.token, forKey: "RailTrip_User_Token")
                        UserDefaults.standard.removeObject(forKey: "RailTrip_AuthData_RefID")
                        UserDefaults.standard.removeObject(forKey: "RailTrip_AuthData_Email")
                        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        guard let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController_ID") as? RAMAnimatedTabBarController else {
                           return
                       }
                        mainVC.modalPresentationStyle = .fullScreen
                        mainVC.modalTransitionStyle = .crossDissolve
                
                        self.present(mainVC, animated: true, completion: nil)
                        break
                    default:
                        self.present(utilsAlert().AlertWithDisableButton(
                            title: response?.message ?? "",
                            message: "Please Try again",
                            buttontext: "Ok"
                        ), animated: true, completion: nil)
                        break
                    }
                    break
                case true:
                    self.present(utilsAlert().AlertWithDisableButton(
                        title: "Internal Server Error",
                        message: "Please Try again",
                        buttontext: "Ok"
                    ), animated: true, completion: nil)
                    break
                }
                sender.isLoading = false
            }
        }else{
            sender.isLoading = false
        }
    }
    
    @IBAction func btnResendOTP(_ sender: Any) {
        btnResendOTP.isHidden = true
        utilsAPIConnect().RequestOTP(email: UserDefaults.standard.string(forKey: "RailTrip_AuthData_Email")!) { reponse,statusCode,error in
            switch(error){
            case false:
                switch(statusCode){
                case 200:
                    UserDefaults.standard.set(String(reponse?.data?.refID ?? ""), forKey: "RailTrip_AuthData_RefID")
                    self.btnResendOTP.isHidden = false
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
            case true:
                self.present(utilsAlert().AlertWithDisableButton(
                    title: "Internal Server Error",
                    message: "Please Try again",
                    buttontext: "Ok"
                ), animated: true, completion: nil)
                break
            }
        }
        self.btnResendOTP.isHidden = false
    }

}
