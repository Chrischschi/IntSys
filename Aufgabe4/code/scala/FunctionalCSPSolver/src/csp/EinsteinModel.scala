package csp

import csp.Constraints._
import csp.Solver.ConstraintNet

/**
 * Created by christian on 12.01.15.
 */
object EinsteinModel {

  val model: ConstraintNet = {
    val variables = for {
      name <- List(
        'daene,'deutscher,'brite,'schwede,'norweger,
        'rot,'weiß,'blau,'grün,'gelb,
        'hund,'fisch,'pferd,'katze,'vogel,
        'dunhill,'pallmall,'marlboro,'rothmanns,'winfield,
        'milch,'tee,'kaffee,'bier,'wasser
      )
    } yield (name,List(1,2,3,4,5))

    val constraints = List(
    ('daene,'deutscher,List(Neq)),
    ('daene,'brite,List(Neq)),
    ('daene,'schwede,List(Neq)),
    ('daene,'norweger,List(Neq)),

    ('deutscher,'daene,List(Neq)),
    ('deutscher,'brite,List(Neq)),
    ('deutscher,'schwede,List(Neq)),
    ('deutscher,'norweger,List(Neq)),

    ('brite,'daene,List(Neq)),
    ('brite,'deutscher,List(Neq)),
    ('brite,'schwede,List(Neq)),
    ('brite,'norweger,List(Neq)),

    ('schwede,'daene,List(Neq)),
    ('schwede,'deutscher,List(Neq)),
    ('schwede,'brite,List(Neq)),
    ('schwede,'norweger,List(Neq)),

    ('norweger,'daene,List(Neq)),
    ('norweger,'deutscher,List(Neq)),
    ('norweger,'brite,List(Neq)),
    ('norweger,'schwede,List(Neq)),

    ('rot,'weiß,List(Neq)),
    ('rot,'blau,List(Neq)),
    ('rot,'grün,List(Neq)),
    ('rot,'gelb,List(Neq)),

    ('weiß,'rot,List(Neq)),
    ('weiß,'blau,List(Neq)),
    ('weiß,'grün,List(Neq,LeftNeighbour)),
    ('weiß,'gelb,List(Neq)),

    ('blau,'rot,List(Neq)),
    ('blau,'weiß,List(Neq)),
    ('blau,'grün,List(Neq)),
    ('blau,'gelb,List(Neq)),

    ('grün,'rot,List(Neq)),
    ('grün,'weiß,List(Neq,LeftNeighbour)),
    ('grün,'blau,List(Neq)),
    ('grün,'gelb,List(Neq)),

    ('gelb,'rot,List(Neq)),
    ('gelb,'weiß,List(Neq)),
    ('gelb,'blau,List(Neq)),
    ('gelb,'grün,List(Neq)),


    ('hund,'fisch,List(Neq)),
    ('hund,'pferd,List(Neq)),
    ('hund,'katze,List(Neq)),
    ('hund,'vogel,List(Neq)),

    ('fisch,'hund,List(Neq)),
    ('fisch,'pferd,List(Neq)),
    ('fisch,'katze,List(Neq)),
    ('fisch,'vogel,List(Neq)),

    ('pferd,'hund,List(Neq)),
    ('pferd,'fisch,List(Neq)),
    ('pferd,'katze,List(Neq)),
    ('pferd,'vogel,List(Neq)),

    ('katze,'hund,List(Neq)),
    ('katze,'fisch,List(Neq)),
    ('katze,'pferd,List(Neq)),
    ('katze,'vogel,List(Neq)),

    ('vogel,'hund,List(Neq)),
    ('vogel,'fisch,List(Neq)),
    ('vogel,'pferd,List(Neq)),
    ('vogel,'katze,List(Neq)),


    ('dunhill,'pallmall,List(Neq)),
    ('dunhill,'marlboro,List(Neq)),
    ('dunhill,'rothmanns,List(Neq)),
    ('dunhill,'winfield,List(Neq)),

    ('pallmall,'dunhill,List(Neq)),
    ('pallmall,'marlboro,List(Neq)),
    ('pallmall,'rothmanns,List(Neq)),
    ('pallmall,'winfield,List(Neq)),

    ('marlboro,'dunhill,List(Neq)),
    ('marlboro,'pallmall,List(Neq)),
    ('marlboro,'rothmanns,List(Neq)),
    ('marlboro,'winfield,List(Neq)),

    ('rothmanns,'dunhill,List(Neq)),
    ('rothmanns,'pallmall,List(Neq)),
    ('rothmanns,'marlboro,List(Neq)),
    ('rothmanns,'winfield,List(Neq)),

    ('winfield,'dunhill,List(Neq)),
    ('winfield,'pallmall,List(Neq)),
    ('winfield,'marlboro,List(Neq)),
    ('winfield,'rothmanns,List(Neq)),


    ('milch,'tee,List(Neq)),
    ('milch,'kaffee,List(Neq)),
    ('milch,'bier,List(Neq)),
    ('milch,'wasser,List(Neq)),

    ('tee,'milch,List(Neq)),
    ('tee,'kaffee,List(Neq)),
    ('tee,'bier,List(Neq)),
    ('tee,'wasser,List(Neq)),

    ('kaffee,'milch,List(Neq)),
    ('kaffee,'tee,List(Neq)),
    ('kaffee,'bier,List(Neq)),
    ('kaffee,'wasser,List(Neq)),

    ('bier,'milch,List(Neq)),
    ('bier,'tee,List(Neq)),
    ('bier,'kaffee,List(Neq)),
    ('bier,'wasser,List(Neq)),

    ('wasser,'milch,List(Neq)),
    ('wasser,'tee,List(Neq)),
    ('wasser,'kaffee,List(Neq)),
    ('wasser,'bier,List(Neq)),

    ('tee,'daene,List(Eq)),
    ('daene,'tee,List(Eq)),

    ('brite,'rot,List(Eq)),
    ('rot,'brite,List(Eq)),

    ('deutscher,'rothmanns,List(Eq)),
    ('rothmanns,'deutscher,List(Eq)),

    ('schwede,'hund,List(Eq)),
    ('hund,'schwede,List(Eq)),

    ('gelb,'dunhill,List(Eq)),
    ('dunhill,'gelb,List(Eq)),

    ('grün,'kaffee,List(Eq)),
    ('kaffee,'grün,List(Eq)),

    ('bier,'winfield,List(Eq)),
    ('winfield,'bier ,List(Eq)),

    ('pallmall,'vogel,List(Eq)),
    ('vogel,'pallmall,List(Eq)),

    ('norweger,'norweger,List(EqToVal(1))),
    ('milch,'milch,List(EqToVal(3))),

    ('norweger,'blau,List(Neighbour)),
    ('blau,'norweger,List(Neighbour)),

    ('pferd,'dunhill,List(Neighbour)),
    ('dunhill,'pferd,List(Neighbour)),

    ('marlboro,'katze,List(Neighbour)),
    ('katze,'marlboro,List(Neighbour)),

    ('marlboro,'wasser,List(Neighbour)),
    ('wasser,'marlboro,List(Neighbour))

    )
    ConstraintNet(variables, constraints)
  }
}
