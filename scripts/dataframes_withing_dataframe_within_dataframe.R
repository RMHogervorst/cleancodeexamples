# dataframes in dataframes in dataframes
#

# frequency, gender, year, opleidingsfaseactuee
#  gemeente en gemeentenummer binnen een provincie
#  croho onderdeel / 
#  opleidingnaam binnen opleidingsfase
#  
#  6 opleidingsfase actueel
#  
# 8 provincies
# 15 gemeenten, gemeentennummers
# 20namen , 20 brin nummer
# 10 croho onderdeel
# 896 opleidingsscode actueel
# 866 opleidingsnaam
# 
# 56821 
duo2015_tidy %>% filter(OPLEIDINGSCODE.ACTUEEL == "56821") %>% View
# eindresultaat is per 
# alles tot opleidingsvorm is identiek, darn aper fase, jaar gender frequnecu
per_instelling <- duo2015_tidy %>% 
        group_by_(.dots = names(duo2015_tidy)[1:11]) %>% 
        nest(.key = opleiding) %>% 
        group_by(INSTELLINGSNAAM.ACTUEEL) %>% 
        nest(.key = INSTELLING) 
# per instelling is nu 

# per lm(FREQUENCY ~ YEAR + GENDER, data = .)
# 

test <-duo2015_tidy %>% 
        group_by_(.dots = names(duo2015_tidy)[1:11]) %>% 
        nest(.key = opleiding) %>% 
        mutate(lmmod = map(opleiding,  ~lm(FREQUENCY ~ YEAR + GENDER, data = .)),
               augment = dmap(broom::augment(lmod)))

broom::tidy(test$lmmod[[1]])
