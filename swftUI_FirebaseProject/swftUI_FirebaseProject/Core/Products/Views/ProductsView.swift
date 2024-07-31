//
//  ProductsView.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 04/07/24.
//

import SwiftUI


struct ProductsView: View {
    
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
                    .contextMenu {
                        Button("Add to favorite") {
                            viewModel.addUserFavoriteProduct(productId: product.id)
                        }
                    }
                
                if product == viewModel.products.last {
                    ProgressView()
                        .onAppear() {
                            viewModel.getProducts()
                    }
                }
            }
            
        }
        
        .navigationTitle("Products")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "none")"){
                    ForEach(ProductsViewModel.FilterOption.allCases, id: \.self){ options in
                        Button(options.rawValue) {
                            Task {
                                try await viewModel.filterSelected(option: options)
                            }
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "none")"){
                    ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self){ options in
                        Button(options.rawValue) {
                            Task {
                                try await viewModel.categorySelected(option: options)
                            }
                        }
                    }
                }
            }
        })
        .onAppear {
            //  viewModel.getProductsCount()
            viewModel.getProducts()
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
