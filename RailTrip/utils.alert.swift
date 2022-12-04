//
//  utils.alert.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 5/12/2565 BE.
//

import Foundation
import PopupDialog

class utilsAlert {
    func AlertWithDisableButton(title:String,message:String,buttontext:String) -> PopupDialog {

        let buttonOne = CancelButton(title: buttontext) {
            print("click disable button")
        }
        
        let popup = PopupDialog(title: title, message: message)
        popup.addButtons([buttonOne])
        
        return popup

    }
}
