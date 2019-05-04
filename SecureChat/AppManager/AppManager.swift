//
//  AppManager.swift
//  SecureChat
//
//  Created by Luis Luna on 4/27/19.
//  Copyright © 2019 DeepTech. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class AppManager {
    static let shared = AppManager()
    
    
    let persistencia: Persistencia = Persistencia()
    let networking: Networking = Networking()

}
