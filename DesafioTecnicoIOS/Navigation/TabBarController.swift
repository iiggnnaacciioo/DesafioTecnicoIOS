//
//  TabBarController.swift
//  DesafioTecnicoIOS
//
//  Created by Ignacio Schiefelbein on 01-09-24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        //title = "My super App"
    }

    private func setupViewControllers() {
        let firstVC = LandingPageViewController()
        firstVC.title = "Home"
        firstVC.tabBarItem.tag = 0
        firstVC.tabBarItem.image = UIImage(systemName: "house")

        let secondVC = UIViewController()
        secondVC.title = "Cart"
        secondVC.tabBarItem.tag = 1
        secondVC.tabBarItem.image = UIImage(systemName: "cart")
        secondVC.tabBarItem.badgeValue = "5"  // Adding a badge with number 5
        secondVC.tabBarItem.badgeColor = UIColor.systemRed  // Optional: Customize badge color

        viewControllers = [firstVC, secondVC]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            let vc = CartViewController.instance { [weak self] in
                self?.selectedIndex = 0
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
