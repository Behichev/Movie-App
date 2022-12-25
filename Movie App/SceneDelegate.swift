//
//  SceneDelegate.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 28.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if #available (iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

