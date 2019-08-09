! Kinds for data types
module Types
implicit none
private
public sp, dp, i1, i2

! Reals
integer, parameter :: sp = selected_real_kind(p = 6, r = 37) ! Single precision
integer, parameter :: dp = selected_real_kind(p = 15, r = 307) ! Double precision

! Integers
integer, parameter :: i1 = selected_int_kind(2) ! 1 byte
integer, parameter :: i2 = selected_int_kind(4) ! 2 bytes

end module Types
