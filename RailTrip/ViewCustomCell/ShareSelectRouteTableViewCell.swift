//
//  ShareSelectRouteTableViewCell.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 6/12/2565 BE.
//

import UIKit

class ShareSelectRouteTableViewCell: UITableViewCell {

    @IBOutlet weak var LBstation: UILabel!
    @IBOutlet weak var LBtime: UILabel!
    @IBOutlet weak var LBprice: UILabel!
    
    @IBOutlet weak var IMG1: UIImageView!
    @IBOutlet weak var IMG2: UIImageView!
    @IBOutlet weak var IMG3: UIImageView!
    @IBOutlet weak var IMG4: UIImageView!
    @IBOutlet weak var IMG5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(price:Int,time:Int,station:Int,image:[String]) {
        LBprice.text = String(price)
        LBtime.text = String(time)
        LBstation.text = String(station)
        
        if image.count >= 1 {
            IMG1.image = UIImage(named: image[0])
        }
        if image.count >= 2 {
            IMG2.image = UIImage(named: image[1])
        }
        if image.count >= 3 {
            IMG3.image = UIImage(named: image[2])
        }
        if image.count >= 4 {
            IMG4.image = UIImage(named: image[3])
        }
        if image.count >= 5 {
            IMG5.image = UIImage(named: image[4])
        }
    }

}
