! Kinds for data types
module Types
implicit none
private
public sp, dp, i1, i2, biggest_i1, biggest_i2

! Reals
integer, parameter :: sp = selected_real_kind(p = 6, r = 37) ! Single precision
integer, parameter :: dp = selected_real_kind(p = 15, r = 307) ! Double precision

! Integers
integer, parameter :: i1 = selected_int_kind(2) ! 1 byte
integer, parameter :: i2 = selected_int_kind(4) ! 2 bytes

!The largest number for given precision
integer(i1),parameter   ::  biggest_i1  = huge(1_i1)
integer(i2),parameter   ::  biggest_i2  = huge(1_i2)

end module Types
