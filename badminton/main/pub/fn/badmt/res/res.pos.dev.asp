<% 
'   ===============================================================================     
'    Purpose : badminton ama play position Data 
'    Make    : 2019.03.11
'    Author  :                                                       By Aramdry
'   ===============================================================================    


'   Random Position Game     - 처음부터 토너먼트 
'   4강 ~ 256 : seed , bye
'   
'   Seed는 제일 마지막 값을 가지고 체크 
'   Bye는 갯수에 따라서 다름
'   pos은 Randoom 
'   
'   =====================================
'   Position Game  - 리그에서 토너먼트로 
'   4강 ~ 32강 
'   pos 은 고정 
'   
'   seed : 1위 ~ 순차적으로 
'   bye  : 제일 마지막 ~ 순차적으로 
%>



<% 
    Dim gDevAryR4Seed2, gDevAryR8Seed2, gDevAryR16Seed4, gDevAryR32Seed8, gDevAryR64Seed16, gDevAryR128Seed16, gDevAryR256Seed16

'   ===============================================================================     
'    Round4 : Seed Max 2
'   ===============================================================================    
    ReDim gDevAryR4Seed2(2)

    gDevAryR4Seed2    = (1)
    gDevAryR4Seed2    = (4)

'   ===============================================================================     
'    Round8 : Seed Max 2
'   ===============================================================================    
    ReDim gDevAryR8Seed2(2)

    gDevAryR8Seed2    = (1)
    gDevAryR8Seed2    = (8)
'   ===============================================================================     
'    Round16 : Seed Max 4
'   ===============================================================================    
    ReDim gDevAryR16Seed4(4)

    gDevAryR16Seed4    = (1)
    gDevAryR16Seed4    = (16)
    gDevAryR16Seed4    = (5)
    gDevAryR16Seed4    = (12)
'   ===============================================================================     
'    Round32 : Seed Max 8
'   ===============================================================================  
    ReDim gDevAryR32Seed8(8)  

    gDevAryR32Seed8    = (1)
    gDevAryR32Seed8    = (32)
    gDevAryR32Seed8    = (9)
    gDevAryR32Seed8    = (24)
    gDevAryR32Seed8    = (5)
    gDevAryR32Seed8    = (13)
    gDevAryR32Seed8    = (20)
    gDevAryR32Seed8    = (28)

'   ===============================================================================     
'    Round64 : Seed Max 16
'   ===============================================================================    
    ReDim gDevAryR64Seed16(16)

    gDevAryR64Seed16   = (1)
    gDevAryR64Seed16   = (64)
    gDevAryR64Seed16   = (17)
    gDevAryR64Seed16   = (48)
    gDevAryR64Seed16   = (9)
    gDevAryR64Seed16   = (25)
    gDevAryR64Seed16   = (40)
    gDevAryR64Seed16   = (56)
    gDevAryR64Seed16   = (5)
    gDevAryR64Seed16   = (13)
    gDevAryR64Seed16   = (21)
    gDevAryR64Seed16   = (29)
    gDevAryR64Seed16   = (36)
    gDevAryR64Seed16   = (44)
    gDevAryR64Seed16   = (52)
    gDevAryR64Seed16   = (60)

'   ===============================================================================     
'    Round128 : Seed Max 16
'   ===============================================================================    
    ReDim gDevAryR128Seed16(16)

    gDevAryR128Seed16      = (1)
    gDevAryR128Seed16      = (128)
    gDevAryR128Seed16      = (33)
    gDevAryR128Seed16      = (96)
    gDevAryR128Seed16      = (17)
    gDevAryR128Seed16      = (49)
    gDevAryR128Seed16      = (80)
    gDevAryR128Seed16      = (112)
    gDevAryR128Seed16      = (9)
    gDevAryR128Seed16      = (25)
    gDevAryR128Seed16      = (41)
    gDevAryR128Seed16      = (57)
    gDevAryR128Seed16      = (72)
    gDevAryR128Seed16      = (88)
    gDevAryR128Seed16      = (104)
    gDevAryR128Seed16      = (120)

'   ===============================================================================     
'    Round256 : Seed Max 16
'   ===============================================================================    
    ReDim gDevAryR256Seed16(16)

    gDevAryR256Seed16      = (1)
    gDevAryR256Seed16      = (256)
    gDevAryR256Seed16      = (65)
    gDevAryR256Seed16      = (192)
    gDevAryR256Seed16      = (33)
    gDevAryR256Seed16      = (97)
    gDevAryR256Seed16      = (160)
    gDevAryR256Seed16      = (224)
    gDevAryR256Seed16      = (17)
    gDevAryR256Seed16      = (49)
    gDevAryR256Seed16      = (81)
    gDevAryR256Seed16      = (113)
    gDevAryR256Seed16      = (144)
    gDevAryR256Seed16      = (176)
    gDevAryR256Seed16      = (208)
    gDevAryR256Seed16      = (240)
%>

<% 
    Dim gDevAryRound4, gDevAryRound8, gDevAryRound16, gDevAryRound32, gDevAryRound64, gDevAryRound128, gDevAryRound256
'   ===============================================================================     
'    Round : 4
'   ===============================================================================    
    ReDim gDevAryRound4(4)

    gDevAryRound4(0) = 1
    gDevAryRound4(1) = 4
    gDevAryRound4(2) = 2
    gDevAryRound4(3) = 3

'   ===============================================================================     
'    Round : 4
'   ===============================================================================    
    ReDim gDevAryRound8(8)
    gDevAryRound8(0) = 1
    gDevAryRound8(1) = 8
    gDevAryRound8(2) = 4
    gDevAryRound8(3) = 5
    gDevAryRound8(4) = 2
    gDevAryRound8(5) = 7
    gDevAryRound8(6) = 3
    gDevAryRound8(7) = 6

'   ===============================================================================     
'    Round : 4
'   ===============================================================================    
    ReDim gDevAryRound16(16)
    gDevAryRound16(0) = 1
    gDevAryRound16(1) = 16
    gDevAryRound16(2) = 8
    gDevAryRound16(3) = 9
    gDevAryRound16(4) = 4
    gDevAryRound16(5) = 13
    gDevAryRound16(6) = 5
    gDevAryRound16(7) = 12
    gDevAryRound16(8) = 2
    gDevAryRound16(9) = 15
    gDevAryRound16(10) = 7
    gDevAryRound16(11) = 10
    gDevAryRound16(12) = 3
    gDevAryRound16(13) = 14
    gDevAryRound16(14) = 6
    gDevAryRound16(15) = 11

'   ===============================================================================     
'    Round : 4
'   ===============================================================================    
    ReDim gDevAryRound32(32)
    gDevAryRound32(0) = 1
    gDevAryRound32(1) = 32
    gDevAryRound32(2) = 16
    gDevAryRound32(3) = 17
    gDevAryRound32(4) = 8
    gDevAryRound32(5) = 25
    gDevAryRound32(6) = 9
    gDevAryRound32(7) = 24
    gDevAryRound32(8) = 4
    gDevAryRound32(9) = 29
    gDevAryRound32(10) = 13
    gDevAryRound32(11) = 20
    gDevAryRound32(12) = 5
    gDevAryRound32(13) = 28
    gDevAryRound32(14) = 12
    gDevAryRound32(15) = 21
    gDevAryRound32(16) = 2
    gDevAryRound32(17) = 31
    gDevAryRound32(18) = 15
    gDevAryRound32(19) = 18
    gDevAryRound32(20) = 7
    gDevAryRound32(21) = 26
    gDevAryRound32(22) = 10
    gDevAryRound32(23) = 23
    gDevAryRound32(24) = 3
    gDevAryRound32(25) = 30
    gDevAryRound32(26) = 14
    gDevAryRound32(27) = 19
    gDevAryRound32(28) = 6
    gDevAryRound32(29) = 27
    gDevAryRound32(30) = 11
    gDevAryRound32(31) = 22

