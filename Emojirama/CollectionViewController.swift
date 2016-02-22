import UIKit

class CollectionViewController: UIViewController {
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
        
        if let path = NSBundle.mainBundle().pathForResource("emojis", ofType: "json") {
            if let emojiData = NSData(contentsOfFile: path) {
                
                do {
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(emojiData, options: [])
                    
                    if let jsonDict = jsonObject as? [NSDictionary] {
                        for value in jsonDict {
                            if let emoji = Emoji(value) {
                                unfilteredEmojis.append(emoji)
                            }
                        }
                    }
                    

                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            }
        }

        emojis = unfilteredEmojis
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEmojiSegue" {
            if let controller = segue.destinationViewController as? ViewController {
                if let indexPath = self.collectionView?.indexPathsForSelectedItems() {
                    controller.emoji = self.emojis[indexPath[0].row]
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
        
        
        cell.label?.text = emojis[indexPath.row].description
        
        return cell
    }
    
}

extension CollectionViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            emojis = unfilteredEmojis
        } else {
            emojis = unfilteredEmojis.filter({ (emoji:Emoji) -> Bool in

                if #available(iOS 9.0, *) {
                    return emoji.description.localizedStandardContainsString(searchText)
                        || emoji.tags.joinWithSeparator(", ").localizedStandardContainsString(searchText)
                        || searchText.localizedStandardContainsString(emoji.value)
                } else {
                    return emoji.description.containsString(searchText)
                        || emoji.tags.joinWithSeparator(", ").containsString(searchText)
                        || searchText.containsString(emoji.value)
                }
                
            })
        }

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
