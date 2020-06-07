/*
 Program to calculate trajectory of object thrown 
 vertically i a gravitational field.

 Program arguments
  t1 - finish time       ( s   )
  dt - time step         ( s   )
  w0 - start velocity    ( m/s )

 Parameters
  g  - gravitational acceleration  ( m/s ) 
  m  - mass of object

 Program steps forward velocity (w) and location of object (z)
 from time t to time t+dt as follows

 w(n) = w(n-1) + g*dt 
 z(n) = 0.5*(w(n)+w(n-1))*dt 
 t=t+dt 

 Program also tracks kinetic (ke) and potential energy (pe) of
 the object
 ke = 0.5*w*w*m
 pe = z*g*m


*/
#include <stdio.h>    /* I/O libraries                              */
#include <stdlib.h>   /* Memory allocation, string functions etc... */
#include <cmath>      /* Math functions                             */

float g = -9.81; /* Make g a global parameter */
FILE *outf;      /* Output stream             */

#include "Ball.h"

/* Prototypes */
void gettheargs( int, char **, float *, float *, float *);


/*==============================================*/
/*=== main() ===================================*/
/*==============================================*/
main ( int argc, char *argv[] )
{
 float t1;        /* Length of integration    */
 float dt;        /* Timestep                 */
 float w0;        /* Initial velocity         */

 Ball ball1;

 outf=stdout;


 /* Read programs args */
 gettheargs( argc, argv, &t1, &dt, &w0);

 /* Create a ball        */
 ball1.init(t1,dt,w0);
 /* Integrate trajectory */
 ball1.integrate();
 /* Print trajectory     */
 ball1.print();

}

/*==============================================*/
/*=== getargs() ================================*/
/*==============================================*/
/*
  Read the command line arguments.
*/
void gettheargs( int argc, char *argv[], 
                 float *t1, float *dt, float *w0)
{
 int nmatch;

 if ( argc != 4 ) {
  printf("Usage: %s tend dt w0\n",argv[0]);
  exit(-1);
 }
 nmatch = sscanf(argv[1],"%f\n",t1);
 if ( nmatch == 0 ) {
  printf("Usage: %s tend dt w0\n",argv[0]);
  exit(-1);
 }
 nmatch = sscanf(argv[2],"%f\n",dt);
 if ( nmatch == 0 ) {
  printf("Usage: %s tend dt w0\n",argv[0]);
  exit(-1);
 }
 nmatch = sscanf(argv[3],"%f\n",w0);
 if ( nmatch == 0 ) {
  printf("Usage: %s tend dt w0\n",argv[0]);
  exit(-1);
 }
}
