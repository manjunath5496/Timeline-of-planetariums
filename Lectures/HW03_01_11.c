/*12.010 Homework #3 Question 1:
  Error function calculation.
  Here we compute the error function and we compare
  it with the C erf result

Compile and link with
cc -lm hw3_1_06.c -o  hw3_1_06

Accuracy may be passed in runstring i.e.,
hw3_1_06 1.e-9
will evaluate erf with 9 significant digits.
*/

/* Prototype definitions */
double factorial( int ) ;
double myerf(double, double );
double dmyerf(double );


#define PI 3.1415926535897932

#include <math.h>
#include <stdio.h>

int main(argc, argv) 
int argc ; // Number of arguments
char  *argv[] ; // Pointer to arguments

{
double eps ; // Accuracy of error function calculation 
double a ; // argument for erf
double cerf, merf, derf  ; // C-function ERF, My coding of Erf, derivative of Erf

/* See how many arguments were passed */
   if ( argc > 1 ) {
       sscanf(argv[1],"%lf",&eps); }
   else {
       eps = 1.e-6;    // Use default value
   }

/* Now output headers */
   printf("---------------------------------------------------------------\n");
   printf("TABLE OF ERROR FUNCTION (ERF) within %8.2e AND FIRST DERIVATIVE\n",eps);
   printf("---------------------------------------------------------------\n");
   printf("| Argument  |    ERF   | d(ERF)/dx  |     ERFC    |   Error   |\n");
   printf("|___________|__________|____________|_____________|___________|\n");

/* Loop over argument range */
   for ( a = -3.0; a <= 3.0 ; a += 0.25 ) {
       cerf = erf(a);
       merf = myerf(a,eps);
       derf = dmyerf(a); 
       printf("| %6.3f    | %8.5f | %9.5f  |  %8.5f   | %9.2e |\n",a, merf, derf, cerf, merf-cerf);
   }
   printf("|___________|__________|____________|_____________|___________|\n");

}

double myerf(double x, double eps) {

// Routine to compute Erf with accuaracy erf
double err =1.0  ; // Error in term
double erf_sum = 0.0 ; // Sum of terms in ERF function
int max_n = 1 ;    // Maximum number of terms in Maclaurin series
int n ;            // Loop variable

/* Compute howmany terms we need */
   while ( err > eps && max_n < 100 ) {
      max_n += 1 ;
      err = fabs(pow(x,(2*max_n+1))/(factorial(max_n)*(2*max_n+1)));
   }

/* Now compute the function value */
   for ( n = 0 ; n <= max_n ; ++n ) {
        erf_sum = erf_sum + pow(-1.0,n)*pow(x,(2*n+1)) / (factorial(n)*(2*n+1));
   }

   return(2*erf_sum/sqrt(PI));
}

double dmyerf(double x) {
// Routine to compute first derivative of ERF
      return(2/sqrt(PI)*exp(-x*x));
}

double factorial( int n) {
// Routine to compute factorial
double fs = 1.0 ; // Factorial value
int i ;  // Loop counter

//  Loop doing multiplication
   for ( i = 2; i <= n ; ++i ) {
      fs = fs*i;
   }
   return(fs);
}







