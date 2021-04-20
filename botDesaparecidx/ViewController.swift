//
//  ViewController.swift
//  botDesaparecidx
//
//  Created by Luis Arambula on 4/20/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
    }

    @IBAction func probarBase(_ sender: UIButton) {
        ref.child("USUARIOS_APP").updateChildValues(["prueba": "usuario2"])
    }
    
}

