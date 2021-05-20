//
//  ViewControllerReset.swift
//  botDesaparecidx
//
//  Created by Luis Arambula on 5/19/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewControllerReset: UIViewController {

    @IBOutlet weak var emaillbl: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func restablecer(_ sender: UIButton) {
        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: emaillbl.text!, completion: {(error) in
            if let error = error{
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "¡Listo!", message: "Un correo ha sido enviado a tu dirección para restablecer tu contraseña", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}
