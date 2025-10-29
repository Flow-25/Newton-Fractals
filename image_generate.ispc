#define epsilon 0.01

struct complex{
    float re;
    float im;
};

struct color_rgb{
    int r;
    int g;
    int b;
};

inline color_rgb sample_color(int i, int n, float intensity)
{
    float t = (float)i / (float)(n - 1);
    float h = t * 6.0f;
    float c = intensity;
    float x = c * (1.0f - abs(fmod(h, 2.0f) - 1.0f));

    float rf, gf, bf;
    if      (h < 1.0f) { rf = c; gf = x; bf = 0.0f; }
    else if (h < 2.0f) { rf = x; gf = c; bf = 0.0f; }
    else if (h < 3.0f) { rf = 0.0f; gf = c; bf = x; }
    else if (h < 4.0f) { rf = 0.0f; gf = x; bf = c; }
    else if (h < 5.0f) { rf = x; gf = 0.0f; bf = c; }
    else               { rf = c; gf = 0.0f; bf = x; }

    color_rgb col;
    col.r = (int)(rf * 255.0f);
    col.g = (int)(gf * 255.0f);
    col.b = (int)(bf * 255.0f);
    return col;
}

inline complex get_root(int i, int n){
    complex ret = {cos(2.0 * PI * (double) i / (double) n), sin(2.0 * PI * (double) i / (double) n)};
    return ret;
}

inline int check_roots(complex z, int n){
    int i = 0;
    while (i < n){
        complex r = get_root(i, n);
        if ((r.re - z.re) * (r.re - z.re) + (r.im - z.im) * (r.im - z.im) < epsilon)
            return i;
        i++;
    }
    return -1;
}


inline double double_fast_pow(double x, int n){
    double result = 1.0;
    while (n > 0) {
        if (n & 1)  // odd exponent
            result *= x;
        x *= x;
        n >>= 1;    // divide exponent by 2 using bit shift
    }
    return result;
}

inline complex complex_fast_pow(complex z, int n){
    complex result = {1.0f, 0.0f};
    while (n > 0) {
        if (n & 1){  // odd exponent
            double re = result.re * z.re - result.im * z.im;
            double im = result.re * z.im + result.im * z.re;
            result.re = re;
            result.im = im;
        }
        double zr = z.re * z.re - z.im * z.im;
        double zi = 2 * z.re * z.im;
        z.re = zr;
        z.im = zi;

        n >>= 1;    // divide exponent by 2 using bit shift
    }
    return result;
}


inline color_rgb evaluate_color(double x, double y, int n, int max_iterations){
    complex zp = {x, y};
    complex zn;
    int i = 0;
    
    while (i < max_iterations) {
        i++;
        double abs = zp.re * zp.re + zp.im * zp.im;
        complex zb = {zp.re, -zp.im};
        complex pow_c = complex_fast_pow(zb, n-1);
        double pow_d = double_fast_pow(abs, n-1);

        if (abs == 0){
            color_rgb c = {255,255,255};
            return c;
        }
        zn.re = (((double) (n-1)) * zp.re + pow_c.re / pow_d) / ((double)n);
        zn.im = (((double) (n-1)) * zp.im + pow_c.im / pow_d) / ((double)n);


        zp.re = zn.re;
        zp.im = zn.im;

        int color_id = check_roots(zn, n);
        if (color_id != -1){
            //assumption that n < 64 why need more when its indistingushable for human eye
            double intensity = max(1.0 / sqrt((float) i), 1.0 / 10.0);
            color_rgb c = sample_color(color_id + 1, n, intensity); 
            return c;
            //color evaluation based on iterations and root convergance
        }
    }
    color_rgb c = {0,0,0};
    return c;
}

export void fill_image(uniform int8 r[], uniform int8 g[], uniform int8 b[], uniform int width, uniform int height, uniform int max_iterations, uniform int n) {
    int center_x = width / 2;
    int center_y = height / 2;
    
    for (int j = 0; j < height; j++){
        foreach (i = 0 ... width) {
            double x = ((double) i) / ((double) center_x) - 1.0;
            double y = ((double) j) / ((double) center_y) - 1.0;
            color_rgb color = evaluate_color(x, y, n, max_iterations);
            int px = i + j * width;
            r[px] = color.r;
            g[px] = color.g;
            b[px] = color.b;
        }
    }    
}

