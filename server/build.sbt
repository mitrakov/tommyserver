val http4sVersion = "1.0.0-M38"
val http4sXmlVersion = "1.0.0-M38.1" // keep it separate from http4sVersion
val logbackVersion = "1.5.18"
val doobieVersion = "1.0.0-RC8"
val circeVersion = "0.15.0-M1"

organization := "com.mitrakoff.self"
name := "tommyserver"
version := "25.4.9" // !!! change version here, then run "sbt docker:publish"
scalaVersion := "3.4.1"
libraryDependencies ++= Seq(
  "org.http4s"    %% "http4s-ember-server"   % http4sVersion,
  "org.http4s"    %% "http4s-dsl"            % http4sVersion,
  "org.http4s"    %% "http4s-core"           % http4sVersion,
  "org.http4s"    %% "http4s-circe"          % http4sVersion,
  "org.http4s"    %% "http4s-scala-xml"      % http4sXmlVersion,
  "ch.qos.logback" % "logback-classic"       % logbackVersion,
  "org.tpolecat"  %% "doobie-postgres"       % doobieVersion, // includes org.postgresql.Driver
  "org.tpolecat"  %% "doobie-postgres-circe" % doobieVersion, // json support
  "org.tpolecat"  %% "doobie-hikari"         % doobieVersion,
  "io.circe"      %% "circe-generic"         % circeVersion,
)

enablePlugins(JavaAppPackaging)

Compile / mainClass := Some("com.mitrakoff.self.Main")
Docker / packageName := "mitrakov/tommy-server"
dockerBaseImage := "adoptopenjdk:11-jre-hotspot"
dockerExposedPorts ++= Seq(8080)
