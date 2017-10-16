import Foundation
import ARKit
import Alamofire

@available(iOS 11.0, *)
public class Atlasdev {

    let uid: String
    var authStatus: AuthType
    var domain: String
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
        
        self.domain = "https://1198c843.ngrok.io/"
        
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
        Alamofire.request(requestURL, method: .get, parameters: parameters).responseJSON { response in
            if let data = response.data {
                output = parseResponseToDict(data)
            }
            completion(output)
        }
    }
    
    /**
         Construct the menu.
         - Parameter: config: list of available scenes and their properties
     */
    private func constructMenu(_ config: [String: NSDictionary]?) {
        print("configRequest")
        self.config = config!
        
        if self.config == [:] {
            print("config data is empty - server error.")
        } else {
            self.menu = Menu(self.config)
            
            let menuItems = self.menu.getNodes()
            for item in menuItems {
                self.scene.rootNode.addChildNode(item)
            }
        }
    }
    
    // download completion handler - adds the returned scene to the container app
    private func addScene(withFile input: URL) {
        let source = SCNSceneSource(url: input, options: nil)
        let tempScene = source?.scene(options: nil)
        for child in (tempScene?.rootNode.childNodes)! {
            self.scene.rootNode.addChildNode(child)
        }
    }
    
    /// Download the .atlas file selected by the user
    private func downloadRequest(forKey key: String, completion: @escaping (_ input: URL) -> ()) {
        print("downloadRequest")
        
        let parameters = [
            "uid" : self.uid,
            "key" : key
        ]
        
        let requestURL = self.domain + AtlasRequests[AtlasRequestsType.storageDownloadRequest]!
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 500
        
        var output: [String: NSDictionary]? = [:]
        var applicationID: String = ""
        manager.request(requestURL, method: .get, parameters: parameters).responseJSON { response in
            if let data = response.data {
                output = parseResponseToDict(data)
                applicationID = (output!["appMeta"]?["key"] as! String)
            }
            
            var localFile: URL = URL(fileURLWithPath: "")
            
            // if this request has completed then we download the actual file
            // note that this is from Firebase and we don't temporarily store on the server
            let destination: Alamofire.DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                localFile = documentsURL.appendingPathComponent(applicationID+".scn")
                return (localFile, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            // BUG
            // At the moment the downloads folder is public - this is obviously not a valid method
            // Note that we do not include <data/download/> <- as this is taken care of by the app router.
            let remoteFileRequestURL = self.domain + applicationID
            
            manager.download(
                remoteFileRequestURL,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default,
                headers: nil,
                to: destination).downloadProgress(closure: { (progress) in
                }).response(completionHandler: { (DefaultDownloadResponse) in
                    completion(localFile)
                })
        }
    }

    /**
         Perform state updates to the scene in response to user input.
         - Parameters:
             - touches: objects representing each of the touches on the screen.
             - event: the type of the touch
     */
    private func hitTestRequest( _ touches: Set<UITouch>, with event: UIEvent? ) {
        print("hitTestRequest")
        if let touchLocation = touches.first?.location(in: self.view) {
            if let hit = self.view.hitTest(touchLocation, options: nil).first {
                let selectionResponse = menu.handleSelection(withKey: (hit.node.parent?.name)!)
                if selectionResponse {
                    downloadRequest(forKey: (hit.node.parent?.name)!, completion: addScene)
                }
            }
        }
    }

}
