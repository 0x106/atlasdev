
import Foundation
import ARKit

public class Menu {
    
    // How far apart (in metres) the menu items will appear in the world
    private let nodeSpacing: Float = 0.24
    
    // The root position of the menu, and therefore any scenes rendered through Atlas
    private let rootPosition: SCNVector3 = SCNVector3Make(0, 0, -0.4)//-1)
    
    // A dictionary for accessing the menu items using their database reference key
    // Note that the key is the unique ID of this scene in the database, and can
    // therefore be used as a safe reference at any point.
    private var menu: [String: MenuItem] = [:]
    
    // All the possible selections the user can choose from
    // [ DEPRECATED ]
    // var menu = [MenuItem]()
    
    public init() {}
    public func parseFileNameToPrefix() {}
    public func handleSelection() {}
    public func getNodes() {}
    public func getItems() {}
    public func getLabel() {}
}

public class MenuItem {
    public init() {}
}
