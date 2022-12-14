//
//  ViewController.swift
//  NamesToFaces
//
//  Created by newbie on 30.08.2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var people = [Person]()
    var editingPerson: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        cell.personLabel.text = people[indexPath.item].name
        cell.imageView.image = UIImage(contentsOfFile: people[indexPath.item].image)
        cell.layer.cornerRadius = 10
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let ac = UIAlertController(title: "Do you want to delete of rename person?", message: nil, preferredStyle: .alert)
        editingPerson = indexPath.item
        ac.addAction(UIAlertAction(title: "Rename", style: .default, handler: renamePerson ))
        ac.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        }))
        
        present(ac, animated: true)
    }
    
    @objc private func addPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            
            let newPerson = Person(name: "Unknown", image: imagePath.path)
            people.append(newPerson)
            collectionView.reloadData()
        }
        
        dismiss(animated: true)
    }
    
    private func getDocumentDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
    
    private func renamePerson(action: UIAlertAction) {
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let renameAlertAction = UIAlertAction(title: "Rename", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            self?.people[self!.editingPerson!].name = newName
            self?.collectionView.reloadData()
        }
        ac.addAction(renameAlertAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

