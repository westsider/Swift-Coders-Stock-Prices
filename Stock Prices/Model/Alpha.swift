//
//  Alpha.swift
//  Stock Prices
//
//  Created by Warren Hansen on 3/17/18.
//  Copyright © 2018 Warren Hansen. All rights reserved.
//  https://www.alphavantage.co/documentation/

import Foundation

protocol AlphaDelegate: class {
    func changeUImessageAlpha(message:String)
}

class Alpha {
    
    weak var delegate: AlphaDelegate?
    let alphaApiKey = "T8A2PPT26G83RF68"
    
    func getPricesFor(ticker:String, debug:Bool, callback: @escaping (Array<AnyObject>) -> ()) {
        
        guard let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(ticker)&apikey=\(alphaApiKey)") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print("\(error.debugDescription)")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                return
            }
            if debug { print(json) }
            
            var priceArry:[(date:Date, close:Double)] = []
            guard let time = json["Time Series (Daily)"] as? NSDictionary else { return }
            
            for (key, value) in time {
                guard let stringDate:String = key as? String  else { return }
                guard let date = Utilities.convertToDateFrom(string: stringDate, debug: false) else { return }
                guard let value = value as? Dictionary<String, String>  else { return }
                guard let close = value["4. close"] else { return }
                let closeDouble = (close as NSString).doubleValue
                self.delegate?.changeUImessageAlpha(message: "\(date) Close: \(closeDouble)")
                priceArry.append((date: date , close: closeDouble))
            }
            
            let dateSort = priceArry.sorted(by: {$0.date < $1.date})
            
            if debug {
                for each in dateSort {
                    print("\(each.date) \t\(each.close)")
                }
            }
            callback(dateSort as Array<AnyObject>)
        }
        task.resume()
    }
}


