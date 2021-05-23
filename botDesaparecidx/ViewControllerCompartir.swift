//
//  ViewControllerCompartir.swift
//  botDesaparecidx
//
//  Created by user189367 on 5/16/21.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewControllerCompartir: UIViewController {
    //@IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfSexo: UITextField!
    @IBOutlet weak var tfEdad: UITextField!
    @IBOutlet weak var tfUltLocacion: UITextField!
    @IBOutlet weak var tfFecha: UITextField!
    @IBOutlet weak var tfRasgos: UITextField!
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var tfComentarios: UITextField!
    @IBOutlet weak var tfContacto: UITextField!
    
    let datePicker =  UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*if Auth.auth().currentUser != nil {
            emaillbl.text = Auth.auth().currentUser?.email
        }*/
        // Do any additional setup after loading the view.
        createDatePicker()
    }
    
    func createDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button Done
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        //asignar toolbar
        tfFecha.inputAccessoryView = toolbar
        
        //asignar datePicker al text field
        tfFecha.inputView = datePicker
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func donePressed(){
        //formatear fecha
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .none
        
        tfFecha.text = format.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    /*
    @IBAction func logOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
       } catch let signOutError as NSError {
         print ("Error signing out: %@", signOutError)
       }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registrationController = storyboard.instantiateViewController(identifier: "RegistrationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(registrationController)
    }*/
}
