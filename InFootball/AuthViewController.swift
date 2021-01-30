//
//  AuthViewController.swift
//  InFootball
//
//  Created by Mac5 on 25/01/21.
//

import UIKit
import Firebase
import GoogleSignIn

class AuthViewController: UIViewController {

    @IBOutlet weak var authStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrarButton: UIButton!
    @IBOutlet weak var inicioSesionButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bienvenidos a InFootball"
        let defaults =  UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String,
           let provider = defaults.value(forKey: "provider") as? String{
            authStackView.isHidden = true
            navigationController?.pushViewController(HomeViewController(email: email, provider: HomeViewController.ProviderType.init(rawValue: provider)!), animated: false)
        }
        //Google auth
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authStackView.isHidden = false
    }
    //comentario de prueba para el commit 

    @IBAction func registrarButtonAction(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password){
                (result,error)in
                if let result = result, error == nil{
                    self.navigationController?.pushViewController(HomeViewController(email: result.user.email!, provider: .basic), animated: true)
                    print("Si se registro")
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                }else{
                    print("Este es el error ")
                    print(error as Any)
                    print(error?.localizedDescription as Any)
                    let errorRegistro = error?.localizedDescription as Any
                    if errorRegistro as! String ==  "The email address is badly formatted." {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        let alertController = UIAlertController(title: "Error", message: "No se ingreso el correo correctamente", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                    if errorRegistro as! String == "The email address is already in use by another account."{
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        let alertController = UIAlertController(title: "Error", message: "El correo que ingreso ya se uso para crear otra cuenta", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                    if errorRegistro as! String == "The password must be 6 characters long or more."{
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        let alertController = UIAlertController(title: "Error", message: "La contraseña debe tener 6 caracteres o más", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func inicioSesionButtonAction(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password){
                (result,error)in
                if let result = result, error == nil{
                    self.navigationController?.pushViewController(HomeViewController(email: result.user.email!, provider: .basic), animated: true)
                    print("Entra a la app")
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                }else{
                    print("Este es el error ")
                    print(error as Any)
                    print(error?.localizedDescription as Any)
                    let errorAutenticacion = error?.localizedDescription as Any
                    if errorAutenticacion as! String == "The password is invalid or the user does not have a password." {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        let alertController = UIAlertController(title: "Error", message: "La contraseña es incorrecta", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                    if errorAutenticacion as! String == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        let alertController = UIAlertController(title: "Error", message: "El usuario no se encuentra registrado", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                        
                }
            }
        }
    }
    @IBAction func googleButtonAction(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
}


extension AuthViewController:GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil{
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential){ (result, error)in
                if let result = result, error == nil{
                    self.navigationController?.pushViewController(HomeViewController(email: result.user.email!, provider: .google), animated: true)
                }else{
                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error en la autentificació con google", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
          }

        }
    }
    
    

