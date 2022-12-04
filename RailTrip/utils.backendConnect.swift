//
//  utils.backendConnect.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 4/12/2565 BE.
//

import Foundation
import Alamofire

class BackendConnect {
    let BASE_URL = "https://railtrip-api.prinpt.com/api/v1"
    let API_VERSION = "v1"
    
    struct RequestOTPResponse: Codable {
        let refID: String
        let status: String
        
        enum CodingKeys: String, CodingKey {
            case status
            case refID = "ref_id"
        }
    }
    
    func RequestOTP(email:String, completion: @escaping (DefaultAPIResponse<RequestOTPResponse>?, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<RequestOTPResponse>
        let url = "\(BASE_URL)/auth/request-otp"
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
        ]
        
        let parameters: [String: String] = [
            "email": email
        ]
        
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: headers
        ).responseDecodable(of: reponseStruct.self) { response in
            switch(response.result){
            case .success:
                completion(response.value,false)
                break
            case .failure:
                completion(response.value,true)
                break
            }
        }
    }
}
