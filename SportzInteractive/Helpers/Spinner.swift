//
//  Spinner.swift
//  SportzInteractive
//
//  Created by Neosoft on 23/01/23.
//

import UIKit

open class Spinner {
    
    internal static var spinnerWrapper: UIView?
    internal static var spinner: UIActivityIndicatorView?
    public static var style: UIActivityIndicatorView.Style = .large
    public static var baseBackColor = UIColor.black.withAlphaComponent(0.5)
    public static var baseColor = UIColor.white
        
    public static func start(style: UIActivityIndicatorView.Style = style,
                             backColor: UIColor = baseBackColor,
                             baseColor: UIColor = baseColor) {
        
        if spinner == nil, let window = UIWindow.key {
            let frame = UIScreen.main.bounds
            spinner?.backgroundColor = backColor
            
            spinner = UIActivityIndicatorView(frame: frame)
            spinner?.style = style
            spinner?.color = baseColor
            
            spinnerWrapper = UIView()
            spinnerWrapper?.frame = frame
            spinnerWrapper?.backgroundColor = baseBackColor
            spinnerWrapper?.addSubview(spinner!)
            
            window.addSubview(spinnerWrapper!)
            
            spinner?.startAnimating()
        }
    }
    
    public static func stop() {
        if spinner != nil {
            spinner?.stopAnimating()
            spinner?.removeFromSuperview()
            spinner = nil
            spinnerWrapper?.removeFromSuperview()
            spinnerWrapper = nil
        }
    }
}
