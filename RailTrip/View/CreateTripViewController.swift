//
//  CreateTripViewController.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 6/12/2565 BE.
//

import UIKit

class CreateTripViewController: UIViewController {

    var apiDataArray = [[String:String]]()
    var selectPlace:[String] = []
    
    var get_routeID:Int = Int(UserDefaults.standard.string(forKey: "RailTrip_Temp_RouteID") ?? "") ?? 0
    
    @IBOutlet weak var tableViewInstance: UITableView!
    
    @IBOutlet weak var TFtripName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewInstance.dataSource = self
        tableViewInstance.delegate = self
        tableViewInstance.rowHeight = 70
        // Do any additional setup after loading the view.
        InitSetup()
    }
    
    func InitSetup() {
        apiDataArray.removeAll()
        selectPlace.removeAll()
        utilsAPIConnect().ListTripPlace(RouteID: get_routeID) { response,statusCode,error in
            switch(error){
            case false:
                switch(statusCode){
                case 200:
                    print("200")
                    
                    for data in response?.data ?? [] {
                        let temp:[String:String] = [
                            "placeID": data.placeID,
                            "placeName": data.placeName,
                            "placeDistance": data.placeDistance,
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
    
    @IBAction func btnSaveTrip(_ sender: Any) {
        let input = TFtripName.text ?? ""
        //validate
        if !utilsValidator().isEmpty(input: input) {
            self.present(utilsAlert().AlertWithDisableButton(
                title: "Trip name field is required",
                message: "Please Try again",
                buttontext: "Ok"
            ), animated: true, completion: nil)
            return
        }
        if !utilsValidator().isText(input: input.replacingOccurrences(of: " ", with: "")) {
            self.present(utilsAlert().AlertWithDisableButton(
                title: "Invalid trip name format",
                message: "Please Try again",
                buttontext: "Ok"
            ), animated: true, completion: nil)
            return
        }
        if selectPlace.count == 0 {
            self.present(utilsAlert().AlertWithDisableButton(
                title: "Select Place is required",
                message: "Please Try again",
                buttontext: "Ok"
            ), animated: true, completion: nil)
            return
        }
        
        var placefordb:String = ""
        for id in selectPlace {
            placefordb += "\(id),"
        }
        
        utilsAPIConnect().CreateTrip(name: input, routeID: String(get_routeID), placeID: placefordb) { reponse,statusCode,error in
            switch(error){
            case false:
                switch(statusCode){
                case 200:
                    UserDefaults.standard.set("true", forKey: "RailTrip_Temp_PreferModeStatus")
                    self.dismiss(animated: false)
                    
                    break
                default:
                    self.present(utilsAlert().AlertWithDisableButton(
                        title: reponse?.message ?? "",
                        message: "Please Try again",
                        buttontext: "Ok"
                    ), animated: true, completion: nil)
                    break
                }
                
                break
            case true:
                self.present(utilsAlert().AlertWithDisableButton(
                    title: "Internal Server Error",
                    message: "Please Try again",
                    buttontext: "Ok"
                ), animated: true, completion: nil)
                break
            }
        }
    
        
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension CreateTripViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiDataArray.count
    }
}

extension CreateTripViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewInstance.dequeueReusableCell(withIdentifier: "CreateTripTableViewCell_ID", for: indexPath) as! CreateTripTableViewCell
        cell.config(
            selectarray: selectPlace,
            placename: self.apiDataArray[indexPath.item]["placeName"] ?? "",
            placeid: self.apiDataArray[indexPath.item]["placeID"] ?? ""
        )
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pid = self.apiDataArray[indexPath.item]["placeID"] ?? ""
        print(pid)
        if selectPlace.contains(pid) {
            if let index = selectPlace.firstIndex(of: pid) {
                print("Index of '\(pid)' is \(index).")
                selectPlace.remove(at: index)
            }
        }else{
            selectPlace.append(pid)
        }
        self.tableViewInstance.reloadData()
    }
    
}
