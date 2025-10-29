// main.cpp
#include <fstream>
#include <vector>
#include <iostream>
#include <cstdlib>

extern "C" void fill_image(unsigned char *r, unsigned char *g, unsigned char *b, int width, int height, int iterations, int n);

int main(int argc, char **argv) {
    if (argc < 6) {
        std::cerr << "Usage: " << argv[0] << " <degree> <width> <height> <max_iterations> <out.ppm>\n";
        return 1;
    }
    int n = std::atoi(argv[1]);
    int width  = std::atoi(argv[2]);
    int height = std::atoi(argv[3]);
    int iterations = std::atoi(argv[4]);
    const char *out = argv[5];

    std::vector<unsigned char> pixels((size_t)width * height * 3);
  
    std::vector<unsigned char> r((size_t)width * height);
    std::vector<unsigned char> g((size_t)width * height);
    std::vector<unsigned char> b((size_t)width * height);
    fill_image(r.data(), g.data(), b.data(), width, height, iterations, n);

    for (int i = 0;  i < width * height; i++){
      pixels[3 * i] = r[i];
      pixels[3 * i + 1] = g[i];
      pixels[3 * i + 2] = b[i];
    } 
  
    std::ofstream ofs(out, std::ios::binary);
    if (!ofs) { std::cerr << "Failed to open output\n"; return 1; }

    // PPM P6 header
    ofs << "P6\n" << width << " " << height << "\n255\n";


    ofs.write(reinterpret_cast<char*>(pixels.data()), pixels.size());
    return 0;
}
