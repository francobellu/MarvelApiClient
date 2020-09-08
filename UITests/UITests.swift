//
//  UITests.swift
//  UITests
//
//  Created by franco bellu on 21/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

//import XCTest
//import Swifter
//
//class UITests: XCTestCase {
//    let app = XCUIApplication()
//    let server = HttpServer()
//
//    func testDeepLinkViaSafari() throws {
//        // Install the app to register the deep link.
//        app.launch()
//
//        // Start a Swifter server with a deep link.
//        try server.start(8080)
//        server["/index.html"] = { _ in
//            .ok(.htmlBody("<a href='marvelapiclient://characters/'>Deep link 1</a>"))
//        }
//
//        // Open Safari, wait for it to launch, and visit the Swifter server.
//        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
//        safari.launch()
//        XCTAssert(safari.wait(for: .runningForeground, timeout: 5))
//        safari.descendants(matching: .any)["URL"].tap()
//        if safari.buttons["Continue"].exists { safari.buttons["Continue"].tap() }
//        safari.typeText("http://localhost:8080/index.html")
//        safari.buttons["Go"].tap()
//
//        // Wait for the page to load and open the deep link.
//        XCTAssert(safari.links["Deep link 1"].waitForExistence(timeout: 5))
//        safari.links["Deep link 1"].tap()
//        safari.buttons["Open"].tap()
//
//        // Wait for the app to enter the foreground.
//        XCTAssert(app.wait(for: .runningForeground, timeout: 5))
//    }
//}
