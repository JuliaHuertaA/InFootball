//
//  HomeViewController.swift
//  InFootball
//
//  Created by Mac5 on 26/01/21.
//

import UIKit

class HomeViewController: UIViewController {

    enum ProviderType: String {
        case basic
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    private let email:String
    private let provider: ProviderType
    //  Constructor para guardar la manera de registro
    init(email:String, provider:ProviderType){
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "INFOOTBALL"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cerrarSesionButtonAction(_ sender: UIButton) {
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
