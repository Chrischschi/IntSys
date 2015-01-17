package csp

import csp.Solver.{Vars, ConstraintNet}

/**
 * Created by christian on 12.01.15.
 */
object Data {
  /**
   * Hole wertebereich von variable mit dem namen "name" aus der liste von variablen
   * "variables"
   */
  def getDomain(name: Symbol, variables: Vars ): List[Int] = {
    variables.find {tuple => tuple._1 == name }.get._2 //get ist nicht exception-safe
  }

  def updatedDomain(name: Symbol, newDomain: List[Int], variables: Vars): Vars = {

    def updatedDomain_(name: Symbol, currDomain: List[Int],newDomain: List[Int], updateFlag: Boolean) = {
      if (updateFlag) {
        (name, newDomain) //return updated
      } else {
        (name, currDomain) //return unchanged
      }
    }

    val variablesNew = for {
      (x,currDomain) <- variables
    } yield updatedDomain_(name, currDomain,newDomain, name == x)


    variablesNew
  }

}
