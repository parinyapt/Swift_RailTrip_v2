//
//  RegisterViewController.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 5/12/2565 BE.
//

import UIKit
import LGButton
import PopupDialog

class RegisterViewController: UIViewController {

    @IBOutlet weak var TFname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnNameSubmit(_ sender: LGButton) {
        //config
        sender.isLoading = true
//        loadingstatus.toggle()
        var pass = true
        let input = TFname.text ?? ""
        //validate
        if !utilsValidator().isEmpty(input: input) {
            pass.toggle()
            self.present(utilsAlert().AlertWithDisableButton(
                title: "Name field is required",
                message: "Please Try again",
                buttontext: "Ok"
            ), animated: true, completion: nil)
        }
        if !utilsValidator().isText(input: input.replacingOccurrences(of: " ", with: "")) {
            pass.toggle()
            self.present(utilsAlert().AlertWithDisableButton(
                title: "Invalid name format",
                message: "Please Try again",
                buttontext: "Ok"
            ), animated: true, completion: nil)
        }
        
        if pass {
            utilsAPIConnect().Register(ref_id: UserDefaults.standard.string(forKey: "RailTrip_AuthData_RefID") ?? "", name: input) { reponse,statusCode,error in
                switch(error){
                case false:
                    switch(statusCode){
                    case 200:
                        //login redirect to otp verify page
                        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        guard let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "OTPVerifyViewController_ID") as? OTPVerifyViewController else {
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

}
