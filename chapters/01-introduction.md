```{=latex}
\clearpage
```

# Introduction

```{=latex}
\begin{center}
\includegraphics[width=\textwidth,height=0.42\textheight,keepaspectratio]{assets/svg/llama-man-at-data-center.pdf}
\end{center}
```

## The Anatomy of a Model
To understand how an AI works, we have to look past the "magic" and see it as a functional machine. We can break an AI model down into three core concepts that work together to turn raw data into intelligence.

### The Blueprint: Architecture

The neural network is the mathematical structure at the core of the model: layers of interconnected units that transform input into output. Architecture is the specific design of that neural network. When engineers build models like Llama, they use frameworks such as PyTorch or TensorFlow to assemble modular building blocks into a particular blueprint. That blueprint defines how many layers the network has, how information flows through it, and how the components are organized to handle specific tasks.

### The Knowledge: Parameters

If the architecture is the empty house, the Parameters are the life inside it. These are the billions of numbers (weights and biases) organized as vectors and matrices. During the training phase, the model adjusts these numbers until they represent "knowledge." These parameters are what the neural network actually learns, and they determine how the model responds to any given input.

### The Execution: Inference

Finally, Inference is the moment of action. This is the "run-time" phase where the finished model—the architecture populated with its learned parameters—is put to work. When you ask the AI a question, the inference engine runs the input through the neural network to produce an output. It is the act of "cooking the meal" using the recipe (architecture) and the ingredients (parameters) you've prepared.
