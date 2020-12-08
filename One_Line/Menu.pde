void menu(){
  textoPlano("ONE LINE", 167, 125, 333);
  textoPlano("Jugar (J)", 80, 350, 500);
  textoPlano("Crear (C)", 65, 355, 600);
  textoPlano("Reset (R)", 25, 20, 920);
  textoPlano("Menu (M)", 25, 20, 970);
  if(_frameRate == 5){
    decore();
    _frameRate = 0;
  }
  _frameRate++;
  if(key == 'J' || key == 'j'){
    _estadoActual = 1;
  }else if(key == 'C' || key == 'c'){
    _estadoActual = 2;
  }
}
void decore(){
  int _x, _y, _radio;
  _x = int(random(0, width));
  _y = int(random(0, height));
  _radio = int(random(0, width/3));
  push();
  fill(0, random(255), random(255));
  circle(_x, _y, _radio);
  pop();
}
