//
//  TripDetailViewController.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 5/12/2565 BE.
//

import UIKit
import PopupDialog
import RAMAnimatedTabBarController

class TripDetailViewController: UIViewController {
    
    var get_tripID:Int = 0
    
    var apiDataSingle:[String:String] = [:]
    var apiDataArray = [[String:String]]()

    @IBOutlet weak var LBtripName: UILabel!
    
    @IBOutlet weak var LBStartStationName: UILabel!
    @IBOutlet weak var LBStartPlatform: UILabel!
    @IBOutlet weak var LBStartStationCode: UILabel!
    
    @IBOutlet weak var LBEndStationName: UILabel!
    @IBOutlet weak var LBEndStationPlatform: UILabel!
    @IBOutlet weak var LBEndStationCode: UILabel!
    
    @IBOutlet weak var LBPrice: UILabel!
    @IBOutlet weak var LBTime: UILabel!
    @IBOutlet weak var LBStation: UILabel!
    
    @IBOutlet weak var TripDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TripDetailTableView.dataSource = self
        TripDetailTableView.delegate = self
        TripDetailTableView.rowHeight = 150
        
        InitSetupSingleData()
        InitSetupTripList()

        // Do any additional setup after loading the view.
    }
    
    func InitSetupSingleData() {
        LBtripName.text = self.apiDataSingle["tripName"]
        
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
    
    func InitSetupTripList() {
        apiDataSingle.removeAll()
        apiDataArray.removeAll()
        utilsAPIConnect().TripDetail(TripID: get_tripID) { response,statusCode,error in
            switch(error){
            case false:
                switch(statusCode){
                case 200:
                    print("200")
                    
                    self.apiDataSingle["tripName"] = response?.data?.tripName ?? ""
                    self.apiDataSingle["fromStationName"] = response?.data?.fromStationName ?? ""
                    self.apiDataSingle["fromLinePlatform"] = response?.data?.fromLinePlatform ?? ""
                    self.apiDataSingle["fromStationCode"] = response?.data?.fromStationCode ?? ""
                    self.apiDataSingle["toStationName"] = response?.data?.toStationName ?? ""
                    self.apiDataSingle["toLinePlatform"] = response?.data?.toLinePlatform ?? ""
                    self.apiDataSingle["toStationCode"] = response?.data?.toStationCode ?? ""
                    
                    self.apiDataSingle["Price"] = String(response?.data?.Price ?? 0)
                    self.apiDataSingle["Time"] = String(response?.data?.Time ?? 0)
                    self.apiDataSingle["Station"] = String(response?.data?.Station ?? 0)
                    
                    for data in response?.data?.placeDetail ?? [] {
                        let temp:[String:String] = [
                            "linePlatform": data.linePlatform,
                            "stationCode": data.stationCode,
                            "stationName": data.stationName,
                            "placeName": data.placeName,
                            "placeDistance": data.placeDistance
                        ]
                        self.apiDataArray.append(temp)
                    }
                    
                    self.TripDetailTableView.reloadData()
                    self.InitSetupSingleData()
                    break
                default:
                    print("default")
                    self.present(utilsAlert().AlertWithDisableButton(
                        title: "Error Occured",
                        message: response?.message ?? "",
                        buttontext: "cancel"
                    ), animated: true, completion: nil)
                    self.InitSetupTripList()
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
                self.InitSetupTripList()
                break
            }
        }
        
       
    }

    @IBAction func btnDeleteTrip(_ sender: Any) {
        let buttonSubmit = DefaultButton(title: "confirm", dismissOnTap: false) {
            print("click submit button")
            utilsAPIConnect().DeleteTrip(TripID: self.get_tripID) { response,statusCode,error in
                switch(error){
                case false:
                    switch(statusCode){
                    case 200:
                        print("200")
                        self.dismiss(animated: true)
                        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        guard let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController_ID") as? RAMAnimatedTabBarController else {
                           return
                       }
                        
                        mainVC.modalPresentationStyle = .fullScreen
                        mainVC.modalTransitionStyle = .crossDissolve

                        self.present(mainVC, animated: true, completion: nil)
                        break
                    default:
                        print("default")
                        self.present(utilsAlert().AlertWithDisableButton(
                            title: "Error Occured",
                            message: response?.message ?? "",
                            buttontext: "cancel"
                        ), animated: true, completion: nil)
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
                    break
                }
            }
            
        }
        let buttonCancel = CancelButton(title: "cancel") {
            print("click cancel button")
        }
        
        let popup = PopupDialog(title: "Warning", message: "Are you confirm to delete this trip")
        popup.addButtons([buttonSubmit,buttonCancel])
        self.present(popup, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnBackPage(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension TripDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiDataArray.count
    }
}

extension TripDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TripDetailTableView.dequeueReusableCell(withIdentifier: "TripDetailTableViewCell_ID", for: indexPath) as! TripDetailTableViewCell
        cell.config(
            Platform: self.apiDataArray[indexPath.item]["linePlatform"] ?? "",
            StationCode: self.apiDataArray[indexPath.item]["stationCode"] ?? "",
            StationName: self.apiDataArray[indexPath.item]["stationName"] ?? "",
            distance: String(format: "%.2f", (Float(self.apiDataArray[indexPath.item]["placeDistance"] ?? "") ?? 0)/1000),
            PlaceName: self.apiDataArray[indexPath.item]["placeName"] ?? ""
        )

        return cell
    }
}
