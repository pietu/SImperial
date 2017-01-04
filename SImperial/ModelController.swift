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
        return [["Gram": UnitMass.grams],
                ["Kilogram": UnitMass.kilograms]]
    }

    var imperialValues: [Dictionary<String, Dimension>] {
        return [["Pound": UnitMass.pounds],
                ["Ounce": UnitMass.ounces]]
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
        return [["Millimeter": UnitLength.millimeters],
                ["Centimeter": UnitLength.centimeters],
                ["Meter": UnitLength.meters],
                ["Kilometer": UnitLength.kilometers]]
    }

    var imperialValues: [Dictionary<String, Dimension>] {
        return [["Inch": UnitLength.inches],
                ["Foot": UnitLength.feet],
                ["Yard": UnitLength.yards],
                ["Mile": UnitLength.miles]]
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
        return [["Millilitre": UnitVolume.milliliters],
                ["Decilitre": UnitVolume.deciliters],
                ["Litre": UnitVolume.liters]]
    }

    var imperialValues: [Dictionary<String, Dimension>] {
        return [["US Teaspoon": UnitVolume.teaspoons],
                ["US Tablespoon": UnitVolume.tablespoons],
                ["US fluid Ounce": UnitVolume.fluidOunces],
                ["US liquid Cup": UnitVolume.cups],
                ["US liquid Pint": UnitVolume.pints],
                ["US liquid Gallon": UnitVolume.gallons],
                ["Imperial Teaspoon": UnitVolume.imperialTeaspoons],
                ["Imperial Tablespoon": UnitVolume.imperialTablespoons],
                ["Imperial fluid Ounce": UnitVolume.imperialFluidOunces],
                ["Metric Cup": UnitVolume.metricCups],
                ["Imperial Pint": UnitVolume.imperialPints],
                ["Imperial Gallon": UnitVolume.imperialGallons]]
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
        return [["Square Meter": UnitArea.squareMeters],
                ["Hectare": UnitArea.hectares],
                ["Square Kilometer": UnitArea.squareKilometers]]
    }

    var imperialValues: [Dictionary<String, Dimension>] {
        return [["Square Foot": UnitArea.squareFeet],
                ["Acre": UnitArea.acres],
                ["Square Mile": UnitArea.squareMiles]]
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
