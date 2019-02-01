//
//  NetworkModel.swift
//  Eda
//
//  Created by Шпинев Виталий Васильевич on 14/01/2019.
//  Copyright © 2019 Шпинев Виталий Васильевич. All rights reserved.
//

import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa
import SwiftyJSON

struct NetworkModel {
    
    private let queryURL = "https://eda.yandex/api/v2/catalog?latitude=55.762885&longitude=37.597360"
    
    lazy var rx_Restaurants: Driver<[Restaurant]> = self.fetchRestaurants()

    private func fetchRestaurants() -> Driver<[Restaurant]> {

        return
            
            RxAlamofire.requestJSON(.get, queryURL, parameters: [:], encoding: JSONEncoding.default, headers: [:])
                .catchError({ error in
                    print("Error occured: \(error.localizedDescription)")
                    return Observable.never()
                })
                .map{ (arg) -> [Restaurant] in
                    
                    let ( _, rawdata) = arg
                    let data = try JSONSerialization.data(withJSONObject: rawdata, options: [])
                    let json = try JSON(data: data)
                    
                    let restaurants =  json["payload"]["foundPlaces"].arrayValue.map {
                        
                        Restaurant(id: $0["place"]["id"].intValue,
                                   name: $0["place"]["name"].stringValue,
                                   description: $0["place"]["description"].stringValue,
                                   url: $0["place"]["picture"]["uri"].stringValue,
                                   aspectRatio: $0["place"]["picture"]["ratio"].floatValue)
                    }
                    return restaurants
        }.asDriver(onErrorJustReturn: [])
    }
}
