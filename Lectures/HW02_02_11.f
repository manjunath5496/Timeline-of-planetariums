      program hw2_2

*     Program to write names to the screen in various formats

* MAIN PROGRAM VARIABLES
      integer*4 len_in      ! Length of input string passed by user

      integer*4 len_first_name, len_last_name, len_capline  
*                           ! Lengths of names strings
      integer*4 len_fin     ! Length of banner needed for final
                            ! form of name (sum of first and last
                            ! name length + constant for middle initial
                            ! and puncutation in name
      integer*4 ierr        ! IOSTAT error reading string
      integer*4 lenline     ! Function to return length of non-blank
                            ! portion of a string
      integer*4 i           ! Implicit do-loop variable to write banner
      integer*4 pos         ! Counter keeping track of character position
                            ! in inline to extract names

      character*80 inline   ! Line read from the terminal
      character*80 capline  ! Line converted to capitials

      character*80 first_name, last_name  ! First and last names
      character*80 middle_name  ! Persons middle initial
      character*1  banner_symbol   ! Symbol to be used in the banner

*     Define the symbol to be used for the banner
      banner_symbol = '*'

*
* Solution Method 1: Reads name into one string and parses string
*
*     Read the persons name and output in caps
*     Tell user we want
      write(*,220)
 220  format('Enter your names (First, middle, last) ',$)
      read(*,'(a)',iostat=ierr) inline
*     Report any error that occurred reading line
      call report_error(ierr,'Reading user name')

*     See if any names were given
      len_in = lenline(inline)
      if( len_in.eq.0 ) then
          call report_error(-1,'No names given')
      endif

*                                                              
*     Dissect the name passed and extract first_name, MI, and 
*     last name
      pos = 0
      call GetName(inline, pos, first_name)
      call GetName(inline, pos, middle_name)
      call GetName(inline, pos, last_name)

*     Get the length of each name part
      len_first_name = lenline(first_name)
      len_last_name  = lenline(last_name)

****  Check the length of the last name.  If this is zero then 
*     probably no middle initial, so re-extract last name and
*     set middle initial to ?
      if( len_last_name.eq.0 ) then
          pos = 0
          call GetName(inline, pos, first_name)
          call GetName(inline, pos, last_name)
          len_last_name  = lenline(last_name)
          middle_name = '?'

*         As a final check.  See if last name is still of zero length
          if( len_last_name.eq.0 ) then
*             Only one name must have been given
              last_name = '?'
              len_last_name = 1
          end if 
      end if

*     Additional check: Makesure first characters are capitalized
      call tocaps(first_name(1:1),first_name(1:1))
      call tocaps(last_name(1:1), last_name(1:1))
      call tocaps(middle_name, middle_name )

      len_fin = len_first_name + len_last_name + 9

      write(*,'(100a)') (banner_symbol, i=1,len_fin)
      write(*,240) banner_symbol, last_name(1:len_last_name),
     .             first_name(1:len_first_name), middle_name , 
     .             banner_symbol
 240  format(a1,1x,a,', ',a,1x,a1,'. ',a1)
      write(*,'(100a)') (banner_symbol, i=1,len_fin)

****
****  Approach number 2: Reads names directly:  Here we read the
*     names into separate string directly
      last_name = ' '
      first_name = ' '
      middle_name = ' '
      write(*,320)
 320  format('Second method: You will need to enter all 3 names ',/,
     .       'Enter first, middle and last name ',$)
      read(*,*) first_name, middle_name, last_name
*     Report any error that occurred reading line
      call report_error(ierr,'Reading user name (second method)')

****  Now case fold and output
      len_first_name = lenline(first_name)
      len_last_name  = lenline(last_name)
      call tocaps(first_name(1:1),first_name(1:1))
      call tocaps(last_name(1:1), last_name(1:1))
      call tocaps(middle_name, middle_name )

      len_fin = len_first_name + len_last_name + 9

      banner_symbol = '+'
      write(*,'(100a)') (banner_symbol, i=1,len_fin)
      write(*,240) banner_symbol, last_name(1:len_last_name),
     .             first_name(1:len_first_name), middle_name , 
     .             banner_symbol
      write(*,'(100a)') (banner_symbol, i=1,len_fin)




      end

*-----------------------------------------------------------------------

      subroutine report_error(ierr,mess)

*     Routine to report IOSTAT errors.  Initially developed
*     for 12.010 HW2 Problem 2.

* PASSED VARIABLES

      integer*4 ierr
      character*(*) mess

* LOCAL VARIABLES
* None
      
***** See if the IOSTAT error was non-zero
      if( ierr.ne.0 ) then
         write(*,120) ierr, mess
 120     format('IOSTAT Error ',i4,' occurred ',a)
         stop 'HW2_2: IO Error in program'
      end if

      return
      end
      
*-----------------------------------------------------------------------

      subroutine tocaps(in,out)

*     Function to convert to upper case

* PASSED VARIABLES
      character*(*) in    ! Input string to be convert
      character*(*) out   ! Output casefolded string

* LOCAL VARIABLES
      integer*4 i         ! Counter looping over strinf
      integer*4 len_in_out    ! Declared length of in and 
                          ! out strings

****  Get the length of string to be converted
      len_in_out = MIN(LEN(in),LEN(out))

*     Loop over each character and convert to upper case.
      do i = 1, len_in_out
         if( in(i:i).ge.'a' .and. in(i:i).le.'z' ) then
             out(i:i) = CHAR( ICHAR(in(i:i))-32 )
         else
             out(i:i) = in(i:i)
         endif
      end do

      return
      end

*-----------------------------------------------------------------------

      integer*4 function lenline(in)

*     Returns length of used portion of string.  Originally
*     developed for HW2 Problem 2.

* PASSED VARIABLES
      
      character*(*) in   ! The string passed that we need to find
                          ! the last character of

* LOCAL VARIABLES
      integer*4 len_in    ! Declared length of in string
      integer*4 i         ! Counter used to work backwards through string

***** Get the declared length of string
      len_in = LEN(in)
      i = len_in
      do while ( i.gt.0 .and. in(i:i).eq.' ')
          i = i - 1
      end do

      lenline = i

      return
      end

*-----------------------------------------------------------------------

      subroutine GetName(in, pos, word )

*     Routine to extract the next full word after position pos in string

* PASSED VARIABLES
      character*(*) in   ! The string passed that we need to extract the
                         ! next word from

      character*(*) word ! Next word extract
      integer*4 pos      ! Starting position in string, is updated with
                         ! position of the last character

* LOCAL VARIABLES
      integer*4 begin, finish  ! Beginning and finishing character numbers
                         ! in string
      integer*4 i        ! Loop counter as we search for blanks
      integer*4 len_in   ! Declared length of input string

*     Initialize and start searching up
      len_in = LEN(in)
      if( pos.lt.0 ) then
          pos = 0
      else if ( pos.ge.len_in ) then
*         We are at end string already.  Keep pos the same and return
*         blank string
          word = ' '
          pos  = len_in
      else
*         OK, Start searching for the beginning of the next word
          i = pos+1
          do while (in(i:i).eq.' ' .and. i.lt.len_in)
             i = i + 1
          end do

*         See if we reached the end of the string ie. There are no 
*         more words to extract
          if( i.eq.len_in .and. in(i:i).eq.' ' ) then
*             No more words
              word = ' '
              pos  = len_in
          else
*             OK, We hit a character, this is the beginning of the
*             next word
              begin = i
*             Now find then end
              do while ( in(i:i).ne.' ' .and. i.lt.len_in )
                  i = i + 1
              end do
*             Now see if we reached a blank or the end of the string
              if( in(i:i).eq.' ' ) then
                  finish = i-1
              else
                  finish = i
              endif

              word = in(begin:finish)
              pos  = finish
          end if
      end if

      return
      end
      








