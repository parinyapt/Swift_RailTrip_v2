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
//    let BASE_URL = "localhost:9000/api/v1"
    
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
    
    struct LineResponse: Codable {
        let LineID: Int
        let LinePlatform: String
        let LineColor: String
        let LineName: String
        
        enum CodingKeys: String, CodingKey {
            case LineID  = "line_id"
            case LinePlatform = "line_platform"
            case LineColor = "line_color"
            case LineName = "line_name"
        }
    }
    func Line(completion: @escaping (DefaultAPIResponse<[LineResponse]>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<[LineResponse]>
        let url = "\(BASE_URL)/line"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "RailTrip_User_Token") ?? "")",
            "Accept": "application/json",
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "th"
        ]
        
        AF.request(
            url,
            method: .get,
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
    
    struct StationResponse: Codable {
        let StationID:Int
        let StationCode:String
        let StationName:String
        let StationLatitude:String
        let StationLongitude:String
        let StationGoogleMap:String
        let StationImage:String
        
        enum CodingKeys: String, CodingKey {
            case StationID = "station_id"
            case StationCode = "station_code"
            case StationName = "station_name"
            case StationLatitude = "station_latitude"
            case StationLongitude = "station_longitude"
            case StationGoogleMap = "station_googlemap"
            case StationImage = "station_image"
        }
    }
    func Station(lineID:Int, completion: @escaping (DefaultAPIResponse<[StationResponse]>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<[StationResponse]>
        let url = "\(BASE_URL)/station/\(lineID)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "RailTrip_User_Token") ?? "")",
            "Accept": "application/json",
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "th"
        ]
        
        AF.request(
            url,
            method: .get,
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
    
    struct StationDetailResponse: Codable {
        let StationID:Int
        let StationCode:String
        let StationName:String
        let StationLatitude:String
        let StationLongitude:String
        let StationGoogleMap:String
        let StationImage:String
        let StationExit:[StationDetailExit]
        let StationFacility:[StationDetailFacility]
        let StationLink:[StationDetailLink]?
        
        enum CodingKeys: String, CodingKey {
            case StationID = "station_id"
            case StationCode = "station_code"
            case StationName = "station_name"
            case StationLatitude = "station_latitude"
            case StationLongitude = "station_longitude"
            case StationGoogleMap = "station_googlemap"
            case StationImage = "station_image"
            case StationExit = "station_exit"
            case StationFacility = "station_facility"
            case StationLink = "station_link"
        }
        
        struct StationDetailExit: Codable{
            let ExitNumber:String
            let ExitName:String
            
            enum CodingKeys: String, CodingKey {
                case ExitNumber = "exit_number"
                case ExitName = "exit_name"
            }
        }
        
        struct StationDetailFacility: Codable{
            let FacilityIcon:String
            let FacilityName:String
            
            enum CodingKeys: String, CodingKey {
                case FacilityIcon = "facility_icon"
                case FacilityName = "facility_name"
            }
        }
        
        struct StationDetailLink: Codable {
            let StationCode:String
            let StationName:String
            let LinePlatform: String
            let LineName: String
            
            enum CodingKeys: String, CodingKey {
                case StationCode = "station_code"
                case StationName = "station_name"
                case LinePlatform = "line_platform"
                case LineName = "line_name"
            }
        }
    }
    func StationDetail(stationID:Int, completion: @escaping (DefaultAPIResponse<StationDetailResponse>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<StationDetailResponse>
        let url = "\(BASE_URL)/station/detail/\(stationID)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "RailTrip_User_Token") ?? "")",
            "Accept": "application/json",
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "th"
        ]
        
        AF.request(
            url,
            method: .get,
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
