//
//  utils.validator.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 4/12/2565 BE.
//

import Foundation
import SwiftValidators

class utilsValidator {
    
    func isEmail(input:String) -> Bool {
        return Validator.isEmail().apply(input)
    }
    
    func isEmpty(input:String) -> Bool {
        return Validator.required().apply(input)
    }
    
    func isText(input:String) -> Bool {
        return Validator.isAlpha().apply(input)
    }
    
    func isOTPCode(input:String) -> Bool {
        return Validator.isNumeric().apply(input) && Validator.exactLength(6).apply(input)
    }
}
