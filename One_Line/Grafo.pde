class Grafo {
  int _seguimientoAnteriorNodosGuardado, _seguimientoActualNodosGuardado;
  ArrayList<Nodo> _nodos;
  String[] _data, _pocisionNodos = new String[0]; 
  String _pocisionesNodoGuardado = "", _matrizRelacionalGuardado = "";
  int[][] _solucionNivel = new int[1000][1000], _tempSolucion; // hay que reiniciar tempSolicion
  
  Grafo(String _fileName, int _noNivel) {
    cargar(_fileName, _noNivel);
    _nodos = new ArrayList<Nodo>();
    for(int i = 0 ; i < _pocisionNodos.length; i = i+2){
      _nodos.add(new Nodo(int(_pocisionNodos[i]), int(_pocisionNodos[i+1])));
    }
  }
  
  Grafo(){
    _seguimientoAnteriorNodosGuardado = 0;
    _seguimientoActualNodosGuardado = 0;
    inicializaEnCreacion();
    _nodos = new ArrayList<Nodo>();
  }
  
  void cargar(String _fileName, int _noNivel){ //carga el grafo desde DATA
     _data = loadStrings(_fileName);
     _pocisionNodos = split(_data[2*_noNivel], " "); // guarda las pocisiones de los nodos (x, y) 
     String [] _tSolucion = split(_data[2*_noNivel+1], " ");
     _solucionNivel = new int[_tSolucion.length][0];
     for(int i = 0; i < _tSolucion.length ; i++){
       _solucionNivel[i] = int(split(_tSolucion[i], ",")); //guarda la solucion como matriz de adyacencia
     }
     crearTempSolucion(); //Crea una matriz de adyacencia auxiliar en 0.
  }
  
  void guardar() { //"Datos.txt"
    for(int i = 0; i < _nodos.size(); i++){
      _solucionNivel[i][i] = 1; // que todo nodo este conectado con el mismo
    }
    for(int i = 0; i < _pocisionNodos.length ; i++){
      if(i == 0){
        _pocisionesNodoGuardado += _pocisionNodos[i];
      }else{
        _pocisionesNodoGuardado += " "+_pocisionNodos[i];
      }
    }
    _dataJuegoTexto = append(_dataJuegoTexto, _pocisionesNodoGuardado); // guardamos las pocisiones de los nodos del grafo que vamos a guardar
    for(int i = 0; i < _nodos.size(); i++){
      if(i > 0){
        _matrizRelacionalGuardado += " ";
      }
      for(int j = 0; j < _nodos.size(); j++){
        if(j == (_nodos.size()-1)){
          _matrizRelacionalGuardado += _solucionNivel[i][j]+"";
        }else{
          _matrizRelacionalGuardado += _solucionNivel[i][j]+",";
        }
      }
    }
    _dataJuegoTexto = append(_dataJuegoTexto, _matrizRelacionalGuardado); // guardamos la matriz de adyacencia del nuevo grafo
    
    saveStrings("Datos.txt", _dataJuegoTexto);
  }
  
  void dibujoGrafo() {
    aristas();
    for(Nodo nodo : _nodos){
      nodo.dibujoNodo();
    }
  }
  
  int seleccionPrimerNodo(int _tempX, int _tempY){ // aqui se pasa a la funcion del nodo en el que se verifica si el mouse esta dentro del nodo o no.
    boolean _dentro  = false;
    int i = -1;
    for(Nodo nodo : _nodos){ //revisa todos los nodos del grafo
      i++;
      _dentro = nodo.dentro(_tempX, _tempY);
      if(_dentro){
        return i;
      }
    }
    return -1;
  }
  
  int seleccionSiguienteNodo(int _n, int _tempX, int _tempY){
    
    push();
    strokeWeight(width/50);
    stroke(0, 255, 255);
    line(_nodos.get(_n).recuperaX(), _nodos.get(_n).recuperaY(), mouseX, mouseY);
    pop();
    
    boolean _dentro  = false;
    int i = -1;
    for(Nodo nodo : _nodos){
      i++;
      _dentro = nodo.dentro(_tempX, _tempY);
      if(_dentro && _tempSolucion[i][_n] == 0 && _solucionNivel[i][_n] == 1){
        _tempSolucion[i][_n] = 1;
        _tempSolucion[_n][i] = 1;
        return i;
      }
    }
    return _n;
  }
  
  void aristas(){
    if(_nodos.size() > 1){
      for(int i = 0; i < _nodos.size(); i++){
        for(int j = 0; j < _nodos.size(); j++){
          if(int(_solucionNivel[i][j]) == 1 && int(_tempSolucion[i][j]) == 0){
            push();
            strokeWeight(width/35);
            stroke(255);
            line((float(_pocisionNodos[i*2])*width)/1000,(float(_pocisionNodos[i*2+1])*height)/1000,(float(_pocisionNodos[j*2])*width)/1000,(float(_pocisionNodos[j*2+1])*height)/1000);
            pop();
          }else if(int(_solucionNivel[i][j]) == 1 && int(_tempSolucion[i][j]) == 1){
            push();
            strokeWeight(width/35);
            stroke(0, 255, 255);
            line((float(_pocisionNodos[i*2])*width)/1000,(float(_pocisionNodos[i*2+1])*height)/1000,(float(_pocisionNodos[j*2])*width)/1000,(float(_pocisionNodos[j*2+1])*height)/1000);
            pop();
          }
        }
      }
    }
  }
  
  void crearTempSolucion(){
    _tempSolucion = new int[_solucionNivel.length][_solucionNivel.length];
    for(int i = 0; i < _solucionNivel.length ; i++){
      for(int j = 0; j < _solucionNivel[i].length ; j++){
        _tempSolucion[i][j] = 0;
      }
    }
  }
  
  void inicializaEnCreacion(){
    crearTempSolucion();
    for(int i = 0; i < _solucionNivel.length ; i++){
      for(int j = 0; j < _solucionNivel[i].length ; j++){
        _solucionNivel[i][j] = 0;
      }
    }
  }
  
  boolean Igualdad() { // saber si se completo el nivel
    if (Arrays.deepEquals(_solucionNivel, _tempSolucion)){ //si estas matrices son iguales, entonces
      return true;
    }else{
      return false;
    }
  }
  
  void cargarNodoCreador(int _tempX, int _tempY){
    int _x = (-50*width)/1000, _y = (-50*height)/1000;
    _x = (_tempX*1000)/width;
    _y = (_tempY*1000)/height;
    
    if(!pertenenciaNodoCreador(_tempX, _tempY)){
      _nodos.add(new Nodo(_x, _y));
      _pocisionNodos = append(_pocisionNodos, _x + "");
      _pocisionNodos = append(_pocisionNodos, _y + "");
      _seguimientoActualNodosGuardado = (_nodos.size()-1);
      _solucionNivel[_seguimientoAnteriorNodosGuardado][_seguimientoActualNodosGuardado] = 1;
      _solucionNivel[_seguimientoActualNodosGuardado][_seguimientoAnteriorNodosGuardado] = 1;
    }else if(pertenenciaNodoCreador(_tempX, _tempY)){
      _seguimientoActualNodosGuardado = numeroPertenenciaNodoCreador(_tempX, _tempY);
      _solucionNivel[_seguimientoAnteriorNodosGuardado][_seguimientoActualNodosGuardado] = 1;
      _solucionNivel[_seguimientoActualNodosGuardado][_seguimientoAnteriorNodosGuardado] = 1;
    }
    _seguimientoAnteriorNodosGuardado = _seguimientoActualNodosGuardado;
  }
  
  boolean pertenenciaNodoCreador(int _tempX, int _tempY){
    for(Nodo nodo : _nodos){
      if(nodo.dentro(_tempX, _tempY)){
        return true;
      }
    }
    return false;
  }
  
  int numeroPertenenciaNodoCreador(int _tempX, int _tempY){
    int i = -1;
    for(Nodo nodo : _nodos){
      i++;
      if(nodo.dentro(_tempX, _tempY)){
        return i;
      }
    }
    return 0;
  }
}
