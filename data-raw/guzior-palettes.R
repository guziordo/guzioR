library(palettes)

# B10 Themed
b10.pal <- pal_palette(
  buckeye = c('#BA0C2F','#A7B1B7','#FFFFFF','#000000'),
  spartan = c('#18453B','#FFFFFF','#000000','#4d4d4d','#008208','#7BBD00','#0B9A6D','#008934'),
  illini = c("#FF5F05","#009FD4","#13294B","#F8FAFC","#F5821E","#1D58A7","#1E3877"),
  hoosier = c('#990000','#EDEBEB','#000000', '#243142','#006298', '#66435A'),
  terrapin = c('#E03A3E','#FFD520','#FFFFFF','#000000'),
  boiler = c('#cfb991','#000000','#8E6F3E','#555960','#DAAA00','#6F727B','#DDB945','#9D9795','#EBD99F','#C4BFC0'),
  badger = c('#C5050C','#FFFFFF','#9B0000','#F7F7F7','#333333','#0479A8'),
  gopher = c('#7a0019','#ffcc33','#333333','#5b0013','#ffb71e','#777677','#900021','#ffde7a','#5a5a5a','#d5d6d2'),
  husker = c("#AD122A", "#000000", "#303B41", "#989EA4", "#DCDDDF"),
  nittany = c("#001E44", "#1E407C", "#FFFFFF", "#96BEE6"),
  wildcat = c("#4e2a84", "#836eaa", "#401f68", "#b6acd1", "#e4e0ee", "#342f2e", "#716c6b", "#bbb8b8", "#d8d6d6"),
  knight = c("#CC0033", "#FFFFFF", "#D2D2D2", "#666666", "#999999"),
  wolverine = c("#FFCB05", "#00274C", "#AFC3DB", "#81C5C3", "#006EB2", "#6963A9")
)

plot(b10.pal)
usethis::use_data(b10.pal, overwrite = TRUE)

guzior.pal <- pal_palette(
  threecol = c("#003352","#009dca","#c24658"),
  cpcols = c("#8B2323", "#EE7600", "#EEC900", "chartreuse3", "#0000FF", "#AB82FF", "#CD6889", "#FFA07A", "#FFFF00", "#228B22", "#AFEEEE", "#DDA0DD", "#EE2C2C", "#CDBE70", "#B0B099","#FFD900", "#32CD32", "maroon4", "cornflowerblue", "darkslateblue","#FFFFE0", "#FFEC8B", "peru", "#668B8B", "honeydew","#A020F0", "grey", "#8B4513", "#191970", "#00FF7F","lemonchiffon","#66CDAA", "#5F9EA0", "#A2CD5A", "#556B2F"),
  )

plot(guzior.pal)
usethis::use_data(guzior.pal, overwrite = TRUE)

