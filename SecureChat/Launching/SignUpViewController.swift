//
//  SignUpViewController.swift
//  SecureChat
//
//  Created by Luis Luna on 4/27/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signupButton.layer.cornerRadius = 6
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tap)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        self.nameTextField.setBottomLine(borderColor: .gray)
        //        self.emailTextField.setBottomLine(borderColor: .gray)
        //        self.passwordTextField.setBottomLine(borderColor: .gray)
        //        self.passwordConfirmTextField.setBottomLine(borderColor: .gray)
    }
    
    
    @IBAction func signupPressed(_ sender: Any) {
        // Registration code and go to chats
        
        if !checkForm() {
            return
        }
        
        let name     = self.nameTextField.text!
        let email    = self.emailTextField.text!
        let password = self.passwordTextField.text!
        
        let (public_key, private_key) = NewRSA.generateKeys()
        
        print("Llaves = privada = \(private_key) publica = \(public_key)")
        RSA.savePrivateKey(key: private_key)
        
            
            AppManager.shared.networking.createAccount(name: name, email: email, password: password, public_key: public_key).done {
                
                ready in
                
                let alert = Utilidades.showMessageCompletion(title: "Welcome !!", text: "You can now login and start messaging 🥳", block: {
                    self.dismiss(animated: true)
                })
                
                self.present(alert, animated: true)
                
                
                }.catch {
                    error in
                    let error = error as NSError
                    
                    
                    self.showAlert(title: "Oops", text: error.userInfo["msg"] as! String)
                    
                    
                    
            }
        
        
        
    }
    
    func checkForm () -> Bool {
        var ready = true
        var msg = ""
        if nameTextField.text! == "" {
            ready = false
            msg = "Your name is required \n"
            
        }
        
        if emailTextField.text! == "" {
            ready = false
            msg = msg + "Your email is required \n"
            
        }
        
        if passwordTextField.text! == "" {
            ready = false
            msg = msg + "A new password is required \n"
            
        }
        
        if passwordConfirmTextField.text! == "" {
            ready = false
            msg = msg + "You must confirm your password email is required \n"
            
        }
        
        if passwordConfirmTextField.text! != passwordTextField.text! {
            ready = false
            msg = msg + "Both passwords must be the same \n"
            
        }
        
        if !ready {
            showAlert(title: "Error Singning up", text: msg)
            
        }
        
        
        return ready
        
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func showAlert(title: String, text: String) {
        
        let alert = UIAlertController.init(title: title, message: text, preferredStyle: .alert)
        
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        print("CANCEL")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
}
