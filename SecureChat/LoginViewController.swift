
//
//  LoginViewController.swift
//  SecureChat
//
//  Created by Luis Luna on 4/27/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.isEnabled = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signinPressed(_ sender: Any) {
        if emailTextField.text! == "" {
            
        }
    }
    
    
    func showAlert(title: String, text: String) {
        
        let alert = UIAlertController.init(title: title, message: text, preferredStyle: .alert)
        
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        print("CANCEL")
        self.dismiss(animated: true, completion: nil)
    }
 

}
