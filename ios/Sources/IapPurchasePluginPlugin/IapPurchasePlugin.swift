import Foundation
import UIKit
import StoreKit

@objc public class IapPurchasePlugin: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    private var productsRequest: SKProductsRequest?
    private var availableProducts: [SKProduct] = []
    private var completionHandler: ((String?, Error?) -> Void)?

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    @objc public func purchase(from viewController: UIViewController,
                               productID: String,
                               applicationUsername: String,
                               appAccountToken: String,
                               completion: @escaping (String?, Error?) -> Void) {
        let productIdentifiers = Set([productID])
        self.completionHandler = completion
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.isEmpty {
            print("Продукт не найден на сервере.")
            completionHandler?(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Продукт не найден."]))
            return
        }
        
        availableProducts = response.products

        if let product = availableProducts.first {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            print("Тестируем продукт: \(product.localizedTitle) по цене \(product.priceLocale.currencySymbol ?? "")\(product.price)")
        } else {
            completionHandler?(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Продукт не доступен."]))
        }
    }

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Покупка завершена: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
                completionHandler?("Покупка завершена для продукта \(transaction.payment.productIdentifier)", nil)

            case .failed:
                if let error = transaction.error as NSError?, error.code != SKError.paymentCancelled.rawValue {
                    print("Покупка не удалась: \(transaction.payment.productIdentifier) - \(error.localizedDescription)")
                    completionHandler?(nil, error)
                } else {
                    print("Покупка отменена пользователем.")
                    completionHandler?(nil, NSError(domain: "", code: SKError.paymentCancelled.rawValue, userInfo: [NSLocalizedDescriptionKey: "Покупка отменена пользователем."]))
                }
                SKPaymentQueue.default().finishTransaction(transaction)

            case .restored:
                print("Покупка восстановлена: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
                completionHandler?("Покупка восстановлена для продукта \(transaction.payment.productIdentifier)", nil)

            default:
                break
            }
        }
    }
}
