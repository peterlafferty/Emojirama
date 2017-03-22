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

        self.searchBar.returnKeyType = .done
        self.searchBar.enablesReturnKeyAutomatically = false

        self.collectionView?.backgroundColor = UIColor.white

        if let toolbarHeight = self.navigationController?.toolbar.frame.height {
            self.collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: toolbarHeight, right: 0)
        }

        self.view.backgroundColor = UIColor.white

        emojis = emojirama.unfilteredEmojis
    }

    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .available {
                registerForPreviewing(with: self, sourceView: collectionView)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEmojiSegue" {
            if let navigationController = segue.destination as? UINavigationController {
                if let controller = navigationController.topViewController as? ViewController {
                    if let indexPath = collectionView?.indexPathsForSelectedItems {
                        controller.emoji = emojis[indexPath[0].row]
                    }
                }
            }
        }
        self.hideKeyboard()
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }

    // MARK: IBActions
    @IBAction func updateModifier(_ sender: AnyObject) {
        modifier = ""
        if let barButtonItem = sender as? UIBarButtonItem {
            if let text = barButtonItem.title {
                modifier = text
            }

        }
        collectionView?.reloadData()
    }

    @IBAction func clearModifier(_ sender: AnyObject) {
        modifier = ""
        collectionView?.reloadData()
    }
}

// MARK: UIScrollViewDelegate
extension CollectionViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         self.hideKeyboard()
    }

}

// MARK: UICollectionViewDataSource
private let reuseIdentifier = "Cell"
extension CollectionViewController: UICollectionViewDataSource {

    // MARK: UICollectionViewData
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier, for: indexPath)

        if let c = cell as? CellCollectionViewCell {
            if emojis[indexPath.row].hasSkinTone {
                c.text?.text = emojis[indexPath.row].value + modifier
            } else {
                c.text?.text = emojis[indexPath.row].value
            }
            c.label?.text = emojis[indexPath.row].text
        }

        return cell
    }

}

extension CollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        emojis = emojirama.filter(searchText)

        collectionView.contentOffset = CGPoint.zero
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.hideKeyboard()
    }
}

extension CollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

@available(iOS 9, *)
extension CollectionViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        // swiftlint:disable:next line_length
        guard let emojiViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "emojiViewController") as? ViewController,
            let selectedEmojiIndexPath = collectionView.indexPathForItem(at: location)
            else { return nil }

        emojiViewController.emoji = emojis[selectedEmojiIndexPath.row]
        return emojiViewController
    }
}
