//
//  Restaurant.swift
//  Eda
//
//  Created by Шпинев Виталий Васильевич on 14/01/2019.
//  Copyright © 2019 Шпинев Виталий Васильевич. All rights reserved.
//


class Restaurant {
    var id: Int?
    var name: String?
    var description: String?
    var url: String?
    var aspectRatio: Float?

    init(id: Int?, name: String?, description: String?, url: String?, aspectRatio: Float?) {
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.aspectRatio = aspectRatio
    }
}
