#  0123456
# 0xx
# 1xx
# 2  xx
# 3  xx
# 4    xxx
# 5    xxx
# 6    xxx
#
# 01
# 23
# 456
#
# should be 80
#
# 36 - 4 - 4 - 9 choose 7
# 19 choose 7

print (19 * 18 * 17 * 16 * 15 * 14 * 13) / (7 * 6 * 5 * 4 * 3 * 2);