'   ===============================================================================     
'    Round : 64
'   ===============================================================================    
    ReDim gDevAryRound64(64)
    gDevAryRound64(0)   = 1
    gDevAryRound64(1)   = 64
    gDevAryRound64(2)   = 17
    gDevAryRound64(3)   = 48
    gDevAryRound64(4)   = 9
    gDevAryRound64(5)   = 56
    gDevAryRound64(6)   = 25
    gDevAryRound64(7)   = 40
    gDevAryRound64(8)   = 8
    gDevAryRound64(9)   = 57
    gDevAryRound64(10)  = 24
    gDevAryRound64(11)  = 41
    gDevAryRound64(12)  = 16
    gDevAryRound64(13)  = 49
    gDevAryRound64(14)  = 32
    gDevAryRound64(15)  = 33
    gDevAryRound64(16)  = 4
    gDevAryRound64(17)  = 61
    gDevAryRound64(18)  = 20
    gDevAryRound64(19)  = 45
    gDevAryRound64(20)  = 12
    gDevAryRound64(21)  = 53
    gDevAryRound64(22)  = 28
    gDevAryRound64(23)  = 37
    gDevAryRound64(24)  = 5
    gDevAryRound64(25)  = 60
    gDevAryRound64(26)  = 21
    gDevAryRound64(27)  = 44
    gDevAryRound64(28)  = 13
    gDevAryRound64(29)  = 52
    gDevAryRound64(30)  = 29
    gDevAryRound64(31)  = 36
    gDevAryRound64(32)  = 2
    gDevAryRound64(33)  = 63
    gDevAryRound64(34)  = 18
    gDevAryRound64(35)  = 47
    gDevAryRound64(36)  = 10
    gDevAryRound64(37)  = 55
    gDevAryRound64(38)  = 26
    gDevAryRound64(39)  = 39
    gDevAryRound64(40)  = 7
    gDevAryRound64(41)  = 58
    gDevAryRound64(42)  = 23
    gDevAryRound64(43)  = 42
    gDevAryRound64(44)  = 15
    gDevAryRound64(45)  = 50
    gDevAryRound64(46)  = 31
    gDevAryRound64(47)  = 34
    gDevAryRound64(48)  = 3
    gDevAryRound64(49)  = 62
    gDevAryRound64(50)  = 19
    gDevAryRound64(51)  = 46
    gDevAryRound64(52)  = 11
    gDevAryRound64(53)  = 54
    gDevAryRound64(54)  = 27
    gDevAryRound64(55)  = 38
    gDevAryRound64(56)  = 6
    gDevAryRound64(57)  = 59
    gDevAryRound64(58)  = 22
    gDevAryRound64(59)  = 43
    gDevAryRound64(60)  = 14
    gDevAryRound64(61)  = 51
    gDevAryRound64(62)  = 30
    gDevAryRound64(63)  = 35
    
'   ===============================================================================     
'    Round : 128
'   ===============================================================================    
    ReDim gDevAryRound128(128)

    gDevAryRound128(0)     = 1
    gDevAryRound128(1)     = 128
    gDevAryRound128(2)     = 33
    gDevAryRound128(3)     = 96
    gDevAryRound128(4)     = 17
    gDevAryRound128(5)     = 112
    gDevAryRound128(6)     = 49
    gDevAryRound128(7)     = 80
    gDevAryRound128(8)     = 9
    gDevAryRound128(9)     = 120
    gDevAryRound128(10)    = 41
    gDevAryRound128(11)    = 88
    gDevAryRound128(12)    = 25
    gDevAryRound128(13)    = 104
    gDevAryRound128(14)    = 57
    gDevAryRound128(15)    = 72
    gDevAryRound128(16)    = 8
    gDevAryRound128(17)    = 121
    gDevAryRound128(18)    = 40
    gDevAryRound128(19)    = 89
    gDevAryRound128(20)    = 24
    gDevAryRound128(21)    = 105
    gDevAryRound128(22)    = 56
    gDevAryRound128(23)    = 73
    gDevAryRound128(24)    = 16
    gDevAryRound128(25)    = 113
    gDevAryRound128(26)    = 48
    gDevAryRound128(27)    = 81
    gDevAryRound128(28)    = 32
    gDevAryRound128(29)    = 97
    gDevAryRound128(30)    = 64
    gDevAryRound128(31)    = 65
    gDevAryRound128(32)    = 4
    gDevAryRound128(33)    = 125
    gDevAryRound128(34)    = 36
    gDevAryRound128(35)    = 93
    gDevAryRound128(36)    = 20
    gDevAryRound128(37)    = 109
    gDevAryRound128(38)    = 52
    gDevAryRound128(39)    = 77
    gDevAryRound128(40)    = 12
    gDevAryRound128(41)    = 117
    gDevAryRound128(42)    = 44
    gDevAryRound128(43)    = 85
    gDevAryRound128(44)    = 28
    gDevAryRound128(45)    = 101
    gDevAryRound128(46)    = 60
    gDevAryRound128(47)    = 69
    gDevAryRound128(48)    = 5
    gDevAryRound128(49)    = 124
    gDevAryRound128(50)    = 37
    gDevAryRound128(51)    = 92
    gDevAryRound128(52)    = 21
    gDevAryRound128(53)    = 108
    gDevAryRound128(54)    = 53
    gDevAryRound128(55)    = 76
    gDevAryRound128(56)    = 13
    gDevAryRound128(57)    = 116
    gDevAryRound128(58)    = 45
    gDevAryRound128(59)    = 84
    gDevAryRound128(60)    = 29
    gDevAryRound128(61)    = 100
    gDevAryRound128(62)    = 61
    gDevAryRound128(63)    = 68
    gDevAryRound128(64)    = 2
    gDevAryRound128(65)    = 127
    gDevAryRound128(66)    = 34
    gDevAryRound128(67)    = 95
    gDevAryRound128(68)    = 18
    gDevAryRound128(69)    = 111
    gDevAryRound128(70)    = 50
    gDevAryRound128(71)    = 79
    gDevAryRound128(72)    = 10
    gDevAryRound128(73)    = 119
    gDevAryRound128(74)    = 42
    gDevAryRound128(75)    = 87
    gDevAryRound128(76)    = 26
    gDevAryRound128(77)    = 103
    gDevAryRound128(78)    = 58
    gDevAryRound128(79)    = 71
    gDevAryRound128(80)    = 7
    gDevAryRound128(81)    = 122
    gDevAryRound128(82)    = 39
    gDevAryRound128(83)    = 90
    gDevAryRound128(84)    = 23
    gDevAryRound128(85)    = 106
    gDevAryRound128(86)    = 55
    gDevAryRound128(87)    = 74
    gDevAryRound128(88)    = 15
    gDevAryRound128(89)    = 114
    gDevAryRound128(90)    = 47
    gDevAryRound128(91)    = 82
    gDevAryRound128(92)    = 31
    gDevAryRound128(93)    = 98
    gDevAryRound128(94)    = 63
    gDevAryRound128(95)    = 66
    gDevAryRound128(96)    = 3
    gDevAryRound128(97)    = 126
    gDevAryRound128(98)    = 35
    gDevAryRound128(99)    = 94
    gDevAryRound128(100)   = 19
    gDevAryRound128(101)   = 110
    gDevAryRound128(102)   = 51
    gDevAryRound128(103)   = 78
    gDevAryRound128(104)   = 11
    gDevAryRound128(105)   = 118
    gDevAryRound128(106)   = 43
    gDevAryRound128(107)   = 86
    gDevAryRound128(108)   = 27
    gDevAryRound128(109)   = 102
    gDevAryRound128(110)   = 59
    gDevAryRound128(111)   = 70
    gDevAryRound128(112)   = 6
    gDevAryRound128(113)   = 123
    gDevAryRound128(114)   = 38
    gDevAryRound128(115)   = 91
    gDevAryRound128(116)   = 22
    gDevAryRound128(117)   = 107
    gDevAryRound128(118)   = 54
    gDevAryRound128(119)   = 75
    gDevAryRound128(120)   = 14
    gDevAryRound128(121)   = 115
    gDevAryRound128(122)   = 46
    gDevAryRound128(123)   = 83
    gDevAryRound128(124)   = 30
    gDevAryRound128(125)   = 99
    gDevAryRound128(126)   = 62
    gDevAryRound128(127)   = 67

