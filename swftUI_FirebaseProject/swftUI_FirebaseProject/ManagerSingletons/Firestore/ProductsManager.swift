//
//  ProductsManager.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 04/07/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ProductsManager {
    
    static let shared = ProductsManager()
    private init() {}
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId).getDocument(as: Product.self)
    }
    
    func getAllProducts() async throws -> [Product]{
        try await productsCollection.getDocument2(as: Product.self)
    }
}

extension Query {
    //passando qualquer tipo para a func
    // Func com tipo generico T onde o tipo esteja em conformidade com o protocolo Decodable
    func getDocument2<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map({ document in
            try document.data(as: T.self)
            
        })
    }
    
    
}
