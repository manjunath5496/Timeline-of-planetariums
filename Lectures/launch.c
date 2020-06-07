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
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  double  w;
  double  z;
  double pe;
  double ke;
} t_gball;

float g = -9.81; /* Make g a global parameter */
float m = 1.;    /* Make m a global parameter */

/*==============================================*/
/*=== main() ===================================*/
/*==============================================*/
main ( int argc, char *argv[] )
{
 float t1;        /* Length of integration    */
 float dt;        /* Timestep                 */
 float w0;        /* Initial velocity         */

 t_gball *theBall;/* Stats for the ball       */

 double m;        /* Mass of the ball         */
 int nmatch;      /* I/O monitor              */
 int nsteps;      /* Timestep counter         */
 int i;           /* Loop counter             */

 FILE *outf=stdout;

 /* Read programs args */
 gettheargs( argc, argv, &t1, &dt, &w0);

 /* Allocate space for full ball time history */
 nsteps = t1/dt;
 if ( nsteps < 1 ) {
  printf("dt must be les than tend\n");
  printf("Usage: %s tend dt w0\n",argv[0]);
  exit(-1);
 }
 theBall = (t_gball *) calloc(nsteps+1, sizeof(*theBall) );
 if ( theBall == NULL ) {
  printf("allocation of coordinate and speed structure failed\n");
  printf("%d MB requested\n",sizeof(*theBall)*nsteps/1024/1024);
  printf("Usage: %s tend dt w0\n",argv[0]);
  exit(-1);
 }
 theBall[0].w  = w0;
 theBall[0].z  = 0;
 theBall[0].pe = 0;
 theBall[0].ke = 0;
 theBall[1].w  = w0;
 theBall[1].z  = 0;
 theBall[1].pe = 0;
 theBall[1].ke = 0;
 m             = 0.1;

 /* Begin calculation */
 for (i=1;i<nsteps;++i) {
  theBall[i+1].w  = theBall[i].w+dt*g;
  theBall[i+1].z  = theBall[i].z
                   +0.5*(theBall[i+1].w+theBall[i].w)*dt;
  theBall[i+1].ke = 0.5*m*theBall[i+1].w*theBall[i+1].w;
  theBall[i+1].pe = -g*m*theBall[i+1].z;
 }

 /* Write ttable of output */
 for (i=0;i<nsteps;++i) {
  fprintf(outf,"%f %f %f %f %f %f\n",
          dt*(float) i,
          theBall[i].z,
          theBall[i].w,
          theBall[i].ke,
          theBall[i].pe, 
          theBall[i].ke+theBall[i].pe);
 }   
}

/*==============================================*/
/*=== getargs() ================================*/
/*==============================================*/
/*
  Read the command line arguments.
*/
gettheargs( int argc, char *argv[], 
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
