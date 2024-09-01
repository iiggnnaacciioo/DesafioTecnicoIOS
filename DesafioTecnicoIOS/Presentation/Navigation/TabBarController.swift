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
        self.delegate = self
        setupView()
        setupNavigationBar()
    }
    
    private func setupViewControllers() {
        let firstVC = LandingPageViewController.instance
        firstVC.title = "Home"
        firstVC.tabBarItem.tag = 0
        firstVC.tabBarItem.image = UIImage(systemName: "house")?.withBaselineOffset(fromBottom: 18)

        let secondVC = UIViewController()
        secondVC.view.backgroundColor = .red
        secondVC.title = "Cart"
        secondVC.tabBarItem.tag = 1
        secondVC.tabBarItem.image = UIImage(systemName: "cart")?.withBaselineOffset(fromBottom: 18)

        secondVC.tabBarItem.badgeValue = nil
        secondVC.tabBarItem.badgeColor = UIColor.systemRed

        viewControllers = [firstVC, secondVC]
    }
        
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            let vc = CartViewController.instance { [weak self] in
                self?.selectedIndex = 0
            }
            navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.badgePositionAdjustment.vertical = 7
        itemAppearance.normal.badgePositionAdjustment.horizontal = 4
        itemAppearance.normal.titlePositionAdjustment.vertical = 10
           
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        appearance.backgroundColor = .white

        tabBar.standardAppearance = appearance
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        let titleColor = UIColor.darkText
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
        appearance.backgroundColor = UIColor.white
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return false

    }
}
