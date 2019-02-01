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

class RestaurantNetworkModel {
    
    private let queryURL = "https://eda.yandex/api/v2/catalog?latitude=55.762885&longitude=37.597360"
    
    // MARK: - Public API
    func fetchRestaurants(onFailure: @escaping (Error) -> Void ) -> Driver<[Restaurant]> {
    
        return RxAlamofire
            .requestJSON(.get, queryURL, parameters: [:], encoding: JSONEncoding.default, headers: [:])
            .catchError({ error in
                onFailure(error)
                return Observable.never()
            })
            .map { (arg) -> [Restaurant] in
                let (_, rawdata) = arg
                let data = try JSONSerialization.data(withJSONObject: rawdata, options: [])
                let json = try JSON(data: data)
                return self.parseRestaurantsArrayFrom(json: json)
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    // MARK: - Private functions
    private func parseRestaurantsArrayFrom(json: JSON) -> [Restaurant] {
        
        let restaurants = json["payload"]["foundPlaces"].arrayValue.map {
            
            Restaurant(id: $0["place"]["id"].int,
                       name: $0["place"]["name"].string,
                       description: $0["place"]["description"].string,
                       url: $0["place"]["picture"]["uri"].string,
                       aspectRatio: $0["place"]["picture"]["ratio"].float)
        }
        return restaurants
    }
}
