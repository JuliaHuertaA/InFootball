//
//  HomeViewController.swift
//  InFootball
//
//  Created by Mac5 on 26/01/21.
//


import UIKit
import Firebase
import GoogleSignIn
//UITableViewDelegate, UITableViewDataSource

class HomeViewController: UIViewController {
    

    enum ProviderType: String {
        case basic
        case google
    }
    
  
    @IBOutlet weak var listaTableView: UITableView!
    @IBOutlet weak var nombreJugadorTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var posicionTextField: UITextField!
    private let email:String
    private let provider: ProviderType
    
    private let db = Firestore.firestore()
    
    //  Constructor para guardar la manera de registro
    init(email:String, provider:ProviderType){
        self.email = email
        self.provider = provider
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      /*  listaTableView.delegate = self
        listaTableView.dataSource = self*/

        title = "INFOOTBALL"
        emailLabel.text = email
        navigationItem.setHidesBackButton(true, animated: false)
        //Guardar datos del usuario
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
        // Do any additional setup after loading the view.
    }
    
/*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        
        
        db.collection("users").document(email).collection("jugadores").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print(querySnapshot!.count)
                    //print("\(document.documentID) => \(document.data())")
                    let jugador = document.data() as NSDictionary
                    print("\(jugador["nombreJugador"]!)")
                    let llenar = "\(jugador["nombreJugador"]!)"
                    print("----------------------------------------------------------------")
                    cell.textLabel?.text = llenar
                }
            }
        }
        return cell
    }*/
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        db.collection("users").document(email).setData([
               "provider":provider.rawValue,
               "nombreJugador": nombreJugadorTextField.text ?? "",
               "posicion": posicionTextField.text ?? ""])
        nombreJugadorTextField.text = ""
        posicionTextField.text = ""
        let alertController = UIAlertController(title: "Registro exitoso", message: "Su jugador favorito ha sido registrado con éxito", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }

    
    @IBAction func getButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        db.collection("users").document(email).getDocument{
            (documentSnapshot,error)in
            if let document = documentSnapshot, error == nil {
                if let jugador = document.get("nombreJugador") as? String{
                    self.nombreJugadorTextField.text = jugador
                }
                if let posicion = document.get("posicion") as? String{
                    self.posicionTextField.text = posicion
                }
            }
            
        }
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        db.collection("users").document(email).delete()
    }
    
    @IBAction func cerrarSesionButtonAction(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        switch provider {
        case .google:
            GIDSignIn.sharedInstance()?.signOut()
            firebaseLogOut()
        case .basic:
            firebaseLogOut()
        }
        navigationController?.popViewController(animated: true)
    }
    private func firebaseLogOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            
        }
    }
}
