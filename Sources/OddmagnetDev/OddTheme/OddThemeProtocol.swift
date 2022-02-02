//
//  OddThemeProtocol.swift
//
//  Created by Michael Brünen on 02.02.22.
//

import Foundation
import Plot
import Publish

public protocol OddWebsite: Website {
    var contacts: [(ContactPoint, String)] { get }
}
