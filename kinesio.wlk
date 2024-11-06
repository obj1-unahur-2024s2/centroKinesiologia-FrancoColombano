class Paciente {
  var edad
  var nivelFortaleza
  var nivelDolor
  const property rutina = []

  method edad() = edad 
  method nivelFortaleza() = nivelFortaleza
  method nivelDolor() = nivelDolor

  method agregarAnio() {
    edad += 1
  }

  method disminuirDolor(valor) {
    nivelDolor = 0.max(nivelDolor - valor)
  }

  method aumentarFortaleza(valor) {
    nivelFortaleza += valor
  }

  method cargarRutina(lista) {
    rutina.clear()
    rutina.addAll(lista)
  }

  method puedeUsar(aparato) = aparato.condicionDeUso(self)

  method usar(aparato) {
    if (self.puedeUsar(aparato))
      aparato.consecuenciaDeUso(self)
  }

  method puedeHacerRutina() =
    rutina.all {aparato => self.puedeUsar(aparato)}

  method realizarRutina() {
    rutina.forEach {aparato => self.usar(aparato)}
  }
}

class Resistente inherits Paciente {
  override method realizarRutina() {
    super()
    self.aumentarFortaleza(rutina.size())
  }
}

class Caprichoso inherits Paciente {
  override method puedeHacerRutina() {
    return
    self.algunAparatoRojo() and super()
  }

  method algunAparatoRojo() =
    rutina.any({aparato => aparato.color() == "Rojo"})

  override method realizarRutina() {
    super()
    super()
  }
}

class RapidaRecuperacion inherits Paciente {
  override method realizarRutina(){
    super()
    self.disminuirDolor(valorDecremento.valor())
  }
}

object valorDecremento {
  var property valor = 3 
}


class Aparato{
  var property color = "blanco" 
  method condicionDeUso(paciente)
  method consecuenciaDeUso(paciente)
  method necesitaMantenimiento() = false
  method recibirMantenimiento()
}

class Magneto inherits Aparato{
  var puntosImantacion = 800

  override method condicionDeUso(paciente) = true

  override method consecuenciaDeUso(paciente) {
    paciente.disminuirDolor(
      paciente.nivelDolor() * 0.1)
    puntosImantacion = 0.max(puntosImantacion-1)
  }

  override method necesitaMantenimiento() = 
    puntosImantacion < 100

  override method recibirMantenimiento() {
    if (self.necesitaMantenimiento())
      puntosImantacion += 500
  }
}

class Bicicleta inherits Aparato{
  var cantDesajuste = 0
  var cantPerdidas = 0

  override method condicionDeUso(paciente) = paciente.edad() > 8

  override method necesitaMantenimiento() =
    cantDesajuste >= 10 or
    cantPerdidas >= 5

  override method recibirMantenimiento() {
    if (self.necesitaMantenimiento())
    cantDesajuste = 0
    cantPerdidas = 0
  }

  override method consecuenciaDeUso(paciente) {
    if (paciente.nivelDolor()>30)
      cantDesajuste += 1
      if (paciente.edad().between(30, 50))
        cantPerdidas += 1
    paciente.disminuirDolor(4)
    paciente.aumentarFortaleza(3)
  }
}

class Minitramp inherits Aparato{
  override method condicionDeUso(paciente) = 
    paciente.nivelDolor() < 20

  override method consecuenciaDeUso(paciente) {
    paciente.aumentarFortaleza(
     paciente.edad() * 0.1)
  }

  override method recibirMantenimiento() {}
}

object centro {
  const pacientes = []
  const aparatos = []

  method agregarPacientes(lista) { 
    pacientes.addAll(lista)
  }

  method agregarAparatos(lista) { 
    aparatos.addAll(lista)
  }

  method colorAparatos() =
    aparatos.map({a => a.color()}).asSet()

  method pacientesMenoresA(edad) = 
    pacientes.filter {p => p.edad()<edad}

  method cantNoPuedenCumplirRutina() =
    pacientes.count {
      p => not p.puedeHacerRutina()
    }

  method estaEnCondiciones() =
    not aparatos.all {a => a.necesitaMantenimiento()} 

  method estaComplicado() = 
    aparatos.count{a => a.necesitaMantenimiento()} >=
    aparatos.size().div(2)

  method visitaDeTecnico() {
    aparatos.forEach({a => a.recibirMantenimiento()})
  }
}

