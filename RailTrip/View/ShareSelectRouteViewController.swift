//
//  ShareSelectRouteViewController.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 6/12/2565 BE.
//

import UIKit

class ShareSelectRouteViewController: UIViewController {

    var apiDataSingle:[String:String] = [:]
    var apiDataArray = [[String:Int]]()
    var apiDataplatform:[[String]] = []
    
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
        tableViewInstance.rowHeight = 110
        
        InitSetupSingleData()
        InitSetup()

        // Do any additional setup after loading the view.
//        print(UserDefaults.standard.string(forKey: "RailTrip_Temp_PreferMode"))
//        print(UserDefaults.standard.string(forKey: "RailTrip_Temp_Start_Station"))
//        print(UserDefaults.standard.string(forKey: "RailTrip_Temp_End_Station"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "RailTrip_Temp_PreferModeStatus") == "true" {
            self.dismiss(animated: false)
        }
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
        apiDataplatform.removeAll()
        utilsAPIConnect().ListAllRoute(StartStationCode: UserDefaults.standard.string(forKey: "RailTrip_Temp_Start_Station") ?? "", EndStationCode: UserDefaults.standard.string(forKey: "RailTrip_Temp_End_Station") ?? "") { response,statusCode,error in
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
                    
                    for data in response?.data?.route ?? [] {
                        let temp:[String:Int] = [
                            "routeID": data.routeID,
                            "price": data.price,
                            "time": data.time,
                            "station": data.station,
                        ]
                        self.apiDataArray.append(temp)
                        self.apiDataplatform.append(data.platform)
//                        for pf in data.platform {
//                            self.apiDataplatform.append(pf)
//                        }
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

extension ShareSelectRouteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiDataArray.count
    }
}

extension ShareSelectRouteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewInstance.dequeueReusableCell(withIdentifier: "ShareSelectRouteTableViewCell_ID", for: indexPath) as! ShareSelectRouteTableViewCell
        cell.config(
            price: self.apiDataArray[indexPath.item]["price"] ?? 0,
            time: self.apiDataArray[indexPath.item]["time"] ?? 0,
            station: self.apiDataArray[indexPath.item]["station"] ?? 0,
            image: apiDataplatform[indexPath.item]
        )

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        UserDefaults.standard.set(self.apiDataArray[indexPath.item]["routeID"] ?? 0, forKey: "RailTrip_Temp_RouteID")
        
        if UserDefaults.standard.string(forKey: "RailTrip_Temp_PreferMode") == "createtrip" {
            guard let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "CreateTripViewController_ID") as? CreateTripViewController else {
               return
           }
            mainVC.modalPresentationStyle = .fullScreen
            mainVC.modalTransitionStyle = .crossDissolve

            self.present(mainVC, animated: true, completion: nil)
        }else{
            guard let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "RouteDetailViewController_ID") as? RouteDetailViewController else {
               return
           }
            mainVC.modalPresentationStyle = .fullScreen
            mainVC.modalTransitionStyle = .crossDissolve

            self.present(mainVC, animated: true, completion: nil)
        }

        
    }
}
