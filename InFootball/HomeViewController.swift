//
//  HomeViewController.swift
//  InFootball
//
//  Created by Mac5 on 26/01/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    enum ProviderType: String {
        case basic
        case google
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    private let email:String
    private let provider: ProviderType
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
    
    @IBAction func cerrarSesionButtonAction(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        switch provider {
        case .basic, .google:
            do{
              try Auth.auth().signOut()
                navigationController?.popViewController(animated: true)
            }catch{
                
            }
            
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}