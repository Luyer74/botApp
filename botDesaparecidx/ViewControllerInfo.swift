//
//  ViewControllerInfo.swift
//  botDesaparecidx
//
//  Created by user189367 on 5/27/21.
//

import UIKit

class ViewControllerInfo: UIViewController {
    @IBOutlet weak var lbInfo1: UILabel!
    @IBOutlet weak var lbInfo2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbInfo1.layer.masksToBounds = true
        lbInfo1.layer.cornerRadius = 5
        lbInfo2.layer.masksToBounds = true
        lbInfo2.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
