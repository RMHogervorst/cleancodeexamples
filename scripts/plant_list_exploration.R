# playing with the complete plant list
# 
plantlist <- readr::read_csv("http://www.plants.usda.gov/java/downloadData?fileName=plantlst.txt&static=true")
length(unique(plantlist$Family))# 543 unique families of 90986 types.
str(plantlist)
View(plantlist)
library(dplyr)
plantlist %>% 
        filter(grepl("L.", plantlist$`Scientific Name with Author`)) %>% # 26,495 by lineaus.
        View()
plantlist %>% 
        group_by(Family) %>% 
        summarise(N = n()) %>% 
        arrange(desc(N))
# A tibble: 543 × 2
#            Family     N
#           <chr>      <int>
# 1        Asteraceae 10642
# 2          Fabaceae  6886
# 3           Poaceae  6464
# 4          Rosaceae  3231
# 5        Cyperaceae  2679
# 6  Scrophulariaceae  2578
# 7      Brassicaceae  2438
# 8         Liliaceae  1656
# 9      Polygonaceae  1599
# 10        Lamiaceae  1442
# # ... with 533 more rows

# so the asteraceae family is very large. 
# Asteraceae or Compositae (commonly referred to as the aster, daisy, composite,[4] or sunflower family) is an exceedingly large and widespread family of flowering plants (Angiospermae).[5][6]
# 
# The Fabaceae, Leguminosae or Papilionaceae,[6] commonly known as the legume, pea, or bean family, are a large and economically important family of flowering plants. It includes trees, shrubs, and perennial or annual herbaceous plants, which are easily recognized by their fruit (legume) and their compound, stipulated leaves. 
# 
# Poaceae (English pronunciation: /poʊˈeɪ.siˌiː/[citation needed]) or Gramineae is a large and nearly ubiquitous family of monocotyledonous flowering plants known as grasses.
# 
# 
# when we look at least common:
# Bryoxiphiaceae, Blasiaceae, Asterothyriaceae all 2
# 
# Bryoxiphium is the only genus of moss in family Bryoxiphiaceae, described as a genus in 1869.[2][1][3][4]
# Bryoxiphium is native to North America, East Asia, and certain islands in the North Atlantic. [5]
# Blasiaceae is a family of liverworts with only two species: Blasia pusilla (a circumboreal species) and Cavicularia densa (found only in Japan). 
# 
plantlist$`Common Name` %>% is.na() %>% sum() # 43043 are empty, have no common name

# probable to separate names out and cluster with the same name. 
# tidyr seperate first, space, second, rest
#  
