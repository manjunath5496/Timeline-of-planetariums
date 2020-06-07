#include <stdio.h>
#include <math.h>
main()
{

 /* Write Hello */
 printf("Hello\n");

 /* Write Hello and the value of PI */
 /* Two statements separated by ;   */
 /* PI is defined in math.h         */
 /* without math.h you get an error */
 /* at compile time if you try to   */
 /* print PI.                       */
 fprintf(stdout,"Hello\n");   fprintf(stdout,"pi == %f\n",M_PI);

}

