//
//  SecurityRules.swift
//  swftUI_FirebaseProject
//
//  Created by Alysson Menezes on 31/07/24.
//

import Foundation
// LINKS: https://firebase.google.com/docs/firestore/security/rules-structure?hl=pt-br
// https://firebase.google.com/docs/rules/rules-language?hl=pt-br

//MARK: FIREBASE RULES DB


/*
 
 rules_version = '2';

 service cloud.firestore {
   match /databases/{database}/documents {
   
     match /users/{userId} {
       allow read: if request.auth != null;
       allow write: if request.auth != null && request.auth.uid == userId;
     }
     
     // permitindo adicionar produtos aos favoritos
     match /users/{userId}/favorite_products/{userFavoriteProductID} {
          allow read, write : if request.auth != null && request.auth.uid == userId
       
     }
     
     match /products/{productId} {
     //    allow read, write : if request.auth != null;
    // allow create: if request.auth != null;
   // allow read: if request.auth != null && isAdmin(request.auth.uid);
       allow read: if request.auth != null;
     allow create: if request.auth != null && isAdmin(request.auth.uid);
     allow update: if request.auth != null && isAdmin(request.auth.uid);
       allow delete: if false
     }
     
     function isPublic(){
     return resource.data.visibility == "public";
     }
     
     function isAdmin(userId) {
    // let adminIds = ["OPqdxAiuNYh1qHlvDGSVs5YqCZy1", "admin02..."];
     //    return userId in adminIds;
     
     return exists(/databases/$(database)/documents/admins/$(userId));
     }
   }
 }

 // read
 // get - single document reads
 // list - queries and collection read request/
 //
 // write
 // create
 // update
 // delete

 
 */
