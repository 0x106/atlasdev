
import Foundation
import ARKit

public class Menu {
    
    /// How far apart (in metres) the menu items will appear in the world
    private let nodeSpacing: Float = 0.24
    
    /// The root position of the menu, and therefore any scenes rendered through Atlas
    private let rootPosition: SCNVector3 = SCNVector3Make(0, 0, -0.4)//-1)
    
    /// A dictionary for accessing the menu items using their database reference key
    // Note that the key is the unique ID of this scene in the database, and can
    // therefore be used as a safe reference at any point.
    private var menu: [String: MenuItem] = [:]
    
    // All the possible selections the user can choose from
    // [ DEPRECATED ]
    // var menu = [MenuItem]()
    
    public init() {}
    
    @available(iOS 9.0, *)
    public init( _ config: [String : NSDictionary]? ) {
        let keys = config!["applications"]?.allKeys
        
        for (index, key) in (keys!).enumerated() {
            let value = (config!["applications"]?[key] as! NSDictionary)["aid"] as! String
            let fname = parseFileNameToPrefix(value)
            let item = MenuItem( key as! String, fname )
            self.menu[key as! String] = item
            
            let x = Float(index) * self.nodeSpacing //* 0.1
            item.applyTransform(x + self.rootPosition.x, 0 + self.rootPosition.y, 0 + self.rootPosition.z)
        }
    }
    
    public func getNodes() -> [SCNNode] {
        var retval: [SCNNode] = [SCNNode]()
        
        for key in menu.keys {
            retval.append((menu[key]?.node)!)
        }
        
        return retval
    }
        
    public func handleSelection(withKey key: String) -> Bool {
        return (menu[key]?.handleItemSelected())! // returns true if safe to download file
    }
}


// should this be a subclass of Menu?
public class MenuItem {
    
    /// the public text representation of the scene
    var label: String
    
    // the unique ID for this scene
    var key: String
    
    /// the object the user views and interacts with
    var node: SCNNode
    
    /// the size in meters of the visible nodes
    var size: Float = 0.05
    
    /**
         Creates a menu item
         - Parameters:
             - key: unique ID
             - label: the name the user sees
     */
    @available(iOS 9.0, *)
    public init(_ key: String, _ label: String) {
        self.label = label
        self.key = key
        
        self.node = SCNNode()
        
        let depth: Float = 0.01
        
        // TEXT BILLBOARD CONSTRAINT
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        // TEXT
        let text = SCNText(string: self.label, extrusionDepth: CGFloat(depth))
        let font = UIFont(name: "Futura", size: 0.15)
        text.font = font
        text.alignmentMode = kCAAlignmentCenter
        text.firstMaterial?.diffuse.contents = UIColor.magenta
        text.firstMaterial?.specular.contents = UIColor.white
        text.firstMaterial?.isDoubleSided = true
        text.chamferRadius = CGFloat(depth)
        
        // TEXT NODE
        let (minBound, maxBound) = text.boundingBox
        let textNode = SCNNode(geometry: text)
        textNode.name = "text"
        // Centre Node - to Centre-Bottom point
        textNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, depth/2)
        // Reduce default text size
        textNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        
        // CENTRE POINT NODE
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.cyan
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.name = "sphere"
        
        // text is rendered differently according to whether there are letters like p, etc
        // that extend below other letters. We therefore need to move the spheres down a bit
        // to account for this.
        let sphereTranslation = SCNMatrix4MakeTranslation(0, -0.01, 0)
        sphereNode.transform = sphereTranslation
        
        // TEXT PARENT NODE
        let textNodeParent = SCNNode()
        
        // important that this is added here
        textNodeParent.name = self.key
        textNodeParent.addChildNode(textNode)
        textNodeParent.addChildNode(sphereNode)
        textNodeParent.constraints = [billboardConstraint]
        
        self.node = textNodeParent
    }
    
    public func applyTransform(_ x: Float, _ y: Float, _ z: Float = 0) {
        let matrix = translate(x, y, z)
        self.node.transform = matrix
        print(self.node.position)
    }
    
    private func translate(_ x: Float, _ y: Float, _ z: Float = 0) -> SCNMatrix4 {
        return SCNMatrix4MakeTranslation(x, y, z)//x * self.size, y * self.size, z * self.size)
    }
    
    public func handleItemSelected() -> Bool {
        
        var retval: Bool = false
        
        // make checks
        
        if retval {
            let textNode = self.node.childNode(withName: "text", recursively: true)
            textNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
            textNode?.geometry?.firstMaterial?.transparency = CGFloat(0.75)
            
            let sphereNode = self.node.childNode(withName: "sphere", recursively: true)
            sphereNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.green
            sphereNode?.geometry?.firstMaterial?.transparency = CGFloat(0.75)
        }
        
        return retval
    }
}
