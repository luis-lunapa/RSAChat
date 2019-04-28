
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signinPressed(_ sender: Any) {
        if emailTextField.text! == "" {
            self.showAlert(title: "Error", text: "You must specify your email")
            return
        }
        if passwordTextField.text! == "" {
            self.showAlert(title: "Error", text: "You must specify your password")
            return
        }
        
        self.tempLogin(user: emailTextField.text!, pass: passwordTextField.text!)
        
        
    }
    
    
    func showAlert(title: String, text: String) {
        
        let alert = UIAlertController.init(title: title, message: text, preferredStyle: .alert)
        
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }
    
    func tempLogin(user: String, pass: String) {
        
        if user == "luis" && pass == "12345" {
            var u = User.init(idUser: "1", token: "123", email: "luis.lunapa@outlook.com", name: "Luis Gerardo Luna Peña", profilePic: nil)
            AppManager.shared.persistencia.currentUser = u
            goToApp()
        } else if user == "tony" && pass == "12345" {
            var u = User.init(idUser: "2", token: "123", email: "laverga@gmail.com", name: "Luis Antonio Vazquez Garcia", profilePic: nil)
            AppManager.shared.persistencia.currentUser = u
            goToApp()
            
        } else if user == "victor" && pass == "12345" {
            var u = User.init(idUser: "3", token: "123", email: "pulidocs@gmail.com", name: "Victor E. Pulido Contreras", profilePic: nil)
            AppManager.shared.persistencia.currentUser = u
            goToApp()
        
        } else {
            
            
            self.showAlert(title: "Error", text: "Wrong user or password")
        }
        
        
        
        
        
    }
    
    func goToApp() {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        
        self.present(view!, animated: true)
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
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
 

}
