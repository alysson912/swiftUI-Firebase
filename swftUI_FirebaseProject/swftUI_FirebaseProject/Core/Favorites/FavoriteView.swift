//
//  FavoritesView.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 17/07/24.
//
import Foundation
import SwiftUI
import Combine


struct FavoriteView: View {
    @StateObject private var viewModel = FavoriteViewModel()
    
    
    var body: some View {
        List {
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu {
                        Button("Remove from favorites") {
                           viewModel.removeFromFavorites(favoriteProductId: item.id)
                        }
                        
                    }
                
            }
        }
        .navigationTitle("Favorites")
        .onFirstApper {
            viewModel.addListenerForFavorites()
        }
    }
}


#Preview {
    NavigationStack {
        FavoriteView()
    }
}
