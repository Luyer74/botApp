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
                let alert = UIAlertController(title: "Error", message: self.checarErrores(error! as NSError), preferredStyle: .alert)
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
    
    func checarErrores(_ error : NSError) -> String{
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
        
        switch errorAuthStatus{
        case .invalidEmail:
            return "Tu correo es inválido o no existe"
        case .wrongPassword:
            return "Tu contraseña es equivocada"
        case .userNotFound:
            return "No existe un usuario con ese correo"
        default:
            return "Error desconocido"
        }
    }

}
