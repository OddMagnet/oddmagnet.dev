//
//  ContactPoint.swift
//  
//
//  Created by Michael Brünen on 02.02.22.
//

import Foundation
import Plot
import Publish
import SVGPublishPlugin

public enum ContactPoint: String, SVGFileNameCase {
    case twitter, github, linkedin, mail

    func url(_ handler: String) -> String {
        switch self {
            case .twitter:
                return "https://twitter.com/\(handler)"
            case .github:
                return "https://github.com/\(handler)"
            case .linkedin:
                return "https://www.linkedin.com/in/\(handler)/"
            case .mail:
                return "mailto:\(handler)"
        }
    }

    var svg: Node<HTML.AnchorContext> {
        .svg(self)
    }
}
