//
//  ViewControllerLogin.swift
//  botDesaparecidx
//
//  Created by Luis Arambula on 4/20/21.
//

import UIKit

class ViewControllerLogin: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfContraseña: UITextField!
    @IBOutlet weak var btLogIn: UIButton!
    @IBOutlet weak var lbError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbError.alpha = 0
    }
    
    
    @IBAction func logInTapped(_ sender: Any) {
        //Validar text fields
        if tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || tfContraseña.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" {
            lbError.alpha = 1.0
            lbError.text = "Por favor llene los campos"
            return
        }
        //Checar contraseña
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
//        let isValid = passwordTest.evaluate(with: tfContraseña.text?.trimmingCharacters(in: .whitespacesAndNewlines))
//        if isValid == false {
//            lbError.alpha = 1.0
//            lbError.text = ""
//            return
//        }
        //Sign in del Usuario
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
