//
//  NSImageExtension.swift
//
//  Created by Roy on 2021/7/28.
//

import SwiftUI

extension Image {
    
    func centerCropped(height: CGFloat) -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: height)
                .clipped()
        }
    }
}


#if canImport(UIKit)

import UIKit

extension UIImage {
    
    static func fromColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)

        let renderer = UIGraphicsImageRenderer(bounds: rect)

        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.fill(rect)
        }

        return img
    }
    
    //生成圆形图片
    func toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(
            x: (shotest - self.size.width) / 2,
            y: (shotest - self.size.height) / 2,
            width: self.size.width,
            height: self.size.height
        ))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return maskedImage
    }
    
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(
            x: 0,
            y: 0,
            width: reSize.width,
            height: reSize.height
        ))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return reSizeImage;
    }
     
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize: CGFloat) -> UIImage {
        let reSize = CGSize(
            width: self.size.width * scaleSize,
            height: self.size.height * scaleSize
        )
        
        return reSizeImage(reSize: reSize)
    }
    
    //图片裁剪 为正方形
    func resizeImageWithSquareLength(squareLength: CGFloat) -> UIImage? {
        let oldWidth = self.size.width
        let oldHeight = self.size.height
        
        let length = (oldHeight > oldWidth) ? oldWidth : oldHeight
        let scale = length / squareLength
        
        let subSize = CGSize(width: oldWidth / scale , height: oldHeight / scale)
        
        UIGraphicsBeginImageContextWithOptions(subSize, false, UIScreen.main.scale)
        
        self.draw(in: CGRect(
            x: 0,
            y: 0,
            width: subSize.width,
            height: subSize.height
        ))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

#endif
