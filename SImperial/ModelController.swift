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
    var SIValues: [Dictionary<String, String>] { get }
    var imperialValues: [Dictionary<String, String>] { get }
    func convert(fromUnit: String, toUnit: String, fromValue: Double) -> Double
}

struct Temperature: Measurement {
    var header: String {
        return "Temperature"
    }

    var SIValues: [Dictionary<String, String>] {
        return [["name": "Celcius", "abbreviation": "ºC"]]
    }

    var imperialValues: [Dictionary<String, String>] {
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

struct Mass: Measurement {
    var header: String {
        return "Mass"
    }

    var SIValues: [Dictionary<String, String>] {
        return [["name": "Gram", "abbreviation": "g"],
                ["name": "Kilogram", "abbreviation": "kg"]]
    }

    var imperialValues: [Dictionary<String, String>] {
        return [["name": "Pound", "abbreviation": "lb"],
                ["name": "Ounce", "abbreviation": "oz"]]
    }

    internal func convert(fromUnit: String, toUnit: String, fromValue: Double) -> Double {
        switch fromUnit {
        case "g":
            return convertGram(toUnit: toUnit, fromValue: fromValue)
        case "kg":
            return convertKilogram(toUnit: toUnit, fromValue: fromValue)
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
        case "lb":
            return fromValue * 2.20462
        case "oz":
            return fromValue * 35.274
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

    var SIValues: [Dictionary<String, String>] {
        return [["name": "Millimeter", "abbreviation": "mm"],
                ["name": "Centimeter", "abbreviation": "cm"],
                ["name": "Meter", "abbreviation": "m"],
                ["name": "Kilometer", "abbreviation": "km"]]
    }

    var imperialValues: [Dictionary<String, String>] {
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
            return fromValue * 39.3701
        case "'":
            return fromValue * 3.28084
        case "yd":
            return fromValue * 1.09361
        case "mi":
            return fromValue * 0.00062137
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

    var SIValues: [Dictionary<String, String>] {
        return [["name": "Millilitre", "abbreviation": "ml"],
                ["name": "Decilitre", "abbreviation": "dl"],
                ["name": "Litre", "abbreviation": "l"]]
    }

    var imperialValues: [Dictionary<String, String>] {
        return [["name": "US fluid Ounce", "abbreviation": "US fl.oz"],
                ["name": "US liquid Cup", "abbreviation": "US cup"],
                ["name": "US liquid Pint", "abbreviation": "US pt"],
                ["name": "US liquid Gallon", "abbreviation": "US gal"],
                ["name": "Imperial fl. Ounce", "abbreviation": "fl.oz"],
                ["name": "Imperial Cup", "abbreviation": "cup"],
                ["name": "Imperial Pint", "abbreviation": "pt"],
                ["name": "Imperial Gallon", "abbreviation": "gal"]]
    }

    internal func convert(fromUnit: String, toUnit: String, fromValue: Double) -> Double {
        switch fromUnit {
        case "ml":
            return convertMillilitre(toUnit: toUnit, fromValue: fromValue)
        case "dl":
            return convertDecilitre(toUnit: toUnit, fromValue: fromValue)
        case "l":
            return convertLitre(toUnit: toUnit, fromValue: fromValue)
        case "US fl.oz":
            return convertUSFluidOunce(toUnit: toUnit, fromValue: fromValue)
        case "US cup":
            return convertUSCup(toUnit: toUnit, fromValue: fromValue)
        case "US pt":
            return convertUSPint(toUnit: toUnit, fromValue: fromValue)
        case "US gal":
            return convertUSGallon(toUnit: toUnit, fromValue: fromValue)
        case "fl.oz":
            return convertFluidOunce(toUnit: toUnit, fromValue: fromValue)
        case "cup":
            return convertCup(toUnit: toUnit, fromValue: fromValue)
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
        case "US fl.oz":
            return fromValue * 0.033814
        case "US cup":
            return fromValue * 0.00416667
        case "US pt":
            return fromValue * 0.00211338
        case "US gal":
            return fromValue * 0.000264172
        case "fl.oz":
            return fromValue * 0.0351951
        case "cup":
            return fromValue * 0.00351951
        case "pt":
            return fromValue * 0.00175975
        case "gal":
            return fromValue * 0.000219969
        default:
            return fromValue
        }
    }

    func convertDecilitre(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "US fl.oz":
            return fromValue * 3.3814
        case "US cup":
            return fromValue * 0.416667
        case "US pt":
            return fromValue * 0.211338
        case "US gal":
            return fromValue * 0.0264172
        case "fl.oz":
            return fromValue * 3.51951
        case "cup":
            return fromValue * 0.351951
        case "pt":
            return fromValue * 0.175975
        case "gal":
            return fromValue * 0.0219969
        default:
            return fromValue
        }
    }

    func convertLitre(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "US fl.oz":
            return fromValue * 33.814
        case "US cup":
            return fromValue * 4.16667
        case "US pt":
            return fromValue * 2.11338
        case "US gal":
            return fromValue * 0.264172
        case "fl.oz":
            return fromValue * 35.1951
        case "cup":
            return fromValue * 3.51951
        case "pt":
            return fromValue * 1.75975
        case "gal":
            return fromValue * 0.219969
        default:
            return fromValue
        }
    }

    func convertUSFluidOunce(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "ml":
            return fromValue * 29.5735
        case "dl":
            return fromValue * 0.295735
        case "l":
            return fromValue * 0.0295735
        default:
            return fromValue
        }
    }

    func convertUSCup(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "ml":
            return fromValue * 240
        case "dl":
            return fromValue * 2.4
        case "l":
            return fromValue * 0.24
        default:
            return fromValue
        }
    }

    func convertUSPint(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "ml":
            return fromValue * 473.176
        case "dl":
            return fromValue * 4.73176
        case "l":
            return fromValue * 0.473176
        default:
            return fromValue
        }
    }

