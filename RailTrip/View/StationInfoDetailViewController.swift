//
//  StationInfoDetailViewController.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 5/12/2565 BE.
//

import UIKit
import Kingfisher
import RAMAnimatedTabBarController

class StationInfoDetailViewController: UIViewController {
    
    var get_station_id:Int = 0
    var select_type:String = "facility"
    
    var apiDataSingle:[String:String] = [:]
    var apiDataArray = [String:[[String:String]]]()
    
    @IBOutlet weak var LBstationName: UILabel!
    @IBOutlet weak var StationImage: UIImageView!
    
    @IBOutlet weak var tableViewInstance: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableViewInstance.dataSource = self
        tableViewInstance.delegate = self
        tableViewInstance.rowHeight = 80
        
        InitSetup()
        
        
    }
    
    func InitSetupSingleData() {
        LBstationName.text = "\(apiDataSingle["StationCode"] ?? "") \(apiDataSingle["stationName"] ?? "")"
        StationImage.kf.setImage(with: URL(string: apiDataSingle["StationImage"] ?? ""))
    }
    
    func InitSetup() {
        utilsAPIConnect().StationDetail(stationID: get_station_id) { response,statusCode,error in
            switch(error){
            case false:
                switch(statusCode){
                case 200:
                    print("200")
                    self.apiDataSingle["StationCode"] = response?.data?.StationCode
                    self.apiDataSingle["stationName"] = response?.data?.StationName
                    self.apiDataSingle["StationImage"] = response?.data?.StationImage
                    self.apiDataSingle["StationGoogleMap"] = response?.data?.StationGoogleMap
                    self.apiDataArray["exit"] = []
                    self.apiDataArray["facility"] = []
                    
                    for data in response?.data?.StationExit ?? [] {
                        let temp:[String:String] = [
                            "1": data.ExitNumber,
                            "2": data.ExitName,
                        ]
                        self.apiDataArray["exit"]?.append(temp)
                    }
                    
                    for data in response?.data?.StationFacility ?? [] {
                        let temp:[String:String] = [
                            "1": data.FacilityIcon,
                            "2": data.FacilityName,
                        ]
                        self.apiDataArray["facility"]?.append(temp)
                    }
                    
                    self.InitSetupSingleData()
                    self.tableViewInstance.reloadData()
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
    
    @IBAction func segmentSelectType(_ sender: Any) {
        let s:UISegmentedControl = sender as! UISegmentedControl
//        print(s.selectedSegmentIndex)
        if s.selectedSegmentIndex == 0 {
            select_type = "facility"
        }else{
            select_type = "exit"
        }
        
        self.tableViewInstance.reloadData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func btnGoogleMap(_ sender: Any) {
        if let url = URL(string: apiDataSingle["StationGoogleMap"] ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
}

extension StationInfoDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiDataArray[select_type]?.count ?? 0
    }
}

extension StationInfoDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewInstance.dequeueReusableCell(withIdentifier: "StationInfoDetailTableViewCell_ID", for: indexPath) as! StationInfoDetailTableViewCell
        cell.config(
            type: select_type,
            title: apiDataArray[select_type]?[indexPath.item]["2"] ?? "",
            data: apiDataArray[select_type]?[indexPath.item]["1"] ?? ""
        )

        return cell
    }
}
