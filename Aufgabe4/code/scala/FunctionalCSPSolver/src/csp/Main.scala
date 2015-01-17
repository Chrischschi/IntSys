package csp

/**
 * Created by christian on 17.01.15.
 */
object Main {


  def main(args: Array[String]) = {
    val einstein = EinsteinModel.model
    println(einstein)

    val solved = Solver.solve(einstein)

    println(solved)
  }

}
