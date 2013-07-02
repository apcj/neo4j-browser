package org.neo4j.tools.localgraph

import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.factory.GraphDatabaseFactory
import org.neo4j.kernel.GraphDatabaseAPI
import org.neo4j.server.WrappingNeoServerBootstrapper

object LocalGraph extends App {

  private final val DB_PATH: String = "local.graphdb"
  private val graphDb: GraphDatabaseAPI = new GraphDatabaseFactory().newEmbeddedDatabase(DB_PATH).asInstanceOf[GraphDatabaseAPI]
  private val srv = new WrappingNeoServerBootstrapper(graphDb)

  srv.start
  
}