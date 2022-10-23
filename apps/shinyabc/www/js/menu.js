var menuItem = document.getElementById("container");

/*
* Funcao para redirecionar o usuário clicando nos cartões.
*
*/
menuItem.onclick = function(e){
  let opcao = e.target.innerText;
  let href = window.location.href
   switch (opcao) {
  case 'Clima':
    window.location.href = href + "clima"
    break;
  case 'Doenças':
    window.location.href = href + "doencas"
    break;
  case 'Experimentos':
    window.location.href = href + "experimentos"
    break;
  case 'Agricultor':
    window.location.href = "/Agricultor/";
    break;
  default:
    console.log('Não escolheu nenhum');
  }
  console.log(opcao);
}
