package com.mitrakoff.self.tommyannals

import com.mitrakoff.self.auth.Id
import io.circe.{Codec, Encoder, Json}
import io.circe.generic.semiauto.{deriveCodec, deriveEncoder}
import java.time.LocalDate

// === Chronicle ===
case class Chronicle(id: Option[Id], date: LocalDate, eventName: String, params: Json, comment: Option[String])

// === Schema Response ===
case class SchemaResponseParam(name: String, description: Option[String], `type`: String, unit: Option[String], defaultValue: Option[String])
case class SchemaResponse(eventName: String, eventDescription: Option[String], params: List[SchemaResponseParam])
// ===

// === CODECS ===
object Chronicle:
  given Codec[Chronicle] = deriveCodec

object SchemaResponse:
  given Encoder[SchemaResponseParam] = deriveEncoder
  given Encoder[SchemaResponse] = deriveEncoder
