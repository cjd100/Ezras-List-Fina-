//
//  NetworkManager.swift
//  ezraslist_appdevfinal
//
//  Created by Sophia Wang on 12/8/19.
//  Copyright © 2019 Sophia Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class NetworkManager {
    
    private static let baseURL = "http://35.231.255.11/"
    private static let userURL = "api/users/"
    private static let listingURL = "api/items/"
    private static let searchURL = "search/"


    static func getAllListings(_ didGetListings: @escaping ([Listing]) -> Void){
        
        Alamofire.request(baseURL + listingURL, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let results):
                let jsonDecoder = JSONDecoder()
                var listings : [Listing] = []
                if let listingData = try? jsonDecoder.decode(ListingSearchResponse.self, from: results) {
                    let data = listingData.data
                    for l in data{
                        listings.append(l)
                        }
                    }
                didGetListings(listings)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
            
        
    }
    
    static func getListings(fromSearch category: String, _ didGetListings: @escaping ([Listing]) -> Void) {
        let jsonObject : [String:String] = ["category": category]
        Alamofire.request(baseURL + listingURL + searchURL, method: .post, parameters: jsonObject , encoding: JSONEncoding.default).responseData { response in
            switch response.result{
                case .success(let results):
                    let jsonDecoder = JSONDecoder()
                    var listings : [Listing] = []
                    if let listingData = try? jsonDecoder.decode(ListingSearchResponse.self, from: results) {
                    let data = listingData.data
                    for l in data{
                        if(l.category == category){
                            listings.append(l)
                        }
                        }
                    }
                didGetListings(listings)
 
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
    }
    
    static func addListing(parameters: [String: Any],  _ didAddListing: @escaping () -> Void){
        Alamofire.request(baseURL + listingURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                print(response)
            didAddListing()
        }
      }
    static func deleteListing(numberID: Int, _ didDeleteListing: @escaping () -> Void){
        Alamofire.request(baseURL+listingURL + String(numberID) + "/", method: .delete, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            print(response)
            didDeleteListing()
        }
    }



}
