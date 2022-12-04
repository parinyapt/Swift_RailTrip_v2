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
}
