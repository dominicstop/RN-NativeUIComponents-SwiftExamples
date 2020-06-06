extension UIView {
  var parentViewController: UIViewController? {
    var parentResponder: UIResponder? = self;
    
    while parentResponder != nil {
      parentResponder = parentResponder!.next
      if let viewController = parentResponder as? UIViewController {
        return viewController;
      };
    };
    
    return nil
  };
  
  public func removeAllConstraints() {
    var _superview = self.superview;
    
    while let superview = _superview {
      for constraint in superview.constraints {
        if let first = constraint.firstItem as? UIView, first == self {
          superview.removeConstraint(constraint)
        };

        if let second = constraint.secondItem as? UIView, second == self {
          superview.removeConstraint(constraint);
        };
      };
      
      _superview = superview.superview;
    };
    
    self.removeConstraints(self.constraints);
  };
};
