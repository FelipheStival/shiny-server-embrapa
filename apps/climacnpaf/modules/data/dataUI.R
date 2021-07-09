#==================================================================
# data UI
#==================================================================
itemdataUI = function(){

  menuItem(text = "Selecione a data",
           icon = icon("calendar"),
           dateRangeInput(inputId = "periodoData",
                          label = "Selecione o periodo:",
                          start = NULL,
                          end = NULL
                          )
  )
  
}