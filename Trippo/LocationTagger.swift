//
//  LocationTagger.swift
//  Trippo
//
//  Created by Siwei Kang on 10/7/17.
//  Copyright © 2017 Siwei Kang. All rights reserved.
//

import Foundation

@objc class LocationTagger : NSObject {
    
    @objc func tagLocationsfromScript(text:String) -> String {

        let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
        tagger.string = text
        let range = NSRange(location:0, length: text.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        let tags: [NSLinguisticTag] = [.placeName, .organizationName]
        var result : String = ""
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
            if let tag = tag, tags.contains(tag) {
                let name = (text as NSString).substring(with: tokenRange)
                print("\(name): \(tag)")
                result  += name
            }
        }
        return result
    }
}
