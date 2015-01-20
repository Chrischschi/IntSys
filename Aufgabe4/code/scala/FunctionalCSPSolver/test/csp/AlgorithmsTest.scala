package csp


import csp.Constraints.{LessThan, Mul, Eq}
import csp.Solver.ConstraintNet
import csp.Algorithms._
import org.junit.Test
import org.junit.Ignore
import org.junit.Assert._

/**
 * Created by christian on 20.01.15.
 */
class AlgorithmsTest {

  val constraintNetBefore = ConstraintNet(
    variables = for(name <- List('x,'v,'y,'z)) yield (name, List(1,2,3,4)),
    arcs = List(
      ('x,'v, List(Eq)),
      ('x,'z, List(Mul(2))),
      ('x,'z, List(LessThan)),
      ('y,'z, List(Eq))
    )
  )

  @Ignore
  def testAC3_la(): Unit = {

    val constraintNetAfter = ConstraintNet(
      variables = for(name <- List('x,'v,'y,'z)) yield (name, if (name == 'z || name == 'y) List(2,4) else List(1,4)),
      arcs = List(
        ('x,'v, List(Eq)),
        ('x,'z, List(Mul(2))),
        ('x,'z, List(LessThan)),
        ('y,'z, List(Eq))
      )
    )

    val (actual,consistent) = arcConsistency3LookAhead(constraintNetBefore, constraintNetBefore.variables)

    assertTrue(consistent)
    assertEquals(constraintNetAfter,actual)
  }

  @Test
  def testRevise(): Unit = {
    val constraintNetAfter = constraintNetBefore.copy(
      variables = for((v,d) <- constraintNetBefore.variables ) yield if (v == 'x) (v,List(1,2)) else (v,d)
    )
    val (actual,delete) = revise(constraintNetBefore, ('x, 'z, List(Mul(2))))

    assertTrue(delete)
    assertEquals(constraintNetAfter,actual)
  }

  @Test
  def testAC3_la_symmetric(): Unit = {
    val arcs = List(
      ('x,'v, List(Eq)),
      ('x,'z, List(Mul(2))),
      ('x,'z, List(LessThan)),
      ('y,'z, List(Eq))
    )
    val arcsSymmetric = arcs ++ (for {(v1,v2,c) <- arcs } yield (v2,v1,c)).toList
    val netBefore = ConstraintNet(
      variables = for(name <- List('x,'v,'y,'z)) yield (name, List(1,2,3,4)),
      arcs = arcsSymmetric
    )

    val netAfter = ConstraintNet(
      variables = for(name <- List('x,'v,'y,'z)) yield (name, if (name == 'z || name == 'y) List(2,4) else List(1,4)),
      arcs = arcsSymmetric
    )

    val (actual,consistent) = arcConsistency3LookAhead(netBefore, netBefore.variables)

    assertTrue(consistent)
    assertEquals(netAfter,actual)

  }

  /* TODO: Testfall mit allen nationalitaeten und nur all-different constraints, sollte mit ac3_la funktionieren */
  @Test
  def ac3la_allDiff(): Unit = ???

}
