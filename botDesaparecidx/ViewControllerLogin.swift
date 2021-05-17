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
    @IBOutlet weak var lbError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbError.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(quitaTeclado))
        view.addGestureRecognizer(tap)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = "Atrás"
    }
    
    @IBAction func quitaTeclado(){
        view.endEditing(true)
    }
    
    // MARK: -Funciones de Log In
    func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func validateFields() -> String? {
        if tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || tfContraseña.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" {
            return "Por favor llene los campos"
        }
        //Check if password is secure
        let cleanedPassword = tfContraseña.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            return "Por favor revise que su contraseña sea correcta"
        }
        
        return nil
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        //Validar text fields
        let error = validateFields()
        if error != nil {
            lbError.text = error!
            lbError.alpha = 1
        }
        //Crear versiones limpias de los campos
        let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfContraseña.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //Sign
        Auth.auth().signIn(withEmail:email, password: password) {
            (result, error) in
            if error != nil{
                //No pudo acceder
                self.lbError.text = error!.localizedDescription
                self.lbError.alpha = 1
            } else {
                if !result!.user.isEmailVerified {
                    self.lbError.text = "Verifica tu correo antes de ingresar"
                    self.lbError.alpha = 1
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
