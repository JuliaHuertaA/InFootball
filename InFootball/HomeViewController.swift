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
 
    @IBOutlet weak var golesJugadorLabel: UILabel!
    @IBOutlet weak var equipoJugadorLabel: UILabel!
    @IBOutlet weak var nombreJugadorLabel: UILabel!
    @IBOutlet weak var golesLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var buscarTextField: UITextField!
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
        //let url = "https://api.football-data.org/v2/competitions/CL/scorers"
        
       // getAllMembers(urlString: url)
        
    }
    func parseJSON(footballData:Data) -> FootballModelo?{
        let decoder = JSONDecoder()
        do{
          let dataDecodifcada =  try decoder.decode(FootballData.self, from: footballData)
            print(dataDecodifcada.scorers[0].player.name)
            let nombreJugador = dataDecodifcada.scorers[0].player.name
            print(dataDecodifcada.scorers[0].team.name)
            let nombreEquipo = dataDecodifcada.scorers[0].team.name
            print(dataDecodifcada.scorers[0].numberOfGoals)
            let goles = dataDecodifcada.scorers[0].numberOfGoals
            let ObjFootball = FootballModelo(nombreJugador: nombreJugador, nombreEquipo: nombreEquipo, goles: goles)
            print (ObjFootball)
            return ObjFootball
        }catch{
            print("Imprimir errores---------------------------")
            print(error)
            print("----------------------------------------------")
        }
        return nil
    }
    func actualizarJugador(football: FootballModelo){
        
    }
    func getAllMembers(urlString: String) {

        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("96e208ed0b6a420cba97fad3b581d1cc", forHTTPHeaderField: "X-Auth-Token")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            if data != nil{
                self.parseJSON(footballData: data!)
                    //     print("DATOS--------------------------------------------------")
                      //   let informacionString = String(data: data!, encoding: .utf8)
                //print(informacionString!)
               // print("------------------------------------------------------------------")

            }

        }.resume()
    }
    @objc func tapGestureHandler() {
            nombreJugadorTextField.endEditing(true)
            posicionTextField.endEditing(true)
            buscarTextField.endEditing(true)
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
    
    @IBAction func buscarButton(_ sender: UIButton) {
       
        let liga = buscarTextField.text
        
        switch liga {
        case "Bundesliga":
           let ligaurl = "BL1"
            let url = "https://api.football-data.org/v2/competitions/\(ligaurl)/scorers"
            getAllMembers(urlString: url)
         
        default:
            let alertController = UIAlertController(title: "No se encontró la información", message: "No tenemos el dato la liga o no se escribio correctamente", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alertController, animated: true, completion: nil)
            print("sepa la madre que paso")
        }
       

    }
    private func firebaseLogOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            
        }
    }
}
