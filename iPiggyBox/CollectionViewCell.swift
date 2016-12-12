//
//  CollectionViewCell.swift
//  iPiggyBox
//
//  Created by Maxim  Grozniy on 11.01.16.
//  Copyright © 2016 Maxim  Grozniy. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var lad = UILabel()
    
    override func awakeFromNib() {
        layer.cornerRadius = 5
        imageViewCell.layer.cornerRadius = 5
        imageViewCell.clipsToBounds = true
        //layer.borderColor = UIColor.grayColor().CGColor
        //layer.borderWidth = 0.3
    }
    
    
    func configureCell(_ dataCell: Targets) {
        lad.removeFromSuperview()
        
        let height = imageViewCell.frame.height
        lad = UILabel(frame: CGRect(x: (imageViewCell.frame.width/2 - height/2) - 5, y: height/4 - 5, width: height/2 - 10, height: height/2-10))
        
        lad.backgroundColor = UIColor.white
        lad.alpha = 0.3
        lad.text = "\((Support.getReadySum(Int(dataCell.id!)) * 100) / Int(dataCell.price!)) %"
        lad.textAlignment = .center
        lad.center = imageViewCell.center
        lad.layer.cornerRadius = lad.frame.height/lad.frame.width
        lad.clipsToBounds = true
        
        imageViewCell.addSubview(lad)
        
        imageViewCell.image = UIImage(data: dataCell.picture! as Data)
        nameLabel.text = dataCell.productName
        priceLabel.text = Int(dataCell.price!).description
        
    }
}
