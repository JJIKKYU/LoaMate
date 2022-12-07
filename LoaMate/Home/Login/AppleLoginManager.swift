//
//  AppleLoginManager.swift
//  LoaMate
//
//  Created by 정진균 on 2022/12/07.
//

import AuthenticationServices

protocol AppleLoginManagerDelegate {
    func appleLoginSuccess(email: String)
    func appleLoginFail()
}

final class AppleLoginManager: NSObject {
    weak var viewController: UIViewController?
    var delegate: AppleLoginManagerDelegate?
    
    func setAppleLoginPresentationAnchorView(_ view: UIViewController) {
        self.viewController = view
    }
    
    /// JWTToken -> dictionary
    private func decode(jwtToken jwt: String) -> [String: Any] {
        
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")

            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 = base64 + padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }

        func decodeJWTPart(_ value: String) -> [String: Any]? {
            guard let bodyData = base64UrlDecode(value),
                  let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
            }

            return payload
        }
        
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    private func saveKeyChain(userIdentifier: String, userEmail: String) {
        print("AppleLoginManager :: saveKeyChain!")
        let keychainItem = [
            kSecValueData: userIdentifier.data(using: .utf8)!,
            kSecAttrAccount: userEmail,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        let status = SecItemAdd(keychainItem, nil)
        print("Operation finished with status: \(status)")
    }
}

extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController!.view.window!
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("AppleLoginManager :: authorizationControllerdidCompleteWithAuthorization!")

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            let userIdentifier = appleIDCredential.user //userIdentifier
            var userEmail = appleIDCredential.email ?? "" //email
            
            if userEmail.isEmpty { /// 2번째 애플 로그인부터는 email이 identityToken에 들어있음.
                if let tokenString = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8) {
                    userEmail = decode(jwtToken: tokenString)["email"] as? String ?? ""
                }
            }

            print("AppleLoginManager :: userIdentifier = \(userIdentifier), email = \(userEmail)")
            saveKeyChain(userIdentifier: userIdentifier, userEmail: userEmail)
            delegate?.appleLoginSuccess(email: userEmail)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleLoginManager :: authorizationControllerWithError!")
        delegate?.appleLoginFail() //apple 로그인 실패
    }
}
