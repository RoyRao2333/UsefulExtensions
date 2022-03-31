//
//  StringPatternFormatter.swift
//  LetMePass
//
//  Created by Roy Rao on 2022/3/30.
//

import Foundation

class StringPatternFormatter {
    
    public var patterns: [StringPattern]
    
    public init(patterns: [StringPattern] = []) {
        self.patterns = patterns
    }
    
    public func attributedString(for string: String) throws -> NSAttributedString {
        return try self.format(NSAttributedString(string: string))
    }
    
    public func format(_ attributedString: NSAttributedString) throws -> NSAttributedString {
        var mutableString = NSMutableAttributedString(attributedString: attributedString)
        try self.process(&mutableString)
        
        return mutableString
    }
}


// MARK: Private Methods -
extension StringPatternFormatter {
    
    private func process(_ attributedString: inout NSMutableAttributedString) throws {
        try self.patterns.forEach {
            switch $0.type {
            case let .replace(to: replacingString):
                try self.processReplace(in: &attributedString, patternToBeReplaced: $0.pattern, replacingString: replacingString)
            case let .attributes(attributes):
                try self.processAttributedKey(in: &attributedString, pattern: $0.pattern, attributes: attributes)
            }
        }
    }
    
    private func processReplace(
        in attributedString: inout NSMutableAttributedString,
        patternToBeReplaced: String,
        replacingString: String
    ) throws {
        let matches = try self.regexMatches(in: attributedString.string, pattern: patternToBeReplaced)
        matches.reversed().forEach { match in
            attributedString.replaceCharacters(in: match.range(at: 0), with: replacingString)
        }
    }
    
    private func processAttributedKey(
        in attributedString: inout NSMutableAttributedString,
        pattern: String,
        attributes: [NSAttributedString.Key : Any]
    ) throws {
        let matches = try self.regexMatches(in: attributedString.string, pattern: pattern)
        try matches.reversed().forEach { match in
            try self.applyAttributes(attributes, to: &attributedString, in: match)
        }
    }
    
    private func applyAttributes(
        _ attributes: [NSAttributedString.Key : Any],
        to attributedString: inout NSMutableAttributedString,
        in result: NSTextCheckingResult
    ) throws {
        guard result.numberOfRanges > 1 else {
            throw StringPatternFormatterError.stringPatternDoNotContainsMatchingCharacter
        }
        
        let overallRange = result.range(at: 0)
        let matchedRange = result.range(at: 1)
        
        attributedString.addAttributes(attributes, range: overallRange)
        let extractedString = attributedString.attributedSubstring(from: matchedRange)
        attributedString.replaceCharacters(in: overallRange, with: extractedString)
    }
    
    private func regexMatches(in string: String, pattern: String) throws -> [NSTextCheckingResult] {
        let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.anchorsMatchLines)
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        return matches
    }
}


protocol StringPattern {
    var pattern: String { get }
    var type: StringPatternType { get }
}


enum StringPatternFormatterError: Error {
    case stringPatternDoNotContainsMatchingCharacter
}


enum StringPatternType {
    case replace(to: String)
    case attributes([NSAttributedString.Key : Any])
}
