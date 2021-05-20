//
//  ViewControllerLogin.swift
//  botDesaparecidx
//
//  Created by Luis Arambula on 4/20/21.
//

import UIKit
import FirebaseAuth
class ViewControllerLogin: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfContraseña: UITextField!
    @IBOutlet weak var btLogIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(quitaTeclado))
        view.addGestureRecognizer(tap)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atrás", style: .plain, target: nil, action: nil)
        
    }
        
    @IBAction func quitaTeclado(){
        view.endEditing(true)
    }
    
    // MARK: -Funciones de Log In
    func validateFields() -> String? {
        if tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || tfContraseña.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" {
            return "Por favor llene los campos"
        }
        return nil
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        //Validar text fields
        let error = validateFields()
        if error != nil {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        //Crear versiones limpias de los campos
        let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfContraseña.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //Sign
        Auth.auth().signIn(withEmail:email, password: password) {
            (result, error) in
            if error != nil{
                //No pudo acceder
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                if !result!.user.isEmailVerified {
                    let alert = UIAlertController(title: "Error", message: "Verifica tu correo antes de ingresar", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeController = storyboard.instantiateViewController(identifier: "HomeViewController")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeController)
                    print("LogIn Exitoso")
                }
            }
        }
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
