//
//  ShareSelectEndStationTableViewCell.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 6/12/2565 BE.
//

import UIKit

class ShareSelectEndStationTableViewCell: UITableViewCell {

    @IBOutlet weak var LBplatform: UILabel!
    @IBOutlet weak var LBStationCode: UILabel!
    @IBOutlet weak var LBStationName: UILabel!
    @IBOutlet weak var PlatformImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(Platform:String,StationCode:String,StationName:String) {
        PlatformImage.image = UIImage(named: Platform)
        LBStationName.text = StationName
        LBStationCode.text = StationCode
        LBplatform.text = Platform
    }

}
