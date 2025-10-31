#include <iostream>
#include <fstream>
#include <complex>
#include "newton.ispc.h"  

int main() {
    const int width = 800;
    const int height = 800;
    const int maxIter = 50;
    int n = 5; 

    std::vector<int> output(width * height);

    // ISPC parallel function call
    ispc::computeNewtonFractal(width, height, maxIter, n, output.data());

    // save like PPM 
    std::ofstream file("newton.ppm");
    file << "P3\n" << width << " " << height << "\n255\n";
    for (int i = 0; i < width * height; i++) {
        int val = output[i];
        // hue: for each root there are different colour
        int r = (val * 123) % 256;
        int g = (val * 231) % 256;
        int b = (val * 321) % 256;
        file << r << " " << g << " " << b << "\n";
    }
    file.close();
    std::cout << "Done! Image saved as newton.ppm\n";
}
