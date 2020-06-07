/** Header file for bike problem **/

#define PI 3.1415926535897932

/* Constants */
double g_0 = 9.8 ; // m/sec^2
double rho_air = 1.226 ; // kg/m^3
double cal_to_joule = 4.1868 ; // Conversion of joules to calories

/* Values for bike and path */
double Mass = 80.0 ;   // kg
double Cd = 0.90, Cr = 0.007 ; // Drag and rolling
double Area = 0.67 ;   // m^2
double P_rider = 100.0, F_max = 20 ; // Rider power and max force
double tot_energy ;    // Total energy Joules
double terr = 0.010 ;  // Error in position (m)
double out_int = 100 ; // Output interval (sec)

double Slope = 0.001 ; // Slope
double As = 5.0, Bs = 0.0 ; // Sin and Cos Amplitudes (m)
double lambda = 2000.0 ; // Wavelength (m)
double Track_len = 10000.0 ; // Track length (m)

int outT ;  // Set non-zero for output of results


