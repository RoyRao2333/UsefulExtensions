//
//  StringExtension.swift
//
//  Created by Roy Rao on 2020/4/5.
//  Copyright © 2020 RoyRao. All rights reserved.
//

import Foundation

// MARK: String -
extension String {
    
    func indexOfRepeatingCharacter(of character: Character, count: Int) -> String.Index? {
        var i = 0
        for index in self.indices {
            if self[index] == character {
                i += 1
                if count == i {
                    return index
                } else {
                    continue
                }
            }
        }
        return nil
    }
    
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
    
    /// Searches through a string to find valid URLs.
    /// - Returns: An array of found URLs.
    func getURLs() -> [URL] {
        var foundUrls: [URL] = []
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return foundUrls
        }

        let matches = detector.matches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: self.utf16.count)
        )

        for match in matches {
            guard let range = Range(match.range, in: self),
                  let retrievedURL = URL(string: String(self[range])) else { continue }
            foundUrls.append(retrievedURL)
        }

        return foundUrls
    }
    
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
    
    func localized(with values: String...) -> String {
        String(format: self.localized(), arguments: values)
    }
    
    /// Check whether String consist of 100% Chinese characters.
    ///
    /// - Returns: true if only Chinese
    var isChinese: Bool {
        Int(self.chinesePercentage) == 100
    }
    
    /// Number of Chinese characters in String.
    ///
    /// - Returns: Chinese character count
    func chineseCharactersCount() -> Int {
        let stripped = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }.joined()
        
        var chineseCount = 0
        
        for scalar in stripped.unicodeScalars {
            switch scalar.value {
            case 19968...40959: // Common
                chineseCount += 1
            case 13312...19903: // Rare
                chineseCount += 1
            case 131072...173791: // Rare, historic
                chineseCount += 1
            case 173824...177983: // Rare, historic
                chineseCount += 1
            case 177984...178207: // Uncommon
                chineseCount += 1
            case 63744...64255: // Duplicates
                chineseCount += 1
            case 194560...195103: // Unifiable variants
                chineseCount += 1
            case 40870...40883: // Interoperability with HKSCS standard
                chineseCount += 1
            case 40884...40891: // Interoperability with GB 18030 standard
                chineseCount += 1
            case 40892...40898: // Interoperability with commercial implementations
                chineseCount += 1
            case 40899: // Correction of mistaken unification
                chineseCount += 1
            case 40900...40902: // Interoperability with ARIB standard
                chineseCount += 1
            case 40903...40907: // Interoperability with HKSCS standard
                chineseCount += 1
            default:
                continue
            }
        }
        
        return chineseCount
    }
    
    var isBlank: Bool {
        allSatisfy { $0.isWhitespace }
    }
    
    /// Percentage of Chinese characters in String.
    var chinesePercentage: Float {
        let chineseCount = self.chineseCharactersCount()
        let stripped = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }.joined()
        
        return (Float(chineseCount) / Float(stripped.count)) * 100
    }
    
    func prefix(by length: Int) -> String {
        String(self.prefix(length))
    }
    
    func suffix(by length: Int) -> String {
        String(self.suffix(length))
    }
    
    func replace(of occurrences: String..., with newValue: String) -> String {
        var oldStr = self
        
        for oldValue in occurrences {
            oldStr = oldStr.replacingOccurrences(of: oldValue, with: newValue)
        }
        
        return oldStr
    }
    
    func pathSwapExtension(with ext: String) -> String? {
        ((self as NSString).deletingPathExtension as NSString).appendingPathExtension(ext)
    }
    
    var folderPath: String {
        (self as NSString).deletingLastPathComponent
    }
    
    var fileExtension: String {
        (self as NSString).pathExtension
    }
    
    var fileName: String? {
        (self.components(separatedBy: "/").last as NSString?)?.deletingPathExtension
    }
    
    var removeExtension: String {
        (self as NSString).deletingPathExtension
    }
    
    func createFile(fileName: String, withExtension fileExtension: String) -> String {
        (self as NSString).appendingPathComponent("\(fileName).\(fileExtension)")
    }
    
    func changeFileName(to fileName: String) -> String {
        let ext = (self as NSString).pathExtension
        return ((self as NSString).deletingLastPathComponent as NSString).appendingPathComponent("\(fileName).\(ext)")
    }
    
    func asciiAt(index: Int) -> UInt32? {
        let scalarIndex = unicodeScalars.index(unicodeScalars.startIndex, offsetBy: index)
        let scalar = unicodeScalars[scalarIndex]
    
        guard scalar.isASCII else {
            return nil
        }
    
        return scalar.value
    }
    
    static var systemLanguage: String {
        String(Locale.preferredLanguages[0].prefix(2))
    }
    
    static var appVersion: String {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    var queryString: String? {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    @available(iOS 15, *)
    var markdown: AttributedString {
        do {
            return try AttributedString(
                markdown: self,
                options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
            )
        } catch {
            return AttributedString("Error parsing markdown: \(error)")
        }
    }
    
    /// Find all matches of certain regex in string.
    ///
    /// First element of sub-array is the match.
    func matches(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex))?
            .matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
            .map { match in
                (0 ..< match.numberOfRanges).map {
                    match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0))
                }
            } ?? []
    }
    
    /// Find all matched ranges of certain regex in string.
    func ranges(regex pattern: String) -> [Range<String.Index>] {
        let nsString = self as NSString
        if let regex = try? NSRegularExpression(pattern: pattern) {
            return regex.matches(in: self, range: NSMakeRange(0, nsString.length)).compactMap {
                Range($0.range, in: self)
            }
        }
        return []
    }
}


