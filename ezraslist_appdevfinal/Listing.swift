//
//  Listing.swift
//  ezraslist_appdevfinal
//
//  Created by Sophia Wang on 12/8/19.
//  Copyright © 2019 Sophia Wang. All rights reserved.
//

import Foundation
import UIKit

struct Listing: Codable {
    let id: Int
    let name: String
    let owner: Owner
    let category: String
    let description: String
    let price: String
}
struct Owner: Codable{
    let id: Int
    let name: String
}

struct ListingSearchResponse: Codable{
    let data: [Listing]
    let success: Bool
}




