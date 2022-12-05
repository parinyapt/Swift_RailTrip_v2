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
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "en"
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
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "en"
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
    
    struct ListEndStationResponse: Codable {
        let LinePlatform: String
        let LineName: String
        let StationCode:String
        let StationName:String
        let StationMinPrice:Int
        let StationMinTime:Int
        let StationMinStation:Int
        
        enum CodingKeys: String, CodingKey {
            case LinePlatform = "line_platform"
            case LineName = "line_name"
            case StationCode = "station_code"
            case StationName = "station_name"
            case StationMinPrice = "station_min_price"
            case StationMinTime = "station_min_time"
            case StationMinStation = "station_min_station"
        }
    }
    func ListEndStation(StartStationCode:String, EndStationLineID:Int, Sortby:String?, completion: @escaping (DefaultAPIResponse<[ListEndStationResponse]>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<[ListEndStationResponse]>
        let url = "\(BASE_URL)/route/list-to-station/\(StartStationCode)/\(EndStationLineID)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "RailTrip_User_Token") ?? "")",
            "Accept": "application/json",
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "en"
        ]
        
        let parameters: [String: String] = [
            "sort": Sortby ?? "price",
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder.default,
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
    
    struct ListAllRouteResponse: Codable {
        let fromLinePlatform, fromLineName, fromStationCode, fromStationName: String
        let toLinePlatform, toLineName, toStationCode, toStationName: String
        let minPrice, minTime, minStation: Int
        let route: [Route]
        
        enum CodingKeys: String, CodingKey {
            case fromLinePlatform = "from_line_platform"
            case fromLineName = "from_line_name"
            case fromStationCode = "from_station_code"
            case fromStationName = "from_station_name"
            case toLinePlatform = "to_line_platform"
            case toLineName = "to_line_name"
            case toStationCode = "to_station_code"
            case toStationName = "to_station_name"
            case minPrice = "min_price"
            case minTime = "min_time"
            case minStation = "min_station"
            case route
        }
        
        struct Route: Codable {
            let routeID: Int
            let platform: [String]
            let price, time, station: Int

            enum CodingKeys: String, CodingKey {
                case routeID = "route_id"
                case platform, price, time, station
            }
        }
    }
    func ListAllRoute(StartStationCode:String, EndStationCode:String, completion: @escaping (DefaultAPIResponse<ListAllRouteResponse>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<ListAllRouteResponse>
        let url = "\(BASE_URL)/route/list/\(StartStationCode)/\(EndStationCode)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "RailTrip_User_Token") ?? "")",
            "Accept": "application/json",
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "en"
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
    
    struct RouteDetailResponse: Codable {
        let fromLinePlatform, fromLineName, fromStationCode, fromStationName: String
        let toLinePlatform, toLineName, toStationCode, toStationName: String
        let minPrice, minTime, minStation: Int
        let stationList: [StationList]
        
        enum CodingKeys: String, CodingKey {
            case fromLinePlatform = "from_line_platform"
            case fromLineName = "from_line_name"
            case fromStationCode = "from_station_code"
            case fromStationName = "from_station_name"
            case toLinePlatform = "to_line_platform"
            case toLineName = "to_line_name"
            case toStationCode = "to_station_code"
            case toStationName = "to_station_name"
            case minPrice = "min_price"
            case minTime = "min_time"
            case minStation = "min_station"
            case stationList = "station_list"
        }
        
        struct StationList: Codable {
            let LinePlatform: String
            let StationCode: String
            let StationName: String

            enum CodingKeys: String, CodingKey {
                case LinePlatform = "line_platform"
                case StationCode = "station_code"
                case StationName = "station_name"
            }
        }
    }
    func RouteDetail(RouteID:Int, completion: @escaping (DefaultAPIResponse<RouteDetailResponse>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<RouteDetailResponse>
        let url = "\(BASE_URL)/route/detail/\(RouteID)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "RailTrip_User_Token") ?? "")",
            "Accept": "application/json",
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "en"
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
    
    struct ListTripPlaceResponse: Codable {
        let placeID, placeName, placeLatitude, placeLongitude: String
        let placeDistance: String
        let placeImage: String

        enum CodingKeys: String, CodingKey {
            case placeID = "place_id"
            case placeName = "place_name"
            case placeLatitude = "place_latitude"
            case placeLongitude = "place_longitude"
            case placeDistance = "place_distance"
            case placeImage = "place_image"
        }
    }
    func ListTripPlace(RouteID:Int, completion: @escaping (DefaultAPIResponse<[ListTripPlaceResponse]>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<[ListTripPlaceResponse]>
        let url = "\(BASE_URL)/trip/place/\(RouteID)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "RailTrip_User_Token") ?? "")",
            "Accept": "application/json",
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "en"
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
    
    func CreateTrip(name:String,routeID:String,placeID:String, completion: @escaping (DefaultAPIResponse<String>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<String>
        let url = "\(BASE_URL)/trip/"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "RailTrip_User_Token") ?? "")",
            "Accept": "application/json",
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "en"
        ]
        
        let parameters: [String: String] = [
            "name": name,
            "route_id": routeID,
            "place_id": placeID,
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
    
    struct ListTripResponse: Codable {
        let fromLinePlatform, fromLineName, fromStationCode, fromStationName: String
        let toLinePlatform, toLineName, toStationCode, toStationName: String
        let Price, Time, Station: Int
        let tripName:String
        let tripID:Int
        
        enum CodingKeys: String, CodingKey {
            case fromLinePlatform = "from_line_platform"
            case fromLineName = "from_line_name"
            case fromStationCode = "from_station_code"
            case fromStationName = "from_station_name"
            case toLinePlatform = "to_line_platform"
            case toLineName = "to_line_name"
            case toStationCode = "to_station_code"
            case toStationName = "to_station_name"
            case Price = "price"
            case Time = "time"
            case Station = "station"
            case tripName = "trip_name"
            case tripID = "trip_id"
        }
    }
    func ListTrip(completion: @escaping (DefaultAPIResponse<[ListTripResponse]>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<[ListTripResponse]>
        let url = "\(BASE_URL)/trip/"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "RailTrip_User_Token") ?? "")",
            "Accept": "application/json",
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "en"
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
    
    struct TripDetailResponse: Codable {
        let fromLinePlatform, fromLineName, fromStationCode, fromStationName: String
        let toLinePlatform, toLineName, toStationCode, toStationName: String
        let Price, Time, Station: Int
        let tripName:String
        let placeDetail:[PlaceDetail]
        
        enum CodingKeys: String, CodingKey {
            case fromLinePlatform = "from_line_platform"
            case fromLineName = "from_line_name"
            case fromStationCode = "from_station_code"
            case fromStationName = "from_station_name"
            case toLinePlatform = "to_line_platform"
            case toLineName = "to_line_name"
            case toStationCode = "to_station_code"
            case toStationName = "to_station_name"
            case Price = "price"
            case Time = "time"
            case Station = "station"
            case tripName = "trip_name"
            case placeDetail = "place_detail"
        }
        
        struct PlaceDetail: Codable {
            let lineID: Int
            let linePlatform, lineColor, lineName: String
            let stationID: Int
            let stationCode, stationName, placeID, placeName: String
            let placeLatitude, placeLongitude, placeDistance: String
            let placeImage: String

            enum CodingKeys: String, CodingKey {
                case lineID = "line_id"
                case linePlatform = "line_platform"
                case lineColor = "line_color"
                case lineName = "line_name"
                case stationID = "station_id"
                case stationCode = "station_code"
                case stationName = "station_name"
                case placeID = "place_id"
                case placeName = "place_name"
                case placeLatitude = "place_latitude"
                case placeLongitude = "place_longitude"
                case placeDistance = "place_distance"
                case placeImage = "place_image"
            }
        }
    }
    func TripDetail(TripID:Int, completion: @escaping (DefaultAPIResponse<TripDetailResponse>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<TripDetailResponse>
        let url = "\(BASE_URL)/trip/\(TripID)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "RailTrip_User_Token") ?? "")",
            "Accept": "application/json",
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "en"
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
    
    func DeleteTrip(TripID:Int, completion: @escaping (DefaultAPIResponse<String>?, Int, Bool) -> Void) {
        typealias reponseStruct = DefaultAPIResponse<String>
        let url = "\(BASE_URL)/trip/\(TripID)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "RailTrip_User_Token") ?? "")",
            "Accept": "application/json",
            "Accept-Language": UserDefaults.standard.string(forKey: "RailTrip_User_Language") ?? "en"
        ]
        
        AF.request(
            url,
            method: .delete,
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
