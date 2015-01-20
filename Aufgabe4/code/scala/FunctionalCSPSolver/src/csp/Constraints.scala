package csp

/**
 * Created on 12.01.15.
 */
object Constraints {

  //Typ für methodensignatur
  sealed trait Constraint

  //zwei variablen sind gleich
  case object Eq extends Constraint

  //eine Variable ist gleich zu einem bestimmten wert
  case class EqToVal(value: Int) extends Constraint

  //zwei Variablen sind ungleich
  case object Neq extends Constraint

  //... ist benachtbart zu ...
  case object Neighbour extends Constraint

  //... ist linker nachbar von ...
  case object LeftNeighbour extends Constraint

  //... ist rechter nachbar von
  case object RightNeighbour extends Constraint


  //weitere constraints
  case object LessThan extends Constraint

  case object GreaterThan extends Constraint

  // l*factor = r
  case class Mul(factor: Int) extends Constraint



  def evalConstraint(x: Int, y: Int, constraint: Constraint): Boolean = constraint match {
      case Eq => x == y
      case EqToVal(value) => x == value
      case Neq => x != y
      case Neighbour => math.abs(x - y) == 1
      case LeftNeighbour => x - y == 1
      case RightNeighbour => y - x == 1
      case LessThan => x < y
      case GreaterThan => x > y
      case Mul(factor) => x * factor == y
      case _ => throw new IllegalArgumentException("Unknown Constraint.")
    }


}
