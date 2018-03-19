//
//  ViewController.swift
//  Stock Prices
//
//  Created by Warren Hansen on 3/17/18.
//  Copyright © 2018 Warren Hansen. All rights reserved.
//

import UIKit
import Charts

class MainViewController: UIViewController, AlphaDelegate {
    
    @IBOutlet weak var mainText: UILabel!
    
    @IBOutlet weak var chtChart: LineChartView!
    
    var alphaLink = Alpha()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alphaLink.delegate = self
        getPricesFromNYSE(ticker: "SPY", debug: false)
    }

    
    func updateGraph(data:[(date:Date, close:Double)]) {
        DispatchQueue.main.async {

            var lineChartEntry = [ChartDataEntry]()
            
            let xAxis = self.chtChart.xAxis
            xAxis.labelPosition = .bottomInside
            xAxis.drawGridLinesEnabled = false
            let formatter = ChartStringFormatter()
            
            var dateArray:[String] = []
            for each in data {
                
                let date = Utilities.convertToStringNoTimeFrom(date: each.date)
                dateArray.append(date)
            }
            formatter.nameValues = dateArray
            xAxis.valueFormatter = formatter
            
            for (i, each) in data.enumerated() {

                let value = ChartDataEntry(x: Double(i), y: each.close)
                lineChartEntry.append(value)
            }
            
            let line1 = LineChartDataSet(values: lineChartEntry, label: "close" )
            line1.colors =  [NSUIColor.darkGray]
            line1.drawCirclesEnabled = false
            line1.drawFilledEnabled = true
            let gradientColors = [UIColor.darkGray.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
            let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
            let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
            line1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
            
            let data = LineChartData()
            data.addDataSet(line1)
            self.chtChart.data = data
            self.chtChart.chartDescription?.text = "Daily Price Data"
            self.chtChart.leftAxis.enabled = false
            self.chtChart.animate(xAxisDuration: 2.5)
        }
    }
    
    
    func getPricesFromNYSE(ticker:String, debug:Bool) {
        alphaLink.getPricesFor(ticker: ticker, debug: false) { (response) in
            if let nyseData = response as? [(date:Date, close:Double)] {
                if debug { print(nyseData) }
                self.changeUImessageAlpha(message: "\(ticker)")
                self.updateGraph(data: nyseData)
            }
        }
    }
    
    func changeUImessageAlpha(message:String) {
        print("\nMESSAGE FROM Alpha: \(message)");
        DispatchQueue.main.async {
            self.mainText.text = message
        }
    }
    
}

class ChartStringFormatter: NSObject, IAxisValueFormatter {
    
    var nameValues: [String] =  []
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: nameValues[Int(value)])
    }
}



