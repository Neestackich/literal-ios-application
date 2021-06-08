//
//  AddRequestViewController.swift
//  Literal
//
//  Created by Neestackich on 30.12.20.
//

import UIKit
import RxSwift
import RxCocoa

final class AddRequestViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private var doneButton: UIButton!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var loadingActivityIndicator: UIActivityIndicatorView!

    private var pickedImage = PublishSubject<UIImage>()

    var viewModel: AddRequestViewModelType? {
        didSet {
            loadViewIfNeeded()
            bindViewModel()
        }
    }

    private var disposeBag = DisposeBag()

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        doneButton.accessibilityIdentifier = "addBookScreenDoneButton"
        backButton.accessibilityIdentifier = "addBookScreenBackButton"
        imageView.layer.cornerRadius = 15
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(openCamera)))

        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }

    private func bindViewModel() {
        disposeBag = DisposeBag()

        if let viewModel = viewModel {
            let output = viewModel.transform(
                input: .init(
                    doneClick: doneButton.rx.tap.asDriver(),
                    backClick: backButton.rx.tap.asDriver(),
                    imageData: pickedImage.asDriver(onErrorDriveWith: .empty()))
            )

            disposeBag.insert(output.triggers.drive(),
                              output.isLoading.drive(
                                loadingActivityIndicator.rx.isAnimating,
                                doneButton.rx.isHidden))
        }
    }

    @objc private func openCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = .camera
        cameraPicker.delegate = self
        present(cameraPicker, animated: true)
    }
}

extension AddRequestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let cameraImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

        let imagePath = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
        print(imagePath)
        pickedImage.onNext(cameraImage)
        imageView.image = cameraImage
        imageView.alpha = 0.95
    }
}
