/** 12.010 Homework 3, Question 3.
    Bike problem: This one is solved on one-dimension ie.
    roller coaster solution 

    cc -lm -lc needed
**/

#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "CBike.h"

/** Prototypes **/
void read_input();
void report_setup();
void report_error(int, char *);
double Int1D( double, double, double *, double *, double *);
double accel( double, double, double, double, double *, double *);
double GetIn(char *, double);

main() {

/*    Program to compute the path of a bicycle along a specified path as given 
    by drag, friction, and rider power (with a maximum force allowed at low
    velocity). Alternative Solution: 1-D integration along specific path */

int max_iter = 1000; 
double Trav_time, ttime1, ttime2 ; // Travel times (sec)
double step ; // Step size (s)
double Pos, Vel, XPos ; // Slope distance, velocity and X position

// Print out header 
printf("\n12.010 Program to solve Bike Motion problem\n");
printf("Given track characteristics and rider/bike properties \n");
printf("the time, energy and path are computed.\n") ;

// Get the input values
read_input();

// Output setup
report_setup();

// Start run.   First get the step size we need to match the accuracy needed
step = 2;
outT = 0;
ttime1 = 1000.0; ttime2 = 0;

while ( fabs(ttime1-ttime2) > terr/10. && step > 0.001 ) {
// Try first step size
     Pos = 0.0 ; Vel = 0.0; XPos = 0.0 ; ttime1 = 0.0 ;
     ttime1 = Int1D( step, ttime1, &Pos, &Vel, &XPos ); 
// Halve the step size and see change in time
     step = step/2;
     Pos = 0.0 ; Vel = 0.0; XPos = 0.0 ; ttime2 = 0.0 ;
     ttime2 = Int1D( step, ttime2, &Pos, &Vel, &XPos );
// Report on status
     printf("Step %6f Times %6f %6f Delta (ms) %6f\n",step, ttime1,ttime2,
            fabs(ttime1-ttime2)*1000.0);
}

// Now run the final solution
outT = 1;
if( out_int <= 0 ) {outT = 0;}

Pos = 0.0 ; Vel = 0.0; XPos = 0.0 ; Trav_time = 0.0 ;
Trav_time = Int1D( step, Trav_time, &Pos, &Vel, &XPos ); 

printf("\nTime to travel %6.3f km, %8.2f seconds, %6.2f hrs\n",Track_len/1000.,
    Trav_time, Trav_time/3600.0);
printf("Rider Energy %12.2f Joules, %12.3f Calories\n",tot_energy, tot_energy/cal_to_joule);
printf("Kinetic      %12.2f Joules\n", Mass*fabs(Vel*Vel)/2.0);
printf("Final Velocity %6.3f m/sec\n",Vel);

}
 
void report_setup() {

// Function to output setup paramters
  printf("\nPROGRAM PARAMETERS");
  printf("\n++++++++++++++++++\n");

  printf("Length of track %7.3f km and error %6.1f mm\n", Track_len/1000.0, terr*1000.0);
  printf("Track Slope %5.3f Sin and Cos amplitudes %5.2f %5.2f (m) and wavelenghth %6.2f (km)\n",
          Slope, As, Bs, lambda/1000.0);
  printf("Rider/Bike Mass %6.2f (kg), Area %6.3f (m**2), Drag and rolling Coefficient %6.2f %6.4f\n",
          Mass, Area, Cd, Cr);
  printf("Rider Power %6.2f (Watts) and max force %6.2f (N)\n",P_rider, F_max);
  printf("Output Interval %6.2f (s)\n",out_int);
  printf("\n++++++++++++++++++\n"); 


}

void read_input() {

// Function to read input 
char newin[20] ;  // Test to see if defaults will be updated
char request[80] ; // String to hold requested input label

  printf("\nDo you want to change defaults (y/n) ");
//  newin = getc(stdin) ; 
  fgets(newin,20,stdin);
  newin[0] = toupper(newin[0]);
  if( newin[0] == 'Y' ) {
     strcpy(request,"Length of track (km)");
     Track_len = GetIn(request,Track_len/1000)*1000;

     terr   = GetIn("Error Tolerance (mm)   ",terr*1000)/1000;
     Slope  = GetIn("Slope (radians)        ",Slope);
     As     = GetIn("Sin Amplitude (m)      ", As);
     Bs     = GetIn("Cos Amplitude (m)      ", Bs);
     lambda = GetIn("Sin/Cos wavelength (km)",lambda/1000)*1000;
     Mass   = GetIn("Rider+bike mass (kg)   ", Mass);
     Area   = GetIn("Rider Area (m^2)       ",Area);
     Cd     = GetIn("Drag coefficient       ", Cd);
     Cr     = GetIn("Rolling coefficient    ",Cr);
     out_int= GetIn("Output Interval(s)     ",out_int);
 
  }

}

double GetIn(char *request, double def) {

/* Function to get value for request. Using / will return the default */
char instr[80]; // String into which results are read
double inval = def ; // Input decoded from user string


// Print out request string and default
  printf("Enter - %s: Default %f ? ",request, def );

// Get input
  fgets(instr,80,stdin); 

// See if first character is /, if it is just return the default def
  if( instr[0] == '/' ) {
     return(def);
   }

// Decode value
   sscanf(instr,"%lf",&inval);
   return(inval);
}


