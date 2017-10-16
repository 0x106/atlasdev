
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
