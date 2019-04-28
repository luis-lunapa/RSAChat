//
//  BlackBox.swift
//  Livenia App
//
//  Created by Luis Luna on 6/7/18.
//  Copyright © 2018 Livenia. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

func performUIUpdatesOnMainSync(_ updates: @escaping () -> Void) {
    DispatchQueue.main.sync {
        updates()
    }
}
