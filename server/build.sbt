val http4sVersion = "0.23.33"
val http4sXmlVersion = "0.24.0" // keep it separate from http4sVersion
val http4sJwtVersion = "2.0.12"
val logbackVersion = "1.5.22"
val doobieVersion = "1.0.0-RC11"
val circeVersion = "0.15.0-M1"
val circeJwtVersion = "11.0.3"

// 1. change version here
// 2. make sure to build under x86_64 platform (Apple Silicon will fail on "linux/amd64" platform)
// 3. run:
// sbt docker:publish
// docker login
// docker push mitrakov/tommy-server:1.2.3"
version := "1.5.3"
organization := "com.mitrakoff.self"
name := "tommyserver"
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
  "com.github.jwt-scala" %% "jwt-circe"       % circeJwtVersion,  // circe codecs for JWT
)

enablePlugins(JavaAppPackaging)

Compile / mainClass := Some("com.mitrakoff.self.Main")
Docker / packageName := "mitrakov/tommy-server"
dockerBaseImage := "adoptopenjdk:11-jre-hotspot"
dockerExposedPorts ++= Seq(8080)
