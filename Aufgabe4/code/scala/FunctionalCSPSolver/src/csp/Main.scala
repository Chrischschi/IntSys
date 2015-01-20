package csp

import csp.Solver.ConstraintNet

/**
 * Created on 17.01.15.
 */
object Main {


  def prettyPrintSolution(solvedConstraintNet: ConstraintNet): Unit = {
    val varsOfSolution = solvedConstraintNet.variables

    val symbolsAsValues = varsOfSolution groupBy {v => v._2} mapValues {l => l map {elem => elem._1 } }

    val intsAsKeys = for {
      (intList, symbols) <- symbolsAsValues
        int <- intList
    } yield (int,symbols)

    for ((key, List(nationality, color, pet, smoke, drink)) <- intsAsKeys ) {
      println(s"Der $nationality wohnt im ${color}en Haus mit der nummer $key, hat ein/eine/einen $pet als Haustier, " +
        s" raucht gerne $smoke und trinkt gerne $drink.")
    }

  }

  def main(args: Array[String]) = {
    val einstein = EinsteinModel.model
    println(einstein)

    val solved = Solver.solve(einstein)

    println(s"lösung: $solved")

    prettyPrintSolution(solved._1)
  }

}
