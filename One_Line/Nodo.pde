class Nodo {
  
  float _x, _y, _radio;
  color _color;
  
  Nodo(int tempX, int tempY) {
    _x = (tempX*width)/1000;
    _y = (tempY*height)/1000;
    _radio = width/15;
    _color = (color(0, 255, 255));
  }
  void dibujoNodo() {
    push();
    stroke(_color);
    circle(_x, _y,_radio);
    pop();
  }
  boolean dentro(int _tempX, int _tempY){
    if(dist(_tempX, _tempY, _x, _y) < _radio/2){ // verifica segun el radio de los nodos si el mouse esta dentro del nodo.
      return true;
    }else{
      return false;
    }
  }
  float recuperaX(){
    return _x;
  }
  float recuperaY(){
    return _y;
  }
}
