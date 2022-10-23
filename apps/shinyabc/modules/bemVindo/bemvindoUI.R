#=====================================================================
# Criar UI pagina bem vindo
# autor: Feliphe Stival Valadares Guiliani
#=====================================================================
bemVindoUI = function() {
  fluidPage(
    includeCSS("www//styles//styles.css"),
    HTML("
    <div id = 'wave-background'>
      <div id = 'container'>
            <div class = 'menu-item' id = 'opcao-clima'>
              <div class = 'menu-item-icon'>
                <img src='icons//clima.png' alt='Icone clima'>
              </div>
              <h7>Clima</h7>
            </div>
            <div class = 'menu-item' id = 'opcao-doencas'>
              <div class = 'menu-item-icon'>
                <img src='icons//doencas.png' alt='Icone clima'>
              </div>
              <h7>Doenças</h7>
            </div>
            <div class = 'menu-item' id = 'opcao-experimentos'>
              <div class = 'menu-item-icon'>
                <img src='icons//experimentos.png' alt='Icone clima'>
              </div>
              <h7>Experimentos</h7>
            </div>
            <div class = 'menu-item' id = 'opcao-agricultor'>
              <div class = 'menu-item-icon'>
                <img src='icons//planta.png' alt='Icone clima'>
              </div>
              <h7>Agricultor</h7>
            </div>
         </div>
    </div>"
    ),
  includeScript("www//js//menu.js")
  )
}