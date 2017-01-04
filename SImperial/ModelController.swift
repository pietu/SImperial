//
//  ModelController.swift
//  SImperial
//
//  Created by Petteri Parkkila on 21/11/16.
//  Copyright © 2016 Pietu. All rights reserved.
//

import UIKit
import Foundation

protocol MyMeasurement {
  var header: String { get }
  var SIValues: [Dictionary<String, Dimension>] { get }
  var imperialValues: [Dictionary<String, Dimension>] { get }
  func convert(fromUnit: Dimension, toUnit: Dimension, fromValue: Double) -> Double
}

struct Temperature: MyMeasurement {
    var header: String {
        return "Temperature"
    }

    var SIValues: [Dictionary<String, Dimension>] {
        return [["Celcius": UnitTemperature.celsius]]
    }

    var imperialValues: [Dictionary<String, Dimension>] {
        return [["Fahrenheit": UnitTemperature.fahrenheit]]
    }

    internal func convert(fromUnit: Dimension, toUnit: Dimension, fromValue: Double) -> Double {
      return Measurement(value: fromValue, unit: fromUnit).converted(to: toUnit).value
    }
}

struct Mass: MyMeasurement {
    var header: String {
        return "Mass"
    }

    var SIValues: [Dictionary<String, Dimension>] {
        return [["Grams": UnitMass.grams],
                ["Kilograms": UnitMass.kilograms],
                ["Metric tons": UnitMass.metricTons]]
    }

    var imperialValues: [Dictionary<String, Dimension>] {
        return [["Ounces": UnitMass.ounces],
                ["Pounds": UnitMass.pounds]]
    }

    internal func convert(fromUnit: Dimension, toUnit: Dimension, fromValue: Double) -> Double {
      return Measurement(value: fromValue, unit: fromUnit).converted(to: toUnit).value
    }
}

struct Length: MyMeasurement {
    var header: String {
        return "Length"
    }

    var SIValues: [Dictionary<String, Dimension>] {
        return [["Millimeters": UnitLength.millimeters],
                ["Centimeters": UnitLength.centimeters],
                ["Meters": UnitLength.meters],
                ["Kilometers": UnitLength.kilometers]]
    }

    var imperialValues: [Dictionary<String, Dimension>] {
        return [["Inches": UnitLength.inches],
                ["Feet": UnitLength.feet],
                ["Yards": UnitLength.yards],
                ["Miles": UnitLength.miles]]
    }

    internal func convert(fromUnit: Dimension, toUnit: Dimension, fromValue: Double) -> Double {
      return Measurement(value: fromValue, unit: fromUnit).converted(to: toUnit).value
    }
}

struct Volume: MyMeasurement {
    var header: String {
        return "Volume"
    }

    var SIValues: [Dictionary<String, Dimension>] {
        return [["Milliliters": UnitVolume.milliliters],
                ["Deciliters": UnitVolume.deciliters],
                ["Liters": UnitVolume.liters],
                ["Cubic Meters": UnitVolume.cubicMeters]]
    }

    var imperialValues: [Dictionary<String, Dimension>] {
        return [["US Teaspoons": UnitVolume.teaspoons],
                ["US Tablespoons": UnitVolume.tablespoons],
                ["US fluid Ounces": UnitVolume.fluidOunces],
                ["US liquid Cups": UnitVolume.cups],
                ["US liquid Pints": UnitVolume.pints],
                ["US Quarts": UnitVolume.quarts],
                ["US liquid Gallons": UnitVolume.gallons],
                ["Cubic Feet": UnitVolume.cubicFeet],
                ["Imperial Teaspoons": UnitVolume.imperialTeaspoons],
                ["Imperial Tablespoons": UnitVolume.imperialTablespoons],
                ["Imperial fluid Ounces": UnitVolume.imperialFluidOunces],
                ["Imperial Pints": UnitVolume.imperialPints],
                ["Imperial Quarts": UnitVolume.imperialQuarts],
                ["Imperial Gallons": UnitVolume.imperialGallons]]
    }

    internal func convert(fromUnit: Dimension, toUnit: Dimension, fromValue: Double) -> Double {
      return Measurement(value: fromValue, unit: fromUnit).converted(to: toUnit).value
    }
}

struct Area: MyMeasurement {
    var header: String {
        return "Area"
    }

    var SIValues: [Dictionary<String, Dimension>] {
        return [["Square Meters": UnitArea.squareMeters],
                ["Ares": UnitArea.ares],
                ["Hectares": UnitArea.hectares],
                ["Square Kilometers": UnitArea.squareKilometers]]
    }

    var imperialValues: [Dictionary<String, Dimension>] {
        return [["Square Feet": UnitArea.squareFeet],
                ["Acres": UnitArea.acres],
                ["Square Miles": UnitArea.squareMiles]]
    }

    internal func convert(fromUnit: Dimension, toUnit: Dimension, fromValue: Double) -> Double {
      return Measurement(value: fromValue, unit: fromUnit).converted(to: toUnit).value
    }
}

class ModelController: NSObject, UIPageViewControllerDataSource {

    var pageData: [MyMeasurement] = []

    override init() {
        super.init()
        pageData = [Temperature(), Mass(), Length(), Volume(), Area()]
    }

    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> DataViewController? {
        if (self.pageData.count == 0) || (index >= self.pageData.count) {
            return nil
        }

        let dataViewController = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
        dataViewController.dataObject = self.pageData[index]
        return dataViewController
    }

    func indexOfViewController(_ viewController: DataViewController) -> Int {
        if let measurement = viewController.dataObject {
            return pageData.index(where: { (m: MyMeasurement) -> Bool in
                m.header == measurement.header
            })!
        } else {
            return NSNotFound
        }
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }

        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        if index == NSNotFound {
            return nil
        }

        index += 1
        if index == self.pageData.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}
