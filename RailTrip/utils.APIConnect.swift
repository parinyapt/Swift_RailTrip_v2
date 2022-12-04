//
//  utils.backendConnect.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 4/12/2565 BE.
//

import Foundation
import Alamofire

class utilsAPIConnect {
    let BASE_URL = "https://railtrip-api.prinpt.com/api/v1"
    
    struct RequestOTPResponse: Codable {
        let refID: String
        let status: String
        
        enum CodingKeys: String, CodingKey {
            case status
            case refID = "ref_id"
        }
    }
    func RequestOTP(email:String, completion: @escaping (DefaultAPIResponse<RequestOTPResponse>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<RequestOTPResponse>
//        typealias responseError = DefaultAPIResponseError
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
                completion(response.value,response.response?.statusCode ?? 0,false)
                break
            case .failure:
//                do {
//                    let rawdata = String(data: response.data!, encoding: String.Encoding.utf8)
//                    let responsedata = try JSONDecoder().decode(responseError.self, from: Data(rawdata!.utf8))
//                    completion(nil,responsedata,true)
//                }catch{
//                    print(error.localizedDescription)
//                    completion(nil,nil,true)
//                }
                completion(nil,response.response?.statusCode ?? 0,true)
                break
            }
        }
    }
    
    func Register(ref_id:String,name:String, completion: @escaping (DefaultAPIResponse<String>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<String>
        let url = "\(BASE_URL)/auth/register"
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
        ]
        
        let parameters: [String: String] = [
            "ref_id": ref_id,
            "name": name
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
                completion(response.value,response.response?.statusCode ?? 0,false)
                break
            case .failure:
                completion(nil,response.response?.statusCode ?? 0,true)
                break
            }
        }
    }
    
    struct LoginResponse: Codable {
        let token: String
        let name: String
        
//        enum CodingKeys: String, CodingKey {
//            case status
//            case refID = "ref_id"
//        }
    }
    func Login(email:String,ref_id:String, otp_code:String, completion: @escaping (DefaultAPIResponse<LoginResponse>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<LoginResponse>
        let url = "\(BASE_URL)/auth/login"
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
        ]
        
        let parameters: [String: String] = [
            "ref_id": ref_id,
            "email": email,
            "otp_code": otp_code
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
                completion(response.value,response.response?.statusCode ?? 0,false)
                break
            case .failure:
                completion(nil,response.response?.statusCode ?? 0,true)
                break
            }
        }
    }
}
