//
//  ShareSelectStartStationViewController.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 6/12/2565 BE.
//

import UIKit

class ShareSelectStartStationViewController: UIViewController {

    @IBOutlet weak var tableViewInstance: UITableView!
    
    var apiDataArray = [[String:String]]()
    
    var select_line_id:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableViewInstance.dataSource = self
        tableViewInstance.delegate = self
        tableViewInstance.rowHeight = 70
        
        InitSetupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "RailTrip_Temp_PreferModeStatus") == "true" {
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func btnSelectLine(_ sender: UIButton) {
        select_line_id = sender.tag
        InitSetupTableView()
    }
    
    func InitSetupTableView() {
        apiDataArray.removeAll()
        self.apiDataArray.removeAll()
        utilsAPIConnect().Station(lineID: self.select_line_id) { response,statusCode,error in
            switch(error){
            case false:
                switch(statusCode){
                case 200:
                    print("200")
                    for data in response?.data ?? [] {
                        let temp:[String:String] = [
                            "StationCode": data.StationCode,
                            "StationName": data.StationName,
                            "Platform": data.Platform,
                            "StationID": String(data.StationID),
                        ]
                        self.apiDataArray.append(temp)
                    }
                    self.tableViewInstance.reloadData()
                    break
                default:
                    print("default")
                    self.present(utilsAlert().AlertWithDisableButton(
                        title: "Error Occured",
                        message: response?.message ?? "",
                        buttontext: "cancel"
                    ), animated: true, completion: nil)
                    self.InitSetupTableView()
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
                self.InitSetupTableView()
                break
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension ShareSelectStartStationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiDataArray.count
    }
}

extension ShareSelectStartStationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewInstance.dequeueReusableCell(withIdentifier: "ShareSelectStartStationTableViewCell_ID", for: indexPath) as! ShareSelectStartStationTableViewCell
        cell.config(
            Platform: apiDataArray[indexPath.item]["Platform"] ?? "",
            StationCode: apiDataArray[indexPath.item]["StationCode"] ?? "",
            StationName: apiDataArray[indexPath.item]["StationName"] ?? ""
        )

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(self.apiDataArray[indexPath.item]["StationCode"] ?? "", forKey: "RailTrip_Temp_Start_Station")
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "ShareSelectEndStationViewController_ID") as? ShareSelectEndStationViewController else {
           return
       }

        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve

        self.present(mainVC, animated: true, completion: nil)
    }
}
