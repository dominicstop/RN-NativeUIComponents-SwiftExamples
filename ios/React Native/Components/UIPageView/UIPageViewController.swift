
import Foundation
import UIKit



class UIPageViewControllerWrapper: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  
  var pages = [UIViewController]();
  
  let pageControl = UIPageControl();

  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    self.delegate   = self;
    self.dataSource = self;
    
    // pageControl
    self.pageControl.frame = CGRect()
    self.pageControl.currentPageIndicatorTintColor = UIColor.black
    self.pageControl.pageIndicatorTintColor = UIColor.lightGray
    self.pageControl.numberOfPages = self.pages.count
    self.pageControl.currentPage = 0;
    self.view.addSubview(self.pageControl)

    self.pageControl.translatesAutoresizingMaskIntoConstraints = false
    self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
    self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
    self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
    self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
  };
  
  public func addPage(_ view: UIView){
    let initialPage = 0;
    let page = UIPageViewItem();
    page.view = view;
    
    print("Adding View");
            
    // add the individual viewControllers to the pageViewController
    self.pages.append(page);

    setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil);
  };
  
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
      if viewControllerIndex == 0 {
        // wrap to last page in array
        return self.pages.last;
        
      } else {
        // go to previous page in array
        return self.pages[viewControllerIndex - 1]
      };
    };
    
    return nil;
  };
  
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
      if viewControllerIndex < self.pages.count - 1 {
        // go to next page in array
        return self.pages[viewControllerIndex + 1];
        
      } else {
        // wrap to first page in array
        return self.pages.first;
      };
    };
    
    return nil;
  };
};


class UIPageViewItem: UIViewController {
  
  var childView: UIView?;
    
  override func viewDidLoad() {
    super.viewDidLoad();
      
    self.view.backgroundColor = UIColor.yellow

    // label
    let labelInst = UILabel()
    self.view.addSubview(labelInst)
    labelInst.text = "Page 1"
    labelInst.translatesAutoresizingMaskIntoConstraints = false
    labelInst.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
    labelInst.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
  };

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  };
};
