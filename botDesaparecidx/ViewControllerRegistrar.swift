//
//  ViewControllerRegistrar.swift
//  botDesaparecidx
//
//  Created by Luis Arambula on 4/20/21.
//

import UIKit
import FirebaseAuth
import Firebase

protocol protocoloChecaRegistro{
    func checaRegistro(registrado : Bool)
}

class ViewControllerRegistrar: UIViewController {
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var tfContrasena: UITextField!
    @IBOutlet weak var tfConfirmarContra: UITextField!
    @IBOutlet weak var btRegistrarse: UIButton!
    
    var ref : DatabaseReference!
    var delegado : protocoloChecaRegistro!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(quitaTeclado))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func quitaTeclado(){
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Funciones de validacion de campos
    
    
    
    //Checar si la contrasena es valida
    func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //Checar si los campos son validos
    func validateInputs() -> String? {
        //Checar si los campos estan llenos
        if tfNombre.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfApellido.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfCorreo.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfContrasena.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Por favor rellene todos los campos"
        }
        
        let password = tfContrasena.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Checar si la contrasena es valida
        if !(isPasswordValid(password)) {
            return "Tu contraseña es inválida, asegúrate que tenga 8 caracteres, un caracter especial y un número"
        }
        
        //Checar si las contrasenas coinciden
        if tfContrasena.text != tfConfirmarContra.text{
            return "Las contraseñas no coinciden"
        }
        return nil
    }

    //Funcion del boton de registro
    
    @IBAction func registroTap(_ sender: UIButton) {
        let error = validateInputs()
        
        if error != nil{
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            ref = Database.database().reference()
            let correo = tfCorreo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let nombres = tfNombre.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let apellidos = tfApellido.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let contrasena = tfContrasena.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: correo, password: contrasena) { [self] (result, err) in
              
                //checar errores
                if err != nil {
                    let alert = UIAlertController(title: "Error", message: checarErrores(err! as NSError), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    self.ref.child("USUARIOS_APP/\(result!.user.uid)").setValue(["nombre" : nombres,
                        "apellidos" : apellidos,
                        "correo" : correo
                    ])
                    result!.user.sendEmailVerification { (error) in
                        if error != nil {
                            print("error enviando correo")
                        }
                    }
                    self.navigationController?.popViewController(animated: true)
                    self.delegado.checaRegistro(registrado: true)
                }
            }
        }
    }
    
    func checarErrores(_ error : NSError) -> String{
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
        
        switch errorAuthStatus{
        case .invalidEmail:
            return "Tu correo es inválido"
        case .userNotFound:
            return "No existe este usuario"
        case .emailAlreadyInUse:
            return "Este correo ya está registrado"
        default:
            return "Error desconocido"
        }
    }
}
