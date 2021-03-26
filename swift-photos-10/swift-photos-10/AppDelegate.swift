import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var doodleViewController : DoodleViewController!
    var navigationController : UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        doodleViewController = DoodleViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController = UINavigationController(rootViewController: doodleViewController)
        
        return true
    }

}

