//
//  ProductCellView.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 05/07/24.
//

import SwiftUI

struct ProductCellView: View {
    
    let product: Product
    
    var body: some View {
        HStack (alignment: .top, spacing:  12){
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                 
            } placeholder: {
                ProgressView()
            }
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
            VStack (alignment: .leading, spacing: 4){
                Text(product.title ?? "")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text("Price: S" + String(product.price ?? 0.0))
                Text("Rating:" + String(product.rating ?? 1.0))
                Text("Category:" + (product.category?.rawValue ?? ""))
                Text("Brand:" + String(product.brand ?? "n/a"))
            }
            .font(.callout)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
   ProductCellView(product: Product(id: 1))
    //ProductCellView(product: Product.init(from: Product(id: 1) as! Decoder))
}
