
import Foundation

class ExamplePageVC: UIViewController {
  var label = UILabel();
  
  public func setLabel(_ value: String){
    self.label.text = value;
  };
  
  override func loadView() {
    super.loadView();
    
    self.view.backgroundColor = .red;
    
    self.label.textAlignment = .center;
    self.label.backgroundColor = .blue;
    self.label.translatesAutoresizingMaskIntoConstraints = false;
    
    self.view.addSubview(self.label);
    
    // fill superview
    NSLayoutConstraint.activate([
      self.label.widthAnchor  .constraint(equalTo: self.view.widthAnchor  ),
      self.label.heightAnchor .constraint(equalTo: self.view.heightAnchor ),
      self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
    ]);
  };
};

class ExampleUIPageViewController: UIPageViewController {
  var pages = [UIViewController]();
  let pageControl = UIPageControl();
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.dataSource = self;
    self.delegate = self;
    
    let initialPage = 0;
    
    let page1 = ExamplePageVC();
    page1.setLabel("Page 1");
    
    let page2 = ExamplePageVC();
    page2.setLabel("Page 2");
    
    let page3 = ExamplePageVC();
    page3.setLabel("Page 3");
            
    // add the individual viewControllers to the pageViewController
    self.pages.append(page1);
    self.pages.append(page2);
    self.pages.append(page3);
    
    self.setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil);

    // pageControl
    self.pageControl.frame = CGRect();
    self.pageControl.currentPageIndicatorTintColor = UIColor.black;
    self.pageControl.pageIndicatorTintColor = UIColor.lightGray;
    self.pageControl.numberOfPages = self.pages.count;
    self.pageControl.currentPage = initialPage;
    self.view.addSubview(self.pageControl);

    self.pageControl.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint.activate([
      self.pageControl.bottomAnchor .constraint(equalTo: self.view.bottomAnchor, constant: -5),
      self.pageControl.widthAnchor  .constraint(equalTo: self.view.widthAnchor, constant: -20),
      self.pageControl.heightAnchor .constraint(equalToConstant: 20),
      self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
    ]);
  };
  
  
};

extension ExampleUIPageViewController: UIPageViewControllerDataSource {
  // swiping left
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
      if viewControllerIndex == 0 {
        // wrap to last page in array
        return self.pages.last;
        
      } else {
        // go to previous page in array
        return self.pages[viewControllerIndex - 1];
      };
    };
    
    return nil;
  };
  
  // swiping right
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
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
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
  // set the pageControl.currentPage to the index of the current viewController in pages
    if let viewControllers = pageViewController.viewControllers {
      if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
        self.pageControl.currentPage = viewControllerIndex;
      };
    };
  };
};

extension ExampleUIPageViewController: UIPageViewControllerDelegate {
  
};
