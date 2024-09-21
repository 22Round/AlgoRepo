import UIKit

extension UIButton {
    convenience init(title: String) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UILabel {
    convenience init(text: String, font: UIFont, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.numberOfLines = numberOfLines
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UITextField {
    convenience init(placeholder: String, font: UIFont = .systemFont(ofSize: 12), leftPadding: CGFloat = 11) {
        self.init(frame: .zero)
        self.font = font
        self.placeholder = placeholder
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.setLeftPadding(leftPadding)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setLeftPadding(_ amount: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIViewController {
    func setViewSize(targetView: UIView, width: CGFloat, height: CGFloat) {
        targetView.widthAnchor.constraint(equalToConstant: width).isActive = true
        targetView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

extension String {
    static var empty: String { String() }
}
