//
//  TripDetailTableViewCell.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 5/12/2565 BE.
//

import UIKit

class TripDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var ImagePF: UIImageView!
    @IBOutlet weak var LBPlatform: UILabel!
    @IBOutlet weak var LBStationCode: UILabel!
    @IBOutlet weak var LBStationName: UILabel!
    @IBOutlet weak var LBdistance: UILabel!
    @IBOutlet weak var LBPlaceName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
    func config(Platform:String,StationCode:String,StationName:String,distance:String,PlaceName:String){
        ImagePF.image = UIImage(named: Platform)
        LBPlatform.text = Platform
        LBStationCode.text = StationCode
        LBStationName.text = StationName
        LBdistance.text = distance
        LBPlaceName.text = PlaceName
    }

}
