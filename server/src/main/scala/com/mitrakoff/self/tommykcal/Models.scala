package com.mitrakoff.self.tommykcal

import com.mitrakoff.self.auth.Id
import io.circe.{Codec, Decoder, Encoder}
import io.circe.generic.semiauto.{deriveCodec, deriveDecoder, deriveEncoder}
import java.time.LocalDate

// === Meal ===
case class Meal(id: Option[Id], date: LocalDate, name: String, kcalTotal: Int, comment: Option[String])
case class AddMeal(date: LocalDate, productId: Id, weight: Int, comment: Option[String])

// === CODECS ===
object Meal:
  given Encoder[Meal] = deriveEncoder

object AddMeal:
  given Decoder[AddMeal] = deriveDecoder
