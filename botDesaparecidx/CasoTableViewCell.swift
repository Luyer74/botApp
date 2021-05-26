//
//  CasoTableViewCell.swift
//  botDesaparecidx
//
//  Created by Luis Arambula on 5/25/21.
//

import UIKit

class CasoTableViewCell: UITableViewCell {

    @IBOutlet var lblUsuario: UILabel!
    @IBOutlet var lblTexto : UILabel!
    @IBOutlet var imgCaso : UIImageView!
    @IBOutlet var lblfecha : UILabel!
    @IBOutlet var lbllugar : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }

    
}
