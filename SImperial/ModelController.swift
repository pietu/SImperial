//
//  ModelController.swift
//  SImperial
//
//  Created by Petteri Parkkila on 21/11/16.
//  Copyright © 2016 Pietu. All rights reserved.
//

import UIKit

protocol Measurement {
    var header: String { get }
    var SIValues: [NSDictionary] { get }
    var imperialValues: [NSDictionary] { get }
    func convert(fromUnit: String, toUnit: String, fromValue: Double) -> Double
}

struct Temperature: Measurement {
    var header: String {
        return "Temperature"
    }
    
    var SIValues: [NSDictionary] {
        return [["name": "Celcius", "abbreviation": "ºC"]]
    }
    
    var imperialValues: [NSDictionary] {
        return [["name": "Fahrenheit", "abbreviation": "ºF"]]
    }

    internal func convert(fromUnit: String, toUnit: String, fromValue: Double) -> Double {
        switch fromUnit {
        case "ºC":
            return fromValue * 9 / 5 + 32
        case "ºF":
            return (fromValue - 32) * 5 / 9
        default:
            return fromValue
        }
    }
}

struct Weight: Measurement {
    var header: String {
        return "Weight"
    }
    
    var SIValues: [NSDictionary] {
        return [["name": "Gram", "abbreviation": "g"],
                ["name": "Kilogram", "abbreviation": "kg"]]
    }
    
    var imperialValues: [NSDictionary] {
        return [["name": "Stone", "abbreviation": "st"],
                ["name": "Pound", "abbreviation": "lb"],
                ["name": "Ounce", "abbreviation": "oz"]]
    }

    internal func convert(fromUnit: String, toUnit: String, fromValue: Double) -> Double {
        switch fromUnit {
        case "g":
            return convertGram(toUnit: toUnit, fromValue: fromValue)
        case "kg":
            return convertKilogram(toUnit: toUnit, fromValue: fromValue)
        case "st":
            return convertStone(toUnit: toUnit, fromValue: fromValue)
        case "lb":
            return convertPound(toUnit: toUnit, fromValue: fromValue)
        case "oz":
            return convertOunce(toUnit: toUnit, fromValue: fromValue)
        default:
            print("NO CONVERSION FOR \(fromUnit). Plz implement!")
            return fromValue
        }
    }

    func convertGram(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "st":
            return fromValue * 0.000157473
        case "lb":
            return fromValue * 0.00220462
        case "oz":
            return fromValue * 0.035274
        default:
            return fromValue
        }
    }

    func convertKilogram(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "st":
            return fromValue * 0.157473
        case "lb":
            return fromValue * 2.20462
        case "oz":
            return fromValue * 3.5274
        default:
            return fromValue
        }
    }
    
    func convertStone(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "g":
            return fromValue * 6350.29
        case "kg":
            return fromValue * 6.35029
        default:
            return fromValue
        }
    }

    func convertPound(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "g":
            return fromValue * 453.592
        case "kg":
            return fromValue * 0.453592
        default:
            return fromValue
        }
    }

    func convertOunce(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "g":
            return fromValue * 28.3495
        case "kg":
            return fromValue * 0.0283495
        default:
            return fromValue
        }
    }
}

struct Length: Measurement {
    var header: String {
        return "Length"
    }
    
    var SIValues: [NSDictionary] {
        return [["name": "Millimeter", "abbreviation": "mm"],
                ["name": "Centimeter", "abbreviation": "cm"],
                ["name": "Meter", "abbreviation": "m"],
                ["name": "Kilometer", "abbreviation": "km"]]
    }
    
    var imperialValues: [NSDictionary] {
        return [["name": "Inch", "abbreviation": "\""],
                ["name": "Foot", "abbreviation": "'"],
                ["name": "Yard", "abbreviation": "yd"],
                ["name": "Mile", "abbreviation": "mi"]]
    }

    internal func convert(fromUnit: String, toUnit: String, fromValue: Double) -> Double {
        switch fromUnit {
        case "mm":
            return convertMillimeter(toUnit: toUnit, fromValue: fromValue)
        case "cm":
            return convertCentimeter(toUnit: toUnit, fromValue: fromValue)
        case "m":
            return convertMeter(toUnit: toUnit, fromValue: fromValue)
        case "km":
            return convertKilometer(toUnit: toUnit, fromValue: fromValue)
        case "\"":
            return convertInch(toUnit: toUnit, fromValue: fromValue)
        case "'":
            return convertFoot(toUnit: toUnit, fromValue: fromValue)
        case "yd":
            return convertYard(toUnit: toUnit, fromValue: fromValue)
        case "mi":
            return convertMile(toUnit: toUnit, fromValue: fromValue)
        default:
            print("NO CONVERSION FOR \(fromUnit). Plz implement!")
            return fromValue
        }
    }

