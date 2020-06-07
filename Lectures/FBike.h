*     This is the include file for the Bike program.
*     The file includes the parameters needed for the
*     program.

* PARAMETERS: These define the constants in the program that
*     the user would not change

      real*8 Pi    ! Pi for converting degs to rads
      real*8 rad_to_deg  ! Conversion from radians to degrees
      real*8 deg_to_rad  ! Conversion from degrees to radians
      real*8 g_0   ! Value of gravity at surface (m/s**2)
      real*8 rho_air  ! Density of air at surface (kg/m**3)
      real*8 cal_to_joule ! 1 calori = cal_to_joule joules 
*                          (food Caloris are 1000*calories)

      parameter ( Pi    = 3.1415926535897932D0 )
      parameter ( rad_to_deg = 180.d0/Pi       )
      parameter ( deg_to_rad = Pi/180.d0       )

      parameter ( g_0    =  9.8d0      )   ! m/s**2
      parameter ( rho_air = 1.226d0    )   ! kg/m**3
      parameter ( cal_to_joule =  4.1868d0 )

***********************************************************************
* COMMON BLOCK FOR "constants" in problem

      real*8 Mass        ! Mass of object (kg)
      real*8 Cd          ! Drag coefficient of Bike
      real*8 Cr          ! Rolling (friction) coefficient of Bike
      real*8 Area        ! area of rider (m**2)
      real*8 P_curr      ! Current power supplied by rider (watts)
      real*8 P_rider     ! Nominal constant power for rider (watts)
      real*8 F_max       ! Maximum force the rider can supply (Newton)
      real*8 tot_energy  ! Total energy supplied by rider (Joules)
      real*8 Terr        ! Error on hitting distance (m)
      real*8 out_int     ! Output interval (sec)

*     Track properities
      real*8 Slope       ! Slope of track (radians)
      real*8 As, Bs      ! Sin and Cos amplitudes (m)
      real*8 lambda      ! Wavelenth of oscillations (m)
      real*8 Track_len   ! Horizontal length of track (m)

      common / Object / Mass , Cd ,Cr,Area,P_curr,P_rider ,F_max,
     .                  tot_energy, Terr, out_int, 
     .                  Slope, As, Bs, lambda, Track_len       

      logical outT       ! Logical set true to output the trajectory
  
      common / control / outT  








