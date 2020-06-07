   #include <stdio.h>
   #include <math.h>

   /* Program to calculate the area of a circle */
   int main( int argc, char *argv[] )
   {
     float radius;
     int   nmatch;

     if ( argc != 2 ) {
      printf("Usage: %s radius\n",argv[0]);
      exit(-1);
     }

     nmatch = sscanf(argv[1],"%f\n",&radius);
     if ( nmatch == 0 ) {
      printf("Usage: %s radius\n",argv[0]);
      exit(-1);
     }

     printf("Radius == %f\n",radius);
     printf("  Area == 0.\n",M_PI*radius*radius);
   }

