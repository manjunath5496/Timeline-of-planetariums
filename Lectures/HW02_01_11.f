      Program HW02_01

      implicit none

*     Program to produce a table Errof function (erf) and its first derivative


      integer*4 max_arg   ! Maximum number of arguments
      parameter ( max_arg = 101 )

* MAIN PROGRAM VARIABLES

      integer*4 ierr  ! IOSTAT error in case there is a problem writing
                      ! to screen

      integer*4 i         ! Loop variables
      integer*4 narg      ! Number of arguments to be computed

      real*8 arg(max_arg)        ! Arguments to be evaluated
      real*8 erf_arg(max_arg)   ! Value of ERF at argument values
      real*8 derf_arg(max_arg)  ! Value of d(ERF)/dc at argument values

      real*8 a    ! Loop variable used to generate arguments
      integer*4 ia, na  ! Integer values for used in do loops.

      real*8 erff, derff  ! Functions to compute erf and d(erf)/dx
    

****  Write the header lines out
      write(*,120,iostat=ierr)
 120  format(/,
     .       '--------------------------------------------------',/,
     .       'TABLE OF ERROR FUNCTION (ERF) AND FIRST DERIVATIVE',/,
     .       '--------------------------------------------------',/,
     .       '| Argument  |    ERF   | d(ERF)/dx  |')
      write(*,140)
 140  format('|___________|__________|____________|')

****  Generate the arguments to be used (-3.0 to 3.0 in 0,25 steps)
      i = 0
      na = nint(6.0d0/0.25d0)
!     do a = -3.0d0, 3.0d0, 0.25d0
      do ia = 0, na
          a = -3.0d0 + ia*0.25d0
          i = i + 1
          if( i.gt. max_arg ) then
              write(*,210) max_arg
 210          format('** ERROR ** Too many (',i4,
     .                              ') arguments requested')
              stop 'Too Many arguments'
          end if
*         Save the argument value
          arg(i) = a
      end do
      narg = i

****  Generate the results
      do i = 1, narg
         erf_arg(i) = erff(arg(i))
         derf_arg(i) = derff(arg(i))
         write(*,220) arg(i), erf_arg(i), derf_arg(i)
 220     format('|',1x,F6.3,4x,'|',1x,F8.5,1x,'|',1x,F8.5,3x,'|')
         print *,'i, arg(i)', i, arg(i), erff(arg(i)), erf(arg(i))
      end do

      write(*,140)
 
****  Thats all
      end 

*--------------------------------------------------------------------
CTITLE ERFF

      real*8 function erff(x)
      implicit none

*     Function to compute ERF based on the Maclaurin series given at
*     http://mathworld.wolfram.com/Erf.html Eqn 6

* PASSED VARIABLES
      real*8 x    ! Argument for Erf function

* PARAMETERS

      real*8 pi, eps
      parameter ( pi   = 3.1415926535897932D0 )
      parameter ( eps  = 1.d-6  )  ! Accuracy of calculation

* LOCAL VARIABLES
      real*8 erf_sum    ! Sum in the Maclaurin series
      real*8 factorial  ! function to return factorial value
      real*8 err        ! Estimate of size of last term in series

      integer*4 n       ! Index to loop over sum in series
      integer*4 max_n   ! Maximum value of n needed



****  Based on size of argument, compute number of terms need
      err = 1.d0
      max_n = 1
      do while ( err .gt. eps .and. max_n.lt. 100)
          max_n = max_n + 1
          err = abs(x**(2*max_n+1)/
     .                    (factorial(max_n)*(2*max_n+1)))
      end do

      erf_sum = 0.d0
      do n = 0, max_n
         erf_sum = erf_sum + (-1.d0)**n* x**(2*n+1) / 
     .                           (factorial(n)*(2*n+1))
      end do

      erff = 2.d0*erf_sum/sqrt(pi)

      return
      end

*--------------------------------------------------------------------
CTITLE DERFF

      real*8 function derff(x)
      implicit none

*     Function to compute first derivative of ERF
*     http://mathworld.wolfram.com/Erf.html Eqn 27

* PASSED VARIABLES
      real*8 x    ! Argument for Erf function

* PARAMETERS

      real*8 pi
      parameter ( pi   = 3.1415926535897932D0 )

* LOCAL VARIABLES
*     None

      derff = 2.d0/sqrt(pi)*exp(-x**2)

      return
      end


*--------------------------------------------------------------------
CTITLE FACTORIAL

      real*8 function factorial(n)

      implicit none

*     Function to compute factorial.  Note: We use as real*8 so that
*     integer overflows will not occur for large n.

* PASSED VARIABLES
      integer*4 n   ! argument

* LOCAL VARiABLES
      integer*4 i   ! Loop counter

      factorial = 1.d0
      do i = 2, n
         factorial = factorial*i
      end do

****  Return
      return
      end

