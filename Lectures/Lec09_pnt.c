main ()
{
  char c='A', *p, s[100]; /* *strcpy(); Could also declare functions*/
  p = &c ;   /* Since p is a pointer we can assign the address of c 
                to it */
  printf("\n%c %c %c", *p, *p+1, *p+2);
  s[0] = 'A' ; s[1] = 'B'; s[2] = 'C'; s[3] = '\0'; /* The \0 is a null and
                                                       terminates the string */
  p = s;   /* s is pointer to an array */
  printf("\n%s %s %c %s",s, p, *(p+1), p+1);
  strcpy(s,"\nshe sells sea shells by the seashore");
  printf("%s",s);
  p += 17;  /* Since p is a pointer, this takes us to 17th charcacter */
  printf("\n  p incremented by 17 %c",*p);
  for ( ; *p != '\0' ; ++p ){
      if ( *p == 'e' ) *p = 'E';
      if ( *p == ' ' ) *p = '\n';
  }
  printf("%s\n",s); 
}
