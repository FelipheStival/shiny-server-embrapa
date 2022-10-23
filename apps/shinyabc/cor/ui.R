# Registrando rotas.
router = make_router(
  route("/", bemVindoUI()),
  route("clima", climaUI),
  route("experimentos", experimentosUI),
  route("gerenciar", gerenciarUI),
  route("doencas", doencasUI)
)

# Pagina reponsavel pelo redirecionamento.
ui <- secure_app(fluidPage(router$ui))
