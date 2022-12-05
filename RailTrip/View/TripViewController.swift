//
//  TripViewController.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 5/12/2565 BE.
//

import UIKit
import SkeletonView

class TripViewController: UIViewController {
    @IBOutlet weak var welcomeMessage: UILabel!
    
    var apiData:[[String:String]] = []

    @IBOutlet weak var ListTripTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ListTripTableView.dataSource = self
        ListTripTableView.delegate = self
        ListTripTableView.rowHeight = 110
        
        
//        welcomeMessage.showAnimatedGradientSkeleton()
//        welcomeMessage.isSkeletonable = true
        
//        InitSetupTripList()
//        InitSetupWelcomeMessage()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        InitSetupTripList()
        InitSetupWelcomeMessage()
    }
    
    func InitSetupWelcomeMessage() {
        welcomeMessage.text = "Hi \(UserDefaults.standard.string(forKey: "RailTrip_User_Name") ?? "")"
//        welcomeMessage.isSkeletonable = false
    }
    
    func InitSetupTripList() {
        apiData.removeAll()
        utilsAPIConnect().ListTrip() { response,statusCode,error in
            switch(error){
            case false:
                switch(statusCode){
                case 200:
                    print("200")
                    for data in response?.data ?? [] {
                        let temp:[String:String] = [
                            "fromLinePlatform": data.fromLinePlatform,
                            "fromStationCode": data.fromStationCode,
                            "toLinePlatform": data.toLinePlatform,
                            "toStationCode": data.toStationCode,
                            "tripName": data.tripName,
                            "tripID": String(data.tripID),
                        ]
                        self.apiData.append(temp)
                    }
                    self.ListTripTableView.reloadData()
                    break
                case 404:
                    print("404")
                    break
                default:
                    print("default")
//                    print(response)
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
    
    @IBAction func btnCreateTrip(_ sender: Any) {
        UserDefaults.standard.set("createtrip", forKey: "RailTrip_Temp_PreferMode")
        UserDefaults.standard.set("false", forKey: "RailTrip_Temp_PreferModeStatus")
        UserDefaults.standard.removeObject(forKey: "RailTrip_Temp_Start_Station")
        UserDefaults.standard.removeObject(forKey: "RailTrip_Temp_End_Station")
        UserDefaults.standard.removeObject(forKey: "RailTrip_Temp_RouteID")
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "ShareSelectStartStationViewController_ID") as? ShareSelectStartStationViewController else {
           return
       }
        
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve

        self.present(mainVC, animated: true, completion: nil)
    }
    

}

extension TripViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiData.count
    }
}

extension TripViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ListTripTableView.dequeueReusableCell(withIdentifier: "TripListCell_ID", for: indexPath) as! TripListCell
        cell.config(
            name: self.apiData[indexPath.item]["tripName"] ?? "",
            fromPlatform: self.apiData[indexPath.item]["fromLinePlatform"] ?? "",
            fromStation: self.apiData[indexPath.item]["fromStationCode"] ?? "",
            toPlatform: self.apiData[indexPath.item]["toLinePlatform"] ?? "",
            toStation: self.apiData[indexPath.item]["toStationCode"] ?? ""
        )

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.apiData[indexPath.item]["tripID"]!
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "TripDetailViewController_ID") as? TripDetailViewController else {
           return
       }
        
        mainVC.get_tripID = Int(self.apiData[indexPath.item]["tripID"] ?? "")!
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve

        self.present(mainVC, animated: true, completion: nil)
    }
}
