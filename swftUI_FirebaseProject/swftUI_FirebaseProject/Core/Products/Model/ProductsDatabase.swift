// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dataProducts = try? JSONDecoder().decode(DataProducts.self, from: jsonData)

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dataProducts = try? JSONDecoder().decode(DataProducts.self, from: jsonData)

import Foundation

// MARK: - DataProducts
struct DataProducts: Codable {
    var products: [Product]?
    var total, skip, limit: Int?
}

// MARK: - Product
struct Product: Codable, Identifiable, Equatable {
    var id: Int
    var title, description: String?
    var category: Category?
    var price, discountPercentage, rating: Double?
    var stock: Int?
    var tags: [String]?
    var brand, sku: String?
    var weight: Int?
    var dimensions: Dimensions?
    var warrantyInformation, shippingInformation: String?
    var availabilityStatus: AvailabilityStatus?
    var reviews: [Review]?
    var returnPolicy: ReturnPolicy?
    var minimumOrderQuantity: Int?
    var meta: Meta?
    var images: [String]?
    var thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case price
        case discountPercentage
        case rating
        case stock
        case tags
        case brand
        case sku
        case weight
        case dimensions
        case warrantyInformation
        case shippingInformation
        case availabilityStatus
        case reviews
        case returnPolicy
        case minimumOrderQuantity
        case meta
        case images
        case thumbnail
    }
    // comparando 2 produtos pelo ID
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

enum AvailabilityStatus: String, Codable {
    case inStock = "In Stock"
    case lowStock = "Low Stock"
}

enum Category: String, Codable {
    case beauty = "beauty"
    case fragrances = "fragrances"
    case furniture = "furniture"
    case groceries = "groceries"
}

// MARK: - Dimensions
struct Dimensions: Codable {
    var width, height, depth: Double?
}

// MARK: - Meta
struct Meta: Codable {
    var createdAt, updatedAt: CreatedAt?
    var barcode: String?
    var qrCode: String?
}

enum CreatedAt: String, Codable {
    case the20240523T085621618Z = "2024-05-23T08:56:21.618Z"
    case the20240523T085621619Z = "2024-05-23T08:56:21.619Z"
    case the20240523T085621620Z = "2024-05-23T08:56:21.620Z"
}

enum ReturnPolicy: String, Codable {
    case noReturnPolicy = "No return policy"
    case the30DaysReturnPolicy = "30 days return policy"
    case the60DaysReturnPolicy = "60 days return policy"
    case the7DaysReturnPolicy = "7 days return policy"
    case the90DaysReturnPolicy = "90 days return policy"
}

// MARK: - Review
struct Review: Codable {
    var rating: Int?
    var comment: String?
    var date: CreatedAt?
    var reviewerName, reviewerEmail: String?
}


//MARK: FUNC PARA ENVIAR TODO O JSON MOCKADO PARA O DB
//    func downloadProductsAndUploadToFirebase() {
//        guard let url = URL(string: "https://dummyjson.com/products") else { return }
//
//        Task {
//            do {
//                let (data, _) = try await URLSession.shared.data(from: url)
//                let products = try JSONDecoder().decode(DataProducts.self, from: data)
//                let productArray = products.products
//
//                for product in productArray {
//                    try await ProductsManager.shared.uploadProduct(product: product)
//                }
//
//                print("SUCCESS")
//                print(products.products.count)
//            } catch {
//                print(error)
//            }
//        }
//    }
