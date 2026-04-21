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

## The Model On The File System

In the industry, we usually separate the "Brain" from the "Body."

### The Model Files (Architecture + Parameters)

In most cases, the Architecture and the Parameters are bundled together into specialized model files. You’ll often see these with extensions like .safetensors, .gguf, or .bin.

Parameters: These make up 99.9% of the file size (the billions of numbers).

Architecture (Metadata): The file also contains "metadata" that tells the computer how to arrange those numbers. It says, "Hey, I’m a Llama-3 model with 32 layers," so the computer knows how to build the neural network in its memory to match the data.

### The Inference Engine (The Separate File)

The Inference part is almost always a separate piece of software.

If you’re using Ollama at home, Ollama is the "Inference Engine." It is the software (the body) that knows how to open a model file (the brain), load it into your RAM, and start "thinking."

If you were writing your own Python script, you would write code using a library like PyTorch to perform the inference. Your script is the inference engine; it "calls" the model file to do the work.

### The "All-in-One" Exception

There are some formats, like GGUF, that try to get as close to a "single file" as possible. A GGUF file contains the parameters, the architecture details, and even the "prompt templates" so the engine knows exactly how to talk to it.

However, you still need an Inference Runner (like llama.cpp or a web server) to actually execute it.

### Why separate them?

Think of it like a DVD and a DVD Player:

The Model File (DVD): Contains the movie (the parameters) and the format info (the architecture).

The Inference Engine (DVD Player): This is the machine that knows how to read the disk and project the image onto the screen.

Separating them allows engineers to update the "Player" (to make it faster or more efficient) without having to re-download the massive 100GB "Movie" (the model weights).