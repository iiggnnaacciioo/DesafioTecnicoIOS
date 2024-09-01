//
//  NavigationBar.swift
//  DesafioTecnicoIOS
//
//  Created by Ignacio Schiefelbein on 01-09-24.
//

import UIKit

class NavigationController: UINavigationController {
    
    static var instance: NavigationController {
        NavigationController(rootViewController: TabBarController())
    }
}
