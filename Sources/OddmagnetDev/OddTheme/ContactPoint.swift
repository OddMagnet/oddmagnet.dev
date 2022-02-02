//
//  ContactPoint.swift
//  
//
//  Created by Michael Brünen on 02.02.22.
//

import Foundation
import Plot
import Publish

public enum ContactPoint {
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
        switch self {
            case .twitter:
                return .element(named: "svg", nodes: [
                    .class("svg-fill-color"),
                    .attribute(named: "xmlns", value: "http://www.w3.org/2000/svg"),
                    .attribute(named: "viewBox", value: "0 0 32 32"),
                    .element(named: "path", attributes: [.attribute(named: "d", value: "M30.063 7.313c-.813 1.125-1.75 2.125-2.875 2.938v.75c0 1.563-.188 3.125-.688 4.625a15.088 15.088 0 0 1-2.063 4.438c-.875 1.438-2 2.688-3.25 3.813a15.015 15.015 0 0 1-4.625 2.563c-1.813.688-3.75 1-5.75 1-3.25 0-6.188-.875-8.875-2.625.438.063.875.125 1.375.125 2.688 0 5.063-.875 7.188-2.5-1.25 0-2.375-.375-3.375-1.125s-1.688-1.688-2.063-2.875c.438.063.813.125 1.125.125.5 0 1-.063 1.5-.25-1.313-.25-2.438-.938-3.313-1.938a5.673 5.673 0 0 1-1.313-3.688v-.063c.813.438 1.688.688 2.625.688a5.228 5.228 0 0 1-1.875-2c-.5-.875-.688-1.813-.688-2.75 0-1.063.25-2.063.75-2.938 1.438 1.75 3.188 3.188 5.25 4.25s4.313 1.688 6.688 1.813a5.579 5.579 0 0 1 1.5-5.438c1.125-1.125 2.5-1.688 4.125-1.688s3.063.625 4.188 1.813a11.48 11.48 0 0 0 3.688-1.375c-.438 1.375-1.313 2.438-2.563 3.188 1.125-.125 2.188-.438 3.313-.875z")])
                ])
            case .github:
                return .element(named: "svg", nodes: [.class("svg-fill-color"), .attribute(named: "xmlns", value: "http://www.w3.org/2000/svg"), .attribute(named: "viewBox", value: "0 0 24 24"), .element(named: "path", attributes: [.attribute(named: "d", value: "M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12")])])
            case .linkedin:
                return .element(named: "svg", nodes: [.class("svg-fill-color"), .attribute(named: "xmlns", value: "http://www.w3.org/2000/svg"), .attribute(named: "viewBox", value: "0 0 448 512"), .element(named: "path", attributes: [.attribute(named: "d", value: "M100.28 448H7.4V148.9h92.88zM53.79 108.1C24.09 108.1 0 83.5 0 53.8a53.79 53.79 0 0 1 107.58 0c0 29.7-24.1 54.3-53.79 54.3zM447.9 448h-92.68V302.4c0-34.7-.7-79.2-48.29-79.2-48.29 0-55.69 37.7-55.69 76.7V448h-92.78V148.9h89.08v40.8h1.3c12.4-23.5 42.69-48.3 87.88-48.3 94 0 111.28 61.9 111.28 142.3V448z")])])
            case .mail:
                return .element(
                    named: "svg",
                    nodes: [
                        .class("svg-fill-color"),
                        .attribute(named: "xmlns", value: "http://www.w3.org/2000/svg"),
                        .attribute(named: "viewBox", value: "0 0 512 512"),
                        .element(
                            named: "path",
                            attributes: [
                                .attribute(
                                    named: "d",
                                    value: "M500.599,157.901L435.2,114.304V0H76.8v114.304l-65.399,43.597C4.275,162.645,0,170.641,0,179.2v307.2 C0,500.54,11.46,512,25.6,512h460.8c14.14,0,25.6-11.46,25.6-25.6V179.2C512,170.641,507.725,162.645,500.599,157.901z M435.2,145.067l39.595,26.394L435.2,197.086V145.067z M102.4,25.6h307.2v188.049L256,313.037l-153.6-99.388V25.6z M76.8,145.067 v52.019l-39.595-25.617L76.8,145.067z M486.4,486.4H25.6V194.449l206.839,133.837L44.254,450.048 c-5.939,3.849-7.637,11.776-3.797,17.698c2.441,3.806,6.554,5.854,10.752,5.854c2.389,0,4.787-0.674,6.938-2.048L256,343.526 l197.854,128.026c2.15,1.374,4.548,2.048,6.938,2.048c4.198,0,8.311-2.048,10.761-5.854c3.84-5.922,2.133-13.85-3.797-17.698 L279.569,328.277L486.4,194.449V486.4z"
                                )
                            ]
                        ),
                        .element(
                            named: "rect",
                            attributes: [
                                .attribute(named: "x", value: "128"),
                                .attribute(named: "y", value: "51.2"),
                                .attribute(named: "width", value: "256"),
                                .attribute(named: "height", value: "25.6")
                            ]
                        ),
                        .element(
                            named: "rect",
                            attributes: [
                                .attribute(named: "x", value: "128"),
                                .attribute(named: "y", value: "102.4"),
                                .attribute(named: "width", value: "256"),
                                .attribute(named: "height", value: "25.6")
                            ]
                        ),
                        .element(
                            named: "rect",
                            attributes: [
                                .attribute(named: "x", value: "128"),
                                .attribute(named: "y", value: "153.6"),
                                .attribute(named: "width", value: "128"),
                                .attribute(named: "height", value: "25.6")
                            ]
                        )
                    ]
                )
        }
    }
}
