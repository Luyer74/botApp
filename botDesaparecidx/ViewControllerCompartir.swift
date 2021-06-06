//
//  ViewControllerCompartir.swift
//  botDesaparecidx
//
//  Created by user189367 on 5/16/21.
//

import UIKit
import FirebaseAuth
import Firebase
import Photos
import FirebaseStorage

class ViewControllerCompartir: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
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
    let sexPicker = UIPickerView()
    var ref : DatabaseReference!
    var daysPassed = 0
    let imagePicker = UIImagePickerController()
    var urlFoto : URL!
    private let sexos = ["Masculino","Femenino"]
    override func viewDidLoad() {
        super.viewDidLoad()
        /*if Auth.auth().currentUser != nil {
            emaillbl.text = Auth.auth().currentUser?.email
        }*/
        // Do any additional setup after loading the view.
        sexPicker.delegate = self
        createPicker()
        createDatePicker()
        let tap = UITapGestureRecognizer(target: self, action: #selector(quitaTeclado))
        view.addGestureRecognizer(tap)

    }
    
    @IBAction func quitaTeclado(){
        view.endEditing(true)
    }
    //MARK: -Funciones para el Picker del campo Sexo
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sexos.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sexos[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfSexo.text = sexos[row]
    }
    
    func createPicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //asignar toolbar
        tfSexo.inputAccessoryView = toolbar
        
        //asignar Picker al text field
        tfSexo.inputView = sexPicker
    }
    
    //MARK: - Funciones para el Date Picker
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
    
    @IBAction func agregaFoto(_ sender: UITapGestureRecognizer) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Metodos del delegado del Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let foto = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imgFoto.image = foto
        urlFoto = info[UIImagePickerController.InfoKey.imageURL] as? URL
        print(urlFoto!)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
    //MARK: - Compartir el caso creado.
    @IBAction func compartirCaso(_ sender: Any) {
        ref = Database.database().reference()
        //Convertir info a texto
        if tfNombre.text=="" || tfSexo.text=="" || tfEdad.text=="" || tfUltLocacion.text=="" || tfFecha.text=="" || tfRasgos.text=="" || tfContacto.text=="" {
            let alert = UIAlertController(title: "Error", message: "Deben llenarse los campos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            //Convertir a formato nuevo
            let textoCaso = "AYUDA A DIFUNDIR! \n\(tfNombre.text!), \(tfSexo.text!), de \(tfEdad.text!) años. Vistx por última vez el \(tfFecha.text!) en \(tfUltLocacion.text!).\nRasgos Fisicos: \(tfRasgos.text!) \nComentarios: \(tfComentarios.text!) \nSi tienes informacion contacta a \(tfContacto.text!)"
            
            //Obtener fecha de hoy
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let fechaCaso = formatter.string(from: date)
            
            //Pasar imagen y crear CASO
            uploadImage(fileURL: urlFoto, texto: textoCaso, fecha: fechaCaso, nombre: tfNombre.text!, lugar: tfUltLocacion.text!)
        }
        
    }
    
    func uploadImage(fileURL: URL, texto: String, fecha: String, nombre: String, lugar: String){
        let storage = Storage.storage()
        
        let storeRef = storage.reference()
        
        let user = Auth.auth().currentUser?.uid
        
        let photoRef = storeRef.child("FotoCaso\(user)")
        
        let upload = photoRef.putFile(from: fileURL, metadata: nil, completion: {(metadata, err) in
            guard let metadata = metadata else{
                print(err?.localizedDescription)
                return
            }
            //Obtener url de Storage y guardarlo en Database
            photoRef.downloadURL(completion: {(url: URL?, error: Error?) in
                let link = url?.absoluteString
                //Crear CASO
                self.ref.child("CASO").childByAutoId().setValue(["text": texto,"date":fecha, "image_link": link, "name": nombre, "location": lugar])
            })
            print("Photo uploaded")
        })
        
        
    }
   /*
     func getInitialData(completion: @escaping ([[String : String]]) -> Void){
         var initData = [[String : String]]()
         var cont = 0
         let date_str = getDate()
         print(date_str)
         ref.child("TWEETS").queryOrdered(byChild: "date_created").queryStarting(atValue: date_str).queryEnding(atValue: date_str).observe(.value) { (snapshot) in
             for snap in snapshot.children{
                 let data = snap as! DataSnapshot
                 let tweetID = data.key
                 if let valueDictionary = data.value as? [AnyHashable:AnyObject]{
                     var userID = ""
                     if let userIDini = valueDictionary["user"] as? NSNumber{
                         userID = userIDini.stringValue
                     }
                     else if let userIDini = valueDictionary["user"] as? String{
                         userID = userIDini
                     }
                     let fechacreado = valueDictionary["date_created"] as! String
                     let tweet_text = valueDictionary["tweet_text"] as! String
                     let dict = ["tweet_id" : tweetID, "fecha_creado" : fechacreado, "id_usuario" : userID, "tweet_text" : tweet_text]
                     initData.insert(dict, at: 0)
                 }
                 cont = cont + 1
             }
             completion(initData)
         }
     }
    func getDate() -> String{
        let fecha = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: daysPassed, to: fecha)
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        format.timeZone = TimeZone(abbreviation: "UTC")
        return format.string(from: nextDate!)
    }*/
}
