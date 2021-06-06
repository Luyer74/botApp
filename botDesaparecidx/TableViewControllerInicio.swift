//
//  TableViewControllerInicio.swift
//  botDesaparecidx
//
//  Created by user189367 on 5/16/21.
//

import UIKit
import FirebaseAuth
import Firebase
import SDWebImage

private struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 50
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 32
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

class TableViewControllerInicio: UITableViewController{

    var ref : DatabaseReference!
    var listaCasos = [tweet]()
    var fecha = Date()
    var daysPassed = 0
    var formater = DateFormatter()
    var isPaginating = false
    private let imageView = UIImageView(image: UIImage(named: "bot2"))
    
    
    @objc func refresh(sender:AnyObject)
    {
        daysPassed = 0
        listaCasos.removeAll()
        tableView.reloadData()
        loadData()
        daysPassed = daysPassed - 1
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let nib = UINib(nibName: "CasoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "celda")
        ref = Database.database().reference()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true


        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaCasos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CasoTableViewCell

        // Configure the cell...
        cell.lblUsuario.text = listaCasos[indexPath.row].user_name
        cell.lblTexto.text = listaCasos[indexPath.row].tweet_text
        cell.imgCaso.image = UIImage(named: "persona")
        cell.lblfecha.text = listaCasos[indexPath.row].fecha_creado
        cell.lbllugar.text = listaCasos[indexPath.row].lugar
        if let image_link = listaCasos[indexPath.row].imagen_link{
            let link = URL(string: image_link)
            cell.imgCaso.sd_setImage(with: link, completed: nil)
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "mostrarCaso", sender: self)
    }
    

    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        let cellname = tableView.cellForRow(at: indexPath!) as! CasoTableViewCell
        let vistaDetalle = segue.destination
        vistaDetalle.title = cellname.lblUsuario.text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atrás", style: .plain, target: nil, action: nil)
        imageView.isHidden = true
    }
    
    
    func loadData(){
        isPaginating = true
        var datosCasos = [[String : String]]()
        getInitialData() { datos in
            let group = DispatchGroup()
            datosCasos = datos
            if datosCasos.count == 0{
                self.isPaginating = false
                return
            }
            self.tableView.tableFooterView = self.createSpinnerFooter()
            for i in 1...datos.count{
                group.enter()
                let id_usuario = datos[i-1]["id_usuario"]!
                self.getUserName(userID: id_usuario, completion: { user_name , location in
                    datosCasos[i-1]["nombre_usuario"] = user_name
                    datosCasos[i-1]["lugar"] = location
                    group.leave()
                })
            }
            
            for i in 1...datos.count{
                group.enter()
                let id_tweet = datos[i-1]["tweet_id"]!
                self.getImageLink(tweetID: id_tweet, completion: {link in
                    datosCasos[i-1]["link_imagen"] = link
                    group.leave()
                })
            }
            
            group.notify(queue: DispatchQueue.global(), execute: {
                self.insertData(datosCasos: datosCasos)
                print("listo!")
                self.reloadTable()
                self.isPaginating = false
            })
        }
    }
    
    
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
    
    func getUserName(userID : String, completion: @escaping (String, String) -> Void){
        self.ref.child("USERS/\(userID)").observeSingleEvent(of: .value, with: {(snapshot) in
            var nombre_usuario = ""
            var lugar = ""
            if let valueDictionary = snapshot.value as? [AnyHashable:AnyObject]{
                if let user_name = valueDictionary["name"] as? String {
                    nombre_usuario = user_name
                }
                if let location = valueDictionary["location"] as? String{
                    if location == ""{
                        lugar = "Desconocido"
                    }else{
                        lugar = location
                    }
                }
            }
            completion(nombre_usuario, lugar)
        })
    }
    
    func getImageLink(tweetID: String, completion: @escaping (String?) -> Void){
        self.ref.child("IMAGES/\(tweetID)/0/image_link").observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? String {
                let image_link = value
                completion(image_link)
            }
            else{
                completion(nil)
            }
        })
    }
    
    func reloadTable(){
        DispatchQueue.main.async {
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
        }
    }
    
    func createSpinnerFooter() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func insertData(datosCasos : [[String : String]]){
        for i in 1...datosCasos.count{
            let tw = tweet(tweet_text: datosCasos[i-1]["tweet_text"]!, fecha_creado: datosCasos[i-1]["fecha_creado"]!, imagen_link: datosCasos[i-1]["link_imagen"], user_name: datosCasos[i-1]["nombre_usuario"]!, lugar: datosCasos[i-1]["lugar"]!)
            self.listaCasos.append(tw)
        }
    }
    
    func getDate() -> String{
        let nextDate = Calendar.current.date(byAdding: .day, value: daysPassed, to: fecha)
        formater.dateFormat = "yyyy-MM-dd"
        formater.timeZone = TimeZone(abbreviation: "UTC")
        return formater.string(from: nextDate!)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let height = navigationController?.navigationBar.frame.height{
            moveAndResizeImage(for: height)
        }
        guard !isPaginating else{
            return
        }
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height+180-scrollView.frame.size.height){
            print("loading more...")
            loadData()
            daysPassed = daysPassed - 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
