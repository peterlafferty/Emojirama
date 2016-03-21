import UIKit
import EmojiramaKit

class CollectionViewController: UIViewController {
    var emojirama = Emojirama()
    var emojis = [Emoji]()
    var unfilteredEmojis = [Emoji]()
    var modifier = ""

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.returnKeyType = .Done
        self.searchBar.enablesReturnKeyAutomatically = false
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        if let toolbarHeight = self.navigationController?.toolbar.frame.height {
            self.collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: toolbarHeight, right: 0)
        }
        
        self.view.backgroundColor = UIColor.whiteColor()

        emojis = emojirama.unfilteredEmojis
    }
    
    override func viewWillAppear(animated: Bool) {
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .Available {
                registerForPreviewingWithDelegate(self, sourceView: collectionView)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEmojiSegue" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let controller = navigationController.topViewController as? ViewController {
                    if let indexPath = collectionView?.indexPathsForSelectedItems() {
                        controller.emoji = emojis[indexPath[0].row]
                    }
                }
            }
        }
        self.hideKeyboard()
    }
    
    func hideKeyboard() {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
    }

    
    // MARK: IBActions
    @IBAction func updateModifier(sender: AnyObject) {
        modifier = ""
        if let barButtonItem = sender as? UIBarButtonItem {
            if let text = barButtonItem.title {
                modifier = text
            }
            
        }
        collectionView?.reloadData()
    }
    
    @IBAction func clearModifier(sender: AnyObject) {
        modifier = ""
        collectionView?.reloadData()
    }
}

// MARK: UIScrollViewDelegate
extension CollectionViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
         self.hideKeyboard()
    }

}


// MARK: UICollectionViewDataSource
private let reuseIdentifier = "Cell"
extension CollectionViewController: UICollectionViewDataSource {
    
    // MARK: UICollectionViewData
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CellCollectionViewCell
        
        
        if emojis[indexPath.row].hasSkinTone {
            cell.text?.text = emojis[indexPath.row].value + modifier
        } else {
            cell.text?.text = emojis[indexPath.row].value
        }
        
        
        cell.label?.text = emojis[indexPath.row].text
        
        return cell
    }
    
}

extension CollectionViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        emojis = emojirama.filter(searchText)

        collectionView.contentOffset = CGPointZero
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.hideKeyboard()
    }
}

extension CollectionViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    }
}

@available(iOS 9, *)
extension CollectionViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let emojiViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("emojiViewController") as? ViewController,
            selectedEmojiIndexPath = collectionView.indexPathForItemAtPoint(location)
            else { return nil }
        
        emojiViewController.emoji = emojis[selectedEmojiIndexPath.row]
        return emojiViewController
    }
}
