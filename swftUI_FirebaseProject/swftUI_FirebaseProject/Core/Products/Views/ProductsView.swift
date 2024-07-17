//
//  ProductsView.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 04/07/24.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil
    
    enum FilterOption: String, CaseIterable {
        // CaseIterable para interagir com for
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter : return nil
            case.priceHigh : return true
            case.priceLow : return false
            }
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
        self.selectedFilter = option
        self.getProducts()
    }
    
    enum CategoryOption: String, CaseIterable {
        // CaseIterable para interagir com for
        case noCategory
        case beauty
        case furniture
        case groceries
        case fragrances
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.getProducts()
    }
    
    func getProducts() {
        Task {
            self.products = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forcategory: selectedCategory?.categoryKey)
        }
    }
    func getProductsByRating() {
        Task {
            let (newProducts, lastDocument) = try await ProductsManager.shared.getProductsByRating(count: 3, lastDocument: lastDocument)
            self.products.append(contentsOf: newProducts)
            self.lastDocument = lastDocument
        }
    }
}

struct ProductsView: View {
    
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
            }
            Button("Fetch products") {
                viewModel.getProductsByRating()
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
            // viewModel.getProducts()
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