double Int1D(double step, double int_time, double *Pos, double *Vel, double *XPos) {

// Runge-Kutta integration routine

double P, V, X  ; // Intermediate postion and velocity
double k1, k2, k3, k4 ; // Coefficients needed for Runge-Kutta

double time = 0.0, T ; // Time into integration
double tpast ;   // Time past end of track
double dist ;    // Final distance traveled
double ustep = step ;   // Used step for integration. Decreased as we approach end of track
double AP1, AP2, AP3 ; // Actual power supplied by rider
double Th1, Th2, Th3 ; // Slopes at points in integration (angle theta)

int done = 0 ;       // Set 0 until end of run, then set to 1.
int n = 0 ;          // Counter
int nint  ;          // Contains interger value of T/out_int.

// Initialize 
  tot_energy = 0.0;
  if ( outT != 0 ) {
     printf("O*    Time          X_pos        S_pos                S_vel     Energy\n");
     printf("O*    (sec)          (m)          (m)                 (m/s)     (Joules)\n");
     printf("O %10.3f %14.4f %14.4f %14.4f %12.2f\n",time, *XPos, *Pos, *Vel, tot_energy);
  }

// Integrate until we get the end of the track
   while ( done == 0 ) {
      n++;
      if( n > pow(10,6) ) {
         printf("**WARNING** Too many steps %d taken\n",n);
         done = 1;
      }

//    Compute accelerations
      k1 = ustep*accel(time, *Pos, *Vel, *XPos, &AP1, &Th1);
      P = *Pos + ustep* *Vel/2 + ustep*k1/8 ;
      V = *Vel + k1/2; 
      X = *XPos + (ustep* *Vel/2 + ustep*k1/8)*cos(Th1);

      k2 = ustep*accel(time+ustep/2, P, V, X, &AP2, &Th2);
      P = *Pos + ustep* *Vel/2 + ustep*k1/8 ;
      V = *Vel + k2/2; 
      X = *XPos + (ustep* *Vel/2 + ustep*k1/8)*cos(Th2);

      k3 = ustep*accel(time+ustep/2, P, V, X, &AP2, &Th2);
      P = *Pos + ustep* *Vel + ustep*k3/2 ;
      V = *Vel + k3; 
      X = *XPos + (ustep* *Vel + ustep*k3/2)*cos(Th2);

      k4 = ustep*accel(time+ustep, P, V, X, &AP3, &Th3);

//    Update the time, position and velocity
      T = time + ustep;
      P = *Pos + ustep*(*Vel + (k1+k2+k3)/6);
      V = *Vel + (k1+2*k2+2*k3+k4)/6;
      X = *XPos + (ustep*(*Vel + (k1+k2+k3)/6))*cos(Th2);

//    Compute the energy
      tot_energy = tot_energy + (ustep/2)*(AP1+4*AP2+AP3)/3;

//    See if we have passed the end of the track
      if ( X-Track_len > 0 ) {
         tpast = (X-Track_len)/(*Vel) ;
         ustep = tpast/2;
         if( fabs(X-Track_len) < terr/10 ) {
             time = T; *Pos = P; *Vel = V; *XPos = X;
             done = 1;
             if( outT != 0 ) printf("O %10.3f %14.4f %14.4f %14.4f %12.2f\n",time, X, P, V, tot_energy);                
          }
      }
      else {
         time = T; *Pos = P; *Vel = V; *XPos = X;
         nint = ceil(T/out_int) ; // Get the integer number of out_ints in T 
         if( outT != 0 && fabsl(T-nint*out_int) <= 1.e-3) {
            printf("O %10.3f %14.4f %14.4f %14.4f %12.2f\n",time, X, P, V, tot_energy);
         }
      }
  
//    See if we are completed based on time integration
      if( int_time != 0 ) {
          if( fabs(time-int_time) < step/10) done = 1;
      }
   }

// Finish up the calculation
   tpast = *XPos/(*Vel*cos(Th2));
   dist = *XPos - *Vel*cos(Th2)*tpast;
   return(time);
}  

double accel( double time, double P, double V, double X, double *AP, double *Theta) {

/* Routine to compute the acceleration of the body at position
   P and with Velocity V. Time is passed into the routine but
   ir is not needed for the forces considered here.  (In a more
   general problem with mass wastage we may need time to compute
   mass).
*/

double gacc, dacc, racc ; // Gravity, Drag rolling acceleration 
double facc ;   // Rider Force
double Vmag ;   // Velocity magnitude
double F_mag ;  // Force magnitude
double ac ;  // Sum of accelations

// Compute the accelerations
  *Theta = atan(Slope + As*cos(2*PI*X/lambda)*2*PI/lambda - 
                Bs*sin(2*PI*X/lambda)*2*PI/lambda);

/* DRAG: Acts opposite to the motion vector (since wind is fixed
   relative to motion direction) */
   Vmag = fabs(V);
   gacc = -g_0*sin(*Theta);
   dacc = -(Cd*rho_air*V*V/2)/Mass*Area ; // Note: This is Vmag^2*V_unit_vector
   racc = -g_0*Cr*cos(*Theta);

// Get the rider power
   F_mag = F_max ;
   if( Vmag > 0 )  F_mag = fmin(P_rider/Vmag, F_max) ;

   facc = F_mag/Mass;
   *AP = F_mag*Vmag;


// Add the acceleration together
   ac = gacc + dacc + racc + facc ;

   return(ac);
}











