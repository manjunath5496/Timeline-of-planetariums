      program poly_area

*     Program to compute the area of an arbitrarily shaped
*     Polygon but breaking the polygon into triangles.

* MOD TAH: Version 2:
*     Added a check of the sign of the darea calculation.
*     If the sign changes as we compute each triangle then
*     if means the figure has not been input correctly.

* PARAMETERS

      integer*4 max_nodes  ! Maximum number of nodes in the polygon
                           ! that the user can input.  

      parameter ( max_nodes = 1000 )

* MAIN PROGRAM VARIABLES

      integer*4 num_nodes ! Number of nodes input by the user.  List
                          ! of node coordinates is read until end-of-
                          ! file (EOF or ^D) is reached.
      integer*4 sign_darea ! Sign of the area of the triangle.  If
                          ! this changes then figure is not ordered
                          ! correctly.

      real*8 nodes_xy(2,max_nodes) ! XY coordinates of nodes of the
                          ! of polygon
      real*8 triangle_vec(2,2)     ! Two vectors that make up the 
                          ! current triangle.  Lead index is over
                          ! XY and the second index is over side
                          ! 1 and 2.
      real*8 area, darea  ! Total area and increment on area for 
                          ! each triangle.  These can be positive or
                          ! negative depending whether nodes are
                          ! entered clockwise or anti-clockwise.
                          ! Sign is fixed in output routine.

      character*8 units   ! Units of the coordinates.  Used only for
                          ! output.

* Miscellaneous variables that are needed
      integer*4 i         ! Counter for looping over the nodes


***** START PROGRAM.
*     Tell user what this program does
      write(*,110) 
 110  format(/,' POLY_AREA: Program to compute the area of a',
     .         ' plane polygon')

*     Now get the polygon node coordinates
      call read_nodes(num_nodes, nodes_xy, units, max_nodes)

*     Make sure we have enough nodes to from a figure.
      if( num_nodes.le.2 ) then
          write(*,130) num_nodes
 130      format('**ERROR** Only ',i2,' nodes entered.  This is',
     .           ' not enough to form figure')
*         Some programmers considering putting "stops" inside
*         routines a bad practice, and that in this case, I 
*         should execute the remainder of the program in an
*         "else" structure.  I feel that if the program has reached
*         a dead-end, it should stop to avoid the problem that with
*         later modifications, it may continue to run.
          stop 'Insufficient number of nodes'
      end if

*     We have enough nodes, now start to loop over the triangles
*     in the figure computing the incremental area and summing to
*     get total.  The order here is that the first node will be
*     apex of all triangles, and in each loop we form the triangle
*     of apex-node_i and apex-node_i-1.  (Could have started at
*     2 and gone to num_nodes-1).
*     Initialize the total area to 0 before starting
      area = 0.0d0
      do i = 3, num_nodes

*        Form the two vectors that make up the triangle
         call form_triangle(i, nodes_xy, triangle_vec, num_nodes)

*        Now compute the increment on the area
         call triangle_darea(triangle_vec, darea)

* MOD TAH Version 2: If this is first triangle set the sign, on
*        subsequent triangles check to see that it remains the
*        same
         call check_dir(i, sign_darea, darea)
    
*        Increment into total area
         area = area + darea
      end do

*     We are now complete, write out the results
      call output_area(num_nodes, area, nodes_xy, units)

****  We are finished
      end

CTITLE READ_NODES

      subroutine read_nodes(num_nodes, nodes_xy, units, max_nodes)

*     Routine to read in the coordinate of the nodes.  Values
*     are read until End-of-file or too many nodes are entered.


* PASSED VARIABLES
* Input values:
      integer*4 max_nodes ! Maximum number of nodes allowed (defined
                          ! in main program)

* Returned values
      integer*4 num_nodes ! Number of nodes input by the user.  List
                          ! of node coordinates is read until end-of-
                          ! file (EOF or ^D) is reached.

      real*8 nodes_xy(2,max_nodes) ! XY coordinates of nodes of the
                          ! of polygon

      character*(*) units ! Units of the coordinates.  Used only for
                          ! output.

* LOCAL VARIABLES
* Miscellaneous variables that are needed
      integer*4 ierr      ! IOSTAT error returned from reads and
                          ! writes.
      real*8 input_xy(2)  ! User input values of X and Y.  If
                          ! values are OK, they are saved in nodes_xy

***** Start: Tell user what they need to enter.  Since we will end
*     list with EOF, the list must be last things entered.
      write(*,110)  
 110  format(' What are the units of the coordinates? ')
      read(*,'(a)',iostat=ierr) units
