//
//  TripVC.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 5/12/2565 BE.
//

import UIKit

class TripListCell: UITableViewCell {

    @IBOutlet weak var LBtripName: UILabel!
    @IBOutlet weak var LBfromPlatform: UILabel!
    @IBOutlet weak var LBfromStation: UILabel!
    @IBOutlet weak var LBtoPlatform: UILabel!
    @IBOutlet weak var LBtoStation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(name:String, fromPlatform:String, fromStation:String, toPlatform:String, toStation:String){
        LBtripName.text = name
        LBfromPlatform.text = fromPlatform
        LBfromStation.text = fromStation
        LBtoPlatform.text = toPlatform
        LBtoStation.text = toStation
    }

}
