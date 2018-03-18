//
//  ViewController.swift
//  Stock Prices
//
//  Created by Warren Hansen on 3/17/18.
//  Copyright © 2018 Warren Hansen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, AlphaDelegate {

    @IBOutlet weak var mainText: UILabel!
    
    var alphaLink = Alpha()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alphaLink.delegate = self
        getPricesFromNYSE(debug: false)
    }

    func getPricesFromNYSE(debug:Bool) {
        alphaLink.getPricesFor(ticker: "SPY", debug: false) { (response) in
            if let nyseData = response as? [(date:Date, close:Double)] {
                if debug { print(nyseData) }
                self.changeUImessageAlpha(message: "We have data from NYSE")}
        }
    }
    
    func changeUImessageAlpha(message:String) {
        print("\nMESSAGE FROM Alpha: \(message)");
        DispatchQueue.main.async {
            self.mainText.text = message
        }
    }

}


