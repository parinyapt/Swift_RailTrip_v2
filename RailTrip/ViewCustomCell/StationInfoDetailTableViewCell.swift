//
//  StationInfoDetailTableViewCell.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 5/12/2565 BE.
//

import UIKit
import Kingfisher

class StationInfoDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var DataImage: UIImageView!
    @IBOutlet weak var LBtext: UILabel!
    @IBOutlet weak var DataLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(type:String, title:String, data:String) {
        if type == "facility" {
            DataImage.isHidden = false
            DataLB.isHidden = true
            
            DataImage.kf.setImage(with: URL(string: data ))
        }else{
            DataImage.isHidden = true
            DataLB.isHidden = false
            
            DataLB.text = data
        }
        LBtext.text = title
    }

}