*     Report any error on read.
      if( ierr.ne.0 ) then
          write(*,120) ierr, units
 120      format('**WARNING** IOSTAT error ',i5,' occurred',
     .           ' reading units.  Recorded units are ',a,/,
     .           ' Area will still be calculated')
      end if

* MOD TAH Version 2.  Change message here to say that warning
*     is printed if direction changed.  Old code has been
*     commented out.
C     write(*,200) 
C200  format(' Input the coordinates of the nodes of the polygon',
C    .       ' in X, Y order, one pair per line, free format',/,
C    .       ' NOTE: No check is made on shape of figure and nodes',
C    .       ' should be entered moving around the figure.',/, 
C    .       ' Use ^D (control-D or EOF) to end input',/,
C    .       '      X     Y  ')
      write(*,200) 
 200  format(' Input the coordinates of the nodes of the polygon',
     .       ' in X, Y order, one pair per line, free format',/,
     .       ' NOTE: Warning printed if direction around polygon',
     .       ' changes during area calculation',/, 
     .       ' Use ^D (control-D or EOF) to end input',/,
     .       '      X     Y  ')


****  Initialize the number of nodes and start reading until an
*     error occurrs (EOF will return ierr=-1 and this is the
*     expected end)
      num_nodes = 0
      ierr = 0         ! Set the error variable so that we enter the
                       ! do while loop.
      do while ( ierr.eq.0 )

*        Read the input coordinates and see if EOF is reached.

         read(*,*,iostat=ierr) input_xy

*        If no error occurred in read, save the coordinates of the
*        node, provided we have not reached maximum allowed.
         if ( ierr.eq.0 ) then   ! No read error.

****        Check to see if the number of nodes is too large.
*           Increment the number of nodes and make sure not too large
*           (i.e., bigger than max_nodes). 

            if ( num_nodes+1.gt.max_nodes ) then
****           Too many nodes are about to be entered.  We could
*              stop at this point or compute using the nodes we
*              already have. We will do the later so that user
*              does not need to enter and can complete the nodes
*              with another program run.
               write(*,220) max_nodes
 220           format('**ERROR** Attempt to input ',i5,' nodes',
     .                ' which exceeds maximum allowed.',/,
     .                ' Computing area with nodes entered.  Run',
     .                ' program again with additional nodes and',
     .                ' sum results')
               ierr = -2   ! Set error to show an error occurred.
                           ! This forces use out of reading loop.

            else           ! Enough space to save
                num_nodes = num_nodes + 1
                nodes_xy(1,num_nodes) = input_xy(1)
                nodes_xy(2,num_nodes) = input_xy(2)
            end if

