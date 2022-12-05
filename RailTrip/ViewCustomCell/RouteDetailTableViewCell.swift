//
//  RouteDetailTableViewCell.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 6/12/2565 BE.
//

import UIKit

class RouteDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var LBstationName: UILabel!
    @IBOutlet weak var LBstationCode: UILabel!
    @IBOutlet weak var LBplatform: UILabel!
    @IBOutlet weak var PFImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(image:String, platform:String, stationCode:String, stationName:String) {
        LBplatform.text = platform
        LBstationCode.text = stationCode
        LBstationName.text = stationName
        PFImage.image = UIImage(named: image)
    }

}
