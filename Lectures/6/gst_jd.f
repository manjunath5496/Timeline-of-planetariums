CTITLE GST_JD
 
      SUBROUTINE GST_JD(jd, GST)
C
C     T.HERRING                                 4 MARCH 1981
C
C     SUBROUTINE TO COMPUTE GST (rads) GIVEN Full julian date
C
C# LAST COMPC'ED  810311:14:23                  #
C
 
      include 'const_param.h'
C
 
      real*8 fract, gst
 
*       diurnv       - Diurnal sidereal velocity
*       cent         - Number of centuries since j2000.
*       Jd_0hr       - Julian date a zero hours UT
 
      real*8 jd, t, t_0hr, gstd, diurnv, cent, jd_0hr
 
*     Remove the fractional part of the julian date
*     Get jd at 0:00 UT
      jd_0hr = aint(jd-0.5d0) + 0.5d0
*                         ! Days since J2000.0
      t_0hr = jd_0hr - dj2000
*                         ! 0:00 hrs at start of day
      cent = t_0hr / 36525.d0
 
*                         ! Fraction of a day
      fract = jd - jd_0hr       
 
      diurnv = ( 1.002737909350795d0 + 5.9006d-11*cent
     .                               - 5.9d-15*cent**2 )
C
C**** COMPUTE GST
      gstd = ( 24110.54841d0  + 8640184.812866d0*cent
     .                        + 0.093104d0*cent**2
*                                                            ! Cycles
     .                        - 6.2d-6*cent**3 ) /86400.d0
 
      gstd = mod(gstd,1.d0)
 
*                                             ! Rads
      gst = (gstd + diurnv*fract) * 2*pi
 
***** Thats all
      return
      end
 
