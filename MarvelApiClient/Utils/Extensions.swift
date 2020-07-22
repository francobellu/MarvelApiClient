//
//  Extensions.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.

import UIKit

protocol StoryboardInstantiable: NSObjectProtocol {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInstantiable where Self: UIViewController {
    // THE VC IDENTIFIER MUST BE EQUAL TO THE CLASS FILENAME BECAUSE WE USE THIS NAME TO TO INSTANTIATE THE OBJECT
    static var storyboardIdentifier: String {
        // Return the filename, which is the name of a class without the module name.
        guard let string = NSStringFromClass(Self.self).components(separatedBy: ".").last else { return "" }
        return string
    }

    static func instantiateViewController(name: String = "Main", _ bundle: Bundle? = nil) -> Self {
        let storyB = UIStoryboard(name: name, bundle: bundle)
        guard let viewC = storyB.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else { fatalError()}
        return viewC
    }
}
