library("tidytuesdayR")

tuesday_data = tt_load(2020, week = 32)
df_names = names(tuesday_data)

if(length(df_names) < 1){
  print("No data exists")
}else{
  for(i in 1:length(df_names)){
    write.csv(
      tuesday_data[[df_names[i]]],
      paste0('./data/', df_names[i], '.csv'),
      row.names = FALSE
    )
    
    msg = paste0('Saved ', df_names[i], ' csv file to data directory')
    print(msg)
  }
}
