//
//  ProductCellViewBuilder.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 18/07/24.
//

import SwiftUI

struct ProductCellViewBuilder: View {
    
    let productId: String
    @State private var product: Product? = nil
    
    var body: some View {
        ZStack {
            if let product {
                ProductCellView(product: product)
            }
        }
       // .background(Color.cyan)
        .task {
            self.product = try?  await ProductsManager.shared.getProduct(productId: productId)
        }
    }
}

#Preview {
    ProductCellViewBuilder(productId: "1")
}
