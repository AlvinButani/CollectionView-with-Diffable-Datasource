//
//  AppCollectionViewCell.swift
//  appstore_app_page_with_diffable_datasource
//
//  Created by sunny on 01/01/24.
//

import UIKit
import SDWebImage

class AppCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblAppName:UILabel!
    @IBOutlet weak var lblAppArtistName:UILabel!
    @IBOutlet weak var imgApp:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgApp.layer.cornerRadius = 12
        self.imgApp.layer.borderWidth = 1
        self.imgApp.layer.borderColor = UIColor.systemGray5.cgColor
        self.imgApp.layer.masksToBounds = true
    }
    
    var items:Application!{
        didSet{
            self.lblAppName.text = self.items.name
            self.lblAppArtistName.text = self.items.artistName
            self.imgApp.sd_setImage(with: self.items.artworkURL)
        }
    }

}
