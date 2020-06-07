CTITLE etide_sub
 
 
      subroutine etide_sub( epoch, site_pos, dXYZ_tide )
 
*     Routine to compute the solid Earth tide.  Based on
*     Formualtion in DSR thesis with extension to the number of
*     coefficients.
 
 
      include 'const_param.h'
 
* PASSED Variables
 
* epoch         - Epoch (JD or MJD)
* site_pos(3) - Site position (XYZ)
* dXYZ_tide(3) - Tidal contribution to site position (m)
 
 
      real*8 epoch, site_pos(3), dXYZ_tide(3)
 
* LOCAL VARIABLES
 
*    dn, de, dh   - Tide displacements in North, East and Height
*    dNEU_tide(3)  - Tides displacements as a vector
*    latr, longr - Latitude and longitude
*    U0, Udlat, Udlong  - Potential (in mm) at point and displaced
*                 - in lat and long
*    dUdlat, dUdLong    - Deriviatives in lat and long
*    loveh, lovel - Love numbers
*    jd           - Julian date
 
 
      real*8 loc_coord(3), rot_matrix(3,3),
     .    dn, de, dh, dNEU_tide(3), latr, longr, U0, Udlat, Udlong,
     .    dUdlat, dUdLong, loveh, lovel, jd
 
      DATA LOVEH/.6090d0/, LOVEL/.0852d0/
 
****  See type of date passed
      if( epoch.gt.2000000.d0 ) then
          jd = epoch
      else
          jd = epoch + 2400000.5d0 - 94554.d0 + 142350.d0
      end if 
****  Get the lat and long of the site
      call XYZ_to_GEOD( rot_matrix, site_pos, loc_coord )
 
      latr = pi/2 - loc_coord(1)
      longr = loc_coord(2)
      call tide_un(jd,  latr, longr, U0 )
 
*     Now do the derivatives
      call tide_un(jd,  latr+1.d-6, longr, Udlat)
      dudlat = (Udlat-U0)/1.d-6
 
      call tide_un(jd,  latr, longr+1.d-6, Udlong)
      dudlong = (Udlong-U0)/1.d-6
 
*     Now compute the displacements
      dh = loveh*U0
      dn = lovel*dUdlat
      de = lovel*dUdlong

*     Save and convert values from mm to meters
      dNEU_tide(1) = dn/1000.d0
      dNEU_tide(2) = de/1000.d0
      dNEU_tide(3) = dh/1000.d0
 
*     Now rotate to XYZ didplacements
      call rotate_geod( dNEU_tide, dXYZ_tide, 'NEU', 'XYZ',
     .        site_pos, loc_coord, rot_matrix)

      write(*,300) (epoch-int(epoch))*86400.d0, dNEU_tide,
     .              dXYZ_tide, jd
 300  format('TIDE:',f16.6,6F12.5,1x,F15.6 )
 
****  Thats all
      end
 
CTITLE tide_un
 
      subroutine tide_un(jd, latr, longr, U)
 
*     Routine to compute the tidal potential in mm.
 
      include 'const_param.h'
 
*         num_lp, num_di, num_se   - Number of terms in
*                    - Long period, diurnal and semidiurnal
*                    - series
 
      integer*4 num_lp, num_di, num_se
 
      parameter ( num_lp = 13 )
      parameter ( num_di = 18 )
      parameter ( num_se = 12 )
 
 
*      latr, longr   - Lat and Long in rads
*      jd            - JD for determination
*      U             - Potenital (mm)
*      lm, ls, w, gst, tc   - Long of moon, of sun,
*                    - Argument of lunar perigee,
*                    - Greenwich sidreal time, and
*                    - time in centuries since 1900.
*      lha, lst      - Local hour angle of moon and sun
 
