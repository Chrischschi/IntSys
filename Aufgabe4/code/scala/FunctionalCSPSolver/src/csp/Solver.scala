package csp

import csp.Constraints.Constraint

/**
 * Created on 12.01.15.
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

  private def solve_(net: ConstraintNet, pastVars: Vars, remainingVars: Vars): (ConstraintNet,Boolean) = {
    if(remainingVars.isEmpty) {
      //constraint-netz gelöst, alle variablen belegt
      (net, true)
    } else if (remainingVars.head._2.isEmpty) {
      //wir können eine variable nicht mehr erfüllen -> Backtracking verwenden
      (net, false)
    } else {
      val currentVar = remainingVars.head; val restVars = remainingVars.tail

      val (name,_) = currentVar
      val domain = Data.getDomain(name, net.variables)
      //constraint-variable einen wert zuweisen = wertebereich auf 1 element einschränken
      val constraintNetVariableSet = net.copy(variables = Data.updatedDomain(name,List(domain.head),net.variables))
      val (constraintNetPruned, consistent) = Algorithms.arcConsistency3LookAhead(constraintNetVariableSet,remainingVars)

      val alternativeVarBindings: List[Int] = domain.tail

      val varsUpdatedWithAlternatives = Data.updatedDomain(name,alternativeVarBindings,net.variables)
      val netWithAlternatives = net.copy(variables = varsUpdatedWithAlternatives)

      val cspVarNew = (name,alternativeVarBindings)
      if (consistent)
        solve__(solve_(constraintNetPruned, pastVars ++ List(currentVar),restVars),netWithAlternatives,cspVarNew,pastVars,restVars)
      else
        solve_(netWithAlternatives, pastVars, List(cspVarNew) ++ restVars)
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
