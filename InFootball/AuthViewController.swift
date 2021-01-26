//
//  AuthViewController.swift
//  InFootball
//
//  Created by Mac5 on 25/01/21.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {

    @IBOutlet weak var authStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrarButton: UIButton!
    @IBOutlet weak var inicioSesionButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registro"
    }

    @IBAction func registrarButtonAction(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password){
                (result,error)in
                if let result = result, error == nil{
                    self.navigationController?.pushViewController(HomeViewController(email: result.user.email!, provider: .basic), animated: true)
                    print("Si se registro")
                }else{
                    print("Este es el error ")
                    print(error as Any)
                    print(error?.localizedDescription as Any)
                    let errorRegistro = error?.localizedDescription as Any
                    if errorRegistro as! String ==  "The email address is badly formatted." {
                        let alertController = UIAlertController(title: "Error", message: "No se ingreso el correo correctamente", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                    if errorRegistro as! String == "The email address is already in use by another account."{
                        let alertController = UIAlertController(title: "Error", message: "El correo que ingreso ya se uso para crear otra cuenta", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                    if errorRegistro as! String == "The password must be 6 characters long or more."{
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
                }else{
                    print("Este es el error ")
                    print(error as Any)
                    print(error?.localizedDescription as Any)
                    let errorAutenticacion = error?.localizedDescription as Any
                    if errorAutenticacion as! String == "The password is invalid or the user does not have a password." {
                        let alertController = UIAlertController(title: "Error", message: "La contraseña es incorrecta", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                    if errorAutenticacion as! String == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        let alertController = UIAlertController(title: "Error", message: "El usuario no se encuentra registrado", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                        
                }
            }
        }
    }
    @IBAction func googleButtonAction(_ sender: Any) {
    }
    
}

