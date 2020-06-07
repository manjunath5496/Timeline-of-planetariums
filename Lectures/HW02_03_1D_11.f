      Program Bike

*     Program to compute the path of a bicycle along a specified path as given 
*     by drag, friction, and rider power (with a maximum force allowed at low
*     velocity).
*     Alternative Solution: 1-D integration along specific path

      implicit none

* Parameters need for program (Physical constants) and the "constants"
*     in the program

      include 'FBike.h'

      integer*4 max_iter   ! Maximum number of iterations allowed

      parameter ( max_iter = 1000 ) 

* MAIN PROGRAM VARIABLES
      real*8 Trav_time, Trav_time1, Trav_time2   ! Travel time (sec)
      real*8 step        ! Integration step size (secs).  We initially
                         ! set this value but check that it is OK and
                         ! reset as needed.
      real*8 Pos, Vel, XPos  ! Distance and velocity of bike along path and
                             ! X-position of bike.

****  Let the user know what this program does:
      write(*,120)
 120  format(/,'12.010 Program to solve Bike Motion problem',/,
     .         'Given track characteristics and rider/bike properties',
     .         ' the time, energy and path are computed')
    
****  Find out from the user the necessary inputs.  We use a variety
*     of input schemes here.  The characteristics of the object can
*     be put into a file thus allowing easy runs with different 
*     distances and launch angles.
      
      call read_input 

***** Report to the user the setup parameters

      call report_setup

****  Run test runs to see what integration step size we need.
      step = 1.0d0 ! Initially set step size to 1-sec (tested in int_soln)

****  Write out the solution
      outT = .false.
      Trav_time1 = 0
      Trav_time2 = 1.e3
