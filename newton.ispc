// newton.ispc
// Compute Newton Fractal for f(z) = z^n - 1

// ISPC doesn't define M_PI by default, so define it manually:
#define M_PI 3.14159265358979323846f

export void computeNewtonFractal(
    uniform int width,
    uniform int height,
    uniform int maxIter,
    uniform int n,
    uniform int output[] // uniform array parameter
)
{
    uniform float xmin = -2.0f;
    uniform float xmax =  2.0f;
    uniform float ymin = -2.0f;
    uniform float ymax =  2.0f;

    foreach (y = 0 ... height, x = 0 ... width)
    {
        float cx = xmin + (xmax - xmin) * ((float)x / (float)width);
        float cy = ymin + (ymax - ymin) * ((float)y / (float)height);

        float zr = cx;
        float zi = cy;

        int iter = 0;

        for (; iter < maxIter; ++iter)
        {
            float r = sqrt(zr * zr + zi * zi);
            float theta = atan2(zi, zr);

            float fr = pow(r, n) * cos(n * theta) - 1.0f;
            float fi = pow(r, n) * sin(n * theta);

            float dr = n * pow(r, n - 1) * cos((n - 1) * theta);
            float di = n * pow(r, n - 1) * sin((n - 1) * theta);

            float denom = dr * dr + di * di;
            if (denom == 0.0f)
                break;

            float zr_new = zr - (fr * dr + fi * di) / denom;
            float zi_new = zi - (fi * dr - fr * di) / denom;

            if (sqrt((zr_new - zr)*(zr_new - zr) + (zi_new - zi)*(zi_new - zi)) < 1e-6f)
                break;

            zr = zr_new;
            zi = zi_new;
        }

        int rootIndex = 0;
        float minDist = 1e9f;

        for (uniform int k = 0; k < n; ++k)
        {
            float rootR = cos(2.0f * M_PI * (uniform float)k / (uniform float)n);
float rootI = sin(2.0f * M_PI * (uniform float)k / (uniform float)n);            float dist = sqrt((zr - rootR)*(zr - rootR) + (zi - rootI)*(zi - rootI));
            if (dist < minDist)
            {
                minDist = dist;
                rootIndex = k;
            }
        }

        int color = ((rootIndex * 40) % 255) + ((iter * 5) % 255);
        output[y * width + x] = color;
    }
}