'   ===============================================================================     
'    Round : 256
'   ===============================================================================    
    ReDim gDevAryRound256(256)

    gDevAryRound256(0)      = 1
    gDevAryRound256(1)      = 256
    gDevAryRound256(2)      = 65
    gDevAryRound256(3)      = 192
    gDevAryRound256(4)      = 33
    gDevAryRound256(5)      = 224
    gDevAryRound256(6)      = 97
    gDevAryRound256(7)      = 160
    gDevAryRound256(8)      = 17
    gDevAryRound256(9)      = 240
    gDevAryRound256(10)     = 81
    gDevAryRound256(11)     = 176
    gDevAryRound256(12)     = 49
    gDevAryRound256(13)     = 208
    gDevAryRound256(14)     = 113
    gDevAryRound256(15)     = 144
    gDevAryRound256(16)     = 9
    gDevAryRound256(17)     = 248
    gDevAryRound256(18)     = 73
    gDevAryRound256(19)     = 184
    gDevAryRound256(20)     = 41
    gDevAryRound256(21)     = 216
    gDevAryRound256(22)     = 105
    gDevAryRound256(23)     = 152
    gDevAryRound256(24)     = 25
    gDevAryRound256(25)     = 232
    gDevAryRound256(26)     = 89
    gDevAryRound256(27)     = 168
    gDevAryRound256(28)     = 57
    gDevAryRound256(29)     = 200
    gDevAryRound256(30)     = 121
    gDevAryRound256(31)     = 136
    gDevAryRound256(32)     = 8
    gDevAryRound256(33)     = 249
    gDevAryRound256(34)     = 72
    gDevAryRound256(35)     = 185
    gDevAryRound256(36)     = 40
    gDevAryRound256(37)     = 217
    gDevAryRound256(38)     = 104
    gDevAryRound256(39)     = 153
    gDevAryRound256(40)     = 24
    gDevAryRound256(41)     = 233
    gDevAryRound256(42)     = 88
    gDevAryRound256(43)     = 169
    gDevAryRound256(44)     = 56
    gDevAryRound256(45)     = 201
    gDevAryRound256(46)     = 120
    gDevAryRound256(47)     = 137
    gDevAryRound256(48)     = 16
    gDevAryRound256(49)     = 241
    gDevAryRound256(50)     = 80
    gDevAryRound256(51)     = 177
    gDevAryRound256(52)     = 48
    gDevAryRound256(53)     = 209
    gDevAryRound256(54)     = 112
    gDevAryRound256(55)     = 145
    gDevAryRound256(56)     = 32
    gDevAryRound256(57)     = 225
    gDevAryRound256(58)     = 96
    gDevAryRound256(59)     = 161
    gDevAryRound256(60)     = 64
    gDevAryRound256(61)     = 193
    gDevAryRound256(62)     = 128
    gDevAryRound256(63)     = 129
    gDevAryRound256(64)     = 4
    gDevAryRound256(65)     = 253
    gDevAryRound256(66)     = 68
    gDevAryRound256(67)     = 189
    gDevAryRound256(68)     = 36
    gDevAryRound256(69)     = 221
    gDevAryRound256(70)     = 100
    gDevAryRound256(71)     = 157
    gDevAryRound256(72)     = 20
    gDevAryRound256(73)     = 237
    gDevAryRound256(74)     = 84
    gDevAryRound256(75)     = 173
    gDevAryRound256(76)     = 52
    gDevAryRound256(77)     = 205
    gDevAryRound256(78)     = 116
    gDevAryRound256(79)     = 141
    gDevAryRound256(80)     = 12
    gDevAryRound256(81)     = 245
    gDevAryRound256(82)     = 76
    gDevAryRound256(83)     = 181
    gDevAryRound256(84)     = 44
    gDevAryRound256(85)     = 213
    gDevAryRound256(86)     = 108
    gDevAryRound256(87)     = 149
    gDevAryRound256(88)     = 28
    gDevAryRound256(89)     = 229
    gDevAryRound256(90)     = 92
    gDevAryRound256(91)     = 165
    gDevAryRound256(92)     = 60
    gDevAryRound256(93)     = 197
    gDevAryRound256(94)     = 124
    gDevAryRound256(95)     = 133
    gDevAryRound256(96)     = 5
    gDevAryRound256(97)     = 252
    gDevAryRound256(98)     = 69
    gDevAryRound256(99)     = 188
    gDevAryRound256(100)    = 37
    gDevAryRound256(101)    = 220
    gDevAryRound256(102)    = 101
    gDevAryRound256(103)    = 156
    gDevAryRound256(104)    = 21
    gDevAryRound256(105)    = 236
    gDevAryRound256(106)    = 85
    gDevAryRound256(107)    = 172
    gDevAryRound256(108)    = 53
    gDevAryRound256(109)    = 204
    gDevAryRound256(110)    = 117
    gDevAryRound256(111)    = 140
    gDevAryRound256(112)    = 13
    gDevAryRound256(113)    = 244
    gDevAryRound256(114)    = 77
    gDevAryRound256(115)    = 180
    gDevAryRound256(116)    = 45
    gDevAryRound256(117)    = 212
    gDevAryRound256(118)    = 109
    gDevAryRound256(119)    = 148
    gDevAryRound256(120)    = 29
    gDevAryRound256(121)    = 228
    gDevAryRound256(122)    = 93
    gDevAryRound256(123)    = 164
    gDevAryRound256(124)    = 61
    gDevAryRound256(125)    = 196
    gDevAryRound256(126)    = 125
    gDevAryRound256(127)    = 132
    gDevAryRound256(128)    = 2
    gDevAryRound256(129)    = 255
    gDevAryRound256(130)    = 66
    gDevAryRound256(131)    = 191
    gDevAryRound256(132)    = 34
    gDevAryRound256(133)    = 223
    gDevAryRound256(134)    = 98
    gDevAryRound256(135)    = 159
    gDevAryRound256(136)    = 18
    gDevAryRound256(137)    = 239
    gDevAryRound256(138)    = 82
    gDevAryRound256(139)    = 175
    gDevAryRound256(140)    = 50
    gDevAryRound256(141)    = 207
    gDevAryRound256(142)    = 114
    gDevAryRound256(143)    = 143
    gDevAryRound256(144)    = 10
    gDevAryRound256(145)    = 247
    gDevAryRound256(146)    = 74
    gDevAryRound256(147)    = 183
    gDevAryRound256(148)    = 42
    gDevAryRound256(149)    = 215
    gDevAryRound256(150)    = 106
    gDevAryRound256(151)    = 151
    gDevAryRound256(152)    = 26
    gDevAryRound256(153)    = 231
    gDevAryRound256(154)    = 90
    gDevAryRound256(155)    = 167
    gDevAryRound256(156)    = 58
    gDevAryRound256(157)    = 199
    gDevAryRound256(158)    = 122
    gDevAryRound256(159)    = 135
    gDevAryRound256(160)    = 7
    gDevAryRound256(161)    = 250
    gDevAryRound256(162)    = 71
    gDevAryRound256(163)    = 186
    gDevAryRound256(164)    = 39
    gDevAryRound256(165)    = 218
    gDevAryRound256(166)    = 103
    gDevAryRound256(167)    = 154
    gDevAryRound256(168)    = 23
    gDevAryRound256(169)    = 234
    gDevAryRound256(170)    = 87
    gDevAryRound256(171)    = 170
    gDevAryRound256(172)    = 55
    gDevAryRound256(173)    = 202
    gDevAryRound256(174)    = 119
    gDevAryRound256(175)    = 138
    gDevAryRound256(176)    = 15
    gDevAryRound256(177)    = 242
    gDevAryRound256(178)    = 79
    gDevAryRound256(179)    = 178
    gDevAryRound256(180)    = 47
    gDevAryRound256(181)    = 210
    gDevAryRound256(182)    = 111
    gDevAryRound256(183)    = 146
    gDevAryRound256(184)    = 31
    gDevAryRound256(185)    = 226
    gDevAryRound256(186)    = 95
    gDevAryRound256(187)    = 162
    gDevAryRound256(188)    = 63
    gDevAryRound256(189)    = 194
    gDevAryRound256(190)    = 127
    gDevAryRound256(191)    = 130
    gDevAryRound256(192)    = 3
    gDevAryRound256(193)    = 254
    gDevAryRound256(194)    = 67
    gDevAryRound256(195)    = 190
    gDevAryRound256(196)    = 35
    gDevAryRound256(197)    = 222
    gDevAryRound256(198)    = 99
    gDevAryRound256(199)    = 158
    gDevAryRound256(200)    = 19
    gDevAryRound256(201)    = 238
    gDevAryRound256(202)    = 83
    gDevAryRound256(203)    = 174
    gDevAryRound256(204)    = 51
    gDevAryRound256(205)    = 206
    gDevAryRound256(206)    = 115
    gDevAryRound256(207)    = 142
    gDevAryRound256(208)    = 11
    gDevAryRound256(209)    = 246
    gDevAryRound256(210)    = 75
    gDevAryRound256(211)    = 182
    gDevAryRound256(212)    = 43
    gDevAryRound256(213)    = 214
    gDevAryRound256(214)    = 107
    gDevAryRound256(215)    = 150
    gDevAryRound256(216)    = 27
    gDevAryRound256(217)    = 230
    gDevAryRound256(218)    = 91
    gDevAryRound256(219)    = 166
    gDevAryRound256(220)    = 59
    gDevAryRound256(221)    = 198
    gDevAryRound256(222)    = 123
    gDevAryRound256(223)    = 134
    gDevAryRound256(224)    = 6
    gDevAryRound256(225)    = 251
    gDevAryRound256(226)    = 70
    gDevAryRound256(227)    = 187
    gDevAryRound256(228)    = 38
    gDevAryRound256(229)    = 219
    gDevAryRound256(230)    = 102
    gDevAryRound256(231)    = 155
    gDevAryRound256(232)    = 22
    gDevAryRound256(233)    = 235
    gDevAryRound256(234)    = 86
    gDevAryRound256(235)    = 171
    gDevAryRound256(236)    = 54
    gDevAryRound256(237)    = 203
    gDevAryRound256(238)    = 118
    gDevAryRound256(239)    = 139
    gDevAryRound256(240)    = 14
    gDevAryRound256(241)    = 243
    gDevAryRound256(242)    = 78
    gDevAryRound256(243)    = 179
    gDevAryRound256(244)    = 46
    gDevAryRound256(245)    = 211
    gDevAryRound256(246)    = 110
    gDevAryRound256(247)    = 147
    gDevAryRound256(248)    = 30
    gDevAryRound256(249)    = 227
    gDevAryRound256(250)    = 94
    gDevAryRound256(251)    = 163
    gDevAryRound256(252)    = 62
    gDevAryRound256(253)    = 195
    gDevAryRound256(254)    = 126
    gDevAryRound256(255)    = 131