*     Check that step size matchs tolerance terr. (Tolerance is in meters
*     so convert to time with 10 m/s velocity assumption)
*     Assume a speed of 10 m/s convert distance into time difference
      do while ( abs(Trav_time1-Trav_time2).gt.terr/10.0 .and.
     .           step .gt.1.d-3 )

          Pos = 0.0
          Vel = 0.0
          Xpos = 0.0
          Trav_time1 = 0.d0

          call Int1D(step, Trav_time1, Pos, Vel, Xpos )
          step = step/2
          Pos = 0.0
          Vel = 0.0
          Xpos = 0.0
          Trav_time2 = 0.d0
          call Int1D(step, Trav_time2, Pos, Vel, Xpos )
          write(*,160) step, Trav_time1,Trav_time2, 
     .                abs(Trav_time1-Trav_time2)*1000.d0*10
 160      format('Step size ',E12.3,' s, Times ',2F10.4, ' s ',
     .           ' Error ',F10.2,' mm')
      end do

      outT = .true.
      if( out_int.le.0 ) outT = .false.

      Pos = 0.0
      Vel = 0.0
      Xpos = 0.0
      Trav_time = 0.d0
      call Int1d(step, Trav_time, Pos, Vel, Xpos )
      write(*,220) Track_len/1.d3, Trav_time, Trav_time/3600.d0, 
     .             tot_energy, 
     .             tot_energy/cal_to_joule,
     .             Mass*abs(Vel)**2/2.d0
 220  format(/,'Time to travel ',F6.3,' km, ',F8.2,' seconds, ',F6.2, 
     .         ' hrs',/,
     .         'Rider Energy ',F12.2,' Joules, ',F12.3, ' Calories',/,
     '         'Kinetic      ',F12.2,' Joules',/)
      write(*,240) Vel
 240  format('Final Velocity ',F6.3,' m/sec')


****  Thats all
      end

CTITLE REPORT_SETUP

      subroutine report_setup

      implicit none

*     Routine to report the parameters being used in the run

* Parameters need for program (Physical constants)
      include 'FBike.h'

* 
      write(*,120) 
 120  format(/,'PROGRAM PARAMETERS',/,
     .       '++++++++++++++++++')

      write(*,140) Track_len/1.0d3, Terr*1.d3
 140  format('Length of track ',F7.3,' (km) and error ',F6.1, '(mm)')

      write(*,160) Slope, As, Bs, Lambda/1.0d3
 160  format('Track Slope ',F5.3,' Sin and Cos amplitudes ',2(F5.2,1x),
     .       '(m) and wavelenghth ',F6.2,' (km)')

      write(*,180) Mass, Area, Cd, Cr
 180  format('Rider/Bike Mass ',F6.2,'(kg), Area ',F6.3,' (m**2),',
     .       'Drag and rolling Coefficient ',F6.2,1x,F6.4)
 
      write(*,200) P_rider, F_max
 200  format('Rider Power ',F6.2,' (Watts) and max force ',F6.2,' (N)')

      write(*,220) 
 220  format(60('+'))

***** Thats all
      return
      end


CTITLE READ_INPUT

      subroutine read_input
      implicit none

*     Routine to read the input parameters of the program

      include 'FBike.h'

      integer*4 ierr       ! IOSTAT error reading user inputs

* LOCAL VARIABLES
      real*8 terr_mm        ! Integration accuracy mm
      real*8 lambda_km      ! wavelength km
      real*8 Track_len_km   ! Track length in km

****  Set default values.  User can then get defaults by typing /
      Mass       =   80.d0  ! Mass of object (kg)
      Cd         =  0.90d0  ! Drag coefficient of Bike
      Cr         = 0.007d0  ! Rolling (friction) coefficient of Bike
      Area       =  0.67d0  ! area of rider (m**2)
      P_rider    = 100.0d0  ! Nominal constant power for rider (watts)
      F_max      =  20.0d0  ! Maximum force the rider can supply (Newton)
      Terr       = 0.010d0  ! Error on hitting distance (m) (default 1 cm)
      Slope      = 0.001d0  ! Slope of track (radians)
      As         =   5.0d0  ! Sin amplitudes (m)
      Bs         =   0.0d0  ! Cos amplitudes (m)
      lambda     =    2.d3  ! Wavelenth of oscillations (m)
      Track_len  =   10.d3  ! Length (m)
      out_int    =  100.d0  ! Output interval (sec).


****  Get input from user:
      write(*,120)
 120  format(/,'Program Parameter Input. [Defaults are printed ',
     .         'use /<cr> to accept default')
      Terr_mm = terr*1000.d0
      lambda_km = lambda/1.0d3
      Track_len_km = Track_len/1.0d3

      write(*,140) Track_len_km, Terr_mm
 140  format('Length of track (km) and error (mm) [',F6.3,' km ',
     .       F5.1,' mm] ',$)
      read(*,*,iostat=ierr) Track_len_km, Terr_mm
      call report_error(ierr,'Reading track length and error')
      terr = terr_mm/1000.d0
      Track_len = Track_len_km*1000.d0

      write(*,160) Slope, As, Bs, Lambda_km
 160  format('Track Slope, Sin and Cos amplitudes (m) and ',
     .       'wavelenghth (km) [Defaults ',F5.3,2(F5.2,' m '),1x,
     .       F6.2,' km] ',$)
      read(*,*,iostat=ierr) Slope, As, Bs, Lambda_km
      call report_error(ierr,'Reading track slope and oscillations')

      write(*,180) Mass, Area, Cd, Cr
 180  format('Rider/Bike Mass (kg), Area (m**2), ',
     .       'Drag and rolling Coefficient ,',
     .       '[',F6.2,' kg, ',F6.3,' m^2, ', F6.2,' and ',
     .        F6.4,'] ',$)
      read(*,*,iostat=ierr) Mass, Area, Cd, Cr
      call report_error(ierr,'Reading Mass, Xarea, Cd and Cr')

      write(*,200) P_rider, F_max
 200  format('Rider Power (W) and max force (N) [',F6.2,' Watts,',
     .       F6.2,' N] ',$)
      read(*,*,iostat=ierr)  P_rider, F_max
      call report_error(ierr,'Reading rider power and max force')

      write(*,220) out_int
 220  format('Output interval, zero for none (default ',F8.2,' s) ',$)
      read(*,*,iostat=ierr) out_int
      call report_error(ierr,'Reading output interval')


      return
      end
             

CTITLE INT1d

      subroutine Int1d(step,int_time, Pos, Vel, Xpos )
      implicit none

*     Runge-Kutta intergration routine.

* Parameters need for program (Physical constants)
      include 'FBike.h'

* PASSED VARIABLES
      real*8 step        ! Integration step size (secs). 
      real*8 int_time    ! Integration time.  If this is zero initially
                         ! integrate on position, otherwise integrate on
                         ! on time.
      real*8 Pos, Vel, Xpos   ! position and velocity along track and Xposition

* LOCAL VARIABLES
      real*8 P, V, X     ! Intermediate position and velocities needed
      real*8 k1, k2, k3, k4   ! Coefficients needed for Runge Kutta integration

      real*8 accel       ! Function that return x acceleration in real part
                         ! and z-acceleration imaginary part

      real*8 time,T      ! Time into integration
      real*8 tpast       ! Time past the zero point for the last step.
      real*8 dist        ! Final distance traveled in X-direction
      real*8 ustep       ! Used step for integration.  As the object approaches the 
                         ! ground, we take smaller steps in the last interval.  
 
      real*8 AP1, AP2, AP3  ! Actual power supplied by rider at each 
                         ! point in the integration.  This is 
                         ! integrated to get energy used.
      real*8 Th1, Th2, Th3 ! Slopes at points in integration (angle theta) 

      logical done       ! Set true when the integration is complete based either
                         ! on position or flight time

      integer*4 n


***** Initialize position
      time = 0.d0
      tot_energy = 0.d0
      done = .false.
      ustep = step 
      if( step.eq.0 ) then
          print *,' Zero step '
          step = 0.05d0
          ustep = step 
      end if
      n = 0
      if( outT ) then
         write(*,110) 
 110     format('O*    Time          X_pos        S_pos     ',
     .          '           S_vel     Energy',/,
     .          'O*    (sec)          (m)          (m)      ',
     .          '           (m/s)     (Joules)') 
         write(*,160) 'O',time, Xpos, Pos, Vel, tot_energy
      end if

*     Itegrate until we get to the track_length
      do while ( .not.done ) 
         n = n + 1
         if( n.gt. 1d6 ) done = .true.   ! Put in to make sure program will stop 
                                         ! at some point

****     Compute the accelerations we need
         k1 = ustep*accel(time, Pos, Vel, AP1, XPos, th1 )

         P = Pos + ustep*Vel/2.d0 +ustep*k1/8.d0
         V = Vel + k1/2.d0
         X = Xpos + (ustep*Vel/2.d0 +ustep*k1/8.d0)*cos(th1)

         k2 = ustep*accel(time+ustep/2.d0, P, V, AP2, X, th2)
         P = Pos + ustep*V/2.d0 + ustep*k1/8.d0
         V = Vel + k2/2.d0 
         X = Xpos + (ustep*V/2.d0 + ustep*k1/8.d0)*cos(th2)

         k3 = ustep*accel(time+ustep/2.d0, P, V, AP2, X, th2 )
         P = Pos + ustep*Vel + ustep*k3/2.d0
         V = Vel + k3
         X = Xpos + (ustep*Vel + ustep*k3/2.d0)*cos(th2)

         k4 = ustep*accel(time+ustep, P, V, AP3,  X,th3)

****     Update the time, position and velocity
         T = time + ustep
         P = Pos + ustep*(Vel + (k1+k2+k3)/6.d0)
         V = Vel + (k1+2*k2+2*k3+k4)/6.d0
         X = Xpos + (ustep*(Vel + (k1+k2+k3)/6.d0))*cos(th2)

*****    Compute total energy used.  Use a 3-point Newton-Cotes Methods
*        (Also called Sumpson's rule)
         tot_energy = tot_energy + (ustep/2)*(AP1+4*AP2+AP3)/3.d0

****     See if we have passed the end of the track.  If we have then
*        take smaller steps.
         if( X-Track_len.gt.0 ) then
             tpast = (X-Track_len)/dble(Vel) 
             ustep = abs(tpast/2.d0)
             if( abs(X-Track_len).lt. terr/10 ) then
                 time = T
                 Pos = P
                 Vel = V
                 Xpos = X
                 done = .true.
                 if( outT ) then
                    write(*,160) 'O',time, Xpos, Pos, Vel, tot_energy
                 end if
             endif
         else
*            Continue with integration
             time = T
             Pos = P
             Vel = V
             Xpos = X
             if( outT ) then
                if( abs(T-nint(T/out_int)*out_int).le.1.d-3 ) then
                    write(*,160) 'O',time, Xpos, Pos, Vel, tot_energy
!                else
!                    write(*,160) 'T',time, Xpos, Pos, Vel, tot_energy
                endif
 160            format(a,1x,F10.3, 2F15.4, 1F15.4,1x, F12.2)
             end if
         end if

****     See if we have completed.  Based either on position
*        of time
         if( int_time.ne.0 ) then
*           Test on time should be = but to avoid rounding
*           error we test when is it within step/10.
            if( abs(time-int_time).lt.step/10 ) done =.true.
         end if        

      end do

****  Return the Distance traveled.  Correct for the overshoot i.e.,
*     the last Z-position is below the surface, so compute how many
*     seconds to get back to surface at last velocity and correct the
*     horizontal distance for this effect.
      tpast = Xpos/(Vel*cos(Th2))
c      Dist = realpart(Pos) - realpart(Vel)*tpast
      Dist = Xpos - Vel*cos(Th2)*tpast
      int_time = time

***** Thats all
      return
      end

CTITLE ACCEL

      real*8 function accel( time,  P, V, AP, X,Theta)
      implicit none

****  Routine to compute the acceleration of the body at position
*     P and with Velocity V. Time is passed into the routine but
*     ir is not needed for the forces considered here.  (In a more
*     general problem with mass wastage we may need time to compute
*     mass).

* Parameters need for program (Physical constants)
      include 'FBike.h'

* PASSED VARIABLES
      real*8    time     ! Integration time (not used in this version)
      real*8 P, V        ! Along track position and velocity
      real*8 X           ! X-coordinate
      real*8 AP          ! Actual power supplied by rider 
      real*8 theta       ! Surface slope

* LOCAL VARIABLES
      real*8 gacc, dacc, racc  ! Gravity along path, Drag and rolling accelerations
      real*8 facc        ! Rider force acceleration
      real*8 Vmag        ! Magnitude of velocity
      real*8 Rho_h       ! Density of air at our height
      real*8 F_mag       ! Magnitude of rider force (N)


***** Compute the accelations:
      theta = atan(Slope + 
     .             As*cos(2*pi*X/Lambda)*2*pi/Lambda - 
     .             Bs*sin(2*pi*X/Lambda)*2*pi/Lambda)

*     DRAG: Acts opposite to the motion vector (since wind is fixed
*     relative to motion direction)
      Vmag = abs(V)
      Rho_h = rho_air
      gacc = -g_0*sin(theta)
      dacc = -(Cd*Rho_h*V**2/2)/Mass*Area  ! Note: This is Vmag^2*V_unit_vector
      racc = -g_0*Cr*cos(theta)

*     Get the rider power
      F_mag = F_max
      if( Vmag.gt.0 ) then
         F_mag = min(P_rider/Vmag, F_max)
      endif

      facc = F_mag/Mass
      AP = F_mag*Vmag


****  Add the acceleration together
      accel = gacc + dacc + racc + facc 

***** Thats all 
      return
      end

CTITLE REPORT_ERROR

      subroutine report_error(ierr,mess)

*     Routine to report IOSTAT errors.  Initially developed
*     for 12.010 HW2 Problem 3.

* PASSED VARIABLES

      integer*4 ierr
      character*(*) mess

* LOCAL VARIABLES
* None
      
***** See if the IOSTAT error was non-zero
      if( ierr.ne.0 ) then
         write(*,120) ierr, mess
 120     format('IOSTAT Error ',i4,' occurred ',a)
         stop 'HW2_3: IO Error in program'
      end if

      return
      end
      
      
 


         

  

          


















  
