/* 12.010 Homework #3 Question 2
  Characater manipulation through reading and writing names
*/
/* Prototype definitions */
int getfoldword( char *, int, char *) ;  /* Function to extract word and  
             casefold it..  First letter to upper case, rest to lower case */


#define MAXLEN 256

#include <stdio.h>
#include <string.h>
#include <ctype.h>

int main(viod) {

  char all[MAXLEN] ; // Complete name typed by used
  char first[MAXLEN], middle[MAXLEN], last[MAXLEN] ; // Name slit to pieces

  int lenall ; // Length of total string as read
  int pos ;   // Position in string
  int sf, ef, sm, em, sl, el ; /* Positions in string all of start first (sf),
                 end first (ef), start middle (sm), end middle (em), start last (sl),
                 end last (el) */
  int i ;
  int blen ; // Lenth of all the words in the name

/* Get input from user */
  printf("\nEnter your names (First, middle, last) ");
//  gets(all); // Get all the names at once.
  fgets(all, MAXLEN, stdin ) ; // Use the safer method
// The string all still contains a newline character at the end.

/* Get full length of string */
  lenall = strlen(all) ; 
  if( lenall == 0 || lenall > MAXLEN ) {
      printf("ERROR: Null string or too long string (Tried %d Max %d)\n",lenall, MAXLEN);
      return(MAXLEN);
  }


/* Now start splitting string */
   sf = 0;
   ef = getfoldword(all,sf, first); 

   sm = ef + 1;
   em = getfoldword(all,sm, middle);
 
   sl = em + 1;
   el = getfoldword(all,sl, last);

/* Now print out result in banner */
   if ( el > sl ) { blen = (ef-sf)+1+(el-sl)+9;} 
   else { blen = (ef-sf)+(em-sm)+6;}

   for ( i = 0 ; i < blen ; ++i ) printf("*");  printf("\n");
/* See if two or three names passed */
   if ( el > sl ) {
      printf("* %s, %s %c. *\n",last, first, middle[0]); }
   else {
      printf("* %s, %s *\n",first, middle) ; // In this case middle was last name
   }
   for ( i = 0 ; i < blen ; ++i ) printf("*");  printf("\n\n");
}


int getfoldword( char *all, int start, char* word) {

/* Function to look for next space after staring point start in string all and
   return the extract string in word */

   int i = start ; // Loop variable
   int eall ;   // character number for last character
   int found = 0  ; //  Set to 1 once the space is found
   int lenall ; // Length of all string

   lenall = strlen(all);

/* Work our way through any blanks at current location (ie. this 
   allows for multiple blanks between names */

/* If the first character is blank, look along string until non-
   blank character is found */
   if( all[i] == ' ' ) {
      while( found == 0 && i < lenall ) {
         i += 1;
         if( all[i] != ' ' ) found = 1;
      }
   }
   start = i;  
/*  Now loop to find next blank */
   found = 0 ; // Reset status  
   while( found == 0 && i < lenall ) {
      i += 1;
      if( all[i] == ' ' || all[i] == '\n' ) found = 1;
   }
/*  Last character checked is blank, so move back one position */
    eall = i - 1;
    word[0] = toupper(all[start]);
    for ( i = start+1 ; i <= eall ; i++ ) {
      word[i-start] = tolower(all[i]); 
    }
    word[i-start] = '\0' ;
    return(eall);
}
