//
//  MusicError.swift
//  NeedleDrop
//
//  Created by Josephine Humphreys on 10/22/19.
//  Copyright © 2019 Jhoom. All rights reserved.
//

import Foundation

enum MusicError: Error {
    case retrieve(description: String)
    case save(description: String)
    case unknown
}
