//
//  SceneDelegate.swift
//  iTechBook
//
//  Created by Neestackich on 11/18/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if DependencyResolver.shared.keychain.credentials != nil {
            let tabBarController = createTabBarController()
            if let shortcutItem = connectionOptions.shortcutItem {
                performShortcut(shortcutItem: shortcutItem)
            } else {
                window?.switchRootController(to: tabBarController,
                                             options: .transitionFlipFromRight)
            }
        } else {
            showWelcomeScreen()
        }
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        performShortcut(shortcutItem: shortcutItem)
    }

    func performShortcut(shortcutItem: UIApplicationShortcutItem) {
        guard let shortcutItem = AppShortcutItem(rawValue: shortcutItem.type) else {
            return
        }

        switch shortcutItem {
        case .account:
            showAccountViewController()
        case .addBook:
            showAddBookViewController()
        }
    }

    enum AppShortcutItem: String {
        case account = "Vittcal.iTechBook.account"
        case addBook = "Vittcal.iTechBook.addbook"
    }

    func showAddBookViewController() {
        if DependencyResolver.shared.keychain.credentials != nil {
            let tabBarController = createTabBarController()

            UIApplication
                .shared
                .windows
                .first?
                .switchRootController(to: tabBarController,
                                      options: .transitionFlipFromRight) {
                    let addBookViewController = AddBookViewController
                        .instantiateFromStoryboard()
                    addBookViewController.viewModel =
                        AddBookViewModel(
                            apiClient: DependencyResolver.shared.apiClient,
                            router: AddBookRouter(rootViewController: addBookViewController))

                    tabBarController.viewControllers?.first?.present(addBookViewController,
                                                                     animated: true,
                                                                     completion: nil)
                }
        } else {
            showWelcomeScreen()
        }
    }

    func showAccountViewController() {
        if DependencyResolver.shared.keychain.credentials != nil {
            let tabBarController = createTabBarController()
            tabBarController.selectedIndex = 1

            UIApplication
                .shared
                .windows
                .first?
                .switchRootController(to: tabBarController,
                                      options: .transitionFlipFromRight)
        } else {
            showWelcomeScreen()
        }
    }

    func showWelcomeScreen() {
        let rootViewController = window?.rootViewController as! WelcomeScreenViewController
        let welcomeScreenRouter = WelcomeScreenRouter(rootViewController: rootViewController)
        rootViewController.viewModel = WelcomeScreenViewModel(router: welcomeScreenRouter)
    }

    func createTabBarController() -> UITabBarController {
        let libraryViewController = LibraryViewController.instantiateFromStoryboard()
        libraryViewController.title = L10n.libraryLabel
        libraryViewController.viewModel = LibraryViewModel(
            apiClient: DependencyResolver.shared.apiClient,
            router: LibraryRouter(rootViewController: libraryViewController),
            credentialsStore: DependencyResolver.shared.keychain,
            database: DependencyResolver.shared.database)

        let accountViewController = AccountViewController.instantiateFromStoryboard()
        accountViewController.title = L10n.accountLabel
        accountViewController.viewModel = AccountViewModel(
            apiClient: DependencyResolver.shared.apiClient,
            router: AccountRouter(rootViewController: accountViewController),
            credentialsStore: DependencyResolver.shared.keychain,
            database: DependencyResolver.shared.database)

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([libraryViewController,
                                             accountViewController], animated: false)
        tabBarController.tabBar.accessibilityIdentifier = "tabBarController"
        tabBarController.tabBar.items?[0].accessibilityIdentifier = "libraryTabBarItem"
        tabBarController.tabBar.items?[1].accessibilityIdentifier = "accountTabBarItem"

        let images = ["books.vertical.fill", "person.fill"]

        if let items = tabBarController.tabBar.items {
            for (index, item) in items.enumerated() {
                item.image = UIImage(systemName: images[index])
            }
        }

        return tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
