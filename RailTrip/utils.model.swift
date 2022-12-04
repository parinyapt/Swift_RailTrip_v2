//
//  utils.model.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 4/12/2565 BE.
//

import Foundation

struct DefaultAPIResponse<DataStruct: Codable>: Codable {
    let success: Bool
    let message: String
    let errorCode: String
    let data: DataStruct? = nil
    
    enum CodingKeys: String, CodingKey {
        case success,message,data
        case errorCode = "error_code"
    }
}

struct DefaultAPIResponseError: Codable {
    let success: Bool
    let message: String
    let errorCode: String
    let data: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case success,message,data
        case errorCode = "error_code"
    }
}
