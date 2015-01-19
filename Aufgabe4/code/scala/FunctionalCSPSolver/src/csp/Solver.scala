package csp

import csp.Constraints.Constraint

/**
 * Created by christian on 12.01.15.
 */
object Solver {

  /** Type aliase, da die tupel-typ notation etwas unhandlich ist. */
  type Vars = List[(Symbol, List[Int])]
  type Arcs = List[(Symbol,Symbol,List[Constraint])]

  case class ConstraintNet(variables: Vars, arcs: Arcs)

  def solve(net: ConstraintNet): (ConstraintNet,Boolean) = {
    //1. knotenkonsistenz
    val withoutUnary = Algorithms.nodeConsistency(net)
    println(s"Nach Knotenkonsistenz: $withoutUnary" )
    //2. einmal AC3-LA aufrufen
    val (prunedFirstTime,consistent) = Algorithms.arcConsistency3LookAhead(withoutUnary,withoutUnary.variables)
    println(s"Nach erstem aufruf von AC3-LA: $prunedFirstTime, consistent = $consistent")
    //3. in die backtracking-schleife einsteigen
    solve_(prunedFirstTime,List[(Symbol, List[Int])](),prunedFirstTime.variables)
  }

  private def solve_(net: ConstraintNet, pastVars: Vars, restVars: Vars): (ConstraintNet,Boolean) = {
    if(restVars.isEmpty) {
      //constraint-netz gelöst, alle variablen belegt
      (net, true)
    } else if (restVars.head._2.isEmpty) {
      //wir können eine variable nicht mehr erfüllen -> Backtracking verwenden
      (net, false)
    } else {
      val v = restVars.head; val restV = restVars.tail

      val (name,_) = v
      val domain = Data.getDomain(name, net.variables)
      //constraint-variable einen wert zuweisen = wertebereich auf 1 element einschränken
      val constraintNetVariableSet = net.copy(variables = Data.updatedDomain(name,List(domain.head),net.variables))
      val (constraintNetPruned, consistent) = Algorithms.arcConsistency3LookAhead(constraintNetVariableSet,restVars)

      val nextDomain = Data.updatedDomain(name,domain.tail,net.variables)
      val nextNet = net.copy(variables = nextDomain)

      val cspVarNew = (name,domain.tail)
      if (consistent)
        solve__(solve_(constraintNetPruned, pastVars ++ List(v),restV),nextNet,cspVarNew,pastVars,restV)
      else
        solve_(nextNet, pastVars, List(cspVarNew) ++ restV)
    }

  }

  private def solve__(solutionPair: (ConstraintNet,Boolean), nextNet: ConstraintNet, cNewVar: (Symbol,List[Int]),
                      pastVars: Vars, restV: Vars) =
  {
    if(solutionPair._2 == true)
      solutionPair
    else
      solve_(nextNet, pastVars, List(cNewVar) ++ restV)
  }


}
