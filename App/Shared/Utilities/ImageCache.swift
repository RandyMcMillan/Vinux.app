//
//  ImageCache.swift
//  damus
//
//  Created by William Casarin on 2022-05-04.
//

import Foundation
import SwiftUI
#if canImport(Cocoa)
import Cocoa
#endif
import Combine

#if !os(macOS)
extension UIImage {
    func decodedImage(_ size: Int) -> UIImage {
        guard let cgImage = cgImage else { return self }
        print("UIImage_____________________",UIScreen.main.scale)
        let scale = UIScreen.main.scale
        let pix_size = CGFloat(size) * scale
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //let cgsize = CGSize(width: size, height: size)
        
        let context = CGContext(data: nil, width: Int(pix_size), height: Int(pix_size), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue)
        
        //UIGraphicsBeginImageContextWithOptions(cgsize, true, 0)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: pix_size, height: pix_size))
        //UIGraphicsEndImageContext()

        guard let decodedImage = context?.makeImage() else { return self }
        return UIImage(cgImage: decodedImage, scale: scale, orientation: .up)
    }
}
#else
extension NSImage {
    func decodedImage(_ size: Int) -> NSImage {
        // guard let cgImage = cgImage else { return self }
        // print("UIImage_____________________",UIScreen.main.scale)
        let scale = CGFloat((NSScreen.main?.frame.width)!)
        let pix_size = CGFloat(size) * scale
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //let cgsize = CGSize(width: size, height: size)
        
        let context = CGContext(data: nil, width: Int(pix_size), height: Int(pix_size), bitsPerComponent: 8, bytesPerRow: 16, space: colorSpace, bitmapInfo: UInt32(16))
        
        //UIGraphicsBeginImageContextWithOptions(cgsize, true, 0)
        context?.draw(cgImage as! CGLayer, in: CGRect(x: 0, y: 0, width: pix_size, height: pix_size))
        //UIGraphicsEndImageContext()

        guard let decodedImage = context?.makeImage() else { return self }
        return NSImage(cgImage: decodedImage, size: CGSize())
        //NSSize(from: 16 as! Decoder)
    }
}
#endif

#if !os(macOS)
class ImageCache {
    private let lock = NSLock()
    
    lazy var cache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = 1024 * 1024 * 100 // 100MB
        return cache
    }()
    
    func lookup(for url: URL) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        
        if let decoded = cache.object(forKey: url as AnyObject) as? UIImage {
            return decoded
        }
        
        return nil
    }
    
    func remove(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        cache.removeObject(forKey: url as AnyObject)
    }
    
    func insert(_ image: UIImage?, for url: URL) {
        guard let image = image else { return remove(for: url) }
        let decodedImage = image.decodedImage(Int(PFP_SIZE))
        lock.lock(); defer { lock.unlock() }
        cache.setObject(decodedImage, forKey: url as AnyObject)
    }
    
    subscript(_ key: URL) -> UIImage? {
        get {
            return lookup(for: key)
        }
        set {
            return insert(newValue, for: key)
        }
    }
}

func load_image(cache: ImageCache, from url: URL) -> AnyPublisher<UIImage?, Never> {
    print(url)
    if let image = cache[url] {
        return Just(image).eraseToAnyPublisher()
    }
    return URLSession.shared.dataTaskPublisher(for: url)
        .map { (data, response) -> UIImage? in return UIImage(data: data) }
        .catch { error in return Just(nil) }
        .handleEvents(receiveOutput: { image in
            guard let image = image else { return }
            cache[url] = image
        })
        .subscribe(on: DispatchQueue.global(qos: .background))
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
}
#else
class ImageCache {
    private let lock = NSLock()
    
    lazy var cache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = 1024 * 1024 * 100 // 100MB
        return cache
    }()
    
    func lookup(for url: URL) -> NSImage? {
        lock.lock(); defer { lock.unlock() }
        
        if let decoded = cache.object(forKey: url as AnyObject) as? NSImage {
            return decoded
        }
        
        return nil
    }
    
    func remove(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        cache.removeObject(forKey: url as AnyObject)
    }
    
    func insert(_ image: NSImage?, for url: URL) {
        guard let image = image else { return remove(for: url) }
        let decodedImage = image.decodedImage(Int(PFP_SIZE))
        lock.lock(); defer { lock.unlock() }
        cache.setObject(decodedImage, forKey: url as AnyObject)
    }
    
    subscript(_ key: URL) -> NSImage? {
        get {
            return lookup(for: key)
        }
        set {
            return insert(newValue, for: key)
        }
    }
}

func load_image(cache: ImageCache, from url: URL) -> AnyPublisher<NSImage?, Never> {
    print(url)
    if let image = cache[url] {
        return Just(image).eraseToAnyPublisher()
    }
    return URLSession.shared.dataTaskPublisher(for: url)
        .map { (data, response) -> NSImage? in return NSImage(data: data) }
        .catch { error in return Just(nil) }
        .handleEvents(receiveOutput: { image in
            guard let image = image else { return }
            cache[url] = image
        })
        .subscribe(on: DispatchQueue.global(qos: .background))
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
}
#endif
