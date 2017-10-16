import Foundation
import ARKit
//import Ala

@available(iOS 11.0, *)
public class Atlasdev {

    let uid: String
    var authStatus: AuthType
    let domain: String
    var config: [String : NSDictionary]

    var menu = Menu() // initialise as a default (empty menu)

    var scene: SCNScene
    var view: ARSCNView

    
    /**
         Initialises all the class properties with default values.
         - Parameter rootSceneView: The default scene view from the container application.
     */
    public init( _ rootSceneView: ARSCNView ) {
        print("Atlasdev initialisation.")
        
        // default initialisations
        self.uid = "default"
        self.domain = "default"
        self.config = [:]
        
        self.authStatus = AuthType.notLoggedIn
    
        self.view = rootSceneView
        self.scene = self.view.scene
        
        self.setup()
    }

    /// Performs a series of step to allow the user to access Atlas content.
    private func setup() {
        print("setup")
        
        // authenticate user
        self.authStatus = authenticate()
        
        if self.authStatus == AuthType.loggedIn {
            // retrieve config data && construct menu in completion
            configRequest(completion: constructMenu)
        } else {
            print("User \(self.uid) is not logged in.")
        }
        
    }
    
    /**
         Authenticate the current user.
         - Returns: authorisation status of the current user
     */
    private func authenticate() -> AuthType {
        print("authenticate")
        var retval = AuthType.loggedIn
        return retval
    }
    
    
    /**
         Retrieve the atlas configuration data.
         - Parameter: completion: build the menu from the config data when the request is processed.
     */
    private func configRequest( completion: @escaping (_ config: [String: NSDictionary]?) -> () ) {
        print("configRequest")
        
        // send a get request to <self.domain>/core/database/userLogIn
        let parameters = [
            "uid" : self.uid as! String
        ]
        
        let requestURL = self.domain + AtlasRequests[AtlasRequestsType.userLogInConfigRequest]!
        var output: [String: NSDictionary]? = [:]
//        Alamofire.request(requestURL, method: .get, parameters: parameters).responseJSON { response in
//            if let data = response.data {
//                output = self.parseResponseToDict(data)
//                let keys = output!["applications"]?.allKeys
//            }
//            completion(output)
//        }
    }
    
    /**
         Construct the menu.
         - Parameter: config: list of available scenes and their properties
     */
    private func constructMenu(_ config: [String: NSDictionary]?) {
        print("configRequest")
        self.config = config!
//        self.menu = Menu(self.userAppConfig)
        
//        let menuItems = self.getMenuNodes()
//        for item in menuItems {
//            self.scene.rootNode.addChildNode(item)
//        }
    }
    
    /// Download the .atlas file selected by the user
    private func downloadRequest() {
        print("setup")
    }

    /**
         Perform state updates to the scene in response to user input.
         - Parameters:
             - touches: objects representing each of the touches on the screen.
             - event: the type of the touch
     */
    private func hitTestRequest( _ touches: Set<UITouch>, with event: UIEvent? ) {
        print("setup")
    }

}
