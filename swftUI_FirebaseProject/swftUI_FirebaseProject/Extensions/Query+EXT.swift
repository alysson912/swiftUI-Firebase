//
//  Query+EXT.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 23/07/24.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Query {
    //passando qualquer tipo para a func
    // Func com tipo generico T onde o tipo esteja em conformidade com o protocolo Decodable

    func getDocument<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).products
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
            return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration)  where T : Decodable {
        let publisher = PassthroughSubject<[T], Error>()
         
        let listener = self.addSnapshotListener { querySnapshot, error in
             guard let  documents = querySnapshot?.documents else {
                 print("No documents")
                 return
             }
             let products: [T] = documents.compactMap ({ try? $0.data(as: T.self) })
             publisher.send(products)
             
         
             }
        return (publisher.eraseToAnyPublisher(), listener)
    }
}


