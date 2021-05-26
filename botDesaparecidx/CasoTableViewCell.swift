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
    
}
