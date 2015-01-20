package csp

import csp.Constraints.Constraint
import csp.Solver.{Arcs, Vars, ConstraintNet}

/**
 * Created by christian on 12.01.15.
 */
object Algorithms {

  def arcConsistency3LookAhead(net: ConstraintNet, vars: Vars): (ConstraintNet,Boolean) = {
    val currVar :: restVars = vars
    val q = getArcs(net, currVar._1, restVars)
    ac3la_while(q, net, vars, true)
  }

  def revise(net: ConstraintNet, arc: (Symbol, Symbol, List[Constraint])): (ConstraintNet, Boolean) = {
    val (source, target, constraints) = arc
    val List((src, srcDomain)) = net.variables.filter { t =>
        val (s, _) = t
        s == source
    }
    val List((_,targetDomain)) = net.variables.filter { t =>
       val (dest, _) = t
       dest == target
    }

    val (accumulator, delete) = reviseForEachX(srcDomain, targetDomain, constraints)

    val newVars = Data.updatedDomain(source, accumulator, net.variables)

    (net.copy(variables = newVars), delete)
  }


  def satisfiesBinary(constraints: List[Constraint], x: Int, y: Int): Boolean = {
    constraints.forall(binC => Constraints.evalConstraint(x,y,binC))
  }

  def reviseForEachX(domainX: List[Int], domainY: List[Int], constraints: List[Constraint]): (List[Int], Boolean) = {
    /*
    for each X in Di do
    if there is no such Y in Dj such that (X,Y) is consistent,
    then
       delete X from Di;
       DELETE <- true;
      endif;
     endfor;
     */

    val updatedDomainX = for {
      x <- domainX
      if domainY.exists(y => satisfiesBinary(constraints,x,y))
    } yield x

    val delete = updatedDomainX != domainX //wenn die listen unterschiedlich sind, dann wurde etwas aktualisiert

    (updatedDomainX,delete)

    }

  private
  def ac3la_while(q: Arcs, net: ConstraintNet, remainingVars: Vars, consistent: Boolean): (ConstraintNet,Boolean) = {
    if (consistent) {
      if (q.isEmpty) {
        (net, true)
      } else {
        //select and delete any arc from Q
        val anyArc :: tailArcs = q
        val (newNet, delete) = revise(net, anyArc)
        val (v_k, v_m, _) = anyArc
        val domainOfVk: List[Int] = Data.getDomain(v_k, newNet.variables)

        if (delete) {
          val qNew = myUnion(tailArcs, newNet.arcs, remainingVars, v_m, v_k)
          ac3la_while(qNew, newNet, remainingVars, domainOfVk.size != 0)
        } else {
          ac3la_while(tailArcs, newNet, remainingVars, domainOfVk.size != 0)
        }
      }
    } else {
      (null, false)
    }
  }

  def getArcs(net: ConstraintNet, varName: Symbol, restVars: Vars): Arcs = {
    val arcs = net.arcs
    arcs.filter {
      t =>
        val (source, target, _) = t
        varMember(source, restVars) && varName == target
    }
  }

  def myUnion(resultArc: Arcs, allArcs: Arcs, restVars: Vars, v_m: Symbol, v_k: Symbol) = {
    val newList = for {
      (source, target, constraints) <- allArcs
      if source != v_k && source != v_m && v_k == target && varMember(source,restVars)
    } yield (source, target, constraints)
    resultArc ++ newList
  }

  def varMember(source: Symbol, restVars: Vars): Boolean = {
    restVars.count(t => t._1 == source) == 1
  }

  /** Prüfe, ob dieser wert eine menge von unären constraints erfüllt.
    *
    * @param constraints
    * @param i
    * @return true wenn i alle constraints in 'constraints' erfüllt
    */
  def satisfiesUnary(constraints: List[Constraint], i: Int): Boolean = {
    constraints.forall(c => Constraints.evalConstraint(i,i,c))
  }

  def nodeConsistency(net: ConstraintNet): ConstraintNet = {

    def nodeConsistency_(vars: Vars, arcs: Arcs): Vars = {
      if (arcs.isEmpty) {
        vars
      } else {
        val (name,_,constraints) = arcs.head; val rest = arcs.tail
        val domainBefore = Data.getDomain(name, vars)
        val domainAfter = domainBefore.filter(x => satisfiesUnary(constraints,x))
        val varsNew: Vars = Data.updatedDomain(name,domainAfter,vars)
        nodeConsistency_(varsNew, rest)
      }
    }
    val prunedVars = nodeConsistency_(net.variables,net.arcs.filter(a => a._1 == a._2))
    ConstraintNet(prunedVars, net.arcs)
  }



}