*      fund_arg(6)   - Browns fundamental arguments
*      dood_arg(6)   - Doodson's arguments in following
*                    - order:
*                    - tau - Time angle in lunar days
*                    - s   - Mean longitude of Moon
*                    - h   - Mean longitude of Sun
*                    - p   - Long of Moon's perigee
*                    - N'  - Negative of long of Moon's Node
*                    - p1  - Longitude of Sun's Perigee.
*      arg           - Argument of tide (rads)
*      A_lp, A_di, A_se   - Long period, diurnal and semi-diurnal
*                    - ampltituds (not quite potential since stills
*                    - need to be multiplied 268.8 mm.
 
      real*8 latr, longr, jd, U, lm, ls, w, gst, tc, lha, lst,
     .    fund_arg(6), dood_arg(6), arg, A_lp, A_di, A_se
 
*         lp_tides(7, num_lp)   - Long period Doodson arguments
*                    - and amplitude by 1d-5
*         di_tides(7, num_di)   - Diurnal args and amp
*         se_tides(7, num_se)   - Semidiurnal args and amp
*         i,j        - Loop counters
 
 
      integer*4 lp_tides(7, num_lp), di_tides(7, num_di),
     .    se_tides(7, num_se), i,j
 
      data lp_tides /  0,  0,  0,  0,  0,  0, 73807,
     .                 0,  0,  0,  0,  1,  0, -6556,
     .                 0,  0,  1,  0,  0, -1,  1156,
     .                 0,  0,  2,  0,  0,  0,  7266,
     .                 0,  1, -2,  1,  0,  0,  1579,
     .                 0,  1,  0, -1,  0,  0,  8255,
     .                 0,  2, -2,  0,  0,  0,  1366,
     .                 0,  2,  0, -2,  0,  0,   676,
     .                 0,  2,  0,  0,  0,  0, 15645,
     .                 0,  2,  0,  0,  1,  0,  6482,
     .                 0,  2,  0,  0,  2,  0,   605,
     .                 0,  3,  0, -1,  0,  0,  2995,
     .                 0,  3,  0, -1,  1,  0,  1241  /
 
      data di_tides /  1, -3,  0,  2,  0,  0,   954,
     .                 1, -3,  2,  0,  0,  0,  1151,
     .                 1, -2,  0,  1, -1,  0,  1359,
     .                 1, -2,  0,  1,  0,  0,  7214,
     .                 1, -2,  2, -1,  0,  0,  1370,
     .                 1, -1,  0,  0, -1,  0,  7105,
     .                 1, -1,  0,  0,  0,  0, 37690,
     .                 1,  0,  0, -1,  0,  0, -1066,
     .                 1,  0,  0,  1,  0,  0, -2963,
     .                 1,  1, -3,  0,  0,  1,  1028,
     .                 1,  1, -2,  0,  0,  0, 17546,
     .                 1,  1,  0,  0, -1,  0,  1050,
     .                 1,  1,  0,  0,  0,  0,-53009,
     .                 1,  1,  0,  0,  1,  0, -7186,
     .                 1,  1,  2,  0,  0,  0,  -755,
     .                 1,  2,  0, -1,  0,  0, -2963,
     .                 1,  3,  0,  0,  0,  0, -1623,
     .                 1,  3,  0,  0,  1,  0, -1039 /
 
      data se_tides /  2, -3,  2,  1,  0,  0,   669,
     .                 2, -2,  0,  2,  0,  0,  2298,
     .                 2, -2,  2,  0,  0,  0,  2774,
     .                 2, -1,  0,  1, -1,  0,  -649,
     .                 2, -1,  0,  1,  0,  0, 17380,
     .                 2, -1,  2, -1,  0,  0,  3301,
     .                 2,  0,  0,  0, -1,  0, -3390,
     .                 2,  0,  0,  0,  0,  0, 90805,
     .                 2,  1,  0, -1,  0,  0, -2567,
     .                 2,  2, -2,  0,  0,  0, 42248,
     .                 2,  2,  0,  0,  0,  0, 11495,
     .                 2,  2,  0,  0,  1,  0,  3424 /
 
      call gst_jd( jd, gst )
 
      tc = (jd - 2415020.5d0)/ 36525.d0
 
      lm =  4.719967d0 + 8399.709d0*tc
      ls =  4.881628d0 + 628.3319d0*tc
      w  =  5.835152d0 + 71.01803d0*tc
 
      lha = gst - lm + longr
      lst = gst - ls + longr
 
***** Get the fundamental arguments at this time and then
*     convert to Doodson argument
      call fund_angles( jd, fund_arg )
 
*     Now computed Doodson's angles: NOTE:
*     fund_arg(6) is gst+pi (so we don't need to add pi below)
      dood_arg(2) = fund_arg(3) + fund_arg(5)
      dood_arg(1) = fund_arg(6) - dood_arg(2) + longr
      dood_arg(3) = dood_arg(2) - fund_arg(4)
      dood_arg(4) = dood_arg(2) - fund_arg(1)
      dood_arg(5) = -fund_arg(5)
      dood_arg(6) = dood_arg(2) - fund_arg(4) - fund_arg(2)
 
****  Now compute the potential
*     Start with Long Period
      A_lp = 0
      do i = 1, num_lp
         arg = 0
         do j = 1,6
            arg = arg + lp_tides(j,i)*dood_arg(j)
         end do
         A_lp = A_lp + lp_tides(7,i)*1.d-5*cos(arg)
      end do
 
*     Do the diurnal terms
      A_di = 0.0d0
      do i = 1, num_di
         arg = -pi/2
         do j = 1,6
            arg = arg + di_tides(j,i)*dood_arg(j)
         end do
         A_di = A_di + di_tides(7,i)*1.d-5*cos(arg)
      end do
 
*     Do the Semidiurnal tides.
      A_se = 0.0d0
      do i = 1, num_se
         arg =  0
         do j = 1,6
            arg = arg + se_tides(j,i)*dood_arg(j)
         end do
         A_se = A_se + se_tides(7,i)*1.d-5*cos(arg)
      end do
 
****  Now we can add up all the peices
      U = 268.8d0*( cos(latr)**2*A_se +
     .              sin(2*latr) *A_di -
     .             (1.5d0*sin(latr)**2-0.5d0)*A_lp )
 
****  Thats all
      return
      end

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
 