%>

<% 
    Dim gDevAryByePos
'   ===============================================================================     
'    Bye Position 1 ~ 256
'   ===============================================================================
   gDevAryByePos = Array( _
                        Array(0	), _
                        Array(0	), _
                        Array(1,   	2), _
                        Array(0	), _
                        Array(3,   	2,4,7 ), _
                        Array(2,   	2,7 ), _
                        Array(1,   	2), _
                        Array(0	), _
                        Array(7,   	2, 4, 6, 8, 11, 13, 15 ), _
                        Array(6,   	2, 4, 6, 11, 13, 15 ), _
                        Array(5,   	2, 4, 6, 11, 15 ), _
                        Array(4,   	2, 6, 11, 15 ), _
                        Array(3,   	2, 6, 15), _
                        Array(2,   	2, 15), _
                        Array(1,   	2), _
                        Array(0	), _
                        Array(15,  	2, 4, 6, 8, 10, 12, 14, 16, 19, 21, 23, 25, 27, 29, 31 ), _
                        Array(14,  	2, 4, 6, 8, 10, 12, 14, 19, 21, 23, 25, 27, 29, 31 ), _
                        Array(13,  	2, 4, 6, 8, 10, 12, 14, 19, 21, 23, 27, 29, 31), _
                        Array(12,  	2, 4, 6, 10, 12, 14, 19, 21, 23, 27, 29, 31 ), _
                        Array(11,  	2, 4, 6, 10, 12, 14, 19, 23, 27, 29, 31 ), _
                        Array(10,  	2, 4, 6, 10, 14, 19, 23, 27, 29, 31 ), _
                        Array(9,   	2, 4, 6, 10, 14, 19, 23, 27, 31 ), _
                        Array(8,   	2, 6, 10, 14, 19, 23, 27, 31 ), _
                        Array(7,   	2, 6, 10, 14, 23, 27, 31 ), _
                        Array(6,   	2, 6, 10, 23, 27, 31 ), _
                        Array(5,   	2, 6, 10, 23, 31), _
                        Array(4,   	2, 10, 23, 31), _
                        Array(3,   	2, 10, 31), _
                        Array(2,   	2, 31 ), _
                        Array(1,   	2), _
                        Array(0	), _
                        Array(31,  	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 35, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63 ), _
                        Array(30,  	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 35, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63 ), _
                        Array(29,  	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 35, 37, 39, 41, 43, 45, 47, 51, 53, 55, 57, 59, 61, 63 ), _
                        Array(28,  	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 30, 35, 37, 39, 41, 43, 45, 47, 51, 53, 55, 57, 59, 61, 63 ), _
                        Array(27,  	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 30, 35, 37, 39, 43, 45, 47, 51, 53, 55, 57, 59, 61, 63 ), _
                        Array(26,  	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 26, 28, 30, 35, 37, 39, 43, 45, 47, 51, 53, 55, 57, 59, 61, 63), _
                        Array(25,  	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 26, 28, 30, 35, 37, 39, 43, 45, 47, 51, 53, 55, 59, 61, 63 ), _
                        Array(24,  	2, 4, 6, 10, 12, 14, 18, 20, 22, 26, 28, 30, 35, 37, 39, 43, 45, 47, 51, 53, 55, 59, 61, 63 ), _
                        Array(23,  	2, 4, 6, 10, 12, 14, 18, 20, 22, 26, 28, 30, 35, 39, 43, 45, 47, 51, 53, 55, 59, 61, 63 ), _
                        Array(22,  	2, 4, 6, 10, 12, 14, 18, 20, 22, 26, 30, 35, 39, 43, 45, 47, 51, 53, 55, 59, 61, 63 ), _
                        Array(21,  	2, 4, 6, 10, 12, 14, 18, 20, 22, 26, 30, 35, 39, 43, 45, 47, 51, 55, 59, 61, 63 ), _
                        Array(20,  	2, 4, 6, 10, 14, 18, 20, 22, 26, 30, 35, 39, 43, 45, 47, 51, 55, 59, 61, 63), _
                        Array(19,  	2, 4, 6, 10, 14, 18, 20, 22, 26, 30, 35, 39, 43, 47, 51, 55, 59, 61, 63 ), _
                        Array(18,  	2, 4, 6, 10, 14, 18, 22, 26, 30, 35, 39, 43, 47, 51, 55, 59, 61, 63 ), _
                        Array(17,  	2, 4, 6, 10, 14, 18, 22, 26, 30, 35, 39, 43, 47, 51, 55, 59, 63 ), _
                        Array(16,  	2, 6, 10, 14, 18, 22, 26, 30, 35, 39, 43, 47, 51, 55, 59, 63 ), _
                        Array(15,  	2, 6, 10, 14, 18, 22, 26, 30, 39, 43, 47, 51, 55, 59, 63 ), _
                        Array(14,  	2, 6, 10, 14, 18, 22, 26, 39, 43, 47, 51, 55, 59, 63 ), _
                        Array(13,  	2, 6, 10, 14, 18, 22, 26, 39, 43, 47, 55, 59, 63 ), _
                        Array(12,  	2, 6, 10, 18, 22, 26, 39, 43, 47, 55, 59, 63 ), _
                        Array(11,  	2, 6, 10, 18, 22, 26, 39, 47, 55, 59, 63 ), _
                        Array(10,  	2, 6, 10, 18, 26, 39, 47, 55, 59, 63 ), _
                        Array(9,   	2, 6, 10, 18, 26, 39, 47, 55, 63 ), _
                        Array(8,   	2, 10, 18, 26, 39, 47, 55, 63 ), _
                        Array(7,   	2, 10, 18, 26, 47, 55, 63), _
                        Array(6,   	2, 10, 18, 47, 55, 63 ), _
                        Array(5,   	2, 10, 18, 47, 63), _
                        Array(4,   	2, 18, 47, 63 ), _
                        Array(3,   	2, 18, 63 ), _
                        Array(2,   	2, 63 ), _
                        Array(1,   	2), _
                        Array(0	), _
                        Array(63,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 67, 69, 71, 81, 83, 85, 87, 97, 99, 101, 103, 113, 115, 117, 119, 10, 12, 14, 16, 26, 28, 30, 32, 42, 44, 46, 48, 58, 60, 62, 64, 73, 75, 77, 79, 89, 91, 93, 95, 105, 107, 109, 111, 121, 123, 125, 127 ), _
                        Array(62,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 67, 69, 71, 81, 83, 85, 87, 97, 99, 101, 103, 113, 115, 117, 119, 10, 12, 14, 16, 26, 28, 30, 32, 42, 44, 46, 48, 58, 60, 62, 73, 75, 77, 79, 89, 91, 93, 95, 105, 107, 109, 111, 121, 123, 125, 127 ), _
                        Array(61,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 67, 69, 71, 81, 83, 85, 87, 99, 101, 103, 113, 115, 117, 119, 10, 12, 14, 16, 26, 28, 30, 32, 42, 44, 46, 48, 58, 60, 62, 73, 75, 77, 79, 89, 91, 93, 95, 105, 107, 109, 111, 121, 123, 125, 127 ), _
                        Array(60,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 67, 69, 71, 81, 83, 85, 87, 99, 101, 103, 113, 115, 117, 119, 10, 12, 14, 16, 26, 28, 30, 42, 44, 46, 48, 58, 60, 62, 73, 75, 77, 79, 89, 91, 93, 95, 105, 107, 109, 111, 121, 123, 125, 127 ), _
                        Array(59,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 67, 69, 71, 83, 85, 87, 99, 101, 103, 113, 115, 117, 119, 10, 12, 14, 16, 26, 28, 30, 42, 44, 46, 48, 58, 60, 62, 73, 75, 77, 79, 89, 91, 93, 95, 105, 107, 109, 111, 121, 123, 125, 127 ), _
                        Array(58,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 67, 69, 71, 83, 85, 87, 99, 101, 103, 113, 115, 117, 119, 10, 12, 14, 16, 26, 28, 30, 42, 44, 46, 58, 60, 62, 73, 75, 77, 79, 89, 91, 93, 95, 105, 107, 109, 111, 121, 123, 125, 127 ), _
                        Array(57,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 67, 69, 71, 83, 85, 87, 99, 101, 103, 115, 117, 119, 10, 12, 14, 16, 26, 28, 30, 42, 44, 46, 58, 60, 62, 73, 75, 77, 79, 89, 91, 93, 95, 105, 107, 109, 111, 121, 123, 125, 127 ), _
                        Array(56,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 67, 69, 71, 83, 85, 87, 99, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 30, 42, 44, 46, 58, 60, 62, 73, 75, 77, 79, 89, 91, 93, 95, 105, 107, 109, 111, 121, 123, 125, 127 ), _
                        Array(55,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 67, 69, 71, 83, 85, 87, 99, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 30, 42, 44, 46, 58, 60, 62, 75, 77, 79, 89, 91, 93, 95, 105, 107, 109, 111, 121, 123, 125, 127 ), _
                        Array(54,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 67, 69, 71, 83, 85, 87, 99, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 30, 42, 44, 46, 58, 60, 62, 75, 77, 79, 89, 91, 93, 95, 105, 107, 109, 111, 121, 123, 125, 127 ), _
                        Array(53,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 67, 69, 71, 83, 85, 87, 99, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 30, 42, 44, 46, 58, 60, 62, 75, 77, 79, 89, 91, 93, 95, 107, 109, 111, 121, 123, 125, 127 ), _
                        Array(52,  	2, 4, 6, 8, 18, 20, 22, 34, 36, 38, 40, 50, 52, 54, 67, 69, 71, 83, 85, 87, 99, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 30, 42, 44, 46, 58, 60, 62, 75, 77, 79, 89, 91, 93, 95, 107, 109, 111, 121, 123, 125, 127 ), _
                        Array(51,  	2, 4, 6, 8, 18, 20, 22, 34, 36, 38, 40, 50, 52, 54, 67, 69, 71, 83, 85, 87, 99, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 30, 42, 44, 46, 58, 60, 62, 75, 77, 79, 91, 93, 95, 107, 109, 111, 121, 123, 125, 127), _
                        Array(50,  	2, 4, 6, 8, 18, 20, 22, 34, 36, 38, 50, 52, 54, 67, 69, 71, 83, 85, 87, 99, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 30, 42, 44, 46, 58, 60, 62, 75, 77, 79, 91, 93, 95, 107, 109, 111, 121, 123, 125, 127), _
                        Array(49,  	2, 4, 6, 8, 18, 20, 22, 34, 36, 38, 50, 52, 54, 67, 69, 71, 83, 85, 87, 99, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 30, 42, 44, 46, 58, 60, 62, 75, 77, 79, 91, 93, 95, 107, 109, 111, 123, 125, 127), _
                        Array(48,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 67, 69, 71, 83, 85, 87,99, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 30, 42, 44, 46, 58, 60, 62, 75, 77, 79, 91, 93, 95, 107, 109, 111, 123, 125, 127 ), _
                        Array(47,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 69, 71, 83, 85, 87, 99, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 30, 42, 44, 46, 58, 60, 62, 75, 77, 79, 91, 93, 95, 107, 109, 111, 123, 125, 127), _
                        Array(46,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 69, 71, 83, 85, 87, 99, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 30, 42, 44, 46, 58, 60, 75, 77, 79, 91, 93, 95, 107, 109, 111, 123, 125, 127 ), _
                        Array(45,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 69, 71, 83, 85, 87, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 30, 42, 44, 46, 58, 60, 75, 77, 79, 91, 93, 95, 107, 109, 111, 123, 125, 127 ), _
                        Array(44,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 69, 71, 83, 85, 87, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 42, 44, 46, 58, 60, 75, 77, 79, 91, 93, 95, 107, 109, 111, 123, 125, 127), _
                        Array(43,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 69, 71, 85, 87, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 42, 44, 46, 58, 60, 75, 77, 79, 91, 93, 95, 107, 109, 111, 123, 125, 127 ), _
                        Array(42,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 69, 71, 85, 87, 101, 103, 115, 117, 119, 10, 12, 14, 26, 28, 42, 44, 58, 60, 75, 77, 79, 91, 93, 95, 107, 109, 111, 123, 125, 127), _
                        Array(41,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 69, 71, 85, 87, 101, 103, 117, 119, 10, 12, 14, 26, 28, 42, 44, 58, 60, 75, 77, 79, 91, 93, 95, 107, 109, 111, 123, 125, 127), _
                        Array(40,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 69, 71, 85, 87, 101, 103, 117, 119, 10, 12, 26, 28, 42, 44, 58, 60, 75, 77, 79, 91, 93, 95, 107, 109, 111, 123, 125, 127), _
                        Array(39,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 69, 71, 85, 87, 101, 103, 117, 119, 10, 12, 26, 28, 42, 44, 58, 60, 77, 79, 91, 93, 95, 107, 109, 111, 123, 125, 127 ), _
                        Array(38,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 69, 71, 85, 87, 101, 103, 117, 119, 10, 12, 26, 28, 42, 44, 58, 60, 77, 79, 91, 93, 95, 107, 109, 111, 123, 125, 127), _
                        Array(37,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 69, 71, 85, 87, 101, 103, 117, 119, 10, 12, 26, 28, 42, 44, 58, 60, 77, 79, 91, 93, 95, 109, 111, 123, 125, 127), _
                        Array(36,  	2, 4, 6, 18, 20, 34, 36, 38, 50, 52, 69, 71, 85, 87, 101, 103, 117, 119, 10, 12, 26, 28, 42, 44, 58, 60, 77, 79, 91, 93, 95, 109, 111, 123, 125, 127), _
                        Array(35,  	2, 4, 6, 18, 20, 34, 36, 38, 50, 52, 69, 71, 85, 87, 101, 103, 117, 119, 10, 12, 26, 28, 42, 44, 58, 60, 77, 79, 93, 95, 109, 111, 123, 125, 127), _
                        Array(34,  	2, 4, 6, 18, 20, 34, 36, 50, 52, 69, 71, 85, 87, 101, 103, 117, 119, 10, 12, 26, 28, 42, 44, 58, 60, 77, 79, 93, 95, 109, 111, 123, 125, 127), _
                        Array(33,  	2, 4, 6, 18, 20, 34, 36, 50, 52, 69, 71, 85, 87, 101, 103, 117, 119, 10, 12, 26, 28, 42, 44, 58, 60, 77, 79, 93, 95, 109, 111, 125, 127 ), _
                        Array(32,  	2, 4, 18, 20, 34, 36, 50, 52, 69, 71, 85, 87, 101, 103, 117, 119, 10, 12, 26, 28, 42, 44, 58, 60, 77, 79, 93, 95, 109, 111, 125, 127), _
                        Array(31,  	2, 4, 18, 20, 34, 36, 50, 52, 71, 85, 87, 101, 103, 117, 119, 10, 12, 26, 28, 42, 44, 58, 60, 77, 79, 93, 95, 109, 111, 125, 127 ), _
                        Array(30,  	2, 4, 18, 20, 34, 36, 50, 52, 71, 85, 87, 101, 103, 117, 119, 10, 12, 26, 28, 42, 44, 58, 77, 79, 93, 95, 109, 111, 125, 127), _
                        Array(29,  	2, 4, 18, 20, 34, 36, 50, 52, 71, 85, 87, 103, 117, 119, 10, 12, 26, 28, 42, 44, 58, 77, 79, 93, 95, 109, 111, 125, 127), _
                        Array(28,  	2, 4, 18, 20, 34, 36, 50, 52, 71, 85, 87, 103, 117, 119, 10, 12, 26, 42, 44, 58, 77, 79, 93, 95, 109, 111, 125, 127 ), _
                        Array(27,  	2, 4, 18, 20, 34, 36, 50, 52, 71, 87, 103, 117, 119, 10, 12, 26, 42, 44, 58, 77, 79, 93, 95, 109, 111,125, 127 ), _
                        Array(26,  	2, 4, 18, 20, 34, 36, 50, 52, 71, 87, 103, 117, 119, 10, 12, 26, 42, 58, 77, 79, 93, 95, 109, 111,125, 127 ), _
                        Array(25,  	2, 4, 18, 20, 34, 36, 50, 52, 71, 87, 103, 119, 10, 12, 26, 42, 58, 77, 79, 93, 95, 109, 111,125, 127 ), _
                        Array(24,  	2, 4, 18, 20, 34, 36, 50, 52, 71, 87, 103, 119, 10, 26, 42, 58, 77, 79, 93, 95, 109, 111,125, 127 ), _
                        Array(23,  	2, 4, 18, 20, 34, 36, 50, 52, 71, 87, 103, 119, 10, 26, 42, 58,79, 93, 95, 109, 111,125, 127 ), _
                        Array(22,  	2, 4, 18, 20, 34, 36, 50, 71, 87, 103, 119, 10, 26, 42, 58, 79, 93, 95, 109, 111,125, 127), _
                        Array(21,  	2, 4, 18, 20, 34, 36, 50, 71, 87, 103, 119, 10, 26, 42, 58, 79, 93, 95,111,125, 127), _
                        Array(20,  	2, 4, 18, 34, 36, 50, 71, 87, 103, 119, 10, 26, 42, 58, 79, 93, 95,111,125, 127), _
                        Array(19,  	2, 4, 18, 34, 36, 50, 71, 87, 103, 119, 10, 26, 42, 58, 79,95,111,125, 127 ), _
                        Array(18,  	2, 4, 18, 34, 50, 71, 87, 103, 119, 10, 26, 42, 58,79,95,111,125, 127 ), _
                        Array(17,  	2, 4, 18, 34, 50, 71, 87, 103, 119, 10, 26, 42, 58,79,95,111, 127 ), _
                        Array(16,  	2, 18, 34, 50, 71, 87, 103, 119, 10, 26, 42, 58,79,95,111, 127), _
                        Array(15,  	2, 18, 34, 50, 87, 103, 119, 10, 26, 42, 58,79,95,111, 127 ), _
                        Array(14,  	2, 18, 34, 50, 87, 103, 119, 10, 26, 42,79,95,111, 127 ), _
                        Array(13,  	2, 18, 34, 50, 87, 119, 10, 26, 42,79,95,111, 127 ), _
                        Array(12,  	2, 18, 34, 50, 87, 119, 10, 42,79,95,111, 127 ), _
                        Array(11,  	2, 18, 34, 50,119, 10, 42,79,95,111, 127 ), _
                        Array(10,  	2, 18, 34, 50,119, 10,79,95,111, 127 ), _
                        Array(9,   	2, 18, 34, 50,10,79,95,111, 127 ), _
                        Array(8,   	2, 18, 34, 50,79,95,111, 127 ), _
                        Array(7,   	2, 18, 34, 50, 95,111, 127), _
                        Array(6,   	2, 18, 34, 95,111, 127), _
                        Array(5,   	2, 18, 34, 95,127), _
                        Array(4,   	2,34, 95,127), _
                        Array(3,   	2,34, 127), _
                        Array(2,   	2, 127), _
                        Array(1,   	2 ), _
                        Array(0	), _
                        Array(127, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 128, 131, 133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 161, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 193, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 225, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(126, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 161, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 193, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 225, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(125, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 161, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 225, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(124, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 161, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 225, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(123, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 225, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(122, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 225, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(121, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(120, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(119, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(118, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(117, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(116, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(115, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(114, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(113, 	2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(112, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 126, 131, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(111, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 126, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(110, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 195, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(109, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 62, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(108, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 163, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(107, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 94, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(106, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 227, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(105, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 30, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(104, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 147, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255), _
                        Array(103, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 110, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(102, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 211, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(101, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 46, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255), _
                        Array(100, 	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 179, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(99,  	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 78, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(98,  	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 243, 245, 247, 249, 251, 253, 255 ), _
                        Array(97,  	2, 4, 6, 8, 10, 12, 14, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(96,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 124, 133, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(95,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 124, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(94,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 197, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(93,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 60, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(92,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 165, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(91,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 92, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(90,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 229, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(89,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 28, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(88,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 149, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255), _
                        Array(87,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 108, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(86,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 213, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(85,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 44, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(84,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 181, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(83,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 76, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(82,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 245, 247, 249, 251, 253, 255 ), _
                        Array(81,  	2, 4, 6, 8, 10, 12, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(80,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 114, 116, 118, 120, 122, 135, 137, 139, 141, 143, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 247, 249, 251, 253, 255), _
                        Array(79,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 114, 116, 118, 120, 122, 137, 139, 141, 143, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(78,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 114, 116, 118, 120, 137, 139, 141, 143, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 183, 185, 187, 189, 191, 199, 201, 203, 205, 207, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(77,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 50, 52, 54, 56, 58, 66, 68, 70, 72, 74, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 114, 116, 118, 120, 137, 139, 141, 143, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 183, 185, 187, 189, 191, 201, 203, 205, 207, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(76,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 50, 52, 54, 56, 66, 68, 70, 72, 74, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 114, 116, 118, 120, 137, 139, 141, 143, 151, 153, 155, 157, 159, 167, 169, 171, 173, 175, 183, 185, 187, 189, 191, 201, 203, 205, 207, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(75,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 50, 52, 54, 56, 66, 68, 70, 72, 74, 82, 84, 86, 88, 90, 98, 100, 102, 104, 106, 114, 116, 118, 120, 137, 139, 141, 143, 151, 153, 155, 157, 159, 169, 171, 173, 175, 183, 185, 187, 189, 191, 201, 203, 205, 207, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(74,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 50, 52, 54, 56, 66, 68, 70, 72, 74, 82, 84, 86, 88, 98, 100, 102, 104, 106, 114, 116, 118, 120, 137, 139, 141, 143, 151, 153, 155, 157, 159, 169, 171, 173, 175, 183, 185, 187, 189, 191, 201, 203, 205, 207, 215, 217, 219, 221, 223, 231, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(73,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 26, 34, 36, 38, 40, 42, 50, 52, 54, 56, 66, 68, 70, 72, 74, 82, 84, 86, 88, 98, 100, 102, 104, 106, 114, 116, 118, 120, 137, 139, 141, 143, 151, 153, 155, 157, 159, 169, 171, 173, 175, 183, 185, 187, 189, 191, 201, 203, 205, 207, 215, 217, 219, 221, 223, 233, 235, 237, 239, 247, 249, 251, 253, 255), _
                        Array(72,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 34, 36, 38, 40, 42, 50, 52, 54, 56, 66, 68, 70, 72, 74, 82, 84, 86, 88, 98, 100, 102, 104, 106, 114, 116, 118, 120, 137, 139, 141, 143, 151, 153, 155, 157, 159, 169, 171, 173, 175, 183, 185, 187, 189, 191, 201, 203, 205, 207, 215, 217, 219, 221, 223, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(71,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 34, 36, 38, 40, 42, 50, 52, 54, 56, 66, 68, 70, 72, 74, 82, 84, 86, 88, 98, 100, 102, 104, 106, 114, 116, 118, 120, 137, 139, 141, 143, 153, 155, 157, 159, 169, 171, 173, 175, 183, 185, 187, 189, 191, 201, 203, 205, 207, 215, 217, 219, 221, 223, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(70,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 34, 36, 38, 40, 42, 50, 52, 54, 56, 66, 68, 70, 72, 74, 82, 84, 86, 88, 98, 100, 102, 104, 114, 116, 118, 120, 137, 139, 141, 143, 153, 155, 157, 159, 169, 171, 173, 175, 183, 185, 187, 189, 191, 201, 203, 205, 207, 215, 217, 219, 221, 223, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(69,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 34, 36, 38, 40, 42, 50, 52, 54, 56, 66, 68, 70, 72, 74, 82, 84, 86, 88, 98, 100, 102, 104, 114, 116, 118, 120, 137, 139, 141, 143, 153, 155, 157, 159, 169, 171, 173, 175, 183, 185, 187, 189, 191, 201, 203, 205, 207, 217, 219, 221, 223, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(68,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 66, 68, 70, 72, 74, 82, 84, 86, 88, 98, 100, 102, 104, 114, 116, 118, 120, 137, 139, 141, 143, 153, 155, 157, 159, 169, 171, 173, 175, 183, 185, 187, 189, 191, 201, 203, 205, 207, 217, 219, 221, 223, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(67,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 66, 68, 70, 72, 74, 82, 84, 86, 88, 98, 100, 102, 104, 114, 116, 118, 120, 137, 139, 141, 143, 153, 155, 157, 159, 169, 171, 173, 175, 185, 187, 189, 191, 201, 203, 205, 207, 217, 219, 221, 223, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(66,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 66, 68, 70, 72, 82, 84, 86, 88, 98, 100, 102, 104, 114, 116, 118, 120, 137, 139, 141, 143, 153, 155, 157, 159, 169, 171, 173, 175, 185, 187, 189, 191, 201, 203, 205, 207, 217, 219, 221, 223, 233, 235, 237, 239, 247, 249, 251, 253, 255 ), _
                        Array(65,  	2, 4, 6, 8, 10, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 66, 68, 70, 72, 82, 84, 86, 88, 98, 100, 102, 104, 114, 116, 118, 120, 137, 139, 141, 143, 153, 155, 157, 159, 169, 171, 173, 175, 185, 187, 189, 191, 201, 203, 205, 207, 217, 219, 221, 223, 233, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(64,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 66, 68, 70, 72, 82, 84, 86, 88, 98, 100, 102, 104, 114, 116, 118, 120, 137, 139, 141, 143, 153, 155, 157, 159, 169, 171, 173, 175, 185, 187, 189, 191, 201, 203, 205, 207, 217, 219, 221, 223, 233, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(63,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 66, 68, 70, 72, 82, 84, 86, 88, 98, 100, 102, 104, 114, 116, 118, 120, 139, 141, 143, 153, 155, 157, 159, 169, 171, 173, 175, 185, 187, 189, 191, 201, 203, 205, 207, 217, 219, 221, 223, 233, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(62,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 66, 68, 70, 72, 82, 84, 86, 88, 98, 100, 102, 104, 114, 116, 118, 139, 141, 143, 153, 155, 157, 159, 169, 171, 173, 175, 185, 187, 189, 191, 201, 203, 205, 207, 217, 219, 221, 223, 233, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(61,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 56, 66, 68, 70, 72, 82, 84, 86, 88, 98, 100, 102, 104, 114, 116, 118, 139, 141, 143, 153, 155, 157, 159, 169, 171, 173, 175, 185, 187, 189, 191, 203, 205, 207, 217, 219, 221, 223, 233, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(60,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 66, 68, 70, 72, 82, 84, 86, 88, 98, 100, 102, 104, 114, 116, 118, 139, 141, 143, 153, 155, 157, 159, 169, 171, 173, 175, 185, 187, 189, 191, 203, 205, 207, 217, 219, 221, 223, 233, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(59,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 66, 68, 70, 72, 82, 84, 86, 88, 98, 100, 102, 104, 114, 116, 118, 139, 141, 143, 153, 155, 157, 159, 171, 173, 175, 185, 187, 189, 191, 203, 205, 207, 217, 219, 221, 223, 233, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(58,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 66, 68, 70, 72, 82, 84, 86, 98, 100, 102, 104, 114, 116, 118, 139, 141, 143, 153, 155, 157, 159, 171, 173, 175, 185, 187, 189, 191, 203, 205, 207, 217, 219, 221, 223, 233, 235, 237, 239, 249, 251, 253, 255), _
                        Array(57,  	2, 4, 6, 8, 18, 20, 22, 24, 34, 36, 38, 40, 50, 52, 54, 66, 68, 70, 72, 82, 84, 86, 98, 100, 102, 104, 114, 116, 118, 139, 141, 143, 153, 155, 157, 159, 171, 173, 175, 185, 187, 189, 191, 203, 205, 207, 217, 219, 221, 223, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(56,  	2, 4, 6, 8, 18, 20, 22, 34, 36, 38, 40, 50, 52, 54, 66, 68, 70, 72, 82, 84, 86, 98, 100, 102, 104, 114, 116, 118, 139, 141, 143, 153, 155, 157, 159, 171, 173, 175, 185, 187, 189, 191, 203, 205, 207, 217, 219, 221, 223, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(55,  	2, 4, 6, 8, 18, 20, 22, 34, 36, 38, 40, 50, 52, 54, 66, 68, 70, 72, 82, 84, 86, 98, 100, 102, 104, 114, 116, 118, 139, 141, 143, 155, 157, 159, 171, 173, 175, 185, 187, 189, 191, 203, 205, 207, 217, 219, 221, 223, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(54,  	2, 4, 6, 8, 18, 20, 22, 34, 36, 38, 40, 50, 52, 54, 66, 68, 70, 72, 82, 84, 86, 98, 100, 102, 114, 116, 118, 139, 141, 143, 155, 157, 159, 171, 173, 175, 185, 187, 189, 191, 203, 205, 207, 217, 219, 221, 223, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(53,  	2, 4, 6, 8, 18, 20, 22, 34, 36, 38, 40, 50, 52, 54, 66, 68, 70, 72, 82, 84, 86, 98, 100, 102, 114, 116, 118, 139, 141, 143, 155, 157, 159, 171, 173, 175, 185, 187, 189, 191, 203, 205, 207, 219, 221, 223, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(52,  	2, 4, 6, 8, 18, 20, 22, 34, 36, 38, 50, 52, 54, 66, 68, 70, 72, 82, 84, 86, 98, 100, 102, 114, 116, 118, 139, 141, 143, 155, 157, 159, 171, 173, 175, 185, 187, 189, 191, 203, 205, 207, 219, 221, 223, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(51,  	2, 4, 6, 8, 18, 20, 22, 34, 36, 38, 50, 52, 54, 66, 68, 70, 72, 82, 84, 86, 98, 100, 102, 114, 116, 118, 139, 141, 143, 155, 157, 159, 171, 173, 175, 187, 189, 191, 203, 205, 207, 219, 221, 223, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(50,  	2, 4, 6, 8, 18, 20, 22, 34, 36, 38, 50, 52, 54, 66, 68, 70, 82, 84, 86, 98, 100, 102, 114, 116, 118, 139, 141, 143, 155, 157, 159, 171, 173, 175, 187, 189, 191, 203, 205, 207, 219, 221, 223, 235, 237, 239, 249, 251, 253, 255 ), _
                        Array(49,  	2, 4, 6, 8, 18, 20, 22, 34, 36, 38, 50, 52, 54, 66, 68, 70, 82, 84, 86, 98, 100, 102, 114, 116, 118, 139, 141, 143, 155, 157, 159, 171, 173, 175, 187, 189, 191, 203, 205, 207, 219, 221, 223, 235, 237, 239, 251, 253, 255 ), _
                        Array(48,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 66, 68, 70, 82, 84, 86, 98, 100, 102, 114, 116, 118, 139, 141, 143, 155, 157, 159, 171, 173, 175, 187, 189, 191, 203, 205, 207, 219, 221, 223, 235, 237, 239, 251, 253, 255 ), _
                        Array(47,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 66, 68, 70, 82, 84, 86, 98, 100, 102, 114, 116, 118, 141, 143, 155, 157, 159, 171, 173, 175, 187, 189, 191, 203, 205, 207, 219, 221, 223, 235, 237, 239, 251, 253, 255), _
                        Array(46,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 66, 68, 70, 82, 84, 86, 98, 100, 102, 114, 116, 141, 143, 155, 157, 159, 171, 173, 175, 187, 189, 191, 203, 205, 207, 219, 221, 223, 235, 237, 239, 251, 253, 255 ), _
                        Array(45,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 54, 66, 68, 70, 82, 84, 86, 98, 100, 102, 114, 116, 141, 143, 155, 157, 159, 171, 173, 175, 187, 189, 191, 205, 207, 219, 221, 223, 235, 237, 239, 251, 253, 255 ), _
                        Array(44,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 66, 68, 70, 82, 84, 86, 98, 100, 102, 114, 116, 141, 143, 155, 157, 159, 171, 173, 175, 187, 189, 191, 205, 207, 219, 221, 223, 235, 237, 239, 251, 253, 255 ), _
                        Array(43,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 66, 68, 70, 82, 84, 86, 98, 100, 102, 114, 116, 141, 143, 155, 157, 159, 173, 175, 187, 189, 191, 205, 207, 219, 221, 223, 235, 237, 239, 251, 253, 255 ), _
                        Array(42,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 66, 68, 70, 82, 84, 98, 100, 102, 114, 116, 141, 143, 155, 157, 159, 173, 175, 187, 189, 191, 205, 207, 219, 221, 223, 235, 237, 239, 251, 253, 255 ), _
                        Array(41,  	2, 4, 6, 18, 20, 22, 34, 36, 38, 50, 52, 66, 68, 70, 82, 84, 98, 100, 102, 114, 116, 141, 143, 155, 157, 159, 173, 175, 187, 189, 191, 205, 207, 219, 221, 223, 237, 239, 251, 253, 255 ), _
                        Array(40,  	2, 4, 6, 18, 20, 34, 36, 38, 50, 52, 66, 68, 70, 82, 84, 98, 100, 102, 114, 116, 141, 143, 155, 157, 159, 173, 175, 187, 189, 191, 205, 207, 219, 221, 223, 237, 239, 251, 253, 255 ), _
                        Array(39,  	2, 4, 6, 18, 20, 34, 36, 38, 50, 52, 66, 68, 70, 82, 84, 98, 100, 102, 114, 116, 141, 143, 157, 159, 173, 175, 187, 189, 191, 205, 207, 219, 221, 223, 237, 239, 251, 253, 255 ), _
                        Array(38,  	2, 4, 6, 18, 20, 34, 36, 38, 50, 52, 66, 68, 70, 82, 84, 98, 100, 114, 116, 141, 143, 157, 159, 173, 175, 187, 189, 191, 205, 207, 219, 221, 223, 237, 239, 251, 253, 255 ), _
                        Array(37,  	2, 4, 6, 18, 20, 34, 36, 38, 50, 52, 66, 68, 70, 82, 84, 98, 100, 114, 116, 141, 143, 157, 159, 173, 175, 187, 189, 191, 205, 207, 221, 223, 237, 239, 251, 253, 255 ), _
                        Array(36,  	2, 4, 6, 18, 20, 34, 36, 50, 52, 66, 68, 70, 82, 84, 98, 100, 114, 116, 141, 143, 157, 159, 173, 175, 187, 189, 191, 205, 207, 221, 223, 237, 239, 251, 253, 255 ), _
                        Array(35,  	2, 4, 6, 18, 20, 34, 36, 50, 52, 66, 68, 70, 82, 84, 98, 100, 114, 116, 141, 143, 157, 159, 173, 175, 189, 191, 205, 207, 221, 223, 237, 239, 251, 253, 255 ), _
                        Array(34,  	2, 4, 6, 18, 20, 34, 36, 50, 52, 66, 68, 82, 84, 98, 100, 114, 116, 141, 143, 157, 159, 173, 175, 189, 191, 205, 207, 221, 223, 237, 239, 251, 253, 255 ), _
                        Array(33,  	2, 4, 6, 18, 20, 34, 36, 50, 52, 66, 68, 82, 84, 98, 100, 114, 116, 141, 143, 157, 159, 173, 175, 189, 191, 205, 207, 221, 223, 237, 239, 253, 255 ), _
                        Array(32,  	2, 4, 18, 20, 34, 36, 50, 52, 66, 68, 82, 84, 98, 100, 114, 116, 141, 143, 157, 159, 173, 175, 189, 191, 205, 207, 221, 223, 237, 239, 253, 255 ), _
                        Array(31,  	2, 4, 18, 20, 34, 36, 50, 52, 66, 68, 82, 84, 98, 100, 114, 116, 143, 157, 159, 173, 175, 189, 191, 205, 207, 221, 223, 237, 239, 253, 255 ), _
                        Array(30,  	2, 4, 18, 20, 34, 36, 50, 52, 66, 68, 82, 84, 98, 100, 114, 143, 157, 159, 173, 175, 189, 191, 205, 207, 221, 223, 237, 239, 253, 255 ), _
                        Array(29,  	2, 4, 18, 20, 34, 36, 50, 52, 66, 68, 82, 84, 98, 100, 114, 143, 157, 159, 173, 175, 189, 191, 207, 221, 223, 237, 239, 253, 255 ), _
                        Array(28,  	2, 4, 18, 20, 34, 36, 50, 66, 68, 82, 84, 98, 100, 114, 143, 157, 159, 173, 175, 189, 191, 207, 221, 223, 237, 239, 253, 255 ), _
                        Array(27,  	2, 4, 18, 20, 34, 36, 50, 66, 68, 82, 84, 98, 100, 114, 143, 157, 159, 175, 189, 191, 207, 221, 223, 237, 239, 253, 255 ), _
                        Array(26,  	2, 4, 18, 20, 34, 36, 50, 66, 68, 82, 98, 100, 114, 143, 157, 159, 175, 189, 191, 207, 221, 223, 237, 239, 253, 255 ), _
                        Array(25,  	2, 4, 18, 20, 34, 36, 50, 66, 68, 82, 98, 100, 114, 143, 157, 159, 175, 189, 191, 207, 221, 223, 239, 253, 255 ), _
                        Array(24,  	2, 4, 18, 34, 36, 50, 66, 68, 82, 98, 100, 114, 143, 157, 159, 175, 189, 191, 207, 221, 223, 239, 253, 255), _
                        Array(23,  	2, 4, 18, 34, 36, 50, 66, 68, 82, 98, 100, 114, 143, 159, 175, 189, 191, 207, 221, 223, 239, 253, 255 ), _
                        Array(22,  	2, 4, 18, 34, 36, 50, 66, 68, 82, 98, 114, 143, 159, 175, 189, 191, 207, 221, 223, 239, 253, 255 ), _
                        Array(21,  	2, 4, 18, 34, 36, 50, 66, 68, 82, 98, 114, 143, 159, 175, 189, 191, 207, 223, 239, 253, 255 ), _
                        Array(20,  	2, 4, 18, 34, 50, 66, 68, 82, 98, 114, 143, 159, 175, 189, 191, 207, 223, 239, 253, 255 ), _
                        Array(19,  	2, 4, 18, 34, 50, 66, 68, 82, 98, 114, 143, 159, 175, 191, 207, 223, 239, 253, 255 ), _
                        Array(18,  	2, 4, 18, 34, 50, 66, 82, 98, 114, 143, 159, 175, 191, 207, 223, 239, 253, 255 ), _
                        Array(17,  	2, 4, 18, 34, 50, 66, 82, 98, 114, 143, 159, 175, 191, 207, 223, 239, 255 ), _
                        Array(16,  	2, 18, 34, 50, 66, 82, 98, 114, 143, 159, 175, 191, 207, 223, 239, 255), _
                        Array(15,  	2, 18, 34, 50, 66, 82, 98, 114, 159, 175, 191, 207, 223, 239, 255), _
                        Array(14,  	2, 18, 34, 50, 66, 82, 98, 159, 175, 191, 207, 223, 239, 255), _
                        Array(13,  	2, 18, 34, 50, 66, 82, 98, 159, 175, 191, 223, 239, 255), _
                        Array(12,  	2, 18, 34, 66, 82, 98, 159, 175, 191, 223, 239, 255 ), _
                        Array(11,  	2, 18, 34, 66, 82, 98, 159, 191, 223, 239, 255 ), _
                        Array(10,  	2, 18, 34, 66, 98, 159, 191, 223, 239, 255), _
                        Array(9,   	2, 18, 34, 66, 98, 159, 191, 223, 255), _
                        Array(8,   	2, 34, 66, 98, 159, 191, 223, 255 ), _
                        Array(7,   	2, 34, 66, 98, 191, 223, 255), _
                        Array(6,   	2, 34, 66, 191, 223, 255 ), _
                        Array(5,   	2, 34, 66, 191, 255 ), _
                        Array(4,   	2, 66, 191, 255 ), _
                        Array(3,   	2, 66, 255 ), _
                        Array(2,   	2, 255 ), _
                        Array(1,   	2 ), _
                        Array(0	) _
                )


%>