// MARK: Encodings -
extension String.Encoding {
    static let defaultCString = String.defaultCStringEncoding
    
    static let big5 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))
    static let GB_2312_80 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_2312_80.rawValue)))
    static let GB_18030_2000 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
    static let GBK_95 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GBK_95.rawValue)))
    
    static let macKorean = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.macKorean.rawValue)))
    static let macCentralEurRoman = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.macCentralEurRoman.rawValue)))
    static let macCyrillic = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.macCyrillic.rawValue)))
    
    static let EUC_JP = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_JP.rawValue)))
    static let EUC_KR = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue)))
    static let EUC_TW = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_TW.rawValue)))
    
    static let ISO_10646_1993 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0101)) // Not sure if it'll work. Better use UTF-32
    static let ISO_2022_CN = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.ISO_2022_CN.rawValue)))
    static let ISO_2022_KR = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.ISO_2022_KR.rawValue)))
    static let isoLatinArabic_8859_6 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatinArabic.rawValue)))
    static let isoLatinCyrillic_8859_5 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatinCyrillic.rawValue)))
    static let isoLatin_8859_2 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatin2.rawValue)))
    static let isoLatin_8859_3 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatin3.rawValue)))
    static let isoLatin_8859_4 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatin4.rawValue)))
    static let isoLatinGreek_8859_7 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatinGreek.rawValue)))
    static let isoLatinHebrew_8859_8 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatinHebrew.rawValue)))
    static let isoLatin_8859_9 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatin5.rawValue)))
    static let isoLatinThai_8859_11 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatinThai.rawValue)))
    static let isoLatin_8859_13 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatin7.rawValue)))
    static let isoLatin_8859_15 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatin9.rawValue)))
    static let isoLatin_8859_16 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatin10.rawValue)))
    
    static let windowsHebrew_1255 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.windowsHebrew.rawValue)))
    static let windowsArabic_1256 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.windowsArabic.rawValue)))
    static let windowsBalticRim_1257 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.windowsBalticRim.rawValue)))
    static let windowsVietnamese_1258 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.windowsVietnamese.rawValue)))
    
    static let dosLatin_852 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.dosLatin2.rawValue)))
    static let dosCyrillic_855 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.dosCyrillic.rawValue)))
    static let dosRussian_866 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.dosRussian.rawValue)))
    
    static let KOI8_R = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.KOI8_R.rawValue)))
    
    static let VISCII = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.VISCII.rawValue)))
}


// MARK: Attributed String Extension -
extension NSAttributedString {
    
    static func rtf(for fileURL: URL) -> NSAttributedString? {
        try? NSAttributedString(
            url: fileURL,
            options: [.documentType: NSAttributedString.DocumentType.rtf],
            documentAttributes: nil
        )
    }
}

extension StringProtocol {
    var data: Data { .init(utf8) }
    var bytes: [UInt8] { .init(utf8) }
}


// MARK: Subscripting -
extension StringProtocol {
    
    subscript(_ offset: Int) -> Element? {
        guard offset >= 0, offset < count else { return nil }
        return self[index(startIndex, offsetBy: offset)]
    }
    
    subscript(_ range: Range<Int>) -> SubSequence {
        prefix(range.lowerBound+range.count).suffix(range.count)
    }
    
    subscript(_ range: ClosedRange<Int>) -> SubSequence {
        prefix(range.lowerBound+range.count).suffix(range.count)
    }
    
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence {
        prefix(range.upperBound.advanced(by: 1))
    }
    
    subscript(_ range: PartialRangeUpTo<Int>) -> SubSequence {
        prefix(range.upperBound)
    }
    
    subscript(_ range: PartialRangeFrom<Int>) -> SubSequence {
        suffix(Swift.max(0, count-range.lowerBound))
    }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}
