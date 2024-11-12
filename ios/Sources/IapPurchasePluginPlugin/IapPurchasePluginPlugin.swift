import Foundation
import Capacitor
import SwiftUI

@objc(IapPurchasePluginPlugin)
public class IapPurchasePluginPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "IapPurchasePluginPlugin"
    public let jsName = "IapPurchasePlugin"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "purchase", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = IapPurchasePlugin()

    @objc func purchase(_ call: CAPPluginCall) {
        let productID = call.getString("productID") ?? "default.productID"
        let applicationUsername = call.getString("applicationUsername") ?? "default.applicationUsername"
        let appAccountToken = call.getString("appAccountToken") ?? "default.appAccountToken"

        print("Запрос на покупку продукта с ID: \(productID)")
        print(applicationUsername)
        print(appAccountToken)

        if let viewController = self.bridge?.viewController {
            self.implementation.purchase(from: viewController,
                                         productID: productID,
                                         applicationUsername: applicationUsername,
                                         appAccountToken: appAccountToken) { successMessage, error in
                if let message = successMessage {
                    call.resolve([
                        "status": "success",
                        "message": message
                    ])
                } else if let error = error {
                    call.reject("Ошибка покупки: \(error.localizedDescription)")
                }
            }
        } else {
            call.reject("ViewController не доступен")
        }
    }
}
