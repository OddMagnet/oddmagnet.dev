//
//  OddThemeProtocol.swift
//
//  Created by Michael Brünen on 02.02.22.
//

import Foundation
import Plot
import Publish

public protocol OddWebsite: Website {
    /// An array of tuples, containing a ContactPoint and it's value, usually the Username for that ContactPoint
    var contacts: [(ContactPoint, String)] { get }

    /// The base path for the favicons, by default  "/images/favicons/"
    var faviconBasePath: String? { get }

    /// An array containing the filenames for the favicons
//    var favicons: [String]
}