*        Some error occurred on read.  If -1 (EOF) or -2 (to many
*        entries (already reported) then OK, and
*        we just continue.  If some other error, then report
*        problem and use just the current nodes.
         else if ( ierr.ne. -1 .and. ierr.ne.-2 ) then
            write(*,250) ierr, num_nodes+1
 250        format('**ERROR** IOSTAT error ',i5,' occurred reading',
     .             ' input node # ',i5,' coordinates.',/,
     .             ' Truncating list at this point and computing',
     .             ' area')
         end if
      end do

****  Finally, tell user how nodes were entered
      write(*,320) num_nodes
 320  format(i5,' Node coordinates have been entered.')


****  That's all
      return
      end

CTITLE FORM_TRIANGLES

      subroutine form_triangle(n, nodes_xy, triangle_vec,
     .                         num_nodes)

*     Routine form the two vectors that make up the triangle
*     from the node coordinates.
*     This routine contains a possible stop if n is greater
*     than the number of nodes (num_nodes)  
      

* PASSED VARIABLES
* Input values:
      integer*4 num_nodes ! Maximum number of nodes allowed (defined
                          ! in main program)
      integer*4 n         ! Node number of second side of triangle
                          ! triangle will be formed with 1->(n-1) and
                          ! 1->n 

      real*8 nodes_xy(2,num_nodes) ! XY coordinates of nodes of the
                           ! of polygon

* Returned values
      real*8 triangle_vec(2,2)     ! Two vectors that make up the 
                          ! current triangle.  Lead index is over
                          ! XY and the second index is over side
                          ! 1 and 2.

* LOCAL VARIABLES
      integer*4 j         ! Variable for looping over X and Y components

****  First check that we are not exceeding the total number
*     of nodes.  This should not happen given way routine is 
*     called but in some future use it might happen
      if( n.gt.num_nodes) then ! Something is wrong: requested
                          ! node out of range
         write(*,120) n, num_nodes
 120     format(/,'**DISASTER** Triangle requested with node number',
     .            i5,' but only ',i5,' nodes were input',/,
     .            ' Program terminating in form_triangles')
*        See discussion in main program about internal stops.
         stop 'Node number too large in form_triangles'
      end if

****  OK, Node number is OK, form the vectors from the apex to
*     node n and n-1
*     Loop over the XY components
      do j = 1, 2
         triangle_vec(j,1) = nodes_xy(j,n-1)-nodes_xy(j,1)
         triangle_vec(j,2) = nodes_xy(j,n  )-nodes_xy(j,1) 
      end do

****  Thats all
      return
      end

CTITLE TRIANGLE_DAREA

      subroutine triangle_darea(triangle_vec, darea)
       
*     Routine to compute the area of the triangle formed
*     by the two vectors in triangle_vec.  A cross product
*     calculation is used.  Since the vectors are 2-d, the
*     cross product will have only a Z-component and so this
*     is the only component we compute.

* PASSED VARIABLES
* Input values:
      real*8 triangle_vec(2,2)     ! Two vectors that make up the 
                          ! current triangle.  Lead index is over
                          ! XY and the second index is over side
                          ! 1 and 2.
* Returned values
      real*8 darea        ! Area of triangle.


****  Form the cross product Z-component and divide by two since
*     cross product a x b = |a||b| sin(theta) in direction normal
*     to the plane of vectors a and b.  theta is the angle between
*     vectors.
*     Note: Sign will depend on if we rotate clockwise or
*     anti-clockwise between vector.  We treat this at the end
*     in the output routine where we use the absolute value.

      darea = (triangle_vec(1,1)*triangle_vec(2,2) -
     .         triangle_vec(2,1)*triangle_vec(1,2))/2.d0 

      return
      end

CTITLE OUTPUT_AREA

      subroutine output_area(num_nodes, area, nodes_xy, units)
        
*     Routine to output the final area.  Here we take the absolute
*     value in case the figure is entered anti-clockwise.

* PASSED VARIABLES
* Input values:
      integer*4 num_nodes ! Number of nodes input by the user.  List
                          ! of node coordinates is read until end-of-
                          ! file (EOF or ^D) is reached.

      real*8 area         ! Total area.  This can be positive or
                          ! negative depending whether nodes are
                          ! entered clockwise or anti-clockwise.
                          ! Sign is fixed in output routine.
      real*8 nodes_xy(2,num_nodes) ! XY coordinates of nodes of the
                           ! of polygon

      character*(*) units ! Units of the coordinates.  Used only for
                          ! output.

* LOCAL VARIABLES
      integer*4 ierr      ! IOSTAT error returned from reads and
                          ! writes.
      integer*4 i, j      ! Loop variables for list nodes.

****  List the nodes we have used.
      write(*,120,iostat=ierr) num_nodes, units
 120  format(/,' POLY_AREA:  The area enclosed by the ',i5,
     .         ' nodes in the following polygon:',/,
     .         '    #          X            Y    ',a)

      do i = 1, num_nodes
         write(*,140) i, (nodes_xy(j,i),j=1,2)
*        Should be careful with format since numbers could be
*        too large or small for the area.
 140     format(i5,1x,2(F12.3,1x))
      end do

      write(*,160,iostat=ierr) abs(area), units
 160  format(' Total area is ',f20.6,' square ',a)

      if( ierr.ne.0 ) then
          write(*,210) ierr
 210      format('**WARNING** IOSTAT error ',i5,' occurred during',
     .           ' output of results')
      end if

****  Thats all
      return
      end

CTITLE CHECK_DIR

      subroutine check_dir(n, sign_darea, darea)

*     Routine to check and warn user if the sign of the 
*     triangle area changes.  This means that the direction
*     around the figure has changed.

* PASSED VARIABLES
* Input variables
      integer*4 n    ! Node number of second vector in triangle
      integer*4 sign_darea ! Sign of the area of the first triangle
      
      real*8 darea   ! Area increment of the triangle formed with
                     ! nodes n and n-1.

****  See if first triangle.  If it is then set the sign.
*     For other triangles make sure the same sign.
      if( n.eq.3 ) then
*         First triangle.  Set the sign of the area. NOTE:
*         small problem with this code if darea=0 (routine
*         will set to +ve sign.
          if( darea.lt.0.d0 ) then
             sign_darea = -1
          else
             sign_darea = +1
          endif
      else
*         See if sign has changed.  By multiplying the values
*         we get a positive number of sign has not changed.
          if( sign_darea*darea.lt.0 ) then
              write(*,210) n
 210          format('**WARNING** Direction around figure ',
     .               ' changes at node number ',i4)
          end if
      end if

****  Thats all
      return
      end


