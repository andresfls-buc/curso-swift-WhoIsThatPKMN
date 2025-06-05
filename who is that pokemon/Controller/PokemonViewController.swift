//  ViewController.swift
//  who is that pokemon
//
//  Created by Alex Camacho on 01/08/22.

import UIKit
import Kingfisher

class PokemonViewController: UIViewController {

    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet var answersButtons: [UIButton]!

    lazy var pokemonManager = PokemonManager()
    lazy var imageManager = ImageManager()
    lazy var game = GameModel()

    var randomPokemon: [PokemonModel] = [] {
        didSet {
            setButtonTitles()
        }
    }
    var correctAnswer: String = ""
    var correctAnswerImage: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonManager.delegate = self
        imageManager.delegate = self
        createButtons()
        pokemonManager.fetchPokemon()
        labelMessage.text = ""
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        let userAnswer = sender.title(for: .normal) ?? ""

        if game.checkAnswer(userAnswer, correctAnswer) {
            labelMessage.text = "Correcto es \(userAnswer.capitalized)!"
            labelScore.text = "Puntaje: \(game.score)"

            sender.layer.borderColor = UIColor.systemGreen.cgColor
            sender.layer.borderWidth = 2

            let url = URL(string: correctAnswerImage)
            pokemonImage.kf.setImage(with: url)

            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                sender.layer.borderWidth = 0
                self.labelMessage.text = ""
                self.resetButtons()  // Aquí limpiamos todos los botones
                self.pokemonManager.fetchPokemon() // Y traemos nuevo pokemon
            }
        } else {
            labelMessage.text = "No, es un \(correctAnswer.capitalized)!"
            sender.layer.borderColor = UIColor.systemRed.cgColor
            sender.layer.borderWidth = 2

            let url = URL(string: correctAnswerImage)
            pokemonImage.kf.setImage(with: url)

            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.resetGame()
                self.performSegue(withIdentifier: "goToResults", sender: nil)
            }
        }
    }

    func resetGame() {
        pokemonManager.fetchPokemon()
        
        labelScore.text = "Puntaje: \(game.score)"
        pokemonImage.image = nil
        labelMessage.text = ""
        resetButtons()
    }

    // Esta función limpia el borde y color de todos los botones
    func resetButtons() {
        for button in answersButtons {
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor.clear.cgColor
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            let destination = segue.destination as! ResultViewController
            destination.pokemonName = correctAnswer
            destination.pokemonImageURL = correctAnswerImage
            destination.finalScore = game.score
            resetGame()
        }
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

    func setButtonTitles() {
        for (index, button) in answersButtons.enumerated() {
            DispatchQueue.main.async {
                button.setTitle(self.randomPokemon[safe: index]?.name.capitalized, for: .normal)
            }
        }
    }
}

extension PokemonViewController: PokemonManagerDelegate {
    func didUpdatePokemon(pokemon: [PokemonModel]) {
        randomPokemon = pokemon.choose(4)
            let index = Int.random(in: 0...3)
            correctAnswer = randomPokemon[index].name
            let imageData = randomPokemon[index].imageUrl
            print("Correct Pokemon: \(correctAnswer), URL to fetch image JSON: \(imageData)")
            imageManager.fetchImage(url: imageData)
    }

    func didFailWithError(error: any Error) {
        print(error)
    }
}

extension PokemonViewController: ImageManagerDelegate {
    func didUpdateImage(images image: ImageModel) {
        correctAnswerImage = image.imageUrl
        print("Imagen oficial URL: \(correctAnswerImage)")
        DispatchQueue.main.async {
            let url = URL(string: image.imageUrl)
            guard url != nil else {
                print("URL de imagen inválida")
                return
            }
            let effect = ColorControlsProcessor(brightness: -1, contrast: 1, saturation: 1, inputEV: 0)
            self.pokemonImage.kf.setImage(with: url, options: [.processor(effect)])
        }
    }


    func didFailWithErrorImage(error: Error) {
        print(error)
    }
}

extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}

extension Collection {
    func choose(_ n: Int) -> Array<Element> {
        Array(shuffled().prefix(n))
    }
}
