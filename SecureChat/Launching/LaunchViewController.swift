//
//  ViewController.swift
//  SecureChat
//
//  Created by Luis Luna on 4/27/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let user = LoginManager().localLogin() {
            
            AppManager.shared.persistencia.currentUser = user
           self.goToApp()
            
            
        } else {
            self.goToWelcome()
        }
    }
    
    func goToApp() {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        
        self.present(view!, animated: true)
    }
    
    func goToWelcome() {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController")
        
        self.present(view!, animated: true)
        
    }


}

