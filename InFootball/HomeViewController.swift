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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
                view.addGestureRecognizer(tapGesture)

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

    @objc func tapGestureHandler() {
            nombreJugadorTextField.endEditing(true)
            posicionTextField.endEditing(true)
      }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        if nombreJugadorTextField.text == "" && posicionTextField.text == ""{
            let alertController = UIAlertController(title: "Campos vacios", message: "Llena los campos correspondientes", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }else{
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

    }

    
    @IBAction func getButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        db.collection("users").document(email).getDocument{
            (documentSnapshot,error)in
            if let document = documentSnapshot, error == nil {
                print("entro aqui")
                if let jugador = document.get("nombreJugador") as? String{
                    self.nombreJugadorTextField.text = jugador
                }else{
                    let alertController = UIAlertController(title: "No hay jugador", message: "No tiene a su jugador favorito registrado", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alertController, animated: true, completion: nil)
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
        self.nombreJugadorTextField.text = ""
        self.posicionTextField.text = ""
        let alertController = UIAlertController(title: "Jugador eliminado", message: "Su jugador favorito ha sido eliminado", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alertController, animated: true, completion: nil)
        
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
