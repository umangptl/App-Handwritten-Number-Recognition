# App-Handwritten-Number-Recognition

This project focuses on implementing an IOS application to recognize handwritten numbers from 0-9. The model utilizes a  MNISTClassifier.mlmodel from Apple's website [MNIST Drawing Classification](https://developer.apple.com/machine-learning/models/#:~:text=View-,Model,-UpdatableDrawingClassifier)

This iOS app allows users to draw digits on the screen and predict the digit using CoreML and Vision frameworks. It includes a simple canvas for drawing, a prediction button, and options to clear the canvas or load predefined images for testing.

## Features
- **Drawing Canvas:** Allows users to draw digits on the screen using touch gestures.
- **CoreML Prediction:** Utilizes a pre-trained CoreML model to predict the drawn digit and also give a probability match.
- **Predefined Images:** Provides options to load predefined images for quick testing.
  
## Screenshots
<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px;">
  <img src="https://github.com/umangptl/App-Handwritten-Number-Recognition/blob/main/Images/home.png" width="20%" alt="Home-Page">
  <img src="https://github.com/umangptl/App-Handwritten-Number-Recognition/blob/main/Images/canva.png" width="20%" alt="Canva-Page">
  <img src="https://github.com/umangptl/App-Handwritten-Number-Recognition/blob/main/Images/recog.png" width="20%" alt="Recog-Page">
</div>

### Prerequisites

- Xcode installed on your development machine.
- iOS device or simulator to run the app.
