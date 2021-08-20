//
// Created by wayto on 2021/7/31.
//

import Foundation
import Alamofire

struct OAuthCredential: AuthenticationCredential, Codable {

    let accessToken: String
    let refreshToken: String
    let userId: Int
    let expiration: Date

    // Require refresh if within 5 minutes of expiration
    var requiresRefresh: Bool {
        Date() >= expiration
    }
}