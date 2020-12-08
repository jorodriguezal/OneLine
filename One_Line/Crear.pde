//int[] _tempX, _tempY;
int _grafo = 0;

void crear(){
  push();
  fill(0, 20);
  rect(0, 0, width, height);
  textoPlano("Guerdar (G)", 25, 850, 970);
  textoPlano("Numero Maximo de Nodos = 50", 25, 10, 27);
  pop();
  if(_grafo == 0){
    _niveles.add(new Grafo());
    _grafo++;
  }
  _niveles.get(_niveles.size()-1).dibujoGrafo();
  
  if(mousePressed){
    _niveles.get(_niveles.size()-1).cargarNodoCreador(mouseX, mouseY);
  }
  
  if(keyPressed && (key == 'G' || key == 'g')){
    _niveles.get(_niveles.size()-1).guardar();
    _estadoActual = 0;
  }
}
