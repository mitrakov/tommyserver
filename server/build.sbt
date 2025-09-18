val http4sVersion = "0.23.30"
val http4sXmlVersion = "0.23.14" // keep it separate from http4sVersion
val http4sJwtVersion = "2.0.4"
val logbackVersion = "1.5.18"
val doobieVersion = "1.0.0-RC9"
val circeVersion = "0.15.0-M1"

organization := "com.mitrakoff.self"
name := "tommyserver"
version := "1.4.16" // !!! change version here, then run "sbt docker:publish; docker push mitrakov/tommy-server:1.2.3"
scalaVersion := "3.4.1"
libraryDependencies ++= Seq(
  "org.http4s"     %% "http4s-ember-server"   % http4sVersion,
  "org.http4s"     %% "http4s-dsl"            % http4sVersion,
  "org.http4s"     %% "http4s-core"           % http4sVersion,
  "org.http4s"     %% "http4s-circe"          % http4sVersion,
  "org.http4s"     %% "http4s-scala-xml"      % http4sXmlVersion,
  "ch.qos.logback"  % "logback-classic"       % logbackVersion,
  "org.tpolecat"   %% "doobie-postgres"       % doobieVersion, // includes org.postgresql.Driver
  "org.tpolecat"   %% "doobie-postgres-circe" % doobieVersion, // json support
  "org.tpolecat"   %% "doobie-hikari"         % doobieVersion, // transactor
  "io.circe"       %% "circe-generic"         % circeVersion,
  "dev.profunktor" %% "http4s-jwt-auth"       % http4sJwtVersion, // JWT support
  "com.github.jwt-scala" %% "jwt-circe" % "10.0.4", // circe codecs for JWT
)

enablePlugins(JavaAppPackaging)

Compile / mainClass := Some("com.mitrakoff.self.Main")
Docker / packageName := "mitrakov/tommy-server"
dockerBaseImage := "adoptopenjdk:11-jre-hotspot"
dockerExposedPorts ++= Seq(8080)
