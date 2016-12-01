# working with nested data
# 
duo2015_tidy <- readr::read_csv("files/duo2015_tidy.csv")
duo_nest <- duo2015_tidy %>% 
        group_by(PROVINCIE, 
                 INSTELLINGSNAAM.ACTUEEL, 
                 OPLEIDINGSNAAM.ACTUEEL,
                 GEMEENTENUMMER, 
                 GEMEENTENAAM,
                 SOORT.INSTELLING,
                 BRIN.NUMMER.ACTUEEL,
                 OPLEIDINGSCODE.ACTUEEL,
                 OPLEIDINGSVORM
                 ) %>% 
        filter(OPLEIDINGSFASE.ACTUEEL == "propedeuse bachelor" ) %>%
        nest(.key = STUDYDETAILS)  

# duo2015_tidy %>%
#         group_by(-YEAR, -GENDER, -FREQUENCY)
# duo2015_tidy %>%
#         group_by_(~)

# verschillende pogingen om iets binnen de dataset ste doen.
duo_nest <-duo_nest %>%
        mutate(MODEL =  map(STUDYDETAILS, ~lm(FREQUENCY ~ YEAR + GENDER, data = .)))
# how zijn de r.squared
duo_nest %>% unnest(MODEL %>% purrr::map(broom::glance)) %>%
        arrange(desc(r.squared))%>%
        ggplot(aes(r.squared)) + geom_density(aes(color = PROVINCIE)) 
# hoe zijn de pwaarden
duo_nest %>% unnest(MODEL %>% purrr::map(broom::glance)) %>%
        arrange(desc(p.value))%>%
        ggplot(aes(p.value)) + geom_density(aes(color = PROVINCIE)) 
        
duo_nest %>% unnest(MODEL %>% purrr::map(broom::tidy))
duo_nest %>% unnest(MODEL %>% purrr::map(broom::augment))
