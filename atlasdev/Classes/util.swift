
import Foundation

enum AuthType {
    case notSignedIn
    case signedIn
    case notLoggedIn
    case loggedIn
}

enum AtlasRequestsType {
    case userLogInConfigRequest
    case storageUploadRequest
    case storageDownloadRequest
}

enum AtlasErrorType {
    case couldNotLogInUser
    case couldNotRetrieveConfig
    case couldNotAccessDomain
    case couldNotBuildItem
    case couldNotRetrieveScene
}


// error messages for various circumstances
let AtlasError = [
    AtlasErrorType.couldNotLogInUser : "",
    AtlasErrorType.couldNotRetrieveConfig : "",
    AtlasErrorType.couldNotAccessDomain : "",
    AtlasErrorType.couldNotBuildItem : "",
    AtlasErrorType.couldNotRetrieveScene : ""
]

// server API calls
let AtlasRequests = [
    AtlasRequestsType.userLogInConfigRequest : "core/database/userLogIn",
    AtlasRequestsType.storageDownloadRequest : "core/storage/download"
]

let AtlasDEBUG: Bool = true


public func parseResponseToDict(_ input: Data) -> [String : NSDictionary]? {
    do {
        let output = try JSONSerialization.jsonObject(with: input, options: []) as? [String : NSDictionary]
        return output
    } catch let error {
        print("ERROR: ", error)
    }
    // default return - may need to ensure that the block above completes before this is returned
    return [:]
}

public func parseFileNameToPrefix(_ input: String) -> String{
    let endOfSentence = input.index(before: (input.index(of: "."))!)
    let output = String(input[...(endOfSentence)])
    return output
}
