//
//  ViewController.swift
//  botDesaparecidx
//
//  Created by Luis Arambula on 4/20/21.
//

import UIKit
import Firebase

class ViewController: UIViewController, protocoloChecaRegistro {
    
    var ref : DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atrás", style: .plain, target: nil, action: nil)
    }
    
    func checaRegistro(registrado: Bool) {
        if registrado{
            let alert = UIAlertController(title: "¡Usuario Registrado!", message: "Verifica tu correo para utilizar tu cuenta", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registro"{
            let vistaRegistro = segue.destination as! ViewControllerRegistrar
            vistaRegistro.delegado = self
        }
    }
}

