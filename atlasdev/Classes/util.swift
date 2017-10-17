
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
    case configEmtpy
}


// error messages for various circumstances
let AtlasError = [
    AtlasErrorType.couldNotLogInUser : "",
    AtlasErrorType.couldNotRetrieveConfig : "",
    AtlasErrorType.couldNotAccessDomain : "",
    AtlasErrorType.couldNotBuildItem : "",
    AtlasErrorType.couldNotRetrieveScene : "Error downloading the selected scene file: returning from execution. User can try again.",
    AtlasErrorType.configEmtpy : "config data is empty - server error. The user will not see any menu items, but your application will continue to run."
]

// server API calls
let AtlasRequests = [
    AtlasRequestsType.userLogInConfigRequest : "core/database/userLogIn",
    AtlasRequestsType.storageDownloadRequest : "core/storage/download"
]

let AtlasDEBUG: Bool = true

//public func isError(with input: Any) -> Bool {
//
//    var retval = false
//
//    for error in AtlasError {
//        if input
//    }
//
//    return retval
//}

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

public func parseFileNameToPrefix(_ input: String) -> String {
    let endOfSentence = input.index(before: (input.index(of: "."))!)
    let output = String(input[...(endOfSentence)])
    return output
}
