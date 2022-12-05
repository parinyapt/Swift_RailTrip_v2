//
//  CreateTripTableViewCell.swift
//  RailTrip
//
//  Created by Parinya Termkasipanich on 6/12/2565 BE.
//

import UIKit

class CreateTripTableViewCell: UITableViewCell {

    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var Icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(selectarray:[String], placename:String, placeid:String) {
        placeName.text = placename
        
        if selectarray.contains(placeid) {
            Icon.image = UIImage(systemName: "star.fill")
            Icon.tintColor = UIColor.systemYellow
        }else{
            Icon.image = UIImage(systemName: "star")
            Icon.tintColor = UIColor.systemGray4
        }
        
    }

}
