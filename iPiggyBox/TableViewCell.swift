//
//  TableViewCell.swift
//  iPiggyBox
//
//  Created by Maxim  Grozniy on 04.06.16.
//  Copyright © 2016 Maxim  Grozniy. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rating: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ dataCell: Targets) {
        let id = Int(dataCell.id!)
        
        img.image = UIImage(data: dataCell.picture! as Data)
        nameLabel.text = dataCell.productName
        priceLabel.text = Int(dataCell.price!).description
        rating.text = "\((Support.getReadySum(id) * 100) / Int(dataCell.price!)) %"
    }
    

}
