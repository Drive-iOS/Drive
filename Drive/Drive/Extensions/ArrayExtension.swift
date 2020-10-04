//
//  ArrayExtension.swift
//  Drive
//
//  Created by Amanuel Ketebo on 10/4/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

// Thanks Paul! https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
