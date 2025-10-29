# Newton Fractal Visualization

This project generates Newton Fractals for the equation `z^n - 1 = 0` using **C++** and **ISPC**. The output is a PPM image where each pixel color represents the root reached by Newton's method and the number of iterations taken.

## Features

* Configurable polynomial degree `n`.
* Configurable image width, height, and max iterations.
* Parallelized computation using ISPC for speed.

## Requirements

* C++ compiler supporting C++11 or higher.
* ISPC compiler.
* Linux or any environment where `g++` and `ispc` are available.

## Building

Clone the repository and run:

```bash
make
```

This compiles the ISPC file and the main C++ program, producing the executable `main`.

## Usage

Run the program with:

```bash
./main <degree> <width> <height> <max_iterations> <output.ppm>
```

* `degree` – the `n` in `z^n - 1 = 0`
* `width` – image width in pixels
* `height` – image height in pixels
* `max_iterations` – maximum iterations for Newton’s method
* `output.ppm` – filename for the output image

Example:

```bash
./main 5 800 800 50 fractal.ppm
```

This generates an 800×800 Newton Fractal for `z^5 - 1 = 0` with 50 max iterations and saves it as `fractal.ppm`.

## Notes

* The program writes the image in **PPM (P6)** format, which can be viewed with most image viewers (e.g., `eog`, `display`, or `GIMP`).
* Parallel computation is implemented in `image_generate.ispc`.

![Newton Fractal n = 3](images/frac3.png)
![Newton Fractal n = 7](images/frac7.png)
![Newton Fractal n = 32](images/frac32.png)
