

 ui = dashboardPage(
   #========================header=========================
    
   dashboardHeader( title =  APP_NAME),
   
   #=======================================================
   
   
   #=======================SiderBar========================
   
   dashboardSidebar(
      
      sidebarMenu(
         itemMenuMapa(),
         itemlocalidadeUI(),
         itemdataUI(),
         itemMenuTabela(),
         itemMenuGrafico(),
         itemSobreUI()
      )),
   
   #========================================================
   
   
   #=======================body=============================
   
   dashboardBody(
      includeCSS("www//css//style.css"),
      useShinyjs(),
      tabItems(
         createMapaUI(),
         tabelaUI(),
         graficoUI(),
         createSobreUI()
      )
   )
   
   #========================================================
 )
