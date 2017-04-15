//
//  ViewController.swift
//  Chart
//
//  Created by Ted Zhang on 4/14/17.
//  Copyright © 2017 Ted Zhang. All rights reserved.
//

import UIKit
import Gloss
import SWXMLHash
import Charts

class ViewController: UIViewController {
    
    fileprivate var barView:BarChartView!
    fileprivate var lineView:LineChartView!
    fileprivate var chartData:[ChartDataModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        barView = BarChartView(frame: CGRect.zero)
        lineView = LineChartView(frame: CGRect.zero)
        
        if let chartData = readJson() {
            self.chartData = chartData
            
//            drawBarChart(data: chartData)
            drawLineChart(data: chartData)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

import EasyPeasy

//MARK: - Charts Methods

extension ViewController {
    
    fileprivate func drawBarChart(data:[ChartDataModel]) {
        barView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barView)
        
        barView <- [
            Edges(20)
        ]
        
        barView.noDataText = "You need to provide data for the chart."
        let description = Description()
        description.text = "Spiral Chart"
        barView.chartDescription = description
        barView.fitBars = true
        
        var dataEntries: [BarChartDataEntry] = []
        
        data.forEach( { model in
            let entry = BarChartDataEntry(x: model.start ?? 0.1, y: (model.ftp ?? 0.1) * 100)
            dataEntries.append(entry)
            let chartDataSet = BarChartDataSet(values: dataEntries, label: nil)
            chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
            
            let chartData = BarChartData(dataSets: [chartDataSet])
            chartData.barWidth = 0.1
            
            barView.data = chartData
            
        })
        
    }
    
    fileprivate func drawLineChart(data:[ChartDataModel]) {
        lineView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineView)
        
        lineView <- [
            Edges(20),
            CenterY(),
            Height(*0.5).like(self.view, .height)
        ]
        
        lineView.noDataText = "You need to provide data for the chart."
        let description = Description()
        description.text = ""
        description.textAlign = .right
        description.textColor = UIColor.white
        description.font = UIFont.systemFont(ofSize: 25)
        lineView.chartDescription = description
        
        var dataEntries: [ChartDataEntry] = []
        
        data.forEach( { model in
            let entry = ChartDataEntry(x:model.start ?? 0.1, y: max( 0.2, (model.ftp ?? 0.1)) )
            dataEntries.append(entry)
            
            let chartDataSet = LineChartDataSet(values: dataEntries, label: nil)
            chartDataSet.mode = .stepped
            chartDataSet.drawCirclesEnabled = false
            chartDataSet.lineWidth = 0
            chartDataSet.drawVerticalHighlightIndicatorEnabled = false
            chartDataSet.drawFilledEnabled = true
            chartDataSet.fill = Fill(color: UIColor.purple)
            let chartData = LineChartData(dataSets: [chartDataSet])
            lineView.data = chartData
        })
    }
 
}

//MARK: - Data Methods

extension ViewController {
    
    fileprivate func readJson() -> [ChartDataModel]? {
        do {
            if let file = Bundle.main.url(forResource: "data", withExtension: "json") {
                let data = try Data(contentsOf: file)
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [JSON] {
                        
                        if let dataModels = [ChartDataModel].from(jsonArray: json) {
                            return dataModels
                        }
                    }
                } catch {
                    print("\(#file) : convert json to dictionary went wrong \(#function)")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
}
