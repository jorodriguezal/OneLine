import java.util.Arrays;

ArrayList<Grafo> _niveles;
ArrayList<Nodo> _nodos;
int _nivelActual = 0, _n, _estadoActual = 0, _frameRate = 0;
boolean _seleccionNodo = false, _siguienteNivel = false;
String[] _dataJuegoTexto;

void settings() {
  size(650, 650);
}

void setup() {
  _niveles = new ArrayList<Grafo>();
  _dataJuegoTexto = loadStrings("Datos.txt");
  for(int i = 0; i < (_dataJuegoTexto.length)/2 ; i++){
    _niveles.add(new Grafo("Datos.txt", i));
  }
}

void draw() {
  push();
  fill(0, 20);
  rect(0, 0, width, height);
  pop();
  if(_estadoActual == 1 && (key == 'M' || key == 'm')){ //Reset y vuelve al menu estando en estado de juego;
    _niveles.get(_nivelActual).crearTempSolucion();
    _seleccionNodo = false;
    _estadoActual = 0;
  }
  if(_estadoActual == 0){ // estado de menu
    menu();
  }else if(_estadoActual == 1){ // estado de juego
    if(key == 'R' || key == 'r'){ // oprime la letra para reset
      _niveles.get(_nivelActual).crearTempSolucion(); // Reset a la matriz de adyacencia temp de la solucion del nivel
      key = '|'; //pone la variable key en cualquier otro valor que no sea Reset (R)
      _seleccionNodo = false; // des_selecciona el nodo por el que vamos a recorrer
    }
    comprobarIgualdad(); // para saber si se completo el nivel.
    _niveles.get(_nivelActual).dibujoGrafo(); //este es para dibujar los diferentes grafos del nivel.
    Jugar();
  }else if(_estadoActual == 3 && _nivelActual < _niveles.size()-1){// estado entre niveles
    CambioNivel("Siguiente Nivel (N)", 'N', 'n');
  }else if(_estadoActual == 3 && _nivelActual == _niveles.size()-1){// estado entre penultimo nivel y ultimo
    CambioNivel("Comenzar de nuevo (C)", 'C', 'c');
  }else if(_estadoActual == 2){ // estado de creacion;
    crear();
  }
}

void Jugar(){
  if(_estadoActual == 1){ // osea estado de juego
    if(_seleccionNodo == false){ //osea ningun nodo esta seleccionado
      _n = _niveles.get(_nivelActual).seleccionPrimerNodo(mouseX, mouseY); //_n es un numero de nodo dentro del grafo
      if(_n != -1){
        _seleccionNodo = true;
      }
    }else{ // si ya tiene un nodo seleccionado 
      _n = _niveles.get(_nivelActual).seleccionSiguienteNodo(_n, mouseX, mouseY);
    }
  }
}

void comprobarIgualdad(){ // saber si se completo el nivel actual
  if(_niveles.get(_nivelActual).Igualdad()){
    _niveles.get(_nivelActual).crearTempSolucion();
    _seleccionNodo = false;
    _estadoActual = 3;
    key = '°';
  }
}

void CambioNivel(String _tempTexto, char _tempCaracterM, char _tempCaracterm){ // frames de cambio de nivel
  push();
  fill(0);
  rect(0, 0, width, height);
  pop();
  textoPlano("Nivel Completo "+(_nivelActual+1), 80, 125, 333);
  textoPlano("Intentar de nuevo (I)", 50, 200, 500);
  textoPlano(_tempTexto, 40, 200, 570);
  if(key == 'I' || key == 'i'){ // intentar de neuvo
    _estadoActual = 1;
  }
  if(key == _tempCaracterM || key == _tempCaracterm && _tempCaracterM == 'N'){ //next lvl
    _nivelActual++;
    _estadoActual = 1;
  }else if(key == _tempCaracterM || key == _tempCaracterm && _tempCaracterM == 'C'){ //comenzar de nuevo
    _nivelActual = 0;
    _estadoActual = 1;
  }
}

void textoPlano(String _tempTexto, int _tempTamanio, int _tempPocisionX, int _tempPocisionY){
  push();
  fill(255);
  textSize((_tempTamanio*height)/1000);
  text(_tempTexto, (_tempPocisionX*height)/1000, (_tempPocisionY*width)/1000);
  pop();
}