    func convertUSGallon(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "ml":
            return fromValue * 3785.41
        case "dl":
            return fromValue * 37.8541
        case "l":
            return fromValue * 3.78541
        default:
            return fromValue
        }
    }

    func convertFluidOunce(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "ml":
            return fromValue * 28.4131
        case "dl":
            return fromValue * 0.284131
        case "l":
            return fromValue * 0.0284131
        default:
            return fromValue
        }
    }

    func convertCup(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "ml":
            return fromValue * 284.131
        case "dl":
            return fromValue * 2.84131
        case "l":
            return fromValue * 0.284131
        default:
            return fromValue
        }
    }

    func convertPint(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "ml":
            return fromValue * 568.2609999991457
        case "dl":
            return fromValue * 5.682609999991457
        case "l":
            return fromValue * 0.568261
        default:
            return fromValue
        }
    }

    func convertGallon(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "ml":
            return fromValue * 4546.0879999931657949
        case "dl":
            return fromValue * 45.460879999931655959
        case "l":
            return fromValue * 4.5460879999931655959
        default:
            return fromValue
        }
    }
}

struct Area: Measurement {
    var header: String {
        return "Area"
    }

    var SIValues: [Dictionary<String, String>] {
        return [["name": "Square Meter", "abbreviation": "m2"],
                ["name": "Hectare", "abbreviation": "ha"],
                ["name": "Square Kilometer", "abbreviation": "km2"]]
    }

    var imperialValues: [Dictionary<String, String>] {
        return [["name": "Square Foot", "abbreviation": "f2"],
                ["name": "Acre", "abbreviation": "ac"],
                ["name": "Square Mile", "abbreviation": "mi2"]]
    }

    internal func convert(fromUnit: String, toUnit: String, fromValue: Double) -> Double {
        switch fromUnit {
        case "m2":
            return convertSquareMeter(toUnit: toUnit, fromValue: fromValue)
        case "ha":
            return convertHectare(toUnit: toUnit, fromValue: fromValue)
        case "km2":
            return convertSquareKiloMeter(toUnit: toUnit, fromValue: fromValue)
        case "f2":
            return convertSquareFoot(toUnit: toUnit, fromValue: fromValue)
        case "ac":
            return convertAcre(toUnit: toUnit, fromValue: fromValue)
        case "mi2":
            return convertSquareMile(toUnit: toUnit, fromValue: fromValue)
        default:
            print("NO CONVERSION FOR \(fromUnit). Plz implement!")
            return fromValue
        }
    }

    func convertSquareMeter(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "f2":
            return fromValue * 10.7639
        case "ac":
            return fromValue * 0.000247105
        case "mi2":
            return fromValue * 3.861e-7
        default:
            return fromValue
        }
    }

    func convertHectare(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "f2":
            return fromValue * 107639
        case "ac":
            return fromValue * 2.47105
        case "mi2":
            return fromValue * 0.00386102
        default:
            return fromValue
        }
    }

    func convertSquareKiloMeter(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "f2":
            return fromValue * 1.076e+7
        case "ac":
            return fromValue * 247.105
        case "mi2":
            return fromValue * 0.386102
        default:
            return fromValue
        }
    }

    func convertSquareFoot(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "m2":
            return fromValue * 0.092903
        case "ha":
            return fromValue * 9.2903e-6
        case "km2":
            return fromValue * 9.2903e-8
        default:
            return fromValue
        }
    }

    func convertAcre(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "m2":
            return fromValue * 4046.86
        case "ha":
            return fromValue * 0.404686
        case "km2":
            return fromValue * 0.00404686
        default:
            return fromValue
        }
    }

    func convertSquareMile(toUnit: String, fromValue: Double) -> Double {
        switch toUnit {
        case "m2":
            return fromValue * 2.59e+6
        case "ha":
            return fromValue * 258.999
        case "km2":
            return fromValue * 2.58999
        default:
            return fromValue
        }
    }
}

class ModelController: NSObject, UIPageViewControllerDataSource {

    var pageData: [Measurement] = []

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
