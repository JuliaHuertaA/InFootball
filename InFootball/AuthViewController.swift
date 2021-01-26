//
//  AuthViewController.swift
//  InFootball
//
//  Created by Mac5 on 25/01/21.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrarButton: UIButton!
    @IBOutlet weak var inicioSesionButton: UIButton!
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
                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error, verifica tu registro nuevamente", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func inicioSesionButtonAction(_ sender: UIButton) {
    }
}

