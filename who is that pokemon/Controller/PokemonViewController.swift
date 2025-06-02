//
//  ViewController.swift
//  who is that pokemon
//
//  Created by Alex Camacho on 01/08/22.
//

import UIKit

class PokemonViewController: UIViewController {

    @IBOutlet weak var pokemonImage: UIImageView!
    
    @IBOutlet weak var labelScore: UILabel!
    
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet var answersButtons: [UIButton]!
    
    lazy var pokemonManager = PokemonManager()
    lazy var imageManager = ImageManager()
    
    var randomPokemon: [PokemonModel] = []
    var correctAnswer: String = ""
    var correctAnswerImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonManager.delegate = self
        imageManager.delegate = self
        
        createButtons()
        pokemonManager.fetchPokemon()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setGradientBackground()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        print(sender.title(for: .normal)!)
    }
    
    func createButtons() {
        for button in answersButtons {
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            button.layer.cornerRadius = 10
            button.layer.shadowOffset = CGSize(width: 0, height: 3)
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 0
            button.layer.masksToBounds = false
        }
    }
    
    func setGradientBackground() {
        // Remove existing gradient layers to prevent stacking
        view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemPurple.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension PokemonViewController: PokemonManagerDelegate {
    func didUpdatePokemon(pokemon: [PokemonModel]) {
        randomPokemon = (pokemon.choose(4))
        
        let index = Int.random(in: 0...3)
        let imageData = randomPokemon[index].imageUrl
        correctAnswer = randomPokemon[index].name
    
    print("🔍 imageData URL: \(imageData)")
    imageManager.fetchImage(url: imageData)
    }
    
    func didFailWithError(error: any Error) {
        print(error)
    }
    
   

    
}

extension PokemonViewController: ImageManagerDelegate {
    func didUpdateImage(images image: ImageModel) {
        print(image.imageUrl)
    }

    

    
    func didFailWithErrorImage(error:  Error) {
        print(error)
    }
}

extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return(startIndex <= index && index < endIndex) ? self[index] : nil
        
    }
}

extension Collection {
    func choose(_ n: Int) -> Array<Element> {
        Array(shuffled().prefix(n))
    }
}
