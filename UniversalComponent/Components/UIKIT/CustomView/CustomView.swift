//
//  CustomView.swift
//  UniversalComponent
//
//  Created by Sujay Gaikwad on 20/01/25.
//

import Foundation
import UIKit

class UniversalFooterView: UIView {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var termsConditionBtn: UIButton!
    @IBOutlet weak var aboutUsBtn: UIButton!
    @IBOutlet weak var careerBtn: UIButton!
    @IBOutlet weak var contactUsBtn: UIButton!
    
    
    var contentView:UIView?
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        
        
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UniversalFooterViewController", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
        
        
    }
    
 
}
//Custom View
