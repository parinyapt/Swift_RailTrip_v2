//
//  RouteDetailViewController.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 6/12/2565 BE.
//

import UIKit

class RouteDetailViewController: UIViewController {
    
    var apiDataSingle:[String:String] = [:]
    var apiDataArray = [[String:String]]()
    
    var get_routeID:Int = Int(UserDefaults.standard.string(forKey: "RailTrip_Temp_RouteID") ?? "") ?? 0

    @IBOutlet weak var LBStartStationName: UILabel!
    @IBOutlet weak var LBStartPlatform: UILabel!
    @IBOutlet weak var LBStartStationCode: UILabel!
    
    @IBOutlet weak var LBEndStationName: UILabel!
    @IBOutlet weak var LBEndStationPlatform: UILabel!
    @IBOutlet weak var LBEndStationCode: UILabel!
    
    @IBOutlet weak var LBPrice: UILabel!
    @IBOutlet weak var LBTime: UILabel!
    @IBOutlet weak var LBStation: UILabel!
    
    @IBOutlet weak var tableViewInstance: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewInstance.dataSource = self
        tableViewInstance.delegate = self
        tableViewInstance.rowHeight = 50
        // Do any additional setup after loading the view.
        InitSetup()
    }
    
    func InitSetupSingleData() {
        LBStartStationName.text = self.apiDataSingle["fromStationName"]
        LBStartPlatform.text = self.apiDataSingle["fromLinePlatform"]
        LBStartStationCode.text = self.apiDataSingle["fromStationCode"]
        
        LBEndStationName.text = self.apiDataSingle["toStationName"]
        LBEndStationPlatform.text = self.apiDataSingle["toLinePlatform"]
        LBEndStationCode.text = self.apiDataSingle["toStationCode"]
        
        LBPrice.text = self.apiDataSingle["Price"]
        LBTime.text = self.apiDataSingle["Time"]
        LBStation.text = self.apiDataSingle["Station"]
    }
    
    func InitSetup() {
        apiDataSingle.removeAll()
        apiDataArray.removeAll()
        utilsAPIConnect().RouteDetail(RouteID: get_routeID) { response,statusCode,error in
            switch(error){
            case false:
                switch(statusCode){
                case 200:
                    print("200")
                    self.apiDataSingle["fromStationName"] = response?.data?.fromStationName ?? ""
                    self.apiDataSingle["fromLinePlatform"] = response?.data?.fromLinePlatform ?? ""
                    self.apiDataSingle["fromStationCode"] = response?.data?.fromStationCode ?? ""
                    self.apiDataSingle["toStationName"] = response?.data?.toStationName ?? ""
                    self.apiDataSingle["toLinePlatform"] = response?.data?.toLinePlatform ?? ""
                    self.apiDataSingle["toStationCode"] = response?.data?.toStationCode ?? ""
                    
                    self.apiDataSingle["Price"] = String(response?.data?.minPrice ?? 0)
                    self.apiDataSingle["Time"] = String(response?.data?.minTime ?? 0)
                    self.apiDataSingle["Station"] = String(response?.data?.minStation ?? 0)
                    
                    for data in response?.data?.stationList ?? [] {
                        let temp:[String:String] = [
                            "LinePlatform": data.LinePlatform,
                            "StationCode": data.StationCode,
                            "StationName": data.StationName,
                        ]
                        self.apiDataArray.append(temp)
                    }
                    
                    self.tableViewInstance.reloadData()
                    self.InitSetupSingleData()
                    break
                default:
                    print("default")
                    self.present(utilsAlert().AlertWithDisableButton(
                        title: "Error Occured",
                        message: response?.message ?? "",
                        buttontext: "cancel"
                    ), animated: true, completion: nil)
                    self.InitSetup()
                    break
                }
                break
            case true:
                print("error")
                self.present(utilsAlert().AlertWithDisableButton(
                    title: "Error Occured",
                    message: response?.message ?? "",
                    buttontext: "cancel"
                ), animated: true, completion: nil)
                self.InitSetup()
                break
            }
        }
        
       
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }

}

extension RouteDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiDataArray.count
    }
}

extension RouteDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewInstance.dequeueReusableCell(withIdentifier: "RouteDetailTableViewCell_ID", for: indexPath) as! RouteDetailTableViewCell
        cell.config(
            image: self.apiDataArray[indexPath.item]["LinePlatform"] ?? "",
            platform: self.apiDataArray[indexPath.item]["LinePlatform"] ?? "",
            stationCode: self.apiDataArray[indexPath.item]["StationCode"] ?? "",
            stationName: self.apiDataArray[indexPath.item]["StationName"] ?? ""
        )

        return cell
    }
    
}

