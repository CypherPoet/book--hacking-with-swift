//
//  ViewController.swift
//  Photo Share
//
//  Created by Brian Sipple on 2/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class HomeViewController: UICollectionViewController {
    @IBOutlet weak var importPhotoButton: UIBarButtonItem!
    @IBOutlet weak var newToSessionButton: UIBarButtonItem!
    
    // The manager class that handles all multipeer connectivity for us
    lazy var mcSession = MCSession(peer: mcPeerId, securityIdentity: nil, encryptionPreference: .required)
    
    // The manager class that handles all multipeer connectivity for us
    lazy var mcPeerId = MCPeerID(displayName: UIDevice.current.name)
    
    // Used when creating a session, telling others that we exist and handling invitations
    lazy var mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: mcServiceType, discoveryInfo: nil, session: mcSession)
    
    // Used when looking for sessions, showing users who is nearby and letting them join
    lazy var mcBrowser = MCBrowserViewController(serviceType: mcServiceType, session: mcSession)

    let mcServiceType = "hws-project25"
    
    var photos = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mcSession.delegate = self
    }
    
    
    func startHosting(action: UIAlertAction) {
        mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction) {
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }

    @IBAction func importPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    @IBAction func showConnectionPrompt(_ sender: Any) {
        let alertController = UIAlertController(
            title: "New Connection",
            message: "How would you like to connect?",
            preferredStyle: .actionSheet
        )
        
        alertController.addAction(UIAlertAction(title: "Host a Session", style: .default, handler: startHosting))
        alertController.addAction(UIAlertAction(title: "Join a Session", style: .default, handler: joinSession))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.popoverPresentationController?.barButtonItem = newToSessionButton
        
        present(alertController, animated: true)
    }
    
}

extension HomeViewController: UINavigationControllerDelegate {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo Item", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = photos[indexPath.item]
        }
        
        return cell
    }
    
    func sendImageToPeers(_ image: UIImage) -> Void {
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch (let error) {
                    let alertController = UIAlertController(
                        title: "Error sending photo to peers",
                        message: error.localizedDescription,
                        preferredStyle: .alert
                    )
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alertController, animated: true)
                }
            }
        }
    }
    
    func addPhoto(fromImage image: UIImage) {
        photos.insert(image, at: 0)
        collectionView?.reloadData()
    }
}

extension HomeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        addPhoto(fromImage: image)
        sendImageToPeers(image)
    }
}


extension HomeViewController: MCSessionDelegate {
    // This method can be useful for some diagnostics
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        }
    }
    
    // attempt to add an image to our collection
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async { [unowned self] in
                self.addPhoto(fromImage: image)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // 🙅‍♂️ noop
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // 🙅‍♂️ noop
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // 🙅‍♂️ noop
    }
}


extension HomeViewController: MCBrowserViewControllerDelegate {
    // dismiss the view controller that is currently being presented
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

    // dismiss the view controller that is currently being presented
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}
