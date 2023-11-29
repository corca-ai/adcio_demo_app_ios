//
//  ProductEntity.swift
//  adcio_demo_app_ios
//
//  Created by 유현명 on 11/9/23.
//

import Foundation

struct ProductEntity: Codable {
    let id: String
    let name: String
    let image: String
    let price: Int
    let seller: String
    var isAd: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name (KO)"
        case image = "Image URL"
        case price = "Customer Price"
        case seller = "Winery"
    }
}
