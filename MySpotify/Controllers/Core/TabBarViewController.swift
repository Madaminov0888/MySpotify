//
//  TabBarViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 16/07/24.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTabBar()
    }
    
    
    private func setUpTabBar() {
        let homeBar = UINavigationController(rootViewController: HomeViewController())
        let searchBar = UINavigationController(rootViewController: SearchViewController())
        let yourLibrary = UINavigationController(rootViewController: YourLibraryViewController())
        
        
        homeBar.tabBarItem.title = "Home"
        homeBar.tabBarItem.image = UIImage(systemName: "house")
        homeBar.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        searchBar.tabBarItem.title = "Search"
        searchBar.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        yourLibrary.tabBarItem.title = "Your Library"
        yourLibrary.tabBarItem.image = UIImage(systemName: "play.square.stack")
        yourLibrary.tabBarItem.selectedImage = UIImage(systemName: "play.square.stack.fill")
        
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .systemGray
        
        self.setViewControllers([homeBar, searchBar, yourLibrary], animated: false)
    }
}