    func convertMillimeter(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "\"":
            return fromValue * 0.0393701
        case "'":
            return fromValue * 0.00328084
        case "yd":
            return fromValue * 0.00109361
        case "mi":
            return fromValue * 6.2137e-7
        default:
            return fromValue
        }
    }

    func convertCentimeter(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "\"":
            return fromValue * 0.393701
        case "'":
            return fromValue * 0.0328084
        case "yd":
            return fromValue * 0.0109361
        case "mi":
            return fromValue * 6.2137e-6
        default:
            return fromValue
        }
    }

    func convertMeter(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "\"":
            return fromValue * 3.93701
        case "'":
            return fromValue * 0.328084
        case "yd":
            return fromValue * 0.109361
        case "mi":
            return fromValue * 0.000062137
        default:
            return fromValue
        }
    }

    func convertKilometer(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "\"":
            return fromValue * 39370.1
        case "'":
            return fromValue * 3280.84
        case "yd":
            return fromValue * 1093.61
        case "mi":
            return fromValue * 0.62137
        default:
            return fromValue
        }
    }

    func convertInch(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "mm":
            return fromValue * 25.4
        case "cm":
            return fromValue * 2.54
        case "m":
            return fromValue * 0.0254
        case "km":
            return fromValue * 2.54e-5
        default:
            return fromValue
        }
    }

    func convertFoot(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "mm":
            return fromValue * 304.8
        case "cm":
            return fromValue * 30.48
        case "m":
            return fromValue * 0.3048
        case "km":
            return fromValue * 0.0003048
        default:
            return fromValue
        }
    }

    func convertYard(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "mm":
            return fromValue * 914.4
        case "cm":
            return fromValue * 91.44
        case "m":
            return fromValue * 0.9144
        case "km":
            return fromValue * 0.0009144
        default:
            return fromValue
        }
    }

    func convertMile(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "mm":
            return fromValue * 1.609e+6
        case "cm":
            return fromValue * 160934
        case "m":
            return fromValue * 1609.34
        case "km":
            return fromValue * 1.60934
        default:
            return fromValue
        }
    }

}

struct Volume: Measurement {
    var header: String {
        return "Volume"
    }
    
    var SIValues: [NSDictionary] {
        return [["name": "Millilitre", "abbreviation": "ml"],
                ["name": "Litre", "abbreviation": "l"]]
    }
    
    var imperialValues: [NSDictionary] {
        return [["name": "Pint", "abbreviation": "pt"],
                ["name": "Gallon", "abbreviation": "gal"]]
    }

    internal func convert(fromUnit: String, toUnit: String, fromValue: Double) -> Double {
        switch fromUnit {
        case "ml":
            return convertMillilitre(toUnit: toUnit, fromValue: fromValue)
        case "l":
            return convertLitre(toUnit: toUnit, fromValue: fromValue)
        case "pt":
            return convertPint(toUnit: toUnit, fromValue: fromValue)
        case "gal":
            return convertGallon(toUnit: toUnit, fromValue: fromValue)
        default:
            print("NO CONVERSION FOR \(fromUnit). Plz implement!")
            return fromValue
        }
    }

    func convertMillilitre(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "pt":
            return fromValue * 0.00211338
        case "gal":
            return fromValue * 0.000264172
        default:
            return fromValue
        }
    }

    func convertLitre(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "pt":
            return fromValue * 2.11338
        case "gal":
            return fromValue * 0.264172
        default:
            return fromValue
        }
    }

    func convertPint(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "ml":
            return fromValue * 473.176
        case "l":
            return fromValue * 0.473176
        default:
            return fromValue
        }
    }

    func convertGallon(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "ml":
            return fromValue * 3785.41
        case "l":
            return fromValue * 3.78541
        default:
            return fromValue
        }
    }
}

class ModelController: NSObject, UIPageViewControllerDataSource {

    var pageData: [Measurement] = []

    override init() {
        super.init()
        pageData = [Temperature(), Weight(), Length(), Volume()]
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
            return pageData.index(where: { (m: Measurement) -> Bool in
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

